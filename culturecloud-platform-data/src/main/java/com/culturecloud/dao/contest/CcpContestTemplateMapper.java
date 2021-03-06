package com.culturecloud.dao.contest;

import com.culturecloud.model.bean.contest.CcpContestTemplate;

public interface CcpContestTemplateMapper {

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_contest_template
	 * @mbggenerated  Tue Nov 01 18:57:48 CST 2016
	 */
	int deleteByPrimaryKey(String templateId);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_contest_template
	 * @mbggenerated  Tue Nov 01 18:57:48 CST 2016
	 */
	int insert(CcpContestTemplate record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_contest_template
	 * @mbggenerated  Tue Nov 01 18:57:48 CST 2016
	 */
	int insertSelective(CcpContestTemplate record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_contest_template
	 * @mbggenerated  Tue Nov 01 18:57:48 CST 2016
	 */
	CcpContestTemplate selectByPrimaryKey(String templateId);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_contest_template
	 * @mbggenerated  Tue Nov 01 18:57:48 CST 2016
	 */
	int updateByPrimaryKeySelective(CcpContestTemplate record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_contest_template
	 * @mbggenerated  Tue Nov 01 18:57:48 CST 2016
	 */
	int updateByPrimaryKey(CcpContestTemplate record);
}