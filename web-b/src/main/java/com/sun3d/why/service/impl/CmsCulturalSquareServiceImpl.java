package com.sun3d.why.service.impl;



import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.CmsCulturalSquareMapper;
import com.sun3d.why.model.CmsCulturalSquare;
import com.sun3d.why.service.CmsCulturalSquareService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
@Service
@Transactional
public class CmsCulturalSquareServiceImpl implements CmsCulturalSquareService {
	@Autowired
    private CmsCulturalSquareMapper cmsCulturalSquareMapper;
	@Override
	public int addSquareInform(CmsCulturalSquare cmsCulturalSquare) {
		String contextDec="发布了一个<span style='color: #c49123;font-size: 24px;'># 通知  #</span>";
		cmsCulturalSquare.setContextDec(contextDec);
		cmsCulturalSquare.setPublishTime(new Date());
		cmsCulturalSquare.setSquareId(UUIDUtils.createUUId());
		cmsCulturalSquare.setOutId(cmsCulturalSquare.getSquareId());
		cmsCulturalSquare.setUserName("文化云");
		//广场通知
		cmsCulturalSquare.setType(3);
		return cmsCulturalSquareMapper.insert(cmsCulturalSquare);
	}
	@Override
	public List<CmsCulturalSquare> querySquareInformList(Pagination page,CmsCulturalSquare cmsCulturalSquare) {
		Map<String, Object> map=new HashMap<String, Object>();
		String userName = cmsCulturalSquare.getUserName();
		if (StringUtils.isNotBlank(userName)) {
			map.put("userName", userName);
		}
		String ext1 = cmsCulturalSquare.getExt1();
		if (StringUtils.isNotBlank(ext1))
			map.put("ext1", ext1);
		// 分页
		if (page != null && page.getFirstResult() != null && page.getRows() != null) {
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
			int total = cmsCulturalSquareMapper.querySquareInformCount(map);
			page.setTotal(total);
		}
		
		 List<CmsCulturalSquare> list=cmsCulturalSquareMapper.querySquareInformList(map);
		
		return list;
	}
	@Override
	public CmsCulturalSquare selectByPrimaryKey(String squareId) {
		return cmsCulturalSquareMapper.selectByPrimaryKey(squareId);
	}
	@Override
	public String updateByPrimaryKeySelective(
			CmsCulturalSquare cmsCulturalSquare) {
		int count=cmsCulturalSquareMapper.update(cmsCulturalSquare);
		if (count!=1) {
			return "failure";
		}
		return "success";
	}
	@Override
	public int deleteSquareInform(String squareId) {
		
		return cmsCulturalSquareMapper.deleteByPrimaryKey(squareId);
		
	}

}
