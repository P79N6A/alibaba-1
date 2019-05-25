package com.sun3d.why.statistics.service;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.countyStatistics.CountyStatisticsDetail;

public interface CountyStatisticsService {
	List<CountyStatisticsDetail> getCountyActivityStatistics(Map<String, Object> param);

	List<CountyStatisticsDetail> getCountyRoomStatistics(Map<String, Object> param);
	boolean isUserRoleExist(String roleName, String userId);

}
