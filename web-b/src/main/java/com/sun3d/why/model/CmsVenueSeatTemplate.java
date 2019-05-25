package com.sun3d.why.model;

import com.sun3d.why.util.Pagination;

import java.util.Date;

public class CmsVenueSeatTemplate extends Pagination{
    private String templateId;

    private String venueId;

    private String templateName;

    private Integer validCount;

    private Integer seatRow;

    private Integer seatColumn;

    private Date templateCreateTime;

    private String templateCreateUser;

    private Date templateUpdateTime;

    private String templateUpdateUser;

    private String templateDesc;

    public String getTemplateId() {
        return templateId;
    }

    public void setTemplateId(String templateId) {
        this.templateId = templateId == null ? null : templateId.trim();
    }

    public String getVenueId() {
        return venueId;
    }

    public void setVenueId(String venueId) {
        this.venueId = venueId == null ? null : venueId.trim();
    }

    public String getTemplateName() {
        return templateName;
    }

    public void setTemplateName(String templateName) {
        this.templateName = templateName == null ? null : templateName.trim();
    }

    public Integer getValidCount() {
        return validCount;
    }

    public void setValidCount(Integer validCount) {
        this.validCount = validCount;
    }

    public Integer getSeatRow() {
        return seatRow;
    }

    public void setSeatRow(Integer seatRow) {
        this.seatRow = seatRow;
    }

    public Integer getSeatColumn() {
        return seatColumn;
    }

    public void setSeatColumn(Integer seatColumn) {
        this.seatColumn = seatColumn;
    }

    public Date getTemplateCreateTime() {
        return templateCreateTime;
    }

    public void setTemplateCreateTime(Date templateCreateTime) {
        this.templateCreateTime = templateCreateTime;
    }

    public String getTemplateCreateUser() {
        return templateCreateUser;
    }

    public void setTemplateCreateUser(String templateCreateUser) {
        this.templateCreateUser = templateCreateUser == null ? null : templateCreateUser.trim();
    }

    public Date getTemplateUpdateTime() {
        return templateUpdateTime;
    }

    public void setTemplateUpdateTime(Date templateUpdateTime) {
        this.templateUpdateTime = templateUpdateTime;
    }

    public String getTemplateUpdateUser() {
        return templateUpdateUser;
    }

    public void setTemplateUpdateUser(String templateUpdateUser) {
        this.templateUpdateUser = templateUpdateUser == null ? null : templateUpdateUser.trim();
    }

    public String getTemplateDesc() {
        return templateDesc;
    }

    public void setTemplateDesc(String templateDesc) {
        this.templateDesc = templateDesc == null ? null : templateDesc.trim();
    }
}