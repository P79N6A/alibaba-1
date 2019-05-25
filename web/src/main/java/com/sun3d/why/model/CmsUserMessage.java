package com.sun3d.why.model;

import com.sun3d.why.util.Pagination;

import java.io.Serializable;
import java.util.Date;

public class CmsUserMessage  extends Pagination implements Serializable {
    private String userMessageId;

    private String userMessageAcceptUser;

    private String userMessageType;

    private String userMessageSendUser;

    private Date userMessageCreateTime;

    private String userMessageContent;
    /**用户消息状态 **/
    private String userMessageStatus;

    public String getUserMessageStatus() {
        return userMessageStatus;
    }

    public void setUserMessageStatus(String userMessageStatus) {
        this.userMessageStatus = userMessageStatus;
    }

    public String getUserMessageId() {
        return userMessageId;
    }

    public void setUserMessageId(String userMessageId) {
        this.userMessageId = userMessageId == null ? null : userMessageId.trim();
    }

    public String getUserMessageAcceptUser() {
        return userMessageAcceptUser;
    }

    public void setUserMessageAcceptUser(String userMessageAcceptUser) {
        this.userMessageAcceptUser = userMessageAcceptUser == null ? null : userMessageAcceptUser.trim();
    }

    public String getUserMessageType() {
        return userMessageType;
    }

    public void setUserMessageType(String userMessageType) {
        this.userMessageType = userMessageType == null ? null : userMessageType.trim();
    }

    public String getUserMessageSendUser() {
        return userMessageSendUser;
    }

    public void setUserMessageSendUser(String userMessageSendUser) {
        this.userMessageSendUser = userMessageSendUser == null ? null : userMessageSendUser.trim();
    }

    public Date getUserMessageCreateTime() {
        return userMessageCreateTime;
    }

    public void setUserMessageCreateTime(Date userMessageCreateTime) {
        this.userMessageCreateTime = userMessageCreateTime;
    }

    public String getUserMessageContent() {
        return userMessageContent;
    }

    public void setUserMessageContent(String userMessageContent) {
        this.userMessageContent = userMessageContent == null ? null : userMessageContent.trim();
    }
}