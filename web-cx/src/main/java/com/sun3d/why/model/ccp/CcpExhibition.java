package com.sun3d.why.model.ccp;

import java.util.Date;
import java.util.List;

public class CcpExhibition{
    

	private String exhibitionId;

    private String exhibitionHead;

    private String exhibitionTitle;

    private String exhibitionSubtitle;

    private String exhibitionHeadImg;

    private String exhibitionFootImg;

    private String exhibitionFootContent;

    private String exhibitionShareTitle;

    private String exhibitionShareDesc;

    private String exhibitionShareImg;

    private Integer exhibitionIsDel;

    private String createUser;

    private Date createTime;

    private String updateUser;

    private Date updateTime;
    
	private String indexLogo;
    
    //虚拟属性
    private List<CcpExhibitionPage> exhibitionPageList;

    public String getExhibitionId() {
        return exhibitionId;
    }

    public void setExhibitionId(String exhibitionId) {
        this.exhibitionId = exhibitionId == null ? null : exhibitionId.trim();
    }

    public String getExhibitionHead() {
        return exhibitionHead;
    }

    public void setExhibitionHead(String exhibitionHead) {
        this.exhibitionHead = exhibitionHead == null ? null : exhibitionHead.trim();
    }

    public String getExhibitionTitle() {
        return exhibitionTitle;
    }

    public void setExhibitionTitle(String exhibitionTitle) {
        this.exhibitionTitle = exhibitionTitle == null ? null : exhibitionTitle.trim();
    }

    public String getExhibitionSubtitle() {
        return exhibitionSubtitle;
    }

    public void setExhibitionSubtitle(String exhibitionSubtitle) {
        this.exhibitionSubtitle = exhibitionSubtitle == null ? null : exhibitionSubtitle.trim();
    }

    public String getExhibitionHeadImg() {
        return exhibitionHeadImg;
    }

    public void setExhibitionHeadImg(String exhibitionHeadImg) {
        this.exhibitionHeadImg = exhibitionHeadImg == null ? null : exhibitionHeadImg.trim();
    }

    public String getExhibitionFootImg() {
        return exhibitionFootImg;
    }

    public void setExhibitionFootImg(String exhibitionFootImg) {
        this.exhibitionFootImg = exhibitionFootImg == null ? null : exhibitionFootImg.trim();
    }

    public String getExhibitionFootContent() {
        return exhibitionFootContent;
    }

    public void setExhibitionFootContent(String exhibitionFootContent) {
        this.exhibitionFootContent = exhibitionFootContent == null ? null : exhibitionFootContent.trim();
    }

    public String getExhibitionShareTitle() {
        return exhibitionShareTitle;
    }

    public void setExhibitionShareTitle(String exhibitionShareTitle) {
        this.exhibitionShareTitle = exhibitionShareTitle == null ? null : exhibitionShareTitle.trim();
    }

    public String getExhibitionShareDesc() {
        return exhibitionShareDesc;
    }

    public void setExhibitionShareDesc(String exhibitionShareDesc) {
        this.exhibitionShareDesc = exhibitionShareDesc == null ? null : exhibitionShareDesc.trim();
    }

    public String getExhibitionShareImg() {
        return exhibitionShareImg;
    }

    public void setExhibitionShareImg(String exhibitionShareImg) {
        this.exhibitionShareImg = exhibitionShareImg == null ? null : exhibitionShareImg.trim();
    }

    public Integer getExhibitionIsDel() {
        return exhibitionIsDel;
    }

    public void setExhibitionIsDel(Integer exhibitionIsDel) {
        this.exhibitionIsDel = exhibitionIsDel;
    }

    public String getCreateUser() {
        return createUser;
    }

    public void setCreateUser(String createUser) {
        this.createUser = createUser == null ? null : createUser.trim();
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public String getUpdateUser() {
        return updateUser;
    }

    public void setUpdateUser(String updateUser) {
        this.updateUser = updateUser == null ? null : updateUser.trim();
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

	public List<CcpExhibitionPage> getExhibitionPageList() {
		return exhibitionPageList;
	}

	public void setExhibitionPageList(List<CcpExhibitionPage> exhibitionPageList) {
		this.exhibitionPageList = exhibitionPageList;
	}

	public String getIndexLogo() {
		return indexLogo;
	}

	public void setIndexLogo(String indexLogo) {
		this.indexLogo = indexLogo;
	}
    
	
}