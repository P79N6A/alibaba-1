package com.culturecloud.model.request.live;

import java.util.Date;

import javax.persistence.Column;
import javax.validation.constraints.NotNull;

import com.culturecloud.bean.BaseRequest;

public class UpdateCcpLiveActivityVO extends BaseRequest{

	@NotNull(message = "直播ID不能为空")
    private String liveActivityId;
	
	private String liveTitle;

	private String liveCoverImg;

	private Date liveStartTime;
	
	private Integer liveStatus;

	private String liveTopText;
	
	private Integer liveCheck;
	
	private String liveWatermarkText;

	private String liveWatermarkImg;

	private Integer liveWatermarkImgPosition;
	
	private String liveBackgroudMusic;
	
	private String liveBackgroudCover;
	
	private Integer liveIsDel;

	public String getLiveActivityId() {
		return liveActivityId;
	}

	public void setLiveActivityId(String liveActivityId) {
		this.liveActivityId = liveActivityId;
	}

	public String getLiveTitle() {
		return liveTitle;
	}

	public void setLiveTitle(String liveTitle) {
		this.liveTitle = liveTitle;
	}

	public String getLiveCoverImg() {
		return liveCoverImg;
	}

	public void setLiveCoverImg(String liveCoverImg) {
		this.liveCoverImg = liveCoverImg;
	}

	public Date getLiveStartTime() {
		return liveStartTime;
	}

	public void setLiveStartTime(Date liveStartTime) {
		this.liveStartTime = liveStartTime;
	}

	public Integer getLiveStatus() {
		return liveStatus;
	}

	public void setLiveStatus(Integer liveStatus) {
		this.liveStatus = liveStatus;
	}

	public String getLiveTopText() {
		return liveTopText;
	}

	public void setLiveTopText(String liveTopText) {
		this.liveTopText = liveTopText;
	}

	public Integer getLiveCheck() {
		return liveCheck;
	}

	public void setLiveCheck(Integer liveCheck) {
		this.liveCheck = liveCheck;
	}

	public String getLiveWatermarkText() {
		return liveWatermarkText;
	}

	public void setLiveWatermarkText(String liveWatermarkText) {
		this.liveWatermarkText = liveWatermarkText;
	}

	public String getLiveWatermarkImg() {
		return liveWatermarkImg;
	}

	public void setLiveWatermarkImg(String liveWatermarkImg) {
		this.liveWatermarkImg = liveWatermarkImg;
	}

	public Integer getLiveWatermarkImgPosition() {
		return liveWatermarkImgPosition;
	}

	public void setLiveWatermarkImgPosition(Integer liveWatermarkImgPosition) {
		this.liveWatermarkImgPosition = liveWatermarkImgPosition;
	}

	public String getLiveBackgroudMusic() {
		return liveBackgroudMusic;
	}

	public void setLiveBackgroudMusic(String liveBackgroudMusic) {
		this.liveBackgroudMusic = liveBackgroudMusic;
	}

	public String getLiveBackgroudCover() {
		return liveBackgroudCover;
	}

	public void setLiveBackgroudCover(String liveBackgroudCover) {
		this.liveBackgroudCover = liveBackgroudCover;
	}

	public Integer getLiveIsDel() {
		return liveIsDel;
	}

	public void setLiveIsDel(Integer liveIsDel) {
		this.liveIsDel = liveIsDel;
	}
	
	

}
