package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.CmsTag;
import com.sun3d.why.model.CmsTagSub;

public interface CmsTagSubMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table cms_tag_sub
     *
     * @mbggenerated Wed Aug 03 16:20:42 CST 2016
     */
    int deleteByPrimaryKey(String tagSubId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table cms_tag_sub
     *
     * @mbggenerated Wed Aug 03 16:20:42 CST 2016
     */
    int insert(CmsTagSub record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table cms_tag_sub
     *
     * @mbggenerated Wed Aug 03 16:20:42 CST 2016
     */
    int insertSelective(CmsTagSub record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table cms_tag_sub
     *
     * @mbggenerated Wed Aug 03 16:20:42 CST 2016
     */
    CmsTagSub selectByPrimaryKey(String tagSubId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table cms_tag_sub
     *
     * @mbggenerated Wed Aug 03 16:20:42 CST 2016
     */
    int updateByPrimaryKeySelective(CmsTagSub record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table cms_tag_sub
     *
     * @mbggenerated Wed Aug 03 16:20:42 CST 2016
     */
    int updateByPrimaryKey(CmsTagSub record);
    
    List<CmsTagSub> queryByTagId(String tagId);
    
    /**
     * 查询名称
     * @param tagName
     * @return
     */
    List<CmsTagSub> queryTagSubName(String tagName);
    
    List<CmsTagSub> queryCommonTag(Integer type);
}