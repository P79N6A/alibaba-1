package com.sun3d.why.model;

import com.sun3d.why.util.Pagination;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import org.apache.http.conn.ssl.PrivateKeyDetails;

public class CmsActivity extends Pagination implements Serializable {
    /**
     * 标签颜色
     **/
    private String tagColor;

    /**
     * 标签首字母
     **/
    private String tagInitial;

    /**
     * 模板名称
     **/
    private String funName;

    /**
     * 主键
     */
    private String activityId;

    /**
     * 活动名称
     */
    private String activityName;

    /**
     * 活动联系人
     */
    private String activityLinkman;

    /**
     * 活动类型
     */
    private String activityType;

    /**
     * 活动联系电话
     */
    private String activityTel;




    /**
     * 活动副标题
     */
    private String activityVideoURL;

    /**
     * 活动图标路径
     */
    private String activityIconUrl;

    /**
     * 活动所在省
     */
    private String activityProvince;


    private String activityTheme;
    /**
     * 活动所在市
     */
    private String activityCity;

    /**
     * 活动所在区
     */
    private String activityArea;

    /**
     * 活动详细地址
     */
    private String activityAddress;

    private String addressId;


    /**
     * 活动坐标经度
     */
    private Double activityLon;

    /**
     * 活动坐标纬度
     */
    private Double activityLat;

    //** 是否好友 1：否 2：是

    private Integer activityIsFriends;

    private Integer activityIsCouples;

    private Integer activityIsChild;

    //** 是否老人家 1：否 2：是//
    private Integer activityIsElderly;

    /**
     * 活动时间
     */
    private String activityTime;


    /**
     * 活动是否收费 1：免费 2：收费  3: 支付
     */
    private Integer activityIsFree;

    /**
     * 活动收费标准
     */
    private String activityPrice;
    
    /**
     * 支付价格
     */
    private BigDecimal activityPayPrice;
    

    /**
     * 活动是否详情 1：是 2：否
     */
    private Integer activityIsDetails;

    /**
     * 是否预订 1：不可预定 2：在线选座 3：自由入座
     */
    private Integer activityIsReservation;

    /**
     * 活动可预订人数
     */
    private Integer activityReservationCount;

    /**
     * 活动开始时间
     */
    private String activityStartTime;

    /**
     * 活动结束时间
     */
    private String activityEndTime;

    /**
     * 是否删除 2：删除 1：未删除
     */
    private Integer activityIsDel;

    /**
     * 状态 1-草稿 2-已审核 3-退回 5-回收站6-已发布 7-未通过'
     */
    private Integer activityState;

    /**
     * 活动信息创建时间
     */
    private Date activityCreateTime;
    /**
     * 活动信息更新时间
     */
    private Date activityUpdateTime;
    /**
     * 活动信息创建人
     */
    private String activityCreateUser;

    /**
     * 活动信息更新人
     */
    private String activityUpdateUser;

    /**
     * 权限信息--部门标示
     */
    private String activityDept;

    //活动描述
    private String activityMemo;

    //活动详情内容
    private String activityContent;

    /**
     * 本周最新活动专用
     */
    private Integer weekBrowseCount;

    /**
     * 热点活动
     */
    private Integer yearBrowseCount;

    /**
     * 收藏量
     */
    private Integer yearCollectCount;

    /**
     * 创建人姓名
     */
    private String createUserName;

    private String maxDateTime;

    /**
     * 标签ids
     */
    private String tagIds;

    /**
     * 标签名称
     */
    private String tagName;

    /**
     * 场馆名称
     */
    private String venueName;

    /**
     * 场馆区域
     */
    private String venueArea;

    /**
     * 场馆类型
     */
    private String venueType;

    /**
     * 场馆id
     */
    private String venueId;

    /**
     * 是否推荐  Y 是  N 不是
     */
    private String activityRecommend;

    /**
     * 推荐人Id
     */
    private String activityRecommendUserId;

    private String activityTerminalUserId;

    private String userId;

    private String activityNotice;

    private String priceDescribe;

    private String dictName;
    /**
     * 评级信息
     */
    private String ratingsInfo;

    private String ticketSettings;

    private Integer ticketNumber;

    private Integer ticketCount;

    private String sysUserId;

    private String orderCheckUser;

    private Date orderCheckTime;

    private String orderSummary;

    /**
     * 用户账号
     */
    private String userAccount;

    private String userAccount2;    //后台显示更新人用

    private Date startTime;

    private Date endTime;

    private String venueDept;

    private String uploadType;

    //人群标签
    private String activityCrowd;

    //心情标签
    private String activityMood;

    //是否在线售票
    private String activitySalesOnline;

    private String orderNumber;

    //活动时间具体描述
    private String activityTimeDes;

    private Short orderPayStatus;

    private Date orderCreateTime;

    private String orderName;

    private String orderIsValid;

    private String activityOrderId;

    private String activityCount;

    private String activityLocation;

    private String sysId;

    private String sysNo;

    //场次开始时间断
    private String eventStartTimes;
    //场次结束时间断
    private String eventEndTimes;
    //活动剩余票数
    private Integer availableCount;
    //活动时间
    private String eventimes;
    //活动剩余天数
    private Integer dateNums;
    //活动是否被用户收藏
    private Integer collectNum;
    /**
     * 日期
     */
    private String eventDate;

    private String activityHost;

    private String activityOrganizer;

    private String activityCoorganizer;

    private String activityPerformed;

    private String activityPrompt;

    private String activitySpeaker;

    private Integer activityPersonal;

    private String activityRecommendUserid;

    private String activityAttachment;

    private Integer activityIsReserved;

    private Integer orderOrCollect;

    /**
     * 活动场次具体时间
     **/
    private String eventDateTimes;

    /**
     * 活动场次id
     **/
    private String eventIds;

    /**
     * 场次
     */
    private String eventTime;
    /*订单操作时间*/
    private Date orderUpdateTime;

    //自建活动编码 0省级自建活动,1市级自建活动,2区级自建活动
    private Integer createActivityCode;

    private Date activityRecommendTime;

    // 本地，测试服务器与公网场馆id切换专用 1-本地 2-测试 3-公网
    private Integer type;

    private Integer orderVotes;

    private String orderPhoneNo;

    /**
     * 后台搜索关键词
     */
    private String searchKey;

    /**
     * 判断活动是否过期
     */
    private String isOver;
    /**
     * 截取后的活动市
     **/
    private String city;
    /**
     * 截取后的活动区
     **/
    private String area;

    private String activityThemeTxt;

    private String recommendId;

    /*3.3活动主题可以手动输入*/
    private String activitySubject;

    /*活动地点*/
    private String activitySite;

    /*活动模板id*/
    private String templId;

    private String spikeTimes;

    private Integer identityCard;    //是否需要买票时添加身份证号 0：不需要   1：需要

    private Integer priceType;    //价格类型   0：XX元起  1:XX元/人

    private Integer lowestCredit;    //参与此活动用户拥有的最低积分

    private Integer costCredit;    //参与此活动消耗的积分数

    private Integer deductionCredit;        //没有核销将扣除的积分

    private Integer spikeType;    //是否是秒杀   0：非秒杀  1:秒杀

    private Integer singleEvent;    //是否是单场次活动 0：非单场次 1：单场次

    private String orderPrice;

    private String seatIds;

    private String avaliableCount;
    
    private String orderValidateCode;

    private String assnId;
    
    private Date cancelEndTime;
    
    /**
     * 活动信息发布时间
     */
    private Date PublicTime;

    private String sysUrl;

    private String endTimePoint;
    
    private Integer wantCount;
    
    List<CmsComment> commentList;
    
    private Integer commentCount;
    
    private Integer activitySmsType;	//短信模板类型（0：取票码入场；1：纸质票入场；2：入场凭证入场）
    
    private Integer activitySupplementType;//补充活动类型 1.不可预订 2.直接前往 3.电话预约
    
    private String activityCustomInfo;

    public String getSysUserId() {
        return sysUserId;
    }

    public void setSysUserId(String sysUserId) {
        this.sysUserId = sysUserId == null ? null : sysUserId.trim();
    }

    public String getOrderCheckUser() {
        return orderCheckUser;
    }

    public void setOrderCheckUser(String orderCheckUser) {
        this.orderCheckUser = orderCheckUser == null ? null : orderCheckUser.trim();
    }

    public Date getOrderCheckTime() {
        return orderCheckTime;
    }

    public void setOrderCheckTime(Date orderCheckTime) {
        this.orderCheckTime = orderCheckTime;
    }

    public String getTicketSettings() {
        return ticketSettings;
    }

    public void setTicketSettings(String ticketSettings) {
        this.ticketSettings = ticketSettings;
    }

    public Integer getTicketNumber() {
        return ticketNumber;
    }

    public void setTicketNumber(Integer ticketNumber) {
        this.ticketNumber = ticketNumber;
    }

    public Integer getTicketCount() {
        return ticketCount;
    }

    public void setTicketCount(Integer ticketCount) {
        this.ticketCount = ticketCount;
    }

    public String getRatingsInfo() {
        return ratingsInfo;
    }

    public void setRatingsInfo(String ratingsInfo) {
        this.ratingsInfo = ratingsInfo;
    }

    public String getDictName() {
        return dictName;
    }

    public void setDictName(String dictName) {
        this.dictName = dictName == null ? null : dictName.trim();
    }

    public String getTagColor() {
        return tagColor;
    }

    public void setTagColor(String tagColor) {
        this.tagColor = tagColor;
    }

    public String getTagInitial() {
        return tagInitial;
    }

    public void setTagInitial(String tagInitial) {
        this.tagInitial = tagInitial;
    }

    public String getFunName() {
        return funName;
    }

    public void setFunName(String funName) {
        this.funName = funName;
    }

    public String getTagName() {
        return tagName;
    }

    public void setTagName(String tagName) {
        this.tagName = tagName == null ? null : tagName.trim();
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId == null ? null : userId.trim();
    }

    public String getMaxDateTime() {
        return maxDateTime;
    }

    public void setMaxDateTime(String maxDateTime) {
        this.maxDateTime = maxDateTime;
    }

    public Integer getOrderOrCollect() {
        return orderOrCollect;
    }

    public void setOrderOrCollect(Integer orderOrCollect) {
        this.orderOrCollect = orderOrCollect;
    }

    public Integer getActivityIsReserved() {
        return activityIsReserved;
    }

    public void setActivityIsReserved(Integer activityIsReserved) {
        this.activityIsReserved = activityIsReserved;
    }

    public String getRecommendId() {
        return recommendId;
    }

    public void setRecommendId(String recommendId) {
        this.recommendId = recommendId == null ? null : recommendId.trim();
    }

    public String getActivityThemeTxt() {
        return activityThemeTxt;
    }

    public void setActivityThemeTxt(String activityThemeTxt) {
        this.activityThemeTxt = activityThemeTxt == null ? null : activityThemeTxt.trim();
    }

    public String getArea() {
        return area;
    }

    public void setArea(String area) {
        this.area = area;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getOrderPhoneNo() {
        return orderPhoneNo;
    }

    public void setOrderPhoneNo(String orderPhoneNo) {
        this.orderPhoneNo = orderPhoneNo;
    }


    public String getActivityTerminalUserId() {
        return activityTerminalUserId;
    }

    public void setActivityTerminalUserId(String activityTerminalUserId) {
        this.activityTerminalUserId = activityTerminalUserId;
    }

    public void setOrderVotes(Integer orderVotes) {
        this.orderVotes = orderVotes;
    }

    public Integer getOrderVotes() {
        return orderVotes;
    }

    public String getActivityAttachment() {
        return activityAttachment;
    }

    public void setActivityAttachment(String activityAttachment) {
        this.activityAttachment = activityAttachment;
    }

    public String getActivityCoorganizer() {
        return activityCoorganizer;
    }

    public void setActivityCoorganizer(String activityCoorganizer) {
        this.activityCoorganizer = activityCoorganizer;
    }

    public String getActivityHost() {
        return activityHost;
    }

    public void setActivityHost(String activityHost) {
        this.activityHost = activityHost;
    }

    public String getActivityOrganizer() {
        return activityOrganizer;
    }

    public void setActivityOrganizer(String activityOrganizer) {
        this.activityOrganizer = activityOrganizer;
    }

    public String getActivityPerformed() {
        return activityPerformed;
    }

    public void setActivityPerformed(String activityPerformed) {
        this.activityPerformed = activityPerformed;
    }

    public Integer getActivityPersonal() {
        return activityPersonal;
    }

    public void setActivityPersonal(Integer activityPersonal) {
        this.activityPersonal = activityPersonal;
    }

    public String getActivityPrompt() {
        return activityPrompt;
    }

    public void setActivityPrompt(String activityPrompt) {
        this.activityPrompt = activityPrompt;
    }

    public String getActivityRecommendUserid() {
        return activityRecommendUserid;
    }

    public void setActivityRecommendUserid(String activityRecommendUserid) {
        this.activityRecommendUserid = activityRecommendUserid;
    }

    public String getActivitySpeaker() {
        return activitySpeaker;
    }

    public void setActivitySpeaker(String activitySpeaker) {
        this.activitySpeaker = activitySpeaker;
    }

    public String getEventDateTimes() {
        return eventDateTimes;
    }

    public void setEventDateTimes(String eventDateTimes) {
        this.eventDateTimes = eventDateTimes;
    }

    public String getEventIds() {
        return eventIds;
    }

    public void setEventIds(String eventIds) {
        this.eventIds = eventIds;
    }

    public Integer getDateNums() {
        return dateNums;
    }

    public void setDateNums(Integer dateNums) {
        this.dateNums = dateNums;
    }

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }

    public Date getActivityRecommendTime() {
        return activityRecommendTime;
    }

    public void setActivityRecommendTime(Date activityRecommendTime) {
        this.activityRecommendTime = activityRecommendTime;
    }

    public Date getOrderUpdateTime() {
        return orderUpdateTime;
    }

    public void setOrderUpdateTime(Date orderUpdateTime) {
        this.orderUpdateTime = orderUpdateTime;
    }

    public Integer getCollectNum() {
        return collectNum != null ? collectNum : 0;
    }

    public void setCollectNum(Integer collectNum) {
        this.collectNum = collectNum;
    }


    public String getEventimes() {
        return eventimes;
    }

    public void setEventimes(String eventimes) {
        this.eventimes = eventimes;
    }

    //每个场次的可以预定的座位数量
    private Integer eventCount;

    public Integer getEventCount() {
        return eventCount;
    }

    public void setEventCount(Integer eventCount) {
        this.eventCount = eventCount;
    }

    public Integer getAvailableCount() {
        return availableCount;
    }

    public void setAvailableCount(Integer availableCount) {
        this.availableCount = availableCount;
    }


    public String getEventStartTimes() {
        return eventStartTimes;
    }

    public void setEventStartTimes(String eventStartTimes) {
        this.eventStartTimes = eventStartTimes;
    }

    public String getEventEndTimes() {
        return eventEndTimes;
    }

    public void setEventEndTimes(String eventEndTimes) {
        this.eventEndTimes = eventEndTimes;
    }

    public String getActivityLocation() {
        return activityLocation;
    }

    public void setActivityLocation(String activityLocation) {
        this.activityLocation = activityLocation;
    }

    public String getActivityCount() {
        return activityCount;
    }

    public void setActivityCount(String activityCount) {
        this.activityCount = activityCount;
    }

    public String getActivityOrderId() {
        return activityOrderId;
    }

    public void setActivityOrderId(String activityOrderId) {
        this.activityOrderId = activityOrderId;
    }

    public String getOrderIsValid() {
        return orderIsValid;
    }

    public void setOrderIsValid(String orderIsValid) {
        this.orderIsValid = orderIsValid;
    }

    public String getOrderName() {
        return orderName;
    }

    public void setOrderName(String orderName) {
        this.orderName = orderName;
    }

    public Date getOrderCreateTime() {
        return orderCreateTime;
    }

    public void setOrderCreateTime(Date orderCreateTime) {
        this.orderCreateTime = orderCreateTime;
    }

    public String getActivityTimeDes() {
        return activityTimeDes;
    }

    public void setActivityTimeDes(String activityTimeDes) {
        this.activityTimeDes = activityTimeDes;
    }

    public String getActivityMood() {
        return activityMood;
    }

    public void setActivityMood(String activityMood) {
        this.activityMood = activityMood;
    }

    public String getActivityCrowd() {
        return activityCrowd;
    }

    public void setActivityCrowd(String activityCrowd) {
        this.activityCrowd = activityCrowd;
    }


    public Integer getYearCollectCount() {
        return yearCollectCount;
    }

    public void setYearCollectCount(Integer yearCollectCount) {
        this.yearCollectCount = yearCollectCount;
    }

    public String getActivitySalesOnline() {
        return activitySalesOnline;
    }

    public void setActivitySalesOnline(String activitySalesOnline) {
        this.activitySalesOnline = activitySalesOnline;
    }

    public String getActivityRecommend() {
        return activityRecommend;
    }

    public void setActivityRecommend(String activityRecommend) {
        this.activityRecommend = activityRecommend;
    }

    public String getActivityRecommendUserId() {
        return activityRecommendUserId;
    }

    public void setActivityRecommendUserId(String activityRecommendUserId) {
        this.activityRecommendUserId = activityRecommendUserId;
    }

    public String getUploadType() {
        return uploadType;
    }

    public void setUploadType(String uploadType) {
        this.uploadType = uploadType;
    }

    public String getVenueDept() {
        return venueDept;
    }

    public void setVenueDept(String venueDept) {
        this.venueDept = venueDept;
    }


    public String getUserAccount() {
        return userAccount;
    }

    public void setUserAccount(String userAccount) {
        this.userAccount = userAccount;
    }

    public String getVenueArea() {
        return venueArea;
    }

    public void setVenueArea(String venueArea) {
        this.venueArea = venueArea;
    }

    public String getVenueType() {
        return venueType;
    }

    public void setVenueType(String venueType) {
        this.venueType = venueType;
    }

    public String getVenueName() {
        return venueName;
    }

    public void setVenueName(String venueName) {
        this.venueName = venueName;
    }

    public void setYearBrowseCount(Integer yearBrowseCount) {
        this.yearBrowseCount = yearBrowseCount;
    }

    public String getTagIds() {
        return tagIds;
    }

    public void setTagIds(String tagIds) {
        this.tagIds = tagIds;
    }

    public String getVenueId() {
        return venueId;
    }

    public void setVenueId(String venueId) {
        this.venueId = venueId;
    }

    public String getCreateUserName() {
        return createUserName;
    }

    public void setCreateUserName(String createUserName) {
        this.createUserName = createUserName;
    }

    public Date getStartTime() {
        return startTime;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    public Date getEndTime() {
        return endTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    public Integer getWeekBrowseCount() {
        return weekBrowseCount;
    }

    public void setWeekBrowseCount(Integer weekBrowseCount) {
        this.weekBrowseCount = weekBrowseCount;
    }

    public Integer getYearBrowseCount() {
        return yearBrowseCount;
    }

    public void setMonthBrowseCount(Integer yearBrowseCount) {
        this.yearBrowseCount = yearBrowseCount;
    }

    public String getActivityId() {
        return activityId;
    }

    public void setActivityId(String activityId) {
        this.activityId = activityId == null ? null : activityId.trim();
    }

    public String getActivityName() {
        return activityName;
    }

    public void setActivityName(String activityName) {
        this.activityName = activityName == null ? null : activityName.trim();
    }

    public String getActivityLinkman() {
        return activityLinkman;
    }

    public void setActivityLinkman(String activityLinkman) {
        this.activityLinkman = activityLinkman == null ? null : activityLinkman.trim();
    }

    public String getActivityType() {
        return activityType;
    }

    public void setActivityType(String activityType) {
        this.activityType = activityType == null ? null : activityType.trim();
    }

    public String getActivityTel() {
        return activityTel;
    }

    public void setActivityTel(String activityTel) {
        this.activityTel = activityTel == null ? null : activityTel.trim();
    }



    public String getActivityVideoURL() {
        return activityVideoURL;
    }

    public void setActivityVideoURL(String activityVideoURL) {
        this.activityVideoURL = activityVideoURL == null ? null : activityVideoURL.trim();
    }

    public String getActivityIconUrl() {
        return activityIconUrl;
    }

    public void setActivityIconUrl(String activityIconUrl) {
        this.activityIconUrl = activityIconUrl == null ? null : activityIconUrl.trim();
    }

    public String getActivityProvince() {
        return activityProvince;
    }

    public void setActivityProvince(String activityProvince) {
        this.activityProvince = activityProvince == null ? null : activityProvince.trim();
    }

    public String getActivityCity() {
        return activityCity;
    }

    public void setActivityCity(String activityCity) {
        this.activityCity = activityCity == null ? null : activityCity.trim();
    }

    public String getActivityArea() {
        return activityArea;
    }

    public void setActivityArea(String activityArea) {
        this.activityArea = activityArea == null ? null : activityArea.trim();
    }

    public String getActivityAddress() {
        return activityAddress;
    }

    public void setActivityAddress(String activityAddress) {
        this.activityAddress = activityAddress == null ? null : activityAddress.trim();
    }

    public Double getActivityLon() {
        return activityLon;
    }

    public void setActivityLon(Double activityLon) {
        this.activityLon = activityLon;
    }

    public Double getActivityLat() {
        return activityLat;
    }

    public void setActivityLat(Double activityLat) {
        this.activityLat = activityLat;
    }

    public String getActivityTime() {
        return activityTime;
    }

    public void setActivityTime(String activityTime) {
        this.activityTime = activityTime == null ? null : activityTime.trim();
    }

    public Integer getActivityIsFree() {
        return activityIsFree;
    }

    public void setActivityIsFree(Integer activityIsFree) {
        this.activityIsFree = activityIsFree;
    }

    public String getActivityPrice() {
        return activityPrice;
    }

    public void setActivityPrice(String activityPrice) {
        this.activityPrice = activityPrice == null ? null : activityPrice.trim();
    }

    public Integer getActivityIsDetails() {
        return activityIsDetails;
    }

    public void setActivityIsDetails(Integer activityIsDetails) {
        this.activityIsDetails = activityIsDetails;
    }

    public Integer getActivityIsReservation() {
        return activityIsReservation;
    }

    public void setActivityIsReservation(Integer activityIsReservation) {
        this.activityIsReservation = activityIsReservation;
    }

    public Integer getActivityReservationCount() {
        return activityReservationCount;
    }

    public void setActivityReservationCount(Integer activityReservationCount) {
        this.activityReservationCount = activityReservationCount;
    }

    public String getActivityStartTime() {
        return activityStartTime;
    }

    public void setActivityStartTime(String activityStartTime) {
        this.activityStartTime = activityStartTime == null ? null : activityStartTime.trim();
    }

    public String getActivityEndTime() {
        return activityEndTime;
    }

    public void setActivityEndTime(String activityEndTime) {
        this.activityEndTime = activityEndTime == null ? null : activityEndTime.trim();
    }

    public Integer getActivityIsDel() {
        return activityIsDel;
    }

    public void setActivityIsDel(Integer activityIsDel) {
        this.activityIsDel = activityIsDel;
    }

    public Integer getActivityState() {
        return activityState;
    }

    public void setActivityState(Integer activityState) {
        this.activityState = activityState;
    }

    public Date getActivityCreateTime() {
        return activityCreateTime;
    }

    public void setActivityCreateTime(Date activityCreateTime) {
        this.activityCreateTime = activityCreateTime;
    }

    public Date getActivityUpdateTime() {
        return activityUpdateTime;
    }

    public void setActivityUpdateTime(Date activityUpdateTime) {
        this.activityUpdateTime = activityUpdateTime;
    }

    public String getActivityCreateUser() {
        return activityCreateUser;
    }

    public void setActivityCreateUser(String activityCreateUser) {
        this.activityCreateUser = activityCreateUser == null ? null : activityCreateUser.trim();
    }

    public String getActivityUpdateUser() {
        return activityUpdateUser;
    }

    public void setActivityUpdateUser(String activityUpdateUser) {
        this.activityUpdateUser = activityUpdateUser == null ? null : activityUpdateUser.trim();
    }

    public String getActivityDept() {
        return activityDept;
    }

    public void setActivityDept(String activityDept) {
        this.activityDept = activityDept == null ? null : activityDept.trim();
    }

    public String getActivityMemo() {
        return activityMemo;
    }

    public void setActivityMemo(String activityMemo) {
        this.activityMemo = activityMemo == null ? null : activityMemo.trim();
    }

    public String getActivityContent() {
        return activityContent;
    }

    public void setActivityContent(String activityContent) {
        this.activityContent = activityContent == null ? null : activityContent.trim();
    }

    public String getOrderNumber() {
        return orderNumber;
    }

    public void setOrderNumber(String orderNumber) {
        this.orderNumber = orderNumber;
    }

    public Short getOrderPayStatus() {
        return orderPayStatus;
    }

    public void setOrderPayStatus(Short orderPayStatus) {
        this.orderPayStatus = orderPayStatus;
    }

    public Integer getActivityIsFriends() {
        return activityIsFriends;
    }

    public void setActivityIsFriends(Integer activityIsFriends) {
        this.activityIsFriends = activityIsFriends;
    }

    public Integer getActivityIsCouples() {
        return activityIsCouples;
    }

    public void setActivityIsCouples(Integer activityIsCouples) {
        this.activityIsCouples = activityIsCouples;
    }

    public Integer getActivityIsChild() {
        return activityIsChild;
    }

    public void setActivityIsChild(Integer activityIsChild) {
        this.activityIsChild = activityIsChild;
    }

    public Integer getActivityIsElderly() {
        return activityIsElderly;
    }

    public void setActivityIsElderly(Integer activityIsElderly) {
        this.activityIsElderly = activityIsElderly;
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

    public String getEventDate() {
        return eventDate;
    }

    public void setEventDate(String eventDate) {
        this.eventDate = eventDate;
    }

    /**
     * 用户与活动之间的距离
     **/
    private Double distance;

    public Double getDistance() {
        return distance;
    }

    public void setDistance(Double distance) {
        this.distance = distance;
    }

    /**
     * 标签图片
     **/
    private String tagImageUrl;

    public String getTagImageUrl() {
        return tagImageUrl;
    }

    public void setTagImageUrl(String tagImageUrl) {
        this.tagImageUrl = tagImageUrl;
    }

    /**
     * 标签id
     **/
    private String tagId;

    public String getTagId() {
        return tagId;
    }

    public void setTagId(String tagId) {
        this.tagId = tagId;
    }

    /**
     * 该标签下活动数目
     **/
    private int tagNums;

    public int getTagNums() {
        return tagNums;
    }

    public void setTagNums(int tagNums) {
        this.tagNums = tagNums;
    }

    public int getActivityIsWant() {
        return activityIsWant;
    }

    public void setActivityIsWant(int activityIsWant) {
        this.activityIsWant = activityIsWant;
    }

    /**
     * 用户是否参加该活动
     **/
    private int activityIsWant;
    /**
     * 活动热门与新的区别
     **/
    private int hours;

    public int getHours() {
        return hours;
    }

    public void setHours(int hours) {
        this.hours = hours;
    }

    /**
     * 活动是否推荐
     **/
    private int recommendNum;

    public int getRecommendNum() {
        return recommendNum;
    }

    public void setRecommendNum(int recommendNum) {
        this.recommendNum = recommendNum;
    }


    public String getEventTime() {
        return eventTime;
    }

    public void setEventTime(String eventTime) {
        this.eventTime = eventTime;
    }

    public Integer getCreateActivityCode() {
        return createActivityCode;
    }

    public void setCreateActivityCode(Integer createActivityCode) {
        this.createActivityCode = createActivityCode;
    }

    public String getSearchKey() {
        return searchKey;
    }

    public void setSearchKey(String searchKey) {
        this.searchKey = searchKey;
    }

    public String getIsOver() {
        return isOver;
    }

    public void setIsOver(String isOver) {
        this.isOver = isOver;
    }

    public String getActivityTheme() {
        return activityTheme;
    }

    public void setActivityTheme(String activityTheme) {
        this.activityTheme = activityTheme;
    }

    public String getUserAccount2() {
        return userAccount2;
    }

    public void setUserAccount2(String userAccount2) {
        this.userAccount2 = userAccount2;
    }

    public String getActivitySubject() {
        return activitySubject;
    }

    public void setActivitySubject(String activitySubject) {
        this.activitySubject = activitySubject;
    }

    public String getTemplId() {
        return templId;
    }

    public void setTemplId(String templId) {
        this.templId = templId;
    }

    public String getActivitySite() {
        return activitySite;
    }

    public void setActivitySite(String activitySite) {
        this.activitySite = activitySite;
    }

    public String getActivityNotice() {
        return activityNotice;
    }

    public void setActivityNotice(String activityNotice) {
        this.activityNotice = activityNotice;
    }

    public String getPriceDescribe() {
        return priceDescribe;
    }

    public void setPriceDescribe(String priceDescribe) {
        this.priceDescribe = priceDescribe;
    }

    public String getOrderSummary() {
        return orderSummary;
    }

    public void setOrderSummary(String orderSummary) {
        this.orderSummary = orderSummary;
    }

    public Integer getIdentityCard() {
        return identityCard;
    }

    public void setIdentityCard(Integer identityCard) {
        this.identityCard = identityCard;
    }

    public Integer getPriceType() {
        return priceType;
    }

    public void setPriceType(Integer priceType) {
        this.priceType = priceType;
    }

    public Integer getLowestCredit() {
        return lowestCredit;
    }

    public void setLowestCredit(Integer lowestCredit) {
        this.lowestCredit = lowestCredit;
    }

    public Integer getCostCredit() {
        return costCredit;
    }

    public void setCostCredit(Integer costCredit) {
        this.costCredit = costCredit;
    }

    public Integer getDeductionCredit() {
        return deductionCredit;
    }

    public void setDeductionCredit(Integer deductionCredit) {
        this.deductionCredit = deductionCredit;
    }

    public Integer getSpikeType() {
        return spikeType;
    }

    public void setSpikeType(Integer spikeType) {
        this.spikeType = spikeType;
    }

    public Integer getSingleEvent() {
        return singleEvent;
    }

    public void setSingleEvent(Integer singleEvent) {
        this.singleEvent = singleEvent;
    }

    public String getSpikeTimes() {
        return spikeTimes;
    }

    public void setSpikeTimes(String spikeTimes) {
        this.spikeTimes = spikeTimes;
    }

    public String getOrderPrice() {
        return orderPrice;
    }

    public void setOrderPrice(String orderPrice) {
        this.orderPrice = orderPrice;
    }

    public String getSeatIds() {
        return seatIds;
    }

    public void setSeatIds(String seatIds) {
        this.seatIds = seatIds;
    }

    public String getAvaliableCount() {
        return avaliableCount;
    }

    public void setAvaliableCount(String avaliableCount) {
        this.avaliableCount = avaliableCount;
    }

    public Date getPublicTime() {
        return PublicTime;
    }

    public void setPublicTime(Date publicTime) {
        PublicTime = publicTime;
    }

    public String getAddressId() {
        return addressId;
    }

    public void setAddressId(String addressId) {
        this.addressId = addressId;
    }

	public String getOrderValidateCode() {
		return orderValidateCode;
	}

	public void setOrderValidateCode(String orderValidateCode) {
		this.orderValidateCode = orderValidateCode;
	}

	public String getAssnId() {
		return assnId;
	}

	public void setAssnId(String assnId) {
		this.assnId = assnId;
	}


    public String getSysUrl() {
        return sysUrl;
    }

    public void setSysUrl(String sysUrl) {
        this.sysUrl = sysUrl;
    }

    public String getEndTimePoint() {
        return endTimePoint;
    }

    public void setEndTimePoint(String endTimePoint) {
        this.endTimePoint = endTimePoint;
    }

	public Integer getWantCount() {
		return wantCount;
	}

	public void setWantCount(Integer wantCount) {
		this.wantCount = wantCount;
	}

	public List<CmsComment> getCommentList() {
		return commentList;
	}

	public void setCommentList(List<CmsComment> commentList) {
		this.commentList = commentList;
	}

	public Integer getCommentCount() {
		return commentCount;
	}

	public void setCommentCount(Integer commentCount) {
		this.commentCount = commentCount;
	}

	public BigDecimal getActivityPayPrice() {
		return activityPayPrice;
	}

	public void setActivityPayPrice(BigDecimal activityPayPrice) {
		this.activityPayPrice = activityPayPrice;
	}

	public Integer getActivitySmsType() {
		return activitySmsType;
	}

	public void setActivitySmsType(Integer activitySmsType) {
		this.activitySmsType = activitySmsType;
	}

	public Integer getActivitySupplementType() {
		return activitySupplementType;
	}

	public void setActivitySupplementType(Integer activitySupplementType) {
		this.activitySupplementType = activitySupplementType;
	}

	public String getActivityCustomInfo() {
		return activityCustomInfo;
	}

	public void setActivityCustomInfo(String activityCustomInfo) {
		this.activityCustomInfo = activityCustomInfo;
	}

	public Date getCancelEndTime() {
		return cancelEndTime;
	}

	public void setCancelEndTime(Date cancelEndTime) {
		this.cancelEndTime = cancelEndTime;
	}
	
	
}