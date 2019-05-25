package com.sun3d.why.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sun3d.why.dao.SysDeptMapper;
import com.sun3d.why.model.SysDept;
import com.sun3d.why.model.SysDeptVo;
import com.sun3d.why.service.SysDeptService;

@Service
public class SysDeptServiceImpl implements SysDeptService{
    @Autowired
    private SysDeptMapper sysDeptMapper;

	@Override
	public SysDept selectDeptById(String areaId) {
		// TODO Auto-generated method stub
		return sysDeptMapper.querySysDeptByDeptId(areaId);
	}

	@Override
	public SysDept selectDeptByDeptCode(String deptCode) {
		// TODO Auto-generated method stub
		List<SysDept> list= sysDeptMapper.selectDeptByDeptCode(deptCode);
		if(list!=null&&list.size()>0){
			return list.get(0);
		}
		return new SysDept();
	}

	@Override
	public List<SysDept> queryAreaList(String pid, String grade) {
		// TODO Auto-generated method stub
		List<SysDept> list = new ArrayList<SysDept>();
		Map map = new HashMap();
		map.put("deptIsFromVenue", 2);
		// TODO Auto-generated method stub
		if(StringUtils.isNotBlank(grade)&&StringUtils.isBlank(pid)){
			map.put("deptRemark", grade);
		}else if(StringUtils.isNotBlank(pid)){
			map.put("deptParentId", pid);
		}
		list = sysDeptMapper.queryAreaListByMap(map);
		return list;
	}

	@Override
	public List<SysDept> getSysDeptBySysDep(SysDept sysDept) {
		// TODO Auto-generated method stub
		return sysDeptMapper.getSysDeptBySysDep(sysDept);
	}
	
	@Override
	public List<SysDept> queryAreaAllList(){
		return sysDeptMapper.queryAreaAllList();
	}
	
	@Override
	public List<SysDeptVo> queryAreaNameAndId(String pid, String grade){
				List<SysDeptVo> list = new ArrayList<SysDeptVo>();
				Map map = new HashMap();
				map.put("deptIsFromVenue", 2);
				if(StringUtils.isNotBlank(grade)&&StringUtils.isBlank(pid)){
					map.put("deptRemark", grade);
				}else if(StringUtils.isNotBlank(pid)){
					map.put("deptParentId", pid);
				}
				list = sysDeptMapper.queryAreaNameAndId(map);
				return list;
	}

}
