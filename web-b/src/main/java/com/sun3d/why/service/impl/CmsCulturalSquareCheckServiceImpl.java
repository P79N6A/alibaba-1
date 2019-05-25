package com.sun3d.why.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.model.bean.square.CmsCulturalSquare;
import com.sun3d.why.dao.CmsCulturalSquareCheckMapper;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CmsCulturalSquareCheckService;
import com.sun3d.why.util.Pagination;
@Service
@Transactional
public class CmsCulturalSquareCheckServiceImpl implements CmsCulturalSquareCheckService {
	@Autowired
    private CmsCulturalSquareCheckMapper cmsCulturalSquareMapper;
	
	@Autowired
    private StaticServer staticServer;
	
	@Override
	public List<CmsCulturalSquare> querySquareList(Pagination page,
			CmsCulturalSquare cmsCulturalSquare) {
		Map<String, Object> map=new HashMap<String, Object>();
		// 用户名
		String userName = cmsCulturalSquare.getUserName();
		if(StringUtils.isNotBlank(userName)){
			map.put("userName",	"%"+userName+"%");
		}
		// 发布类型
		Integer type = cmsCulturalSquare.getType();
		
		if(type == null){
			map.put("type", 6);
		}
		
		String ext2 = cmsCulturalSquare.getExt2();
		
		if(type != null){
			map.put("type", type);
			if(type == 2 && StringUtils.isNotBlank(ext2)){
				map.put("ext2", ext2);
			}
		}
		
		// 审核状态
		Integer status = cmsCulturalSquare.getStatus();
	
		if(status != null) {
			map.put("status", status);
		}
		
		// 白名单
		Integer whiteList = cmsCulturalSquare.getWhiteList();
		
		if(whiteList != null){
           map.put("whiteList",whiteList);			
		}
		 // 分页
		if (page != null && page.getFirstResult() != null && page.getRows() != null) {
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
			int total = cmsCulturalSquareMapper.querySquareCheckCount(map);
			page.setTotal(total);
		}
				
		List<CmsCulturalSquare> list=cmsCulturalSquareMapper.querySquareCheckList(map);
		
		String ext0 = null;
		
		for (CmsCulturalSquare cm : list) {
			
			ext0 = cm.getExt0();
			
			if (StringUtils.isNotBlank(ext0)) {
	        	if(cm.getExt0().indexOf("http:")>-1)
	        		ext0 = cm.getExt0();
	        	else
	        		ext0 = staticServer.getStaticServerUrl() + cm.getExt0();
	        }
			cm.setExt0(ext0);
		}
		return list;
	}

	@Override
	public int setMessageTop(CmsCulturalSquare cmsCulturalSquare,
			SysUser sysUser) {
		int result = 1;
		try {
			
			CmsCulturalSquare m= cmsCulturalSquareMapper.selectByPrimaryKey( cmsCulturalSquare.getSquareId());
			
			if(m.getTop()!=null&&m.getTop()==0)
			{
				m.setTop(1);
				if(m.getTop() == 1){
					m.setTop(0);
					cmsCulturalSquareMapper.update(m);
				}
				m.setTop(1);
				return cmsCulturalSquareMapper.updateByPrimaryKeySelective(m);
			}
			
			if(m.getTop()!=null&&m.getTop()==1)
			{
				m.setTop(0);
				return cmsCulturalSquareMapper.updateByPrimaryKeySelective(m);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
		return result;
	}

	@Override
	public CmsCulturalSquare queryCulturalSquareById(String squareId) {
		return cmsCulturalSquareMapper.selectByPrimaryKey(squareId);
	}

	@Override
	public int update(CmsCulturalSquare cmsCulturalSquare) {
		return cmsCulturalSquareMapper.updateByPrimaryKeySelective(cmsCulturalSquare);
	}

}
