package com.sun3d.why.dao;

import com.culturecloud.model.bean.common.CcpInformationDetail;

public interface CcpInformationDetailMapper {

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_information_detail
	 * @mbggenerated  Wed Dec 13 15:12:01 CST 2017
	 */
	int deleteByPrimaryKey(String informationDetailId);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_information_detail
	 * @mbggenerated  Wed Dec 13 15:12:01 CST 2017
	 */
	int insert(CcpInformationDetail record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_information_detail
	 * @mbggenerated  Wed Dec 13 15:12:01 CST 2017
	 */
	int insertSelective(CcpInformationDetail record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_information_detail
	 * @mbggenerated  Wed Dec 13 15:12:01 CST 2017
	 */
	CcpInformationDetail selectByPrimaryKey(String informationDetailId);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_information_detail
	 * @mbggenerated  Wed Dec 13 15:12:01 CST 2017
	 */
	int updateByPrimaryKeySelective(CcpInformationDetail record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_information_detail
	 * @mbggenerated  Wed Dec 13 15:12:01 CST 2017
	 */
	int updateByPrimaryKeyWithBLOBs(CcpInformationDetail record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_information_detail
	 * @mbggenerated  Wed Dec 13 15:12:01 CST 2017
	 */
	int updateByPrimaryKey(CcpInformationDetail record);
}