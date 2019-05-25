package com.sun3d.why.dao.ccp;

import com.sun3d.why.model.ccp.CcpSceneVote;

public interface CcpSceneVoteMapper {
    int deleteByPrimaryKey(String sceneVoteId);

    int insert(CcpSceneVote record);

    CcpSceneVote selectByPrimaryKey(String sceneVoteId);

    int update(CcpSceneVote record);
    
    int queryTodayVoteCount(CcpSceneVote record);

}