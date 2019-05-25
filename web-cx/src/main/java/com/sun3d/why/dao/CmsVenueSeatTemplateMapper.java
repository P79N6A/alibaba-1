package com.sun3d.why.dao;

import com.sun3d.why.model.CmsVenueSeatTemplate;

import java.util.List;

/**
 * 场馆座位模版映射类
 */
public interface CmsVenueSeatTemplateMapper {

    /**
     * 根据模板ID删除对应的场馆座位模板记录
     * @param templateId 模板ID
     * @return
     */
    int deleteVenueSeatTemplateById(String templateId);

    /**
     * 添加场馆座位模板记录
     * @param record 场馆座位模板信息
     * @return
     */
    int addCmsVenueSeatTemplate(CmsVenueSeatTemplate record);

    /**
     * 根据场馆座位模板ID查询单条场馆座位模板记录
     * @param templateId 场馆模板ID
     * @return
     */
    CmsVenueSeatTemplate queryVenueSeatTemplateById(String templateId);

    /**
     * 编辑场馆座位模板记录
     * @param record 场馆座位模板信息
     * @return
     */
    int editCmsVenueSeatTemplate(CmsVenueSeatTemplate record);

    /**
     * 将场馆座位模板对象作为条件查询符合条件的所有场馆座位模板
     * @param cmsVenueSeatTemplate 场馆模板信息
     * @return
     */
    List<CmsVenueSeatTemplate> queryVenueSeatTemplateByCondition(CmsVenueSeatTemplate cmsVenueSeatTemplate);

    /**
     * 将场馆座位模板对象作为条件查询符合条件的所有场馆座位模板总记录数
     * @param cmsVenueSeatTemplate 场馆模板信息
     * @return
     */
    int queryVenueSeatTemplateCountByCondition(CmsVenueSeatTemplate cmsVenueSeatTemplate);
}