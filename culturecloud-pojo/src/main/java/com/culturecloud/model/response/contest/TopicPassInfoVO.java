package com.culturecloud.model.response.contest;

import java.util.List;

/**
 * @author zhangshun
 *
 */
public class TopicPassInfoVO {
	
	// 主题id 
	private String topicId;

	// 过关信息集合
	private List<CcpContestTopicPassVO> topicPassVOList;	
	
	//试题id
	private String [] questionIdArray;
	
	// 总关数
	private Integer sum;
	
	// 主题名称
	private String topicName;
	
	// 主题副标题
	private String topicTitle;

	public String getTopicId() {
		return topicId;
	}

	public void setTopicId(String topicId) {
		this.topicId = topicId;
	}

	public List<CcpContestTopicPassVO> getTopicPassVOList() {
		return topicPassVOList;
	}

	public void setTopicPassVOList(List<CcpContestTopicPassVO> topicPassVOList) {
		this.topicPassVOList = topicPassVOList;
	}

	public Integer getSum() {
		return sum;
	}

	public void setSum(Integer sum) {
		this.sum = sum;
	}

	public String[] getQuestionIdArray() {
		return questionIdArray;
	}

	public void setQuestionIdArray(String[] questionIdArray) {
		this.questionIdArray = questionIdArray;
	}

	public String getTopicName() {
		return topicName;
	}

	public void setTopicName(String topicName) {
		this.topicName = topicName;
	}

	public String getTopicTitle() {
		return topicTitle;
	}

	public void setTopicTitle(String topicTitle) {
		this.topicTitle = topicTitle;
	}
	
	
	
}
