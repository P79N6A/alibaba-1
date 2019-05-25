package com.sun3d.why.dao;

import com.sun3d.why.model.CmsUserVote;

import java.util.List;
import java.util.Map;

public interface CmsUserVoteMapper {

    int insert(CmsUserVote record);

    CmsUserVote queryByMap(Map<String,Object> params);

    int queryCmsUserVoteByVoteIdList(String voteId);


}