package com.sun3d.why.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.model.bean.drama.CcpDrama;
import com.sun3d.why.dao.CcpDramaMapper;
import com.sun3d.why.service.CcpDramaService;

@Service
@Transactional
public class CcpDramaServiceImpl implements CcpDramaService{
	
	@Autowired
	private CcpDramaMapper ccpDramaMapper;

	@Override
	public List<CcpDrama> getAllCcpDrama() {
	
		return ccpDramaMapper.selecAllCcpDrama();
	}

}
