package com.sun3d.why.jms.model;

import java.io.Serializable;



public class ActivityTicketModel implements Serializable {
    /**
     * serialVersionUID
     */
    private static final long serialVersionUID = 5378774153218780022L;

    /**
     * 用户ID
     */
    private Integer userId;

    /**
     * 内容ID
     */
    private Integer contentId;

    /**
     * 预定票数
     */
    private Integer orderNum;

    /**
     * 来源
     */
    private String source;

    /**
     * 活动操作类型
     */
    private String operate;

    /**
     * 版本
     */
    private String version;

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getContentId() {
        return contentId;
    }

    public void setContentId(Integer contentId) {
        this.contentId = contentId;
    }

    public Integer getOrderNum() {
        return orderNum;
    }

    public void setOrderNum(Integer orderNum) {
        this.orderNum = orderNum;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public String getOperate() {
        return operate;
    }

    public void setOperate(String operate) {
        this.operate = operate;
    }


}

