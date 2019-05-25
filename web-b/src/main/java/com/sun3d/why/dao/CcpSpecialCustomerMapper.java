package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.culturecloud.model.bean.special.CcpSpecialCustomer;
import com.sun3d.why.dao.dto.CcpSpecialCustomerDto;

public interface CcpSpecialCustomerMapper {
	
	int querySumYCodeCount(Map<String,Object> map);

	int queryCustomerCountByCondition(Map<String,Object> map );
	
	List<CcpSpecialCustomerDto>queryCustomerByCondition(Map<String,Object> map );
	
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table ccp_special_customer
     *
     * @mbggenerated Fri Sep 23 17:55:29 CST 2016
     */
    int deleteByPrimaryKey(String customerId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table ccp_special_customer
     *
     * @mbggenerated Fri Sep 23 17:55:29 CST 2016
     */
    int insert(CcpSpecialCustomer record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table ccp_special_customer
     *
     * @mbggenerated Fri Sep 23 17:55:29 CST 2016
     */
    int insertSelective(CcpSpecialCustomer record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table ccp_special_customer
     *
     * @mbggenerated Fri Sep 23 17:55:29 CST 2016
     */
    CcpSpecialCustomer selectByPrimaryKey(String customerId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table ccp_special_customer
     *
     * @mbggenerated Fri Sep 23 17:55:29 CST 2016
     */
    int updateByPrimaryKeySelective(CcpSpecialCustomer record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table ccp_special_customer
     *
     * @mbggenerated Fri Sep 23 17:55:29 CST 2016
     */
    int updateByPrimaryKey(CcpSpecialCustomer record);
}