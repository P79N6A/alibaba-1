package com.culturecloud.model.bean.activity;

import java.math.BigDecimal;
import java.util.Date;

import javax.persistence.Column;

import com.culturecloud.annotations.Id;
import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;

@Table(value="cms_activity")
public class CmsActivity implements BaseEntity{

	private static final long serialVersionUID = -3586841584989510841L;
	
	@Id
	@Column(name="ACTIVITY_ID")
	private String activityId;

	
	@Column(name="ACTIVITY_NAME")
	private String activityName;

	
	@Column(name="ACTIVITY_LINKMAN")
	private String activityLinkman;
	
	
	@Column(name="ACTIVITY_TEL")
	private String activityTel;


	@Column(name="ACTIVITY_ICON_URL")
	private String activityIconUrl;

	@Column(name="ACTIVITY_PROVINCE")
	private String activityProvince;

	@Column(name="ACTIVITY_CITY")
	private String activityCity;

	@Column(name="ACTIVITY_AREA")
	private String activityArea;

	@Column(name="ACTIVITY_ADDRESS")
	private String activityAddress;

	@Column(name="ACTIVITY_LON")
	private Double activityLon;

	@Column(name="ACTIVITY_LAT")
	private Double activityLat;

	@Column(name="ACTIVITY_TIME")
	private String activityTime;

	@Column(name="ACTIVITY_IS_FREE")
	private Integer activityIsFree;

	@Column(name="ACTIVITY_PRICE")
	private String activityPrice;
	
	@Column(name="ACTIVITY_PAY_PRICE")
	private BigDecimal activityPayPrice;
	/**
	 * 娲诲姩鏄惁鏈夎鎯呭瓧娈碉紝璇︽儏涓哄繀濉」銆�
	 */
	@Deprecated
	@Column(name="ACTIVITY_IS_DETAILS")
	private Integer activityIsDetails;

	@Column(name="ACTIVITY_IS_RESERVATION")
	private Integer activityIsReservation;

	@Column(name="ACTIVITY_RESERVATION_COUNT")
	private Integer activityReservationCount;

	@Column(name="ACTIVITY_START_TIME")
	private String activityStartTime;

	@Column(name="ACTIVITY_END_TIME")
	private String activityEndTime;

	@Column(name="ACTIVITY_IS_DEL")
	private Integer activityIsDel;

	@Column(name="ACTIVITY_STATE")
	private Integer activityState;

	@Column(name="ACTIVITY_CREATE_TIME")
	private Date activityCreateTime;

	@Column(name="ACTIVITY_UPDATE_TIME")
	private Date activityUpdateTime;

	@Column(name="ACTIVITY_CREATE_USER")
	private String activityCreateUser;

	@Column(name="ACTIVITY_UPDATE_USER")
	private String activityUpdateUser;

	@Column(name="ACTIVITY_RECOMMEND")
	private String activityRecommend;

	@Column(name="ACTIVITY_SALES_ONLINE")
	private String activitySalesOnline;

	@Column(name="ACTIVITY_TIME_DES")
	private String activityTimeDes;
	
	/**
	 * 娲诲姩浣嶇疆瀛楁锛岄渶姹備腑鍒犳帀銆�
	 */
	@Deprecated
	@Column(name="ACTIVITY_LOCATION")
	private String activityLocation;

	@Column(name="SYS_ID")
	private String sysId;

	@Column(name="SYS_NO")
	private String sysNo;


	@Column(name="CREATE_ACTIVITY_CODE")
	private Integer createActivityCode;
	
	/**
	 * 鍦烘绁ㄥ姟瀛樺湪鍦烘淇℃伅涓��
	 */
	@Deprecated
	@Column(name="EVENT_COUNT")
	private Integer eventCount;

	@Column(name="ACTIVITY_RECOMMEND_TIME")
	private Date activityRecommendTime;

	@Column(name="ACTIVITY_HOST")
	private String activityHost;

	@Column(name="ACTIVITY_ORGANIZER")
	private String activityOrganizer;

	@Column(name="ACTIVITY_COORGANIZER")
	private String activityCoorganizer;

	@Column(name="ACTIVITY_PERFORMED")
	private String activityPerformed;

	@Column(name="ACTIVITY_PROMPT")
	private String activityPrompt;

	@Column(name="ACTIVITY_SPEAKER")
	private String activitySpeaker;
	
	/**
	 * 浜у搧闇�姹傚垹鎺夛紝涓嶅啀瀛樺湪涓汉娲诲姩銆�
	 */
	@Deprecated
	@Column(name="ACTIVITY_PERSONAL")
	private Integer activityPersonal;

	@Column(name="ACTIVITY_RECOMMEND_USERID")
	private String activityRecommendUserid;
	/**
	 * 浜у搧闇�姹傚垹鎺夛紝涓嶅啀瀛樺湪涓汉娲诲姩銆�
	 */
	@Deprecated
	@Column(name="ACTIVITY_TERMINAL_USER_ID")
	private String activityTerminalUserId;
	
	/**
	 * 妯℃澘ID锛屾ā鏉跨郴缁熷凡搴熼櫎銆�
	 */
	@Deprecated
	@Column(name="TEMPL_ID")
	private String templId;

	@Column(name="ACTIVITY_SITE")
	private String activitySite;

	@Column(name="ACTIVITY_SUBJECT")
	private String activitySubject;

	@Column(name="PRICE_DESCRIBE")
	private String priceDescribe;

	@Column(name="RATINGS_INFO")
	private String ratingsInfo;

	@Column(name="TICKET_SETTINGS")
	private String ticketSettings;

	@Column(name="TICKET_NUMBER")
	private Integer ticketNumber;

	@Column(name="TICKET_COUNT")
	private Integer ticketCount;

	@Column(name="PUBLIC_TIME")
	private Date publicTime;

	@Column(name="IDENTITY_CARD")
	private Integer identityCard;

	@Column(name="PRICE_TYPE")
	private Integer priceType;

	@Column(name="LOWEST_CREDIT")
	private Integer lowestCredit;

	@Column(name="COST_CREDIT")
	private Integer costCredit;

	@Column(name="DEDUCTION_CREDIT")
	private Integer deductionCredit;

	@Column(name="SPIKE_TYPE")
	private Integer spikeType;

	@Column(name="SINGLE_EVENT")
	private Integer singleEvent;

	@Column(name="ASSN_ID")
	private String assnId;

	@Column(name="ACTIVITY_TYPE")
	private String activityType;

	@Column(name="ACTIVITY_MEMO")
	private String activityMemo;

	@Column(name="ACTIVITY_CONTENT")
	private String activityContent;

	@Column(name="ACTIVITY_DEPT")
	private String activityDept;


	@Column(name="ACTIVITY_THEME")
	private String activityTheme;

	@Column(name="ACTIVITY_NOTICE")
	private String activityNotice;

	@Column(name="END_TIME_POINT")
	private String endTimePoint;

	@Column(name="SYS_URL")
	private String SysUrl;
	
	@Column(name="ACTIVITY_ATTACHMENT")
	private String activityAttachment;
	
	@Column(name="ACTIVITY_SMS_TYPE")
	private Integer activitySmsType;	//短信模板类型（0：取票码入场；1：纸质票入场；2：入场凭证入场）
	
	@Column(name="ACTIVITY_SUPPLEMENT_TYPE")
	private Integer activitySupplementType;
	
	@Column(name="ACTIVITY_CUSTOM_INFO")
	private String activityCustomInfo;
	
	@Column(name="CANCEL_END_TIME")
	private Date cancelEndTime;
	
	public Date getCancelEndTime() {
		return cancelEndTime;
	}

	public void setCancelEndTime(Date cancelEndTime) {
		this.cancelEndTime = cancelEndTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_ID
	 * @return  the value of cms_activity.ACTIVITY_ID
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getActivityId() {
		return activityId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_ID
	 * @param activityId  the value for cms_activity.ACTIVITY_ID
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityId(String activityId) {
		this.activityId = activityId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_NAME
	 * @return  the value of cms_activity.ACTIVITY_NAME
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getActivityName() {
		return activityName;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_NAME
	 * @param activityName  the value for cms_activity.ACTIVITY_NAME
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityName(String activityName) {
		this.activityName = activityName;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_LINKMAN
	 * @return  the value of cms_activity.ACTIVITY_LINKMAN
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getActivityLinkman() {
		return activityLinkman;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_LINKMAN
	 * @param activityLinkman  the value for cms_activity.ACTIVITY_LINKMAN
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityLinkman(String activityLinkman) {
		this.activityLinkman = activityLinkman;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_TEL
	 * @return  the value of cms_activity.ACTIVITY_TEL
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getActivityTel() {
		return activityTel;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_TEL
	 * @param activityTel  the value for cms_activity.ACTIVITY_TEL
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityTel(String activityTel) {
		this.activityTel = activityTel;
	}





	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_ICON_URL
	 * @return  the value of cms_activity.ACTIVITY_ICON_URL
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getActivityIconUrl() {
		return activityIconUrl;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_ICON_URL
	 * @param activityIconUrl  the value for cms_activity.ACTIVITY_ICON_URL
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityIconUrl(String activityIconUrl) {
		this.activityIconUrl = activityIconUrl;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_PROVINCE
	 * @return  the value of cms_activity.ACTIVITY_PROVINCE
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getActivityProvince() {
		return activityProvince;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_PROVINCE
	 * @param activityProvince  the value for cms_activity.ACTIVITY_PROVINCE
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityProvince(String activityProvince) {
		this.activityProvince = activityProvince;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_CITY
	 * @return  the value of cms_activity.ACTIVITY_CITY
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getActivityCity() {
		return activityCity;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_CITY
	 * @param activityCity  the value for cms_activity.ACTIVITY_CITY
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityCity(String activityCity) {
		this.activityCity = activityCity;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_AREA
	 * @return  the value of cms_activity.ACTIVITY_AREA
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getActivityArea() {
		return activityArea;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_AREA
	 * @param activityArea  the value for cms_activity.ACTIVITY_AREA
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityArea(String activityArea) {
		this.activityArea = activityArea;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_ADDRESS
	 * @return  the value of cms_activity.ACTIVITY_ADDRESS
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getActivityAddress() {
		return activityAddress;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_ADDRESS
	 * @param activityAddress  the value for cms_activity.ACTIVITY_ADDRESS
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityAddress(String activityAddress) {
		this.activityAddress = activityAddress;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_LON
	 * @return  the value of cms_activity.ACTIVITY_LON
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public Double getActivityLon() {
		return activityLon;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_LON
	 * @param activityLon  the value for cms_activity.ACTIVITY_LON
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityLon(Double activityLon) {
		this.activityLon = activityLon;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_LAT
	 * @return  the value of cms_activity.ACTIVITY_LAT
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public Double getActivityLat() {
		return activityLat;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_LAT
	 * @param activityLat  the value for cms_activity.ACTIVITY_LAT
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityLat(Double activityLat) {
		this.activityLat = activityLat;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_TIME
	 * @return  the value of cms_activity.ACTIVITY_TIME
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getActivityTime() {
		return activityTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_TIME
	 * @param activityTime  the value for cms_activity.ACTIVITY_TIME
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityTime(String activityTime) {
		this.activityTime = activityTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_IS_FREE
	 * @return  the value of cms_activity.ACTIVITY_IS_FREE
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public Integer getActivityIsFree() {
		return activityIsFree;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_IS_FREE
	 * @param activityIsFree  the value for cms_activity.ACTIVITY_IS_FREE
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityIsFree(Integer activityIsFree) {
		this.activityIsFree = activityIsFree;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_PRICE
	 * @return  the value of cms_activity.ACTIVITY_PRICE
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getActivityPrice() {
		return activityPrice;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_PRICE
	 * @param activityPrice  the value for cms_activity.ACTIVITY_PRICE
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityPrice(String activityPrice) {
		this.activityPrice = activityPrice;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_IS_DETAILS
	 * @return  the value of cms_activity.ACTIVITY_IS_DETAILS
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public Integer getActivityIsDetails() {
		return activityIsDetails;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_IS_DETAILS
	 * @param activityIsDetails  the value for cms_activity.ACTIVITY_IS_DETAILS
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityIsDetails(Integer activityIsDetails) {
		this.activityIsDetails = activityIsDetails;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_IS_RESERVATION
	 * @return  the value of cms_activity.ACTIVITY_IS_RESERVATION
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public Integer getActivityIsReservation() {
		return activityIsReservation;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_IS_RESERVATION
	 * @param activityIsReservation  the value for cms_activity.ACTIVITY_IS_RESERVATION
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityIsReservation(Integer activityIsReservation) {
		this.activityIsReservation = activityIsReservation;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_RESERVATION_COUNT
	 * @return  the value of cms_activity.ACTIVITY_RESERVATION_COUNT
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public Integer getActivityReservationCount() {
		return activityReservationCount;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_RESERVATION_COUNT
	 * @param activityReservationCount  the value for cms_activity.ACTIVITY_RESERVATION_COUNT
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityReservationCount(Integer activityReservationCount) {
		this.activityReservationCount = activityReservationCount;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_START_TIME
	 * @return  the value of cms_activity.ACTIVITY_START_TIME
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getActivityStartTime() {
		return activityStartTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_START_TIME
	 * @param activityStartTime  the value for cms_activity.ACTIVITY_START_TIME
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityStartTime(String activityStartTime) {
		this.activityStartTime = activityStartTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_END_TIME
	 * @return  the value of cms_activity.ACTIVITY_END_TIME
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getActivityEndTime() {
		return activityEndTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_END_TIME
	 * @param activityEndTime  the value for cms_activity.ACTIVITY_END_TIME
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityEndTime(String activityEndTime) {
		this.activityEndTime = activityEndTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_IS_DEL
	 * @return  the value of cms_activity.ACTIVITY_IS_DEL
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public Integer getActivityIsDel() {
		return activityIsDel;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_IS_DEL
	 * @param activityIsDel  the value for cms_activity.ACTIVITY_IS_DEL
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityIsDel(Integer activityIsDel) {
		this.activityIsDel = activityIsDel;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_STATE
	 * @return  the value of cms_activity.ACTIVITY_STATE
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public Integer getActivityState() {
		return activityState;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_STATE
	 * @param activityState  the value for cms_activity.ACTIVITY_STATE
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityState(Integer activityState) {
		this.activityState = activityState;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_CREATE_TIME
	 * @return  the value of cms_activity.ACTIVITY_CREATE_TIME
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public Date getActivityCreateTime() {
		return activityCreateTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_CREATE_TIME
	 * @param activityCreateTime  the value for cms_activity.ACTIVITY_CREATE_TIME
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityCreateTime(Date activityCreateTime) {
		this.activityCreateTime = activityCreateTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_UPDATE_TIME
	 * @return  the value of cms_activity.ACTIVITY_UPDATE_TIME
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public Date getActivityUpdateTime() {
		return activityUpdateTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_UPDATE_TIME
	 * @param activityUpdateTime  the value for cms_activity.ACTIVITY_UPDATE_TIME
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityUpdateTime(Date activityUpdateTime) {
		this.activityUpdateTime = activityUpdateTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_CREATE_USER
	 * @return  the value of cms_activity.ACTIVITY_CREATE_USER
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getActivityCreateUser() {
		return activityCreateUser;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_CREATE_USER
	 * @param activityCreateUser  the value for cms_activity.ACTIVITY_CREATE_USER
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityCreateUser(String activityCreateUser) {
		this.activityCreateUser = activityCreateUser;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_UPDATE_USER
	 * @return  the value of cms_activity.ACTIVITY_UPDATE_USER
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getActivityUpdateUser() {
		return activityUpdateUser;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_UPDATE_USER
	 * @param activityUpdateUser  the value for cms_activity.ACTIVITY_UPDATE_USER
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityUpdateUser(String activityUpdateUser) {
		this.activityUpdateUser = activityUpdateUser;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_RECOMMEND
	 * @return  the value of cms_activity.ACTIVITY_RECOMMEND
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getActivityRecommend() {
		return activityRecommend;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_RECOMMEND
	 * @param activityRecommend  the value for cms_activity.ACTIVITY_RECOMMEND
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityRecommend(String activityRecommend) {
		this.activityRecommend = activityRecommend;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_SALES_ONLINE
	 * @return  the value of cms_activity.ACTIVITY_SALES_ONLINE
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getActivitySalesOnline() {
		return activitySalesOnline;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_SALES_ONLINE
	 * @param activitySalesOnline  the value for cms_activity.ACTIVITY_SALES_ONLINE
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivitySalesOnline(String activitySalesOnline) {
		this.activitySalesOnline = activitySalesOnline;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_TIME_DES
	 * @return  the value of cms_activity.ACTIVITY_TIME_DES
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getActivityTimeDes() {
		return activityTimeDes;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_TIME_DES
	 * @param activityTimeDes  the value for cms_activity.ACTIVITY_TIME_DES
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityTimeDes(String activityTimeDes) {
		this.activityTimeDes = activityTimeDes;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_LOCATION
	 * @return  the value of cms_activity.ACTIVITY_LOCATION
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getActivityLocation() {
		return activityLocation;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_LOCATION
	 * @param activityLocation  the value for cms_activity.ACTIVITY_LOCATION
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityLocation(String activityLocation) {
		this.activityLocation = activityLocation;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.SYS_ID
	 * @return  the value of cms_activity.SYS_ID
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getSysId() {
		return sysId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.SYS_ID
	 * @param sysId  the value for cms_activity.SYS_ID
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setSysId(String sysId) {
		this.sysId = sysId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.SYS_NO
	 * @return  the value of cms_activity.SYS_NO
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getSysNo() {
		return sysNo;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.SYS_NO
	 * @param sysNo  the value for cms_activity.SYS_NO
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setSysNo(String sysNo) {
		this.sysNo = sysNo;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.CREATE_ACTIVITY_CODE
	 * @return  the value of cms_activity.CREATE_ACTIVITY_CODE
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public Integer getCreateActivityCode() {
		return createActivityCode;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.CREATE_ACTIVITY_CODE
	 * @param createActivityCode  the value for cms_activity.CREATE_ACTIVITY_CODE
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setCreateActivityCode(Integer createActivityCode) {
		this.createActivityCode = createActivityCode;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.EVENT_COUNT
	 * @return  the value of cms_activity.EVENT_COUNT
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public Integer getEventCount() {
		return eventCount;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.EVENT_COUNT
	 * @param eventCount  the value for cms_activity.EVENT_COUNT
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setEventCount(Integer eventCount) {
		this.eventCount = eventCount;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_RECOMMEND_TIME
	 * @return  the value of cms_activity.ACTIVITY_RECOMMEND_TIME
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public Date getActivityRecommendTime() {
		return activityRecommendTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_RECOMMEND_TIME
	 * @param activityRecommendTime  the value for cms_activity.ACTIVITY_RECOMMEND_TIME
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityRecommendTime(Date activityRecommendTime) {
		this.activityRecommendTime = activityRecommendTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_HOST
	 * @return  the value of cms_activity.ACTIVITY_HOST
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getActivityHost() {
		return activityHost;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_HOST
	 * @param activityHost  the value for cms_activity.ACTIVITY_HOST
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityHost(String activityHost) {
		this.activityHost = activityHost;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_ORGANIZER
	 * @return  the value of cms_activity.ACTIVITY_ORGANIZER
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getActivityOrganizer() {
		return activityOrganizer;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_ORGANIZER
	 * @param activityOrganizer  the value for cms_activity.ACTIVITY_ORGANIZER
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityOrganizer(String activityOrganizer) {
		this.activityOrganizer = activityOrganizer;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_COORGANIZER
	 * @return  the value of cms_activity.ACTIVITY_COORGANIZER
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getActivityCoorganizer() {
		return activityCoorganizer;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_COORGANIZER
	 * @param activityCoorganizer  the value for cms_activity.ACTIVITY_COORGANIZER
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityCoorganizer(String activityCoorganizer) {
		this.activityCoorganizer = activityCoorganizer;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_PERFORMED
	 * @return  the value of cms_activity.ACTIVITY_PERFORMED
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getActivityPerformed() {
		return activityPerformed;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_PERFORMED
	 * @param activityPerformed  the value for cms_activity.ACTIVITY_PERFORMED
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityPerformed(String activityPerformed) {
		this.activityPerformed = activityPerformed;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_PROMPT
	 * @return  the value of cms_activity.ACTIVITY_PROMPT
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getActivityPrompt() {
		return activityPrompt;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_PROMPT
	 * @param activityPrompt  the value for cms_activity.ACTIVITY_PROMPT
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityPrompt(String activityPrompt) {
		this.activityPrompt = activityPrompt;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_SPEAKER
	 * @return  the value of cms_activity.ACTIVITY_SPEAKER
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getActivitySpeaker() {
		return activitySpeaker;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_SPEAKER
	 * @param activitySpeaker  the value for cms_activity.ACTIVITY_SPEAKER
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivitySpeaker(String activitySpeaker) {
		this.activitySpeaker = activitySpeaker;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_PERSONAL
	 * @return  the value of cms_activity.ACTIVITY_PERSONAL
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public Integer getActivityPersonal() {
		return activityPersonal;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_PERSONAL
	 * @param activityPersonal  the value for cms_activity.ACTIVITY_PERSONAL
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityPersonal(Integer activityPersonal) {
		this.activityPersonal = activityPersonal;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_RECOMMEND_USERID
	 * @return  the value of cms_activity.ACTIVITY_RECOMMEND_USERID
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getActivityRecommendUserid() {
		return activityRecommendUserid;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_RECOMMEND_USERID
	 * @param activityRecommendUserid  the value for cms_activity.ACTIVITY_RECOMMEND_USERID
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityRecommendUserid(String activityRecommendUserid) {
		this.activityRecommendUserid = activityRecommendUserid;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_TERMINAL_USER_ID
	 * @return  the value of cms_activity.ACTIVITY_TERMINAL_USER_ID
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getActivityTerminalUserId() {
		return activityTerminalUserId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_TERMINAL_USER_ID
	 * @param activityTerminalUserId  the value for cms_activity.ACTIVITY_TERMINAL_USER_ID
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityTerminalUserId(String activityTerminalUserId) {
		this.activityTerminalUserId = activityTerminalUserId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.TEMPL_ID
	 * @return  the value of cms_activity.TEMPL_ID
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getTemplId() {
		return templId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.TEMPL_ID
	 * @param templId  the value for cms_activity.TEMPL_ID
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setTemplId(String templId) {
		this.templId = templId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_SITE
	 * @return  the value of cms_activity.ACTIVITY_SITE
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getActivitySite() {
		return activitySite;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_SITE
	 * @param activitySite  the value for cms_activity.ACTIVITY_SITE
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivitySite(String activitySite) {
		this.activitySite = activitySite;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_SUBJECT
	 * @return  the value of cms_activity.ACTIVITY_SUBJECT
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getActivitySubject() {
		return activitySubject;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_SUBJECT
	 * @param activitySubject  the value for cms_activity.ACTIVITY_SUBJECT
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivitySubject(String activitySubject) {
		this.activitySubject = activitySubject;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.PRICE_DESCRIBE
	 * @return  the value of cms_activity.PRICE_DESCRIBE
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getPriceDescribe() {
		return priceDescribe;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.PRICE_DESCRIBE
	 * @param priceDescribe  the value for cms_activity.PRICE_DESCRIBE
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setPriceDescribe(String priceDescribe) {
		this.priceDescribe = priceDescribe;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.RATINGS_INFO
	 * @return  the value of cms_activity.RATINGS_INFO
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getRatingsInfo() {
		return ratingsInfo;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.RATINGS_INFO
	 * @param ratingsInfo  the value for cms_activity.RATINGS_INFO
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setRatingsInfo(String ratingsInfo) {
		this.ratingsInfo = ratingsInfo;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.TICKET_SETTINGS
	 * @return  the value of cms_activity.TICKET_SETTINGS
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getTicketSettings() {
		return ticketSettings;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.TICKET_SETTINGS
	 * @param ticketSettings  the value for cms_activity.TICKET_SETTINGS
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setTicketSettings(String ticketSettings) {
		this.ticketSettings = ticketSettings;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.TICKET_NUMBER
	 * @return  the value of cms_activity.TICKET_NUMBER
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public Integer getTicketNumber() {
		return ticketNumber;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.TICKET_NUMBER
	 * @param ticketNumber  the value for cms_activity.TICKET_NUMBER
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setTicketNumber(Integer ticketNumber) {
		this.ticketNumber = ticketNumber;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.TICKET_COUNT
	 * @return  the value of cms_activity.TICKET_COUNT
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public Integer getTicketCount() {
		return ticketCount;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.TICKET_COUNT
	 * @param ticketCount  the value for cms_activity.TICKET_COUNT
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setTicketCount(Integer ticketCount) {
		this.ticketCount = ticketCount;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.PUBLIC_TIME
	 * @return  the value of cms_activity.PUBLIC_TIME
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public Date getPublicTime() {
		return publicTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.PUBLIC_TIME
	 * @param publicTime  the value for cms_activity.PUBLIC_TIME
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setPublicTime(Date publicTime) {
		this.publicTime = publicTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.IDENTITY_CARD
	 * @return  the value of cms_activity.IDENTITY_CARD
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public Integer getIdentityCard() {
		return identityCard;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.IDENTITY_CARD
	 * @param identityCard  the value for cms_activity.IDENTITY_CARD
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setIdentityCard(Integer identityCard) {
		this.identityCard = identityCard;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.PRICE_TYPE
	 * @return  the value of cms_activity.PRICE_TYPE
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public Integer getPriceType() {
		return priceType;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.PRICE_TYPE
	 * @param priceType  the value for cms_activity.PRICE_TYPE
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setPriceType(Integer priceType) {
		this.priceType = priceType;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.LOWEST_CREDIT
	 * @return  the value of cms_activity.LOWEST_CREDIT
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public Integer getLowestCredit() {
		return lowestCredit;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.LOWEST_CREDIT
	 * @param lowestCredit  the value for cms_activity.LOWEST_CREDIT
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setLowestCredit(Integer lowestCredit) {
		this.lowestCredit = lowestCredit;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.COST_CREDIT
	 * @return  the value of cms_activity.COST_CREDIT
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public Integer getCostCredit() {
		return costCredit;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.COST_CREDIT
	 * @param costCredit  the value for cms_activity.COST_CREDIT
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setCostCredit(Integer costCredit) {
		this.costCredit = costCredit;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.DEDUCTION_CREDIT
	 * @return  the value of cms_activity.DEDUCTION_CREDIT
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public Integer getDeductionCredit() {
		return deductionCredit;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.DEDUCTION_CREDIT
	 * @param deductionCredit  the value for cms_activity.DEDUCTION_CREDIT
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setDeductionCredit(Integer deductionCredit) {
		this.deductionCredit = deductionCredit;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.SPIKE_TYPE
	 * @return  the value of cms_activity.SPIKE_TYPE
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public Integer getSpikeType() {
		return spikeType;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.SPIKE_TYPE
	 * @param spikeType  the value for cms_activity.SPIKE_TYPE
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setSpikeType(Integer spikeType) {
		this.spikeType = spikeType;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.SINGLE_EVENT
	 * @return  the value of cms_activity.SINGLE_EVENT
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public Integer getSingleEvent() {
		return singleEvent;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.SINGLE_EVENT
	 * @param singleEvent  the value for cms_activity.SINGLE_EVENT
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setSingleEvent(Integer singleEvent) {
		this.singleEvent = singleEvent;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ASSN_ID
	 * @return  the value of cms_activity.ASSN_ID
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getAssnId() {
		return assnId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ASSN_ID
	 * @param assnId  the value for cms_activity.ASSN_ID
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setAssnId(String assnId) {
		this.assnId = assnId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_TYPE
	 * @return  the value of cms_activity.ACTIVITY_TYPE
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getActivityType() {
		return activityType;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_TYPE
	 * @param activityType  the value for cms_activity.ACTIVITY_TYPE
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityType(String activityType) {
		this.activityType = activityType;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_MEMO
	 * @return  the value of cms_activity.ACTIVITY_MEMO
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getActivityMemo() {
		return activityMemo;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_MEMO
	 * @param activityMemo  the value for cms_activity.ACTIVITY_MEMO
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityMemo(String activityMemo) {
		this.activityMemo = activityMemo;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_CONTENT
	 * @return  the value of cms_activity.ACTIVITY_CONTENT
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getActivityContent() {
		return activityContent;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_CONTENT
	 * @param activityContent  the value for cms_activity.ACTIVITY_CONTENT
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityContent(String activityContent) {
		this.activityContent = activityContent;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_DEPT
	 * @return  the value of cms_activity.ACTIVITY_DEPT
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getActivityDept() {
		return activityDept;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_DEPT
	 * @param activityDept  the value for cms_activity.ACTIVITY_DEPT
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityDept(String activityDept) {
		this.activityDept = activityDept;
	}


	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_THEME
	 * @return  the value of cms_activity.ACTIVITY_THEME
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getActivityTheme() {
		return activityTheme;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_THEME
	 * @param activityTheme  the value for cms_activity.ACTIVITY_THEME
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityTheme(String activityTheme) {
		this.activityTheme = activityTheme;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column cms_activity.ACTIVITY_NOTICE
	 * @return  the value of cms_activity.ACTIVITY_NOTICE
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public String getActivityNotice() {
		return activityNotice;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column cms_activity.ACTIVITY_NOTICE
	 * @param activityNotice  the value for cms_activity.ACTIVITY_NOTICE
	 * @mbggenerated  Tue Jul 26 17:38:21 CST 2016
	 */
	public void setActivityNotice(String activityNotice) {
		this.activityNotice = activityNotice;
	}

	public String getEndTimePoint() {
		return endTimePoint;
	}

	public void setEndTimePoint(String endTimePoint) {
		this.endTimePoint = endTimePoint;
	}

	public String getSysUrl() {
		return SysUrl;
	}

	public void setSysUrl(String sysUrl) {
		SysUrl = sysUrl;
	}

	public String getActivityAttachment() {
		return activityAttachment;
	}

	public void setActivityAttachment(String activityAttachment) {
		this.activityAttachment = activityAttachment;
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
	
}