package com.culturecloud.dao.beautycity;

import com.culturecloud.model.bean.beautycity.CcpBeautycityVote;
import com.culturecloud.model.request.beautycity.CcpBeautycityVoteReqVO;

public interface CcpBeautycityVoteMapper {
    int deleteByPrimaryKey(String beautycityVoteId);

    int insert(CcpBeautycityVoteReqVO record);

    CcpBeautycityVote selectByPrimaryKey(String beautycityVoteId);

    int update(CcpBeautycityVoteReqVO record);
    
    int countUserTodayVote(CcpBeautycityVoteReqVO request);
}