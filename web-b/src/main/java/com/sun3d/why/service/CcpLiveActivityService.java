package com.sun3d.why.service;

import java.util.List;

import com.culturecloud.model.bean.live.CcpLiveActivity;
import com.sun3d.why.dao.dto.CcpLiveActivityDto;
import com.sun3d.why.util.Pagination;

public interface CcpLiveActivityService {

	List<CcpLiveActivityDto> queryLiveActivityByCondition(String userId,Integer liveActivityTimeStatus,
			 Integer liveStatus,Integer liveType,Integer liveCheck,Pagination page);
	
	int updateLiveActivity(CcpLiveActivity ccpLiveActivity);
	
	CcpLiveActivity queryLiveActivityById(String liveActivityId);
	
	int addManyMessage(String liveActivityId,Integer commontNum,Integer likeNum);
}
