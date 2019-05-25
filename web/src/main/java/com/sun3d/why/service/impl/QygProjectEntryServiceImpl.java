package com.sun3d.why.service.impl;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.QygProjectEntryMapper;
import com.sun3d.why.dao.QygUserMapper;
import com.sun3d.why.dao.dto.QygProjectEntryDto;
import com.sun3d.why.model.qyg.QygProjectEntry;
import com.sun3d.why.model.qyg.QygUser;
import com.sun3d.why.service.QygProjectEntryService;
@Service
@Transactional
public class QygProjectEntryServiceImpl implements QygProjectEntryService {
	
	
	@Autowired
	private QygProjectEntryMapper entryMapper;
	@Autowired
	private QygUserMapper userMapper;

	@Override
	public List<QygProjectEntryDto> queryEntryList(QygProjectEntryDto entry) {
		return entryMapper.queryQygEntryList(entry);
	}

	@Override
	public QygProjectEntryDto queryUserById(String entryId) {
		
		return entryMapper.selectByPrimaryKey(entryId);
	}

	@Override
	public int saveQygUser(QygUser user) {
		user.setCreateTime(new Date());
		return userMapper.insertSelective(user);
	}

}
