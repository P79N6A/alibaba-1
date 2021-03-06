package com.culturecloud.model.bean.volunteer;

import java.util.Date;

import javax.persistence.Column;

import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;

@Table("ccp_volunteer_apply")
public class CcpVolunteerApply implements BaseEntity{


	private static final long serialVersionUID = -2123417427661523580L;

	@Column(name="volunteer_apply_id")
	private String volunteerApplyId;
	
	@Column(name="volunteer_real_name")
	private String volunteerRealName;
	
	@Column(name="volunteer_mobile")
	private String volunteerMobile;

	@Column(name="volunteer_age")
	private Integer volunteerAge;

	@Column(name="volunteer_sex")
	private Integer volunteerSex;

	@Column(name="volunteer_degree")
	private String volunteerDegree;

	@Column(name="volunteer_introduction")
	private String volunteerIntroduction;

	@Column(name="apply_date_time")
	private Date applyDateTime;

	@Column(name="apply_status")
	private Integer applyStatus;

	@Column(name="recruit_id")
	private String recruitId;

	@Column(name="user_id")
	private String userId;

	@Column(name="apply_operator_id")
	private String applyOperatorId;

	// 申请人账号
    private String userName;





	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_volunteer_apply.volunteer_apply_id
	 * @return  the value of ccp_volunteer_apply.volunteer_apply_id
	 * @mbggenerated  Wed Aug 31 11:03:11 CST 2016
	 */
	public String getVolunteerApplyId() {
		return volunteerApplyId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_volunteer_apply.volunteer_apply_id
	 * @param volunteerApplyId  the value for ccp_volunteer_apply.volunteer_apply_id
	 * @mbggenerated  Wed Aug 31 11:03:11 CST 2016
	 */
	public void setVolunteerApplyId(String volunteerApplyId) {
		this.volunteerApplyId = volunteerApplyId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_volunteer_apply.volunteer_real_name
	 * @return  the value of ccp_volunteer_apply.volunteer_real_name
	 * @mbggenerated  Wed Aug 31 11:03:11 CST 2016
	 */
	public String getVolunteerRealName() {
		return volunteerRealName;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_volunteer_apply.volunteer_real_name
	 * @param volunteerRealName  the value for ccp_volunteer_apply.volunteer_real_name
	 * @mbggenerated  Wed Aug 31 11:03:11 CST 2016
	 */
	public void setVolunteerRealName(String volunteerRealName) {
		this.volunteerRealName = volunteerRealName;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_volunteer_apply.volunteer_mobile
	 * @return  the value of ccp_volunteer_apply.volunteer_mobile
	 * @mbggenerated  Wed Aug 31 11:03:11 CST 2016
	 */
	public String getVolunteerMobile() {
		return volunteerMobile;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_volunteer_apply.volunteer_mobile
	 * @param volunteerMobile  the value for ccp_volunteer_apply.volunteer_mobile
	 * @mbggenerated  Wed Aug 31 11:03:11 CST 2016
	 */
	public void setVolunteerMobile(String volunteerMobile) {
		this.volunteerMobile = volunteerMobile;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_volunteer_apply.volunteer_age
	 * @return  the value of ccp_volunteer_apply.volunteer_age
	 * @mbggenerated  Wed Aug 31 11:03:11 CST 2016
	 */
	public Integer getVolunteerAge() {
		return volunteerAge;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_volunteer_apply.volunteer_age
	 * @param volunteerAge  the value for ccp_volunteer_apply.volunteer_age
	 * @mbggenerated  Wed Aug 31 11:03:11 CST 2016
	 */
	public void setVolunteerAge(Integer volunteerAge) {
		this.volunteerAge = volunteerAge;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_volunteer_apply.volunteer_sex
	 * @return  the value of ccp_volunteer_apply.volunteer_sex
	 * @mbggenerated  Wed Aug 31 11:03:11 CST 2016
	 */
	public Integer getVolunteerSex() {
		return volunteerSex;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_volunteer_apply.volunteer_sex
	 * @param volunteerSex  the value for ccp_volunteer_apply.volunteer_sex
	 * @mbggenerated  Wed Aug 31 11:03:11 CST 2016
	 */
	public void setVolunteerSex(Integer volunteerSex) {
		this.volunteerSex = volunteerSex;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_volunteer_apply.volunteer_degree
	 * @return  the value of ccp_volunteer_apply.volunteer_degree
	 * @mbggenerated  Wed Aug 31 11:03:11 CST 2016
	 */
	public String getVolunteerDegree() {
		return volunteerDegree;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_volunteer_apply.volunteer_degree
	 * @param volunteerDegree  the value for ccp_volunteer_apply.volunteer_degree
	 * @mbggenerated  Wed Aug 31 11:03:11 CST 2016
	 */
	public void setVolunteerDegree(String volunteerDegree) {
		this.volunteerDegree = volunteerDegree;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_volunteer_apply.volunteer_introduction
	 * @return  the value of ccp_volunteer_apply.volunteer_introduction
	 * @mbggenerated  Wed Aug 31 11:03:11 CST 2016
	 */
	public String getVolunteerIntroduction() {
		return volunteerIntroduction;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_volunteer_apply.volunteer_introduction
	 * @param volunteerIntroduction  the value for ccp_volunteer_apply.volunteer_introduction
	 * @mbggenerated  Wed Aug 31 11:03:11 CST 2016
	 */
	public void setVolunteerIntroduction(String volunteerIntroduction) {
		this.volunteerIntroduction = volunteerIntroduction;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_volunteer_apply.apply_date_time
	 * @return  the value of ccp_volunteer_apply.apply_date_time
	 * @mbggenerated  Wed Aug 31 11:03:11 CST 2016
	 */
	public Date getApplyDateTime() {
		return applyDateTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_volunteer_apply.apply_date_time
	 * @param applyDateTime  the value for ccp_volunteer_apply.apply_date_time
	 * @mbggenerated  Wed Aug 31 11:03:11 CST 2016
	 */
	public void setApplyDateTime(Date applyDateTime) {
		this.applyDateTime = applyDateTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_volunteer_apply.apply_status
	 * @return  the value of ccp_volunteer_apply.apply_status
	 * @mbggenerated  Wed Aug 31 11:03:11 CST 2016
	 */
	public Integer getApplyStatus() {
		return applyStatus;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_volunteer_apply.apply_status
	 * @param applyStatus  the value for ccp_volunteer_apply.apply_status
	 * @mbggenerated  Wed Aug 31 11:03:11 CST 2016
	 */
	public void setApplyStatus(Integer applyStatus) {
		this.applyStatus = applyStatus;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_volunteer_apply.recruit_id
	 * @return  the value of ccp_volunteer_apply.recruit_id
	 * @mbggenerated  Wed Aug 31 11:03:11 CST 2016
	 */
	public String getRecruitId() {
		return recruitId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_volunteer_apply.recruit_id
	 * @param recruitId  the value for ccp_volunteer_apply.recruit_id
	 * @mbggenerated  Wed Aug 31 11:03:11 CST 2016
	 */
	public void setRecruitId(String recruitId) {
		this.recruitId = recruitId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_volunteer_apply.user_id
	 * @return  the value of ccp_volunteer_apply.user_id
	 * @mbggenerated  Wed Aug 31 11:03:11 CST 2016
	 */
	public String getUserId() {
		return userId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_volunteer_apply.user_id
	 * @param userId  the value for ccp_volunteer_apply.user_id
	 * @mbggenerated  Wed Aug 31 11:03:11 CST 2016
	 */
	public void setUserId(String userId) {
		this.userId = userId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_volunteer_apply.apply_operator_id
	 * @return  the value of ccp_volunteer_apply.apply_operator_id
	 * @mbggenerated  Wed Aug 31 11:03:11 CST 2016
	 */
	public String getApplyOperatorId() {
		return applyOperatorId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_volunteer_apply.apply_operator_id
	 * @param applyOperatorId  the value for ccp_volunteer_apply.apply_operator_id
	 * @mbggenerated  Wed Aug 31 11:03:11 CST 2016
	 */
	public void setApplyOperatorId(String applyOperatorId) {
		this.applyOperatorId = applyOperatorId;
	}

    public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}
    
    
}