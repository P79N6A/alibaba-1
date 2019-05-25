package com.sun3d.why.controller;


import com.sun3d.why.model.CmsTag;
import com.sun3d.why.model.CmsTagSub;
import com.sun3d.why.model.SysDict;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsTagService;
import com.sun3d.why.service.CmsTagSubService;
import com.sun3d.why.service.SysDictService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.HanziToPinyin;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.net.URLDecoder;
import java.util.*;

@RequestMapping("/tag")
@Controller
public class CmsTagController {
    private Logger logger = LoggerFactory.getLogger(CmsTagController.class);

    @Autowired
    private CmsTagService cmsTagService;
    
    @Autowired
    private CmsTagSubService cmsTagSubService;

    @Autowired
    private SysDictService sysDictService;

    @Autowired
    private HttpSession session;


    /**
     * 进入标签管理页并查询标签列表信息
     *
     * @param page
     * @param tag
     * @return
     * @author zuowm
     * @date 2015年4月22日 上午10:17:00
     */
    @RequestMapping(value = "/tagIndex")
    public ModelAndView tagIndex(CmsTag tag, Pagination page, HttpServletRequest request) {
        ModelAndView model = new ModelAndView();
        Map<String, Object> map = new HashMap<String, Object>();
        String tagName = tag.getTagName();
        if (!StringUtils.isBlank(tag.getTagName())) {
            tagName = URLDecoder.decode(tag.getTagName());
        }
        map.put("tagName", tagName);
        map.put("tagType", tag.getTagType());
        map.put("orderByClause", " ct.TAG_CREATE_TIME desc");
        map.put("firstResult", page.getFirstResult());
        map.put("rows", page.getRows());
        int total = cmsTagService.countTagList(map);
        page.setTotal(total);
        model.addObject("page", page);
        model.addObject("tag", tag);
        List<Map<String, Object>> list = cmsTagService.selectTagList(map);
        model.addObject("list", list);
        model.setViewName("admin/tag/tag_index");
        return model;
    }

    /**
     * 进入标签编辑页
     *
     * @param tagId 标签id
     * @return
     * @author zuowm
     * @date 2015年4月22日 下午1:26:26
     */
    @RequestMapping("/preEditTag")
    public ModelAndView preTagEdit(String tagId) {
        ModelMap model = new ModelMap();
        // 如果tagId为空，新增标签，否则为修改，需要加载选中信息
        if (!StringUtils.isBlank(tagId)) {
            CmsTag tag = cmsTagService.queryCmsTagByTagId(tagId);
            model.addAttribute("tag", tag);
        }
        return new ModelAndView("admin/tag/tag_edit", model);
    }


    private String addEditTag(CmsTag tag, Integer countTags) {
        if (StringUtils.isNotBlank(tag.getTagId())) {
            //修改时判断
            CmsTag extTag = cmsTagService.queryCmsTagByTagId(tag.getTagId());
            if (extTag.getTagRecommend().equals(1)) {
                return null;
            } else {
                if (countTags >= 6) {
                    return Constant.RESULT_STR_REPEAT;
                }
            }
        } else if (countTags >= 6) {
            //新增时必须判断
            return Constant.RESULT_STR_REPEAT;
        }
        return null;

    }


    /**
     * 保存标签信息
     *
     * @param tag
     * @return
     * @author zuowm
     * @date 2015年4月22日 下午1:27:21
     */
    @RequestMapping(value = "/saveTag", method = RequestMethod.POST)
    @ResponseBody
    public String saveTag(CmsTag tag,String []tagNames, String tagChildType, String myTagType) {
    	
    	try {
    	
    	 SysUser sysUser = (SysUser) session.getAttribute("user");
         if(sysUser==null){
            return Constant.RESULT_STR_FAILURE;
        }
         
         
        tag.setTagUpdateTime(new Date());
        tag.setTagUpdateUser(sysUser.getUserId());
        tag.setTagSearchStr(HanziToPinyin.hanziToPinyinFirstLetter(tag.getTagName()));
      
        if (tagChildType != null && StringUtils.isNotBlank(tagChildType)) {
            tag.setTagType(tagChildType);
        }
        int count = 0;

        /**
         * 更新或添加   是否推荐  前查询目前推荐数木是否大于6
         */
        if ("1".equals(String.valueOf(tag.getTagRecommend()))) {

            SysDict dict = new SysDict();

            //因需求 推荐至app用户勾选个性化标签页面  不再进行该项验证 注释 myTagType=2（即活动类型）
/*
            if ("2".equals(myTagType)) {
                dict.setDictCode(Constant.TAG_TYPE);
                dict.setDictName(Constant.ACTIVITY_NAME);
                SysDict dictModel = sysDictService.querySysDict(dict);
                Integer countTags = cmsTagService.queryRecommendTag(dictModel.getDictId());

                String result = addEditTag(tag, countTags);
                if (StringUtils.isNotBlank(result)) {
                    return result;
                }

            } else */ if ("3".equals(myTagType)) {
                dict.setDictCode(Constant.TAG_TYPE);
                dict.setDictName(Constant.VENUE_NAME);
                SysDict dictModel = sysDictService.querySysDict(dict);
                Integer countTags = cmsTagService.queryRecommendTag(dictModel.getDictId());

                logger.info("场馆标签----->" + countTags);

                String result = addEditTag(tag, countTags);
                if (StringUtils.isNotBlank(result)) {
                    return result;
                }
            } else if ("4".equals(myTagType)) {
                dict.setDictCode(Constant.ROOM_TAG);
                SysDict dictModel = sysDictService.querySysDict(dict);
                Integer countTags = cmsTagService.queryRecommendTag(dictModel.getDictId());
                logger.info("活动室标签----->" + countTags);

                String result = addEditTag(tag, countTags);
                if (StringUtils.isNotBlank(result)) {
                    return result;
                }
            } /*else {
                return Constant.RESULT_STR_FAILURE;
            }*/
        } else {
            tag.setTagRecommend(0);
        }
     
        Integer type=getType(myTagType);

        Map<String, Object> params = new HashMap<String, Object>();

        if (StringUtils.isBlank(tag.getTagId())) {
            //新增验证标签名是否
            params.put("tagName", tag.getTagName().trim());
            params.put("tagType", tag.getTagType());
            List<CmsTag> extList = cmsTagService.queryExtTagByName(params);
            if (!CollectionUtils.isEmpty(extList)) {
                return "nameRepeat";
            }
            List<CmsTag> list =cmsTagService.queryExtTagByColor(tag);
            if(list.size()>0){
                return "colorRepeat";
            }

            tag.setTagId(UUIDUtils.createUUId());
            tag.setTagIsDelete(1);
            tag.setTagCreateUser(sysUser.getUserId());
            tag.setTagCreateTime(new Date());
            
            count = cmsTagService.addCmsTag(tag,type,tagNames);
        } else {
            params.put("tagName", tag.getTagName().trim());
            params.put("tagType", tag.getTagType());
            List<CmsTag> extList = cmsTagService.queryExtTagByName(params);
            for (CmsTag myTag : extList) {
                if (!tag.getTagId().equals(myTag.getTagId())) {
                    return "nameRepeat";
                }
            }

            //根据标签类型和颜色查询标签表的List
            List<CmsTag> list =cmsTagService.queryExtTagByColor(tag);
            for(CmsTag tags :list){
                //如果当前标签的id和list里面的id相同
                if((!tag.getTagId().equals(tags.getTagId())) && tag.getTagColor().equals(tags.getTagColor())){
                    return "colorRepeat";
                }
            }
            count = cmsTagService.editCmsTag(tag,type,tagNames);
        }
        if (count > 0) {
            return Constant.RESULT_STR_SUCCESS;
        }
        return Constant.RESULT_STR_FAILURE;
        
		
		} catch (Exception e) {
			  return e.getMessage();
		}
    }

    /**
     * 删除标签信息，支持批量删除
     *
     * @param tagId 标签id数组
     * @author zuowm
     * @date 2015年4月22日 下午3:46:12
     */
    @RequestMapping(value = "/delTag", method = RequestMethod.POST)
    @ResponseBody
    public String delTag(String tagId) {
        int count = cmsTagService.updateByTagId(tagId);
        if (count > 0) {
            return Constant.RESULT_STR_SUCCESS;
        }
        return Constant.RESULT_STR_FAILURE;
    }

    /**
     * 根据类型获取标签信息列表
     *
     * @param type
     * @return
     * @author zuowm
     * @date 2015年4月24日 下午2:40:38
     */
    @SuppressWarnings("rawtypes")
    @RequestMapping("/getTagByType")
    @ResponseBody
    public List getTagByType(String type) {
        List<CmsTag> list = cmsTagService.queryCmsTagByCondition(type, 20);
        return list;
    }
    
    @RequestMapping("/getTagSubByTagId")
    @ResponseBody
    public List getTagSubByTagId(String tagId) {
        List<CmsTagSub> list = cmsTagSubService.queryByTagId(tagId);
        return list;
    }
    
    @SuppressWarnings("rawtypes")
    @RequestMapping("/getCommonTag")
    @ResponseBody
    public List getCommonTag(Integer type) {
    
        List<CmsTagSub> list = cmsTagSubService.queryCommonTag(type);
        return list;
    }


    /**
     * 根据数据字典的code 查询对应的tag标签的值
     *
     * @param code
     * @return
     */
    @SuppressWarnings("rawtypes")
    @RequestMapping("/getChildTagByType")
    @ResponseBody
    public List getChildTagByType(String code) {
        List<CmsTag> list = new ArrayList<CmsTag>();
        List<SysDict> dicts = sysDictService.querySysDictByCode(code);
        if (dicts != null && dicts.size() > 0) {
            list = cmsTagService.queryCmsTagByCondition(dicts.get(0).getDictId(), 20);
        }
        return list;
    }

    /**
     * 根据数据字典的dictTagType 查询对应的tag标签的值
     *
     * @param code
     * @return
     */
    @SuppressWarnings("rawtypes")
    @RequestMapping("/getTagsByDictTagType")
    @ResponseBody
    public List getTagsByDictTagType(String code) {
        List<CmsTag> list = new ArrayList<CmsTag>();
        try {

            list = cmsTagService.getTagsByDictTagType(code);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return list;
    }


    @RequestMapping("/tagList")
    public String tagList(String tagType,Pagination page,  HttpServletRequest request) {
    	
    	// 类型
    	String sysDictCode="";
    	// 字典id
    	String dictId="";
    	  
        //活动
        if ("2".equals(tagType)) {
        	sysDictCode="ACTIVITY_TYPE";
        //场馆类型
        } else if ("3".equals(tagType)) {
        	sysDictCode=Constant.VENUE_TYPE;
        //活动室标签
        } else if ("4".equals(tagType)) {
        	sysDictCode=Constant.ROOM_TAG;
        }else if ("6".equals(tagType)) {
            sysDictCode=Constant.ASSOCIATION_TYPE;
        }else if("7".equals(tagType)){
            sysDictCode=Constant.LEAGUE_TYPE;
        }else if("10".equals(tagType)){
            sysDictCode="TRAIN_TYPE";
        }
        //类型
        List<SysDict> typeDicts = sysDictService.querySysDictByCode(sysDictCode);
        if (typeDicts != null && typeDicts.size() > 0) {
        	
        	dictId=typeDicts.get(0).getDictId();
        	
        }    
        
        List<CmsTag> tagList =  cmsTagService.queryTagList(dictId, page);
      	  
      	 request.setAttribute("page", page);
      	  
      	 request.setAttribute("dictId", dictId);
      	  
         request.setAttribute("tagList", tagList);

        request.setAttribute("tagType", tagType);
        return "admin/tag/tagList1";
    }


    @RequestMapping("preTagAdd")
    public String preAddTag(HttpServletRequest request, String tagType,String dictId) {
        //SysDict dict = new SysDict();
        //request.setAttribute("dicList", getSysDictList(tagType));
    	
    	 request.setAttribute("dictId", dictId);
        request.setAttribute("tagType", tagType);
        return "admin/tag/tagAdd";
    }

    private List<SysDict> getSysDictList(String tagType) {
        SysDict dict = new SysDict();
        List<SysDict> dicList = new ArrayList<SysDict>();
        SysDict dicts = new SysDict();
        if ("2".equals(tagType)) {
            dict.setDictCode(Constant.TAG_TYPE);
            dict.setDictName(Constant.ACTIVITY_NAME);
            SysDict dictModel = sysDictService.querySysDict(dict);
            dicts.setDictParentId(dictModel.getDictId());
            dicList = sysDictService.querySysDictByByCondition(dicts);
            /***********2015.11.16 add niu 暂时*****************/
            List<SysDict> delList = new ArrayList<SysDict>();
            for (SysDict s:dicList){
                if("活动心情".equals(s.getDictName())||"活动人群".equals(s.getDictName())){
                    delList.add(s);
                }
            }
            dicList.removeAll(delList);
        } else if ("3".equals(tagType)) {
            dict.setDictCode(Constant.TAG_TYPE);
            dict.setDictName(Constant.VENUE_NAME);
            SysDict dictModel = sysDictService.querySysDict(dict);
            dicts.setDictParentId(dictModel.getDictId());
            dicList = sysDictService.querySysDictByByCondition(dicts);
        } else if ("4".equals(tagType)) {
            dict.setDictCode(Constant.ROOM_TAG);
            SysDict dictModel = sysDictService.querySysDict(dict);
            dicts.setDictParentId(dictModel.getDictId());
            List<SysDict> list = sysDictService.querySysDictByByCondition(dicts);
            /***********2015.11.18 add qww 暂时*****************/
            for(SysDict sysDict:list){
                if(!"团体人群".equals(sysDict.getDictName()) && !"团体地点".equals(sysDict.getDictName())){
                    dicList.add(sysDict);
                }
            }
        }else if("5".equals(tagType)){
            dict.setDictCode(Constant.TAG_TYPE);
            dict.setDictName(Constant.NEWS_TAG);
            SysDict dictModel = sysDictService.querySysDict(dict);
            dicts.setDictParentId(dictModel.getDictId());
            dicList = sysDictService.querySysDictByByCondition(dicts);
        } else if("6".equals(tagType)){
            dict.setDictCode(Constant.ASSOCIATION_TYPE);
            SysDict dictModel = sysDictService.querySysDict(dict);
            dicts.setDictParentId(dictModel.getDictId());
            dicList = sysDictService.querySysDictByByCondition(dicts);
        }
        return dicList;
    }
    
    @RequestMapping("/commonTag")
    public ModelAndView commonTag(String tagType,String dictId){
    	
    	ModelAndView model = new ModelAndView();
    	
        //类型
        Integer type=getType(tagType);
        	
    	List<CmsTagSub> tags=cmsTagSubService.queryCommonTag(type);
    	
		String [] tagArray=new String[tags.size()];
   		
   		for (int i = 0; i < tags.size(); i++) {
				
   			CmsTagSub cmgTag=tags.get(i);
   			tagArray[i]=cmgTag.getTagName();
			}
   		
   		 // 子标签名称集合
   		String tagName=StringUtils.join(tagArray,",");
   		
   		model.addObject("tagName", tagName);
   		model.addObject("dictId", dictId);
   		model.addObject("tagType", tagType);
   		model.setViewName("admin/tag/commonTag");
    	  
    	return model;
    }
    
    @RequestMapping(value = "/saveCommonTag", method = RequestMethod.POST)
    @ResponseBody
    public String saveCommonTag(String []tagNames,String tagType,String dictId) {
    	
	    try {
	    	
	    	 SysUser sysUser = (SysUser) session.getAttribute("user");
	         if(sysUser==null){
	            return Constant.RESULT_STR_FAILURE;
	        }
	         
	         //类型
	         Integer type=getType(tagType);
	      
	         Integer result = cmsTagService.addCommonTag(sysUser,type,tagNames);
	     
	         return Constant.RESULT_STR_SUCCESS;
			
			} catch (Exception e) {
				  return e.getMessage();
			}
	    }

    @RequestMapping("/preEditTags")
    public ModelAndView preEditTags(String tagId, String tagType) {
        ModelAndView model = new ModelAndView();
        model.addObject("dictList", getSysDictList(tagType));
        model.addObject("tagType", tagType);
        if (!StringUtils.isBlank(tagId)) {
            CmsTag cmsTag = cmsTagService.queryCmsTagByTagId(tagId);
            
	   		 String type=cmsTag.getTagId();
				
	   		List<CmsTagSub> tags=  cmsTagSubService.queryByTagId(tagId);
	   		
	   		String [] tagArray=new String[tags.size()];
	   		
	   		for (int i = 0; i < tags.size(); i++) {
					
	   			CmsTagSub cmgTag=tags.get(i);
	   			tagArray[i]=cmgTag.getTagName();
				}
	   		
	   		 // 子标签名称集合
	   		String tagName=StringUtils.join(tagArray,",");
	   		
	   		cmsTag.setTagNames(tagName);
            
            model.addObject("tag", cmsTag);
        }
        model.setViewName("admin/tag/tagEdit");
        return model;
    }


    /**
     * 返回类型
     * @param tagType
     * @return
     */
    private Integer getType(String tagType){
    	
    	   Integer type=null;
           
           //活动
           if ("2".equals(tagType)) {
           	type=Constant.TYPE_ACTIVITY;
           //场馆类型
           } else if ("3".equals(tagType)) {
           	type=Constant.TYPE_VENUE;
           //活动室标签
           } else if ("4".equals(tagType)) {
           	type=Constant.TYPE_ACTIVITY_ROOM;
           }
           
           return type;
    }



}
