package com.culturecloud.dao.dto.activity;

import java.util.Date;
import java.util.List;

public class ActivityVO {

	private String activityId;

    private String activityName;

    private String activityType;

    private String activityTel;

    private String activityMemo;

    private String activityIconUrl;

    private String activityProvince;

    private String activityCity;

    private String activityArea;

    private String activityTown;

    private String activityVillage;

    private String activityAddress;

    private Double activityLon;

    private Double activityLat;

    private String activityTime;

    private Integer activityIsFree;

    private String activityPrice;

    private Integer activityIsReservation;

    private Integer activityReservationCount;

    private String activityStartTime;

    private String activityEndTime;
  
    private String activityCreateTime;

    private String activityUpdateTime;

    private String activityCreateUser;

    private String activityUpdateUser;

    private String activityTimeDes;

    private Integer createActivityCode;

    private Integer eventCount;

    private String activityHost;

    private String activityOrganizer;

    private String activityCoorganizer;

    private String activityPerformed;

    private String activitySpeaker;

    private String activitySite;

    private String activityNotice;

    private String priceDescribe;

    private Integer ticketNumber;

    private Integer ticketCount;

    private Date publicTime;

    private Integer identityCard;

    private Integer priceType;

    private Integer lowestCredit;

    private Integer costCredit;

    private Integer deductionCredit;

    private Integer spikeType;

    private Integer singleEvent;

    private List<ActivityEventVO> activityEvents;
    
    /*
      private String activityLinkman;
      private Integer activityIsDel;
      private Integer activityIsDetails;
      private String activityContent;
      private Integer activityState;
      private String activityDept;
      private String activityRecommend;
      private String activitySalesOnline;
      private String activityLocation;
      private String sysId;
      private String sysNo;
      private String sysUrl;
      private Date activityRecommendTime;
      private String activityPrompt;
      private String activityAttachment;
      private Integer activityPersonal;
      private String activityRecommendUserid;
      private String activityTheme;
      private String activityTerminalUserId;
      private String templId;
      private String activitySubject;
      private String ratingsInfo;
      private String ticketSettings;
      private String assnId;
      private String endTimePoint;
      private Integer activitySort;
      private Integer activityIsTop;
      private Date topTime;
      private String activityVideoUrl;
      private String activityMood;
      private String activityCrowd;
      private String joinMethod;
      private Integer activitySmsType;
      private BigDecimal activityPayPrice;
      private Integer activitySupplementType;
     */

	public String getActivityId() {
		return activityId;
	}

	public void setActivityId(String activityId) {
		this.activityId = activityId;
	}

	public String getActivityName() {
		return activityName;
	}

	public void setActivityName(String activityName) {
		this.activityName = activityName;
	}

	public String getActivityType() {
		return activityType;
	}

	public void setActivityType(String activityType) {
		this.activityType = activityType;
	}

	public String getActivityTel() {
		return activityTel;
	}

	public void setActivityTel(String activityTel) {
		this.activityTel = activityTel;
	}

	public String getActivityMemo() {
		return activityMemo;
	}

	public void setActivityMemo(String activityMemo) {
		this.activityMemo = activityMemo;
	}

	public String getActivityIconUrl() {
		return activityIconUrl;
	}

	public void setActivityIconUrl(String activityIconUrl) {
		this.activityIconUrl = activityIconUrl;
	}

	public String getActivityProvince() {
		return activityProvince;
	}

	public void setActivityProvince(String activityProvince) {
		this.activityProvince = activityProvince;
	}

	public String getActivityCity() {
		return activityCity;
	}

	public void setActivityCity(String activityCity) {
		this.activityCity = activityCity;
	}

	public String getActivityArea() {
		return activityArea;
	}

	public void setActivityArea(String activityArea) {
		this.activityArea = activityArea;
	}

	public String getActivityTown() {
		return activityTown;
	}

	public void setActivityTown(String activityTown) {
		this.activityTown = activityTown;
	}

	public String getActivityVillage() {
		return activityVillage;
	}

	public void setActivityVillage(String activityVillage) {
		this.activityVillage = activityVillage;
	}

	public String getActivityAddress() {
		return activityAddress;
	}

	public void setActivityAddress(String activityAddress) {
		this.activityAddress = activityAddress;
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
		this.activityTime = activityTime;
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
		this.activityPrice = activityPrice;
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
		this.activityStartTime = activityStartTime;
	}

	public String getActivityEndTime() {
		return activityEndTime;
	}

	public void setActivityEndTime(String activityEndTime) {
		this.activityEndTime = activityEndTime;
	}
	

	public String getActivityCreateUser() {
		return activityCreateUser;
	}

	public void setActivityCreateUser(String activityCreateUser) {
		this.activityCreateUser = activityCreateUser;
	}

	public String getActivityUpdateUser() {
		return activityUpdateUser;
	}

	public void setActivityUpdateUser(String activityUpdateUser) {
		this.activityUpdateUser = activityUpdateUser;
	}

	public String getActivityTimeDes() {
		return activityTimeDes;
	}

	public void setActivityTimeDes(String activityTimeDes) {
		this.activityTimeDes = activityTimeDes;
	}

	public Integer getCreateActivityCode() {
		return createActivityCode;
	}

	public void setCreateActivityCode(Integer createActivityCode) {
		this.createActivityCode = createActivityCode;
	}

	public Integer getEventCount() {
		return eventCount;
	}

	public void setEventCount(Integer eventCount) {
		this.eventCount = eventCount;
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

	public String getActivityCoorganizer() {
		return activityCoorganizer;
	}

	public void setActivityCoorganizer(String activityCoorganizer) {
		this.activityCoorganizer = activityCoorganizer;
	}

	public String getActivityPerformed() {
		return activityPerformed;
	}

	public void setActivityPerformed(String activityPerformed) {
		this.activityPerformed = activityPerformed;
	}

	public String getActivitySpeaker() {
		return activitySpeaker;
	}

	public void setActivitySpeaker(String activitySpeaker) {
		this.activitySpeaker = activitySpeaker;
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

	public Date getPublicTime() {
		return publicTime;
	}

	public void setPublicTime(Date publicTime) {
		this.publicTime = publicTime;
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

	public String getActivityCreateTime() {
		return activityCreateTime;
	}

	public void setActivityCreateTime(String activityCreateTime) {
		this.activityCreateTime = activityCreateTime;
	}

	public String getActivityUpdateTime() {
		return activityUpdateTime;
	}

	public void setActivityUpdateTime(String activityUpdateTime) {
		this.activityUpdateTime = activityUpdateTime;
	}

	public List<ActivityEventVO> getActivityEvents() {
		return activityEvents;
	}

	public void setActivityEvents(List<ActivityEventVO> activityEvents) {
		this.activityEvents = activityEvents;
	}
    
}
