package com.culturecloud.model.request.training;

import com.culturecloud.bean.BasePageRequest;


public class CcpTrainingVO extends BasePageRequest {
    private String trainingId;

    private String trainingTitle;

    private String trainingSubtitle;

    private String trainingImgUrl;

    private String trainingVideoUrl;

    private String trainingIntroduce;

    private Integer trainingStatus;

    private String speakerId;

    private String speakerName;

    private String speakerSubtitle;

    private String speakerImgUrl;

    private String speakerIntroduce;

    private String createUser;

    private String updateUser;

    public String getTrainingTitle() {
        return trainingTitle;
    }

    public void setTrainingTitle(String trainingTitle) {
        this.trainingTitle = trainingTitle;
    }

    public String getTrainingSubtitle() {
        return trainingSubtitle;
    }

    public void setTrainingSubtitle(String trainingSubtitle) {
        this.trainingSubtitle = trainingSubtitle;
    }

    public String getTrainingImgUrl() {
        return trainingImgUrl;
    }

    public void setTrainingImgUrl(String trainingImgUrl) {
        this.trainingImgUrl = trainingImgUrl;
    }

    public String getTrainingVideoUrl() {
        return trainingVideoUrl;
    }

    public void setTrainingVideoUrl(String trainingVideoUrl) {
        this.trainingVideoUrl = trainingVideoUrl;
    }

    public String getTrainingIntroduce() {
        return trainingIntroduce;
    }

    public void setTrainingIntroduce(String trainingIntroduce) {
        this.trainingIntroduce = trainingIntroduce;
    }

    public String getSpeakerId() {
        return speakerId;
    }

    public void setSpeakerId(String speakerId) {
        this.speakerId = speakerId;
    }

    public String getSpeakerName() {
        return speakerName;
    }

    public void setSpeakerName(String speakerName) {
        this.speakerName = speakerName;
    }

    public String getSpeakerSubtitle() {
        return speakerSubtitle;
    }

    public void setSpeakerSubtitle(String speakerSubtitle) {
        this.speakerSubtitle = speakerSubtitle;
    }

    public String getSpeakerIntroduce() {
        return speakerIntroduce;
    }

    public void setSpeakerIntroduce(String speakerIntroduce) {
        this.speakerIntroduce = speakerIntroduce;
    }

    public String getCreateUser() {
        return createUser;
    }

    public void setCreateUser(String createUser) {
        this.createUser = createUser;
    }

    public String getUpdateUser() {
        return updateUser;
    }

    public void setUpdateUser(String updateUser) {
        this.updateUser = updateUser;
    }

    public String getTrainingId() {
        return trainingId;
    }

    public void setTrainingId(String trainingId) {
        this.trainingId = trainingId;
    }

    public Integer getTrainingStatus() {
        return trainingStatus;
    }

    public void setTrainingStatus(Integer trainingStatus) {
        this.trainingStatus = trainingStatus;
    }


    public String getSpeakerImgUrl() {
        return speakerImgUrl;
    }

    public void setSpeakerImgUrl(String speakerImgUrl) {
        this.speakerImgUrl = speakerImgUrl;
    }
}
