package com.sun3d.why.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.culturecloud.model.bean.special.CcpSpecialEnter;
import com.sun3d.why.dao.CcpSpecialEnterMapper;
import com.sun3d.why.dao.dto.CcpSpecialEnterDto;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CcpSpecialEnterService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

@Service
public class CcpSpecialEnterServiceImpl  implements CcpSpecialEnterService{
	
	@Autowired
	private CcpSpecialEnterMapper ccpSpecialEnterMapper;

	@Override
	public List<CcpSpecialEnterDto> queryByCondition(CcpSpecialEnter enter, Pagination page) {

		Map<String, Object> map = new HashMap<String, Object>();
			
			map.put("enterIsDel", Constant.NORMAL);
			
			if (StringUtils.isNotBlank(enter.getProjectId())){
	            map.put("projectId", enter.getProjectId());
	        }
			
			if(page!=null){
				map.put("firstResult", page.getFirstResult());
				map.put("rows", page.getRows());
				
				int total = ccpSpecialEnterMapper.queryEnterCountByCondition(map);
	
				// 设置分页的总条数来获取总页数
				page.setTotal(total);
				page.setRows(page.getRows());
			}
	
			List<CcpSpecialEnterDto> list = null;
			
			list = ccpSpecialEnterMapper.queryEnterByCondition(map);
	
			return list;
	}

	@Override
	public CcpSpecialEnter findById(String enterId) {
		
		return ccpSpecialEnterMapper.selectByPrimaryKey(enterId);
	}

	@Override
	public int saveEnter(CcpSpecialEnter enter,SysUser user) {
		
		String enterId=enter.getEnterId();
		
		int result=0;
		
		if(StringUtils.isBlank(enterId))
		{
			enter.setEnterCreateUser(user.getUserId());
			enter.setEnterId(UUIDUtils.createUUId());
			enter.setEnterCreateTime(new Date());
			enter.setEnterIsDel(Constant.NORMAL);
			result=ccpSpecialEnterMapper.insertSelective(enter);
		}else
		{
			result=ccpSpecialEnterMapper.updateByPrimaryKeySelective(enter);
		}
		
		return result;
	}

}
