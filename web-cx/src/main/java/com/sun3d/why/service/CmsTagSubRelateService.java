package com.sun3d.why.service;

import java.util.List;
import java.util.Set;

import com.sun3d.why.model.CmsTagSubRelate;

public interface CmsTagSubRelateService {
	
	
	/**
	 * 插入元素 标签关系
	 * 
	 * @param keyId
	 * @param type
	 * @param tagIds
	 * @return
	 */
	public int insertTagRelateList(String keyId,Integer type,String []tagIds);
	
	/**
	 * 更新元素 标签记录(set中没有的tagId 会被删除)
	 * 
	 * @param keyId
	 * @param type
	 * @param tagIds
	 * @return
	 */
	public int updateEntityTagRelateList(String keyId,Integer type,Set<String>allTagIdSet);
	
	/**
	 * 查询元素的所有标签
	 * 
	 * @param keyId
	 * @return
	 */
	public List<CmsTagSubRelate> queryTagRelateByEntityId(String keyId);
}
