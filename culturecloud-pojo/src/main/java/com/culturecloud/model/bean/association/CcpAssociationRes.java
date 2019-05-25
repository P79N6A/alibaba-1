package com.culturecloud.model.bean.association;

import java.util.Date;

import javax.persistence.Column;

import com.culturecloud.annotations.Id;
import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;

@Table(value="ccp_association_res")
public class CcpAssociationRes implements BaseEntity{


	private static final long serialVersionUID = -6393757176386207120L;

	@Id
	@Column(name="RES_ID")
	private String resId;

	@Column(name="ASSN_ID")
	private String assnId;

	@Column(name="ASSN_RES_URL")
	private String assnResUrl;

	@Column(name="ASSN_RES_COVER")
	private String assnResCover;

	@Column(name="ASSN_RES_NAME")
	private String assnResName;

	@Column(name="RES_TYPE")
	private Integer resType;

	@Column(name="CREATE_TIME")
	private Date createTime;

	@Column(name="CREATE_USER")
	private String createUser;

	@Column(name="UPDATE_TIME")
	private Date updateTime;

	@Column(name="UPDATE_USER")
	private String updateUser;

	public String getResId() {
		return resId;
	}

	public void setResId(String resId) {
		this.resId = resId;
	}

	public String getAssnId() {
		return assnId;
	}

	public void setAssnId(String assnId) {
		this.assnId = assnId;
	}

	public String getAssnResUrl() {
		return assnResUrl;
	}

	public void setAssnResUrl(String assnResUrl) {
		this.assnResUrl = assnResUrl;
	}

	public Integer getResType() {
		return resType;
	}

	public void setResType(Integer resType) {
		this.resType = resType;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public String getCreateUser() {
		return createUser;
	}

	public void setCreateUser(String createUser) {
		this.createUser = createUser;
	}

	public Date getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}

	public String getUpdateUser() {
		return updateUser;
	}

	public void setUpdateUser(String updateUser) {
		this.updateUser = updateUser;
	}

	public String getAssnResName() {
		return assnResName;
	}

	public void setAssnResName(String assnResName) {
		this.assnResName = assnResName;
	}

	public String getAssnResCover() {
		return assnResCover;
	}

	public void setAssnResCover(String assnResCover) {
		this.assnResCover = assnResCover;
	}


}