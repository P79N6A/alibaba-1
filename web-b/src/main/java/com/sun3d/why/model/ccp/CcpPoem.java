package com.sun3d.why.model.ccp;

import java.util.Date;

public class CcpPoem {
    private String poemId;

    private String poemDate;

    private String poemTitle;

    private String poemAuthor;

    private String poemContent;

    private String poemTemplate;

    private String poemWord;

    private String poemLectorId;

    private String poemLectorExplain;

    private Date createTime;

    private String createUser;
    
    //虚拟属性
    private String lectorName;

    public String getPoemId() {
        return poemId;
    }

    public void setPoemId(String poemId) {
        this.poemId = poemId == null ? null : poemId.trim();
    }

    public String getPoemDate() {
        return poemDate;
    }

    public void setPoemDate(String poemDate) {
        this.poemDate = poemDate == null ? null : poemDate.trim();
    }

    public String getPoemTitle() {
        return poemTitle;
    }

    public void setPoemTitle(String poemTitle) {
        this.poemTitle = poemTitle == null ? null : poemTitle.trim();
    }

    public String getPoemAuthor() {
        return poemAuthor;
    }

    public void setPoemAuthor(String poemAuthor) {
        this.poemAuthor = poemAuthor == null ? null : poemAuthor.trim();
    }

    public String getPoemContent() {
        return poemContent;
    }

    public void setPoemContent(String poemContent) {
        this.poemContent = poemContent == null ? null : poemContent.trim();
    }

    public String getPoemTemplate() {
        return poemTemplate;
    }

    public void setPoemTemplate(String poemTemplate) {
        this.poemTemplate = poemTemplate == null ? null : poemTemplate.trim();
    }

    public String getPoemWord() {
        return poemWord;
    }

    public void setPoemWord(String poemWord) {
        this.poemWord = poemWord == null ? null : poemWord.trim();
    }

    public String getPoemLectorId() {
        return poemLectorId;
    }

    public void setPoemLectorId(String poemLectorId) {
        this.poemLectorId = poemLectorId == null ? null : poemLectorId.trim();
    }

    public String getPoemLectorExplain() {
        return poemLectorExplain;
    }

    public void setPoemLectorExplain(String poemLectorExplain) {
        this.poemLectorExplain = poemLectorExplain == null ? null : poemLectorExplain.trim();
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public String getCreateUser() {
        return createUser;
    }

    public void setCreateUser(String createUser) {
        this.createUser = createUser == null ? null : createUser.trim();
    }

	public String getLectorName() {
		return lectorName;
	}

	public void setLectorName(String lectorName) {
		this.lectorName = lectorName;
	}
    
}