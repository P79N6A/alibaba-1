package com.sun3d.why.service.impl;

import com.alibaba.fastjson.JSONObject;
import com.sun3d.why.dao.StatisticsFlowWebMapper;
import com.sun3d.why.model.StatisticsFlowWeb;
import com.sun3d.why.service.StatisticsFlowWebService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional
public class StatisticsFlowWebServiceImpl implements StatisticsFlowWebService {

	@Autowired
	private StatisticsFlowWebMapper statisticsFlowWebMapper;
	@Override
	public String flowWebStatisticQuery(Map<String, String> map) {
		JSONObject jsonObject = new JSONObject();
		List<Map<String,String>> resultList = new ArrayList<Map<String,String>>();
		List<StatisticsFlowWeb> flowStatisticList=statisticsFlowWebMapper.queryByMap(map);
		if(flowStatisticList !=null&&flowStatisticList.size()>0){
			for(StatisticsFlowWeb bean : flowStatisticList){
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
	public String flowWebStatisticYear(Map<String, String> map) {
		JSONObject jsonObject = new JSONObject();
		List<Map<String,Object>> resultList = new ArrayList<Map<String,Object>>();
		List<Map<String,String>> flowStatisticList=statisticsFlowWebMapper.queryByMapYear(map);
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
