package com.sun3d.why.dao;

import com.sun3d.why.model.AppAdvertCalendar;

import java.util.List;
import java.util.Map;

public interface AppAdvertCalendarMapper {
    int deleteByPrimaryKey(String advertId);

    AppAdvertCalendar getAdvert(String advertId);
    int addAdvert(AppAdvertCalendar record);

    int editAdvert(AppAdvertCalendar record);

    /**
     * 根据传入的map查询活动列表信息
     * @param map  查询条件
     * @return 活动列表信息
     */
    List<AppAdvertCalendar> selectAdvertIndex(Map<String, Object> map);
    /**
     * 根据广告sql语句示例条件查询符合的信息总数，一般分页功能的时候需要用到该方法
     *
     * @param map 带查询条件的map集合
     * @return int 查询结果总数
     */
    int selectAdvertCount(Map<String,Object> map);
    
    /**
     * 根据日期查询广告位
     * @return
     */
    AppAdvertCalendar queryCalendarAdvertByDate(Map<String,Object> map);
}