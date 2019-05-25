package com.sun3d.why.model.train;

import java.util.Date;

public class CmsTrainField {
    private String id;

    private String trainId;

    private String fieldTimeStr;

    private Date fieldStartTime;

    private Date fieldEndTime;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id == null ? null : id.trim();
    }

    public String getTrainId() {
        return trainId;
    }

    public void setTrainId(String trainId) {
        this.trainId = trainId == null ? null : trainId.trim();
    }

    public String getFieldTimeStr() {
        return fieldTimeStr;
    }

    public void setFieldTimeStr(String fieldTimeStr) {
        this.fieldTimeStr = fieldTimeStr == null ? null : fieldTimeStr.trim();
    }

    public Date getFieldStartTime() {
        return fieldStartTime;
    }

    public void setFieldStartTime(Date fieldStartTime) {
        this.fieldStartTime = fieldStartTime;
    }

    public Date getFieldEndTime() {
        return fieldEndTime;
    }

    public void setFieldEndTime(Date fieldEndTime) {
        this.fieldEndTime = fieldEndTime;
    }
}