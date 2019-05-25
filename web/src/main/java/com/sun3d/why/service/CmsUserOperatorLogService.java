package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.CmsUserOperatorLog;

public interface CmsUserOperatorLogService {

	
	 public List<CmsUserOperatorLog> queryCmsUserOperatorLogByModel(CmsUserOperatorLog model);
	 
	 public  int insert(CmsUserOperatorLog record);
}
