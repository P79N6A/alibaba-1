package com.culturecloud.dao.common;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.culturecloud.model.bean.common.CmsTag;

public interface CmsTagMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table cms_tag
     *
     * @mbggenerated Mon Jul 25 16:42:06 CST 2016
     */
    int deleteByPrimaryKey(String tagId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table cms_tag
     *
     * @mbggenerated Mon Jul 25 16:42:06 CST 2016
     */
    int insert(CmsTag record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table cms_tag
     *
     * @mbggenerated Mon Jul 25 16:42:06 CST 2016
     */
    int insertSelective(CmsTag record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table cms_tag
     *
     * @mbggenerated Mon Jul 25 16:42:06 CST 2016
     */
    CmsTag selectByPrimaryKey(String tagId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table cms_tag
     *
     * @mbggenerated Mon Jul 25 16:42:06 CST 2016
     */
    int updateByPrimaryKeySelective(CmsTag record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table cms_tag
     *
     * @mbggenerated Mon Jul 25 16:42:06 CST 2016
     */
    int updateByPrimaryKey(CmsTag record);
    
    List<CmsTag> queryActivityTagByDictCode(@Param("dictCode")String dictCode);
}