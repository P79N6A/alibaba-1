package com.culturecloud.dao.micronote;

import java.util.List;

import com.culturecloud.model.bean.micronote.CcpMicronote;
import com.culturecloud.model.request.micronote.CcpMicronoteReqVO;
import com.culturecloud.model.response.micronote.CcpMicronoteResVO;

public interface CcpMicronoteMapper {
    int deleteByPrimaryKey(String noteId);

    int insert(CcpMicronoteReqVO record);

    CcpMicronote selectByPrimaryKey(String noteId);

    int update(CcpMicronoteReqVO record);
    
    List<CcpMicronoteResVO> selectMicronoteList(CcpMicronoteReqVO request);
    
    int selectMicronoteListCount(CcpMicronoteReqVO request);
    
    List<CcpMicronoteResVO> selectMicronoteRankingList(CcpMicronoteReqVO request);
    
    CcpMicronoteResVO selectMicronoteByCondition(CcpMicronoteReqVO request);
    
    /**
     * 根据投票数获取排名
     * @param userId
     * @return
     */
    int selectRankingByVoteCount(Integer voteCount);
}