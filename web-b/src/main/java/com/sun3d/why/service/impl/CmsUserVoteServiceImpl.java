package com.sun3d.why.service.impl;

import com.sun3d.why.dao.CmsActivityVoteRelevanceMapper;
import com.sun3d.why.dao.CmsUserVoteMapper;
import com.sun3d.why.model.CmsActivityVoteRelevance;
import com.sun3d.why.model.CmsUserVote;
import com.sun3d.why.service.CmsUserVoteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by niubiao on 2016/2/18.
 */
@Service
@Transactional
public class CmsUserVoteServiceImpl implements CmsUserVoteService {

    @Autowired
    private CmsUserVoteMapper cmsUserVoteMapper;

    @Autowired
    private CmsActivityVoteRelevanceMapper cmsActivityVoteRelevanceMapper;

    @Override
    public int insert(CmsUserVote record) {
         Map<String,Object> params = new HashMap<>();
         CmsActivityVoteRelevance cmsActivityVoteRelevance =  cmsActivityVoteRelevanceMapper.queryDataById(record.getVoteRelateId());
         params.put("id",record.getVoteRelateId());
         params.put("voteCount",cmsActivityVoteRelevance.getVoteCount()+1);
         cmsUserVoteMapper.insert(record);
         cmsActivityVoteRelevanceMapper.updateDataById(params);
         return 1;
    }

    @Override
    public CmsUserVote queryByMap(Map<String, Object> params) {
        return cmsUserVoteMapper.queryByMap(params);
    }

    @Override
    public  int queryCmsUserVoteByVoteIdList(String voteId){
        return cmsUserVoteMapper.queryCmsUserVoteByVoteIdList(voteId);
    }
}
