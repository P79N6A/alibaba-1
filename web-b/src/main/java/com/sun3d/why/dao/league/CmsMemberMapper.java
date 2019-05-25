package com.sun3d.why.dao.league;

import com.sun3d.why.model.league.CmsMember;
import com.sun3d.why.model.league.CmsMemberBO;

import java.util.List;

public interface CmsMemberMapper {
    int deleteByPrimaryKey(String id);

    int insert(CmsMember record);

    int insertSelective(CmsMember record);

    CmsMemberBO selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(CmsMember record);

    int updateByPrimaryKey(CmsMember record);

    int queryListCount(CmsMemberBO bo);

    List<CmsMemberBO> queryList(CmsMemberBO bo);

    List<CmsMemberBO> queryRelationMemberList(CmsMemberBO member);

    int queryRelationMemberListCount(CmsMemberBO member);
}