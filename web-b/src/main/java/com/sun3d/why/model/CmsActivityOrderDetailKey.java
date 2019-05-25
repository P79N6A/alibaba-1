package com.sun3d.why.model;

public class CmsActivityOrderDetailKey {
    private String activityOrderId;

    private Integer orderLine;

    public String getActivityOrderId() {
        return activityOrderId;
    }

    public void setActivityOrderId(String activityOrderId) {
        this.activityOrderId = activityOrderId == null ? null : activityOrderId.trim();
    }

    public Integer getOrderLine() {
        return orderLine;
    }

    public void setOrderLine(Integer orderLine) {
        this.orderLine = orderLine;
    }
}