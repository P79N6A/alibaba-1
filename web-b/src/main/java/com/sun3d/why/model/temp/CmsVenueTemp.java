package com.sun3d.why.model.temp;

import com.sun3d.why.util.Pagination;

import java.io.Serializable;
import java.util.Date;

public class CmsVenueTemp extends Pagination implements Serializable {
    private String venueId;

    private String venueName;

    private String venueIconUrl;

    private String venueDetailUrl;

    private String venueAddress;

    private String venueTel;

    private String venueArea;

    private Date venueCreateTime;

    private Date venueUpdateTime;

    private String venueCreateUser;

    private String venueUpdateUser;

    public String getVenueId() {
        return venueId;
    }

    public void setVenueId(String venueId) {
        this.venueId = venueId == null ? null : venueId.trim();
    }

    public String getVenueName() {
        return venueName;
    }

    public void setVenueName(String venueName) {
        this.venueName = venueName == null ? null : venueName.trim();
    }

    public String getVenueIconUrl() {
        return venueIconUrl;
    }

    public void setVenueIconUrl(String venueIconUrl) {
        this.venueIconUrl = venueIconUrl == null ? null : venueIconUrl.trim();
    }

    public String getVenueDetailUrl() {
        return venueDetailUrl;
    }

    public void setVenueDetailUrl(String venueDetailUrl) {
        this.venueDetailUrl = venueDetailUrl == null ? null : venueDetailUrl.trim();
    }

    public String getVenueAddress() {
        return venueAddress;
    }

    public void setVenueAddress(String venueAddress) {
        this.venueAddress = venueAddress == null ? null : venueAddress.trim();
    }

    public String getVenueTel() {
        return venueTel;
    }

    public void setVenueTel(String venueTel) {
        this.venueTel = venueTel == null ? null : venueTel.trim();
    }

    public String getVenueArea() {
        return venueArea;
    }

    public void setVenueArea(String venueArea) {
        this.venueArea = venueArea == null ? null : venueArea.trim();
    }

    public Date getVenueCreateTime() {
        return venueCreateTime;
    }

    public void setVenueCreateTime(Date venueCreateTime) {
        this.venueCreateTime = venueCreateTime;
    }

    public Date getVenueUpdateTime() {
        return venueUpdateTime;
    }

    public void setVenueUpdateTime(Date venueUpdateTime) {
        this.venueUpdateTime = venueUpdateTime;
    }

    public String getVenueCreateUser() {
        return venueCreateUser;
    }

    public void setVenueCreateUser(String venueCreateUser) {
        this.venueCreateUser = venueCreateUser == null ? null : venueCreateUser.trim();
    }

    public String getVenueUpdateUser() {
        return venueUpdateUser;
    }

    public void setVenueUpdateUser(String venueUpdateUser) {
        this.venueUpdateUser = venueUpdateUser == null ? null : venueUpdateUser.trim();
    }
}