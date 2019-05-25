package com.sun3d.why.webservice.service;

import com.sun3d.why.model.CmsComment;
import com.sun3d.why.util.PaginationApp;

import java.util.List;
import java.util.Map;

/**
 * 评论
 */
public interface CommentAppService {
    /**
     * 查看某一类型评论
     * @param moldId     类型id
     * @param type       评论类型 1.展馆 2.活动 3.藏品 4.专题 5.会员 6.团体 7.活动室
     * @return
     */
    public String queryAppCommentByCondition(String moldId, String type,PaginationApp pageApp);

    /**
     * app添加评论
     * @param comment 评论对象
     * @return
     */
    public String addComment(CmsComment comment);

    /**
     * why3.5 查询个人用户下所有活动评论
     * @param pageApp
     * @param userId
     * @return
     */
    String queryAppActivityCommentByUserId(PaginationApp pageApp, String userId);

    /**
     * why3.5 查询个人用户下所有场馆评论
     * @param pageApp
     * @param userId
     * @return
     */
    String queryAppVenueCommentByUserId(PaginationApp pageApp, String userId);

    /**
     * why3.5 根据id删除评论
     * @param commentId
     * @return
     */
    String deleteAppCommentById(String commentId);
}
