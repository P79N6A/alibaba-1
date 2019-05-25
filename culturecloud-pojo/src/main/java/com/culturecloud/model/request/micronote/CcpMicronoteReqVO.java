package com.culturecloud.model.request.micronote;

import java.util.Date;

import com.culturecloud.bean.BaseRequest;

public class CcpMicronoteReqVO extends BaseRequest{

	private String noteId;
	
	private Integer noteNum;

    private String noteTitle;

    private String notePublisherName;

    private String notePublisherAge;

    private String notePublisherMobile;

    private String noteContent;

    private Date createTime;

    private String createUser;

    private Date updateTime;

    private String updateUser;
    
    private String userId;
    
    private Integer resultIndex=1;
	
	private Integer resultSize=10;
	
	private Integer resultFirst;
	

	public String getNoteId() {
		return noteId;
	}

	public void setNoteId(String noteId) {
		this.noteId = noteId;
	}
	
	public Integer getNoteNum() {
		return noteNum;
	}

	public void setNoteNum(Integer noteNum) {
		this.noteNum = noteNum;
	}

	public String getNoteTitle() {
		return noteTitle;
	}

	public void setNoteTitle(String noteTitle) {
		this.noteTitle = noteTitle;
	}

	public String getNotePublisherName() {
		return notePublisherName;
	}

	public void setNotePublisherName(String notePublisherName) {
		this.notePublisherName = notePublisherName;
	}

	public String getNotePublisherAge() {
		return notePublisherAge;
	}

	public void setNotePublisherAge(String notePublisherAge) {
		this.notePublisherAge = notePublisherAge;
	}

	public String getNotePublisherMobile() {
		return notePublisherMobile;
	}

	public void setNotePublisherMobile(String notePublisherMobile) {
		this.notePublisherMobile = notePublisherMobile;
	}

	public String getNoteContent() {
		return noteContent;
	}

	public void setNoteContent(String noteContent) {
		this.noteContent = noteContent;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public String getCreateUser() {
		return createUser;
	}

	public void setCreateUser(String createUser) {
		this.createUser = createUser;
	}

	public Date getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}

	public String getUpdateUser() {
		return updateUser;
	}

	public void setUpdateUser(String updateUser) {
		this.updateUser = updateUser;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public Integer getResultIndex() {
		return resultIndex;
	}

	public void setResultIndex(Integer resultIndex) {
		this.resultIndex = resultIndex;
	}

	public Integer getResultSize() {
		return resultSize;
	}

	public void setResultSize(Integer resultSize) {
		this.resultSize = resultSize;
	}

	public Integer getResultFirst() {
		if(resultFirst!=null){
			return resultFirst;
		}else{
			return (resultIndex-1)*resultSize;
		}
	}

	public void setResultFirst(Integer resultFirst) {
		this.resultFirst = resultFirst;
	}

}