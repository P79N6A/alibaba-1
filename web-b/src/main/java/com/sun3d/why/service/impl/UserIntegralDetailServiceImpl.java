package com.sun3d.why.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.enumeration.common.IntegralTypeEnum;
import com.culturecloud.model.bean.live.CcpLiveMessage;
import com.sun3d.why.dao.UserIntegralDetailMapper;
import com.sun3d.why.dao.UserIntegralMapper;
import com.sun3d.why.enumeration.redis.IntegralRedisKeyEnum;
import com.sun3d.why.model.UserIntegral;
import com.sun3d.why.model.UserIntegralDetail;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.redis.vo.UserIntergralRedisVO;
import com.sun3d.why.service.UserIntegralDetailService;
import com.sun3d.why.service.UserIntegralService;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.util.redis.ListTranscoder;

import redis.clients.jedis.HostAndPort;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisSentinelPool;

@Service
@Transactional
public class UserIntegralDetailServiceImpl implements UserIntegralDetailService{
	
	private Logger logger = Logger.getLogger(this.getClass());

	@Autowired
	private UserIntegralDetailMapper userIntegralDetailMapper;
	
	@Autowired
	private UserIntegralMapper userIntegralMapper;
	
	@Autowired
	private UserIntegralService userIntegralService;
	
	 @Autowired
	private StaticServer staticServer;
	    
	

	@Override
	public int deleteUserIntegralDetailById(String integralDetailId) {
		// TODO Auto-generated method stub
		return userIntegralDetailMapper.deleteByPrimaryKey(integralDetailId);
	}

	@Override
	public int addUserIntegralDetail(UserIntegralDetail record) {
		// TODO Auto-generated method stub
		return userIntegralDetailMapper.insert(record);
	}

	@Override
	public UserIntegralDetail selectUserIntegralDetailById(String integralDetailId) {
		// TODO Auto-generated method stub
		return userIntegralDetailMapper.selectByPrimaryKey(integralDetailId);
	}

	@Override
	public int updateUserIntegralDetail(UserIntegralDetail record) {
		// TODO Auto-generated method stub
		return userIntegralDetailMapper.updateByPrimaryKey(record);
	}

	@Override
	public List<UserIntegralDetail> queryUserIntegralDetailByIntegralId(String integralId, Pagination page) {
		// TODO Auto-generated method stub
		if(integralId!=null&&!integralId.trim().equals(""))
		{
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("integralId", integralId);
			
			//分页
            if (page != null && page.getFirstResult() != null && page.getRows() != null) {
                map.put("firstResult", page.getFirstResult());
                map.put("rows", page.getRows());
                int total = userIntegralDetailMapper.queryUserIntegralDetailCountByIntegralId(map);
                page.setTotal(total);
            }
            
            return userIntegralDetailMapper.queryUserIntegralDetailByIntegralId(map);
		}
		return null;
	}

	@Override
	public int registerAddIntegral(String userId) {
		
		// 积分数200
		int integralChange=200;

		// 0:增加、1:扣除
		int changeType=0;
		
		// 积分类型
		int type=IntegralTypeEnum.REGISTER.getIndex();

		UserIntegral userIntegral=userIntegralService.selectUserIntegralByUserId(userId);
		
		if(userIntegral==null)
			return 0;
		
		int result=this.updateUserNowIntegral(userIntegral, integralChange);
		
		if(result>0)
		{
			UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
			userIntegralDetail.setIntegralDetailId(UUIDUtils.createUUId());
			userIntegralDetail.setCreateTime(new Date());
			userIntegralDetail.setIntegralId(userIntegral.getIntegralId());
			userIntegralDetail.setIntegralChange(integralChange);
			userIntegralDetail.setChangeType(changeType);
			userIntegralDetail.setIntegralFrom("新用户注册奖励积分 用户ID："+userId);
			userIntegralDetail.setIntegralType(type);
			return userIntegralDetailMapper.insertSelective(userIntegralDetail);
		}
		
		return 0;
	}

	@Override
	public int commentAddIntegral(String userId, String commentId) {
		
		// 积分数
		int integralChange=5;

		// 0:增加、1:扣除
		int changeType=0;
		
		if(!this.checkCommentAddIntegral(userId, commentId, integralChange))
		
			return 0;
		
		try {
			
			
			// 积分类型
			int type=IntegralTypeEnum.COMMENT.getIndex();

			UserIntegral userIntegral=userIntegralService.selectUserIntegralByUserId(userId);
			
			if(userIntegral==null)
			{
				return 0;
			}
			
			int result=this.updateUserNowIntegral(userIntegral, integralChange);
			
			if(result>0)
			{
				UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
				userIntegralDetail.setIntegralDetailId(UUIDUtils.createUUId());
				userIntegralDetail.setCreateTime(new Date());
				userIntegralDetail.setIntegralId(userIntegral.getIntegralId());
				userIntegralDetail.setIntegralChange(integralChange);
				userIntegralDetail.setChangeType(changeType);
				userIntegralDetail.setIntegralFrom("成功评论 奖励积分 积分ID："+commentId);
				userIntegralDetail.setIntegralType(type);
				
				result=userIntegralDetailMapper.insertSelective(userIntegralDetail);
				
				return result;
			}
			
		} catch (Exception e) {
			
			this.rollbackCommentAddIntegral(userId, commentId, integralChange);
			
			e.printStackTrace();
		}
		
		return 0;
	}
	
	private boolean rollbackCommentAddIntegral(String userId, String commentId,int integralChange){
		
		boolean result=true;
		
		JedisSentinelPool sentinelPool = null;
		Jedis jedis = null;
		
		try {
			
			sentinelPool = getJedisSentinelPool();
	         jedis = sentinelPool.getResource();
	         if (!jedis.isConnected()) {
	             jedis.connect();
	         }
			
			// 本周结束日期
			String weekEndDate=IntegralRedisKeyEnum.getEndOfThisWeek();
			// 今日日期
			String today=IntegralRedisKeyEnum.getToday();
			
			// 用户积分记录 缓存 key
			String userIntegralModelKey=IntegralRedisKeyEnum.getUserIntegralModelKey(userId, weekEndDate);
			
			byte[] bytes=userIntegralModelKey.getBytes();
			
			// 获取积分缓存对象
			UserIntergralRedisVO userIntergralRedisVO=(UserIntergralRedisVO) ListTranscoder.deserialize(	jedis.get(bytes));
			
			 Map<String, Integer> commentMap=userIntergralRedisVO.getCommentDateMap();
			 
			 Integer sum=commentMap.get(today);
				 
			commentMap.put(today, sum-integralChange);
				
			 
			 jedis.set(bytes, ListTranscoder.serialize(userIntergralRedisVO));
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			
			if(jedis!=null){
				jedis.close();
			}
			
			if(sentinelPool!=null){
				   sentinelPool.destroy();
			}
		}
		
		return result;
	}
	
	private boolean checkCommentAddIntegral(String userId, String commentId,int integralChange){
		
		boolean result=true;
		
		JedisSentinelPool sentinelPool = null;
		Jedis jedis = null;
		
		try {
			
			 sentinelPool = getJedisSentinelPool();
	         jedis = sentinelPool.getResource();
	         if (!jedis.isConnected()) {
	             jedis.connect();
	         }
			
			// 本周结束日期
			String weekEndDate=IntegralRedisKeyEnum.getEndOfThisWeek();
			// 今日日期
			String today=IntegralRedisKeyEnum.getToday();
			
			// 用户积分记录 缓存 key
			String userIntegralModelKey=IntegralRedisKeyEnum.getUserIntegralModelKey(userId, weekEndDate);
			
			byte[] bytes=userIntegralModelKey.getBytes();
			
			// 获取积分缓存对象
			UserIntergralRedisVO userIntergralRedisVO=(UserIntergralRedisVO) ListTranscoder.deserialize(	jedis.get(bytes));
			
			 Map<String, Integer> commentMap=userIntergralRedisVO.getCommentDateMap();
			 
			 if(commentMap.containsKey(today))
			 {
				 Integer sum=commentMap.get(today);
				 
				 if(sum>=100)
					return false; 
				 else
				 {
					 commentMap.put(today, sum+integralChange);
				 }
					 
			 }else
				 commentMap.put(today, integralChange);
			 
			 jedis.set(bytes, ListTranscoder.serialize(userIntergralRedisVO));
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			
			if(jedis!=null){
				jedis.close();
			}
			
			if(sentinelPool!=null){
				   sentinelPool.destroy();
			}
		}
		
		return result;
		
	}
	
	@Override
	public int commentDeleteIntegral(String userId, String commentId) {

		// 积分数
		int integralChange=-5;

		// 0:增加、1:扣除
		int changeType=1;
		
		// 积分类型
		int type=IntegralTypeEnum.COMMENT_DELETE.getIndex();

		UserIntegral userIntegral=userIntegralService.selectUserIntegralByUserId(userId);
		
		int result=this.updateUserNowIntegral(userIntegral, integralChange);
		
		if(result>0)
		{
			UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
			userIntegralDetail.setIntegralDetailId(UUIDUtils.createUUId());
			userIntegralDetail.setCreateTime(new Date());
			userIntegralDetail.setIntegralId(userIntegral.getIntegralId());
			userIntegralDetail.setIntegralChange(Math.abs(integralChange));
			userIntegralDetail.setChangeType(changeType);
			userIntegralDetail.setIntegralFrom("删除评论 扣除积分 评论ID："+commentId);
			userIntegralDetail.setIntegralType(type);
			return userIntegralDetailMapper.insertSelective(userIntegralDetail);
		}		
		
		return 0;
	}
	
	@Override
	public int forwardAddIntegral(String userId, String url) {

		// 积分数
		int integralChange=10;
		
		if(!this.checkForwardAddIntegral(userId, url)){
			
			return 0;
		}

		// 0:增加、1:扣除
		int changeType=0;
		
		// 积分类型
		int type=IntegralTypeEnum.FORWARDING.getIndex();
		
		try {
			
			UserIntegral userIntegral=userIntegralService.selectUserIntegralByUserId(userId);
			
			if(userIntegral==null)
			{
				return 0;
			}
			
			int result=this.updateUserNowIntegral(userIntegral, integralChange);
			
			if(result>0)
			{
				UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
				userIntegralDetail.setIntegralDetailId(UUIDUtils.createUUId());
				userIntegralDetail.setCreateTime(new Date());
				userIntegralDetail.setIntegralId(userIntegral.getIntegralId());
				userIntegralDetail.setIntegralChange(integralChange);
				userIntegralDetail.setChangeType(changeType);
				userIntegralDetail.setIntegralFrom("转发页面奖励 转发页面:"+url);
				userIntegralDetail.setIntegralType(type);
				result= userIntegralDetailMapper.insertSelective(userIntegralDetail);
				
				return result;
			}				
			
			
		} catch (Exception e) {
			
			this.rollbackForwardAddIntegral(userId, url);
			
			e.printStackTrace();
		}

		
				
		return 0;
	}
	
	private boolean rollbackForwardAddIntegral(String userId, String url){
		
		boolean result=true;
		
		JedisSentinelPool sentinelPool = null;
		Jedis jedis = null;
		
		try {
			
			sentinelPool = getJedisSentinelPool();
	         jedis = sentinelPool.getResource();
	         if (!jedis.isConnected()) {
	             jedis.connect();
	         }
			
			// 本周结束日期
			String weekEndDate=IntegralRedisKeyEnum.getEndOfThisWeek();
			// 今日日期
			String today=IntegralRedisKeyEnum.getToday();
			
			// 用户积分记录 缓存 key
			String userIntegralModelKey=IntegralRedisKeyEnum.getUserIntegralModelKey(userId, weekEndDate);
			
			byte[] bytes=userIntegralModelKey.getBytes();
			
			// 获取积分缓存对象
			UserIntergralRedisVO userIntergralRedisVO=(UserIntergralRedisVO) ListTranscoder.deserialize(	jedis.get(bytes));
			
			Map<String,Set<String>> forwardDateMap=userIntergralRedisVO.getForwardDateMap();
			 
			
			 Set<String> urlSet=forwardDateMap.get(today);
				 
			 urlSet.remove(url);
			 
			 jedis.set(bytes, ListTranscoder.serialize(userIntergralRedisVO));
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			
			if(jedis!=null){
				jedis.close();
			}
			
			if(sentinelPool!=null){
				   sentinelPool.destroy();
			}
		}
		
		return result;
		
	}
	
	private boolean checkForwardAddIntegral(String userId, String url){
		
		boolean result=true;
		
		JedisSentinelPool sentinelPool = null;
		Jedis jedis = null;
		
		try {
			
			sentinelPool = getJedisSentinelPool();
	         jedis = sentinelPool.getResource();
	         if (!jedis.isConnected()) {
	             jedis.connect();
	         }
			
			// 本周结束日期
			String weekEndDate=IntegralRedisKeyEnum.getEndOfThisWeek();
			// 今日日期
			String today=IntegralRedisKeyEnum.getToday();
			
			// 用户积分记录 缓存 key
			String userIntegralModelKey=IntegralRedisKeyEnum.getUserIntegralModelKey(userId, weekEndDate);
			
			byte[] bytes=userIntegralModelKey.getBytes();
			
			// 获取积分缓存对象
			UserIntergralRedisVO userIntergralRedisVO=(UserIntergralRedisVO) ListTranscoder.deserialize(	jedis.get(bytes));
			
			Map<String,Set<String>> forwardDateMap=userIntergralRedisVO.getForwardDateMap();
			 
			 if(forwardDateMap.containsKey(today))
			 {
				 Set<String> urlSet=forwardDateMap.get(today);
				 
				 if(urlSet.size()>=10 || !urlSet.contains(url))
					return false; 
				 else
				 {
					 urlSet.add(url);
				 }
					 
			 }else
			 {
				 Set<String> urlSet=new HashSet<String>();
				 urlSet.add(url);
				 
				 forwardDateMap.put(today, urlSet);
			 }
			
			 
			 jedis.set(bytes, ListTranscoder.serialize(userIntergralRedisVO));
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			
			if(jedis!=null){
				jedis.close();
			}
			
			if(sentinelPool!=null){
				   sentinelPool.destroy();
			}
		}
		
		return result;
		
	}


	@Override
	@Transactional(isolation = Isolation.SERIALIZABLE)
	public int successVerificationAddIntegral(String userId, String orderID) {

		// 积分数
		int integralChange=50;

		// 0:增加、1:扣除
		int changeType=0;
		
		// 积分类型
		int type=IntegralTypeEnum.VERIFICATION.getIndex();

		UserIntegral userIntegral=userIntegralService.selectUserIntegralByUserId(userId);
		
		if(userIntegral==null)
			return 0;
		
		Map<String,Object> data=new HashMap<String,Object>();
		
		data.put("integralType", type);
		data.put("integralFrom", orderID);
		data.put("integralId", userIntegral.getIntegralId());
		
		List<UserIntegralDetail> detailList=userIntegralDetailMapper.queryUserIntegralDetail(data);
		
		if(detailList.size()>0)
			return 0;
		
		int result=this.updateUserNowIntegral(userIntegral, integralChange);
		
		if(result>0)
		{
			UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
			userIntegralDetail.setIntegralDetailId(UUIDUtils.createUUId());
			userIntegralDetail.setCreateTime(new Date());
			userIntegralDetail.setIntegralId(userIntegral.getIntegralId());
			userIntegralDetail.setIntegralChange(integralChange);
			userIntegralDetail.setChangeType(changeType);
			userIntegralDetail.setIntegralFrom(orderID);
			userIntegralDetail.setIntegralType(type);
			return userIntegralDetailMapper.insertSelective(userIntegralDetail);
		}		
		
		
		return 0;
	}
	

	@Override
	@Transactional(isolation = Isolation.SERIALIZABLE)
	public int timeOutNotVerificationAddIntegral(String userId, String userName,String activityId,Integer deductionCredit, String orderId,
			String orderNumer) {
		// 积分数
		int integralChange=0;
		
		integralChange-=deductionCredit;

		// 0:增加、1:扣除
		int changeType=1;
		
		// 积分类型
		int type=IntegralTypeEnum.NOT_VERIFICATION.getIndex();

		UserIntegral userIntegral=userIntegralService.selectUserIntegralByUserId(userId);
		
		if(userIntegral==null)
			return 0;
		
		Map<String,Object> data=new HashMap<String,Object>();
		
		data.put("integralType", type);
		data.put("integralFrom", orderId);
		data.put("integralId", userIntegral.getIntegralId());
		
		List<UserIntegralDetail> detailList=userIntegralDetailMapper.queryUserIntegralDetail(data);
		
		if(detailList.size()>0)
			return 0;
		
		int result=this.updateUserNowIntegral(userIntegral, integralChange);
		
		if(result>0)
		{
			UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
			userIntegralDetail.setIntegralDetailId(UUIDUtils.createUUId());
			userIntegralDetail.setCreateTime(new Date());
			userIntegralDetail.setIntegralId(userIntegral.getIntegralId());
			userIntegralDetail.setIntegralChange(Math.abs(integralChange));
			userIntegralDetail.setChangeType(changeType);
			userIntegralDetail.setIntegralFrom(orderId);
			userIntegralDetail.setIntegralType(type);
			return userIntegralDetailMapper.insertSelective(userIntegralDetail);
		}		
		
		
		return 0;		
	}

	@Override
	@Transactional(isolation = Isolation.SERIALIZABLE)
	public int everyDayOpenAddIntegral(String userId) {

		// 积分数
		int integralChange=10;

		// 0:增加、1:扣除
		int changeType=0;
		
		// 积分类型
		int type=IntegralTypeEnum.EVERYDAY.getIndex();

		UserIntegral userIntegral=userIntegralService.selectUserIntegralByUserId(userId);
		
		if(userIntegral==null)
			return 0;
		
		List<UserIntegralDetail> userIntegralDetailList=userIntegralDetailMapper.queryUserTodayLoginIntegralDetail(userIntegral.getIntegralId());
		
		if(userIntegralDetailList.size()>0)
			return 0;
		
		int result=this.updateUserNowIntegral(userIntegral, integralChange);
		
		if(result>0)
		{
			UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
			userIntegralDetail.setIntegralDetailId(UUIDUtils.createUUId());
			userIntegralDetail.setCreateTime(new Date());
			userIntegralDetail.setIntegralId(userIntegral.getIntegralId());
			userIntegralDetail.setIntegralChange(integralChange);
			userIntegralDetail.setChangeType(changeType);
			userIntegralDetail.setIntegralFrom("每日登录奖励  用户ID："+userId);
			userIntegralDetail.setIntegralType(type);
			return userIntegralDetailMapper.insertSelective(userIntegralDetail);
		}				
		
		return 0;
	}

	@Override
	@Transactional(isolation = Isolation.SERIALIZABLE)
	public int weekOpenAddIntegral(String userId,String date) {

		// 积分数
		int integralChange=50;

		// 0:增加、1:扣除
		int changeType=0;
		
		// 积分类型
		int type=IntegralTypeEnum.WEEK_OPEN.getIndex();

		UserIntegral userIntegral=userIntegralService.selectUserIntegralByUserId(userId);
		
		if(userIntegral==null)
			return 0;
		
		Map<String,Object> data=new HashMap<String,Object>();
		
		data.put("integralType", type);
		data.put("integralFrom", date);
		data.put("integralId", userIntegral.getIntegralId());
		
		List<UserIntegralDetail> detailList=userIntegralDetailMapper.queryUserIntegralDetail(data);
		
		if(detailList.size()>0)
			return 0;
		
		int result=this.updateUserNowIntegral(userIntegral, integralChange);
		
		if(result>0)
		{
			UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
			userIntegralDetail.setIntegralDetailId(UUIDUtils.createUUId());
			userIntegralDetail.setCreateTime(new Date());
			userIntegralDetail.setIntegralId(userIntegral.getIntegralId());
			userIntegralDetail.setIntegralChange(integralChange);
			userIntegralDetail.setChangeType(changeType);
			userIntegralDetail.setIntegralFrom(date);
			userIntegralDetail.setIntegralType(type);
			return userIntegralDetailMapper.insertSelective(userIntegralDetail);
		}		
		
		return 0;
	}
	
	private int updateUserNowIntegral(UserIntegral userIntegral,int integralChange){

		Integer integralNow=userIntegral.getIntegralNow();
		
		Integer integralHis=userIntegral.getIntegralHis();
		
		integralNow+=integralChange;
		
		userIntegral.setIntegralNow(integralNow);
		
		if(integralChange>0)
		{
			integralHis+=integralChange;
			
			userIntegral.setIntegralHis(integralHis);
		}
		
		return this.userIntegralMapper.updateByPrimaryKeySelective(userIntegral);
	}

	@Override
	public int saveCloudIntegral(String[] userId, UserIntegralDetail userIntegralDetail) {
		
		if(userId!=null&& userId.length>0)
		{
			
			// 0:增加、1:扣除
			int changeType=userIntegralDetail.getChangeType();
			// 积分数 
			int integralChange=userIntegralDetail.getIntegralChange();
			// 积分类型
			int integralType=IntegralTypeEnum.CLOUD_INTEGRAL.getIndex();
			
			userIntegralDetail.setIntegralType(integralType);
			
			userIntegralDetail.setCreateTime(new Date());
			
			// 如果为扣除积分 添加积分变成-N分
			if(changeType==1)
				integralChange-=integralChange*2;
			
			for (String uId : userId) {
				
				UserIntegral userIntegral=userIntegralService.selectUserIntegralByUserId(uId);
				
				if(userIntegral==null)
					continue;
				
				int result=this.updateUserNowIntegral(userIntegral, integralChange);
				
				if(result>0)
				{
					userIntegralDetail.setIntegralDetailId(UUIDUtils.createUUId());
					
					userIntegralDetail.setIntegralId(userIntegral.getIntegralId());
					
					this.userIntegralDetailMapper.insert(userIntegralDetail);
				}
				
			}
			
		}
		
		return 0;
	}

	 /**
     * 获取jedis连接池
     *
     * @return jedis连接池
     */
    private JedisSentinelPool getJedisSentinelPool() {
        try {
            String poolRedis[] = staticServer.getSentinelPool().split(";");
            if (poolRedis == null || poolRedis.length == 0) {
                return null;
            }
            Set sentinels = new HashSet();
            for (int i = 0; i < poolRedis.length; i++) {
                if (poolRedis[i] != null && poolRedis[i].length() > 0) {
                    String redisInfo[] = poolRedis[i].split(":");
                    sentinels.add(new HostAndPort(redisInfo[0], Integer.parseInt(redisInfo[1])).toString());
                }
            }
            if (CollectionUtils.isNotEmpty(sentinels)) {
                return new JedisSentinelPool("mymaster", sentinels);
            }

        } catch (Exception e) {
            logger.info("getJedisSentinelPool error ", e);
            e.printStackTrace();
        }
        return null;
    }

    @Override
	@Transactional
	public int liveCommentDeleteIntegral(CcpLiveMessage message) {
		
		String messageId=message.getMessageId();
		
		String userId=message.getMessageCreateUser();
		
		String messageImg=message.getMessageImg();
		
		String liveActivityId=message.getMessageActivity();

		UserIntegral userIntegral=userIntegralService.selectUserIntegralByUserId(userId);
		
		int result=0;
		
		if(userIntegral==null)
			return 0;
		
		int integralChange=5;

		if(StringUtils.isNotBlank(messageImg)){
			integralChange=100;
			
			 result=this.updateUserNowIntegral(userIntegral, -100);
		}
		else
			
			 result=this.updateUserNowIntegral(userIntegral, -5);
	
		
		if(result>0)
		{
			//添加积分
			UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
			userIntegralDetail.setIntegralDetailId(UUIDUtils.createUUId());
			userIntegralDetail.setCreateTime(new Date());
			userIntegralDetail.setIntegralId(userIntegral.getIntegralId());
			userIntegralDetail.setIntegralChange(integralChange);
			userIntegralDetail.setChangeType(1);
			userIntegralDetail.setIntegralFrom("直播活动删除评论扣积分，直播活动id="+liveActivityId);
			userIntegralDetail.setIntegralType(IntegralTypeEnum.LIVE_COMMENT_DELETE.getIndex());
			int ud=userIntegralDetailMapper.insertSelective(userIntegralDetail);
			
			return ud;
		}
		
		return 1;
	}

	@Override
	public String deteleIntegralByVo(UserIntegralDetail vo) {
		String json = "";
		try {
			if (vo != null && vo.getUserId() != null) {
				UserIntegral userIntegral=userIntegralService.selectUserIntegralByUserId(vo.getUserId());
				if(userIntegral!=null){
					List<UserIntegralDetail> detailList = new ArrayList<UserIntegralDetail>();
					Map<String,Object> data = new HashMap<String,Object>();
					data.put("integralType", vo.getIntegralType());
					data.put("integralFrom", vo.getIntegralFrom());
					data.put("integralId", userIntegral.getIntegralId());
					detailList = userIntegralDetailMapper.queryUserIntegralDetail(data);
					
					if(detailList.size()>0){
						userIntegral.setIntegralNow(userIntegral.getIntegralNow() - vo.getIntegralChange());
						int result = userIntegralMapper.updateByPrimaryKeySelective(userIntegral);
						if(result>0){
							if(vo.getUpdateType() == 1){
								detailList.get(0).setIntegralFrom("(已扣)"+vo.getIntegralFrom());
								userIntegralDetailMapper.updateByPrimaryKeySelective(detailList.get(0));
							}
							
							UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
							userIntegralDetail.setIntegralDetailId(UUIDUtils.createUUId());
							userIntegralDetail.setCreateTime(new Date());
							userIntegralDetail.setIntegralId(userIntegral.getIntegralId());
							userIntegralDetail.setIntegralChange(vo.getIntegralChange());
							userIntegralDetail.setChangeType(1);
							userIntegralDetail.setIntegralFrom(vo.getIntegralFrom());
							userIntegralDetail.setIntegralType(IntegralTypeEnum.DELETE_INTEGRAL.getIndex());
							userIntegralDetailMapper.insertSelective(userIntegralDetail);
						}
					}
					json = JSONResponse.toAppResultFormat(200, "success");
				}else{
					json = JSONResponse.toAppResultFormat(500, "userIntegral不存在");
				}
			} else {
				json = JSONResponse.toAppResultFormat(500, "参数缺失");
			}
		} catch (Exception e) {
			e.printStackTrace();
			json = JSONResponse.toAppResultFormat(500, "false");
		}
		return json;
	}
	
}
