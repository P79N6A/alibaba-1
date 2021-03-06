package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.BpInfo;

public interface BpInfoMapper {

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table bp_info
	 * @mbggenerated  Wed Aug 09 15:37:09 CST 2017
	 */
	int deleteByPrimaryKey(String beipiaoinfoId);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table bp_info
	 * @mbggenerated  Wed Aug 09 15:37:09 CST 2017
	 */
	int insert(BpInfo record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table bp_info
	 * @mbggenerated  Wed Aug 09 15:37:09 CST 2017
	 */
	int insertSelective(BpInfo record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table bp_info
	 * @mbggenerated  Wed Aug 09 15:37:09 CST 2017
	 */
	BpInfo selectByPrimaryKey(String beipiaoinfoId);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table bp_info
	 * @mbggenerated  Wed Aug 09 15:37:09 CST 2017
	 */
	int updateByPrimaryKeySelective(BpInfo record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table bp_info
	 * @mbggenerated  Wed Aug 09 15:37:09 CST 2017
	 */
	int updateByPrimaryKeyWithBLOBs(BpInfo record);

	/**
	 * This method was generated by MyBatis Generator. This method corresponds to the database table bp_info
	 * @mbggenerated  Wed Aug 09 15:37:09 CST 2017
	 */
	int updateByPrimaryKey(BpInfo record);

	/**
	 * 根据条件查询出列表总数
	 * @param queryMap
	 * @return
	 */
	int queryTotal(Map<String, Object> queryMap);

	/**
	 * 根据条件查询出当前页数据
	 * @param queryMap
	 * @return
	 */
	List<BpInfo> queryListByMap(Map<String, Object> queryMap);

	/**
	 * 根据类型查处当前类型number的集合
	 * @param infoTag
	 * @return
	 */
	List<String> queryNumberByTag(String infoTag);

}