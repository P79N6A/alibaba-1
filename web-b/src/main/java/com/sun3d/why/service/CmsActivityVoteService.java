package com.sun3d.why.service;

import com.sun3d.why.model.CmsActivityVote;
import com.sun3d.why.util.Pagination;

import java.util.List;
import java.util.Map;

public interface CmsActivityVoteService{

    /**
     * 查询投票列表分页列表
     * @para Map()查询条件
     * @return List<CmsActivityVote> 投票管理列表集合
     * @authours hucheng
     * @date 2016-2-16
     */
    List<CmsActivityVote> queryActivityVoteByCondition(CmsActivityVote cmsActivityVote,Pagination page);

    /**
     * 根据广告主键id来更新模块信息，不判断是否字段为空，更新所有字段
     *
     * @param record CmsActivityVote
     * @return int 执行结果 1：成功 0：失败
     */
    int editCmsActivityVote(CmsActivityVote record,String voteContents,String voteImgUrls);


    /**
     * 添加投票信息
     * @para
     * @return int 插入结果
     * @authours hucheng
     * @date 2016-2-17
     */
    int addActivityVote(CmsActivityVote record,String voteContents,String voteImgUrls);

    /**
     * 删除投票信息
     * @para
     * @return int
     * @authours hucheng
     * @date 2016-2-17
     */
    int deleteActivityVote(String voteId);

    /**
     * 根据主键id查询投票对象
     * @para
     * @return CmsActivityVote
     * @authours hucheng
     * @date 2016-2-17
     */
    CmsActivityVote queryActivityVoteById(String voteId);


    /**
     * 根据投票名称查询投票对象，验证是否重名
     * @para voteTitel
     * @return int
     * @authours hucheng
     * @date 2016-2-22
     */
    CmsActivityVote queryActivityVoteByVoteTitel(String voteTitel);


    List<CmsActivityVote> queryVoteList(Map<String,Object> params);

    CmsActivityVote queryDetailById(String dataId);

    CmsActivityVote queryForIndex(Map<String,Object> params);

    Map<String,Object> queryForIndexData(String voteId);

}