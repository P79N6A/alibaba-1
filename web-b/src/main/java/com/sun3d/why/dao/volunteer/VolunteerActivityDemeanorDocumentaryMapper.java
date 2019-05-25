package com.sun3d.why.dao.volunteer;


import com.sun3d.why.model.volunteer.VolunteerActivityDemeanorDocumentary;

import java.util.List;
import java.util.Map;

public interface VolunteerActivityDemeanorDocumentaryMapper {
    int deleteByPrimaryKey(String uuid);

    int insert(VolunteerActivityDemeanorDocumentary record);

    int insertSelective(VolunteerActivityDemeanorDocumentary record);

    VolunteerActivityDemeanorDocumentary selectByPrimaryKey(String uuid);

    int updateByPrimaryKeySelective(VolunteerActivityDemeanorDocumentary record);

    int updateByPrimaryKey(VolunteerActivityDemeanorDocumentary record);

    List<VolunteerActivityDemeanorDocumentary> Documentarylist(String OwnerId);

    int queryTotalDocumentary(Map<String, Object> map);
}