package com.sun3d.why.dao.ccp;

import java.util.List;

import com.sun3d.why.model.ccp.CcpWalkVote;

public interface CcpWalkVoteMapper {
    int deleteByPrimaryKey(String walkVoteId);
    
    int deleteByCondition(CcpWalkVote record);

    int insert(CcpWalkVote record);

    CcpWalkVote selectByPrimaryKey(String walkVoteId);

    int update(CcpWalkVote record);
    
    int brushWalkVote(List<CcpWalkVote> votelist);
    
}