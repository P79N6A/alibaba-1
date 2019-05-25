package com.sun3d.why.model;

import java.io.Serializable;

public class CmsTagSubRelate implements Serializable {
   
	private static final long serialVersionUID = 4404739369119626725L;

	private String tagSubId;

    private String relateId;

    private Integer type;


    public String getTagSubId() {
		return tagSubId;
	}

	public void setTagSubId(String tagSubId) {
		this.tagSubId = tagSubId;
	}

	public String getRelateId() {
        return relateId;
    }

    public void setRelateId(String relateId) {
        this.relateId = relateId == null ? null : relateId.trim();
    }

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }
}