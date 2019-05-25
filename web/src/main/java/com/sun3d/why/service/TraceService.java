package com.sun3d.why.service;

import com.sun3d.why.common.Result;
import com.sun3d.why.model.bean.yket.YketTrace;

public interface TraceService {

	int addTrace(YketTrace trace);

	Result listTraceByUserId(String userId);

}
