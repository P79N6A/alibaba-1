package com.sun3d.why.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.culturecloud.model.bean.contest.CcpContestTopic;
import com.sun3d.why.dao.ccp.CcpExhibitionMapper;
import com.sun3d.why.dao.ccp.CcpExhibitionPageMapper;
import com.sun3d.why.dao.dto.CcpContestTopicQuestionDto;
import com.sun3d.why.enumeration.contest.CcpContestTopicStatusEnum;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.ccp.CcpExhibition;
import com.sun3d.why.model.ccp.CcpExhibitionPage;
import com.sun3d.why.service.CcpExhibitionService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
@Service
@Transactional
public class CcpExhibitionServiceImpl implements CcpExhibitionService {
	
	@Autowired
	private CcpExhibitionMapper ccpExhibitionMapper;
	@Autowired
	private CcpExhibitionPageMapper ccpExhibitionPageMapper;

	@Override
	public List<CcpExhibition> queryCcpExhibition(CcpExhibition exhibition,
			Pagination page) {
        Map<String, Object> map = new HashMap<String, Object>();
		
        if(StringUtils.isNoneBlank(exhibition.getExhibitionHead())){
        	map.put("exhibitionHead", exhibition.getExhibitionHead());
        }
		
		if(exhibition.getCreateUser()!=null){
			map.put("createUser", exhibition.getCreateUser());
		}
		
		  //分页
       if (page != null && page.getFirstResult() != null && page.getRows() != null) {
	     map.put("firstResult", page.getFirstResult());
         map.put("rows", page.getRows());
       //  int total = contestTopicMappper.queryCmsActivityCountByCondition(map);
         int total = ccpExhibitionMapper.queryExhibitionListByCondition(map);
         page.setTotal(total);
       }
       
       List<CcpExhibition> exhibitionList=ccpExhibitionMapper.queryCcpExhibitionListByCondition(map);
		
		return exhibitionList;
	}

	@Override
	public CcpExhibition queryFrontExhibition(String exhibitionId) {
		CcpExhibition ccpExhibition = ccpExhibitionMapper.selectByPrimaryKey(exhibitionId);
		
		Map<String, Object> map = new HashMap<String, Object>();
		if(StringUtils.isNotBlank(exhibitionId)){
			map.put("exhibitionId", exhibitionId);
		}
		List<CcpExhibitionPage> exhibitionPageList = ccpExhibitionPageMapper.queryCcpExhibitionPageListByCondition(map);
		ccpExhibition.setExhibitionPageList(exhibitionPageList);
		return ccpExhibition;
	}

	@Override
	public CcpExhibition queryCcpExhibitionById(String exhibitionId) {
		 
		return ccpExhibitionMapper.selectByPrimaryKey(exhibitionId);
	}

	@Override
	public int saveExhibition(CcpExhibition exhibition,SysUser user) {
		int result=0;
		String exhibitionId=exhibition.getExhibitionId();
		if(StringUtils.isBlank(exhibitionId)){
			exhibition.setExhibitionId(UUIDUtils.createUUId());
			exhibition.setCreateUser(user.getUserId());
			exhibition.setUpdateUser(user.getUserId());
			exhibition.setExhibitionIsDel(1);
			exhibition.setCreateTime(new Date());
			exhibition.setUpdateTime(new Date());
			
			result=ccpExhibitionMapper.insert(exhibition);
		}
		return result;
		
	}

	@Override
	public int deleteExhibition(String exhibitionId, SysUser loginUser) {
       
		return ccpExhibitionMapper.deleteByPrimaryKey(exhibitionId);
	}

	@Override
	public List<CcpExhibition> queryCcpManagerExhibition(String exhibitionId,
			Pagination page) {
        Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("exhibitionId", exhibitionId);
		  //分页
	     if (page != null && page.getFirstResult() != null && page.getRows() != null) {
		     map.put("firstResult", page.getFirstResult());
	       map.put("rows", page.getRows());
	       int total = ccpExhibitionMapper.queryCcpManagerExhibitionCount(map);
	       page.setTotal(total);
	     }
     
	     List<CcpExhibition> exhibitionList=ccpExhibitionMapper.queryManagerExhibition(map);
	
	     return exhibitionList;
	}

	@Override
	public int update(CcpExhibition exhibition,SysUser user) {
		exhibition.setUpdateTime(new Date());
		exhibition.setUpdateUser(user.getUserId());
      return ccpExhibitionMapper.update(exhibition);		
	}



}
