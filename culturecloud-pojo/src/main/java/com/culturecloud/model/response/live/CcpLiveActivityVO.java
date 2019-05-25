package com.culturecloud.model.response.live;

import java.lang.reflect.InvocationTargetException;

import org.apache.commons.beanutils.PropertyUtils;

import com.culturecloud.model.bean.live.CcpLiveActivity;

public class CcpLiveActivityVO extends CcpLiveActivity {

	private static final long serialVersionUID = -7728093502430810316L;

	// 直播活动状态 0.不限 1.正在直播 2.尚未开始 3.已结束
	private Integer liveActivityTimeStatus;
	
	private Long countDown;
	
	private String userName;
	
	private String userHeadImgUrl;
	
	private String shareUrl;

	private String backgroudMusic;
	
	private String watermarkHtml;
	
	private String watermarkHtml2;
	
	public CcpLiveActivityVO(CcpLiveActivity ccpLiveActivity) {

		try {
			PropertyUtils.copyProperties(this, ccpLiveActivity);
		} catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
			e.printStackTrace();
		}
	}

	public Integer getLiveActivityTimeStatus() {
		return liveActivityTimeStatus;
	}

	public void setLiveActivityTimeStatus(Integer liveActivityTimeStatus) {
		this.liveActivityTimeStatus = liveActivityTimeStatus;
	}

	@Override
	public String getLiveTitle() {

		String t = super.getLiveTitle();

		if (t == null)

			return "";
		else
			return t;
	}

	@Override
	public String getLiveTopText() {
		
		String t = super.getLiveTopText();

		if (t == null)

			return "";
		else
			return t;
	}

	public Long getCountDown() {
		return countDown;
	}

	public void setCountDown(Long countDown) {
		this.countDown = countDown;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserHeadImgUrl() {
		return userHeadImgUrl;
	}

	public void setUserHeadImgUrl(String userHeadImgUrl) {
		this.userHeadImgUrl = userHeadImgUrl;
	}

	public String getShareUrl() {
		return shareUrl;
	}

	public void setShareUrl(String shareUrl) {
		this.shareUrl = shareUrl;
	}

	public String getBackgroudMusic() {
		return backgroudMusic;
	}

	public void setBackgroudMusic(String backgroudMusic) {
		this.backgroudMusic = backgroudMusic;
	}

	public String getWatermarkHtml() {
		return watermarkHtml;
	}

	public void setWatermarkHtml(String watermarkHtml) {
		this.watermarkHtml = watermarkHtml;
	}

	public String getWatermarkHtml2() {
		return watermarkHtml2;
	}

	public void setWatermarkHtml2(String watermarkHtml2) {
		this.watermarkHtml2 = watermarkHtml2;
	}

	
	
	
}
