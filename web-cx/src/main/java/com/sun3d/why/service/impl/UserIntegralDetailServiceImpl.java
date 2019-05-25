package com.sun3d.why.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.culturecloud.enumeration.common.IntegralTypeEnum;
import com.culturecloud.model.bean.live.CcpLiveMessage;
import com.culturecloud.model.response.contest.QuestionShareInfoVO;
import com.sun3d.why.dao.CmsTerminalUserMapper;
import com.sun3d.why.dao.UserIntegralDetailMapper;
import com.sun3d.why.dao.UserIntegralMapper;
import com.sun3d.why.enumeration.redis.IntegralRedisKeyEnum;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.UserIntegral;
import com.sun3d.why.model.UserIntegralDetail;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.redis.RedisDAO;
import com.sun3d.why.redis.vo.UserIntergralRedisVO;
import com.sun3d.why.service.UserIntegralDetailService;
import com.sun3d.why.service.UserIntegralService;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.util.redis.ListTranscoder;
import com.sun3d.why.webservice.api.util.HttpClientConnection;
import com.sun3d.why.webservice.api.util.HttpResponseText;

@Service
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
	 
	 @Autowired
	 private CmsTerminalUserMapper cmsTerminalUserMapper;
	 
	 @Resource
	private RedisDAO<String> redisDAO;
	    
	

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
		// 积分数1200 改动 2016 10 11
		int integralChange=1200;

		// 0:增加、1:扣除
		int changeType=0;
		
		// 积分类型
		int type=IntegralTypeEnum.REGISTER.getIndex();

		UserIntegral userIntegral=userIntegralService.selectUserIntegralByUserId(userId);
		
		if(userIntegral==null)
		{
			System.out.println("*********用户"+userId+"插入userIntegral失败！！**************");
			return 0;
		}
		
		Map<String,Object>map=new HashMap<String,Object>();
		map.put("integralId", userIntegral.getIntegralId());
		map.put("integralType", type);
		
		List<UserIntegralDetail> details=userIntegralDetailMapper.queryUserIntegralDetail(map);
		
		if(details.size()>0)
			return 0;
			
		CmsTerminalUser cmsTerminalUser=cmsTerminalUserMapper.queryTerminalUserById(userId);
		
		int result=this.updateUserNowIntegral(userIntegral, integralChange);
		
		if(result>0)
		{
			UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
			userIntegralDetail.setIntegralDetailId(UUIDUtils.createUUId());
			userIntegralDetail.setCreateTime(cmsTerminalUser.getCreateTime());
			userIntegralDetail.setIntegralId(userIntegral.getIntegralId());
			userIntegralDetail.setIntegralChange(integralChange);
			userIntegralDetail.setChangeType(changeType);
			userIntegralDetail.setIntegralFrom("新用户注册奖励积分 用户ID："+userId);
			userIntegralDetail.setIntegralType(type);
			int ud=userIntegralDetailMapper.insertSelective(userIntegralDetail);
			
			if(ud==0){
				System.out.println("*********用户"+userId+"插入注册添加积分失败！！**************");
			}
			
			this.checkDayIntegral(userId);
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

		
		try {
			
			
			// 本周结束日期
			String weekEndDate=IntegralRedisKeyEnum.getEndOfThisWeek();
			// 今日日期
			String today=IntegralRedisKeyEnum.getToday();
			
			// 用户积分记录 缓存 key
			String userIntegralModelKey=IntegralRedisKeyEnum.getUserIntegralModelKey(userId, weekEndDate);
			
			byte[] bytes=userIntegralModelKey.getBytes();
			
			// 获取积分缓存对象
			UserIntergralRedisVO userIntergralRedisVO=(UserIntergralRedisVO) ListTranscoder.deserialize(	redisDAO.getData(bytes));
			
			 Map<String, Integer> commentMap=userIntergralRedisVO.getCommentDateMap();
			 
			 Integer sum=commentMap.get(today);
				 
			commentMap.put(today, sum-integralChange);
				
			 
			redisDAO.save(bytes, ListTranscoder.serialize(userIntergralRedisVO));
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			
		}
		
		return result;
	}
	
	private boolean checkCommentAddIntegral(String userId, String commentId,int integralChange){
		
		boolean result=true;
		
		try {
			// 本周结束日期
			String weekEndDate=IntegralRedisKeyEnum.getEndOfThisWeek();
			// 今日日期
			String today=IntegralRedisKeyEnum.getToday();
			
			// 用户积分记录 缓存 key
			String userIntegralModelKey=IntegralRedisKeyEnum.getUserIntegralModelKey(userId, weekEndDate);
			
			byte[] bytes=userIntegralModelKey.getBytes();
			
			// 获取积分缓存对象
			UserIntergralRedisVO userIntergralRedisVO=(UserIntergralRedisVO) ListTranscoder.deserialize(	redisDAO.getData(bytes));
			
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
			 
			 redisDAO.save(bytes, ListTranscoder.serialize(userIntergralRedisVO));
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			
			
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
		try {
			
			
			// 本周结束日期
			String weekEndDate=IntegralRedisKeyEnum.getEndOfThisWeek();
			// 今日日期
			String today=IntegralRedisKeyEnum.getToday();
			
			// 用户积分记录 缓存 key
			String userIntegralModelKey=IntegralRedisKeyEnum.getUserIntegralModelKey(userId, weekEndDate);
			
			byte[] bytes=userIntegralModelKey.getBytes();
			
			// 获取积分缓存对象
			UserIntergralRedisVO userIntergralRedisVO=(UserIntergralRedisVO) ListTranscoder.deserialize(	redisDAO.getData(bytes));
			
			Map<String,Set<String>> forwardDateMap=userIntergralRedisVO.getForwardDateMap();
			 
			
			 Set<String> urlSet=forwardDateMap.get(today);
				 
			 urlSet.remove(url);
			 
			 redisDAO.save(bytes, ListTranscoder.serialize(userIntergralRedisVO));
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
		}
		
		return result;
		
	}
	
	private boolean checkForwardAddIntegral(String userId, String url){
		
		boolean result=true;
		
		
		try {
			
			
			// 本周结束日期
			String weekEndDate=IntegralRedisKeyEnum.getEndOfThisWeek();
			// 今日日期
			String today=IntegralRedisKeyEnum.getToday();
			
			// 用户积分记录 缓存 key
			String userIntegralModelKey=IntegralRedisKeyEnum.getUserIntegralModelKey(userId, weekEndDate);
			
			byte[] bytes=userIntegralModelKey.getBytes();
			
			// 获取积分缓存对象
			UserIntergralRedisVO userIntergralRedisVO=(UserIntergralRedisVO) ListTranscoder.deserialize(	redisDAO.getData(bytes));
			
			Map<String,Set<String>> forwardDateMap=userIntergralRedisVO.getForwardDateMap();
			 
			 if(forwardDateMap.containsKey(today))
			 {
				 Set<String> urlSet=forwardDateMap.get(today);
				 
				 if(urlSet.size()>=10 || urlSet.contains(url))
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
			
			 
			 redisDAO.save(bytes, ListTranscoder.serialize(userIntergralRedisVO));
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			
		
		}
		
		return result;
		
	}


	@Override
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

	@Override
	public int checkDayIntegral(String userId) {
		int result=0;

		// 本周结束日期
		String weekEndDate=IntegralRedisKeyEnum.getEndOfThisWeek();
		
		// 本周登录 userId set 集合
		String weekLoginKey=IntegralRedisKeyEnum.getWeekLoginSetKey(weekEndDate);
		
		// 判断本周登陆集合里是否存在 userID
		if(!redisDAO.isMember(weekLoginKey, userId))
		{
			// 集合中插入useID
			redisDAO.saveSet(weekLoginKey, userId); 
		}
		
		// 用户积分记录 缓存 key
		String userIntegralModelKey=IntegralRedisKeyEnum.getUserIntegralModelKey(userId, weekEndDate);
		
		byte[] bytes=userIntegralModelKey.getBytes();
		
		// 获取积分缓存对象
		UserIntergralRedisVO userIntergralRedisVO=(UserIntergralRedisVO) ListTranscoder.deserialize(redisDAO.getData(bytes));
		
		if(userIntergralRedisVO==null)
			userIntergralRedisVO=new UserIntergralRedisVO();
		
		// 今日日期
		String today=IntegralRedisKeyEnum.getToday();
		
		Set<String> accessDateSet=userIntergralRedisVO.getAccessDateSet();
		
		// 判断今天是否登录过
		if(!accessDateSet.contains(today))
		{
			// 插入积分信息
			 result=this.everyDayOpenAddIntegral(userId);
				if(result>0)
				{
					accessDateSet.add(today);
					redisDAO.save(bytes, ListTranscoder.serialize(userIntergralRedisVO));
				}
		}
		return result;
	}
	
	@Override
	public int liveLikeAddIntegral(String userId, String liveActivityId) {
		
		UserIntegral userIntegral=userIntegralService.selectUserIntegralByUserId(userId);
		
		if(userIntegral==null)
			return 0;
		
		int integralChange=5;
		
		// 本周结束日期
		String weekEndDate=IntegralRedisKeyEnum.getEndOfThisWeek();
		// 今日日期
		String today=IntegralRedisKeyEnum.getToday();
		
		// 用户积分记录 缓存 key
		String userIntegralModelKey=IntegralRedisKeyEnum.getUserIntegralModelKey(userId, weekEndDate);
		
		byte[] bytes=userIntegralModelKey.getBytes();
		
		// 获取积分缓存对象
		UserIntergralRedisVO userIntergralRedisVO=(UserIntergralRedisVO) ListTranscoder.deserialize(	redisDAO.getData(bytes));
		
		if(userIntergralRedisVO==null)
			userIntergralRedisVO=new UserIntergralRedisVO();
		
		 Map<String, Integer> LiveMap=userIntergralRedisVO.getLiveLikeDateMap();
		 
		 if(LiveMap==null)
			 LiveMap=new HashMap<String, Integer>();
		
		if(LiveMap.containsKey(today))
		 {
			 Integer sum=LiveMap.get(today);
			 
			 if(sum>=100){
				
				 return 0;
			}
			 else
			 {
				 LiveMap.put(today, sum+integralChange);
			 }
				 
		 }else
			 LiveMap.put(today, integralChange);
		
		userIntergralRedisVO.setLiveLikeDateMap(LiveMap);;
		
		Map<String,Object> data = new HashMap<String,Object>();
		data.put("integralType", IntegralTypeEnum.LIVE_LIKE.getIndex());
		data.put("integralFrom", "直播活动点赞，直播活动id="+liveActivityId);
		data.put("integralId", userIntegral.getIntegralId());
		List<UserIntegralDetail> detailList = userIntegralDetailMapper.queryUserIntegralDetail(data);
		
		if(detailList.size()==0){
			
			int result=this.updateUserNowIntegral(userIntegral, integralChange);
			
			if(result>0)
			{
				//添加积分
				UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
				userIntegralDetail.setIntegralDetailId(UUIDUtils.createUUId());
				userIntegralDetail.setCreateTime(new Date());
				userIntegralDetail.setIntegralId(userIntegral.getIntegralId());
				userIntegralDetail.setIntegralChange(integralChange);
				userIntegralDetail.setChangeType(0);
				userIntegralDetail.setIntegralFrom("直播活动点赞，直播活动id="+liveActivityId);
				userIntegralDetail.setIntegralType(IntegralTypeEnum.LIVE_LIKE.getIndex());
				int ud=userIntegralDetailMapper.insertSelective(userIntegralDetail);
				
				if(ud>0)
					redisDAO.save(bytes, ListTranscoder.serialize(userIntergralRedisVO));
				
				return ud;
			}
		}
		
		return 1;
	}

	@Override
	@Transactional
	public int liveCommentAddIntegral(CcpLiveMessage message) {
		
		String userId=message.getMessageCreateUser();
		
		String messageImg=message.getMessageImg();
		
		String liveActivityId=message.getMessageActivity();

		UserIntegral userIntegral=userIntegralService.selectUserIntegralByUserId(userId);
		
		if(userIntegral==null)
			return 0;
		
		int integralChange=5;
		
		int integralType=IntegralTypeEnum.LIVE_COMMENT.getIndex();

		if(StringUtils.isNotBlank(messageImg)){
			integralChange=100;
			integralType=IntegralTypeEnum.LIVE_COMMENT_IMG.getIndex();
		}
		
		// 本周结束日期
		String weekEndDate=IntegralRedisKeyEnum.getEndOfThisWeek();
		// 今日日期
		String today=IntegralRedisKeyEnum.getToday();
		
		// 用户积分记录 缓存 key
		String userIntegralModelKey=IntegralRedisKeyEnum.getUserIntegralModelKey(userId, weekEndDate);
		
		byte[] bytes=userIntegralModelKey.getBytes();
		
		// 获取积分缓存对象
		UserIntergralRedisVO userIntergralRedisVO=(UserIntergralRedisVO) ListTranscoder.deserialize(	redisDAO.getData(bytes));
		
		if(userIntergralRedisVO==null)
			userIntergralRedisVO=new UserIntergralRedisVO();
		
		 Map<String, Integer> LiveMap=userIntergralRedisVO.getLiveCommentDateMap();
		 
		 if(LiveMap==null)
			 LiveMap=new HashMap<String, Integer>();
			 
		if(LiveMap.containsKey(today))
		 {
			 Integer sum=LiveMap.get(today);
			 
			 if(sum>=500){
				
				 return 0;
			}
			 else
			 {
				 LiveMap.put(today, sum+integralChange);
			 }
				 
		 }else{
			 LiveMap.put(today, integralChange);
		 }
		
		userIntergralRedisVO.setLiveCommentDateMap(LiveMap);
		
		int result=this.updateUserNowIntegral(userIntegral, integralChange);
		
		if(result>0)
		{
			//添加积分
			UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
			userIntegralDetail.setIntegralDetailId(UUIDUtils.createUUId());
			userIntegralDetail.setCreateTime(new Date());
			userIntegralDetail.setIntegralId(userIntegral.getIntegralId());
			userIntegralDetail.setIntegralChange(integralChange);
			userIntegralDetail.setChangeType(0);
			userIntegralDetail.setIntegralFrom("直播活动评论加积分，直播活动id="+liveActivityId);
			userIntegralDetail.setIntegralType(integralType);
			int ud=userIntegralDetailMapper.insertSelective(userIntegralDetail);
			
			if(ud>0){
				
				redisDAO.save(bytes, ListTranscoder.serialize(userIntergralRedisVO));
				
				return integralChange;
			}
				
		}
		
		return 0;
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
	public String updateIntegralByVo(UserIntegralDetail vo) {
    	String json = "";
		try {
			if (vo != null && vo.getUserId() != null) {
				UserIntegral userIntegral=userIntegralService.selectUserIntegralByUserId(vo.getUserId());
				if(userIntegral!=null){
					List<UserIntegralDetail> detailList = new ArrayList<UserIntegralDetail>();
					if(vo.getUpdateType() == 1){
						Map<String,Object> data = new HashMap<String,Object>();
						data.put("integralType", vo.getIntegralType());
						data.put("integralFrom", vo.getIntegralFrom());
						data.put("integralId", userIntegral.getIntegralId());
						detailList = userIntegralDetailMapper.queryUserIntegralDetail(data);
					}
					if((vo.getUpdateType()==1&&detailList.size()==0)||vo.getUpdateType()==0){
						int result = this.updateUserNowIntegral(userIntegral, vo.getIntegralChange());
						if(result>0){
							UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
							userIntegralDetail.setIntegralDetailId(UUIDUtils.createUUId());
							userIntegralDetail.setCreateTime(new Date());
							userIntegralDetail.setIntegralId(userIntegral.getIntegralId());
							userIntegralDetail.setIntegralChange(vo.getIntegralChange());
							userIntegralDetail.setChangeType(vo.getChangeType());
							userIntegralDetail.setIntegralFrom(vo.getIntegralFrom());
							userIntegralDetail.setIntegralType(vo.getIntegralType());
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
