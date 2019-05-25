package com.sun3d.why.dao.ccp;

import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.sun3d.why.model.ccp.CcpNyUser;

public interface CcpNyUserMapper {
    int deleteByPrimaryKey(String userId);

    int insert(CcpNyUser record);

    CcpNyUser selectByPrimaryKey(String userId);

    int update(CcpNyUser record);
    
    List<CcpNyUser> queryNyUserRanking();

    int selectRankingByVoteCount(@Param("voteCount")Integer voteCount,@Param("createTime")Date createTime);
}