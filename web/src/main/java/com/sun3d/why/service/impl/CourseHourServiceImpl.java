package com.sun3d.why.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import com.aliyuncs.exceptions.ClientException;
import com.culturecloud.utils.UUIDUtils;
import com.culturecloud.utils.ali.video.AliOssVideo;
import com.sun3d.why.common.Result;
import com.sun3d.why.dao.YketCourseHourMapper;
import com.sun3d.why.enumeration.RSKeyEnum;
import com.sun3d.why.model.bean.yket.SysUser;
import com.sun3d.why.model.bean.yket.YketCourseHour;
import com.sun3d.why.service.CourseHourService;
import com.sun3d.why.util.Pagination;
@Service
@Transactional
public class CourseHourServiceImpl implements CourseHourService{
	
	@Autowired
	private YketCourseHourMapper  yketCourseHourMapper;

	@Override
	public List<YketCourseHour> queryCourseIdByCourseHour(String courseId,
			Pagination page) {
		Map<String, Object> map = new HashMap<String, Object>();
		if(!StringUtils.isEmpty(courseId)){
			map.put("courseId", courseId);
		}
		// 分页
		if (page != null && page.getFirstResult() != null && page.getRows() != null) {
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
			int total = this.yketCourseHourMapper.countCourseTime(map);
			page.setTotal(total);
		}
		return this.yketCourseHourMapper.queryCourseTimeList(map);
	}

	@Override
	public int addCourseHour(YketCourseHour yketCourseHour, SysUser sysUser) {
		Integer sort = this.yketCourseHourMapper.maxSort()==null?0:this.yketCourseHourMapper.maxSort()+1;
		if(yketCourseHour!=null){
			//视频转码
			if(!StringUtils.isEmpty(yketCourseHour.getVideoUrl())){
				String url = yketCourseHour.getVideoUrl();
				int index=url.lastIndexOf("/");
				int index2=url.lastIndexOf(".");
				
				final String videoUrl=url.substring(0, index+1);
				
				final String videoName=url.substring(index+1, url.length());
				
				int index3=videoName.lastIndexOf(".");
				
				final String videoNewName=videoName.substring(0,index3);
				
				 //删除缓存
	            Runnable runnable = new Runnable() {
	                @Override
	                public void run() {
	                	try {
	                		AliOssVideo.transvideo("ykyt", videoName, videoNewName+".mp4");
	        			} catch (ClientException e) {
	        				e.printStackTrace();
	        			}
	                }
	            };
	            Thread thread = new Thread(runnable);
	            thread.start();
				
	            yketCourseHour.setVideoUrl(videoUrl+videoNewName+".mp4");
			}
			yketCourseHour.setHourId(UUIDUtils.createUUId());
			yketCourseHour.setSort(sort);
			yketCourseHour.setDeleted(false);
			yketCourseHour.setCreateUser(sysUser.getUserId());
			yketCourseHour.setCreateDate(new Date());
			yketCourseHour.setUpdateDate(new Date());
			yketCourseHour.setUpdateUser(sysUser.getUserId());
		}
		return this.yketCourseHourMapper.insert(yketCourseHour);
	}

	@Override
	public YketCourseHour queryYketCourseHourByHourId(String hourId) {
		return this.yketCourseHourMapper.selectByPrimaryKey(hourId);
	}

	@Override
	public Result editCourseHour(YketCourseHour yketCourseHour, SysUser sysUser) {
		YketCourseHour courseHour = this.yketCourseHourMapper.selectByPrimaryKey(yketCourseHour.getHourId());
		if(courseHour!=null){
			//视频转码
			if(!StringUtils.isEmpty(yketCourseHour.getVideoUrl())){
				String url = yketCourseHour.getVideoUrl();
				int index=url.lastIndexOf("/");
				int index2=url.lastIndexOf(".");
				
				final String videoUrl=url.substring(0, index+1);
				
				final String videoName=url.substring(index+1, url.length());
				
				int index3=videoName.lastIndexOf(".");
				
				final String videoNewName=videoName.substring(0,index3);
				
				 //删除缓存
	            Runnable runnable = new Runnable() {
	                @Override
	                public void run() {
	                	try {
	                		AliOssVideo.transvideo("ykyt", videoName, videoNewName+".mp4");
	        			} catch (ClientException e) {
	        				e.printStackTrace();
	        			}
	                }
	            };
	            Thread thread = new Thread(runnable);
	            thread.start();
				
	            courseHour.setVideoUrl(videoUrl+videoNewName+".mp4");
			}
			courseHour.setCourseDuration(yketCourseHour.getCourseDuration());	
			courseHour.setHourName(yketCourseHour.getHourName());
			courseHour.setUpdateDate(new Date());
			courseHour.setUpdateUser(sysUser.getUserId());
			this.yketCourseHourMapper.updateByPrimaryKeySelective(courseHour);
			return Result.Ok();
		}
		return Result.Error().setVal(RSKeyEnum.msg, "修改失败！");
	}

	@Override
	public Result deleteCourseHour(String hourId, SysUser sysUser) {
		YketCourseHour courseHour = this.yketCourseHourMapper.selectByPrimaryKey(hourId);
		if(courseHour!=null){
			courseHour.setDeleted(true);
			courseHour.setUpdateDate(new Date());
			courseHour.setCreateUser(sysUser.getUserId());
			this.yketCourseHourMapper.updateByPrimaryKeySelective(courseHour);
			return Result.Ok();
		}
		return Result.Error().setVal(RSKeyEnum.msg, "删除失败！");
	}

	@Override
	public Result moveUp(String hourId, Integer sort) {
		Map<String ,Object> map = new HashMap<String, Object>();
	 	if (sort != null) {
			map.put("sort", sort);
		}
		List<YketCourseHour> list = this.yketCourseHourMapper.moveUp(map);
		if(list==null || list.size()==0){
			return Result.Error().setVal(RSKeyEnum.msg, "查询异常请稍后再试！");
		}
        if(list.size()<2){
        	return Result.Error().setVal(RSKeyEnum.msg, "查询异常请稍后再试！");
		}
        if(list.size()==1){
        	return Result.Error().setVal(RSKeyEnum.msg, "查询异常请稍后再试！");
        }
        try{
        	YketCourseHour top= list.get(0);
        	Integer topSort = top.getSort();
        	YketCourseHour second= list.get(1);
			top.setSort(second.getSort());
			second.setSort(topSort);
			this.yketCourseHourMapper.updateByPrimaryKey(second);
			this.yketCourseHourMapper.updateByPrimaryKey(top);
			return Result.Ok();
		}catch(Exception e){
			throw new RuntimeException();
		}
	}

	@Override
	public Result moveDown(String hourId, Integer sort) {
		Map<String ,Object> map = new HashMap<String, Object>();
		if (sort != null) {
			map.put("sort", sort);
		}
		List<YketCourseHour> list = this.yketCourseHourMapper.moveDown(map);
		if(list==null || list.size()==0){
			return Result.Error().setVal(RSKeyEnum.msg, "查询异常请稍后再试！");
		}
        if(list.size()<2){
        	return Result.Error().setVal(RSKeyEnum.msg, "查询异常请稍后再试！");
		}
        if(list.size()==1){
        	return Result.Error().setVal(RSKeyEnum.msg, "查询异常请稍后再试！");
        }
        try{
        	YketCourseHour top= list.get(0);
        	Integer topSort = top.getSort();
        	YketCourseHour second= list.get(1);
			top.setSort(second.getSort());
			second.setSort(topSort);
			this.yketCourseHourMapper.updateByPrimaryKey(second);
			this.yketCourseHourMapper.updateByPrimaryKey(top);
			return Result.Ok();
		}catch(Exception e){
			throw new RuntimeException();
		}
	}

	@Override
	public int queryHourName(String hourName, String courseId) {
		Map<String, Object> map = new HashMap<String, Object>();
		if(!StringUtils.isEmpty(hourName)){
			map.put("hourName", hourName);
		}
		if(!StringUtils.isEmpty(courseId)){
			map.put("courseId", courseId);
		}
		return this.yketCourseHourMapper.queryHourName(map);
	}

}
