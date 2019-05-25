package com.sun3d.why.service;

import java.io.IOException;
import java.util.List;

import com.culturecloud.model.bean.live.CcpLiveMessage;
import com.sun3d.why.model.UserIntegralDetail;
import com.sun3d.why.util.Pagination;

public interface UserIntegralDetailService {

	 int deleteUserIntegralDetailById(String integralDetailId);
	 
	 int addUserIntegralDetail(UserIntegralDetail record);
	 
	 UserIntegralDetail selectUserIntegralDetailById(String integralDetailId);
	 
	 int updateUserIntegralDetail(UserIntegralDetail record);
	 
	 List<UserIntegralDetail> queryUserIntegralDetailByIntegralId(String integralId,Pagination page);
	 
	 /**
	  * 添加云叔积分
	 * @param userId
	 * @param userIntegralDetail
	 * @return
	 */
	int saveCloudIntegral(String []userId,UserIntegralDetail userIntegralDetail);
	 
	 /**
	  * 注册添加积分
	 * @param userId
	 * @return
	 */
	int registerAddIntegral(String userId);
	
	/**
	 * 评论添加积分
	 * @param userId
	 * @param commentId
	 * @return
	 */
	int commentAddIntegral(String userId,String commentId);
	
	/**
	 * 删除评论扣积分
	 * @param userId
	 * @param commentId
	 * @return
	 */
	int commentDeleteIntegral(String userId,String commentId);
	
	/**
	 * 转发添加接口
	 * 
	 * @param userId
	 * @param text
	 * @return
	 */
	int forwardAddIntegral(String userId,String url);
	
	/**
	 * 成功核销
	 * 
	 * @param userId
	 * @param activityId
	 * @return
	 */
	int successVerificationAddIntegral(String userId,String activityId);
	
	/**
	 * 未核销
	 * 
	 * @param userId
	 * @param activityId
	 * @return
	 */
	int timeOutNotVerificationAddIntegral(String userId,String userName,String activityId,Integer deductionCredit,String orderId,String orderNumer);
	
	/**
	 * 每日登录
	 * 
	 * @param userId
	 * @return
	 */
	int everyDayOpenAddIntegral(String userId);
	
	/**
	 * 每周登录奖励
	 * 
	 * @param userId
	 * @return
	 */
	int weekOpenAddIntegral(String userId,String date);
	
	/**
	 * 直播评论添加积分
	 * @param userId
	 * @param commentId
	 * @return
	 */
	int liveCommentDeleteIntegral(CcpLiveMessage message);

	/**
     * 积分变动(扣减)
     * @param vo
     * @return
     */
	String deteleIntegralByVo(UserIntegralDetail vo);
}
