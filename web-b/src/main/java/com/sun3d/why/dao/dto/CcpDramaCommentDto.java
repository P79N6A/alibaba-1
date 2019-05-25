package com.sun3d.why.dao.dto;

import com.culturecloud.model.bean.drama.CcpDramaComment;

public class CcpDramaCommentDto extends CcpDramaComment{

	private static final long serialVersionUID = -1480195237838557096L;

	private String userName;
	
	private String dramaName;

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getDramaName() {
		return dramaName;
	}

	public void setDramaName(String dramaName) {
		this.dramaName = dramaName;
	}
	
	
}
