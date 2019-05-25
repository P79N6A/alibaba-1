package com.sun3d.why.model.volunteer;



import java.util.Date;

public class VolunteerRelation {
    private String uuid;  //主键

    private String volunteerActivityId;  //招募活动主键

    private String volunteerId;  //志愿者id

    private Integer status;   //状态 1:未审核 2:正常 3:驳回 9:删除

    private Date createTime;

    private String createId;

    private Date updateTime;

    private String updateId;

    public String getUuid() {
        return uuid;
    }

    public void setUuid(String uuid) {
        this.uuid = uuid == null ? null : uuid.trim();
    }

    public String getVolunteerActivityId() {
        return volunteerActivityId;
    }

    public void setVolunteerActivityId(String volunteerActivityId) {
        this.volunteerActivityId = volunteerActivityId == null ? null : volunteerActivityId.trim();
    }

    public String getVolunteerId() {
        return volunteerId;
    }

    public void setVolunteerId(String volunteerId) {
        this.volunteerId = volunteerId == null ? null : volunteerId.trim();
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
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
}