package com.culturecloud.model.response.contest;


import com.culturecloud.annotations.Table;
import com.culturecloud.model.bean.contest.CcpContestAnswer;

@Table(value="ccp_contest_answer")
public class CcpContestAnswerVO extends CcpContestAnswer{
	
	private static final long serialVersionUID = -965987244112117765L;
	 
	 public CcpContestAnswerVO(CcpContestAnswer answer) {
		 
		this.setAnswerId(answer.getAnswerId());
		this.setAnswerText(answer.getAnswerText());
		this.setAnswerPicUrl(answer.getAnswerPicUrl());
		this.setQuestionId(answer.getQuestionId());
		this.setIsTrue(answer.getIsTrue());
	}

}