package com.culturecloud.model.response.beautycity;

import com.culturecloud.model.bean.beautycity.CcpBeautycityVenue;

public class CcpBeautycityVenueResVO extends CcpBeautycityVenue{

	private static final long serialVersionUID = 1165165614462717020L;
	
	private Integer isPublish;		//是否已发布

	public Integer getIsPublish() {
		return isPublish;
	}

	public void setIsPublish(Integer isPublish) {
		this.isPublish = isPublish;
	}

}