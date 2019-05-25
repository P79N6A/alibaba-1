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
    
    private String lectorHeadImg;
    
    private String lectorJob;
    
    private String lectorIntro;
    
    private String userId;
    
    private Integer selectCompleteCount = 0;		//1：查询poemCompleteCount
    
    private Integer poemCompleteCount;	//用户已完成的题目总数
    
    private Integer poemIsComplete;	//是否完成题目
    
    private Integer wantCount;
    
    private Integer userIsWant;
    
    public CcpPoem() {
		super();
	}

	public CcpPoem(Integer poemCompleteCount) {
		super();
		this.poemCompleteCount = poemCompleteCount;
	}

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

	public String getLectorHeadImg() {
		return lectorHeadImg;
	}

	public void setLectorHeadImg(String lectorHeadImg) {
		this.lectorHeadImg = lectorHeadImg;
	}

	public String getLectorJob() {
		return lectorJob;
	}

	public void setLectorJob(String lectorJob) {
		this.lectorJob = lectorJob;
	}

	public String getLectorIntro() {
		return lectorIntro;
	}

	public void setLectorIntro(String lectorIntro) {
		this.lectorIntro = lectorIntro;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public Integer getPoemCompleteCount() {
		return poemCompleteCount;
	}

	public void setPoemCompleteCount(Integer poemCompleteCount) {
		this.poemCompleteCount = poemCompleteCount;
	}

	public Integer getPoemIsComplete() {
		return poemIsComplete;
	}

	public void setPoemIsComplete(Integer poemIsComplete) {
		this.poemIsComplete = poemIsComplete;
	}

	public Integer getSelectCompleteCount() {
		return selectCompleteCount;
	}

	public void setSelectCompleteCount(Integer selectCompleteCount) {
		this.selectCompleteCount = selectCompleteCount;
	}

	public Integer getWantCount() {
		return wantCount;
	}

	public void setWantCount(Integer wantCount) {
		this.wantCount = wantCount;
	}

	public Integer getUserIsWant() {
		return userIsWant;
	}

	public void setUserIsWant(Integer userIsWant) {
		this.userIsWant = userIsWant;
	}
	
}