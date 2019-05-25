package com.culturecloud.model.bean.analyse;

import java.util.Date;

import javax.persistence.Column;

import com.culturecloud.annotations.Id;
import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;

@Table(value="sys_activity_promote")
public class SysActivityPromote implements BaseEntity{

	private static final long serialVersionUID = 3169284349103384638L;

	
	/** 主键*/
	@Id
	@Column(name="id")
	private String id;
	
	/** 日志时间*/
	@Column(name="log_time")
	private Date logTime;
	
	/** 场馆Id*/
	@Column(name="activity_id")
	private String activityId;
	
	/** 访问数量*/
	@Column(name="visit_num")
	private Integer visitNum;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public Date getLogTime() {
		return logTime;
	}

	public void setLogTime(Date logTime) {
		this.logTime = logTime;
	}

	public String getActivityId() {
		return activityId;
	}

	public void setActivityId(String activityId) {
		this.activityId = activityId;
	}

	public Integer getVisitNum() {
		return visitNum;
	}

	public void setVisitNum(Integer visitNum) {
		this.visitNum = visitNum;
	}

	
}
