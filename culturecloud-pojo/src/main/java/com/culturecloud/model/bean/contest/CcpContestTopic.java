package com.culturecloud.model.bean.contest;

import java.util.Date;

import javax.persistence.Column;

import com.culturecloud.annotations.Id;
import com.culturecloud.annotations.Table;
import com.culturecloud.bean.BaseEntity;

@Table(value="ccp_contest_topic")
public class CcpContestTopic implements BaseEntity{
	
	private static final long serialVersionUID = -7653789967821366286L;

	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column ccp_contest_topic.topic_id
	 * @mbggenerated  Thu Jul 07 17:16:03 CST 2016
	 */
	@Id
	@Column(name="topic_id")
	private String topicId;
	
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column ccp_contest_topic.topic_name
	 * @mbggenerated  Thu Jul 07 17:16:03 CST 2016
	 */
	@Column(name="topic_name")
	private String topicName;
	
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column ccp_contest_topic.topic_title
	 * @mbggenerated  Thu Jul 07 17:16:03 CST 2016
	 */
	@Column(name="topic_title")
	private String topicTitle;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column ccp_contest_topic.is_levelup
	 * @mbggenerated  Thu Jul 07 17:16:03 CST 2016
	 */
	@Column(name="is_levelup")
	private Integer isLevelup;
	
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column ccp_contest_topic.pass_name
	 * @mbggenerated  Thu Jul 07 17:16:03 CST 2016
	 */
	@Column(name="pass_name")
	private String passName;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column ccp_contest_topic.pass_text
	 * @mbggenerated  Thu Jul 07 17:16:03 CST 2016
	 */
	@Column(name="pass_text")
	private String passText;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column ccp_contest_topic.topic_status
	 * @mbggenerated  Thu Jul 07 17:16:03 CST 2016
	 */
	@Column(name="topic_status")
	private Integer topicStatus;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column ccp_contest_topic.create_time
	 * @mbggenerated  Thu Jul 07 17:16:03 CST 2016
	 */
	@Column(name="create_time")
	private Date createTime;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column ccp_contest_topic.update_time
	 * @mbggenerated  Thu Jul 07 17:16:03 CST 2016
	 */
	@Column(name="update_time")
	private Date updateTime;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column ccp_contest_topic.create_sys_user_id
	 * @mbggenerated  Thu Jul 07 17:16:03 CST 2016
	 */
	@Column(name="create_sys_user_id")
	private String createSysUserId;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column ccp_contest_topic.update_sys_user_id
	 * @mbggenerated  Thu Jul 07 17:16:03 CST 2016
	 */
	@Column(name="update_sys_user_id")
	private String updateSysUserId;
	/**
	 * This field was generated by MyBatis Generator. This field corresponds to the database column ccp_contest_topic.topic_icon
	 * @mbggenerated  Thu Jul 07 17:16:03 CST 2016
	 */
	@Column(name="topic_icon")
	private String topicIcon;
	
	
	@Column(name="answer_right_text")
    private String answerRightText;

	@Column(name="answer_wrong_text")
    private String answerWrongText;

	@Column(name="is_draw")
    private Integer isDraw;

	@Column(name="draw_rule")
    private String drawRule;

	@Column(name="share_logo_img")
    private String shareLogoImg;

	@Column(name="share_title")
    private String shareTitle;

	@Column(name="share_describe")
    private String shareDescribe;
	
	@Column(name="template_id")
	private String templateId;
	
	@Column(name="index_logo")
	private String indexLogo;
	
	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_contest_topic.topic_id
	 * @return  the value of ccp_contest_topic.topic_id
	 * @mbggenerated  Thu Jul 07 17:16:03 CST 2016
	 */
	public String getTopicId() {
		return topicId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_contest_topic.topic_id
	 * @param topicId  the value for ccp_contest_topic.topic_id
	 * @mbggenerated  Thu Jul 07 17:16:03 CST 2016
	 */
	public void setTopicId(String topicId) {
		this.topicId = topicId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_contest_topic.topic_name
	 * @return  the value of ccp_contest_topic.topic_name
	 * @mbggenerated  Thu Jul 07 17:16:03 CST 2016
	 */
	public String getTopicName() {
		return topicName;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_contest_topic.topic_name
	 * @param topicName  the value for ccp_contest_topic.topic_name
	 * @mbggenerated  Thu Jul 07 17:16:03 CST 2016
	 */
	public void setTopicName(String topicName) {
		this.topicName = topicName;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_contest_topic.topic_title
	 * @return  the value of ccp_contest_topic.topic_title
	 * @mbggenerated  Thu Jul 07 17:16:03 CST 2016
	 */
	public String getTopicTitle() {
		return topicTitle;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_contest_topic.topic_title
	 * @param topicTitle  the value for ccp_contest_topic.topic_title
	 * @mbggenerated  Thu Jul 07 17:16:03 CST 2016
	 */
	public void setTopicTitle(String topicTitle) {
		this.topicTitle = topicTitle;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_contest_topic.is_levelup
	 * @return  the value of ccp_contest_topic.is_levelup
	 * @mbggenerated  Thu Jul 07 17:16:03 CST 2016
	 */
	public Integer getIsLevelup() {
		return isLevelup;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_contest_topic.is_levelup
	 * @param isLevelup  the value for ccp_contest_topic.is_levelup
	 * @mbggenerated  Thu Jul 07 17:16:03 CST 2016
	 */
	public void setIsLevelup(Integer isLevelup) {
		this.isLevelup = isLevelup;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_contest_topic.pass_name
	 * @return  the value of ccp_contest_topic.pass_name
	 * @mbggenerated  Thu Jul 07 17:16:03 CST 2016
	 */
	public String getPassName() {
		return passName;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_contest_topic.pass_name
	 * @param passName  the value for ccp_contest_topic.pass_name
	 * @mbggenerated  Thu Jul 07 17:16:03 CST 2016
	 */
	public void setPassName(String passName) {
		this.passName = passName;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_contest_topic.pass_text
	 * @return  the value of ccp_contest_topic.pass_text
	 * @mbggenerated  Thu Jul 07 17:16:03 CST 2016
	 */
	public String getPassText() {
		return passText;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_contest_topic.pass_text
	 * @param passText  the value for ccp_contest_topic.pass_text
	 * @mbggenerated  Thu Jul 07 17:16:03 CST 2016
	 */
	public void setPassText(String passText) {
		this.passText = passText;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_contest_topic.topic_status
	 * @return  the value of ccp_contest_topic.topic_status
	 * @mbggenerated  Thu Jul 07 17:16:03 CST 2016
	 */
	public Integer getTopicStatus() {
		return topicStatus;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_contest_topic.topic_status
	 * @param topicStatus  the value for ccp_contest_topic.topic_status
	 * @mbggenerated  Thu Jul 07 17:16:03 CST 2016
	 */
	public void setTopicStatus(Integer topicStatus) {
		this.topicStatus = topicStatus;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_contest_topic.create_time
	 * @return  the value of ccp_contest_topic.create_time
	 * @mbggenerated  Thu Jul 07 17:16:03 CST 2016
	 */
	public Date getCreateTime() {
		return createTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_contest_topic.create_time
	 * @param createTime  the value for ccp_contest_topic.create_time
	 * @mbggenerated  Thu Jul 07 17:16:03 CST 2016
	 */
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_contest_topic.update_time
	 * @return  the value of ccp_contest_topic.update_time
	 * @mbggenerated  Thu Jul 07 17:16:03 CST 2016
	 */
	public Date getUpdateTime() {
		return updateTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_contest_topic.update_time
	 * @param updateTime  the value for ccp_contest_topic.update_time
	 * @mbggenerated  Thu Jul 07 17:16:03 CST 2016
	 */
	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_contest_topic.create_sys_user_id
	 * @return  the value of ccp_contest_topic.create_sys_user_id
	 * @mbggenerated  Thu Jul 07 17:16:03 CST 2016
	 */
	public String getCreateSysUserId() {
		return createSysUserId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_contest_topic.create_sys_user_id
	 * @param createSysUserId  the value for ccp_contest_topic.create_sys_user_id
	 * @mbggenerated  Thu Jul 07 17:16:03 CST 2016
	 */
	public void setCreateSysUserId(String createSysUserId) {
		this.createSysUserId = createSysUserId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_contest_topic.update_sys_user_id
	 * @return  the value of ccp_contest_topic.update_sys_user_id
	 * @mbggenerated  Thu Jul 07 17:16:03 CST 2016
	 */
	public String getUpdateSysUserId() {
		return updateSysUserId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_contest_topic.update_sys_user_id
	 * @param updateSysUserId  the value for ccp_contest_topic.update_sys_user_id
	 * @mbggenerated  Thu Jul 07 17:16:03 CST 2016
	 */
	public void setUpdateSysUserId(String updateSysUserId) {
		this.updateSysUserId = updateSysUserId;
	}

	/**
	 * This method was generated by MyBatis Generator. This method returns the value of the database column ccp_contest_topic.topic_icon
	 * @return  the value of ccp_contest_topic.topic_icon
	 * @mbggenerated  Thu Jul 07 17:16:03 CST 2016
	 */
	public String getTopicIcon() {
		return topicIcon;
	}

	/**
	 * This method was generated by MyBatis Generator. This method sets the value of the database column ccp_contest_topic.topic_icon
	 * @param topicIcon  the value for ccp_contest_topic.topic_icon
	 * @mbggenerated  Thu Jul 07 17:16:03 CST 2016
	 */
	public void setTopicIcon(String topicIcon) {
		this.topicIcon = topicIcon;
	}

	public String getAnswerRightText() {
		return answerRightText;
	}

	public void setAnswerRightText(String answerRightText) {
		this.answerRightText = answerRightText;
	}

	public String getAnswerWrongText() {
		return answerWrongText;
	}

	public void setAnswerWrongText(String answerWrongText) {
		this.answerWrongText = answerWrongText;
	}

	public Integer getIsDraw() {
		return isDraw;
	}

	public void setIsDraw(Integer isDraw) {
		this.isDraw = isDraw;
	}

	public String getDrawRule() {
		return drawRule;
	}

	public void setDrawRule(String drawRule) {
		this.drawRule = drawRule;
	}

	public String getShareLogoImg() {
		return shareLogoImg;
	}

	public void setShareLogoImg(String shareLogoImg) {
		this.shareLogoImg = shareLogoImg;
	}

	public String getShareTitle() {
		return shareTitle;
	}

	public void setShareTitle(String shareTitle) {
		this.shareTitle = shareTitle;
	}

	public String getShareDescribe() {
		return shareDescribe;
	}

	public void setShareDescribe(String shareDescribe) {
		this.shareDescribe = shareDescribe;
	}

	public String getTemplateId() {
		return templateId;
	}

	public void setTemplateId(String templateId) {
		this.templateId = templateId;
	}

	public String getIndexLogo() {
		return indexLogo;
	}

	public void setIndexLogo(String indexLogo) {
		this.indexLogo = indexLogo;
	}

		

	
}