package com.sun3d.why.service;

import com.sun3d.why.common.Result;
import com.sun3d.why.model.bean.yket.SysUser;
import com.sun3d.why.model.bean.yket.YketTeacherInfo;

public interface YketTeacherService {

	Result addTeacher(YketTeacherInfo teacher,SysUser user);
	
	Result editTeacher(YketTeacherInfo teacher,SysUser user);
	
	Result deleteTeacher(String teacherId,SysUser user);
	
	Result getTeacher(String teacherId);

	
}
