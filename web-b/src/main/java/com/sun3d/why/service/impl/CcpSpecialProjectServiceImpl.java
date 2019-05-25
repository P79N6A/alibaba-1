package com.sun3d.why.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.culturecloud.model.bean.special.CcpSpecialProject;
import com.sun3d.why.dao.CcpSpecialProjectMapper;
import com.sun3d.why.model.CmsAntique;
import com.sun3d.why.service.CcpSpecialProjectService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

@Service
public class CcpSpecialProjectServiceImpl implements CcpSpecialProjectService {

	@Autowired
	private CcpSpecialProjectMapper ccpSpecialProjectMapper;

	@Override
	public List<CcpSpecialProject> queryByCondition(CcpSpecialProject project, Pagination page) {

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("projectIsDel", Constant.NORMAL);
		
		if(page!=null){
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
			
			int total = ccpSpecialProjectMapper.queryProjectCountByCondition(map);

			// 设置分页的总条数来获取总页数
			page.setTotal(total);
			page.setRows(page.getRows());
		}

		List<CcpSpecialProject> list = null;
		
		list = ccpSpecialProjectMapper.queryProjectByCondition(map);

		return list;
	}

	@Override
	public CcpSpecialProject findById(String projectId) {
		
		return ccpSpecialProjectMapper.selectByPrimaryKey(projectId);
	}

	@Override
	public int saveProject(CcpSpecialProject project) {
		
		String projectId=project.getProjectId();
		
		int result=0;
		
		if(StringUtils.isBlank(projectId))
		{
			project.setProjectId(UUIDUtils.createUUId());
			project.setProjectCreateTime(new Date());
			project.setProjectIsDel(Constant.NORMAL);
			result=ccpSpecialProjectMapper.insertSelective(project);
		}else
		{
			result=ccpSpecialProjectMapper.updateByPrimaryKeySelective(project);
		}
		
		return result;
	}

}
