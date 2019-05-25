package com.sun3d.why.service;

import com.sun3d.why.model.CmsComment;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.PaginationApp;

import java.util.List;

public interface CmsCommentService {

    /**
     * 新增评论
     * @param comment 评论对象
     * @return success:成功  failure:失败
     */
    String addComment(CmsComment comment);

    /**
     * 根据id删除评论
     * @param commentId  评论id
     * @return false 失败, true成功
     */
    boolean deleteCommentById(String commentId);

    /**
     * 查询列表页面
     * @param comment 评论对象
     * @param page 网页分页对象
     * @param  sysUser 用户对象
     * @return 评论集合
     */
     List<CmsComment> queryCommentByCondition(CmsComment comment, Pagination page, SysUser sysUser);

    /**
     * 评论列表条数
     * @param comment 评论对象
     * @return 评论个数
     */
    int queryCommentCountByCondition(CmsComment comment);

    /**
     * 前端2.0判断用户评论数小于等于五
     * @param comment 评论对象
     * @return
     */
    int queryCommentCount(CmsComment comment);

    /**
     * 评论3.0列表
     * @param comment
     * @param page
     * @return
     */
    List<CmsComment> queryCmsCommentByCondition(CmsComment comment, Pagination page);

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


    public List<CmsComment> queryMemberComment(String memberId,Integer pageIndex);
}
