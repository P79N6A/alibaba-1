package com.culturecloud.model.bean.analyse;

import javax.persistence.Column;

import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;

@Table(value="sys_user_analyse")
public class SysUserAnalyse implements BaseEntity{

	private static final long serialVersionUID = 5477166770210802514L;

	/** 用户Id*/
	@Column(name="user_id")
	private String userId;
	
	/** 分类Id*/
	@Column(name="tag_id")
	private String tagId;
	
	/** 浏览分数*/
	@Column(name="visit_score")
	private Integer visitScore;
	
	/** 收藏分数*/
	@Column(name="collect_score")
	private Integer collectScore;
	
	/** 下单分数*/
	@Column(name="order_score")
	private Integer orderScore;
	
	/** 未注册未登陆标示*/
	@Column(name="sign_id")
	private String signId;

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getTagId() {
		return tagId;
	}

	public void setTagId(String tagId) {
		this.tagId = tagId;
	}

	public Integer getVisitScore() {
		return visitScore;
	}

	public void setVisitScore(Integer visitScore) {
		this.visitScore = visitScore;
	}

	public Integer getCollectScore() {
		return collectScore;
	}

	public void setCollectScore(Integer collectScore) {
		this.collectScore = collectScore;
	}

	public Integer getOrderScore() {
		return orderScore;
	}

	public void setOrderScore(Integer orderScore) {
		this.orderScore = orderScore;
	}

	public String getSignId() {
		return signId;
	}

	public void setSignId(String signId) {
		this.signId = signId;
	}
	
	
}
