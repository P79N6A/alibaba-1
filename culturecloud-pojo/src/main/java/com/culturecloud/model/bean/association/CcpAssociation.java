package com.culturecloud.model.bean.association;

import java.util.Date;

import javax.persistence.Column;

import com.culturecloud.annotations.Id;
import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;
@Table(value="ccp_association")
public class CcpAssociation implements BaseEntity{

	private static final long serialVersionUID = -8506068867362762404L;

	@Id
	@Column(name="ASSN_ID")
    private String assnId;

	@Column(name="ASSN_NAME")
    private String assnName;

	@Column(name="ASSN_IMG_URL")
    private String assnImgUrl;
	
	@Column(name="ASSN_ICON_URL")
    private String assnIconUrl;

	@Column(name="assn_video_url")
    private String assnVideoUrl;
	
	@Column(name="ASSN_VIDEO_NAME")
    private String assnVideoName;
	
	@Column(name="ASSN_INTRODUCE")
	private String assnIntroduce;

	@Column(name="ASSN_CONTENT")
    private String assnContent;
	
	@Column(name="ASSN_TAG")
    private String assnTag;
	
	@Column(name="ASSN_MEMBER")
    private String assnMember;
	
	@Column(name="ASSN_FANS_INIT")
    private String assnFansInit;
	
	@Column(name="ASSN_FLOWER_INIT")
    private String assnFlowerInit;
	
	@Column(name="SHARE_TITLE")
    private String shareTitle;
	
	@Column(name="SHARE_DESC")
    private String shareDesc;

	@Column(name="CREATE_TIME")
    private Date createTime;
	
	@Column(name="CREATE_SUSER")
    private String createSuser;
	
	@Column(name="CREATE_TUSER")
    private String createTuser;
	
	@Column(name="UPDATE_TIME")
    private Date updateTime;
	
	@Column(name="UPDATE_SUSER")
    private String updateSuser;
	
	@Column(name="UPDATE_TUSER")
    private String updateTuser;

	public String getAssnId() {
		return assnId;
	}

	public void setAssnId(String assnId) {
		this.assnId = assnId;
	}

	public String getAssnName() {
		return assnName;
	}

	public void setAssnName(String assnName) {
		this.assnName = assnName;
	}

	public String getAssnImgUrl() {
		return assnImgUrl;
	}

	public void setAssnImgUrl(String assnImgUrl) {
		this.assnImgUrl = assnImgUrl;
	}

	public String getAssnIconUrl() {
		return assnIconUrl;
	}

	public void setAssnIconUrl(String assnIconUrl) {
		this.assnIconUrl = assnIconUrl;
	}

	public String getAssnVideoUrl() {
		return assnVideoUrl;
	}

	public void setAssnVideoUrl(String assnVideoUrl) {
		this.assnVideoUrl = assnVideoUrl;
	}

	public String getAssnContent() {
		return assnContent;
	}

	public void setAssnContent(String assnContent) {
		this.assnContent = assnContent;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public Date getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}

	public String getAssnVideoName() {
		return assnVideoName;
	}

	public void setAssnVideoName(String assnVideoName) {
		this.assnVideoName = assnVideoName;
	}

	public String getAssnIntroduce() {
		return assnIntroduce;
	}

	public void setAssnIntroduce(String assnIntroduce) {
		this.assnIntroduce = assnIntroduce;
	}

	public String getCreateSuser() {
		return createSuser;
	}

	public void setCreateSuser(String createSuser) {
		this.createSuser = createSuser;
	}

	public String getCreateTuser() {
		return createTuser;
	}

	public void setCreateTuser(String createTuser) {
		this.createTuser = createTuser;
	}

	public String getUpdateSuser() {
		return updateSuser;
	}

	public void setUpdateSuser(String updateSuser) {
		this.updateSuser = updateSuser;
	}

	public String getUpdateTuser() {
		return updateTuser;
	}

	public void setUpdateTuser(String updateTuser) {
		this.updateTuser = updateTuser;
	}

	public String getAssnTag() {
		return assnTag;
	}

	public void setAssnTag(String assnTag) {
		this.assnTag = assnTag;
	}

	public String getAssnMember() {
		return assnMember;
	}

	public void setAssnMember(String assnMember) {
		this.assnMember = assnMember;
	}

	public String getAssnFansInit() {
		return assnFansInit;
	}

	public void setAssnFansInit(String assnFansInit) {
		this.assnFansInit = assnFansInit;
	}

	public String getAssnFlowerInit() {
		return assnFlowerInit;
	}

	public void setAssnFlowerInit(String assnFlowerInit) {
		this.assnFlowerInit = assnFlowerInit;
	}

	public String getShareTitle() {
		return shareTitle;
	}

	public void setShareTitle(String shareTitle) {
		this.shareTitle = shareTitle;
	}

	public String getShareDesc() {
		return shareDesc;
	}

	public void setShareDesc(String shareDesc) {
		this.shareDesc = shareDesc;
	}
	
}