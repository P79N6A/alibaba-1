package com.sun3d.why.model;

import java.util.Date;

public class BpInfo {

	/**
	 * This field was generated by MyBatis Generator. This field corresponds to
	 * the database column bp_info.BEIPIAOINFO_ID
	 * 
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	private String beipiaoinfoId;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to
	 * the database column bp_info.BEIPIAOINFO_TITLE
	 * 
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	private String beipiaoinfoTitle;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to
	 * the database column bp_info.BEIPIAOINFO_HOMEPAGE
	 * 
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	private String beipiaoinfoHomepage;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to
	 * the database column bp_info.BEIPIAOINFO_TAG
	 * 
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	private String beipiaoinfoTag;

	private String beipiaoinfoSubTag;

	public String getBeipiaoinfoSubTag() {
		return beipiaoinfoSubTag;
	}

	public void setBeipiaoinfoSubTag(String beipiaoinfoSubTag) {
		this.beipiaoinfoSubTag = beipiaoinfoSubTag;
	}

	/**
	 * This field was generated by MyBatis Generator. This field corresponds to
	 * the database column bp_info.PUBLISHER_NAME
	 * 
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	private String publisherName;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to
	 * the database column bp_info.BEIPIAOINFO_VIDEO
	 * 
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	private String beipiaoinfoVideo;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to
	 * the database column bp_info.BEIPIAOINFO_CREATE_TIME
	 * 
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	private Date beipiaoinfoCreateTime;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to
	 * the database column bp_info.BEIPIAOINFO_UPDATE_TIME
	 * 
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	private Date beipiaoinfoUpdateTime;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to
	 * the database column bp_info.BEIPIAOINFO_CREATE_USER
	 * 
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	private String beipiaoinfoCreateUser;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to
	 * the database column bp_info.BEIPIAOINFO_UPDATE_USER
	 * 
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	private String beipiaoinfoUpdateUser;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to
	 * the database column bp_info.BEIPIAOINFO_STATUS
	 * 
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	private String beipiaoinfoStatus;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to
	 * the database column bp_info.BEIPIAOINFO_NUMBER
	 * 
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	private String beipiaoinfoNumber;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to
	 * the database column bp_info.BEIPIAOINFO_SHOWTYPE
	 * 
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	private String beipiaoinfoShowtype;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to
	 * the database column bp_info.BEIPIAOINFO_IMAGES
	 * 
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	private String beipiaoinfoImages;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to
	 * the database column bp_info.BEIPIAOINFO_CONTENT
	 * 
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	private String beipiaoinfoContent;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to
	 * the database column bp_info.BEIPIAOINFO_DETAILS
	 * 
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	private String beipiaoinfoDetails;

	/**
	 * 用于存放父标签信息
	 */
	private String parentTagInfo;

	public String getParentTagInfo() {
		return parentTagInfo;
	}

	public void setParentTagInfo(String parentTagInfo) {
		this.parentTagInfo = parentTagInfo;
	}
	/**
	 * 用于存放所属标签的名字
	 */
	private String currentTagName;
	public String getCurrentTagName() {
		return currentTagName;
	}

	public void setCurrentTagName(String currentTagName) {
		this.currentTagName = currentTagName;
	}

	/**
	 * 所属模块：WHZX,文化资讯;YSJS,艺术鉴赏;PTCC:评弹传承;PPWH:品牌文化
	 */
	private String module;
	//艺术节类型:只有文化艺术节模块用到(数据字典)
	private String ysjType;
	private String linkInfo;

	private String address;
	private String tel;


	private Integer beipiaoinfoIsTop;	//置顶

	private Date topTime;	//置顶时间

	//前台搜索关键词
	private String keyword;

	public String getKeyword() {
		return keyword;
	}

	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}

	public String getModule() {
		return module;
	}

	public void setModule(String module) {
		this.module = module;
	}

	public String getYsjType() {
		return ysjType;
	}

	public void setYsjType(String ysjType) {
		this.ysjType = ysjType;
	}

	public String getLinkInfo() {
		return linkInfo;
	}

	public void setLinkInfo(String linkInfo) {
		this.linkInfo = linkInfo;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getTel() {
		return tel;
	}

	public void setTel(String tel) {
		this.tel = tel;
	}

	public Integer getBeipiaoinfoIsTop() {
		return beipiaoinfoIsTop;
	}

	public void setBeipiaoinfoIsTop(Integer beipiaoinfoIsTop) {
		this.beipiaoinfoIsTop = beipiaoinfoIsTop;
	}

	public Date getTopTime() {
		return topTime;
	}

	public void setTopTime(Date topTime) {
		this.topTime = topTime;
	}

	/**
	 * 用于存放管理员信息
	 */
	private String userInfo;

	public String getUserInfo() {
		return userInfo;
	}

	public void setUserInfo(String userInfo) {
		this.userInfo = userInfo;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column bp_info.BEIPIAOINFO_ID
	 * 
	 * @return the value of bp_info.BEIPIAOINFO_ID
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	public String getBeipiaoinfoId() {
		return beipiaoinfoId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column bp_info.BEIPIAOINFO_ID
	 * 
	 * @param beipiaoinfoId
	 *            the value for bp_info.BEIPIAOINFO_ID
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	public void setBeipiaoinfoId(String beipiaoinfoId) {
		this.beipiaoinfoId = beipiaoinfoId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column bp_info.BEIPIAOINFO_TITLE
	 * 
	 * @return the value of bp_info.BEIPIAOINFO_TITLE
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	public String getBeipiaoinfoTitle() {
		return beipiaoinfoTitle;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column bp_info.BEIPIAOINFO_TITLE
	 * 
	 * @param beipiaoinfoTitle
	 *            the value for bp_info.BEIPIAOINFO_TITLE
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	public void setBeipiaoinfoTitle(String beipiaoinfoTitle) {
		this.beipiaoinfoTitle = beipiaoinfoTitle;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column bp_info.BEIPIAOINFO_HOMEPAGE
	 * 
	 * @return the value of bp_info.BEIPIAOINFO_HOMEPAGE
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	public String getBeipiaoinfoHomepage() {
		return beipiaoinfoHomepage;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column bp_info.BEIPIAOINFO_HOMEPAGE
	 * 
	 * @param beipiaoinfoHomepage
	 *            the value for bp_info.BEIPIAOINFO_HOMEPAGE
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	public void setBeipiaoinfoHomepage(String beipiaoinfoHomepage) {
		this.beipiaoinfoHomepage = beipiaoinfoHomepage;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column bp_info.BEIPIAOINFO_TAG
	 * 
	 * @return the value of bp_info.BEIPIAOINFO_TAG
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	public String getBeipiaoinfoTag() {
		return beipiaoinfoTag;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column bp_info.BEIPIAOINFO_TAG
	 * 
	 * @param beipiaoinfoTag
	 *            the value for bp_info.BEIPIAOINFO_TAG
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	public void setBeipiaoinfoTag(String beipiaoinfoTag) {
		this.beipiaoinfoTag = beipiaoinfoTag;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column bp_info.PUBLISHER_NAME
	 * 
	 * @return the value of bp_info.PUBLISHER_NAME
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	public String getPublisherName() {
		return publisherName;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column bp_info.PUBLISHER_NAME
	 * 
	 * @param publisherName
	 *            the value for bp_info.PUBLISHER_NAME
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	public void setPublisherName(String publisherName) {
		this.publisherName = publisherName;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column bp_info.BEIPIAOINFO_VIDEO
	 * 
	 * @return the value of bp_info.BEIPIAOINFO_VIDEO
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	public String getBeipiaoinfoVideo() {
		return beipiaoinfoVideo;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column bp_info.BEIPIAOINFO_VIDEO
	 * 
	 * @param beipiaoinfoVideo
	 *            the value for bp_info.BEIPIAOINFO_VIDEO
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	public void setBeipiaoinfoVideo(String beipiaoinfoVideo) {
		this.beipiaoinfoVideo = beipiaoinfoVideo;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column bp_info.BEIPIAOINFO_CREATE_TIME
	 * 
	 * @return the value of bp_info.BEIPIAOINFO_CREATE_TIME
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	public Date getBeipiaoinfoCreateTime() {
		return beipiaoinfoCreateTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column bp_info.BEIPIAOINFO_CREATE_TIME
	 * 
	 * @param beipiaoinfoCreateTime
	 *            the value for bp_info.BEIPIAOINFO_CREATE_TIME
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	public void setBeipiaoinfoCreateTime(Date beipiaoinfoCreateTime) {
		this.beipiaoinfoCreateTime = beipiaoinfoCreateTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column bp_info.BEIPIAOINFO_UPDATE_TIME
	 * 
	 * @return the value of bp_info.BEIPIAOINFO_UPDATE_TIME
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	public Date getBeipiaoinfoUpdateTime() {
		return beipiaoinfoUpdateTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column bp_info.BEIPIAOINFO_UPDATE_TIME
	 * 
	 * @param beipiaoinfoUpdateTime
	 *            the value for bp_info.BEIPIAOINFO_UPDATE_TIME
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	public void setBeipiaoinfoUpdateTime(Date beipiaoinfoUpdateTime) {
		this.beipiaoinfoUpdateTime = beipiaoinfoUpdateTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column bp_info.BEIPIAOINFO_CREATE_USER
	 * 
	 * @return the value of bp_info.BEIPIAOINFO_CREATE_USER
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	public String getBeipiaoinfoCreateUser() {
		return beipiaoinfoCreateUser;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column bp_info.BEIPIAOINFO_CREATE_USER
	 * 
	 * @param beipiaoinfoCreateUser
	 *            the value for bp_info.BEIPIAOINFO_CREATE_USER
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	public void setBeipiaoinfoCreateUser(String beipiaoinfoCreateUser) {
		this.beipiaoinfoCreateUser = beipiaoinfoCreateUser;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column bp_info.BEIPIAOINFO_UPDATE_USER
	 * 
	 * @return the value of bp_info.BEIPIAOINFO_UPDATE_USER
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	public String getBeipiaoinfoUpdateUser() {
		return beipiaoinfoUpdateUser;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column bp_info.BEIPIAOINFO_UPDATE_USER
	 * 
	 * @param beipiaoinfoUpdateUser
	 *            the value for bp_info.BEIPIAOINFO_UPDATE_USER
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	public void setBeipiaoinfoUpdateUser(String beipiaoinfoUpdateUser) {
		this.beipiaoinfoUpdateUser = beipiaoinfoUpdateUser;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column bp_info.BEIPIAOINFO_STATUS
	 * 
	 * @return the value of bp_info.BEIPIAOINFO_STATUS
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	public String getBeipiaoinfoStatus() {
		return beipiaoinfoStatus;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column bp_info.BEIPIAOINFO_STATUS
	 * 
	 * @param beipiaoinfoStatus
	 *            the value for bp_info.BEIPIAOINFO_STATUS
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	public void setBeipiaoinfoStatus(String beipiaoinfoStatus) {
		this.beipiaoinfoStatus = beipiaoinfoStatus;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column bp_info.BEIPIAOINFO_NUMBER
	 * 
	 * @return the value of bp_info.BEIPIAOINFO_NUMBER
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	public String getBeipiaoinfoNumber() {
		return beipiaoinfoNumber;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column bp_info.BEIPIAOINFO_NUMBER
	 * 
	 * @param beipiaoinfoNumber
	 *            the value for bp_info.BEIPIAOINFO_NUMBER
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	public void setBeipiaoinfoNumber(String beipiaoinfoNumber) {
		this.beipiaoinfoNumber = beipiaoinfoNumber;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column bp_info.BEIPIAOINFO_SHOWTYPE
	 * 
	 * @return the value of bp_info.BEIPIAOINFO_SHOWTYPE
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	public String getBeipiaoinfoShowtype() {
		return beipiaoinfoShowtype;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column bp_info.BEIPIAOINFO_SHOWTYPE
	 * 
	 * @param beipiaoinfoShowtype
	 *            the value for bp_info.BEIPIAOINFO_SHOWTYPE
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	public void setBeipiaoinfoShowtype(String beipiaoinfoShowtype) {
		this.beipiaoinfoShowtype = beipiaoinfoShowtype;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column bp_info.BEIPIAOINFO_IMAGES
	 * 
	 * @return the value of bp_info.BEIPIAOINFO_IMAGES
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	public String getBeipiaoinfoImages() {
		return beipiaoinfoImages;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column bp_info.BEIPIAOINFO_IMAGES
	 * 
	 * @param beipiaoinfoImages
	 *            the value for bp_info.BEIPIAOINFO_IMAGES
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	public void setBeipiaoinfoImages(String beipiaoinfoImages) {
		this.beipiaoinfoImages = beipiaoinfoImages;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column bp_info.BEIPIAOINFO_CONTENT
	 * 
	 * @return the value of bp_info.BEIPIAOINFO_CONTENT
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	public String getBeipiaoinfoContent() {
		return beipiaoinfoContent;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column bp_info.BEIPIAOINFO_CONTENT
	 * 
	 * @param beipiaoinfoContent
	 *            the value for bp_info.BEIPIAOINFO_CONTENT
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	public void setBeipiaoinfoContent(String beipiaoinfoContent) {
		this.beipiaoinfoContent = beipiaoinfoContent;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the
	 * value of the database column bp_info.BEIPIAOINFO_DETAILS
	 * 
	 * @return the value of bp_info.BEIPIAOINFO_DETAILS
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	public String getBeipiaoinfoDetails() {
		return beipiaoinfoDetails;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the
	 * value of the database column bp_info.BEIPIAOINFO_DETAILS
	 * 
	 * @param beipiaoinfoDetails
	 *            the value for bp_info.BEIPIAOINFO_DETAILS
	 * @mbggenerated Wed Aug 09 15:37:09 CST 2017
	 */
	public void setBeipiaoinfoDetails(String beipiaoinfoDetails) {
		this.beipiaoinfoDetails = beipiaoinfoDetails;
	}

	// 用户点赞数
	private Integer userWantGo;

	public Integer getUserWantGo() {
		return userWantGo;
	}

	public void setUserWantGo(Integer userWantGo) {
		this.userWantGo = userWantGo;
	}
}