package com.culturecloud.dao.contest;


import com.culturecloud.model.bean.contest.CcpContestUserInfo;

import java.util.List;

public interface CcpContestUserInfoMapper {
    int deleteByPrimaryKey(String contestUserId);

    int insertSelective(CcpContestUserInfo record);

    CcpContestUserInfo selectByPrimaryKey(String contestUserId);

    int updateByPrimaryKeySelective(CcpContestUserInfo record);

    int selectTop(CcpContestUserInfo record);

    List<CcpContestUserInfo> selectTopList(CcpContestUserInfo record);
}