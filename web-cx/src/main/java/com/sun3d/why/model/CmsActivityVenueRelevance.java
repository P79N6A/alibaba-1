package com.sun3d.why.model;

import java.io.Serializable;

public class CmsActivityVenueRelevance implements Serializable {
    private String venueId;

    private String activityId;

    public String getVenueId() {
        return venueId;
    }

    public void setVenueId(String venueId) {
        this.venueId = venueId == null ? null : venueId.trim();
    }

    public String getActivityId() {
        return activityId;
    }

    public void setActivityId(String activityId) {
        this.activityId = activityId == null ? null : activityId.trim();
    }
}