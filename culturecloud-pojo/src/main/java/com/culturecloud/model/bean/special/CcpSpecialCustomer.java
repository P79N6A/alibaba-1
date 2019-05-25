package com.culturecloud.model.bean.special;

import java.util.Date;

import javax.persistence.Column;

import com.culturecloud.annotations.Id;
import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;

@Table(value="ccp_special_customer")
public class CcpSpecialCustomer implements BaseEntity{

	private static final long serialVersionUID = -7099745022448211962L;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column ccp_special_customer.customer_id
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	@Id
	@Column(name="customer_id")
	private String customerId;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column ccp_special_customer.customer_name
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	@Column(name="customer_name")
	private String customerName;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column ccp_special_customer.customer_type
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	@Column(name="customer_type")
	private String customerType;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column ccp_special_customer.customer_is_del
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	@Column(name="customer_is_del")
	private Integer customerIsDel;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column ccp_special_customer.ycode_num
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	@Column(name="ycode_num")
	private Integer ycodeNum;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column ccp_special_customer.project_id
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	@Column(name="project_id")
	private String projectId;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column ccp_special_customer.page_id
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	@Column(name="page_id")
	private String pageId;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column ccp_special_customer.enter_id
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	@Column(name="enter_id")
	private String enterId;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column ccp_special_customer.customer_create_time
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	@Column(name="customer_create_time")
	private Date customerCreateTime;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column ccp_special_customer.customer_create_user
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	@Column(name="customer_create_user")
	private String customerCreateUser;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column ccp_special_customer.ycode_start_time
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	@Column(name="ycode_start_time")
	private Date ycodeStartTime;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column ccp_special_customer.ycode_end_time
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	@Column(name="ycode_end_time")
	private Date ycodeEndTime;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column ccp_special_customer.customer_update_time
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	@Column(name="customer_update_time")
	private Date customerUpdateTime;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column ccp_special_customer.customer_update_user
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	@Column(name="customer_update_user")
	private String customerUpdateUser;
	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_special_customer.customer_id
	 * @return  the value of ccp_special_customer.customer_id
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	public String getCustomerId() {
		return customerId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_special_customer.customer_id
	 * @param customerId  the value for ccp_special_customer.customer_id
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	public void setCustomerId(String customerId) {
		this.customerId = customerId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_special_customer.customer_name
	 * @return  the value of ccp_special_customer.customer_name
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	public String getCustomerName() {
		return customerName;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_special_customer.customer_name
	 * @param customerName  the value for ccp_special_customer.customer_name
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_special_customer.customer_type
	 * @return  the value of ccp_special_customer.customer_type
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	public String getCustomerType() {
		return customerType;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_special_customer.customer_type
	 * @param customerType  the value for ccp_special_customer.customer_type
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	public void setCustomerType(String customerType) {
		this.customerType = customerType;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_special_customer.customer_is_del
	 * @return  the value of ccp_special_customer.customer_is_del
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	public Integer getCustomerIsDel() {
		return customerIsDel;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_special_customer.customer_is_del
	 * @param customerIsDel  the value for ccp_special_customer.customer_is_del
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	public void setCustomerIsDel(Integer customerIsDel) {
		this.customerIsDel = customerIsDel;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_special_customer.ycode_num
	 * @return  the value of ccp_special_customer.ycode_num
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	public Integer getYcodeNum() {
		return ycodeNum;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_special_customer.ycode_num
	 * @param ycodeNum  the value for ccp_special_customer.ycode_num
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	public void setYcodeNum(Integer ycodeNum) {
		this.ycodeNum = ycodeNum;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_special_customer.project_id
	 * @return  the value of ccp_special_customer.project_id
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	public String getProjectId() {
		return projectId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_special_customer.project_id
	 * @param projectId  the value for ccp_special_customer.project_id
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	public void setProjectId(String projectId) {
		this.projectId = projectId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_special_customer.page_id
	 * @return  the value of ccp_special_customer.page_id
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	public String getPageId() {
		return pageId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_special_customer.page_id
	 * @param pageId  the value for ccp_special_customer.page_id
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	public void setPageId(String pageId) {
		this.pageId = pageId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_special_customer.enter_id
	 * @return  the value of ccp_special_customer.enter_id
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	public String getEnterId() {
		return enterId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_special_customer.enter_id
	 * @param enterId  the value for ccp_special_customer.enter_id
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	public void setEnterId(String enterId) {
		this.enterId = enterId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_special_customer.customer_create_time
	 * @return  the value of ccp_special_customer.customer_create_time
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	public Date getCustomerCreateTime() {
		return customerCreateTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_special_customer.customer_create_time
	 * @param customerCreateTime  the value for ccp_special_customer.customer_create_time
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	public void setCustomerCreateTime(Date customerCreateTime) {
		this.customerCreateTime = customerCreateTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_special_customer.customer_create_user
	 * @return  the value of ccp_special_customer.customer_create_user
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	public String getCustomerCreateUser() {
		return customerCreateUser;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_special_customer.customer_create_user
	 * @param customerCreateUser  the value for ccp_special_customer.customer_create_user
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	public void setCustomerCreateUser(String customerCreateUser) {
		this.customerCreateUser = customerCreateUser;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_special_customer.ycode_start_time
	 * @return  the value of ccp_special_customer.ycode_start_time
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	public Date getYcodeStartTime() {
		return ycodeStartTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_special_customer.ycode_start_time
	 * @param ycodeStartTime  the value for ccp_special_customer.ycode_start_time
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	public void setYcodeStartTime(Date ycodeStartTime) {
		this.ycodeStartTime = ycodeStartTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_special_customer.ycode_end_time
	 * @return  the value of ccp_special_customer.ycode_end_time
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	public Date getYcodeEndTime() {
		return ycodeEndTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_special_customer.ycode_end_time
	 * @param ycodeEndTime  the value for ccp_special_customer.ycode_end_time
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	public void setYcodeEndTime(Date ycodeEndTime) {
		this.ycodeEndTime = ycodeEndTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_special_customer.customer_update_time
	 * @return  the value of ccp_special_customer.customer_update_time
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	public Date getCustomerUpdateTime() {
		return customerUpdateTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_special_customer.customer_update_time
	 * @param customerUpdateTime  the value for ccp_special_customer.customer_update_time
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	public void setCustomerUpdateTime(Date customerUpdateTime) {
		this.customerUpdateTime = customerUpdateTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_special_customer.customer_update_user
	 * @return  the value of ccp_special_customer.customer_update_user
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	public String getCustomerUpdateUser() {
		return customerUpdateUser;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_special_customer.customer_update_user
	 * @param customerUpdateUser  the value for ccp_special_customer.customer_update_user
	 * @mbggenerated  Tue Sep 27 14:52:35 CST 2016
	 */
	public void setCustomerUpdateUser(String customerUpdateUser) {
		this.customerUpdateUser = customerUpdateUser;
	}

	// ��Ŀ���
    private String projectName;
    // ר��ҳ���
    private String pageName;
    // ���ҳ���
    private String enterName;
    // ����������
    private String customerCreateUserName;
    public String getProjectName() {
		return projectName;
	}

	public void setProjectName(String projectName) {
		this.projectName = projectName;
	}

	public String getPageName() {
		return pageName;
	}

	public void setPageName(String pageName) {
		this.pageName = pageName;
	}

	public String getEnterName() {
		return enterName;
	}

	public void setEnterName(String enterName) {
		this.enterName = enterName;
	}

	public String getCustomerCreateUserName() {
		return customerCreateUserName;
	}

	public void setCustomerCreateUserName(String customerCreateUserName) {
		this.customerCreateUserName = customerCreateUserName;
	}
    
    
}