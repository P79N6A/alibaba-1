package com.culturecloud.model.response.contest;

import com.culturecloud.model.bean.contest.CcpContestUserResult;

public class CcpContestUserResultVO extends CcpContestUserResult{

	private static final long serialVersionUID = -947005550489678663L;

	public CcpContestUserResultVO(CcpContestUserResult ccpContestUserResult) {
		this.setUserTopicResultId(ccpContestUserResult.getUserTopicResultId());
		this.setUserId(ccpContestUserResult.getUserId());
		this.setTopicId(ccpContestUserResult.getTopicId());
		this.setAllQuestionNumber(ccpContestUserResult.getAllQuestionNumber());
		this.setTrueQuestionNumber(ccpContestUserResult.getTrueQuestionNumber());
	}
}
