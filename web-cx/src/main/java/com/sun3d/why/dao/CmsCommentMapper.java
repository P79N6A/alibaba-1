package com.sun3d.why.dao;

import com.sun3d.why.model.CmsComment;
import org.apache.ibatis.annotations.Select;
import weibo4j.model.Comment;

import java.util.List;
import java.util.Map;

public interface CmsCommentMapper {
    /**
     * 新增评论
     * @param comment 评论对象
     * @return 0 失败, 1成功
     */
    int addComment(CmsComment comment);

    /**
     * 评论列表
     * @param map
     * @return 评论对象集合
     */
    List<CmsComment> queryCommentByCondition(Map<String, Object> map);

    /**
     * 评论列表条数
     * @param map
     * @return 评论个数
     */
    int queryCommentCountByCondition(Map<String, Object> map);

    /**
     * 根据id删除评论
     * @param commentId  评论id
     * @return 0 失败, 1成功
     */
    int deleteCommentById(String commentId);

    /**
     * 前端2.0判断用户评论数小于等于五
     * @param map
     * @return
     */
    int queryCommentCount(Map<String, Object> map);

    /**
     * 评论3.0列表
     * @param map
     * @return 评论对象集合
     */
    List<CmsComment> queryCmsCommentByCondition(Map<String, Object> map);

    /**
     * 评论3.0条数
     * @param map
     * @return 评论个数
     */
    int queryCmsCommentCountByCondition(Map<String, Object> map);

    /**
     * 评论3.0 更新置顶状态
     * @param comment
     * @return
     */
    int editCommentTopState(CmsComment comment);

    /**
     * 评论3.0 查看详情
     * @param commentId
     * @return
     */
    CmsComment queryCommentById(String commentId);

    /**
     * why3.5 查询个人用户下所有活动评论
     * @param map
     * @return
     */
    List<CmsComment> queryAppActivityCommentByUserId(Map<String, Object> map);

    /**
     * why3.5 查询个人用户下所有场馆评论
     * @param map
     * @return
     */
    List<CmsComment> queryAppVenueCommentByUserId(Map<String, Object> map);

    /**
     * why3.5 场馆及活动详情页评论个数
     * @param map
     * @return
     */
    int queryCmsCommentCount(Map<String, Object> map);

    /**
     * 成员评论
     * @param memberId
     * @return
     */
    List<CmsComment> queryMemberComment(String memberId,Integer pageIndex);

}