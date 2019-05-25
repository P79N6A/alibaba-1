package com.culturecloud.model.response.contest;

import com.culturecloud.model.bean.contest.CcpContestTopicPass;

public class CcpContestTopicPassVO extends CcpContestTopicPass{

	private static final long serialVersionUID = 5474389656846017966L;

	public CcpContestTopicPassVO(CcpContestTopicPass contestTopicPass) {
		
		
		this.setTopicPassId(contestTopicPass.getTopicPassId());
		this.setPassNumber(contestTopicPass.getPassNumber());
		this.setPassName(contestTopicPass.getPassName());
		this.setTopicId(contestTopicPass.getTopicId());
	}

}
