package com.sun3d.why.dao;

import com.sun3d.why.model.CmsTag;
import com.sun3d.why.model.CmsTagSubRelate;

import java.util.List;
import java.util.Map;

public interface CmsTagMapper {

    int deleteByTagId(String tagId);

    int addCmsTag(CmsTag record);

    CmsTag queryCmsTagByTagId(String tagId);

    int editCmsTag(CmsTag record);
    /**
     * 根据条件查询标签列表
     * @author zuowm 
     * @date 2015年4月29日 下午1:57:02
     * @param map
     * @return
     */
    List<Map<String,Object>> selectTagList(Map<String,Object> map);
    
    List<CmsTag> queryTagList(Map<String,Object> map);
    
    /**
     * 根据条件查询标签的总条数
     * @author zuowm 
     * @date 2015年4月29日 下午2:01:41
     * @param map
     * @return
     */
    Integer countTagList(Map<String,Object> map);

    List<CmsTag> queryCmsTagByCondition(Map<String,Object> map);
    
    List<CmsTag> queryAllCmsTagByCondition(Map<String,Object> map);

    public List<CmsTag> queryRecCmsTagByCondition(Map<String,Object> map);

    public List<CmsTag> queryTagsByDictTagType(Map map);


    public List<CmsTag> queryTeamTags(List<String> tagIds);


    /**
     * app推荐活动标签
     * @param map
     * @return
     */
    List<CmsTag> queryAppTagsByDictTagType(Map<String, Object> map);


    Integer queryRecommendTag(String parentId);


    List<CmsTag> queryExtTagByName(Map<String, Object> map);

    List<CmsTag> getTagsByDictTagType(String tagType);

    /**
     * app获取获取心情标签集合
     * @param map
     * @return
     */
    List<CmsTag> queryAppTagByCondition(Map<String, Object> map);


    /**
     * app根据标签id查询标签名称
     * @param tags 标签id集合
     * @return
     */
 //   List<CmsTag> queryAppTagNameById(String[] tags);
    CmsTag queryAppTagNameById(String tags);
    /**
     * 文化云3.1前端首页根据栏目名称查标签数据
     * @param map
     * @return
     */
    String queryTagIdByTagName(Map<String, Object> map);

    List<CmsTag> queryExtTagByColor(Map<String,Object> map);

	List<CmsTag> querySortByCondition(Map<String, Object> map);

}