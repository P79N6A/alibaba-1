package com.sun3d.why.model.ccp;

import java.util.Date;

public class CcpExhibitionPage {
    private String pageId;

    private String exhibitionId;

    private String pageTitle;

    private String pageImg;

    private String pageContent;

    private Integer pageIsDel;

    private Integer pageType;
    
    private Integer pageSort;

    private String createUser;

    private Date createTime;

	public String getPageId() {
		return pageId;
	}

	public void setPageId(String pageId) {
		this.pageId = pageId;
	}

	public String getExhibitionId() {
		return exhibitionId;
	}

	public void setExhibitionId(String exhibitionId) {
		this.exhibitionId = exhibitionId;
	}

	public String getPageTitle() {
		return pageTitle;
	}

	public void setPageTitle(String pageTitle) {
		this.pageTitle = pageTitle;
	}

	public String getPageImg() {
		return pageImg;
	}

	public void setPageImg(String pageImg) {
		this.pageImg = pageImg;
	}

	public String getPageContent() {
		return pageContent;
	}

	public void setPageContent(String pageContent) {
		this.pageContent = pageContent;
	}

	public Integer getPageIsDel() {
		return pageIsDel;
	}

	public void setPageIsDel(Integer pageIsDel) {
		this.pageIsDel = pageIsDel;
	}

	public Integer getPageType() {
		return pageType;
	}

	public void setPageType(Integer pageType) {
		this.pageType = pageType;
	}

	public Integer getPageSort() {
		return pageSort;
	}

	public void setPageSort(Integer pageSort) {
		this.pageSort = pageSort;
	}

	public String getCreateUser() {
		return createUser;
	}

	public void setCreateUser(String createUser) {
		this.createUser = createUser;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

    
}