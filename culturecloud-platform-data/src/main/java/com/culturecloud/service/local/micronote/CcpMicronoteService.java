package com.culturecloud.service.local.micronote;

import java.util.List;

import com.culturecloud.bean.BasePageResultListVO;
import com.culturecloud.model.bean.micronote.CcpMicronote;
import com.culturecloud.model.request.micronote.CcpMicronoteReqVO;
import com.culturecloud.model.request.micronote.CcpMicronoteVoteReqVO;
import com.culturecloud.model.response.micronote.CcpMicronoteResVO;

public interface CcpMicronoteService {

	BasePageResultListVO<CcpMicronoteResVO> getMicronoteList(CcpMicronoteReqVO request);
	
	List<CcpMicronoteResVO> getMicronoteRankingList(CcpMicronoteReqVO request);
	
	CcpMicronoteResVO getMicronoteByCondition(CcpMicronoteReqVO request);
	
	int saveMicronote(CcpMicronoteReqVO request);
	
	void deleteMicronote(CcpMicronoteReqVO request);
	
	void voteMicronote(CcpMicronoteVoteReqVO request);
}
