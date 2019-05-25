package com.sun3d.why.model.league;

public class CmsMemberBO extends CmsMember{

    private String searchName;

    private String leagueName;

    private String createUserName;

    private String[] relateIds;

    private Integer relationType; //关联状态 1 已关联，0 ，未关联

    public String getLeagueName() {
        return leagueName;
    }

    public void setLeagueName(String leagueName) {
        this.leagueName = leagueName;
    }

    public String getCreateUserName() {
        return createUserName;
    }

    public void setCreateUserName(String createUserName) {
        this.createUserName = createUserName;
    }

    public String[] getRelateIds() {
        return relateIds;
    }

    public void setRelateIds(String[] relateIds) {
        this.relateIds = relateIds;
    }

    public String getSearchName() {
        return searchName;
    }

    public void setSearchName(String searchName) {
        this.searchName = searchName;
    }

    public Integer getRelationType() {
        return relationType;
    }

    public void setRelationType(Integer relationType) {
        this.relationType = relationType;
    }
}