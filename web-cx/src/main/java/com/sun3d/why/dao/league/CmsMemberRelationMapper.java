package com.sun3d.why.dao.league;

import com.sun3d.why.model.league.CmsMemberRelation;

import java.util.List;

public interface CmsMemberRelationMapper {
    int insert(CmsMemberRelation record);

    int insertSelective(CmsMemberRelation record);

    void relation(List<CmsMemberRelation> list);

    void cancelRelation(List<CmsMemberRelation> list);
}