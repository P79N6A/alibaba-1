package com.sun3d.why.dao;

import com.culturecloud.model.bean.common.CcpInformation;
import com.sun3d.why.dao.dto.CcpInformationDto;

import java.util.List;
import java.util.Map;

public interface CcpInformationMapper {
	
	
	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_information
	 * @mbggenerated  Thu Aug 03 20:54:53 CST 2017
	 */
	int deleteByPrimaryKey(String informationId);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_information
	 * @mbggenerated  Thu Aug 03 20:54:53 CST 2017
	 */
	int insert(CcpInformation record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_information
	 * @mbggenerated  Thu Aug 03 20:54:53 CST 2017
	 */
	int insertSelective(CcpInformation record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_information
	 * @mbggenerated  Thu Aug 03 20:54:53 CST 2017
	 */
	CcpInformation selectByPrimaryKey(String informationId);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_information
	 * @mbggenerated  Thu Aug 03 20:54:53 CST 2017
	 */
	int updateByPrimaryKeySelective(CcpInformation record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_information
	 * @mbggenerated  Thu Aug 03 20:54:53 CST 2017
	 */
	int updateByPrimaryKeyWithBLOBs(CcpInformation record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_information
	 * @mbggenerated  Thu Aug 03 20:54:53 CST 2017
	 */
	int updateByPrimaryKey(CcpInformation record);

	int queryInformationByConditionCount(Map<String, Object> map);

	List<CcpInformationDto>queryInformationByCondition(Map<String, Object> map);
}