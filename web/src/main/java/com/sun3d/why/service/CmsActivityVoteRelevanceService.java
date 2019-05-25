package com.sun3d.why.service;

import com.sun3d.why.model.CmsActivityVoteRelevance;

import java.util.List;

public interface CmsActivityVoteRelevanceService {


    /**
     * 添加投票信息关联表记录
     * @para CmsActivityVoteRelevance
     * @return int 插入结果
     * @authours hucheng
     * @date 2016-2-19
     */
    int addCmsActivityVoteRelevance(CmsActivityVoteRelevance cmsActivityVoteRelevance);


    /**
     * 投票统计
     * @para voteId
     * @return list
     * @authours hucheng
     * @date 2016-2-19
     */
    List<CmsActivityVoteRelevance> queryVoteStatistics(String voteId);
}