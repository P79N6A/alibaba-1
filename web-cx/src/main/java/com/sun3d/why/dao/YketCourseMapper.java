package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.bean.yket.YketCourse;
import com.sun3d.why.model.bean.yket.YketCourseHour;
import com.sun3d.why.model.vo.yket.RecommandCourseVo;
import com.sun3d.why.model.vo.yket.YketCourse4FrontVo;
import com.sun3d.why.model.vo.yket.YketCourseList4FrontVo;
import com.sun3d.why.model.vo.yket.YketCourseListVo;
import com.sun3d.why.model.vo.yket.YketCourseVo;

public interface YketCourseMapper {
    int deleteByPrimaryKey(String courseId);

    int insert(YketCourse record);

    int insertSelective(YketCourse record);

    YketCourse selectByPrimaryKey(String courseId);

    int updateByPrimaryKeySelective(YketCourse record);

    int updateByPrimaryKey(YketCourse record);

	Integer countCourseTime(Map<String, Object> map);

	List<YketCourseHour> queryCourseTimeList(Map<String, Object> map);
	
	
	List<YketCourseListVo> courList(Map<String,Object> conds);
    Integer  countCourse(Map<String,Object> conds);
    
    
    YketCourseVo getCourseInfo(String courseId);
    
    
    @Deprecated
	List<YketCourse> queryFrontYketCourseList(Map<String, Object> map);
    
    
    List<YketCourseList4FrontVo> courseList4Front(Map<String, String> map);
    
    
    YketCourse4FrontVo getCourseInfo4Front(Map<String, Object> map);

    
    RecommandCourseVo recommandCourse(Map<String,Object> conds);

}