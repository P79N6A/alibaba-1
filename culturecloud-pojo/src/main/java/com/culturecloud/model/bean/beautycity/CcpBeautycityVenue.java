package com.culturecloud.model.bean.beautycity;

import java.util.Date;

import javax.persistence.Column;

import com.culturecloud.annotations.Id;
import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;

@Table(value="ccp_beautycity_venue")
public class CcpBeautycityVenue implements BaseEntity {
    
	private static final long serialVersionUID = 9138096580760984040L;

	@Id
	@Column(name="BEAUTYCITY_VENUE_ID")
	private String beautycityVenueId;

	@Column(name="VENUE_ID")
    private String venueId;

	@Column(name="VENUE_NAME")
    private String venueName;

	@Column(name="VENUE_ICON_URL")
    private String venueIconUrl;

	@Column(name="VENUE_SORT")
    private Integer venueSort;

	@Column(name="CREATE_TIME")
    private Date createTime;

    public String getBeautycityVenueId() {
        return beautycityVenueId;
    }

    public void setBeautycityVenueId(String beautycityVenueId) {
        this.beautycityVenueId = beautycityVenueId == null ? null : beautycityVenueId.trim();
    }

    public String getVenueId() {
        return venueId;
    }

    public void setVenueId(String venueId) {
        this.venueId = venueId == null ? null : venueId.trim();
    }

    public String getVenueName() {
        return venueName;
    }

    public void setVenueName(String venueName) {
        this.venueName = venueName == null ? null : venueName.trim();
    }

    public String getVenueIconUrl() {
        return venueIconUrl;
    }

    public void setVenueIconUrl(String venueIconUrl) {
        this.venueIconUrl = venueIconUrl == null ? null : venueIconUrl.trim();
    }

    public Integer getVenueSort() {
		return venueSort;
	}

	public void setVenueSort(Integer venueSort) {
		this.venueSort = venueSort;
	}

	public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }
}