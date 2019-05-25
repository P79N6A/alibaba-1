package com.sun3d.why.model;

import com.sun3d.why.util.Pagination;

import java.io.Serializable;
import java.util.Date;

public class MessageTemplet  extends Pagination implements Serializable {
    private String messageId;

    private String messageType;

   /* private String messageTargetUser;
*/
    private String messageCreateUser;

    private Date messageCreateTime;

    private String messageUpdateUser;

    private Date messageUpdateTime;

    private Integer messageState;

    private String messageContent;

    public String getMessageId() {
        return messageId;
    }

    public void setMessageId(String messageId) {
        this.messageId = messageId == null ? null : messageId.trim();
    }

    public String getMessageType() {
        return messageType;
    }

    public void setMessageType(String messageType) {
        this.messageType = messageType == null ? null : messageType.trim();
    }

/*
    public String getMessageTargetUser() {
        return messageTargetUser;
    }

    public void setMessageTargetUser(String messageTargetUser) {
        this.messageTargetUser = messageTargetUser == null ? null : messageTargetUser.trim();
    }
*/

    public String getMessageCreateUser() {
        return messageCreateUser;
    }

    public void setMessageCreateUser(String messageCreateUser) {
        this.messageCreateUser = messageCreateUser == null ? null : messageCreateUser.trim();
    }

    public Date getMessageCreateTime() {
        return messageCreateTime;
    }

    public void setMessageCreateTime(Date messageCreateTime) {
        this.messageCreateTime = messageCreateTime;
    }

    public String getMessageUpdateUser() {
        return messageUpdateUser;
    }

    public void setMessageUpdateUser(String messageUpdateUser) {
        this.messageUpdateUser = messageUpdateUser == null ? null : messageUpdateUser.trim();
    }

    public Date getMessageUpdateTime() {
        return messageUpdateTime;
    }

    public void setMessageUpdateTime(Date messageUpdateTime) {
        this.messageUpdateTime = messageUpdateTime;
    }

    public Integer getMessageState() {
        return messageState;
    }

    public void setMessageState(Integer messageState) {
        this.messageState = messageState;
    }

    public String getMessageContent() {
        return messageContent;
    }

    public void setMessageContent(String messageContent) {
        this.messageContent = messageContent == null ? null : messageContent.trim();
    }
}