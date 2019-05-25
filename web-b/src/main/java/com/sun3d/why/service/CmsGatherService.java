package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.CmsGather;
import com.sun3d.why.util.Pagination;

public interface CmsGatherService {

	/**
	 * 市场采集列表
	 * @param ccpAssociation
	 * @param page
	 * @return
	 */
	List<CmsGather> queryGatherByCondition(CmsGather ccpGather, Pagination page);
	
	/**
	 * 根据ID查市场采集信息
	 * @param gatherId
	 * @return
	 */
	CmsGather queryGatherByPrimaryKey(String gatherId);
	
	/**
	 * 保存或更新市场采集
	 * @param ccpGather
	 * @return
	 */
	String saveOrUpdateGather(CmsGather ccpGather);
	
	/**
	 * 删除市场采集
	 * @param gatherId
	 * @return
	 */
	String deleteGather(String gatherId);
	
}
