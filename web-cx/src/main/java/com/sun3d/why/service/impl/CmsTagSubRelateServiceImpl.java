package com.sun3d.why.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.CmsTagSubRelateMapper;
import com.sun3d.why.model.CmsTagSubRelate;
import com.sun3d.why.service.CmsTagSubRelateService;

@Service
@Transactional
public class CmsTagSubRelateServiceImpl implements CmsTagSubRelateService {

    @Autowired
    private CmsTagSubRelateMapper cmsTagSubRelateMapper;

	@Override
	public int insertTagRelateList(String keyId, Integer type, String[] tagIds) {

		int result=0;
		
		if(tagIds!=null&&tagIds.length>0)
		{
			for (int i = 0; i < tagIds.length; i++) {
				
				String tagId=tagIds[i];
				
				if(StringUtils.isBlank(tagId))
					continue;
				
				CmsTagSubRelate relate=new CmsTagSubRelate();
				relate.setRelateId(keyId);
				relate.setType(type);
				relate.setTagSubId(tagId);
				
				int count=cmsTagSubRelateMapper.addCmsTagSubRelate(relate);
				
				result+=count;
			}
		}
		
		return result;
	}

	@Override
	public int updateEntityTagRelateList(String keyId, Integer type, Set<String> allTagIdSet) {
		
		Map<String,Object>map=new HashMap<String,Object>();
		
		map.put("relateId", keyId);
		
		cmsTagSubRelateMapper.deleteByMap(map);
		
		int result=0;
		
		for (String tagId : allTagIdSet) {
			
			if(StringUtils.isBlank(tagId))
				continue;
			
			CmsTagSubRelate relate=new CmsTagSubRelate();
			relate.setRelateId(keyId);
			relate.setType(type);
			relate.setTagSubId(tagId);
			
			int count=cmsTagSubRelateMapper.addCmsTagSubRelate(relate);
			
			result+=count;
		}
		
		return result;
	}

	@Override
	public List<CmsTagSubRelate> queryTagRelateByEntityId(String keyId) {

		Map<String,Object>map=new HashMap<String,Object>();
		
		map.put("relateId", keyId);
		
		List<CmsTagSubRelate> list=cmsTagSubRelateMapper.queryCmsTagSubRelateByMap(map);
		
		return list;
	}

   
}
