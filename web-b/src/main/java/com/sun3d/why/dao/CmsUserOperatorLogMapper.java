package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.CmsUserOperatorLog;

public interface CmsUserOperatorLogMapper {

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table cms_user_operator_log
	 * @mbggenerated  Mon Jun 27 12:51:36 CST 2016
	 */
	int deleteByPrimaryKey(String orderLogId);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table cms_user_operator_log
	 * @mbggenerated  Mon Jun 27 12:51:36 CST 2016
	 */
	int insert(CmsUserOperatorLog record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table cms_user_operator_log
	 * @mbggenerated  Mon Jun 27 12:51:36 CST 2016
	 */
	int insertSelective(CmsUserOperatorLog record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table cms_user_operator_log
	 * @mbggenerated  Mon Jun 27 12:51:36 CST 2016
	 */
	CmsUserOperatorLog selectByPrimaryKey(String orderLogId);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table cms_user_operator_log
	 * @mbggenerated  Mon Jun 27 12:51:36 CST 2016
	 */
	int updateByPrimaryKeySelective(CmsUserOperatorLog record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table cms_user_operator_log
	 * @mbggenerated  Mon Jun 27 12:51:36 CST 2016
	 */
	int updateByPrimaryKeyWithBLOBs(CmsUserOperatorLog record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table cms_user_operator_log
	 * @mbggenerated  Mon Jun 27 12:51:36 CST 2016
	 */
	int updateByPrimaryKey(CmsUserOperatorLog record);
	
	List<CmsUserOperatorLog> queryCmsUserOperatorLogByModel(Map<String,Object> data);
}