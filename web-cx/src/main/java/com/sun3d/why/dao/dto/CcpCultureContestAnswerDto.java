package com.sun3d.why.dao.dto;

import com.culturecloud.model.bean.culture.CcpCultureContestAnswer;

public class CcpCultureContestAnswerDto extends CcpCultureContestAnswer{
	
	private Integer rowno;
	
	private Integer rightSum;

	private String userHeadImgUrl;
	
	private String userName;
	
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

	public String getUserHeadImgUrl() {
		return userHeadImgUrl;
	}

	public void setUserHeadImgUrl(String userHeadImgUrl) {
		this.userHeadImgUrl = userHeadImgUrl;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}
	
	
	

}
