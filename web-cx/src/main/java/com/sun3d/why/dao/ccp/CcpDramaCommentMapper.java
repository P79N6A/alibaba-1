package com.sun3d.why.dao.ccp;

import java.util.List;

import com.sun3d.why.model.ccp.CcpDramaComment;

public interface CcpDramaCommentMapper {
    int deleteByPrimaryKey(String dramaCommentId);

    int insert(CcpDramaComment record);

    CcpDramaComment selectByPrimaryKey(String dramaCommentId);

    int update(CcpDramaComment record);
    
    List<CcpDramaComment> queryCcpDramaCommentlist(CcpDramaComment vo);

}