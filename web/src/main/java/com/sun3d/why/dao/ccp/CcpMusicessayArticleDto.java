package com.sun3d.why.dao.ccp;

import com.culturecloud.model.bean.musicessay.CcpMusicessayArticle;

public class CcpMusicessayArticleDto extends CcpMusicessayArticle{

	
	private Integer isLike = 0;
	
	private String userName;
  	
  	private String userHeadImgUrl;
  	
  	private Integer rowno;

	public Integer getIsLike() {
		return isLike;
	}

	public void setIsLike(Integer isLike) {
		this.isLike = isLike;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserHeadImgUrl() {
		return userHeadImgUrl;
	}

	public void setUserHeadImgUrl(String userHeadImgUrl) {
		this.userHeadImgUrl = userHeadImgUrl;
	}

	public Integer getRowno() {
		return rowno;
	}

	public void setRowno(Integer rowno) {
		this.rowno = rowno;
	}
	
	
}
