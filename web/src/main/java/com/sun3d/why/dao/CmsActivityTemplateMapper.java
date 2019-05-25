package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.CmsActivityTemplate;

public interface CmsActivityTemplateMapper {
	
	/**
	 * 活动模板列表
	 * @param map
	 * @return
	 */
	List<CmsActivityTemplate> queryActivityTemplateByCondition(Map<String, Object> map);
	
	/**
	 * 活动模板总数
	 * @param map
	 * @return
	 */
	int queryActivityTemplateByCount(Map<String, Object> map);
	
	/**
	 * 删除模板
	 * @param templId
	 * @return
	 */
    int deleteByPrimaryKey(String templId);
    
    /**
     * 添加模板
     * @param record
     * @return
     */
    int addActivityTemplate(CmsActivityTemplate record);
    
    /**
     * 根据ID查询模板
     * @param templId
     * @return
     */
    CmsActivityTemplate queryActivityTemplateById(String templId);
    
    /**
     * 编辑模板
     * @param record
     * @return
     */
    int editActivityTemplate(CmsActivityTemplate record);

    /**
     * 根据模板名称，检查是否重复
     * @param templateName
     * @return
     */
    int checkRepeatByName(String templateName);
}