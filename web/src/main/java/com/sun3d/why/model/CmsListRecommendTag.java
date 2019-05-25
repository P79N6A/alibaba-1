package com.sun3d.why.model;

import com.sun3d.why.util.Pagination;

import java.io.Serializable;
import java.util.Date;

public class CmsListRecommendTag extends Pagination implements Serializable {

    /*列表页推荐ID(主键)*/
   private   String  listRecommendId;

    /*推荐的标签ID(关联标签表主键)*/
   private  String  tagId;

    /*列表推荐类型(1.活动 2.其它-其它可扩展、如场馆)*/
    private int  listType;

    /*列表推荐类别(1.APP 2.其它可扩展、如WEB)*/
    private int  listAssortment;

    /*推荐更新时间*/
    private Date recommendUpdateTime;

    /**推荐更新人id*/
    private String recommentUpdateUser;


    public String getListRecommendId() {
        return listRecommendId;
    }

    public void setListRecommendId(String listRecommendId) {
        this.listRecommendId = listRecommendId;
    }

    public String getTagId() {
        return tagId;
    }

    public void setTagId(String tagId) {
        this.tagId = tagId;
    }

    public int getListType() {
        return listType;
    }

    public void setListType(int listType) {
        this.listType = listType;
    }

    public int getListAssortment() {
        return listAssortment;
    }

    public void setListAssortment(int listAssortment) {
        this.listAssortment = listAssortment;
    }

    public Date getRecommendUpdateTime() {
        return recommendUpdateTime;
    }

    public void setRecommendUpdateTime(Date recommendUpdateTime) {
        this.recommendUpdateTime = recommendUpdateTime;
    }

    public String getRecommentUpdateUser() {
        return recommentUpdateUser;
    }

    public void setRecommentUpdateUser(String recommentUpdateUser) {
        this.recommentUpdateUser = recommentUpdateUser;
    }


}
