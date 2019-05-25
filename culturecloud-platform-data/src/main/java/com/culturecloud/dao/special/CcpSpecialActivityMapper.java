package com.culturecloud.dao.special;

import java.util.List;

import com.culturecloud.model.response.special.SpecActivityByPageResVO;

public interface CcpSpecialActivityMapper {

	
	/** 根据PageId获取活动列表数据*/
	List<SpecActivityByPageResVO> getActivityListByPage(String pageId);
	
}
