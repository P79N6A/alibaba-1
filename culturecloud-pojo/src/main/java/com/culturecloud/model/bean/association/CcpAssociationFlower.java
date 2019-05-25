package com.culturecloud.model.bean.association;

import java.util.Date;

import javax.persistence.Column;

import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;

@Table(value="ccp_association_flower")
public class CcpAssociationFlower implements BaseEntity{

	private static final long serialVersionUID = -9055686443409554033L;

	@Column(name="ASSN_ID")
    private String assnId;

	@Column(name="USER_ID")
    private String userId;

	@Column(name="CREATE_TIME")
    private Date createTime;
	
	
	public String getAssnId() {
		return assnId;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public void setAssnId(String assnId) {
		this.assnId = assnId;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

}