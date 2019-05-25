package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.common.Result;
import com.sun3d.why.model.CmsComment;
import com.sun3d.why.model.bean.yket.SysUser;
import com.sun3d.why.model.bean.yket.YketComment;
import com.sun3d.why.model.vo.yket.CommentListVo;
import com.sun3d.why.util.Pagination;

public interface CommentService {

	Result comment(YketComment comment);

	List<YketComment> queryCommentByCondition(YketComment comment, Integer firstResult, Integer rows);

	List<YketComment> queryCommentList(String courseId, Pagination page, String commentType);

	Result handPick(String commentId);

	Result deleteComment(String commentId, SysUser user);

	List<CommentListVo> queryCommentByCondition(String commentType, String objectId, Integer firstResult, Integer rows);


}
