package com.culturecloud.model.bean.training;

import com.culturecloud.annotations.Id;
import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;

import javax.persistence.Column;
import java.util.Date;

@Table(value="ccp_training")
public class CcpTraining  implements BaseEntity {

    private static final long serialVersionUID = -3586841584982510841L;

    @Id
    @Column(name="TRAINING_ID")
    private String trainingId;

    @Column(name="TRAINING_TITLE")
    private String trainingTitle;

    @Column(name="TRAINING_SUBTITLE")
    private String trainingSubtitle;

    @Column(name="TRAINING_IMG_URL")
    private String trainingImgUrl;

    @Column(name="TRAINING_VIDEO_URL")
    private String trainingVideoUrl;

    @Column(name="TRAINING_INTRODUCE")
    private String trainingIntroduce;

    @Column(name="SPEAKER_ID")
    private String speakerId;

    @Column(name="SPEAKER_NAME")
    private String speakerName;

    @Column(name="SPEAKER_SUBTITLE")
    private String speakerSubtitle;

    @Column(name="SPEAKER_IMG_URL")
    private String speakerImgUrl;

    @Column(name="SPEAKER_INTRODUCE")
    private String speakerIntroduce;

    @Column(name="TRAINING_STATUS")
    private Integer speakerStatus;

    @Column(name="CREATE_TIME")
    private Date createTime;

    @Column(name="CREATE_USER")
    private String createUser;

    @Column(name="UPDATE_TIME")
    private Date updateTime;

    @Column(name="UPDATE_USER")
    private String updateUser;

    public String getTrainingId() {
        return trainingId;
    }

    public void setTrainingId(String trainingId) {
        this.trainingId = trainingId;
    }

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
        this.createUser = createUser;
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
        this.updateUser = updateUser;
    }

    public Integer getSpeakerStatus() {
        return speakerStatus;
    }

    public void setSpeakerStatus(Integer speakerStatus) {
        this.speakerStatus = speakerStatus;
    }

    public String getSpeakerImgUrl() {
        return speakerImgUrl;
    }

    public void setSpeakerImgUrl(String speakerImgUrl) {
        this.speakerImgUrl = speakerImgUrl;
    }
}
