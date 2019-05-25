package com.sun3d.why.service.impl;

import com.sun3d.why.dao.CourseMapper;
import com.sun3d.why.model.*;
import com.sun3d.why.model.peopleTrain.Course;
import com.sun3d.why.model.peopleTrain.CourseOrderTemp;
import com.sun3d.why.service.*;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.*;

@Service
@Transactional
public class CourseServiceImpl implements CourseService {
	@Autowired
	private CourseMapper courseMapper;
	
	private org.apache.log4j.Logger logger = org.apache.log4j.Logger.getLogger(CmsVenueServiceImpl.class);
	
	@Override
	public List<Course> queryCourseByCondition(String courseType, String courseField,String searchKey, Course course,
			Pagination page, SysUser sysUser) {
		Map<String, Object> map = new HashMap<String, Object>();
		// 权限验证
		if (sysUser != null && StringUtils.isNotBlank(sysUser.getUserCounty()) && ((sysUser.getUserCounty()).indexOf("44")==-1 && (sysUser.getUserCounty()).indexOf("45")==-1)){
			map.put("sysUserId", sysUser.getUserId());
		}
		if(StringUtils.isNotBlank(courseType)){
			map.put("courseType", courseType);
		}
		if(StringUtils.isNotBlank(courseField)){
			map.put("courseField", courseField);
		}
		   if(StringUtils.isNotBlank(searchKey)){
               map.put("searchKey", searchKey);
           }
        //分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            int total = courseMapper.queryCourserCountByCondition(map);
            page.setTotal(total);
        }

		return courseMapper.queryCourserByCondition(map);
	}
	
	@Override
	public List<Course> queryCourseListForFront(Map<String, Object> map) {
		
		return courseMapper.queryCourseListForFront(map);
	}
	
	public Course queryCourseByCourseId(String courseId){
		return courseMapper.queryCourseByCourseId(courseId);
	}

	@Override
	public List<Course> queryCourseByIn(CourseOrderTemp temp) {
		String [] courseIds = temp.getCourseId();
		StringBuffer sb = new StringBuffer(" c.COURSE_ID in ( ");
		for(int i=0;i<courseIds.length-1;i++){
			sb.append("\'").append(courseIds[i]).append("\'").append(",");
		}
		sb.append("\'").append(courseIds[courseIds.length-1]).append("\'").append(" )");
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("sqlStr",sb.toString());
		return courseMapper.queryCourseByIn(map);
	}
	
	@Override
	public int saveCourse(Course course, SysUser sysUser) {
		 int count = 0;
	        try{
	        	course.setCourseId(UUIDUtils.createUUId());
	        	course.setCreateUser(sysUser.getUserAccount());
	        	course.setCreateUserId(sysUser.getUserId());
	        	course.setCreateTime(new Date());
	        	course.setCourseState(2);
	        	course.setCourseCheck(1);
	            count = courseMapper.saveCourse(course);
	        }catch (Exception e){
	            logger.error("保存课程失败!",e);
	            return count;
	        }
	        return count;
	}
	
	@Override
	public int editState(Course course, String state,String checkState) {
		  if (StringUtils.isNotBlank(state)){
			  course.setCourseState(Integer.valueOf(state));
			  
		  }
		  if (StringUtils.isNotBlank(checkState)){
			  course.setCourseCheck(Integer.valueOf(checkState));
			  
		  }
		  return courseMapper.editState(course);
	}
	
	@Override
	public int editSaveCourse(Course course) {
		return courseMapper.editState(course);
	}
	
	
}
