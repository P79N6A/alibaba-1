package com.culturecloud.dao.common;

import java.util.List;
import java.util.Map;

import com.culturecloud.dao.dto.common.SysUserIntegralDetailDto;
import com.culturecloud.model.bean.common.SysUserIntegralDetail;

/**
 * 用户积分详情表
 * */
public interface SysUserIntegralDetailMapper {
	
	 int insertSelective(SysUserIntegralDetail record);
    
	  
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
    List<SysUserIntegralDetailDto> queryUserTodayLoginIntegralDetail(String integralId );
}