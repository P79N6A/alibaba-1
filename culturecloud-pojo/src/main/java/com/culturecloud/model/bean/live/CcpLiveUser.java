package com.culturecloud.model.bean.live;

import java.util.Date;

import javax.persistence.Column;

import com.culturecloud.annotations.Id;
import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;

@Table(value="ccp_live_user")
public class CcpLiveUser implements BaseEntity{
	
	private static final long serialVersionUID = 8629606777295276371L;

	@Id
	@Column(name="live_user_id")
    private String liveUserId;

	@Column(name="user_id")
    private String userId;

	@Column(name="live_activity")
    private String liveActivity;

	@Column(name="user_real_name")
    private String userRealName;

	@Column(name="user_telephone")
    private String userTelephone;

	@Column(name="user_create_time")
    private Date userCreateTime;

	@Column(name="user_update_time")
    private Date userUpdateTime;

	@Column(name="user_upload_img")
    private String userUploadImg;

	@Column(name="user_is_like")
    private Integer userIsLike;

	
	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_live_user.live_user_id
	 * @return  the value of ccp_live_user.live_user_id
	 * @mbggenerated  Thu Oct 20 18:22:54 CST 2016
	 */
	public String getLiveUserId() {
		return liveUserId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_live_user.live_user_id
	 * @param liveUserId  the value for ccp_live_user.live_user_id
	 * @mbggenerated  Thu Oct 20 18:22:54 CST 2016
	 */
	public void setLiveUserId(String liveUserId) {
		this.liveUserId = liveUserId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_live_user.user_id
	 * @return  the value of ccp_live_user.user_id
	 * @mbggenerated  Thu Oct 20 18:22:54 CST 2016
	 */
	public String getUserId() {
		return userId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_live_user.user_id
	 * @param userId  the value for ccp_live_user.user_id
	 * @mbggenerated  Thu Oct 20 18:22:54 CST 2016
	 */
	public void setUserId(String userId) {
		this.userId = userId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_live_user.live_activity
	 * @return  the value of ccp_live_user.live_activity
	 * @mbggenerated  Thu Oct 20 18:22:54 CST 2016
	 */
	public String getLiveActivity() {
		return liveActivity;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_live_user.live_activity
	 * @param liveActivity  the value for ccp_live_user.live_activity
	 * @mbggenerated  Thu Oct 20 18:22:54 CST 2016
	 */
	public void setLiveActivity(String liveActivity) {
		this.liveActivity = liveActivity;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_live_user.user_real_name
	 * @return  the value of ccp_live_user.user_real_name
	 * @mbggenerated  Thu Oct 20 18:22:54 CST 2016
	 */
	public String getUserRealName() {
		return userRealName;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_live_user.user_real_name
	 * @param userRealName  the value for ccp_live_user.user_real_name
	 * @mbggenerated  Thu Oct 20 18:22:54 CST 2016
	 */
	public void setUserRealName(String userRealName) {
		this.userRealName = userRealName;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_live_user.user_telephone
	 * @return  the value of ccp_live_user.user_telephone
	 * @mbggenerated  Thu Oct 20 18:22:54 CST 2016
	 */
	public String getUserTelephone() {
		return userTelephone;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_live_user.user_telephone
	 * @param userTelephone  the value for ccp_live_user.user_telephone
	 * @mbggenerated  Thu Oct 20 18:22:54 CST 2016
	 */
	public void setUserTelephone(String userTelephone) {
		this.userTelephone = userTelephone;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_live_user.user_create_time
	 * @return  the value of ccp_live_user.user_create_time
	 * @mbggenerated  Thu Oct 20 18:22:54 CST 2016
	 */
	public Date getUserCreateTime() {
		return userCreateTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_live_user.user_create_time
	 * @param userCreateTime  the value for ccp_live_user.user_create_time
	 * @mbggenerated  Thu Oct 20 18:22:54 CST 2016
	 */
	public void setUserCreateTime(Date userCreateTime) {
		this.userCreateTime = userCreateTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_live_user.user_update_time
	 * @return  the value of ccp_live_user.user_update_time
	 * @mbggenerated  Thu Oct 20 18:22:54 CST 2016
	 */
	public Date getUserUpdateTime() {
		return userUpdateTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_live_user.user_update_time
	 * @param userUpdateTime  the value for ccp_live_user.user_update_time
	 * @mbggenerated  Thu Oct 20 18:22:54 CST 2016
	 */
	public void setUserUpdateTime(Date userUpdateTime) {
		this.userUpdateTime = userUpdateTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_live_user.user_upload_img
	 * @return  the value of ccp_live_user.user_upload_img
	 * @mbggenerated  Thu Oct 20 18:22:54 CST 2016
	 */
	public String getUserUploadImg() {
		return userUploadImg;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_live_user.user_upload_img
	 * @param userUploadImg  the value for ccp_live_user.user_upload_img
	 * @mbggenerated  Thu Oct 20 18:22:54 CST 2016
	 */
	public void setUserUploadImg(String userUploadImg) {
		this.userUploadImg = userUploadImg;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_live_user.user_is_like
	 * @return  the value of ccp_live_user.user_is_like
	 * @mbggenerated  Thu Oct 20 18:22:54 CST 2016
	 */
	public Integer getUserIsLike() {
		return userIsLike;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_live_user.user_is_like
	 * @param userIsLike  the value for ccp_live_user.user_is_like
	 * @mbggenerated  Thu Oct 20 18:22:54 CST 2016
	 */
	public void setUserIsLike(Integer userIsLike) {
		this.userIsLike = userIsLike;
	}


    
}