package com.culturecloud.dao.association;

import com.culturecloud.model.bean.association.CcpAssociationRes;

import java.util.List;
import java.util.Map;

public interface CcpAssociationResMapper {

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_association_res
	 * @mbggenerated  Tue Jul 26 15:32:44 CST 2016
	 */
	int deleteByPrimaryKey(String resId);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_association_res
	 * @mbggenerated  Tue Jul 26 15:32:44 CST 2016
	 */
	int insert(CcpAssociationRes record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_association_res
	 * @mbggenerated  Tue Jul 26 15:32:44 CST 2016
	 */
	int insertSelective(CcpAssociationRes record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_association_res
	 * @mbggenerated  Tue Jul 26 15:32:44 CST 2016
	 */
	CcpAssociationRes selectByPrimaryKey(String resId);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_association_res
	 * @mbggenerated  Tue Jul 26 15:32:44 CST 2016
	 */
	int updateByPrimaryKeySelective(CcpAssociationRes record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table ccp_association_res
	 * @mbggenerated  Tue Jul 26 15:32:44 CST 2016
	 */
	int updateByPrimaryKey(CcpAssociationRes record);
	
	int getAssociationResCount(Map<String, Object> param);
	List<CcpAssociationRes> getAssociationRes(Map<String, Object> map);
}