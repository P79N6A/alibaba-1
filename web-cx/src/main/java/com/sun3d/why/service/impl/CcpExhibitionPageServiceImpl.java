package com.sun3d.why.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sun3d.why.dao.ccp.CcpExhibitionPageMapper;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.ccp.CcpExhibitionPage;
import com.sun3d.why.service.CcpExhibitionPageService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

@Service
public class CcpExhibitionPageServiceImpl implements CcpExhibitionPageService{

	@Autowired
	private CcpExhibitionPageMapper exhibitionPageMapper;
	
	@Override
	public List<CcpExhibitionPage> queryCcpExhibitionPage(String exhibitionId, Pagination page) {
		
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("pageIsDel", 1);
		map.put("exhibitionId", exhibitionId);

		// 分页
		if (page != null && page.getFirstResult() != null && page.getRows() != null) {
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
			int total = exhibitionPageMapper.queryCcpExhibitionPageCountByCondition(map);
			page.setTotal(total);
		}

		 List<CcpExhibitionPage> list=exhibitionPageMapper.queryCcpExhibitionPageListByCondition(map);
		
		return list;
	}


	@Override
	public Integer deleteExhibition(String pageId, SysUser loginUser) {
		
		return exhibitionPageMapper.deleteByPrimaryKey(pageId);
		
	}


	@Override
	public Integer saveExhibitionPage(CcpExhibitionPage exhibition ,String exhibitionId , SysUser user,Integer pageType) {
		int result=0;
		String PageId=exhibition.getPageId();
		if(StringUtils.isBlank(PageId)){
			exhibition.setPageId(UUIDUtils.createUUId());
			exhibition.setCreateUser(user.getUserNickName());
			exhibition.setExhibitionId(exhibitionId);
			exhibition.setCreateTime(new Date());
			exhibition.setPageContent(exhibition.getPageContent());
			exhibition.setPageIsDel(1);
			exhibition.setPageType(pageType);
			Integer pageSort = exhibitionPageMapper.queryCcpExhibitionPageSort(exhibitionId);
			if(pageSort==null){
				pageSort=1;
			}else {
				pageSort++;
			}
			exhibition.setPageSort(pageSort);
			result=exhibitionPageMapper.insert(exhibition);
		}
		return result;
		
	}

	@Override
	public Integer updateExhibitionPage(CcpExhibitionPage exhibition,
			SysUser loginUser) {
		return exhibitionPageMapper.update(exhibition);
	}
	


	@Override
	public CcpExhibitionPage queryExhibitionPage(String pageId) {
		return exhibitionPageMapper.selectByPrimaryKey(pageId);
	}

@Override
public int moveExhibition(String pageId, Integer moveType) {
		int result = 0;

		CcpExhibitionPage page = exhibitionPageMapper.selectByPrimaryKey(pageId);

		Map<String, Object> map = new HashMap<String, Object>();

		String exhibitionId = page.getExhibitionId();

		map.put("pageIsDel", 1);
		map.put("exhibitionId", exhibitionId);

		List<CcpExhibitionPage> list = exhibitionPageMapper.queryCcpExhibitionPageListByCondition(map);

		CcpExhibitionPage changePage = null;

		for (int i = 0; i < list.size(); i++) {

			CcpExhibitionPage exhibitionPage = list.get(i);

			if (exhibitionPage.getPageId().equals(pageId)) {
				// 上移
				if (i == 0 && moveType == 1)
					break;
				// 下移
				else if (i == list.size() - 1 && moveType == 2)
					break;

				if (moveType == 1)
					changePage = list.get(i - 1);
				else
					changePage = list.get(i + 1);

				Integer sort = page.getPageSort();
				Integer changeSort=changePage.getPageSort();
						
				page.setPageSort(0);
				result = exhibitionPageMapper.update(page);
				changePage.setPageSort(sort);

				result = exhibitionPageMapper.update(changePage);
				
				if (result > 0){
					page.setPageSort(changeSort);
					result = exhibitionPageMapper.update(page);
					return result;
				}
			}

		}

		return 0;
	}

}
