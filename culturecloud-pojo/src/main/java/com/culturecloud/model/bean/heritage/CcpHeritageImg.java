package com.culturecloud.model.bean.heritage;

import java.util.Date;

import javax.persistence.Column;

import com.culturecloud.annotations.Id;
import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;

@Table(value="ccp_heritage_img")
public class CcpHeritageImg implements BaseEntity{
    
	private static final long serialVersionUID = -2982023031953838442L;

	@Id
	@Column(name="HERITAGE_IMG_ID")
	private String heritageImgId;

	@Column(name="HERITAGE_ID")
    private String heritageId;

	@Column(name="HERITAGE_IMG_URL")
    private String heritageImgUrl;

	@Column(name="CREATE_TIME")
    private Date createTime;

    public String getHeritageImgId() {
        return heritageImgId;
    }

    public void setHeritageImgId(String heritageImgId) {
        this.heritageImgId = heritageImgId == null ? null : heritageImgId.trim();
    }

    public String getHeritageId() {
        return heritageId;
    }

    public void setHeritageId(String heritageId) {
        this.heritageId = heritageId == null ? null : heritageId.trim();
    }

    public String getHeritageImgUrl() {
        return heritageImgUrl;
    }

    public void setHeritageImgUrl(String heritageImgUrl) {
        this.heritageImgUrl = heritageImgUrl == null ? null : heritageImgUrl.trim();
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }
}