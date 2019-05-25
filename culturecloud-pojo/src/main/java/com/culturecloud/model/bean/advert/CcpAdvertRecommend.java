package com.culturecloud.model.bean.advert;


import com.culturecloud.annotations.Id;
import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;

import javax.persistence.Column;
import java.util.Date;
@Table(value="ccp_advert_recommend")
public class CcpAdvertRecommend implements BaseEntity {

	private static final long serialVersionUID = 35472065588717768L;

	@Id
    @Column(name="advert_id")
    private String advertId;

    @Column(name="advert_title")
    private String advertTitle;

    @Column(name="advert_url")
    private String advertUrl;

    @Column(name="advert_img_url")
    private String advertImgUrl;

    @Column(name="advert_link")
    private Integer advertLink;

    @Column(name="advert_link_type")
    private Integer advertLinkType;

    @Column(name="advert_postion")
    private Integer advertPostion;

    @Column(name="advert_type")
    private String advertType;

    @Column(name="advert_sort")
    private Integer advertSort;

    @Column(name="advert_state")
    private Integer advertState;

    @Column(name="create_by")
    private String createBy;

    @Column(name="update_by")
    private String updateBy;

    @Column(name="create_time")
    private Date createTime;

    @Column(name="update_time")
    private Date updateTime;

    public String getAdvertId() {
        return advertId;
    }

    public void setAdvertId(String advertId) {
        this.advertId = advertId;
    }

    public String getAdvertUrl() {
        return advertUrl;
    }

    public void setAdvertUrl(String advertUrl) {
        this.advertUrl = advertUrl;
    }

    public String getAdvertImgUrl() {
        return advertImgUrl;
    }

    public void setAdvertImgUrl(String advertImgUrl) {
        this.advertImgUrl = advertImgUrl;
    }

    public Integer getAdvertLink() {
        return advertLink;
    }

    public void setAdvertLink(Integer advertLink) {
        this.advertLink = advertLink;
    }

    public Integer getAdvertLinkType() {
        return advertLinkType;
    }

    public void setAdvertLinkType(Integer advertLinkType) {
        this.advertLinkType = advertLinkType;
    }

    public Integer getAdvertPostion() {
        return advertPostion;
    }

    public void setAdvertPostion(Integer advertPostion) {
        this.advertPostion = advertPostion;
    }

   
    public String getAdvertType() {
		return advertType;
	}

	public void setAdvertType(String advertType) {
		this.advertType = advertType;
	}

	public Integer getAdvertSort() {
        return advertSort;
    }

    public void setAdvertSort(Integer advertSort) {
        this.advertSort = advertSort;
    }

    public Integer getAdvertState() {
        return advertState;
    }

    public void setAdvertState(Integer advertState) {
        this.advertState = advertState;
    }

    public String getCreateBy() {
        return createBy;
    }

    public void setCreateBy(String createBy) {
        this.createBy = createBy;
    }

    public String getUpdateBy() {
        return updateBy;
    }

    public void setUpdateBy(String updateBy) {
        this.updateBy = updateBy;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    public String getAdvertTitle() {
        return advertTitle;
    }

    public void setAdvertTitle(String advertTitle) {
        this.advertTitle = advertTitle;
    }
}
