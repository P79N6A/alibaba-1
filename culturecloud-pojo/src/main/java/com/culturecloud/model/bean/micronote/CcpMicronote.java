package com.culturecloud.model.bean.micronote;

import java.util.Date;

import javax.persistence.Column;

import com.culturecloud.annotations.Id;
import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;

@Table(value="ccp_micronote")
public class CcpMicronote implements BaseEntity{

	private static final long serialVersionUID = -6354016989465841395L;

	@Id
	@Column(name="NOTE_ID")
	private String noteId;
	
	@Column(name="NOTE_NUM")
	private Integer noteNum;

	@Column(name="NOTE_TITLE")
    private String noteTitle;

	@Column(name="NOTE_PUBLISHER_NAME")
    private String notePublisherName;

	@Column(name="NOTE_PUBLISHER_AGE")
    private String notePublisherAge;

	@Column(name="NOTE_PUBLISHER_MOBILE")
    private String notePublisherMobile;

	@Column(name="NOTE_CONTENT")
    private String noteContent;

	@Column(name="CREATE_TIME")
    private Date createTime;

	@Column(name="CREATE_USER")
    private String createUser;

	@Column(name="UPDATE_TIME")
    private Date updateTime;

	@Column(name="UPDATE_USER")
    private String updateUser;

	public String getNoteId() {
        return noteId;
    }

    public void setNoteId(String noteId) {
        this.noteId = noteId == null ? null : noteId.trim();
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
        this.noteTitle = noteTitle == null ? null : noteTitle.trim();
    }

    public String getNotePublisherName() {
        return notePublisherName;
    }

    public void setNotePublisherName(String notePublisherName) {
        this.notePublisherName = notePublisherName == null ? null : notePublisherName.trim();
    }

    public String getNotePublisherAge() {
        return notePublisherAge;
    }

    public void setNotePublisherAge(String notePublisherAge) {
        this.notePublisherAge = notePublisherAge == null ? null : notePublisherAge.trim();
    }

    public String getNotePublisherMobile() {
        return notePublisherMobile;
    }

    public void setNotePublisherMobile(String notePublisherMobile) {
        this.notePublisherMobile = notePublisherMobile == null ? null : notePublisherMobile.trim();
    }

    public String getNoteContent() {
        return noteContent;
    }

    public void setNoteContent(String noteContent) {
        this.noteContent = noteContent == null ? null : noteContent.trim();
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
        this.createUser = createUser == null ? null : createUser.trim();
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
        this.updateUser = updateUser == null ? null : updateUser.trim();
    }
}