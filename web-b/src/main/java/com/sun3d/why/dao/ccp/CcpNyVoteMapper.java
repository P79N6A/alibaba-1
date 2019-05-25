package com.sun3d.why.dao.ccp;

import com.sun3d.why.model.ccp.CcpNyVote;

public interface CcpNyVoteMapper {
    int deleteByPrimaryKey(String nyVoteId);
    
    int deleteByCondition(CcpNyVote record);

    int insert(CcpNyVote record);

    CcpNyVote selectByPrimaryKey(String nyVoteId);

    int update(CcpNyVote record);
    
    int queryTodayVoteCount(CcpNyVote record);

}