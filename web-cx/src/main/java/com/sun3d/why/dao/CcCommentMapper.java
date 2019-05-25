package com.sun3d.why.dao;

import java.util.List;

import com.sun3d.why.model.CcComment;

public interface CcCommentMapper {
    int deleteByPrimaryKey(String commentId);

    int insert(CcComment record);

    CcComment selectByPrimaryKey(String commentId);

    int update(CcComment record);
    
    List<CcComment> queryAllCcComment();
}