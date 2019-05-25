package com.sun3d.why.model.volunteer;

import java.util.Date;

public class VolunteerActivityDemeanorDocumentary {
    private String uuid;

    private String OwnerId;

    private String ownerId;

    private String resourceName;

    private Integer resourceType;

    private String resourceSite;

    private Double resourceSize;

    private Date createTime;

    private String createId;

    private Date updateTime;

    private String updateId;

    private Integer status;

    public String getUuid() {
        return uuid;
    }

    public void setUuid(String uuid) {
        this.uuid = uuid == null ? null : uuid.trim();
    }

    public String getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(String ownerId) {
        this.ownerId = ownerId;
    }

    public String getResourceName() {
        return resourceName;
    }

    public void setResourceName(String resourceName) {
        this.resourceName = resourceName == null ? null : resourceName.trim();
    }

    public Integer getResourceType() {
        return resourceType;
    }

    public void setResourceType(Integer resourceType) {
        this.resourceType = resourceType;
    }

    public String getResourceSite() {
        return resourceSite;
    }

    public void setResourceSite(String resourceSite) {
        this.resourceSite = resourceSite == null ? null : resourceSite.trim();
    }

    public Double getResourceSize() {
        return resourceSize;
    }

    public void setResourceSize(Double resourceSize) {
        this.resourceSize = resourceSize;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public String getCreateId() {
        return createId;
    }

    public void setCreateId(String createId) {
        this.createId = createId == null ? null : createId.trim();
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    public String getUpdateId() {
        return updateId;
    }

    public void setUpdateId(String updateId) {
        this.updateId = updateId == null ? null : updateId.trim();
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }


}