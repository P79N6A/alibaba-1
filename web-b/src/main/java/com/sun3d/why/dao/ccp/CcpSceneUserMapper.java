package com.sun3d.why.dao.ccp;

import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.sun3d.why.model.ccp.CcpSceneUser;

public interface CcpSceneUserMapper {
    int deleteByPrimaryKey(String userId);

    int insert(CcpSceneUser record);

    CcpSceneUser selectByPrimaryKey(String userId);

    int update(CcpSceneUser record);
    
    List<CcpSceneUser> querySceneUserRanking();

    int selectRankingByVoteCount(@Param("voteCount")Integer voteCount,@Param("createTime")Date createTime);
}