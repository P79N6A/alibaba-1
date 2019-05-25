package com.sun3d.why.model;

import com.sun3d.why.util.Pagination;

import java.io.Serializable;
import java.util.Date;

public class CmsVenue extends Pagination implements Serializable {
    private String activityName;

    private Integer venueIsWant;

    public Integer getVenueIsWant() {
        return venueIsWant;
    }

    public void setVenueIsWant(Integer venueIsWant) {
        this.venueIsWant = venueIsWant;
    }

    public String getActivityName() {
        return activityName;
    }

    public void setActivityName(String activityName) {
        this.activityName = activityName == null ? null : activityName.trim();
    }

    /**用户性别 **/
    private String userSexs;

    public String getUserSexs() {
        return userSexs;
    }

    public void setUserSexs(String userSexs) {
        this.userSexs = userSexs;
    }

    /**截取获取的区 **/
    private String area;

    public String getArea() {
        return area;
    }

    public void setArea(String area) {
        this.area = area;
    }

    /**截取获取的市 **/
    private String city;

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    /**用户与展馆之间的距离 **/
    private Double distance;

    public Double getDistance() {
        return distance;
    }

    public void setDistance(Double distance) {
        this.distance = distance;
    }

    /**用户头像 **/
    private String userHeadImgUrl;

    public String getUserHeadImgUrl() {
        return userHeadImgUrl;
    }

    public void setUserHeadImgUrl(String userHeadImgUrl) {
        this.userHeadImgUrl = userHeadImgUrl;
    }
    /**用户昵称 **/
    private String  userNickNames;

    public String getUserNickNames() {
        return userNickNames;
    }

    public void setUserNickNames(String userNickNames) {
        this.userNickNames = userNickNames;
    }

    /**活动室名称 **/
     private String roomNames;

    public String getRoomNames() {
        return roomNames;
    }

    public void setRoomNames(String roomNames) {
        this.roomNames = roomNames;
    }

    /**活动室url **/
    private String roomUrls;

    public String getRoomUrls() {
        return roomUrls;
    }

    public void setRoomUrls(String roomUrls) {
        this.roomUrls = roomUrls;
    }

    /**
     * 场馆id
     */
    private String venueId;

    /**
     * 场馆名称
     */
    private String venueName;

    /**
     * 场馆图标
     */
    private String venueIconUrl;

    /**
     * 场馆坐标经度
     */
    private Double venueLon;

    /**
     * 场馆坐标纬度
     */
    private Double venueLat;

    /**
     * 场馆所在省，cms_dict表关联
     */
    private String venueProvince;

    /**
     * 场馆所在市，cms_dict表关联
     */
    private String venueCity;

    /**
     * 场馆所在区域，cms_dict表关联
     */
    private String venueArea;

    /**
     * 场馆所在详细地址
     */
    private String venueAddress;

    /**
     * 场馆开放时间
     */
    private String venueOpenTime;

    /**
     * 场馆类型，cms_dict表关联
     */
    private String venueType;

    /**
     * 场馆联系人
     */
    private String venueLinkman;

    /**
     * 场馆网站
     */
    private String venueSites;

    /**
     * 场馆联系邮箱
     */
    private String venueMail;

    /**
     * 场馆联系电话
     */
    private String venueTel;

    /**
     * 场馆联系手机号码
     */
    private String venueMobile;

    /**
     * 场馆是否免费 1：免费 2：收费
     */
    private Integer venueIsFree;

    /**
     * 场馆门票价格
     */
    private String venuePrice;

    /**
     * 场馆所属商圈
     */
    private String venueBusiness;

    /**
     * 是否有音频 1：否 2：是
     */
    private Integer venueIsVoice;

    /**
     * 场馆音频地址
     */
    private String venueVoiceUrl;

    /**
     * 是否有视频 1：否 2：是
     */
    private Integer venueIsVideo;

    /**
     * 场馆视频地址
     */
    private String venueVideoUrl;

    /**
     * 是否虚拟漫游 1：否 2：是
     */
    private Integer venueIsRoam;

    /**
     * 虚拟漫游地址
     */
    private String venueRoamUrl;

    private String venueCrowd;

    private String venueMood;

    /**
     * 是否删除 2：删除 1：未删除
     */
    private Integer venueIsDel;

    /**
     * 状态 1-草稿 2-已审核 3-退回 4-回收站
     */
    private Integer venueState;

    /**
     * 场馆信息创建时间
     */
    private Date venueCreateTime;

    /**
     * 场馆信息更新时间
     */
    private Date venueUpdateTime;

    /**
     * 场馆信息创建人，cms_user表关联
     */
    private String venueCreateUser;

    /**
     * 场馆信息更新人，cms_user表关联2
     */
    private String venueUpdateUser;

    /**
     * 权限信息(部门标示)
     */
    private String venueDept;

    /**
     * 是否可预定 1-否 2 -是
     */
    private Integer venueIsReserve;

    // 本周最受欢迎藏品
    private Integer weekBrowseCount;
     //年浏览次数
    private  Integer yearBrowseCount;
    //新添加字段

    private String venueEndTime;

    private String venueMon;

    private String venueTue;

    private String venueWed;

    private String venueThu;

    private String venueFri;

    private String managerId;

    private String venueMemo;

    private String venueRemark;

    private String dictName;

    private String openNotice;

    private Integer venueHasRoom;

    private Integer venueHasAntique;

    private String tagId;

    private Integer statisticCount;
    private String sysId;
    private String sysNo;
    private Integer commentCount;
    /**展馆是否收藏*/
    private Integer collectNum;
    /**场馆对应的部门ID*/
    private String venueDeptId;
    /**场馆对应部门的上级部门ID*/
    private String venueParentDeptId;
    /**场馆对应部门的上级部门名称*/
    private String venueParentDeptName;

    private String tagName;

    private String venueMetroText;
    
    private String venueBusText;
    
    /**
     * 场馆设施
     */
    private String venueFacility;
    
    private Integer venueSort;

    public String getVenueFacility() {
		return venueFacility;
	}

	public void setVenueFacility(String venueFacility) {
		this.venueFacility = venueFacility;
	}

	public String getVenueMetroText() {
		return venueMetroText;
	}

	public void setVenueMetroText(String venueMetroText) {
		this.venueMetroText = venueMetroText;
	}

	public String getVenueBusText() {
		return venueBusText;
	}

	public void setVenueBusText(String venueBusText) {
		this.venueBusText = venueBusText;
	}

	public String getTagName() {
        return tagName;
    }

    public void setTagName(String tagName) {
        this.tagName = tagName == null ? null : tagName.trim();
    }

    public Integer getCollectNum() {
        return collectNum!=null?collectNum:0;
    }

    public void setCollectNum(Integer collectNum) {
        this.collectNum = collectNum;
    }

    /**有无地铁*/
    private Integer venueHasMetro;
    /**有无公交*/
    private Integer venueHasBus;
    /**场馆星级*/
    private String venueStars;
    /**是否推荐*/
    private Integer venueIsRecommend;
    /**推荐时间*/
    private Date venueRecommendTime;

    private  String remarks;
    private  String userNames;

    private String venuePanorama;
    
    /**后台搜索关键词*/
    private String searchKey;
    /**
     * 场馆所对应的权限标签
     */
    private Integer venueDeptLable;
    /**
     * 权限标签(文广体系、独立商家、其他)
     */
    private Integer userLabel1;
    private Integer userLabel2;
    private Integer userLabel3;
    
    
    /**
     * 收费备注
     */
    private String venuePriceNotice;


    public String getVenuePanorama() {
        return venuePanorama;
    }

    public void setVenuePanorama(String venuePanorama) {
        this.venuePanorama = venuePanorama == null ? null : venuePanorama.trim();
    }

    public String getUserNames() {
        return userNames;
    }

    public void setUserNames(String userNames) {
        this.userNames = userNames;
    }

    public String getRemarks() {

        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    public Integer getCommentCount() {
        return commentCount;
    }

    public void setCommentCount(Integer commentCount) {
        this.commentCount = commentCount;
    }

    public String getVenueEndTime() {
        return venueEndTime;
    }

    public void setVenueEndTime(String venueEndTime) {
        this.venueEndTime = venueEndTime == null ? null : venueEndTime.trim();
    }

    public String getVenueSun() {
        return venueSun;
    }

    public void setVenueSun(String venueSun) {
        this.venueSun = venueSun;
    }

    public String getVenueFri() {
        return venueFri;
    }

    public void setVenueFri(String venueFri) {
        this.venueFri = venueFri;
    }

    public String getVenueSat() {
        return venueSat;
    }

    public void setVenueSat(String venueSat) {
        this.venueSat = venueSat;
    }

    public String getVenueThu() {
        return venueThu;
    }

    public void setVenueThu(String venueThu) {
        this.venueThu = venueThu;
    }

    public String getVenueWed() {
        return venueWed;
    }

    public void setVenueWed(String venueWed) {
        this.venueWed = venueWed;
    }

    public String getVenueTue() {
        return venueTue;
    }

    public void setVenueTue(String venueTue) {
        this.venueTue = venueTue;
    }

    public String getVenueMon() {
        return venueMon;
    }

    public void setVenueMon(String venueMon) {
        this.venueMon = venueMon;
    }

    private String venueSat;

    private String venueSun;

    public Integer getYearBrowseCount() {
        return yearBrowseCount;
    }

    public void setYearBrowseCount(Integer yearBrowseCount) {
        this.yearBrowseCount = yearBrowseCount;
    }

    //年度收藏次数
    private Integer yearCollectCount;

    public Integer getYearCollectCount() {
        return yearCollectCount;
    }

    public void setYearCollectCount(Integer yearCollectCount) {
        this.yearCollectCount = yearCollectCount;
    }

    public Integer getWeekBrowseCount() {
        return weekBrowseCount;
    }

    public void setWeekBrowseCount(Integer weekBrowseCount) {
        this.weekBrowseCount = weekBrowseCount;
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

    public Double getVenueLon() {
        return venueLon;
    }

    public void setVenueLon(Double venueLon) {
        this.venueLon = venueLon;
    }

    public Double getVenueLat() {
        return venueLat;
    }

    public void setVenueLat(Double venueLat) {
        this.venueLat = venueLat;
    }

    public String getVenueProvince() {
        return venueProvince;
    }

    public void setVenueProvince(String venueProvince) {
        this.venueProvince = venueProvince == null ? null : venueProvince.trim();
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
        this.venueArea = venueArea == null ? null : venueArea.trim();
    }

    public String getVenueAddress() {
        return venueAddress;
    }

    public void setVenueAddress(String venueAddress) {
        this.venueAddress = venueAddress == null ? null : venueAddress.trim();
    }

    public String getVenueOpenTime() {
        return venueOpenTime;
    }

    public void setVenueOpenTime(String venueOpenTime) {
        this.venueOpenTime = venueOpenTime == null ? null : venueOpenTime.trim();
    }

    public String getVenueType() {
        return venueType;
    }

    public void setVenueType(String venueType) {
        this.venueType = venueType == null ? null : venueType.trim();
    }

    public String getVenueLinkman() {
        return venueLinkman;
    }

    public void setVenueLinkman(String venueLinkman) {
        this.venueLinkman = venueLinkman == null ? null : venueLinkman.trim();
    }

    public String getVenueSites() {
        return venueSites;
    }

    public void setVenueSites(String venueSites) {
        this.venueSites = venueSites == null ? null : venueSites.trim();
    }

    public String getVenueMail() {
        return venueMail;
    }

    public void setVenueMail(String venueMail) {
        this.venueMail = venueMail == null ? null : venueMail.trim();
    }

    public String getVenueTel() {
        return venueTel;
    }

    public void setVenueTel(String venueTel) {
        this.venueTel = venueTel == null ? null : venueTel.trim();
    }

    public String getVenueMobile() {
        return venueMobile;
    }

    public void setVenueMobile(String venueMobile) {
        this.venueMobile = venueMobile == null ? null : venueMobile.trim();
    }

    public Integer getVenueIsFree() {
        return venueIsFree;
    }

    public void setVenueIsFree(Integer venueIsFree) {
        this.venueIsFree = venueIsFree;
    }

    public String getVenuePrice() {
        return venuePrice;
    }

    public void setVenuePrice(String venuePrice) {
        this.venuePrice = venuePrice == null ? null : venuePrice.trim();
    }

    public String getVenueBusiness() {
        return venueBusiness;
    }

    public void setVenueBusiness(String venueBusiness) {
        this.venueBusiness = venueBusiness == null ? null : venueBusiness.trim();
    }

    public Integer getVenueIsVoice() {
        return venueIsVoice;
    }

    public void setVenueIsVoice(Integer venueIsVoice) {
        this.venueIsVoice = venueIsVoice;
    }

    public String getVenueVoiceUrl() {
        return venueVoiceUrl;
    }

    public void setVenueVoiceUrl(String venueVoiceUrl) {
        this.venueVoiceUrl = venueVoiceUrl == null ? null : venueVoiceUrl.trim();
    }

    public Integer getVenueIsVideo() {
        return venueIsVideo;
    }

    public void setVenueIsVideo(Integer venueIsVideo) {
        this.venueIsVideo = venueIsVideo;
    }

    public String getVenueVideoUrl() {
        return venueVideoUrl;
    }

    public void setVenueVideoUrl(String venueVideoUrl) {
        this.venueVideoUrl = venueVideoUrl == null ? null : venueVideoUrl.trim();
    }

    public Integer getVenueIsRoam() {
        return venueIsRoam;
    }

    public void setVenueIsRoam(Integer venueIsRoam) {
        this.venueIsRoam = venueIsRoam;
    }

    public String getVenueRoamUrl() {
        return venueRoamUrl;
    }

    public void setVenueRoamUrl(String venueRoamUrl) {
        this.venueRoamUrl = venueRoamUrl == null ? null : venueRoamUrl.trim();
    }

    public String getVenueCrowd() {
        return venueCrowd;
    }

    public void setVenueCrowd(String venueCrowd) {
        this.venueCrowd = venueCrowd;
    }

    public String getVenueMood() {
        return venueMood;
    }

    public void setVenueMood(String venueMood) {
        this.venueMood = venueMood;
    }

    public Integer getVenueIsDel() {
        return venueIsDel;
    }

    public void setVenueIsDel(Integer venueIsDel) {
        this.venueIsDel = venueIsDel;
    }

    public Integer getVenueState() {
        return venueState;
    }

    public void setVenueState(Integer venueState) {
        this.venueState = venueState;
    }

    public Date getVenueCreateTime() {
        return venueCreateTime;
    }

    public void setVenueCreateTime(Date venueCreateTime) {
        this.venueCreateTime = venueCreateTime;
    }

    public Date getVenueUpdateTime() {
        return venueUpdateTime;
    }

    public void setVenueUpdateTime(Date venueUpdateTime) {
        this.venueUpdateTime = venueUpdateTime;
    }

    public String getVenueCreateUser() {
        return venueCreateUser;
    }

    public void setVenueCreateUser(String venueCreateUser) {
        this.venueCreateUser = venueCreateUser == null ? null : venueCreateUser.trim();
    }

    public String getVenueUpdateUser() {
        return venueUpdateUser;
    }

    public void setVenueUpdateUser(String venueUpdateUser) {
        this.venueUpdateUser = venueUpdateUser == null ? null : venueUpdateUser.trim();
    }

	public Integer getVenueIsReserve() {
		return venueIsReserve;
	}

	public void setVenueIsReserve(Integer venueIsReserve) {
		this.venueIsReserve = venueIsReserve;
	}

    public String getManagerId() {
        return managerId;
    }

    public void setManagerId(String managerId) {
        this.managerId = managerId == null ? null : managerId.trim();
    }

    public String getVenueRemark() {
        return venueRemark;
    }

    public void setVenueRemark(String venueRemark) {
        this.venueRemark = venueRemark;
    }

    public String getVenueMemo() {
        return venueMemo;
    }

    public void setVenueMemo(String venueMemo) {
        this.venueMemo = venueMemo == null ? null : venueMemo.trim();
    }

    public String getVenueDept() {
        return venueDept;
    }

    public void setVenueDept(String venueDept) {
        this.venueDept = venueDept == null ? null : venueDept.trim();
    }

    public String getDictName() {
        return dictName;
    }

    public void setDictName(String dictName) {
        this.dictName = dictName == null ? null : dictName.trim();
    }


    public String getOpenNotice() {
        return openNotice;
    }

    public void setOpenNotice(String openNotice) {
        this.openNotice = openNotice;
    }

    public Integer getVenueHasRoom() {
        return venueHasRoom;
    }

    public void setVenueHasRoom(Integer venueHasRoom) {
        this.venueHasRoom = venueHasRoom;
    }

    public Integer getVenueHasAntique() {
        return venueHasAntique;
    }

    public void setVenueHasAntique(Integer venueHasAntique) {
        this.venueHasAntique = venueHasAntique;
    }

    public String getTagId() {
        return tagId;
    }

    public void setTagId(String tagId) {
        this.tagId = tagId;
    }

    public Integer getStatisticCount() {
        return statisticCount;
    }

    public void setStatisticCount(Integer statisticCount) {
        this.statisticCount = statisticCount;
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

	public Integer getVenueHasMetro() {
		return venueHasMetro;
	}

	public void setVenueHasMetro(Integer venueHasMetro) {
		this.venueHasMetro = venueHasMetro;
	}

	public Integer getVenueHasBus() {
		return venueHasBus;
	}
	
	public void setVenueHasBus(Integer venueHasBus) {
		this.venueHasBus = venueHasBus;
	}

	public String getVenueStars() {
		return venueStars;
	}

	public void setVenueStars(String venueStars) {
		this.venueStars = venueStars;
	}

	public Integer getVenueIsRecommend() {
		return venueIsRecommend;
	}

	public void setVenueIsRecommend(Integer venueIsRecommend) {
		this.venueIsRecommend = venueIsRecommend;
	}

	public Date getVenueRecommendTime() {
		return venueRecommendTime;
	}

	public void setVenueRecommendTime(Date venueRecommendTime) {
		this.venueRecommendTime = venueRecommendTime;
	}

	public String getVenueDeptId() {
		return venueDeptId;
	}

	public void setVenueDeptId(String venueDeptId) {
		this.venueDeptId = venueDeptId;
	}

	public String getVenueParentDeptId() {
		return venueParentDeptId;
	}

	public void setVenueParentDeptId(String venueParentDeptId) {
		this.venueParentDeptId = venueParentDeptId;
	}

	public String getVenueParentDeptName() {
		return venueParentDeptName;
	}

	public void setVenueParentDeptName(String venueParentDeptName) {
		this.venueParentDeptName = venueParentDeptName;
	}

	public String getSearchKey() {
		return searchKey;
	}

	public void setSearchKey(String searchKey) {
		this.searchKey = searchKey;
	}


    public Integer getVenueDeptLable() {
        return venueDeptLable;
    }

    public void setVenueDeptLable(Integer venueDeptLable) {
        this.venueDeptLable = venueDeptLable;
    }

    public Integer getUserLabel1() {
        return userLabel1;
    }

    public void setUserLabel1(Integer userLabel1) {
        this.userLabel1 = userLabel1;
    }

    public Integer getUserLabel2() {
        return userLabel2;
    }

    public void setUserLabel2(Integer userLabel2) {
        this.userLabel2 = userLabel2;
    }

    public Integer getUserLabel3() {
        return userLabel3;
    }

    public void setUserLabel3(Integer userLabel3) {
        this.userLabel3 = userLabel3;
    }

	public String getVenuePriceNotice() {
		return venuePriceNotice;
	}

	public void setVenuePriceNotice(String venuePriceNotice) {
		this.venuePriceNotice = venuePriceNotice;
	}

	private Integer relationType; //是否关联成员   1：已关联，0：未关联

    public Integer getRelationType() {
        return relationType;
    }

    public void setRelationType(Integer relationType) {
        this.relationType = relationType;
    }

	public Integer getVenueSort() {
		return venueSort;
	}

	public void setVenueSort(Integer venueSort) {
		this.venueSort = venueSort;
	}
}