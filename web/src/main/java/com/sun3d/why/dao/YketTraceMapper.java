package com.sun3d.why.dao;

import java.util.List;

import com.sun3d.why.model.bean.yket.YketTrace;
import com.sun3d.why.model.vo.yket.MyTraceInfoVo;

public interface YketTraceMapper {
	int insert(YketTrace record);

	int insertSelective(YketTrace record);

	List<MyTraceInfoVo> listTraceByUserId(String userId);
}