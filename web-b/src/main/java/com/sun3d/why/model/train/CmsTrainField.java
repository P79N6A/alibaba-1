package com.sun3d.why.model.train;

public class CmsTrainField {
    private String id;

    private String trainId;

    private String fieldTimeStr;

    private String fieldStartTime;

    private String fieldEndTime;

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

    public String getFieldStartTime() {
        return fieldStartTime;
    }

    public void setFieldStartTime(String fieldStartTime) {
        this.fieldStartTime = fieldStartTime;
    }

    public String getFieldEndTime() {
        return fieldEndTime;
    }

    public void setFieldEndTime(String fieldEndTime) {
        this.fieldEndTime = fieldEndTime;
    }
}