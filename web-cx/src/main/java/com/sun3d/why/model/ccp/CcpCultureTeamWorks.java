package com.sun3d.why.model.ccp;

import java.util.Date;

public class CcpCultureTeamWorks {
    private String cultureTeamWorksId;

    private String cultureTeamId;

    private String worksName;

    private String worksManuscript;

    private String worksStage;
    
    private Integer worksSort;
    
    private Date createTime;

    public String getCultureTeamWorksId() {
        return cultureTeamWorksId;
    }

    public void setCultureTeamWorksId(String cultureTeamWorksId) {
        this.cultureTeamWorksId = cultureTeamWorksId == null ? null : cultureTeamWorksId.trim();
    }

    public String getCultureTeamId() {
        return cultureTeamId;
    }

    public void setCultureTeamId(String cultureTeamId) {
        this.cultureTeamId = cultureTeamId == null ? null : cultureTeamId.trim();
    }

    public String getWorksName() {
        return worksName;
    }

    public void setWorksName(String worksName) {
        this.worksName = worksName == null ? null : worksName.trim();
    }

    public String getWorksManuscript() {
        return worksManuscript;
    }

    public void setWorksManuscript(String worksManuscript) {
        this.worksManuscript = worksManuscript == null ? null : worksManuscript.trim();
    }

    public String getWorksStage() {
        return worksStage;
    }

    public void setWorksStage(String worksStage) {
        this.worksStage = worksStage == null ? null : worksStage.trim();
    }

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public Integer getWorksSort() {
		return worksSort;
	}

	public void setWorksSort(Integer worksSort) {
		this.worksSort = worksSort;
	}

}