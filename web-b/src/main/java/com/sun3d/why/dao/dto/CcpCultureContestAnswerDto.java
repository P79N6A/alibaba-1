package com.sun3d.why.dao.dto;

import com.culturecloud.model.bean.culture.CcpCultureContestAnswer;

public class CcpCultureContestAnswerDto extends CcpCultureContestAnswer {
	private Integer rowno;

	private Integer sum;

	private Integer stage1;
	private Integer stage2;
	private Integer stage3;
	private String userTelephone;

	private String userName;
	private String realName;
	private String userArea;
	
	public String getUserArea() {
		return userArea;
	}

	public void setUserArea(String userArea) {
		this.userArea = userArea;
	}

	public Integer getSum() {
		return sum;
	}

	public void setSum(Integer sum) {
		this.sum = sum;
	}

	public Integer getStage1() {
		return stage1;
	}

	public void setStage1(Integer stage1) {
		this.stage1 = stage1;
	}

	public Integer getStage2() {
		return stage2;
	}

	public void setStage2(Integer stage2) {
		this.stage2 = stage2;
	}

	public Integer getStage3() {
		return stage3;
	}

	public void setStage3(Integer stage3) {
		this.stage3 = stage3;
	}

	public String getUserTelephone() {
		return userTelephone;
	}

	public void setUserTelephone(String userTelephone) {
		this.userTelephone = userTelephone;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getRealName() {
		return realName;
	}

	public void setRealName(String realName) {
		this.realName = realName;
	}

	private Integer rightSum;

	public Integer getRowno() {
		return rowno;
	}

	public void setRowno(Integer rowno) {
		this.rowno = rowno;
	}

	public Integer getRightSum() {
		return rightSum;
	}

	public void setRightSum(Integer rightSum) {
		this.rightSum = rightSum;
	}

}
