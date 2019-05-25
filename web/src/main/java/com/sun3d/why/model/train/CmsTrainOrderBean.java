package com.sun3d.why.model.train;

public class CmsTrainOrderBean extends CmsTrainOrder {

    private String trainTitle;

    private String trainImgUrl;

    private String trainStartTime;

    private String trainEndTime;

    private String trainAddress;

    private String queryType; //1:当前培训，2：历史培训

    private Integer admissionType;

    public Integer getAdmissionType() {
        return admissionType;
    }

    public void setAdmissionType(Integer admissionType) {
        this.admissionType = admissionType;
    }

    public String getTrainTitle() {
        return trainTitle;
    }

    public void setTrainTitle(String trainTitle) {
        this.trainTitle = trainTitle;
    }

    public String getTrainStartTime() {
        return trainStartTime;
    }

    public void setTrainStartTime(String trainStartTime) {
        this.trainStartTime = trainStartTime;
    }

    public String getTrainEndTime() {
        return trainEndTime;
    }

    public void setTrainEndTime(String trainEndTime) {
        this.trainEndTime = trainEndTime;
    }

    public String getTrainAddress() {
        return trainAddress;
    }

    public void setTrainAddress(String trainAddress) {
        this.trainAddress = trainAddress;
    }

    public String getQueryType() {
        return queryType;
    }

    public void setQueryType(String queryType) {
        this.queryType = queryType;
    }

    public String getTrainImgUrl() {
        return trainImgUrl;
    }

    public void setTrainImgUrl(String trainImgUrl) {
        this.trainImgUrl = trainImgUrl;
    }
}