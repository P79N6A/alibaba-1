package com.sun3d.why.dao.league;

import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.league.CmsLeague;
import com.sun3d.why.model.league.CmsLeagueBO;
import org.apache.ibatis.annotations.Select;

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

    @Select("select DISTINCT mr.relation_id,a.activity_id activityId, a.ACTIVITY_NAME activityName," +
            "a.ACTIVITY_CREATE_TIME activityCreateTime from cms_member_relation mr " +
            "left join cms_activity_venue_relevance avr on avr.VENUE_ID = mr.relation_id " +
            "left join cms_activity a on a.ACTIVITY_ID = avr.ACTIVITY_ID and a.ACTIVITY_STATE = 6 and a.activity_is_del = 1 " +
            "where mr.relation_type = 1 and a.activity_id is not null " +
            "order by a.ACTIVITY_CREATE_TIME desc " +
            "LIMIT #{rows}")
    List<CmsActivity> queryActivityByLeague(CmsLeagueBO bo);
}