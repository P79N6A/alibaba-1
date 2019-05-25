package com.sun3d.why.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.culturecloud.model.bean.special.CcpSpecialPage;
import com.culturecloud.model.bean.special.CcpSpecialPageActivity;
import com.sun3d.why.dao.CcpSpecialPageMapper;
import com.sun3d.why.dao.dto.CcpSpecialPageDto;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CcpSpecialPageService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

@Service
public class CcpSpecialPageServiceImpl implements CcpSpecialPageService {

	@Autowired
	private CcpSpecialPageMapper ccpSpecialPageMapper;
	@Autowired
    private HttpSession session;

	@Override
	public List<CcpSpecialPageDto> queryByCondition(CcpSpecialPage entity, Pagination page) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pageIsDel", Constant.NORMAL);
		if (StringUtils.isNotBlank(entity.getPageName())){
            map.put("pageName", "%" + entity.getPageName() + "%");
        }
		if (StringUtils.isNotBlank(entity.getProjectId())){
            map.put("projectId", entity.getProjectId());
        }
		if(page!=null){
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
			int total = ccpSpecialPageMapper.queryPageCountByCondition(map);
			// 设置分页的总条数来获取总页数
			page.setTotal(total);
			page.setRows(page.getRows());
		}
		return ccpSpecialPageMapper.queryPageByCondition(map);
	}

	@Override
	public CcpSpecialPage findById(String pageId) {
		return ccpSpecialPageMapper.selectByPrimaryKey(pageId);
	}

	@Override
	public int saveOrUpdatePage(CcpSpecialPage entity) {
		String pageId=entity.getPageId();
		int result=0;
		SysUser sysUser = (SysUser) session.getAttribute("user");
		if(sysUser!=null){
			if(StringUtils.isBlank(pageId)){
				entity.setPageId(UUIDUtils.createUUId());
				entity.setPageCreateTime(new Date());
				entity.setPageIsDel(Constant.NORMAL);
				entity.setPageCreateUser(sysUser.getUserId());
				result=ccpSpecialPageMapper.insert(entity);
			}else{
				result=ccpSpecialPageMapper.update(entity);
			}
		}
		return result;
	}

	@Override
	public int savePageActivity(CcpSpecialPageActivity entity,String activityIds) {
		int result = 1;
		if (activityIds!=null) {
			for(String activityId : activityIds.split(",")){
				entity.setActivityId(activityId);
				if(ccpSpecialPageMapper.insertActivity(entity)<=0){
					result = 0;
				}
			};
		}
		return result;
	}

	@Override
	public int deletePageActivity(CcpSpecialPageActivity entity) {
		return ccpSpecialPageMapper.deleteActivityByPrimaryKey(entity);
	}
}
