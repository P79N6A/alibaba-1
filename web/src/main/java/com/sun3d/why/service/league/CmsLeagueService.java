package com.sun3d.why.service.league;

import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.league.CmsLeague;
import com.sun3d.why.model.league.CmsLeagueBO;

import java.util.List;

public interface CmsLeagueService {

    int deleteByPrimaryKey(String id);

    int insert(CmsLeague record);

    int insertSelective(CmsLeague record);

    CmsLeague selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(CmsLeague record);

    int updateByPrimaryKey(CmsLeague record);

    List<CmsLeagueBO> queryList(CmsLeagueBO bo);

    List<CmsActivity> queryActivityByLeague(CmsLeagueBO bo);

}
