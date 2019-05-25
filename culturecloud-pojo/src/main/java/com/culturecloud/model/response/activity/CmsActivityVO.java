package com.culturecloud.model.response.activity;

import java.lang.reflect.InvocationTargetException;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import org.apache.commons.beanutils.PropertyUtils;

import com.culturecloud.model.bean.activity.CmsActivity;
import com.culturecloud.model.response.common.CmsTagSubVO;

public class CmsActivityVO extends CmsActivity {

	private static final long serialVersionUID = 6951581868400198064L;
		
	
	// 场馆名称 
	private String venueName;
	
	// 地点
	private String activityLocationName;
	
	// 余票数
	private Integer availableCount;
	
	private String tagName;
	
	// 标签列表 
	private List<CmsTagSubVO> subList;

	public CmsActivityVO(CmsActivity cmsActivity) {
		
		try {
			PropertyUtils.copyProperties(this, cmsActivity);
		} catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
			e.printStackTrace();
		}
	
		 // 创建时间
		Date activityCreateTime=this.getActivityCreateTime();
		
		 if(activityCreateTime!=null)
		 {
			 this.setActivityCreateTime(new Date(activityCreateTime.getTime()/1000));
		 }	
		 
		 // 地区
		 String activityArea=this.getActivityArea();
			 
		 if(activityArea!=null&&this.getActivityArea()!="")
		 {
			String areaArry[]= activityArea.split(",");
			
			if(areaArry.length>1)
				activityArea=areaArry[1];
			
			this.setActivityArea(activityArea.replace("区", ""));
		 }
	}

	

	public String getVenueName() {
		return venueName;
	}

	public void setVenueName(String venueName) {
		this.venueName = venueName;
	}

	public String getActivityLocationName() {
		return activityLocationName;
	}

	public void setActivityLocationName(String activityLocationName) {
		this.activityLocationName = activityLocationName;
	}

	public List<CmsTagSubVO> getSubList() {
		return subList;
	}

	public void setSubList(List<CmsTagSubVO> subList) {
		this.subList = subList;
	}



	public String getTagName() {
		return tagName;
	}



	public void setTagName(String tagName) {
		this.tagName = tagName;
	}



	public Integer getAvailableCount() {
		return availableCount;
	}



	public void setAvailableCount(Integer availableCount) {
		this.availableCount = availableCount;
	}
	
	
}
