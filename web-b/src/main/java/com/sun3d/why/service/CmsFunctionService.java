package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.CmsFunction;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

public interface CmsFunctionService {

	/**
	 * 模板功能列表
	 * @param cmsFunction
	 * @param page
	 * @param sysUser
	 * @return
	 */
	List<CmsFunction> queryCmsFunctionByCondition(CmsFunction cmsFunction, Pagination page, SysUser sysUser);
	
	/**
     * 添加模板功能
     * @param cmsFunction 
     * @param sysUser   
     * @return     
     */
    String addFunction(CmsFunction cmsFunction, SysUser sysUser);
    
    /**
     * 编辑模板功能
     * @param cmsFunction 
     * @param sysUser   
     * @return     
     */
    String editFunction(CmsFunction cmsFunction, SysUser sysUser);
    
    /**
     * 根据id删除模型功能
     * @param functionId   
     * @return     
     */
    String deleteFunction(String functionId);
    
    /**
     * 根据ID查询功能
     * @param funId
     * @return
     */
    CmsFunction selectByPrimaryKey(String funId);

    /**
     *  根据功能名称，检查是否重复
     * @param functionName
     * @return
     */
    boolean checkRepeatByName(String functionName);
}
