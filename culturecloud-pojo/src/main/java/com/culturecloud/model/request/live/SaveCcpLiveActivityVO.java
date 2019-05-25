package com.culturecloud.model.request.live;

import java.util.Date;

import javax.persistence.Column;
import javax.validation.constraints.NotNull;

import com.culturecloud.bean.BaseRequest;

public class SaveCcpLiveActivityVO extends BaseRequest{

	@NotNull(message = "直播标题不能为空")
	private String liveTitle;

	@NotNull(message = "直播封面不能为空")
	private String liveCoverImg;

	@NotNull(message = "直播开始时间不能为空")
	private Date liveStartTime;
	
	@NotNull(message = "直播创建人不能为空")
	private String liveCreateUser;
	
	@NotNull(message = "直播类型不能为空")
	private Integer liveType;
	
	private String liveWatermarkText;

	private String liveWatermarkImg;

	private Integer liveWatermarkImgPosition;
	
	private String liveBackgroudMusic;
	
	private String liveBackgroudCover;


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

	public String getLiveCreateUser() {
		return liveCreateUser;
	}

	public void setLiveCreateUser(String liveCreateUser) {
		this.liveCreateUser = liveCreateUser;
	}

	public Integer getLiveType() {
		return liveType;
	}

	public void setLiveType(Integer liveType) {
		this.liveType = liveType;
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
	
	
}
