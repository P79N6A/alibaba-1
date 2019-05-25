package com.sun3d.why.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.CnwdEntryformCheckMapper;
import com.sun3d.why.model.cnwd.CnwdEntryformCheck;
import com.sun3d.why.service.CnwdEntryformCheckService;
@Service
@Transactional
public class CnwdEntryformCheckServiceImpl implements CnwdEntryformCheckService {

	@Autowired
	private CnwdEntryformCheckMapper cnwdEntryformCheckMapper ;
	@Override
	public CnwdEntryformCheck queryEntryformCheckById(String entryId) {
		return cnwdEntryformCheckMapper.queryByEntryId(entryId);
	}

	@Override
	public void insert(CnwdEntryformCheck cnwdEntryformCheck) {
		cnwdEntryformCheckMapper.insert(cnwdEntryformCheck);
	}

	@Override
	public void update(CnwdEntryformCheck cnwdEntryformCheck) {
		cnwdEntryformCheckMapper.updateByPrimaryKeySelective(cnwdEntryformCheck);
	}

}
