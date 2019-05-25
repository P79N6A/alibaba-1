package com.sun3d.why.service;

import com.sun3d.why.model.CmsUserVote;

import java.util.Map;

/**
 * Created by niubiao on 2016/2/18.
 */
public interface CmsUserVoteService {

    int insert(CmsUserVote record);

    CmsUserVote queryByMap(Map<String,Object> params);

    int queryCmsUserVoteByVoteIdList(String voteId);

}
