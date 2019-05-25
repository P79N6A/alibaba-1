package com.culturecloud.service.local.impl.common;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.coreutils.UUIDUtils;
import com.culturecloud.dao.common.SysBussinessErrorLogMapper;
import com.culturecloud.dao.dto.common.SysBussinessErrorLogDto;
import com.culturecloud.model.bean.common.SysBussinessErrorLog;
import com.culturecloud.service.local.common.SysBussinessErrorLogService;

@Service
@Transactional
public class SysBussinessErrorLogServiceImpl implements SysBussinessErrorLogService {

	@Autowired
	private SysBussinessErrorLogMapper sysBussinessErrorLogMapper;

	@Override
	@Transactional(isolation=Isolation.SERIALIZABLE)
	public SysBussinessErrorLog createNewInstace(String bussinessKeyId, String errorDescription, String bussinessType) {
		
		SysBussinessErrorLog log=new SysBussinessErrorLog();
		log.setErrorLogId(UUIDUtils.createUUId());
		log.setCreateTime(new Date());
		log.setBussinessKeyId(bussinessKeyId);
		log.setErrorDescription(errorDescription);
		log.setBussinessType(bussinessType);
		
		List<SysBussinessErrorLogDto> logList=sysBussinessErrorLogMapper.selectRepeatLog(log);
		
		if(logList.size()==0)
		{
			int result=sysBussinessErrorLogMapper.insert(log);
			
			if(result>0)
				return log;
		}
		
		return null;
	}


}
