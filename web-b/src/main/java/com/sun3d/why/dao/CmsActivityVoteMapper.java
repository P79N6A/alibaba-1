package com.sun3d.why.dao;

import com.sun3d.why.model.CmsActivityVote;

import java.util.List;
import java.util.Map;

public interface CmsActivityVoteMapper {

    /**
     * 查询投票列表List总记录数
     * @para
     * @return int 查询结果总数
     * @authours hucheng
     * @date 2016-2-16
     */
    int queryActivityVoteCountByCondition(Map<String,Object> map);

    /**
     * 查询投票列表分页列表
     * @para Map()查询条件
     * @return List<CmsActivityVote> 投票管理列表集合
     * @authours hucheng
     * @date 2016-2-16
     */
    List<CmsActivityVote> queryActivityVoteByCondition(Map<String,Object> map);

    /**
     * 修改投票信息
     * @param record CmsActivityVote
     * @return int 执行结果 1：成功 0：失败
     */
    int editCmsActivityVote(CmsActivityVote record);

    /**
     * 添加投票信息
     * @para
     * @return int 插入结果
     * @authours hucheng
     * @date 2016-2-16
     */
    int addActivityVote(CmsActivityVote record);

    /**
     * 删除投票信息
     * @para
     * @return int
     * @authours hucheng
     * @date 2016-2-17
     */
    int deleteActivityVote(String voteId);

    /**
     * 删除投票信息
     * @para voteId
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

    /**
     * app查询活动投票信息
     * @param map
     * @return
     */
    List<CmsActivityVote> queryAppUserVoteById(Map<String, Object> map);

    /**
     * app查询活动投票个数
     * @param map
     * @return
     */
    int queryAppUserVoteCountById(Map<String, Object> map);

    CmsActivityVote queryForIndex(Map<String,Object> params);

    Map<String,Object> queryForIndexData(String voteId);


}