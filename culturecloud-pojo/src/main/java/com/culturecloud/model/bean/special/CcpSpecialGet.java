package com.culturecloud.model.bean.special;

import javax.persistence.Column;

import com.culturecloud.annotations.Id;
import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;

@Table(value="ccp_special_get")
public class CcpSpecialGet implements BaseEntity{

	private static final long serialVersionUID = 7557996478089440092L;
	
	/** 主键*/
	@Id
	@Column(name="id")
	private String id;
	
	/** 入口ID*/
	@Column(name="enter_id")
	private String enterId;
	
	/** 姓名*/
	@Column(name="name")
	private String name;
	
	/** 手机号*/
	@Column(name="telphone")
	private String telphone;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getEnterId() {
		return enterId;
	}

	public void setEnterId(String enterId) {
		this.enterId = enterId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getTelphone() {
		return telphone;
	}

	public void setTelphone(String telphone) {
		this.telphone = telphone;
	}
	
	
}
