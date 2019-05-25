package com.sun3d.why.dao;

import java.util.List;

import com.sun3d.why.dao.dto.QygProjectEntryDto;
import com.sun3d.why.model.qyg.QygProjectEntry;
import com.sun3d.why.model.qyg.QygVote;

public interface QygProjectEntryMapper {
	
	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table qyg_project_entry
	 * @mbggenerated  Sun Dec 18 20:21:53 CST 2016
	 */
	int deleteByPrimaryKey(String entryId);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table qyg_project_entry
	 * @mbggenerated  Sun Dec 18 20:21:53 CST 2016
	 */
	int insert(QygProjectEntry record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table qyg_project_entry
	 * @mbggenerated  Sun Dec 18 20:21:53 CST 2016
	 */
	int insertSelective(QygProjectEntry record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table qyg_project_entry
	 * @mbggenerated  Sun Dec 18 20:21:53 CST 2016
	 */
	QygProjectEntryDto selectByPrimaryKey(String entryId);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table qyg_project_entry
	 * @mbggenerated  Sun Dec 18 20:21:53 CST 2016
	 */
	int updateByPrimaryKeySelective(QygProjectEntry record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table qyg_project_entry
	 * @mbggenerated  Sun Dec 18 20:21:53 CST 2016
	 */
	int updateByPrimaryKeyWithBLOBs(QygProjectEntry record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table qyg_project_entry
	 * @mbggenerated  Sun Dec 18 20:21:53 CST 2016
	 */
	int updateByPrimaryKey(QygProjectEntry record);

	List<QygProjectEntryDto> queryQygEntryList(QygProjectEntryDto entry);
	
	int insertVote(QygVote record);
}