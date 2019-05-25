package com.sun3d.why.dao.league;

import com.sun3d.why.model.league.CmsLeague;
import com.sun3d.why.model.league.CmsLeagueBO;

import java.util.List;

public interface CmsLeagueMapper {
    int deleteByPrimaryKey(String id);

    int insert(CmsLeague record);

    int insertSelective(CmsLeague record);

    CmsLeague selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(CmsLeague record);

    int updateByPrimaryKey(CmsLeague record);

    List<CmsLeagueBO> queryList(CmsLeagueBO bo);

    int queryListCount(CmsLeagueBO bo);
}