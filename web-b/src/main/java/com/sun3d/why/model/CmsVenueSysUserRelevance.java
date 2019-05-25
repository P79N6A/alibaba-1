package com.sun3d.why.model;

import java.io.Serializable;

public class CmsVenueSysUserRelevance implements Serializable {
	
	private String venueId;
	
	private String userId;
	
	   /**
     * 权限信息(部门标示)
     */
    private String venueDept;

	public String getVenueId() {
		return venueId;
	}

	public void setVenueId(String venueId) {
		this.venueId = venueId;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getVenueDept() {
		return venueDept;
	}

	public void setVenueDept(String venueDept) {
		this.venueDept = venueDept;
	}
    
    

}
