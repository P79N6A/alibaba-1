package com.sun3d.why.dao;

import com.sun3d.why.model.CmsActivityVoteRelevance;

import java.util.List;
import java.util.Map;

public interface CmsActivityVoteRelevanceMapper {


    /**
     * 添加投票信息关联表记录
     * @para CmsActivityVoteRelevance
     * @return int 插入结果
     * @authours hucheng
     * @date 2016-2-19
     */
    int addCmsActivityVoteRelevance(CmsActivityVoteRelevance cmsActivityVoteRelevance);

    /**
     * 根据投票id查询关联表List
     * @para voteId
     * @return list
     * @authours hucheng
     * @date 2016-2-19
     */
    List<CmsActivityVoteRelevance> queryVoteRelevanceListByVoteId(String voteId);


    int updateDataById(Map<String,Object> params);

    CmsActivityVoteRelevance queryDataById(String id);


    /**
     * 根据voteId删除投票关联表的List记录
     * @para voteId
     * @return int
     * @authours hucheng
     * @date 2016-2-19
     */
    int deleteCmsActivityVoteRelevance(String voteId);


    /**
     * 投票统计
     * @para voteId
     * @return list
     * @authours hucheng
     * @date 2016-2-19
     */
    List<CmsActivityVoteRelevance> queryVoteStatistics(String voteId);

}