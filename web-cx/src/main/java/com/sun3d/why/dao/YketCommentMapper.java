package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.bean.yket.YketComment;
import com.sun3d.why.model.vo.yket.CommentListVo;

public interface YketCommentMapper {
    int deleteByPrimaryKey(String commentId);

    int insert(YketComment record);

    int insertSelective(YketComment record);

    YketComment selectByPrimaryKey(String commentId);

    int updateByPrimaryKeySelective(YketComment record);

    int updateByPrimaryKey(YketComment record);

	List<YketComment> queryCommentByCondition(Map<String, Object> map);
 

	Integer countComment(Map<String, Object> conds);

	List<YketComment> queryCommentList(Map<String, Object> conds);

	void update(YketComment comment);
	List<CommentListVo> queryCommentByCondition4Front(Map<String, Object> map);
	
	
	 YketComment getPickUpComment(Map<String, Object> map);

 }