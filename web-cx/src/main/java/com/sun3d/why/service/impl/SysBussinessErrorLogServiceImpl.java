package com.sun3d.why.service.impl;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.SysBussinessErrorLogMapper;
import com.sun3d.why.model.SysBussinessErrorLog;
import com.sun3d.why.service.SysBussinessErrorLogService;
import com.sun3d.why.util.UUIDUtils;

@Service
@Transactional
public class SysBussinessErrorLogServiceImpl implements SysBussinessErrorLogService{
	
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
		
		List<SysBussinessErrorLog> logList=sysBussinessErrorLogMapper.selectRepeatLog(log);
		
		if(logList.size()==0)
		{
			int result=sysBussinessErrorLogMapper.insert(log);
			
			if(result>0)
				return log;
		}
		
		return null;
	}

	
}
