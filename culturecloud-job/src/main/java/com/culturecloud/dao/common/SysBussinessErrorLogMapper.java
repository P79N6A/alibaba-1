package com.culturecloud.dao.common;

import java.util.List;

import com.culturecloud.dao.dto.common.SysBussinessErrorLogDto;
import com.culturecloud.model.bean.common.SysBussinessErrorLog;

public interface SysBussinessErrorLogMapper {
    
	  /**
     * 查询重复记录的日志
     * @param record
     * @return
     */
    List<SysBussinessErrorLogDto> selectRepeatLog(SysBussinessErrorLog record);
    
    int insert(SysBussinessErrorLog record);
}