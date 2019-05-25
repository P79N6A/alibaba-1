package com.sun3d.why.model;

public class CmsActivityTemplateRel {
    private String templId;

    private String funId;

    public String getTemplId() {
        return templId;
    }

    public void setTemplId(String templId) {
        this.templId = templId == null ? null : templId.trim();
    }

    public String getFunId() {
        return funId;
    }

    public void setFunId(String funId) {
        this.funId = funId == null ? null : funId.trim();
    }
}