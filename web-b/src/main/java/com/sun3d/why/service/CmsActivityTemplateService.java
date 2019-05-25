package com.sun3d.why.service;

import com.sun3d.why.model.CmsActivityTemplate;
import com.sun3d.why.model.CmsFunction;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

import java.util.List;

/**
 * Created by lijing on 2016/2/2.
 */
public interface CmsActivityTemplateService {
    public List<CmsActivityTemplate> queryCmsActivityTemplateByCondition(CmsActivityTemplate activity, Pagination page, SysUser sysUser);

	/**
     * 添加活动模板
     * @param cmsActivityTemplate 
     * @param sysUser   
     * @return     
     */
    String addActivityTemplate(CmsActivityTemplate cmsActivityTemplate, SysUser sysUser);
    
    /**
     * 编辑活动模板
     * @param cmsActivityTemplate 
     * @param sysUser   
     * @return     
     */
    String editActivityTemplate(CmsActivityTemplate cmsActivityTemplate, SysUser sysUser);
    
    /**
     * 根据id删除活动模板
     * @param templId   
     * @return     
     */
    String deleteActivityTemplate(String templId);
    
    /**
     * 根据ID查询模板
     * @param templId
     * @return
     */
    CmsActivityTemplate selectByPrimaryKey(String templId);

    /**
     * 根据模板名称，检查是否重复
     * @param templateName
     * @return
     */
    boolean checkRepeatByName(String templateName);
}
