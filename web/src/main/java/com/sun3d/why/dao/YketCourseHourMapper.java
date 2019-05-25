package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.bean.yket.YketCourseHour;

public interface YketCourseHourMapper {
    int deleteByPrimaryKey(String hourId);

    int insert(YketCourseHour record);

    int insertSelective(YketCourseHour record);

    YketCourseHour selectByPrimaryKey(String hourId);

    int updateByPrimaryKeySelective(YketCourseHour record);

    int updateByPrimaryKey(YketCourseHour record);

	int countCourseTime(Map<String, Object> map);

	List<YketCourseHour> queryCourseTimeList(Map<String, Object> map);

	Integer maxSort();

	List<YketCourseHour> moveUp(Map<String, Object> map);

	List<YketCourseHour> moveDown(Map<String, Object> map);

	int queryHourName(Map<String, Object> map);

}