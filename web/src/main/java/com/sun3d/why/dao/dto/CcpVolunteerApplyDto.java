package com.sun3d.why.dao.dto;

import com.culturecloud.model.bean.volunteer.CcpVolunteerApply;

public class CcpVolunteerApplyDto extends CcpVolunteerApply {

	
	private String userName;
	
	private String dictName;
	
	private String recruitName;
	
	private String[] imgs;
	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getDictName() {
		return dictName;
	}

	public void setDictName(String dictName) {
		this.dictName = dictName;
	}

	public String getRecruitName() {
		return recruitName;
	}

	public void setRecruitName(String recruitName) {
		this.recruitName = recruitName;
	}

	public String[] getImgs() {
		return imgs;
	}

	public void setImgs(String[] imgs) {
		this.imgs = imgs;
	}
	
	
	
}
