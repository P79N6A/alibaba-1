package com.sun3d.why.dao.ccp;

import com.sun3d.why.model.ccp.CcpCultureTeamVote;

public interface CcpCultureTeamVoteMapper {
    int deleteByPrimaryKey(String voteId);

    int insert(CcpCultureTeamVote record);

    CcpCultureTeamVote selectByPrimaryKey(String voteId);

    int update(CcpCultureTeamVote record);

	int queryTodayVoteCount(CcpCultureTeamVote vote);

}