package com.culturecloud.service.local.common;

import com.culturecloud.model.bean.common.SysBussinessErrorLog;

public interface SysBussinessErrorLogService {

	 SysBussinessErrorLog createNewInstace(String bussinessKeyId,String errorDescription,String bussinessType);
}
