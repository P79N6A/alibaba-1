package com.sun3d.why.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.CmsActivityTemplateMapper;
import com.sun3d.why.dao.CmsActivityTemplateRelMapper;
import com.sun3d.why.model.CmsActivityTemplate;
import com.sun3d.why.model.CmsActivityTemplateRel;
import com.sun3d.why.model.CmsFunction;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsActivityTemplateService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

/**
 * Created by lijing on 2016/2/3.
 * 主题模板功能引擎
 */
@Transactional
@Service
public class CmsActivityTemplateServiceImpl implements CmsActivityTemplateService {

    @Autowired
    private CmsActivityTemplateMapper cmsActivityTemplateMapper;
    @Autowired
    private CmsActivityTemplateRelMapper cmsActivityTemplateRelMapper;

    /**
	 * 活动模板列表
	 * @param activityTemplate
	 * @param page
	 * @param sysUser
	 * @return
	 */
    @Override
    public List<CmsActivityTemplate> queryCmsActivityTemplateByCondition(CmsActivityTemplate activityTemplate, Pagination page, SysUser sysUser) {
    	Map<String, Object> map = new HashMap<String, Object>();
        
        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = cmsActivityTemplateMapper.queryActivityTemplateByCount(map);
            //设置分页的总条数来获取总页数
            page.setTotal(total);
        }
        return cmsActivityTemplateMapper.queryActivityTemplateByCondition(map);
    }
    
    /**
     * 添加活动模板
     * @param cmsActivityTemplate 
     * @param sysUser   
     * @return     
     */
	@Override
	public String addActivityTemplate(CmsActivityTemplate cmsActivityTemplate, SysUser sysUser) {
		try {
			cmsActivityTemplate.setTemplId(UUIDUtils.createUUId());
			cmsActivityTemplate.setCreateTime(new Date());
			cmsActivityTemplate.setCreateUser(sysUser.getUserId());
			cmsActivityTemplate.setUpdateTime(new Date());
			cmsActivityTemplate.setUpdateUser(sysUser.getUserId());
			int result = cmsActivityTemplateMapper.addActivityTemplate(cmsActivityTemplate);
			
			String [] functions = cmsActivityTemplate.getFunctions().split(",");
			int result2 = 1;
			for(String id:functions){
				CmsActivityTemplateRel templateRel = new CmsActivityTemplateRel();
				templateRel.setFunId(id);
				templateRel.setTemplId(cmsActivityTemplate.getTemplId());
				int r = cmsActivityTemplateRelMapper.addActivityTemplateRel(templateRel);
				if(r == 0){
					result2 = 0;
				}
			}
			
			if(result == 1 && result2 == 1){
			    return  "success";
			}else{
			    return  "false";
			}
		} catch (Exception e) {
			e.printStackTrace();
			return  "false";
		}
	}
	
	/**
     * 编辑活动模板
     * @param cmsActivityTemplate
     * @param sysUser   
     * @return     
     */
	@Override
	public String editActivityTemplate(CmsActivityTemplate cmsActivityTemplate, SysUser sysUser) {
		try {
			//修改活动模板
			cmsActivityTemplate.setUpdateTime(new Date());
			cmsActivityTemplate.setUpdateUser(sysUser.getUserId());
			int result = cmsActivityTemplateMapper.editActivityTemplate(cmsActivityTemplate);
			
			//删除该模板功能
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("id", cmsActivityTemplate.getTemplId());
			map.put("type", "templId");
			int result2 = cmsActivityTemplateRelMapper.deleteById(map);
			
			//插入新的模板功能
			String [] functions = cmsActivityTemplate.getFunctions().split(",");
			int result3 = 1;
			for(String id:functions){
				CmsActivityTemplateRel templateRel = new CmsActivityTemplateRel();
				templateRel.setFunId(id);
				templateRel.setTemplId(cmsActivityTemplate.getTemplId());
				int r = cmsActivityTemplateRelMapper.addActivityTemplateRel(templateRel);
				if(r == 0){
					result3 = 0;
				}
			}
			
			if(result == 1 && result2 >= 0 && result3 == 1){
			    return  "success";
			}else{
			    return  "false";
			}
		} catch (Exception e) {
			e.printStackTrace();
			return  "false";
		}
	}
	
	/**
     * 根据id删除活动模板
     * @param templId   
     * @return     
     */
	@Override
	public String deleteActivityTemplate(String templId) {
		try {
			int result = cmsActivityTemplateMapper.deleteByPrimaryKey(templId);
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("id", templId);
			map.put("type", "templId");
			int result2 = cmsActivityTemplateRelMapper.deleteById(map);
			if(result == 1 && result2 >= 0){
			    return  "success";
			}else{
			    return  "false";
			}
		} catch (Exception e) {
			e.printStackTrace();
			return  "false";
		}
	}
	
	/**
     * 根据ID查询模板
     * @param templId
     * @return
     */
	@Override
	public CmsActivityTemplate selectByPrimaryKey(String templId) {
		return cmsActivityTemplateMapper.queryActivityTemplateById(templId);
	}

	/**
	 * 根据模板名称，检查是否重复
	 *
	 * @param templateName
	 * @return
	 */
	@Override
	public boolean checkRepeatByName(String templateName) {
		boolean checkResult = true;
		int count = cmsActivityTemplateMapper.checkRepeatByName(templateName);
		if(count>0){
			checkResult = false;
		}
		return checkResult;
	}
}
