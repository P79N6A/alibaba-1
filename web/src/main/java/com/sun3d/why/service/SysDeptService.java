package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.SysDept;
import com.sun3d.why.model.SysDeptVo;

public interface SysDeptService{

	SysDept selectDeptById(String areaId);

	SysDept selectDeptByDeptCode(String cityNo);

	List<SysDept> queryAreaList(String pid, String grade);

	List<SysDept> getSysDeptBySysDep(SysDept sysDept);
	
	List<SysDept> queryAreaAllList();
	
	List<SysDeptVo> queryAreaNameAndId(String pid, String grade);

}
