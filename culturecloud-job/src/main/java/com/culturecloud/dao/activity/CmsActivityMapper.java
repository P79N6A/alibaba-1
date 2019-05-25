package com.culturecloud.dao.activity;

import com.culturecloud.dao.dto.activity.CmsActivityDto;
import com.culturecloud.model.bean.activity.CmsActivity;

public interface CmsActivityMapper {

	
	 CmsActivityDto queryCmsActivityByActivityId(String activityId);
	 
		CmsActivity selectByPrimaryKey(String activityId);

}
