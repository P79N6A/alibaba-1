package com.sun3d.why.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sun3d.why.common.Result;
import com.sun3d.why.dao.YketCommentMapper;
import com.sun3d.why.dao.YketCourseMapper;
import com.sun3d.why.dao.YketCourseTeacherMapper;
import com.sun3d.why.dao.YketLabelRelationMapper;
import com.sun3d.why.enumeration.CommentTypeEnum;
import com.sun3d.why.enumeration.LabelTypeEnum;
import com.sun3d.why.exception.UserReadableException;
import com.sun3d.why.model.bean.yket.SysUser;
import com.sun3d.why.model.bean.yket.YketCourse;
import com.sun3d.why.model.bean.yket.YketCourseTeacher;
import com.sun3d.why.model.bean.yket.YketLabel;
import com.sun3d.why.model.bean.yket.YketLabelRelationKey;
import com.sun3d.why.model.bean.yket.YketTeacherInfo;
import com.sun3d.why.model.vo.yket.YketCourse4FrontVo;
import com.sun3d.why.model.vo.yket.YketCourseList4FrontVo;
import com.sun3d.why.model.vo.yket.YketCourseListVo;
import com.sun3d.why.model.vo.yket.YketCourseVo;
import com.sun3d.why.service.YketCourseService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

@Service
public class YketCourseServiceImpl implements YketCourseService {

	private final Logger log = Logger.getLogger(YketCourseServiceImpl.class);

	@Autowired
	private YketCourseMapper courseMapper;

	@Autowired
	private YketLabelRelationMapper labelRelationMapper;

	@Autowired
	private YketCourseTeacherMapper courseTeacherMapper;

	@Autowired
	private YketCommentMapper commentMapper;
	
	
	@Override
	public Result addCourse(YketCourseVo courseVo, SysUser user) {
		log.trace("添加课程，参数：" + courseVo);

		// 添加课程
		YketCourse course = new YketCourse();
		course.setCourseId(UUIDUtils.createUUId());
		course.setCourseName(courseVo.getCourseName());
		course.setCourseImgUrl(courseVo.getCourseImgUrl());
		course.setCoursePress(courseVo.getCoursePress());
		course.setMsg(courseVo.getMsg());
		course.setCreateDate(new Date());
		course.setCreateUser(user.getUserId());
		course.setUpdateDate(new Date());
		course.setUpdateUser(user.getUserId());
		course.setDeleted(false);
		try {
			int res = courseMapper.insert(course);
			if (res <= 0) {
				log.error("添加课程失败: 参数：" + courseVo);
				throw new UserReadableException("添加课程失败");
			}
			// 添加标签
			List<YketLabel> labels = courseVo.getLabels();
			YketLabelRelationKey courseLabel = new YketLabelRelationKey();
			courseLabel.setLabelType(LabelTypeEnum.COURSE.getIndex());
			courseLabel.setObjectId(course.getCourseId());

			if (labels != null) {
				for (YketLabel labelItem : labels) {
					if (!StringUtils.isEmpty(labelItem.getLabelId())) {
						courseLabel.setLabelId(labelItem.getLabelId());
						if (this.labelRelationMapper.insert(courseLabel) <= 0) {
							log.error("添加课程失败: 参数：" + courseVo);
							throw new UserReadableException("添加课程失败");
						}
					}
				}
			}
			
			
		  // 添加课程类别标签
			List<YketLabel> courseTypelabels = courseVo.getCourseTypelabels();
			YketLabelRelationKey courseTypelabel = new YketLabelRelationKey();
			courseTypelabel.setLabelType(LabelTypeEnum.COURSE_TYPE.getIndex());
			courseTypelabel.setObjectId(course.getCourseId());
			if (courseTypelabels != null) {
				for (YketLabel labelItem : courseTypelabels) {
					if (!StringUtils.isEmpty(labelItem.getLabelId())) {
							courseTypelabel.setLabelId(labelItem.getLabelId());
							if (this.labelRelationMapper.insert(courseTypelabel) <= 0) {
								log.error("添加课程类别标签: 参数：" + courseVo);
								throw new UserReadableException("添加课程失败");
							}
						}
					}
			}
			
			  // 添加课程形式标签
				List<YketLabel> courseFormlabels = courseVo.getCourseFormlabels();
				YketLabelRelationKey courseFormlabelLabel = new YketLabelRelationKey();
				courseFormlabelLabel.setLabelType(LabelTypeEnum.COURSE_FORM.getIndex());
				courseFormlabelLabel.setObjectId(course.getCourseId());
				if (courseTypelabels != null) {
					for (YketLabel labelItem : courseFormlabels) {
						if (!StringUtils.isEmpty(labelItem.getLabelId())) {
							courseFormlabelLabel.setLabelId(labelItem.getLabelId());
								if (this.labelRelationMapper.insert(courseFormlabelLabel) <= 0) {
									log.error("添加课程形式标签: 参数：" + courseVo);
									throw new UserReadableException("添加课程失败");
								}
							}
						}
				}
			
			
			// 添加老師
			List<YketTeacherInfo> teachers = courseVo.getTeachers();
			YketCourseTeacher courseTeacher = new YketCourseTeacher();
			courseTeacher.setCourseId(course.getCourseId());
			if (teachers != null) {
				for (YketTeacherInfo teacherItem : teachers) {
					if (!StringUtils.isEmpty(teacherItem.getTeacherId())) {
						courseTeacher.setTeacherId(teacherItem.getTeacherId());
						if (this.courseTeacherMapper.insert(courseTeacher) <= 0) {
							log.error("添加课程失败: 参数：" + courseVo);
							throw new UserReadableException("添加课程失败");
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			if (e instanceof UserReadableException) {
				throw new UserReadableException(e.getMessage());
			} else {
				throw new UserReadableException("添加课程失败");
			}
		}
		return Result.Ok();
	}

	@Override
	public List<YketCourseListVo> courList(String courseName, Pagination page) {
		Map<String, Object> conds = new HashMap<String, Object>();
		if (!StringUtils.isEmpty(courseName)) {
			conds.put("courseName", courseName);
		}
		if (page != null && page.getFirstResult() != null && page.getRows() != null) {
			conds.put("firstResult", page.getFirstResult());
			conds.put("rows", page.getRows());
			Integer total = this.courseMapper.countCourse(conds);
			page.setTotal(total);
		}
		return this.courseMapper.courList(conds);
	}

	@Override
	public YketCourseVo getCourseInfo(String courseId) {
		return this.courseMapper.getCourseInfo(courseId);
	}

	@Override
	public Result updateCourse(YketCourseVo courseVo, SysUser user) {
		YketCourse old = this.courseMapper.selectByPrimaryKey(courseVo.getCourseId());
		old.setCourseName(courseVo.getCourseName());
		old.setCourseImgUrl(courseVo.getCourseImgUrl());
		old.setCoursePress(courseVo.getCoursePress());
		old.setMsg(courseVo.getMsg());
		old.setUpdateDate(new Date());
		old.setUpdateUser(user.getUserId());
		try {
			int res = this.courseMapper.updateByPrimaryKey(old);
			if (res <= 0) {
				log.error("课程更新失败:" + courseVo);
				throw new UserReadableException("课程更新失败");
			}
			YketLabelRelationKey key = new YketLabelRelationKey();
			key.setLabelType(LabelTypeEnum.COURSE.getIndex());
			key.setObjectId(old.getCourseId());
			// 删除老数据 关联的 标签
			int deleteRes = labelRelationMapper.deleteByObject(key);
			log.trace("删除老数据 关联的 标签 " + deleteRes);
			
			// 删除老数据 关联的 标签
			key.setLabelType(LabelTypeEnum.COURSE_TYPE.getIndex());
			int deleteTypeRes = labelRelationMapper.deleteByObject(key);
			log.trace("删除老数据 关联的 标签 " + deleteTypeRes);
			
			key.setLabelType(LabelTypeEnum.COURSE_FORM.getIndex());
			int deleteFormRes = labelRelationMapper.deleteByObject(key);
			log.trace("删除老数据 关联的 标签 " + deleteFormRes);
			
			
			// 删除老数据关联的 老师
			int deleteCtRes = this.courseTeacherMapper.deleteByCourse(courseVo.getCourseId());
			log.trace("删除老数据关联的 老师 " + deleteCtRes);

			// 添加标签
			List<YketLabel> labels = courseVo.getLabels();
			YketLabelRelationKey courseLabel = new YketLabelRelationKey();
			courseLabel.setLabelType(LabelTypeEnum.COURSE.getIndex());
			courseLabel.setObjectId(old.getCourseId());

			if (labels != null) {
				for (YketLabel labelItem : labels) {
					if (!StringUtils.isEmpty(labelItem.getLabelId())) {
						courseLabel.setLabelId(labelItem.getLabelId());
						if (this.labelRelationMapper.insert(courseLabel) <= 0) {
							log.error("添加课程失败: 参数：" + courseVo);
							throw new UserReadableException("添加课程失败");
						}
					}
				}
			}
			
		    // 添加课程类别标签
						List<YketLabel> courseTypelabels = courseVo.getCourseTypelabels();
						YketLabelRelationKey courseTypelabel = new YketLabelRelationKey();
						courseTypelabel.setLabelType(LabelTypeEnum.COURSE_TYPE.getIndex());
						courseTypelabel.setObjectId(old.getCourseId());

						if (courseTypelabels != null) {
							for (YketLabel labelItem : courseTypelabels) {
								if (!StringUtils.isEmpty(labelItem.getLabelId())) {
									courseTypelabel.setLabelId(labelItem.getLabelId());
									if (this.labelRelationMapper.insert(courseTypelabel) <= 0) {
										log.error("添加课程类别标签: 参数：" + courseVo);
										throw new UserReadableException("添加课程失败");
									}
								}
							}
						}
						
						  // 添加课程形式标签
				    List<YketLabel> courseFormlabels = courseVo.getCourseFormlabels();
					YketLabelRelationKey courseFormlabelLabel = new YketLabelRelationKey();
						courseFormlabelLabel.setLabelType(LabelTypeEnum.COURSE_FORM.getIndex());
						courseFormlabelLabel.setObjectId(old.getCourseId());
						if (courseFormlabels != null && courseFormlabels.size()!=0) {
							for (YketLabel labelItem : courseFormlabels) {
								if (!StringUtils.isEmpty(labelItem.getLabelId())) {
									courseFormlabelLabel.setLabelId(labelItem.getLabelId());
										if (this.labelRelationMapper.insert(courseFormlabelLabel) <= 0) {
											log.error("添加课程形式标签: 参数：" + courseVo);
											throw new UserReadableException("添加课程失败");
										}
									}
								}
						}		
						
			// 添加老師
			List<YketTeacherInfo> teachers = courseVo.getTeachers();
			YketCourseTeacher courseTeacher = new YketCourseTeacher();
			courseTeacher.setCourseId(old.getCourseId());
			if (teachers != null) {
				for (YketTeacherInfo teacherItem : teachers) {
					if (!StringUtils.isEmpty(teacherItem.getTeacherId())) {
						courseTeacher.setTeacherId(teacherItem.getTeacherId());
						if (this.courseTeacherMapper.insert(courseTeacher) <= 0) {
							log.error("添加课程失败: 参数：" + courseVo);
							throw new UserReadableException("添加课程失败");
						}
					}
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
			if (e instanceof UserReadableException) {
				throw new UserReadableException(e.getMessage());
			} else {
				throw new UserReadableException("课程更新失败");
			}
		}
		return Result.Ok();
	}

	@Override
	public Result delCourse(String courseId, SysUser user) {
		YketCourse old = this.courseMapper.selectByPrimaryKey(courseId);
		old.setDeleted(true);
		int res = this.courseMapper.updateByPrimaryKey(old);
		if (res <= 0) {
			log.error("课程删除失败:" + courseId);
			throw new UserReadableException("课程更新失败");
		}
		return Result.Ok();
	}

	@Override
	public List<YketCourse> queryFrontYketCourseList(Map<String, Object> map) {
		return this.courseMapper.queryFrontYketCourseList(map);
	}
	
	
	@Override
	public List<YketCourseList4FrontVo> getCourseList4Front(Map<String, String> map) {
		log.trace("前端课程列表参数:" + map);
 		return this.courseMapper.courseList4Front(map);
	}
	@Override
	public YketCourse4FrontVo getCourseDetailFront(Map<String,Object> map) {
 		map.put("commentType",CommentTypeEnum.COURSE.getIndex());
		YketCourse4FrontVo  result=this.courseMapper.getCourseInfo4Front(map);
		if(result!=null){
			 result.setPickUpcomment(commentMapper.getPickUpComment(map));
		}
 		return result;
	}
}
