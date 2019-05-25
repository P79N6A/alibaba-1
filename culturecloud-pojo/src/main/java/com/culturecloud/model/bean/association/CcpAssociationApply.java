package com.culturecloud.model.bean.association;

import java.util.Date;

import javax.persistence.Column;

import com.culturecloud.annotations.Id;
import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;
@Table(value="ccp_association_apply")
public class CcpAssociationApply implements BaseEntity{

	private static final long serialVersionUID = -4996002292916108554L;

	@Id
	@Column(name="ASSN_ID")
    private String assnId;

	@Column(name="ASSN_NAME")
    private String assnName;

	@Column(name="ASSN_INTRODUCE")
	private String assnIntroduce;

	@Column(name="ASSN_LINKMAN")
    private String assnLinkman;
	
	@Column(name="ASSN_PHONE")
    private String assnPhone;
	
	@Column(name="ASSN_TYPE")
    private String assnType;
	
	@Column(name="ASSN_STATE")
    private Integer assnState;

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

	public String getAssnIntroduce() {
		return assnIntroduce;
	}

	public void setAssnIntroduce(String assnIntroduce) {
		this.assnIntroduce = assnIntroduce;
	}

	public String getAssnLinkman() {
		return assnLinkman;
	}

	public void setAssnLinkman(String assnLinkman) {
		this.assnLinkman = assnLinkman;
	}

	public String getAssnPhone() {
		return assnPhone;
	}

	public void setAssnPhone(String assnPhone) {
		this.assnPhone = assnPhone;
	}

	public String getAssnType() {
		return assnType;
	}

	public void setAssnType(String assnType) {
		this.assnType = assnType;
	}

	public Integer getAssnState() {
		return assnState;
	}

	public void setAssnState(Integer assnState) {
		this.assnState = assnState;
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

}