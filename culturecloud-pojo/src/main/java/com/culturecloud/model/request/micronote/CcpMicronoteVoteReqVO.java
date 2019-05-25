package com.culturecloud.model.request.micronote;

import java.util.Date;

import com.culturecloud.bean.BaseRequest;

public class CcpMicronoteVoteReqVO extends BaseRequest{

	private String noteVoteId;

    private String noteId;

    private String userId;

    private Date createTime;
    
	public String getNoteVoteId() {
		return noteVoteId;
	}

	public void setNoteVoteId(String noteVoteId) {
		this.noteVoteId = noteVoteId;
	}

	public String getNoteId() {
		return noteId;
	}

	public void setNoteId(String noteId) {
		this.noteId = noteId;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

}