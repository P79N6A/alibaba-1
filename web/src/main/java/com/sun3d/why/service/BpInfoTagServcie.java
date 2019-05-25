package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.BpInfoTag;

public interface BpInfoTagServcie {

	/**
	 * 查找页面父标签
	 * @param infoTagCode
	 * @return
	 */
	List<BpInfoTag> queryParentTag();

	/**
	 * 查找页面父标签
	 * @param infoTagCode
	 * @return
	 */
	List<BpInfoTag> queryParentTag(String module);

	/**
	 * 根据子标签查找兄弟标签
	 * @param infoTagCode
	 * @return
	 */
	List<BpInfoTag> queryChildTagByChildTag(String infoTagCode);

	/**
	 * 根据子标签查找父标签
	 * @param infoTagCode
	 * @return
	 */
	BpInfoTag queryParentTagByCode(String infoTagCode);

	/**
	 * 根据父标签查找子标签集合
	 * @param parentTagCode
	 * @return
	 */
	List<BpInfoTag> queryChildTags(String parentTagCode);

}
