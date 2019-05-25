package com.sun3d.why.dao.ccp;

import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.sun3d.why.model.ccp.CcpWalkUser;

public interface CcpWalkUserMapper {
    int deleteByPrimaryKey(String userId);

    int insert(CcpWalkUser record);

    CcpWalkUser selectByPrimaryKey(String userId);

    int update(CcpWalkUser record);
    
    List<CcpWalkUser> queryWalkUserRanking();

    int selectRankingByVoteCount(@Param("voteCount")Integer voteCount,@Param("createTime")Date createTime);
}