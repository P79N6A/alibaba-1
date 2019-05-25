package com.culturecloud.dao.dto.contest;

import java.util.List;

import com.culturecloud.model.bean.contest.CcpContestAnswer;
import com.culturecloud.model.bean.contest.CcpContestTopicQuestion;

public class CcpContestTopicQuestionDto extends CcpContestTopicQuestion {

	private static final long serialVersionUID = 8392419371001983507L;

	private List<CcpContestAnswer> answerList;
	
	private String questionTitle;

	public List<CcpContestAnswer> getAnswerList() {
		return answerList;
	}

	public void setAnswerList(List<CcpContestAnswer> answerList) {
		this.answerList = answerList;
	}

	public String getQuestionTitle() {
		return questionTitle;
	}

	public void setQuestionTitle(String questionTitle) {
		this.questionTitle = questionTitle;
	}

	
	
}
