package com.sun3d.why.model.vo.yket;

import java.util.List;

import com.sun3d.why.model.bean.yket.YketComment;
import com.sun3d.why.model.bean.yket.YketCourse;
import com.sun3d.why.model.bean.yket.YketCourseHour;
import com.sun3d.why.model.bean.yket.YketLabel;
import com.sun3d.why.model.bean.yket.YketTeacherInfo;

public class YketCourse4FrontVo extends YketCourse {

	private Integer commentCount;
	private Integer likeCount;
	private List<YketLabel> courseFormlabels;

	private List<YketTeacherInfo> teachers;

	private List<YketCourseHour> courseHours;
	
	

	private YketComment pickUpcomment;
	
	
	private String isLiked;
	
	private String isFavorite;

	
	public String getIsLiked() {
		return isLiked;
	}

	public void setIsLiked(String isLiked) {
		this.isLiked = isLiked;
	}

	public String getIsFavorite() {
		return isFavorite;
	}

	public void setIsFavorite(String isFavorite) {
		this.isFavorite = isFavorite;
	}

	public Integer getCommentCount() {
		return commentCount;
	}

	public void setCommentCount(Integer commentCount) {
		this.commentCount = commentCount;
	}

	public Integer getLikeCount() {
		return likeCount;
	}

	public void setLikeCount(Integer likeCount) {
		this.likeCount = likeCount;
	}

	public List<YketLabel> getCourseFormlabels() {
		return courseFormlabels;
	}

	public void setCourseFormlabels(List<YketLabel> courseFormlabels) {
		this.courseFormlabels = courseFormlabels;
	}

	public List<YketTeacherInfo> getTeachers() {
		return teachers;
	}

	public void setTeachers(List<YketTeacherInfo> teachers) {
		this.teachers = teachers;
	}

	public List<YketCourseHour> getCourseHours() {
		return courseHours;
	}

	public void setCourseHours(List<YketCourseHour> courseHours) {
		this.courseHours = courseHours;
	}

	public YketComment getPickUpcomment() {
		return pickUpcomment;
	}

	public void setPickUpcomment(YketComment pickUpcomment) {
		this.pickUpcomment = pickUpcomment;
	}

}
