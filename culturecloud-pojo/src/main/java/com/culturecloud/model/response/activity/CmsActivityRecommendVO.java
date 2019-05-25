package com.culturecloud.model.response.activity;

import java.io.Serializable;
import java.lang.reflect.InvocationTargetException;
import java.util.List;

import org.apache.commons.beanutils.PropertyUtils;

import com.culturecloud.model.bean.activity.CmsActivity;
import com.culturecloud.model.response.common.CmsTagSubVO;

/**
 * 推荐活动vo
 * 
 * @author zhangshun
 *
 */
public class CmsActivityRecommendVO implements Serializable {

	private static final long serialVersionUID = -3894734489234929162L;
	
	private String activityId;
	private String activityName;
	private String activitySite;
	private String activityIconUrl;
	private String activitySubject;
	private String activityArea;
	private String activityAddress;
	private Double activityLon;
	private Double activityLat;
	private Integer activityIsFree;
	private String activityPrice;
	private String activityStartTime;
	private String activityEndTime;
	private Integer activityIsReservation;
	private String activityRecommend;
	private String sysId;
	private String sysNo;
	
	// 余票数
	private Integer availableCount;
		
	// 活动与用户距离
	private Double distance ;
	// 是否是热门活动
	private Integer activityIsHot;
	
	// 地点
	private String activityLocationName;
	
	// 类型标签
	private String tagName;
	
	//价格类型   0：XX元起  1:XX元/人
	private Integer priceType;    
	
	//是否是秒杀   0：非秒杀  1:秒杀
	private Integer spikeType;    
	
	// 标签列表 
	private List<CmsTagSubVO> subList;
	
//	//是否关注
//	private Integer activityIsCollect;

	public CmsActivityRecommendVO(CmsActivity cmsActivity) {
		
		try {
			PropertyUtils.copyProperties(this, cmsActivity);
		} catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
			e.printStackTrace();
		}
		
	}


	public Integer getAvailableCount() {
		return availableCount;
	}


	public void setAvailableCount(Integer availableCount) {
		this.availableCount = availableCount;
	}


	public Double getDistance() {
		return distance;
	}


	public void setDistance(Double distance) {
		this.distance = distance;
	}


	public Integer getActivityIsHot() {
		return activityIsHot;
	}


	public void setActivityIsHot(Integer activityIsHot) {
		this.activityIsHot = activityIsHot;
	}


	public String getActivityId() {
		return activityId;
	}


	public void setActivityId(String activityId) {
		this.activityId = activityId;
	}


	public String getActivityName() {
		return activityName;
	}


	public void setActivityName(String activityName) {
		this.activityName = activityName;
	}


	public String getActivitySite() {
		return activitySite;
	}


	public void setActivitySite(String activitySite) {
		this.activitySite = activitySite;
	}


	public String getActivityIconUrl() {
		return activityIconUrl;
	}


	public void setActivityIconUrl(String activityIconUrl) {
		this.activityIconUrl = activityIconUrl;
	}


	public String getActivityArea() {
		return activityArea;
	}


	public void setActivityArea(String activityArea) {
		this.activityArea = activityArea;
	}


	public String getActivityAddress() {
		return activityAddress;
	}


	public void setActivityAddress(String activityAddress) {
		this.activityAddress = activityAddress;
	}


	public Double getActivityLon() {
		return activityLon;
	}


	public void setActivityLon(Double activityLon) {
		this.activityLon = activityLon;
	}


	public Double getActivityLat() {
		return activityLat;
	}


	public void setActivityLat(Double activityLat) {
		this.activityLat = activityLat;
	}


	public Integer getActivityIsFree() {
		return activityIsFree;
	}


	public void setActivityIsFree(Integer activityIsFree) {
		this.activityIsFree = activityIsFree;
	}


	public String getActivityPrice() {
		return activityPrice;
	}


	public void setActivityPrice(String activityPrice) {
		this.activityPrice = activityPrice;
	}


	public String getActivityStartTime() {
		return activityStartTime;
	}


	public void setActivityStartTime(String activityStartTime) {
		this.activityStartTime = activityStartTime;
	}


	public String getActivityEndTime() {
		return activityEndTime;
	}


	public void setActivityEndTime(String activityEndTime) {
		this.activityEndTime = activityEndTime;
	}


	public Integer getActivityIsReservation() {
		return activityIsReservation;
	}


	public void setActivityIsReservation(Integer activityIsReservation) {
		this.activityIsReservation = activityIsReservation;
	}


	public String getSysId() {
		return sysId;
	}


	public void setSysId(String sysId) {
		this.sysId = sysId;
	}


	public String getSysNo() {
		return sysNo;
	}


	public void setSysNo(String sysNo) {
		this.sysNo = sysNo;
	}

	
	

	public List<CmsTagSubVO> getSubList() {
		return subList;
	}


	public void setSubList(List<CmsTagSubVO> subList) {
		this.subList = subList;
	}


	public String getActivitySubject() {
		return activitySubject;
	}


	public void setActivitySubject(String activitySubject) {
		this.activitySubject = activitySubject;
	}


	public String getActivityRecommend() {
		return activityRecommend;
	}


	public void setActivityRecommend(String activityRecommend) {
		this.activityRecommend = activityRecommend;
	}

	public String getActivityLocationName() {
		return activityLocationName;
	}


	public void setActivityLocationName(String activityLocationName) {
		this.activityLocationName = activityLocationName;
	}


	public Integer getPriceType() {
		return priceType;
	}


	public void setPriceType(Integer priceType) {
		this.priceType = priceType;
	}


	public Integer getSpikeType() {
		return spikeType;
	}


	public void setSpikeType(Integer spikeType) {
		this.spikeType = spikeType;
	}


	public String getTagName() {
		return tagName;
	}


	public void setTagName(String tagName) {
		this.tagName = tagName;
	}
	
	
}
