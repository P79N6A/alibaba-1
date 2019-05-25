package com.sun3d.why.model;

import java.util.Date;

import com.sun3d.why.enumeration.UserOperationEnum;
import com.sun3d.why.util.UUIDUtils;

public class CmsUserOperatorLog {

	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column cms_user_operator_log.ORDER_LOG_ID
	 * @mbggenerated  Mon Jun 27 12:51:36 CST 2016
	 */
	private String orderLogId;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column cms_user_operator_log.OPERATOR_USER_ID
	 * @mbggenerated  Mon Jun 27 12:51:36 CST 2016
	 */
	private String operatorUserId;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column cms_user_operator_log.CREATE_TIME
	 * @mbggenerated  Mon Jun 27 12:51:36 CST 2016
	 */
	private Date createTime;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column cms_user_operator_log.ORDER_ID
	 * @mbggenerated  Mon Jun 27 12:51:36 CST 2016
	 */
	private String orderId;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column cms_user_operator_log.OPERATOR_TYPE
	 * @mbggenerated  Mon Jun 27 12:51:36 CST 2016
	 */
	private Integer operatorType;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column cms_user_operator_log.USER_ID
	 * @mbggenerated  Mon Jun 27 12:51:36 CST 2016
	 */
	private String userId;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column cms_user_operator_log.USER_TYPE
	 * @mbggenerated  Mon Jun 27 12:51:36 CST 2016
	 */
	private Integer userType;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column cms_user_operator_log.TUSER_ID
	 * @mbggenerated  Mon Jun 27 12:51:36 CST 2016
	 */
	private String tuserId;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column cms_user_operator_log.REMARK
	 * @mbggenerated  Mon Jun 27 12:51:36 CST 2016
	 */
	private String remark;
	
	// 管理员
	public static int USER_TYPE_ADMIN=1;
	// 普通用户
	public static int USER_TYPE_NORMAL=2;
	
	
	private String tuserName;
	
	private String userName;
	
	private String operatorUserName;
	
	
	public static CmsUserOperatorLog createInstance(String userId,String orderId,String tuserId,String operatorUserId,int userType,UserOperationEnum orderOperation){
		
		CmsUserOperatorLog log=new CmsUserOperatorLog();
		
		log.setOrderLogId(UUIDUtils.createUUId());
		log.setCreateTime(new Date());
		log.setTuserId(tuserId);
		log.setOrderId(orderId);
		log.setUserId(userId);

		log.setUserType(userType);
		
		log.setOperatorUserId(operatorUserId);
		
		log.setOperatorType(orderOperation.getType());
		log.setRemark(orderOperation.getRemark());
		
		return log;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_user_operator_log.ORDER_LOG_ID
	 * @return  the value of cms_user_operator_log.ORDER_LOG_ID
	 * @mbggenerated  Mon Jun 27 12:51:36 CST 2016
	 */
	public String getOrderLogId() {
		return orderLogId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_user_operator_log.ORDER_LOG_ID
	 * @param orderLogId  the value for cms_user_operator_log.ORDER_LOG_ID
	 * @mbggenerated  Mon Jun 27 12:51:36 CST 2016
	 */
	public void setOrderLogId(String orderLogId) {
		this.orderLogId = orderLogId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_user_operator_log.OPERATOR_USER_ID
	 * @return  the value of cms_user_operator_log.OPERATOR_USER_ID
	 * @mbggenerated  Mon Jun 27 12:51:36 CST 2016
	 */
	public String getOperatorUserId() {
		return operatorUserId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_user_operator_log.OPERATOR_USER_ID
	 * @param operatorUserId  the value for cms_user_operator_log.OPERATOR_USER_ID
	 * @mbggenerated  Mon Jun 27 12:51:36 CST 2016
	 */
	public void setOperatorUserId(String operatorUserId) {
		this.operatorUserId = operatorUserId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_user_operator_log.CREATE_TIME
	 * @return  the value of cms_user_operator_log.CREATE_TIME
	 * @mbggenerated  Mon Jun 27 12:51:36 CST 2016
	 */
	public Date getCreateTime() {
		return createTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_user_operator_log.CREATE_TIME
	 * @param createTime  the value for cms_user_operator_log.CREATE_TIME
	 * @mbggenerated  Mon Jun 27 12:51:36 CST 2016
	 */
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_user_operator_log.ORDER_ID
	 * @return  the value of cms_user_operator_log.ORDER_ID
	 * @mbggenerated  Mon Jun 27 12:51:36 CST 2016
	 */
	public String getOrderId() {
		return orderId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_user_operator_log.ORDER_ID
	 * @param orderId  the value for cms_user_operator_log.ORDER_ID
	 * @mbggenerated  Mon Jun 27 12:51:36 CST 2016
	 */
	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_user_operator_log.OPERATOR_TYPE
	 * @return  the value of cms_user_operator_log.OPERATOR_TYPE
	 * @mbggenerated  Mon Jun 27 12:51:36 CST 2016
	 */
	public Integer getOperatorType() {
		return operatorType;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_user_operator_log.OPERATOR_TYPE
	 * @param operatorType  the value for cms_user_operator_log.OPERATOR_TYPE
	 * @mbggenerated  Mon Jun 27 12:51:36 CST 2016
	 */
	public void setOperatorType(Integer operatorType) {
		this.operatorType = operatorType;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_user_operator_log.USER_ID
	 * @return  the value of cms_user_operator_log.USER_ID
	 * @mbggenerated  Mon Jun 27 12:51:36 CST 2016
	 */
	public String getUserId() {
		return userId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_user_operator_log.USER_ID
	 * @param userId  the value for cms_user_operator_log.USER_ID
	 * @mbggenerated  Mon Jun 27 12:51:36 CST 2016
	 */
	public void setUserId(String userId) {
		this.userId = userId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_user_operator_log.USER_TYPE
	 * @return  the value of cms_user_operator_log.USER_TYPE
	 * @mbggenerated  Mon Jun 27 12:51:36 CST 2016
	 */
	public Integer getUserType() {
		return userType;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_user_operator_log.USER_TYPE
	 * @param userType  the value for cms_user_operator_log.USER_TYPE
	 * @mbggenerated  Mon Jun 27 12:51:36 CST 2016
	 */
	public void setUserType(Integer userType) {
		this.userType = userType;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_user_operator_log.TUSER_ID
	 * @return  the value of cms_user_operator_log.TUSER_ID
	 * @mbggenerated  Mon Jun 27 12:51:36 CST 2016
	 */
	public String getTuserId() {
		return tuserId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_user_operator_log.TUSER_ID
	 * @param tuserId  the value for cms_user_operator_log.TUSER_ID
	 * @mbggenerated  Mon Jun 27 12:51:36 CST 2016
	 */
	public void setTuserId(String tuserId) {
		this.tuserId = tuserId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_user_operator_log.REMARK
	 * @return  the value of cms_user_operator_log.REMARK
	 * @mbggenerated  Mon Jun 27 12:51:36 CST 2016
	 */
	public String getRemark() {
		return remark;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_user_operator_log.REMARK
	 * @param remark  the value for cms_user_operator_log.REMARK
	 * @mbggenerated  Mon Jun 27 12:51:36 CST 2016
	 */
	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getTuserName() {
		return tuserName;
	}

	public void setTuserName(String tuserName) {
		this.tuserName = tuserName;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getOperatorUserName() {
		return operatorUserName;
	}

	public void setOperatorUserName(String operatorUserName) {
		this.operatorUserName = operatorUserName;
	}
	
	
	
}