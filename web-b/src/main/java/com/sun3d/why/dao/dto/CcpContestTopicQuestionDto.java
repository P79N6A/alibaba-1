package com.sun3d.why.dao.dto;

import com.culturecloud.model.bean.contest.CcpContestQuestion;
import com.culturecloud.model.bean.contest.CcpContestTopicQuestion;

public class CcpContestTopicQuestionDto extends CcpContestTopicQuestion{
	
	
	private static final long serialVersionUID = 8852605424265623614L;
	
	private CcpContestQuestion question;

	public CcpContestQuestion getQuestion() {
		return question;
	}

	public void setQuestion(CcpContestQuestion question) {
		this.question = question;
	}
	
	

}
