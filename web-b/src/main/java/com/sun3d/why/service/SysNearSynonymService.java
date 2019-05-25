package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.SysUser;

public interface SysNearSynonymService {

	/**
	 * 导入近义词
	 * @param dataList
	 * @return
	 */
	public List<String> importSysNearSynonym(SysUser sysUser, List<List<String>> dataList);
}
