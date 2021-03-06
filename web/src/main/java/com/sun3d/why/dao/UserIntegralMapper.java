package com.sun3d.why.dao;

import com.sun3d.why.model.UserIntegral;
/**
 * 用户积分表
 * */
public interface UserIntegralMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table sys_user_integral
     *
     * @mbggenerated Wed Jun 01 15:47:01 CST 2016
     */
    int deleteByPrimaryKey(String integralId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table sys_user_integral
     *
     * @mbggenerated Wed Jun 01 15:47:01 CST 2016
     */
    int insert(UserIntegral record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table sys_user_integral
     *
     * @mbggenerated Wed Jun 01 15:47:01 CST 2016
     */
    int insertSelective(UserIntegral record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table sys_user_integral
     *
     * @mbggenerated Wed Jun 01 15:47:01 CST 2016
     */
    UserIntegral selectByPrimaryKey(String integralId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table sys_user_integral
     *
     * @mbggenerated Wed Jun 01 15:47:01 CST 2016
     */
    int updateByPrimaryKeySelective(UserIntegral record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table sys_user_integral
     *
     * @mbggenerated Wed Jun 01 15:47:01 CST 2016
     */
    int updateByPrimaryKey(UserIntegral record);
    
    UserIntegral selectUserIntegralByUserId(String userId);
}