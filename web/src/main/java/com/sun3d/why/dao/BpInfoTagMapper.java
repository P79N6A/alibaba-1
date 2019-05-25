package com.sun3d.why.dao;

import java.util.List;

import com.sun3d.why.model.BpInfoTag;

public interface BpInfoTagMapper {

	/**
	 * 根据父标签编码查找子标签编码集合
	 * @param parentTagCode
	 * @return
	 */
	List<BpInfoTag> queryChildTagByCode(String parentTagCode);

	/**
	 * 查找父标签集合
	 * @return
	 */
	List<BpInfoTag> queryParentTagsByCode(String module);

	/**
	 * 根据子标签查找子标签集合
	 * @param infoTagCode
	 * @return
	 */
	List<BpInfoTag> queryChildTagsByChildCode(String infoTagCode);

	/**
	 * 根据子标签查找父标签
	 * @param infoTagCode
	 * @return
	 */
	BpInfoTag queryParentTagByCode(String infoTagCode);
	
}