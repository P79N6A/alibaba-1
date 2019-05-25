package com.culturecloud.model.bean.analyse;

import java.util.Date;

import javax.persistence.Column;

import com.culturecloud.annotations.Id;
import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;

@Table(value="sys_visit_sum")
public class SysVisitSum implements BaseEntity{

	private static final long serialVersionUID = -1601464774270615599L;

	/** 主键*/
	@Id
	@Column(name="id")
	private String id;
	
	/** 日志时间*/
	@Column(name="log_time")
	private Date logTime;
	
	/** H5次数*/
	@Column(name="h5_num")
	private Integer h5Num;
	
	/** ios次数*/
	@Column(name="ios_num")
	private Integer iosNum;
	
	/** android次数*/
	@Column(name="android_num")
	private Integer androidNum;
	
	/** 总次数*/
	@Column(name="all_num")
	private Integer allnum;
	
	

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

	public Integer getH5Num() {
		return h5Num;
	}

	public void setH5Num(Integer h5Num) {
		this.h5Num = h5Num;
	}

	public Integer getIosNum() {
		return iosNum;
	}

	public void setIosNum(Integer iosNum) {
		this.iosNum = iosNum;
	}

	public Integer getAndroidNum() {
		return androidNum;
	}

	public void setAndroidNum(Integer androidNum) {
		this.androidNum = androidNum;
	}

	public Integer getAllnum() {
		return allnum;
	}

	public void setAllnum(Integer allnum) {
		this.allnum = allnum;
	}

	

	

}
