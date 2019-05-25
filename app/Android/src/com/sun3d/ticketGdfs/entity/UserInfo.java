package com.sun3d.ticketGdfs.entity;

import java.io.Serializable;

@SuppressWarnings("serial")
public class UserInfo implements Serializable {

	private String userNema;	//用户名
	private String belonging;	//所属部门
	private String figure;		//角色名称
	private String userId;		//用户ID
	
	public UserInfo(){
		
	}

	public UserInfo(String userNema, String belonging, String figure) {
		super();
		this.userNema = userNema;
		this.belonging = belonging;
		this.figure = figure;
	}
	
	

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	/**
	 * 用户名称
	 * **/
	public String getUserNema() {
		return userNema;
	}

	/**
	 * 用户名称
	 * **/
	public void setUserNema(String userNema) {
		this.userNema = userNema;
	}

	/**
	 * 所属部门
	 * **/
	public String getBelonging() {
		return belonging;
	}

	/**
	 * 所属部门
	 * **/
	public void setBelonging(String belonging) {
		this.belonging = belonging;
	}

	/**
	 * 角色名称
	 * **/
	public String getFigure() {
		return figure;
	}
	/**
	 * 角色名称
	 * **/
	public void setFigure(String figure) {
		this.figure = figure;
	}

	@Override
	public String toString() {
		return "UserInfo [userNema=" + userNema + ", belonging=" + belonging
				+ ", figure=" + figure + ", userId=" + userId + "]";
	}
	
	

}
