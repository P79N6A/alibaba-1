package com.sun3d.why.service;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.CcpJiazhouInfo;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

public interface CcpJiazhouInfoService {

	/**
     * 根据资讯对象查询资讯列表信息
     *
     * @param jiazhouInfo 资讯对象
     * @param page     分页对象
     * @param sysUser  用户对象
     * @return 资讯列表信息
     */
	List<CcpJiazhouInfo> jiazhouInfoList(CcpJiazhouInfo jiazhouInfo, Pagination page,
			SysUser sysUser);
	
	/**
     * 新增资讯
     *
     * @param jiazhouInfo 资讯对象
     * @return 新增信息
     */
	String addJiazhouInfo(CcpJiazhouInfo jiazhouInfo, SysUser sysUser);
	
	 /**
     * 根据id读取资讯
     *
     * @return jiazhouInfo
     */
	CcpJiazhouInfo getJiazhouInfo(String jiazhouInfoId);

	/**
     * 根据编码读取分类
     *
     * @return List
     */
	List<Map<String, Object>> getJiazhouInfoSortList(String dictCode);
	
	/**
     * 根据id删除资讯
     *
     * @return jiazhouInfo
     */
	void delJiazhouInfo(String jiazhouInfoId);

}
