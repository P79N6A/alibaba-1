package com.sun3d.why.model;

import com.sun3d.why.util.Pagination;

import java.io.Serializable;
import java.util.Date;

public class CmsActivityRoom extends Pagination implements Serializable {

	/**活动室是否可预订数目 **/
    private Integer roomCount;

    public Integer getRoomCount() {
        return roomCount;
    }

    public void setRoomCount(Integer roomCount) {
        this.roomCount = roomCount;
    }

    /** 展馆id **/
    private String venueId;

    public String getVenueId() {
        return venueId;
    }

    public void setVenueId(String venueId) {
        this.venueId = venueId;
    }

    /**展馆名称 **/
    private String venueName;
    /**展馆地址 **/
    private String venueAddress;

    private Integer venueIsDel;

    public String getVenueName() {
        return venueName;
    }

    public void setVenueName(String venueName) {
        this.venueName = venueName;
    }

    public String getVenueAddress() {
        return venueAddress;
    }

    public void setVenueAddress(String venueAddress) {
        this.venueAddress = venueAddress;
    }

    private String roomId;

    private String roomName;

    private String roomPicUrl;

    private Integer roomCapacity;

    private Integer roomDayMonday;

    private Integer roomDayTuesday;

    private Integer roomDayWednesday;

    private Integer roomDayThursday;

    private Integer roomDayFriday;

    private Integer roomDaySaturday;

    private Integer roomDaySunday;

    private String roomFee;

    private Date roomCreateTime;

    private String roomCreateUser;

    private Date roomUpdateTime;

    private String roomUpdateUser;

    private Integer roomIsDel;

    private String roomVenueId;

    private String roomNo;

    private Integer roomIsClosed;

    private String roomConsultTel;

    private Integer roomIsFree;

    private String roomArea;

    private String roomReleaseNotice;

    private String roomFacilityInfo;

    private Integer statisticCount;

    private String venueCity;

    private String venueArea;

    private Integer roomState;

    //活动室配套设施
     private String dictName;

    private String roomIntro;

    private String roomRemark;
    
    /**后台搜索关键词*/
    private String SearchKey;

    private Integer availableCount;

    public String getRoomIntro() {
        return roomIntro;
    }

    public void setRoomIntro(String roomIntro) {
        this.roomIntro = roomIntro == null ? null : roomIntro.trim();
    }

    public String getRoomRemark() {
        return roomRemark;
    }

    public void setRoomRemark(String roomRemark) {
        this.roomRemark = roomRemark == null ? null : roomRemark.trim();
    }

    public String getDictName() {
        return dictName;
    }

    public void setDictName(String dictName) {
        this.dictName = dictName;
    }

    //活动室标签名称
    private String roomTagName;
    //活动室标签id
    private  String roomTag;

    public String getRoomTag() {
        return roomTag;
    }

    public void setRoomTag(String roomTag) {
        this.roomTag = roomTag;
    }

    //配套设施
    private String roomFacilityDict;
    
    private String sysId;
    private String sysNo;
    public String getRoomId() {
        return roomId;
    }

    public void setRoomId(String roomId) {
        this.roomId = roomId == null ? null : roomId.trim();
    }

    public String getRoomVenueId() {return roomVenueId;}

    public void setRoomVenueId(String roomVenueId) {this.roomVenueId = roomVenueId == null ? null : roomVenueId.trim();}

    public String getRoomName() {
        return roomName;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName == null ? null : roomName.trim();
    }

    public String getRoomPicUrl() {
        return roomPicUrl;
    }

    public void setRoomPicUrl(String roomPicUrl) {
        this.roomPicUrl = roomPicUrl == null ? null : roomPicUrl.trim();
    }

    public Integer getRoomCapacity() {
        return roomCapacity;
    }

    public void setRoomCapacity(Integer roomCapacity) {
        this.roomCapacity = roomCapacity;
    }

    public Integer getRoomDayMonday() {
        return roomDayMonday;
    }

    public void setRoomDayMonday(Integer roomDayMonday) {
        this.roomDayMonday = roomDayMonday;
    }

    public Integer getRoomDayTuesday() {
        return roomDayTuesday;
    }

    public void setRoomDayTuesday(Integer roomDayTuesday) {
        this.roomDayTuesday = roomDayTuesday;
    }

    public Integer getRoomDayWednesday() {
        return roomDayWednesday;
    }

    public void setRoomDayWednesday(Integer roomDayWednesday) {
        this.roomDayWednesday = roomDayWednesday;
    }

    public Integer getRoomDayThursday() {
        return roomDayThursday;
    }

    public void setRoomDayThursday(Integer roomDayThursday) {
        this.roomDayThursday = roomDayThursday;
    }

    public Integer getRoomDayFriday() {
        return roomDayFriday;
    }

    public void setRoomDayFriday(Integer roomDayFriday) {
        this.roomDayFriday = roomDayFriday;
    }

    public Integer getRoomDaySaturday() {
        return roomDaySaturday;
    }

    public void setRoomDaySaturday(Integer roomDaySaturday) {
        this.roomDaySaturday = roomDaySaturday;
    }

    public Integer getRoomDaySunday() {
        return roomDaySunday;
    }

    public void setRoomDaySunday(Integer roomDaySunday) {
        this.roomDaySunday = roomDaySunday;
    }

    public String getRoomFee() {
        return roomFee;
    }

    public void setRoomFee(String roomFee) {
        this.roomFee = roomFee == null ? null : roomFee.trim();
    }

    public Date getRoomCreateTime() {
        return roomCreateTime;
    }

    public void setRoomCreateTime(Date roomCreateTime) {
        this.roomCreateTime = roomCreateTime;
    }

    public String getRoomCreateUser() {
        return roomCreateUser;
    }

    public void setRoomCreateUser(String roomCreateUser) {
        this.roomCreateUser = roomCreateUser == null ? null : roomCreateUser.trim();
    }

    public Date getRoomUpdateTime() {
        return roomUpdateTime;
    }

    public void setRoomUpdateTime(Date roomUpdateTime) {
        this.roomUpdateTime = roomUpdateTime;
    }

    public String getRoomUpdateUser() {
        return roomUpdateUser;
    }

    public void setRoomUpdateUser(String roomUpdateUser) {
        this.roomUpdateUser = roomUpdateUser == null ? null : roomUpdateUser.trim();
    }

    public Integer getRoomIsDel() {
        return roomIsDel;
    }

    public void setRoomIsDel(Integer roomIsDel) {
        this.roomIsDel = roomIsDel;
    }

    public String getRoomNo() {
        return roomNo;
    }

    public void setRoomNo(String roomNo) {
        this.roomNo = roomNo;
    }

    public Integer getRoomIsClosed() {
        return roomIsClosed;
    }

    public void setRoomIsClosed(Integer roomIsClosed) {
        this.roomIsClosed = roomIsClosed;
    }

    public String getRoomConsultTel() {
        return roomConsultTel;
    }

    public void setRoomConsultTel(String roomConsultTel) {
        this.roomConsultTel = roomConsultTel;
    }

    public Integer getRoomIsFree() {
        return roomIsFree;
    }

    public void setRoomIsFree(Integer roomIsFree) {
        this.roomIsFree = roomIsFree;
    }

    public String getRoomArea() {
        return roomArea;
    }

    public void setRoomArea(String roomArea) {
        this.roomArea = roomArea;
    }

    public String getRoomReleaseNotice() {
        return roomReleaseNotice;
    }

    public void setRoomReleaseNotice(String roomReleaseNotice) {
        this.roomReleaseNotice = roomReleaseNotice;
    }

    public String getRoomFacilityInfo() {
		return roomFacilityInfo;
	}

	public void setRoomFacilityInfo(String roomFacilityInfo) {
		this.roomFacilityInfo = roomFacilityInfo;
	}

    public String getRoomTagName() {
        return roomTagName;
    }

    public void setRoomTagName(String roomTagName) {
        this.roomTagName = roomTagName;
    }

    public String getRoomFacilityDict() {
		return roomFacilityDict;
	}

	public void setRoomFacilityDict(String roomFacilityDict) {
		this.roomFacilityDict = roomFacilityDict;
	}

	public Integer getStatisticCount() {
        return statisticCount;
    }

    public void setStatisticCount(Integer statisticCount) {
        this.statisticCount = statisticCount;
    }

    public String getVenueCity() {
        return venueCity;
    }

    public void setVenueCity(String venueCity) {
        this.venueCity = venueCity == null ? null : venueCity.trim();
    }

    public String getVenueArea() {
        return venueArea;
    }

    public void setVenueArea(String venueArea) {
        this.venueArea = venueArea;
    }

    public Integer getRoomState() {
        return roomState;
    }

    public void setRoomState(Integer roomState) {
        this.roomState = roomState;
    }

	public String getSysId() {
		return sysId;
	}

	public void setSysId(String sysId) {
		this.sysId = sysId;
	}

	public String getSysNo() {
		return sysNo;
	}

	public void setSysNo(String sysNo) {
		this.sysNo = sysNo;
	}

    public Integer getVenueIsDel() {
        return venueIsDel;
    }

    public void setVenueIsDel(Integer venueIsDel) {
        this.venueIsDel = venueIsDel;
    }

	public String getSearchKey() {
		return SearchKey;
	}

	public void setSearchKey(String searchKey) {
		SearchKey = searchKey;
	}

    public Integer getAvailableCount() {
        return availableCount;
    }

    public void setAvailableCount(Integer availableCount) {
        this.availableCount = availableCount;
    }
    
    
}