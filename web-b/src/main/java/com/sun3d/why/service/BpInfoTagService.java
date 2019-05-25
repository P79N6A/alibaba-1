package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.BpInfoTag;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

public interface BpInfoTagService {

	/**
	 * 列表+检索
	 * 
	 * @param page
	 * @param bpInfoTag
	 * @return
	 */
	List<BpInfoTag> queryTagList(Pagination page, BpInfoTag bpInfoTag);

	/**
	 * 删除
	 * 
	 * @param tagid
	 * @param loginUser
	 */
	void delInfo(String tagid, SysUser loginUser);

	/**
	 * 编辑前的数据回显
	 * 
	 * @param tagId
	 * @return
	 */
	BpInfoTag selectTagById(String tagId);

	/**
	 * 添加+更新
	 * 
	 * @param bpInfoTag
	 * @param sysUser
	 * @return
	 */
	String addAndEditTag(BpInfoTag bpInfoTag, SysUser sysUser);

	/**
	 * 查找父标签
	 * 
	 * @return
	 */
	List<BpInfoTag> queryPTagByStatus();

	/**
	 * 根据父标签查找子标签
	 * 
	 * @param parentId
	 * @return
	 */
	List<BpInfoTag> queryChildTag(String parentId);

	/**
	 * 根据module查询
	 *
	 * @param module
	 * @return
	 */
	List<BpInfoTag> queryChildTagByMobule(String module);
	List<BpInfoTag> queryChildTagByTagCode(String tagCode);
	List<BpInfoTag> queryTagsByModule(String module);

}
