package com.sun3d.why.dao;

import com.culturecloud.model.bean.common.CcpInformationType;

import java.util.List;
import java.util.Map;

public interface CcpInformationTypeMapper {
	
	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_information_type
	 * @mbggenerated  Tue Aug 01 19:49:51 CST 2017
	 */
	int deleteByPrimaryKey(String informationTypeId);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_information_type
	 * @mbggenerated  Tue Aug 01 19:49:51 CST 2017
	 */
	int insert(CcpInformationType record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_information_type
	 * @mbggenerated  Tue Aug 01 19:49:51 CST 2017
	 */
	int insertSelective(CcpInformationType record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_information_type
	 * @mbggenerated  Tue Aug 01 19:49:51 CST 2017
	 */
	CcpInformationType selectByPrimaryKey(String informationTypeId);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_information_type
	 * @mbggenerated  Tue Aug 01 19:49:51 CST 2017
	 */
	int updateByPrimaryKeySelective(CcpInformationType record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_information_type
	 * @mbggenerated  Tue Aug 01 19:49:51 CST 2017
	 */
	int updateByPrimaryKey(CcpInformationType record);

	List<CcpInformationType> queryInformationTypeByCondition(Map<String, Object> map);

	int queryInformationTypeByConditionCount(Map<String, Object> map);
	
	int queryTypeUseCount(String typeId);
}