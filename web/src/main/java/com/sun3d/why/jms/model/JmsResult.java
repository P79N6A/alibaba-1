package com.sun3d.why.jms.model;

import java.io.Serializable;

/**
 * Created by liyang on 2015/9/9.
 */
public class JmsResult implements Serializable{
    /**
     * serialVersionUID
     */
    private static final long serialVersionUID = 8580243279123979334L;

    /**
     * 无参构造函数
     */
    public JmsResult(){

    }

    /**
     * 构造函数
     * @param success 是否成功
     * @param message 消息内容
     */
    public JmsResult(Boolean success, String message, String status, String activityId, String userId){
        this.success=success;
        this.message=message;
        this.status=status;
        this.activityId = activityId;
        this.userId = userId;
    }

    /**
     * 是否成功
     */
    private Boolean success;

    /**
     * 消息内容
     */
    private String message;
    /**
     * 状态 1-票已抢光,2-黑名单,3-年龄限制,10-系统故障
     * @return
     */
    private String status;

    private String activityId;

    private String userId;

    private String roomId;

    private String activityOrderId;

    private String sid;

    private String sysId;
    private String sysNo;

    public String getActivityOrderId() {
        return activityOrderId;
    }

    public void setActivityOrderId(String activityOrderId) {
        this.activityOrderId = activityOrderId;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public Boolean getSuccess() {
        return success;
    }

    public void setSuccess(Boolean success) {
        this.success = success;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getActivityId() {
        return activityId;
    }

    public void setActivityId(String activityId) {
        this.activityId = activityId;
    }

    public String getRoomId() {
        return roomId;
    }

    public void setRoomId(String roomId) {
        this.roomId = roomId;
    }

    public String getSid() {
        return sid;
    }

    public void setSid(String sid) {
        this.sid = sid;
    }

    public String getSysId() {
        return sysId;
    }

    public void setSysId(String sysId) {
        this.sysId = sysId;
    }

    public String getSysNo() {
        return sysNo;
    }

    public void setSysNo(String sysNo) {
        this.sysNo = sysNo;
    }
}