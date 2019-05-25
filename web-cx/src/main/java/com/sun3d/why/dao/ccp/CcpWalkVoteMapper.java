package com.sun3d.why.dao.ccp;

import com.sun3d.why.model.ccp.CcpWalkVote;

public interface CcpWalkVoteMapper {
    int deleteByPrimaryKey(String walkVoteId);

    int insert(CcpWalkVote record);

    CcpWalkVote selectByPrimaryKey(String walkVoteId);

    int update(CcpWalkVote record);
    
    int queryTodayVoteCount(CcpWalkVote record);

}