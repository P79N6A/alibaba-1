package com.culturecloud.service.local.impl.common;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.bean.UserIntegralDetail;
import com.culturecloud.coreutils.UUIDUtils;
import com.culturecloud.dao.common.SysUserIntegralDetailMapper;
import com.culturecloud.dao.common.SysUserIntegralMapper;
import com.culturecloud.dao.dto.common.SysUserIntegralDetailDto;
import com.culturecloud.enumeration.common.IntegralTypeEnum;
import com.culturecloud.model.bean.common.SysUserIntegral;
import com.culturecloud.model.bean.common.SysUserIntegralDetail;
import com.culturecloud.service.local.common.SysUserIntegralDetailService;
import com.culturecloud.service.local.common.SysUserIntegralService;
import com.culturecloud.util.HttpClientConnection;
import com.culturecloud.util.HttpResponseText;
import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;

@Transactional
@Service
public class SysUserIntegralDetailServiceImpl implements SysUserIntegralDetailService {

	@Autowired
	private SysUserIntegralService sysUserIntegralService;
	
	@Autowired
	private SysUserIntegralDetailMapper sysUserIntegralDetailMapper;
	
	@Autowired
	private SysUserIntegralMapper sysUserIntegralMapper;
	
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

		SysUserIntegral SysUserIntegral=sysUserIntegralService.getUserIntegralByUserId(userId);
		
		if(SysUserIntegral==null)
		{
			return 0;
		}
			
		else
		{
			UserIntegralDetail userIntegralDetail = new UserIntegralDetail();
			userIntegralDetail.setIntegralChange(deductionCredit);
			userIntegralDetail.setChangeType(changeType);
			userIntegralDetail.setIntegralFrom("放鸽子惩罚"+orderId);
			userIntegralDetail.setIntegralType(type);
			userIntegralDetail.setUserId(userId);
			userIntegralDetail.setUpdateType(1);
			userIntegralDetail.setIntegralId(SysUserIntegral.getIntegralId());
			HttpResponseText res = HttpClientConnection.post("http://china.wenhuayun.cn/chinaIntegral/updateIntegralByJson.do", (JSONObject)JSON.toJSON(userIntegralDetail));
			return 1;	
		}
		
//		Map<String,Object> data=new HashMap<String,Object>();
//		
//		data.put("integralType", type);
//		data.put("integralFrom", orderId);
//		data.put("integralId", SysUserIntegral.getIntegralId());
//		
//		List<SysUserIntegralDetailDto> detailList=sysUserIntegralDetailMapper.queryUserIntegralDetail(data);
//		
//		if(detailList.size()>0)
//			return 0;
		
		
		
		
//		int result=this.updateUserNowIntegral(SysUserIntegral, integralChange);
//		
//		if(result>0)
//		{
//			SysUserIntegralDetail SysUserIntegralDetail = new SysUserIntegralDetail();
//			SysUserIntegralDetail.setIntegralDetailId(UUIDUtils.createUUId());
//			SysUserIntegralDetail.setCreateTime(new Date());
//			SysUserIntegralDetail.setIntegralId(SysUserIntegral.getIntegralId());
//			SysUserIntegralDetail.setIntegralChange(Math.abs(integralChange));
//			SysUserIntegralDetail.setChangeType(changeType);
//			SysUserIntegralDetail.setIntegralFrom(orderId);
//			SysUserIntegralDetail.setIntegralType(type);
//			return sysUserIntegralDetailMapper.insertSelective(SysUserIntegralDetail);
//		}		
		
		
			
	}

	

	@Override
	//@Transactional(isolation = Isolation.SERIALIZABLE)
	public int weekOpenAddIntegral(String userId,String date) {

		// 积分数
		int integralChange=50;

		// 0:增加、1:扣除
		int changeType=0;
		
		// 积分类型
		int type=IntegralTypeEnum.WEEK_OPEN.getIndex();

		SysUserIntegral SysUserIntegral=sysUserIntegralService.getUserIntegralByUserId(userId);
		
		if(SysUserIntegral==null)
			return 0;
		
		Map<String,Object> data=new HashMap<String,Object>();
		
		data.put("integralType", type);
		data.put("integralFrom", date);
		data.put("integralId", SysUserIntegral.getIntegralId());
		
		List<SysUserIntegralDetailDto> detailList=sysUserIntegralDetailMapper.queryUserIntegralDetail(data);
		
		if(detailList.size()>0)
			return 0;
		
		int result=this.updateUserNowIntegral(SysUserIntegral, integralChange);
		
		if(result>0)
		{
			SysUserIntegralDetail SysUserIntegralDetail = new SysUserIntegralDetail();
			SysUserIntegralDetail.setIntegralDetailId(UUIDUtils.createUUId());
			SysUserIntegralDetail.setCreateTime(new Date());
			SysUserIntegralDetail.setIntegralId(SysUserIntegral.getIntegralId());
			SysUserIntegralDetail.setIntegralChange(integralChange);
			SysUserIntegralDetail.setChangeType(changeType);
			SysUserIntegralDetail.setIntegralFrom(date);
			SysUserIntegralDetail.setIntegralType(type);
			return sysUserIntegralDetailMapper.insertSelective(SysUserIntegralDetail);
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




}
