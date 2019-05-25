package com.sun3d.why.dao;

import com.sun3d.why.model.DcVote;

public interface DcVoteMapper {
    int deleteByPrimaryKey(String voteId);

    int insert(DcVote record);

    DcVote selectByPrimaryKey(String voteId);

    int update(DcVote record);

    int queryTodayVoteCount(DcVote record);
}