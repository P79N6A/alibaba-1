package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.CmsFunction;

public interface CmsFunctionMapper {
	/**
	 * 模板功能列表
	 * @param map
	 * @return
	 */
	List<CmsFunction> queryFunctionByCondition(Map<String, Object> map);
	
	/**
	 * 模板功能总数
	 * @param map
	 * @return
	 */
	int queryFunctionByCount(Map<String, Object> map);
	
	/**
	 * 删除功能
	 * @param funId
	 * @return
	 */
    int deleteByPrimaryKey(String funId);
    
    /**
     * 添加功能
     * @param record
     * @return
     */
    int insert(CmsFunction record);
    
    /**
     * 根据ID查询功能
     * @param funId
     * @return
     */
    CmsFunction selectByPrimaryKey(String funId);
    
    /**
     * 编辑功能
     * @param record
     * @return
     */
    int updateByPrimaryKey(CmsFunction record);

    /**
     *  根据功能名称，检查是否重复
     * @param functionName
     * @return
     */
    int checkRepeatByName(String functionName);
}