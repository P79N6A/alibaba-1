package com.sun3d.why.service.impl;

import com.alibaba.fastjson.JSONObject;
import com.sun3d.why.dao.StatisticsFlowWapMapper;
import com.sun3d.why.model.StatisticsFlowWap;
import com.sun3d.why.service.StatisticsFlowWapService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional
public class StatisticsFlowWapServiceImpl implements StatisticsFlowWapService {
	
	@Autowired
	private StatisticsFlowWapMapper statisticsFlowWapMapper;
	
	@Override
	public String flowWapStatisticQuery(Map<String, String> map) {
		JSONObject jsonObject = new JSONObject();
		List<Map<String,String>> resultList = new ArrayList<Map<String,String>>();
		List<StatisticsFlowWap> flowStatisticList=statisticsFlowWapMapper.queryByMap(map);
		if(flowStatisticList !=null&&flowStatisticList.size()>0){
			for(StatisticsFlowWap bean : flowStatisticList){
				Map<String,String> result = new HashMap<String,String>();
				result.put("time",bean.getDate());
				result.put("pvcount", bean.getPv().toString());
				result.put("uvcount", bean.getUv().toString());
				result.put("ipcount", bean.getIp().toString());
				resultList.add(result);
			}
		}
		jsonObject.put("resultList", resultList);
		return jsonObject.toJSONString();
	}

	@Override
	public String flowWapStatisticYear(Map<String, String> map) {
		JSONObject jsonObject = new JSONObject();
		List<Map<String,Object>> resultList = new ArrayList<Map<String,Object>>();
		List<Map<String,String>> flowStatisticList=statisticsFlowWapMapper.queryByMapYear(map);
		if(flowStatisticList !=null&&flowStatisticList.size()>0){
			for(Map<String,String> bean : flowStatisticList){
				Map<String,Object> result = new HashMap<String,Object>();
				result.put("time",bean.get("time").toString());
				result.put("pvcount",bean.get("pvcount"));
				result.put("uvcount", bean.get("uvcount"));
				result.put("ipcount", bean.get("ipcount"));
				resultList.add(result);
			}
		}
		jsonObject.put("resultList", resultList);
		return jsonObject.toJSONString();
	}

}
