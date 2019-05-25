package com.culturecloud.model.bean.special;

import javax.persistence.Column;

import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;

@Table(value="ccp_special_page_activity")
public class CcpSpecialPageActivity implements BaseEntity{
 
	private static final long serialVersionUID = 209610258603329992L;
	
	@Column(name="page_id")
	private String pageId;
	
	@Column(name="activity_id")
    private String activityId;
  
    public String getPageId() {
        return pageId;
    }

    public void setPageId(String pageId) {
        this.pageId = pageId == null ? null : pageId.trim();
    }

	public String getActivityId() {
		return activityId;
	}

	public void setActivityId(String activityId) {
		this.activityId = activityId;
	}


}