package com.sun3d.why.dao.ccp;

import com.sun3d.why.model.ccp.CcpCityVote;

public interface CcpCityVoteMapper {
    int deleteByPrimaryKey(String cityVoteId);

    int insert(CcpCityVote record);

    CcpCityVote selectByPrimaryKey(String cityVoteId);

    int update(CcpCityVote record);
    
    int queryTodayVoteCount(CcpCityVote record);

}