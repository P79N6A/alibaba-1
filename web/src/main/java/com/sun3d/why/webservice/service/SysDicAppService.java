package com.sun3d.why.webservice.service;

import com.sun3d.why.model.SysDict;

import java.util.List;

public interface SysDicAppService {
	
	/**
	 * app根据字典id查询字典
	 * @param dictId
	 * @return
	 */
	public SysDict queryAppSysDictByDictId(String dictId);

	public List<SysDict> queryAllArea();


}
