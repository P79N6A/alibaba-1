package com.sun3d.why.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.CmsActivityTemplateRelMapper;
import com.sun3d.why.dao.CmsFunctionMapper;
import com.sun3d.why.model.CmsFunction;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsFunctionService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

@Transactional
@Service
public class CmsFunctionServiceImpl implements CmsFunctionService {

    @Autowired
    private CmsFunctionMapper cmsFunctionMapper;
    @Autowired
    private CmsActivityTemplateRelMapper cmsActivityTemplateRelMapper;
    
    /**
	 * 模板功能列表
	 * @param cmsFunction
	 * @param page
	 * @param sysUser
	 * @return
	 */
    @Override
    public List<CmsFunction> queryCmsFunctionByCondition(CmsFunction cmsFunction, Pagination page, SysUser sysUser) {
    	Map<String, Object> map = new HashMap<String, Object>();
        
        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = cmsFunctionMapper.queryFunctionByCount(map);
            //设置分页的总条数来获取总页数
            page.setTotal(total);
        }
        return cmsFunctionMapper.queryFunctionByCondition(map);
    }
    
    /**
     * 添加模板功能
     * @param cmsFunction 
     * @param sysUser   
     * @return     
     */
	@Override
	public String addFunction(CmsFunction cmsFunction, SysUser sysUser) {
		try {
			cmsFunction.setFunId(UUIDUtils.createUUId());
			cmsFunction.setCreateTime(new Date());
			cmsFunction.setCreateUser(sysUser.getUserId());
			cmsFunction.setUpdateTime(new Date());
			cmsFunction.setUpdateUser(sysUser.getUserId());
			int result = cmsFunctionMapper.insert(cmsFunction);
			if(result == 1){
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
     * 编辑模板功能
     * @param cmsFunction
     * @param sysUser   
     * @return     
     */
	@Override
	public String editFunction(CmsFunction cmsFunction, SysUser sysUser) {
		try {
			cmsFunction.setUpdateTime(new Date());
			cmsFunction.setUpdateUser(sysUser.getUserId());
			int result = cmsFunctionMapper.updateByPrimaryKey(cmsFunction);
			if(result == 1){
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
     * 根据id删除模型功能
     * @param functionId   
     * @return     
     */
	@Override
	public String deleteFunction(String functionId) {
		try {
			int result = cmsFunctionMapper.deleteByPrimaryKey(functionId);
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("id", functionId);
			map.put("type", "funId");
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
     * 根据ID查询功能
     * @param funId
     * @return
     */
	@Override
	public CmsFunction selectByPrimaryKey(String funId) {
		return cmsFunctionMapper.selectByPrimaryKey(funId);
	}

	/**
	 * 根据功能名称，检查是否重复
	 *
	 * @param functionName
	 * @return
	 */
	@Override
	public boolean checkRepeatByName(String functionName) {
		boolean checkResult = true;
		int count = cmsFunctionMapper.checkRepeatByName(functionName);
		if(count>0){
			checkResult = false;
		}
		return checkResult;
	}
}
