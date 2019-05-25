package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.countyStatistics.CountyStatisticsDetail;

public interface CountyStatisticsDetailMapper {
	List<CountyStatisticsDetail> getCountyActivityStatistics(Map<String, Object> param);

	List<CountyStatisticsDetail> getCountyRoomStatistics(Map<String, Object> param);

}
