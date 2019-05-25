package com.culturecloud.model.bean.square;

import java.util.Date;

import javax.persistence.Column;

import com.culturecloud.annotations.Id;
import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;

@Table(value="cms_cultural_square")
public class CmsCulturalSquare implements BaseEntity{

	private static final long serialVersionUID = -5721337180789443196L;

	/** 主键*/
	@Id
	@Column(name="square_id")
	private String squareId;
	
	/** 用户头像*/
	@Column(name="head_url")
	private String headUrl;
	
	/** 用户名*/
	@Column(name="user_name")
	private String userName;
	
	/** 发布时间*/
	@Column(name="publish_time")
	private String publishTime;
	
	/** 文案描述*/
	@Column(name="context_dec")
	private String contextDec;
	
	/** 扩充字段*/
	@Column(name="ext0")
	private String ext0;
	
	/** 扩充字段*/
	@Column(name="ext1")
	private String ext1;
	
	/** 扩充字段*/
	@Column(name="ext2")
	private String ext2;
	
	/** 扩充字段*/
	@Column(name="ext3")
	private String ext3;
	
	/** 扩充字段*/
	@Column(name="ext4")
	private String ext4;
	
	/** 类型*/
	@Column(name="type")// 1：活动、2:专题C端参与、3：通知类、4：知识问答、5：投票
	private Integer type;
	
	/** 外ID*/
	@Column(name="out_id")
	private String outId;
	
	/** 审核状态*/
	@Column(name="status")
	private Integer status;//0待审核、1审核通过、2审核不通过
	
	/** 置顶*/
	@Column(name="top")
	private Integer top;
	
	/** 白名单*/
	@Column(name="white_list")//0否、1是
	private Integer whiteList;
	
	
	public String getSquareId() {
		return squareId;
	}

	public void setSquareId(String squareId) {
		this.squareId = squareId;
	}

	public String getHeadUrl() {
		return headUrl;
	}

	public void setHeadUrl(String headUrl) {
		this.headUrl = headUrl;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}


	public String getPublishTime() {
		return publishTime;
	}

	public void setPublishTime(String publishTime) {
		this.publishTime = publishTime;
	}

	public String getContextDec() {
		return contextDec;
	}

	public void setContextDec(String contextDec) {
		this.contextDec = contextDec;
	}

	public String getExt0() {
		return ext0;
	}

	public void setExt0(String ext0) {
		this.ext0 = ext0;
	}

	public String getExt1() {
		return ext1;
	}

	public void setExt1(String ext1) {
		this.ext1 = ext1;
	}

	public String getExt2() {
		return ext2;
	}

	public void setExt2(String ext2) {
		this.ext2 = ext2;
	}

	public String getExt3() {
		return ext3;
	}

	public void setExt3(String ext3) {
		this.ext3 = ext3;
	}

	public String getExt4() {
		return ext4;
	}

	public void setExt4(String ext4) {
		this.ext4 = ext4;
	}

	public Integer getType() {
		return type;
	}

	public void setType(Integer type) {
		this.type = type;
	}

	public String getOutId() {
		return outId;
	}

	public void setOutId(String outId) {
		this.outId = outId;
	}

	public Integer getStatus() {
		return status;
	}

	public void setStatus(Integer status) {
		this.status = status;
	}

	public Integer getTop() {
		return top;
	}

	public void setTop(Integer top) {
		this.top = top;
	}

	public Integer getWhiteList() {
		return whiteList;
	}

	public void setWhiteList(Integer whiteList) {
		this.whiteList = whiteList;
	}
	
}
