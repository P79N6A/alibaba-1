package com.culturecloud.model.bean.micronote;

import java.util.Date;

import javax.persistence.Column;

import com.culturecloud.annotations.Id;
import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;

@Table(value="ccp_micronote_vote")
public class CcpMicronoteVote implements BaseEntity{

	private static final long serialVersionUID = 8505969787796401575L;

	@Id
	@Column(name="NOTE_VOTE_ID")
	private String noteVoteId;

	@Column(name="NOTE_ID")
    private String noteId;

	@Column(name="USER_ID")
    private String userId;

	@Column(name="CREATE_TIME")
    private Date createTime;

    public String getNoteVoteId() {
        return noteVoteId;
    }

    public void setNoteVoteId(String noteVoteId) {
        this.noteVoteId = noteVoteId == null ? null : noteVoteId.trim();
    }

    public String getNoteId() {
        return noteId;
    }

    public void setNoteId(String noteId) {
        this.noteId = noteId == null ? null : noteId.trim();
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId == null ? null : userId.trim();
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }
}