package com.sun3d.why.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeSet;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.CmsTagMapper;
import com.sun3d.why.dao.CmsTagSubMapper;
import com.sun3d.why.dao.CmsTagSubRelateMapper;
import com.sun3d.why.dao.CmsTagSubRelevanceMapper;
import com.sun3d.why.model.CmsTag;
import com.sun3d.why.model.CmsTagSub;
import com.sun3d.why.model.CmsTagSubRelate;
import com.sun3d.why.model.CmsTagSubRelevance;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.CmsTagService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

@Service
@Transactional
public class CmsTagServiceImpl implements CmsTagService {

    @Autowired
    private CmsTagMapper cmsTagMapper;
    
    @Autowired
    private  CmsTagSubMapper cmsTagSubMapper;
    
    @Autowired
    private CmsTagSubRelevanceMapper cmsTagSubRelevanceMapper;
    
    @Autowired
    private CmsTagSubRelateMapper cmsTagSubRelateMapper;

    @Autowired
    private CacheService cacheService;


    @Override
    public int deleteByTagId(String tagId) {
        return cmsTagMapper.deleteByTagId(tagId);
    }

    @Override
    public int addCmsTag(CmsTag record,Integer type ,String []tagNames) {
    	
    	int result=cmsTagMapper.addCmsTag(record);
    	
    	if(result>0)
    	{
    	  
    		this.addTagNames(record,type, tagNames);
    	}
    	
        return result;
    }
    
    @Override
    public int editCmsTag(CmsTag record,Integer type ,String []tagNames) {
        
        int result=cmsTagMapper.editCmsTag(record);
    	
    	if(result>0)
    	{
    		//List<CmsTagSub> tagSubList=cmsTagSubMapper.queryByTagId(record.getTagId());
    		
    		CmsTagSubRelevance model=new CmsTagSubRelevance();
    		model.setTagId(record.getTagId());
    		model.setType(type);
    		
    		cmsTagSubRelevanceMapper.deleteSelective(model);
    		
    	    this.addTagNames(record,type, tagNames);
    	}
    	
        return result;
    }

    @Override
    public List<CmsTag> queryCmsTagByCondition(String type, Integer count) {
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("tagType", type);
        map.put("tagIsDelete", 1);
        map.put("firstResult",count);
        return cmsTagMapper.queryCmsTagByCondition(map);
    }

    @Override
    public CmsTag queryCmsTagByTagId(String tagId) {
        return cmsTagMapper.queryCmsTagByTagId(tagId);
    }

    public int updateByTagId(String tagId) {
        CmsTag cmsTag = cmsTagMapper.queryCmsTagByTagId(tagId);
        if (cmsTag != null) {
            cmsTag.setTagIsDelete(2);
        }
        return cmsTagMapper.editCmsTag(cmsTag);
    }

    @Override
    public List<Map<String, Object>> selectTagList(Map<String, Object> map) {
        return cmsTagMapper.selectTagList(map);
    }

    public Integer countTagList(Map<String, Object> map) {
        return cmsTagMapper.countTagList(map);
    }

    /**
     *
     * @param type
     * @param count
     * @param recommendState 是否推荐 0不推荐  1推荐
     * @return
     */

    @Override
    public List<CmsTag> queryRecCmsTagByCondition(String type, Integer count, Integer recommendState) {
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("tagType", type);
        map.put("tagIsDelete", 1);
        map.put("firstResult",count);
        map.put("recState",recommendState);
        return cmsTagMapper.queryRecCmsTagByCondition(map);
    }

    @Override
    public List<CmsTag> queryTagsByDictTagType(Map map) {
        map.put("tagIsDelete",1);
        return cmsTagMapper.queryTagsByDictTagType(map);
    }


    @Override
    public List<CmsTag> queryTeamTags(String tagIds) {
        String[] tagArr = tagIds.split(",");
        List<String> list = new ArrayList<String>();
        for(String str:tagArr){
            list.add(str);
        }
        return cmsTagMapper.queryTeamTags(list);
    }


    @Override
    public List<CmsTag> queryAppTagsByDictTagType() {
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("dictName","活动");
        map.put("dictCode","TAG_TYPE");
        return cmsTagMapper.queryAppTagsByDictTagType(map);
    }

    @Override
    public Integer queryRecommendTag(String parentId) {
        return cmsTagMapper.queryRecommendTag(parentId);
    }

    @Override
    public List<CmsTag> queryExtTagByName(Map<String, Object> map) {
        return cmsTagMapper.queryExtTagByName(map);
    }

    @Override
    public List<CmsTag> getTagsByDictTagType(final String tagType) {
        try{

/*
            //先从缓存获取
            List<CmsTag> cacheList = cacheService.getTagList(CacheConstant.TAG_CACHE+tagType);
            if(!CollectionUtils.isEmpty(cacheList)){
                return cacheList;
            }
*/


            //查询放入缓存
            String temp = getValue(tagType);
            if(StringUtils.isBlank(temp)){
                return new ArrayList<CmsTag>();
            }
            final  List<CmsTag>  tagList =  cmsTagMapper.getTagsByDictTagType(temp);
/*            Runnable runner = new Runnable() {
                        @Override
                        public void run() {
                            Calendar calendar = Calendar.getInstance();
                            calendar.setTime(new Date());
                            //设置过期时间为当前时间之后的24小时
                            calendar.add(Calendar.HOUR_OF_DAY,24);
                            cacheService.setTagList(CacheConstant.TAG_CACHE+tagType, tagList, calendar.getTime());
                        }
            };
            Thread t = new Thread(runner);
            t.start();*/

            return tagList;
        }catch (Exception e){
            e.printStackTrace();
        }
        return new ArrayList<CmsTag>();
    }

    private static String getValue(String key){
        Map<String,String> extMap = new HashMap<String,String>();
        extMap.put("activity","活动");
        extMap.put("venue","场馆");
        extMap.put("team","团体");
        return extMap.get(key);
    }

    /**
     * 文化云3.1前端首页根据栏目名称查标签数据
     * @param map
     * @return
     */
    @Override
    public String queryTagIdByTagName(Map<String, Object> map){
        return cmsTagMapper.queryTagIdByTagName(map);
    }

    @Override
    public List<CmsTag> queryExtTagByColor(CmsTag cmsTag){
        Map map  = new HashMap();
        map.put("tagType", cmsTag.getTagType());
        map.put("tagColor", cmsTag.getTagColor());
        return cmsTagMapper.queryExtTagByColor(map);
    }

	// 添加子标签
	private int addTagNames(CmsTag record,Integer type, String[] tagNames) {
		
		int result=0;
	     
		if(tagNames!=null&&tagNames.length>0)
		{
			// 新添加标签名称set
			TreeSet<String> newTagNameSet=new TreeSet<>();
			
			for (String tagName : tagNames) {
				
				String name=tagName.trim();
				
				if(StringUtils.isNotBlank(name))
				{
					newTagNameSet.add(name);
				}
			}
			
			// 添加新的
			for (String newTagName : newTagNameSet) {
				
				CmsTagSub tagSub=null;
				
				List<CmsTagSub> tagSubList=cmsTagSubMapper.queryTagSubName(newTagName);
				
				if(tagSubList.size()==0)
				{
					tagSub=new CmsTagSub();
					
					tagSub.setTagSubId(UUIDUtils.createUUId());
					tagSub.setTagName(newTagName);
					tagSub.setTagCreateTime(new Date());
					tagSub.setTagUpdateTime(new Date());
					tagSub.setTagCreateUser(record.getTagUpdateUser());
					tagSub.setTagUpdateUser(record.getTagUpdateUser());
					tagSub.setTagIsDelete(1);
					cmsTagSubMapper.insert(tagSub);
				}
				else
					tagSub=tagSubList.get(0);
				
				CmsTagSubRelevance relevance=new CmsTagSubRelevance();
				
				relevance.setTagId(record.getTagId());
				relevance.setType(type);
				relevance.setTagSubId(tagSub.getTagSubId());
				
				result+=cmsTagSubRelevanceMapper.insert(relevance);
				
			}
		}
		
		
		return result;
	}
	

	@Override
	public int addCommonTag( SysUser sysUser,Integer type,String[] tagNames) {
		
		CmsTag record=new CmsTag();
		record.setTagUpdateUser(sysUser.getUserId());
		
		cmsTagSubRelevanceMapper.deleteCommonTag(type);
		
		return this.addTagNames(record,type, tagNames);
	}

	@Override
	public List<CmsTagSub> queryCommonTag(Integer type) {
	    
		return cmsTagSubMapper.queryCommonTag(type);
	}

	@Override
	public List<CmsTag> queryTagList(String tagType, Pagination page) {
		
		Map<String, Object> map = new HashMap<String, Object>();
        
        map.put("tagType",tagType);
        map.put("orderByClause", " ct.TAG_CREATE_TIME desc");
        map.put("firstResult", page.getFirstResult());
        map.put("rows", page.getRows());
        map.put("tagIsDelete", 1);
        int total = cmsTagMapper.countTagList(map);
        page.setTotal(total);
        
        List<CmsTag> tagList =   cmsTagMapper.queryTagList(map);
    	  
    	  for (CmsTag cmsTag : tagList) {
    		  
    		 String tagId=cmsTag.getTagId();
			
    		List<CmsTagSub> tags=  cmsTagSubMapper.queryByTagId(tagId);
    		
    		String [] tagArray=new String[tags.size()];
    		
    		for (int i = 0; i < tags.size(); i++) {
				
    			CmsTagSub cmgTag=tags.get(i);
    			tagArray[i]=cmgTag.getTagName();
			}
    		
    		 // 子标签名称集合
    		String tagName=StringUtils.join(tagArray,",");
    		
    		cmsTag.setTagNames(tagName);
    	  }
		
		return tagList;
	}
}
