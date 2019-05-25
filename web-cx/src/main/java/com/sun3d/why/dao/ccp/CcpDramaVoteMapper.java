package com.sun3d.why.dao.ccp;

import com.sun3d.why.model.ccp.CcpDramaVote;

public interface CcpDramaVoteMapper {
    int deleteByPrimaryKey(String dramaVoteId);

    int insert(CcpDramaVote record);

    CcpDramaVote selectByPrimaryKey(String dramaVoteId);

    int update(CcpDramaVote record);
    
    int queryTodayVoteCount(CcpDramaVote record);

}