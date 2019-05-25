package com.sun3d.why.service.impl;

import java.util.Date;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sun3d.why.common.Result;
import com.sun3d.why.dao.YketTeacherInfoMapper;
import com.sun3d.why.enumeration.RSKeyEnum;
import com.sun3d.why.exception.UserReadableException;
import com.sun3d.why.model.bean.yket.SysUser;
import com.sun3d.why.model.bean.yket.YketTeacherInfo;
import com.sun3d.why.service.YketTeacherService;
import com.sun3d.why.util.UUIDUtils;
@Service
public class YketTeacherServiceImpl implements YketTeacherService {

	@Autowired
	YketTeacherInfoMapper teacherInfoMapper ;
	
	private final Logger log = Logger.getLogger(YketTeacherServiceImpl.class);
	
	
	@Override
	public Result addTeacher(YketTeacherInfo teacher,SysUser user) {
		log.trace("添加老师：参数 :"+teacher);
		teacher.setTeacherId(UUIDUtils.createUUId());
		teacher.setCreateTime(new Date());
		teacher.setUpdateTime(new Date());
		teacher.setCreateUser(user.getUserId());
		teacher.setUpdateUser(user.getUserId());
		teacher.setDeleted(false);
		int res= teacherInfoMapper.insert(teacher);
		if(res>0){
			return Result.Ok().setVal(RSKeyEnum.data, teacher);
		}
		return Result.Error().setVal(RSKeyEnum.msg, "添加老师失败");
	}

	@Override
	public Result editTeacher(YketTeacherInfo teacher,SysUser user) {
		YketTeacherInfo old= this.teacherInfoMapper.selectYketTeacherInfo(teacher.getTeacherId());
		old.setTeacherIntro(teacher.getTeacherIntro());
		old.setTeacherHeaderImg(teacher.getTeacherHeaderImg());
		old.setTeacherName(teacher.getTeacherName());
		old.setTeacherTitle(teacher.getTeacherTitle());
		old.setUpdateTime(new Date());
		old.setUpdateUser(user.getUserId());
 		int res= teacherInfoMapper.updateTeacherInfo(old);
		if(res>0){
			return Result.Ok().setVal(RSKeyEnum.data, teacher);
		}
		return Result.Error().setVal(RSKeyEnum.msg, "更新老师失败");
	}

	@Override
	public Result deleteTeacher(String teacherId,SysUser user) {
		YketTeacherInfo old= this.teacherInfoMapper.selectYketTeacherInfo(teacherId);
		old.setUpdateTime(new Date());
		old.setUpdateUser(user.getUserId());
		old.setDeleted(true);
		int res=0;
		try{
			res=teacherInfoMapper.updateTeacherInfo(old);
		}catch(Exception e){
			e.printStackTrace();
			throw new UserReadableException("更新失败");
		}
		if(res>0){
			return Result.Ok().setVal(RSKeyEnum.data, teacherId);
		}
		return Result.Error().setVal(RSKeyEnum.msg, "删除老师失败");
 	}
	
	@Override
	public Result getTeacher(String teacherId) {
		return Result.Ok().setVal(RSKeyEnum.data, this.teacherInfoMapper.selectYketTeacherInfo(teacherId));
	}

}
