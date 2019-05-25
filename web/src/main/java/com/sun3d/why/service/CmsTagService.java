package com.sun3d.why.service;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.CmsTag;
import com.sun3d.why.model.CmsTagSub;
import com.sun3d.why.model.CmsTagSubRelate;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

public interface CmsTagService {


	/**
	 * 更具标签Id删除标签信息
	 * @param tagId 标签Id
	 * @return 1 成功 0 失败
	 */
	int deleteByTagId(String tagId);

	/**
	 * 插入标签信息
	 * @param record 标签对象
	 * @return 1 成功 0 失败
	 */
	int addCmsTag(CmsTag record,Integer type ,String []tagNames);
	
	/**
	 * 插入通用标签
	 * @param tagNames
	 * @return
	 */
	int addCommonTag( SysUser sysUser,Integer type,String []tagNames);
	
	/**
	 * 根据标签类型查询标签列表
	 * @param type 标签类型(1:场馆,2:活动,3:藏品)
	 * @param count 显示条数
	 * @return 标签列表
	 */
	List<CmsTag> queryCmsTagByCondition(String type,Integer count);

	/**
	 * 根据标签Id查询标签
	 * @param tagId 标签Id
	 * @return 1成功 0失败
	 */
	CmsTag queryCmsTagByTagId(String tagId);


	/**
	 * 根据标签对象的id更新标签信息
	 * @param record
	 * @return 1成功 0失败
	 */
	int editCmsTag(CmsTag record,Integer type ,String []tagNames);
	
	/**
	 * 修改标签状态信息
	 * @author zuowm 
	 * @date 2015年4月29日 下午2:30:19
	 * @param tagId
	 * @return
	 */
	int updateByTagId(String tagId);
    
    /**
     * 根据条件查询标签列表
     * @author zuowm 
     * @date 2015年4月29日 下午1:57:02
     * @param map
     * @return
     */
    List<Map<String,Object>> selectTagList(Map<String,Object> map);
    
    /**
     * 根据条件查询标签的总条数
     * @author zuowm 
     * @date 2015年4月29日 下午2:01:41
     * @param map
     * @return
     */
    Integer countTagList(Map<String,Object> map);


	List<CmsTag> queryRecCmsTagByCondition(String type,Integer count,Integer recommendState);

	List<CmsTag> queryTagsByDictTagType(Map map);


	public List<CmsTag> queryTeamTags(String tagIds);


	/**
	 * app活动标签类型推荐
	 * @return
	 */
	List<CmsTag> queryAppTagsByDictTagType();

	/**
	 * tag_type的父Id
	 * @param parentId
	 * @return
	 */
	Integer queryRecommendTag(String parentId);

	List<CmsTag> queryExtTagByName(Map<String, Object> map);


	List<CmsTag> getTagsByDictTagType(final String tagType);

	/**
	 * 文化云3.1前端首页根据栏目名称查标签数据
	 * @param map
	 * @return
	 */
	String queryTagIdByTagName(Map<String, Object> map);


	List<CmsTag> queryExtTagByColor(CmsTag cmsTag);
	
	/**
	 * 查找公共标签
	 * @param type
	 * @return
	 */
	List<CmsTagSub> queryCommonTag(Integer type);
	
	List<CmsTag>queryTagList (String tagType,Pagination page);

    List<CmsTag> selectAllTrainTag(String train_type);
}
