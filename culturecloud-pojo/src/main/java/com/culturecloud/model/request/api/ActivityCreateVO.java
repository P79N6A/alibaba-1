package com.culturecloud.model.request.api;

import com.culturecloud.bean.BaseRequest;

import java.util.List;

/**
 * 子平台上传活动VO
 */
public class ActivityCreateVO extends BaseRequest {


    private List<ActivityCreateApi> activityList;

    private String platSource;

    public List<ActivityCreateApi> getActivityList() {
        return activityList;
    }

    public void setActivityList(List<ActivityCreateApi> activityList) {
        this.activityList = activityList;
    }

    public String getPlatSource() {
        return platSource;
    }

    public void setPlatSource(String platSource) {
        this.platSource = platSource;
    }
}
