package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.SysBussinessErrorLog;

public interface SysBussinessErrorLogService {

	
	 SysBussinessErrorLog createNewInstace(String bussinessKeyId,String errorDescription,String bussinessType);

}
