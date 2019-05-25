package com.sun3d.why.service.league.impl;


import com.sun3d.why.dao.league.CmsLeagueMapper;
import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.league.CmsLeague;
import com.sun3d.why.model.league.CmsLeagueBO;
import com.sun3d.why.service.league.CmsLeagueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Created by ct on 16/9/28.
 */
@Service
public class CmsLeagueServiceImpl implements CmsLeagueService {


    @Autowired
    private CmsLeagueMapper leagueMapper;


    @Override
    public int deleteByPrimaryKey(String id) {
        return leagueMapper.deleteByPrimaryKey(id);
    }

    @Override
    public int insert(CmsLeague record) {
        return leagueMapper.insert(record);
    }

    @Override
    public int insertSelective(CmsLeague record) {
        return leagueMapper.insertSelective(record);
    }

    @Override
    public CmsLeague selectByPrimaryKey(String id) {
        return leagueMapper.selectByPrimaryKey(id);
    }

    @Override
    public int updateByPrimaryKeySelective(CmsLeague record) {
        return leagueMapper.updateByPrimaryKeySelective(record);
    }

    @Override
    public int updateByPrimaryKey(CmsLeague record) {
        return leagueMapper.updateByPrimaryKeySelective(record);
    }

    @Override
    public List<CmsLeagueBO> queryList(CmsLeagueBO bo) {
        //分页
        if (bo.getFirstResult() != null && bo.getRows() != null) {
            int total = leagueMapper.queryListCount(bo);
            bo.setTotal(total);
        }
        return leagueMapper.queryList(bo);
    }

    @Override
    public List<CmsActivity> queryActivityByLeague(CmsLeagueBO bo){
        return leagueMapper.queryActivityByLeague(bo);
    }

}
