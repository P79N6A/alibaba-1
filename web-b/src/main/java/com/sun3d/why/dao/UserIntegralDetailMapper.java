package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.UserIntegralDetail;
import com.sun3d.why.util.Pagination;
/**
 * 用户积分详情表
 * */
public interface UserIntegralDetailMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table sys_user_integral_detail
     *
     * @mbggenerated Wed Jun 01 15:48:50 CST 2016
     */
    int deleteByPrimaryKey(String integralDetailId);
    
    int deleteByCondition(UserIntegralDetail record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table sys_user_integral_detail
     *
     * @mbggenerated Wed Jun 01 15:48:50 CST 2016
     */
    int insert(UserIntegralDetail record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table sys_user_integral_detail
     *
     * @mbggenerated Wed Jun 01 15:48:50 CST 2016
     */
    int insertSelective(UserIntegralDetail record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table sys_user_integral_detail
     *
     * @mbggenerated Wed Jun 01 15:48:50 CST 2016
     */
    UserIntegralDetail selectByPrimaryKey(String integralDetailId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table sys_user_integral_detail
     *
     * @mbggenerated Wed Jun 01 15:48:50 CST 2016
     */
    int updateByPrimaryKeySelective(UserIntegralDetail record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table sys_user_integral_detail
     *
     * @mbggenerated Wed Jun 01 15:48:50 CST 2016
     */
    int updateByPrimaryKey(UserIntegralDetail record);
    
    /**
     * 查询用户IntegralId 下的所有积分记录
     * 
     * @param map
     * @return
     */
    List<UserIntegralDetail> queryUserIntegralDetailByIntegralId(Map<String, Object> map);
    
    int  queryUserIntegralDetailCountByIntegralId(Map<String, Object> map);
    
    /**
     * 获取用户今日登录
     * @param map
     * @return
     */
    List<UserIntegralDetail> queryUserTodayLoginIntegralDetail(String integralId );
    
    List<UserIntegralDetail> queryUserIntegralDetail(Map<String, Object> map);
}