package com.culturecloud.dao.micronote;

import com.culturecloud.model.bean.micronote.CcpMicronoteVote;
import com.culturecloud.model.request.micronote.CcpMicronoteVoteReqVO;

public interface CcpMicronoteVoteMapper {
    int deleteByPrimaryKey(String noteVoteId);

    int insert(CcpMicronoteVoteReqVO record);

    CcpMicronoteVote selectByPrimaryKey(String noteVoteId);

    int update(CcpMicronoteVoteReqVO record);
    
    int countUserTodayVote(CcpMicronoteVoteReqVO request);
}