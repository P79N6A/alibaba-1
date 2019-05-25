package com.sun3d.why.dao;

import com.sun3d.why.model.qyg.QygVote;


public interface QygVoteMapper {
    int deleteByPrimaryKey(String voteId);

    int insert(QygVote record);

    int insertSelective(QygVote record);

    QygVote selectByPrimaryKey(String voteId);

    int updateByPrimaryKeySelective(QygVote record);

    int updateByPrimaryKey(QygVote record);

	int queryTodayVoteCount(QygVote vo);
}