package com.culturecloud.service.local.impl.common;

import java.util.Date;
import java.util.List;
import java.util.Set;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.coreutils.UUIDUtils;
import com.culturecloud.dao.common.CmsTerminalUserMapper;
import com.culturecloud.dao.common.SysUserIntegralDetailMapper;
import com.culturecloud.dao.common.SysUserIntegralMapper;
import com.culturecloud.dao.dto.common.CmsTerminalUserDto;
import com.culturecloud.dao.dto.common.SysUserIntegralDto;
import com.culturecloud.enumeration.common.IntegralTypeEnum;
import com.culturecloud.enumeration.redis.IntegralRedisKeyEnum;
import com.culturecloud.exception.BizException;
import com.culturecloud.model.bean.common.SysUserIntegral;
import com.culturecloud.model.bean.common.SysUserIntegralDetail;
import com.culturecloud.redis.RedisDAO;
import com.culturecloud.service.local.common.SysUserIntegralService;
import com.culturecloud.util.redis.ListTranscoder;
import com.sun3d.why.redis.vo.UserIntergralRedisVO;

@Transactional
@Service
public class SysUserIntegralServiceImpl implements SysUserIntegralService {
	
	
	@Autowired
	private CmsTerminalUserMapper cmsTerminalUserMapper;
	
	@Autowired
	private SysUserIntegralMapper sysUserIntegralMapper;
	
	@Autowired
	private SysUserIntegralDetailMapper sysUserIntegralDetailMapper;
	
	@Resource
	private RedisDAO<String> redisDAO;

	@Override
	public int insertUserIntegral(String userId, Integer integralChange,Integer changeType, String integralFrom,
			Integer integralType) {
		
		
		SysUserIntegral userIntegral= this.getUserIntegralByUserId(userId);
		
		if(userIntegral==null)
			
			new BizException(new RuntimeException(),"用户信息不存在！");
		
		int result=this.updateUserNowIntegral(userIntegral, integralChange);
		
		if(result>0)
		{
			SysUserIntegralDetail userIntegralDetail = new SysUserIntegralDetail();
			userIntegralDetail.setIntegralDetailId(UUIDUtils.createUUId());
			userIntegralDetail.setCreateTime(new Date());
			userIntegralDetail.setIntegralId(userIntegral.getIntegralId());
			userIntegralDetail.setIntegralChange(integralChange);
			userIntegralDetail.setChangeType(changeType);
			userIntegralDetail.setIntegralFrom(integralFrom);
			userIntegralDetail.setIntegralType(integralType);
			return sysUserIntegralDetailMapper.insertSelective(userIntegralDetail);
		}
		
		
		return 0;
	}
	
	/**
	 * 修改当前积分 
	 * @param userIntegral
	 * @param integralChange
	 * @return
	 */
	private int updateUserNowIntegral(SysUserIntegral userIntegral,int integralChange){

		Integer integralNow=userIntegral.getIntegralNow();
		
		Integer integralHis=userIntegral.getIntegralHis();
		
		integralNow+=integralChange;
		
		userIntegral.setIntegralNow(integralNow);
		
		if(integralChange>0)
		{
			integralHis+=integralChange;
			
			userIntegral.setIntegralHis(integralHis);
		}
		
		return this.sysUserIntegralMapper.updateByPrimaryKeySelective(userIntegral);
	}

	@Override
	public SysUserIntegral getUserIntegralByUserId(String userId) {

		
		CmsTerminalUserDto user=cmsTerminalUserMapper.queryTerminalUserById(userId);
		
		if(user==null)
			return null;
			
		SysUserIntegralDto userIntegral= sysUserIntegralMapper.selectUserIntegralByUserId(userId);
		
		if(userIntegral!=null)
		{
			return userIntegral;
		}
		else
		{
			SysUserIntegral newIntegral=new SysUserIntegral();
			
			newIntegral.setUserId(userId);
			newIntegral.setIntegralId(UUIDUtils.createUUId());
			newIntegral.setIntegralNow(0);
			newIntegral.setIntegralHis(0);
        	
			sysUserIntegralMapper.insert(newIntegral);
			
			return newIntegral;
		}
	}

	@Override
	public int checkDayIntegral(String userId) {

		int result=0;

		// 本周结束日期
		String weekEndDate=IntegralRedisKeyEnum.getEndOfThisWeek();
		
		// 本周登录 userId set 集合
		String weekLoginKey=IntegralRedisKeyEnum.getWeekLoginSetKey(weekEndDate);
		
		// 判断本周登陆集合里是否存在 userID
//		if(!jedis.sismember(weekLoginKey, userId))
		if(!redisDAO.isMember(weekLoginKey, userId))
		{
			// 集合中插入useID
			//jedis.sadd(weekLoginKey, userId); 
			
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
	
	
	private int everyDayOpenAddIntegral(String userId) {

		// 积分数
		int integralChange=10;

		// 0:增加、1:扣除
		int changeType=0;
		
		// 积分类型
		int type=IntegralTypeEnum.EVERYDAY.getIndex();

		SysUserIntegral userIntegral=this.getUserIntegralByUserId(userId);
		
		if(userIntegral==null)
			return 0;
		
		List<SysUserIntegralDetail> userIntegralDetailList=sysUserIntegralDetailMapper.queryUserTodayLoginIntegralDetail(userIntegral.getIntegralId());
		
		if(userIntegralDetailList.size()>0)
			return 0;
		
		int result=this.updateUserNowIntegral(userIntegral, integralChange);
		
		if(result>0)
		{
			SysUserIntegralDetail userIntegralDetail = new SysUserIntegralDetail();
			userIntegralDetail.setIntegralDetailId(UUIDUtils.createUUId());
			userIntegralDetail.setCreateTime(new Date());
			userIntegralDetail.setIntegralId(userIntegral.getIntegralId());
			userIntegralDetail.setIntegralChange(integralChange);
			userIntegralDetail.setChangeType(changeType);
			userIntegralDetail.setIntegralFrom("每日登录奖励  用户ID："+userId);
			userIntegralDetail.setIntegralType(type);
			return sysUserIntegralDetailMapper.insertSelective(userIntegralDetail);
		}				
		
		return 0;
	}

}
