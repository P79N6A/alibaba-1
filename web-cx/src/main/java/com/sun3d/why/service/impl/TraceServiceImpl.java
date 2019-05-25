package com.sun3d.why.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sun3d.why.common.Result;
import com.sun3d.why.dao.YketTraceMapper;
import com.sun3d.why.enumeration.RSKeyEnum;
import com.sun3d.why.model.bean.yket.YketTrace;
import com.sun3d.why.service.TraceService;

@Service
public class TraceServiceImpl implements TraceService {

	@Autowired
	YketTraceMapper traceMapper;

	@Override
	public int addTrace(YketTrace trace) {
		return traceMapper.insert(trace);
	}

	@Override
	public Result listTraceByUserId(String userId) {
		return Result.Ok().setVal(RSKeyEnum.data, traceMapper.listTraceByUserId(userId));
	}
}
