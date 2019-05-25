package com.sun3d.why.dao.league;


import com.sun3d.why.model.league.CmsMemberLeague;

import java.util.List;

public interface CmsMemberLeagueMapper {

    int insert(CmsMemberLeague record);

    int insertSelective(List<CmsMemberLeague> list);

    int deleteByMemberId(String memberId);
}