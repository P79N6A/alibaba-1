package com.sun3d.why.webservice.service.impl;

import com.sun3d.why.dao.SysDictMapper;
import com.sun3d.why.model.SysDict;
import com.sun3d.why.webservice.service.SysDicAppService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
@Transactional
public class SysDicAppServiceImpl implements SysDicAppService {
	
	@Autowired
    private SysDictMapper sysDictMapper;

	String[] list = {"46", "48", "52", "50", "49", "51", "53", "54", "58", "56", "57", "60", "61", "55", "59", "63", "64"};
		
	public SysDict queryAppSysDictByDictId(String dictId) {
		return sysDictMapper.querySysDictByDictId(dictId);
	}

	@Override
	public List<SysDict> queryAllArea() {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", list);
		return sysDictMapper.queryAllArea(map);
	}
}
