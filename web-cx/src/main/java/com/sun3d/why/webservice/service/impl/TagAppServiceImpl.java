package com.sun3d.why.webservice.service.impl;
import com.sun3d.why.dao.CmsTagMapper;
import com.sun3d.why.dao.CmsUserTagMapper;
import com.sun3d.why.model.CmsTag;
import com.sun3d.why.model.CmsUserTag;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.util.*;
import com.sun3d.why.webservice.service.TagAppService;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.*;
@Service
@Transactional
public class TagAppServiceImpl implements TagAppService {
    @Autowired
    private CmsTagMapper cmsTagMapper;
    @Autowired
    private StaticServer staticServer;
    @Autowired
    private CmsUserTagMapper cmsUserTagMapper;
    @Autowired
    private CacheService cacheService;
    /**
     * app获取活动与展馆推荐标签
     * @return
     * @param type1
     * @param type2
     */
    @Override
    public String queryActivityVenueTagsByType(int type1, int type2) {
        List<Map<String, Object>> ActivityList = new ArrayList<Map<String, Object>>();
        List<Map<String,Object>> venueList=new ArrayList<Map<String, Object>>();
        Map<String,Object> map = new HashMap<String, Object>();
         if( Integer.valueOf(type1)==1){
          map.put("dictName", "活动");
          map.put("dictCode", "TAG_TYPE");
          map.put("themsCode", "ACTIVITY_THEME");
          List<CmsTag> activityTagList=cmsTagMapper.queryAppTagsByDictTagType(map);
          if (activityTagList.size() > 0) {
              for (CmsTag activityTags : activityTagList) {
                  Map<String, Object> activityTag = new HashMap<String, Object>();
                  activityTag.put("tagName", activityTags.getTagName() != null ? activityTags.getTagName() : "");
                  String tagImageUrl = "";
                  if (StringUtils.isNotBlank(activityTags.getTagImageUrl())) {
                      tagImageUrl = staticServer.getStaticServerUrl() + activityTags.getTagImageUrl();
                  }
                  activityTag.put("tagImageUrl", tagImageUrl);
                  activityTag.put("tagId", activityTags.getTagId() != null ? activityTags.getTagId() : "");
                  ActivityList.add(activityTag);
              }
          }
      }
        if(Integer.valueOf(type2)==2){
            map.put("dictName", "场馆");
            map.put("dictCode", "TAG_TYPE");
            map.put("themsCode", "VENUE_TYPE");
            List<CmsTag> venueTagList=cmsTagMapper.queryAppTagsByDictTagType(map);
            if (venueTagList.size() > 0) {
                for (CmsTag venueTags : venueTagList) {
                    Map<String, Object> venueTag = new HashMap<String, Object>();
                    venueTag.put("tagName", venueTags.getTagName() != null ? venueTags.getTagName() : "");
                    String tagImageUrl = "";
                    if (StringUtils.isNotBlank(venueTags.getTagImageUrl())) {
                        tagImageUrl = staticServer.getStaticServerUrl() + venueTags.getTagImageUrl();
                    }
                    venueTag.put("tagImageUrl", tagImageUrl);
                    venueTag.put("tagId", venueTags.getTagId() != null ? venueTags.getTagId() : "");
                    venueList.add(venueTag);
                }
            }
        }
        return JSONResponse.toAppResultObject(0, ActivityList, venueList);
    }

    /**
     * app获取活动与展馆标签
     * @param tagMood  活动与心情标签
     * @param tagType  活动类型标签
     * @param tagCrowd 活动人群标签
     * @return
     */
    @Override
    public String queryCmsActivityTagByCondition(String tagMood,String tagType,String tagCrowd) {
        List<Map<String, Object>> mapMoodList = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> mapThemeList = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> mapCrowdList = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> mapAreaList = new ArrayList<Map<String, Object>>();
        Map<String,Object> map=new HashMap<String,Object>();
        map.put("dictState", Constant.NORMAL);
        //活动心情标签集合
        if (tagMood != null && StringUtils.isNotBlank(tagMood)) {
            map.put("dictCode",tagMood);
            List<CmsTag> listMood = cmsTagMapper.queryAppTagByCondition(map);
            if(CollectionUtils.isNotEmpty(listMood)){
                for (CmsTag tagList : listMood) {
                    Map<String, Object> mapMood = new HashMap<String, Object>();
                    mapMood.put("tagId", tagList.getTagId()!=null?tagList.getTagId():"");
                    mapMood.put("tagName", tagList.getTagName()!=null?tagList.getTagName():"");
                    mapMoodList.add(mapMood);
                }
            }
        }
        //活动类型标签集合
        if(tagType != null && StringUtils.isNotBlank(tagType)){
            map.put("dictCode",tagType);
            List<CmsTag> listTheme = cmsTagMapper.queryAppTagByCondition(map);
            if (CollectionUtils.isNotEmpty(listTheme)) {
                for (CmsTag tagList : listTheme) {
                    Map<String, Object> mapTheme = new HashMap<String, Object>();
                    mapTheme.put("tagId", tagList.getTagId()!=null?tagList.getTagId():"");
                    mapTheme.put("tagName", tagList.getTagName()!=null?tagList.getTagName():"");
                    mapThemeList.add(mapTheme);
                }
            }
        }
        //活动人群标签集合
      if(tagCrowd!=null && StringUtils.isNotBlank(tagCrowd)){
          map.put("dictCode",tagCrowd);
          List<CmsTag> listCrowd=cmsTagMapper.queryAppTagByCondition(map);
          if (CollectionUtils.isNotEmpty(listCrowd)) {
              for (CmsTag tagList : listCrowd) {
                  Map<String, Object> mapCrowd = new HashMap<String, Object>();
                  mapCrowd.put("tagId", tagList.getTagId()!=null?tagList.getTagId():"");
                  mapCrowd.put("tagName", tagList.getTagName()!=null?tagList.getTagName():"");
                  mapCrowdList.add(mapCrowd);
              }
          }
       }
        //位置标签集合
        String areaCode = "46:黄浦区,48:徐汇区,50:静安区,49:长宁区,51:普陀区,52:闸北区,53:虹口区,54:杨浦区,58:浦东新区,56:宝山区,57:嘉定区,60:松江区,61:青浦区,55:闵行区,59:金山区,63:奉贤区,64:崇明县";
        String[] areaId = areaCode.split(",");
        for (int i = 0; i < areaId.length; i++) {
            Map<String, Object> mapArea = new HashMap<String, Object>();
            mapArea.put("areaCode", areaId[i]);
            mapAreaList.add(mapArea);
        }
       return JSONResponse.toFourParamterResult(0, mapMoodList, mapThemeList, mapCrowdList, mapAreaList);

    }

    /**
     * app用户选择喜欢标签
     * @param cmsUsertag
     * @return
     */
    @Override
    public String addUserTags(CmsUserTag cmsUsertag) {
        List<CmsUserTag> userTagList=new ArrayList<CmsUserTag>();
        int flag=0;
        int status=0;
        //查询该用户是否已选择标签
        int count=cmsUserTagMapper.queryAppUserTagCount(cmsUsertag.getUserId());
        if(count>0){
            status=cmsUserTagMapper.deleteAppUserListTagsById(cmsUsertag.getUserId());
            if(status>0){
                if(cmsUsertag!=null) {
                    String[] userTags=cmsUsertag.getUserSelectTag().split(",");
                    for (String tags:userTags) {
                        CmsUserTag userTag=new CmsUserTag();
                        userTag.setUserId(cmsUsertag.getUserId());
                        userTag.setTagCreateTime(new Date());
                        userTag.setTagCreateUser(cmsUsertag.getUserId());
                        userTag.setTagUpdateUser(cmsUsertag.getUserId());
                        userTag.setTagUpdateTime(new Date());
                        userTag.setUserSelectTag(tags);
                        userTag.setTagId(UUIDUtils.createUUId());
                        userTagList.add(userTag);
                    }
                        flag = cmsUserTagMapper.addUserTags(userTagList);
                }
            }
        }else {
            if(cmsUsertag!=null && StringUtils.isNotBlank(cmsUsertag.getUserSelectTag())) {
                String[] userTags=cmsUsertag.getUserSelectTag().split(",");
                for (String tags:userTags) {
                    CmsUserTag userTag=new CmsUserTag();
                    userTag.setUserId(cmsUsertag.getUserId());
                    userTag.setTagCreateTime(new Date());
                    userTag.setTagCreateUser(cmsUsertag.getUserId());
                    userTag.setTagUpdateUser(cmsUsertag.getUserId());
                    userTag.setTagUpdateTime(new Date());
                    userTag.setUserSelectTag(tags);
                    userTag.setTagId(UUIDUtils.createUUId());
                    userTagList.add(userTag);
                }
                 flag = cmsUserTagMapper.addUserTags(userTagList);
            }
        }
        if(flag>0){
            return  JSONResponse.commonResultFormat(0, "信息添加成功", null);
        }else {
            return  JSONResponse.commonResultFormat(1, "信息添加失败", null);
        }
    }

    /**
     * app获取活动与展馆推荐标签
     * @return

    @Override
    public List<CmsTag> queryActivityTagsByType(int type) {
        Map<String,Object> map = new HashMap<String, Object>();
        if(type==1) {
            map.put("dictName", "活动");
            map.put("dictCode", "TAG_TYPE");
            map.put("themsCode", "ACTIVITY_THEME");
        }else {
            map.put("dictName", "场馆");
            map.put("dictCode", "TAG_TYPE");
            map.put("themsCode", "VENUE_TYPE");
        }
        return cmsTagMapper.queryAppTagsByDictTagType(map);
    }
     */
   /* @Override
    public List<CmsTag> queryCmsTagByCondition(String tagType) {
        Map<String,Object> map=new HashMap<String,Object>();
        map.put("dictState", Constant.NORMAL);
        if (tagType != null && StringUtils.isNotBlank(tagType)) {
            map.put("dictCode",tagType);
        }
        return cmsTagMapper.queryAppTagByCondition(map);
    }*/

    /**
     * 根据标签id查询标签
     */
	public CmsTag queryAppTagByTagId(String tagId) {
		return cmsTagMapper.queryCmsTagByTagId(tagId);
	}
    /**
     * app获取活动与展馆标签
     *
     * @return
     */
    @Override
    public String activityHot() {
        List<Map<String, Object>> mapWordsList = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> mapCrowdList = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> mapList = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> mapAreaList = new ArrayList<Map<String, Object>>();
        Map<String,Object> map=new HashMap<String,Object>();
        map.put("dictState", Constant.NORMAL);
        //活动热门标签
        final List activityTagKeywordsNameList= cacheService.getList("activityTagKeywordsName");
        final List activityTagKeywordsList= cacheService.getList("activityTagKeywords");
        if (CollectionUtils.isNotEmpty(activityTagKeywordsList)) {
                for (int i = 0; i < activityTagKeywordsNameList.size(); i++) {
                    Map<String, Object> mapCrowd = new HashMap<String, Object>();
                    mapCrowd.put("tagId", activityTagKeywordsList.get(i));
                    mapCrowd.put("tagName", activityTagKeywordsNameList.get(i));
                    mapCrowdList.add(mapCrowd);
                }
            }
        final List areaId= cacheService.getList("activityAreaKeywords");
        for (int i = 0; i < areaId.size(); i++) {
            Map<String, Object> mapArea = new HashMap<String, Object>();
            mapArea.put("areaCode", areaId.get(i));
            mapAreaList.add(mapArea);
        }
        final List HotKeywords= cacheService.getList("activityHotKeywords");
        for (int i = 0; i < HotKeywords.size(); i++) {
            Map<String, Object> mapWords = new HashMap<String, Object>();
            mapWords.put("hotKeywords", HotKeywords.get(i));
            mapWordsList.add(mapWords);
        }
        return JSONResponse.toFourParamterResult(0, mapAreaList, mapCrowdList, mapWordsList, mapList);

    }


    /**
     * app获取活动与展馆标签
     *
     * @return
     */
    @Override
    public String venueHot() {
        List<Map<String, Object>> mapWordsList = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> mapCrowdList = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> mapList = new ArrayList<Map<String, Object>>();
        List<Map<String, Object>> mapAreaList = new ArrayList<Map<String, Object>>();
        Map<String,Object> map=new HashMap<String,Object>();
        map.put("dictState", Constant.NORMAL);
        //活动热门标签
        final List activityTagKeywordsNameList= cacheService.getList("venueTagKeywordsName");
        final List activityTagKeywordsList= cacheService.getList("venueTagKeywords");
        if (CollectionUtils.isNotEmpty(activityTagKeywordsList)) {
            for (int i = 0; i < activityTagKeywordsNameList.size(); i++) {
                Map<String, Object> mapCrowd = new HashMap<String, Object>();
                mapCrowd.put("tagId", activityTagKeywordsList.get(i));
                mapCrowd.put("tagName", activityTagKeywordsNameList.get(i));
                mapCrowdList.add(mapCrowd);
            }
        }
        final List areaId= cacheService.getList("venueAreaKeywords");
        for (int i = 0; i < areaId.size(); i++) {
            Map<String, Object> mapArea = new HashMap<String, Object>();
            mapArea.put("areaCode", areaId.get(i));
            mapAreaList.add(mapArea);
        }
        final List HotKeywords= cacheService.getList("venueHotKeywords");
        for (int i = 0; i < HotKeywords.size(); i++) {
            Map<String, Object> mapWords = new HashMap<String, Object>();
            mapWords.put("hotKeywords", HotKeywords.get(i));
            mapWordsList.add(mapWords);
        }
        return JSONResponse.toFourParamterResult(0, mapAreaList, mapCrowdList, mapWordsList, mapList);

    }
}
