package com.culturecloud.model.bean.special;

import java.util.Date;

import javax.persistence.Column;

import com.culturecloud.annotations.Id;
import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;

@Table(value="ccp_special_ycode")
public class CcpSpecialYcode implements BaseEntity{

	private static final long serialVersionUID = 8250697916425578947L;

	/** Y码主键*/
	@Id
	@Column(name="code_id")
	private String codeId;
	
	/** Y码*/
	@Column(name="ycode")
	private String ycode;
	
	/** 渠道客户id*/
	@Column(name="customer_id")
	private String customerId;
	
	/** 领取活动id*/
	@Column(name="use_activity_id")
	private String useActivityId;
	
	/** 用户Id*/
	@Column(name="user_id")
	private String userId;
	
	/** Y码状态 0.未使用 1.已发送 2.已使用*/
	@Column(name="code_status")
	private Integer codeStatus;
	
	/** 创建时间*/
	@Column(name="ycode_create_time")
	private Date ycodeCreateTime;
	
	/** Y码使用时间*/
	@Column(name="ycode_use_time")
	private Date ycodeUseTime;

	public String getCodeId() {
		return codeId;
	}

	public void setCodeId(String codeId) {
		this.codeId = codeId;
	}

	public String getYcode() {
		return ycode;
	}

	public void setYcode(String ycode) {
		this.ycode = ycode;
	}

	public String getCustomerId() {
		return customerId;
	}

	public void setCustomerId(String customerId) {
		this.customerId = customerId;
	}


	public String getUseActivityId() {
		return useActivityId;
	}

	public void setUseActivityId(String useActivityId) {
		this.useActivityId = useActivityId;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public Integer getCodeStatus() {
		return codeStatus;
	}

	public void setCodeStatus(Integer codeStatus) {
		this.codeStatus = codeStatus;
	}

	public Date getYcodeCreateTime() {
		return ycodeCreateTime;
	}

	public void setYcodeCreateTime(Date ycodeCreateTime) {
		this.ycodeCreateTime = ycodeCreateTime;
	}

	public Date getYcodeUseTime() {
		return ycodeUseTime;
	}

	public void setYcodeUseTime(Date ycodeUseTime) {
		this.ycodeUseTime = ycodeUseTime;
	}
	
}
