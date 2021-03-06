package com.culturecloud.dao.common;

import java.util.List;
import java.util.Map;

import com.culturecloud.dao.dto.common.SysUserIntegralDetailDto;
import com.culturecloud.model.bean.common.SysUserIntegralDetail;
/**
 * 用户积分详情表
 * */
public interface SysUserIntegralDetailMapper {
	
	/**
     * 查询用户的积分列表数据
     * @param map
     * @return
     */
    List<SysUserIntegralDetailDto> queryUserIntegralDetail(Map<String, Object> map);
	
	 /**
     * 获取用户今日登录
     * @param map
     * @return
     */
    List<SysUserIntegralDetail> queryUserTodayLoginIntegralDetail(String integralId );
	
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table sys_user_integral_detail
     *
     * @mbggenerated Wed Jun 01 15:48:50 CST 2016
     */
    int deleteByPrimaryKey(String integralDetailId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table sys_user_integral_detail
     *
     * @mbggenerated Wed Jun 01 15:48:50 CST 2016
     */
    int insert(SysUserIntegralDetail record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table sys_user_integral_detail
     *
     * @mbggenerated Wed Jun 01 15:48:50 CST 2016
     */
    int insertSelective(SysUserIntegralDetail record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table sys_user_integral_detail
     *
     * @mbggenerated Wed Jun 01 15:48:50 CST 2016
     */
    SysUserIntegralDetail selectByPrimaryKey(String integralDetailId);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table sys_user_integral_detail
     *
     * @mbggenerated Wed Jun 01 15:48:50 CST 2016
     */
    int updateByPrimaryKeySelective(SysUserIntegralDetail record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table sys_user_integral_detail
     *
     * @mbggenerated Wed Jun 01 15:48:50 CST 2016
     */
    int updateByPrimaryKey(SysUserIntegralDetail record);
    
   
}