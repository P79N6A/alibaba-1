package com.culturecloud.model.bean.words;

import java.util.Date;

import javax.persistence.Column;

import com.culturecloud.annotations.Id;
import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;

@Table(value="cms_sensitive_words")
public class CmsSensitiveWords implements BaseEntity{

	@Id
	@Column(name="SID")
	private String sid;
	
	@Column(name="SENSITIVE_WORDS")
	private String sensitiveWords;
	
	@Column(name="CREATE_USER")
	private String createUser;
	
	@Column(name="UPDATE_USER")
	private String updateUser;
	
	@Column(name="CREATE_TIME")
	private Date createTime;
	
	@Column(name="UPDATE_TIME")
	private Date updateTime;
	
	@Column(name="WORDS_STATUS")
	private Integer wordsStatus;

	public String getSid() {
		return sid;
	}

	public void setSid(String sid) {
		this.sid = sid;
	}

	public String getSensitiveWords() {
		return sensitiveWords;
	}

	public void setSensitiveWords(String sensitiveWords) {
		this.sensitiveWords = sensitiveWords;
	}

	public String getCreateUser() {
		return createUser;
	}

	public void setCreateUser(String createUser) {
		this.createUser = createUser;
	}

	public String getUpdateUser() {
		return updateUser;
	}

	public void setUpdateUser(String updateUser) {
		this.updateUser = updateUser;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public Date getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}

	public Integer getWordsStatus() {
		return wordsStatus;
	}

	public void setWordsStatus(Integer wordsStatus) {
		this.wordsStatus = wordsStatus;
	}
	
	
}
