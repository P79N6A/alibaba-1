package com.sun3d.why.service;

import java.util.Map;

public interface StatisticsFlowWebService {
	
	String flowWebStatisticQuery(Map<String, String> map);

	String flowWebStatisticYear(Map<String, String> map);

}
