package com.sun3d.why.dao.ccp;

import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.sun3d.why.model.ccp.CcpCityUser;

public interface CcpCityUserMapper {
    int deleteByPrimaryKey(String userId);

    int insert(CcpCityUser record);

    CcpCityUser selectByPrimaryKey(String userId);

    int update(CcpCityUser record);
    
    List<CcpCityUser> queryCityUserRanking(@Param("cityType")Integer cityType);

    int selectRankingByVoteCount(@Param("voteCount")Integer voteCount,@Param("createTime")Date createTime);
}