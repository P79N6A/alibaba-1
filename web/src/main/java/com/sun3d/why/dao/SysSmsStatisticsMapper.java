package com.sun3d.why.dao;

import java.util.Date;

import com.culturecloud.model.bean.common.SysSmsStatistics;

public interface SysSmsStatisticsMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table sys_sms_statistics
     *
     * @mbggenerated Thu May 04 16:54:35 CST 2017
     */
    int deleteByPrimaryKey(String smsId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table sys_sms_statistics
     *
     * @mbggenerated Thu May 04 16:54:35 CST 2017
     */
    int insert(SysSmsStatistics record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table sys_sms_statistics
     *
     * @mbggenerated Thu May 04 16:54:35 CST 2017
     */
    int insertSelective(SysSmsStatistics record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table sys_sms_statistics
     *
     * @mbggenerated Thu May 04 16:54:35 CST 2017
     */
    SysSmsStatistics selectByPrimaryKey(String smsId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table sys_sms_statistics
     *
     * @mbggenerated Thu May 04 16:54:35 CST 2017
     */
    int updateByPrimaryKeySelective(SysSmsStatistics record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table sys_sms_statistics
     *
     * @mbggenerated Thu May 04 16:54:35 CST 2017
     */
    int updateByPrimaryKey(SysSmsStatistics record);
    
    SysSmsStatistics querySysSmsStatisticsBydate(Date date);
}