package com.culturecloud.model.response.activity;

import java.io.Serializable;
import java.lang.reflect.InvocationTargetException;
import java.util.List;

import org.apache.commons.beanutils.PropertyUtils;

import com.culturecloud.model.bean.activity.CmsActivity;
import com.culturecloud.model.response.common.CmsTagSubVO;

/**
 * 活动详情
 * 
 * @author zhangshun
 *
 */
public class CmsActivityDetailVO extends CmsActivity  {
	
	private Integer activityIsCollect;
	
	private String activityFunName;
	
	private Integer collectNum;
	
	private Integer activityAbleCount;
	
	private String activityEventIds;
	private String activityEventimes;
	private String status;
	private String timeQuantum;
	private String eventCounts;
	private String eventPrices;
	private String spikeDifferences;
	private Integer activityIsPast;
	
	private Integer activityDateNums;

	private String shareUrl;
	
	private Integer activityIsWant;
	
	private String activityNotice;
	
	private String activityTips;
	
	private String integralStatus;
	
	private String[]assnSub;
	
	private String tagName;
	
	private List<CmsTagSubVO> subList;
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -4641843594263622376L;
	
	public CmsActivityDetailVO() {
		super();
	}

	public CmsActivityDetailVO(CmsActivity cmsActivity) {
		
		try {
			PropertyUtils.copyProperties(this, cmsActivity);
		} catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
			e.printStackTrace();
		}
	}

	public Integer getActivityIsCollect() {
		return activityIsCollect;
	}

	public void setActivityIsCollect(Integer activityIsCollect) {
		this.activityIsCollect = activityIsCollect;
	}

	public String getActivityFunName() {
		return activityFunName;
	}

	public void setActivityFunName(String activityFunName) {
		this.activityFunName = activityFunName;
	}

	public Integer getCollectNum() {
		return collectNum != null ? collectNum : 0;
	}

	public void setCollectNum(Integer collectNum) {
		this.collectNum = collectNum;
	}

	public Integer getActivityDateNums() {
		return activityDateNums;
	}

	public void setActivityDateNums(Integer activityDateNums) {
		this.activityDateNums = activityDateNums;
	}

	public Integer getActivityAbleCount() {
		return activityAbleCount;
	}

	public void setActivityAbleCount(Integer activityAbleCount) {
		this.activityAbleCount = activityAbleCount;
	}

	public String getActivityEventIds() {
		return activityEventIds;
	}

	public void setActivityEventIds(String activityEventIds) {
		this.activityEventIds = activityEventIds;
	}

	public String getActivityEventimes() {
		return activityEventimes;
	}

	public void setActivityEventimes(String activityEventimes) {
		this.activityEventimes = activityEventimes;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getTimeQuantum() {
		return timeQuantum;
	}

	public void setTimeQuantum(String timeQuantum) {
		this.timeQuantum = timeQuantum;
	}

	public String getEventCounts() {
		return eventCounts;
	}

	public void setEventCounts(String eventCounts) {
		this.eventCounts = eventCounts;
	}

	public String getEventPrices() {
		return eventPrices;
	}

	public void setEventPrices(String eventPrices) {
		this.eventPrices = eventPrices;
	}

	public String getSpikeDifferences() {
		return spikeDifferences;
	}

	public void setSpikeDifferences(String spikeDifferences) {
		this.spikeDifferences = spikeDifferences;
	}

	public Integer getActivityIsPast() {
		return activityIsPast;
	}

	public void setActivityIsPast(Integer activityIsPast) {
		this.activityIsPast = activityIsPast;
	}

	public String getShareUrl() {
		return shareUrl;
	}

	public void setShareUrl(String shareUrl) {
		this.shareUrl = shareUrl;
	}

	public Integer getActivityIsWant() {
		return activityIsWant;
	}

	public void setActivityIsWant(Integer activityIsWant) {
		this.activityIsWant = activityIsWant;
	}

	public String getActivityNotice() {
		return activityNotice;
	}

	public void setActivityNotice(String activityNotice) {
		this.activityNotice = activityNotice;
	}

	public String getActivityTips() {
		return activityTips;
	}

	public void setActivityTips(String activityTips) {
		this.activityTips = activityTips;
	}

	public String getIntegralStatus() {
		return integralStatus;
	}

	public void setIntegralStatus(String integralStatus) {
		this.integralStatus = integralStatus;
	}

	public String[] getAssnSub() {
		return assnSub;
	}

	public void setAssnSub(String[] assnSub) {
		this.assnSub = assnSub;
	}

	public String getTagName() {
		return tagName;
	}

	public void setTagName(String tagName) {
		this.tagName = tagName;
	}

	public List<CmsTagSubVO> getSubList() {
		return subList;
	}

	public void setSubList(List<CmsTagSubVO> subList) {
		this.subList = subList;
	}

	
	
	
}
