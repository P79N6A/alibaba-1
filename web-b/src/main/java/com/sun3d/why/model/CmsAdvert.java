package com.sun3d.why.model;

import java.io.Serializable;
import java.util.Date;

public class CmsAdvert implements Serializable {
    private String advertId;

    private String advertTitle;

    private String advertContent;

    private Integer advertType;

    private String advertSite;

    private String advertColumn;

    private String advertPos;

    public String getDictName() {
        return dictName;
    }

    public void setDictName(String dictName) {
        this.dictName = dictName;
    }

    private String advertPicUrl;

    private String advertPicSite;

    private String advertSizeWidth;

    private String advertSizeHeight;

    private String advertConnectUrl;

    private Integer advertConnectTarget;

    private String advertCreateUser;

    private Date advertCreateTime;

    private String advertUpdateUser;

    private Date advertUpdateTime;

    private Integer advertState;

    private Integer advertIsDel;

    private Integer advertPosSort;

    //广告栏目
    private String advertRecDes;
    private  String dictName;

    private String advertAdress;

    private Integer isRecommendType;

    private Date activityTime;

    private Date recommendTime;

    private String activityId;

    private String displayPosition;

    private Date activityEndTime;

    private int activityIsReservation;

    private int availableCount;

    private String advertDescribe;

    public int getActivityIsReservation() {
        return activityIsReservation;
    }

    public void setActivityIsReservation(int activityIsReservation) {
        this.activityIsReservation = activityIsReservation;
    }

    public int getAvailableCount() {
        return availableCount;
    }

    public void setAvailableCount(int availableCount) {
        this.availableCount = availableCount;
    }

    public Date getActivityEndTime() {
        return activityEndTime;
    }

    public void setActivityEndTime(Date activityEndTime) {
        this.activityEndTime = activityEndTime;
    }

    public String getDisplayPosition() {
        return displayPosition;
    }

    public void setDisplayPosition(String displayPosition) {
        this.displayPosition = displayPosition;
    }

    public String getActivityId() {
        return activityId;
    }

    public void setActivityId(String activityId) {
        this.activityId = activityId;
    }

    public String getAdvertId() {
        return advertId;
    }



    public void setAdvertId(String advertId) {
        this.advertId = advertId == null ? null : advertId.trim();
    }

    public String getAdvertTitle() {
        return advertTitle;
    }

    public void setAdvertTitle(String advertTitle) {
        this.advertTitle = advertTitle == null ? null : advertTitle.trim();
    }

    public String getAdvertContent() {
        return advertContent;
    }

    public void setAdvertContent(String advertContent) {
        this.advertContent = advertContent == null ? null : advertContent.trim();
    }

    public Integer getAdvertType() {
        return advertType;
    }

    public void setAdvertType(Integer advertType) {
        this.advertType = advertType;
    }

    public String getAdvertSite() {
        return advertSite;
    }

    public void setAdvertSite(String advertSite) {
        this.advertSite = advertSite == null ? null : advertSite.trim();
    }

    public String getAdvertColumn() {
        return advertColumn;
    }

    public void setAdvertColumn(String advertColumn) {
        this.advertColumn = advertColumn == null ? null : advertColumn.trim();
    }

    public String getAdvertPos() {
        return advertPos;
    }

    public void setAdvertPos(String advertPos) {
        this.advertPos = advertPos == null ? null : advertPos.trim();
    }

    public String getAdvertPicUrl() {
        return advertPicUrl;
    }

    public void setAdvertPicUrl(String advertPicUrl) {
        this.advertPicUrl = advertPicUrl == null ? null : advertPicUrl.trim();
    }

    public String getAdvertPicSite() {
        return advertPicSite;
    }

    public void setAdvertPicSite(String advertPicSite) {
        this.advertPicSite = advertPicSite == null ? null : advertPicSite.trim();
    }

    public String getAdvertSizeWidth() {
        return advertSizeWidth;
    }

    public void setAdvertSizeWidth(String advertSizeWidth) {
        this.advertSizeWidth = advertSizeWidth == null ? null : advertSizeWidth.trim();
    }

    public String getAdvertSizeHeight() {
        return advertSizeHeight;
    }

    public void setAdvertSizeHeight(String advertSizeHeight) {
        this.advertSizeHeight = advertSizeHeight == null ? null : advertSizeHeight.trim();
    }

    public String getAdvertConnectUrl() {
        return advertConnectUrl;
    }

    public void setAdvertConnectUrl(String advertConnectUrl) {
        this.advertConnectUrl = advertConnectUrl == null ? null : advertConnectUrl.trim();
    }

    public Integer getAdvertConnectTarget() {
        return advertConnectTarget;
    }

    public void setAdvertConnectTarget(Integer advertConnectTarget) {
        this.advertConnectTarget = advertConnectTarget;
    }

    public String getAdvertCreateUser() {
        return advertCreateUser;
    }

    public void setAdvertCreateUser(String advertCreateUser) {
        this.advertCreateUser = advertCreateUser == null ? null : advertCreateUser.trim();
    }

    public Date getAdvertCreateTime() {
        return advertCreateTime;
    }

    public void setAdvertCreateTime(Date advertCreateTime) {
        this.advertCreateTime = advertCreateTime;
    }

    public String getAdvertUpdateUser() {
        return advertUpdateUser;
    }

    public void setAdvertUpdateUser(String advertUpdateUser) {
        this.advertUpdateUser = advertUpdateUser == null ? null : advertUpdateUser.trim();
    }

    public Date getAdvertUpdateTime() {
        return advertUpdateTime;
    }

    public void setAdvertUpdateTime(Date advertUpdateTime) {
        this.advertUpdateTime = advertUpdateTime;
    }

    public Integer getAdvertState() {
        return advertState;
    }

    public void setAdvertState(Integer advertState) {
        this.advertState = advertState;
    }

    public Integer getAdvertIsDel() {
        return advertIsDel;
    }

    public void setAdvertIsDel(Integer advertIsDel) {
        this.advertIsDel = advertIsDel;
    }

    public Integer getAdvertPosSort() {
        return advertPosSort;
    }

    public void setAdvertPosSort(Integer advertPosSort) {
        this.advertPosSort = advertPosSort;
    }

    public String getAdvertRecDes() {
        return advertRecDes;
    }

    public void setAdvertRecDes(String advertRecDes) {
        this.advertRecDes = advertRecDes;
    }

    public String getAdvertAdress() {
        return advertAdress;
    }

    public void setAdvertAdress(String advertAdress) {
        this.advertAdress = advertAdress;
    }

    public Integer getIsRecommendType() {
        return isRecommendType;
    }

    public void setIsRecommendType(Integer isRecommendType) {
        this.isRecommendType = isRecommendType;
    }

    public Date getActivityTime() {
        return activityTime;
    }

    public void setActivityTime(Date activityTime) {
        this.activityTime = activityTime;
    }

    public Date getRecommendTime() {
        return recommendTime;
    }

    public void setRecommendTime(Date recommendTime) {
        this.recommendTime = recommendTime;
    }

    public String getAdvertDescribe() {
        return advertDescribe;
    }

    public void setAdvertDescribe(String advertDescribe) {
        this.advertDescribe = advertDescribe;
    }
}