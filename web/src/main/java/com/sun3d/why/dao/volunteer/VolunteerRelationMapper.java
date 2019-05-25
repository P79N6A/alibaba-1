package com.sun3d.why.dao.volunteer;


import com.sun3d.why.model.volunteer.Volunteer;
import com.sun3d.why.model.volunteer.VolunteerRelation;

import java.util.List;
import java.util.Map;

public interface VolunteerRelationMapper {

    void addVolunteerRelation(VolunteerRelation volunteerRelation);

    void updateVolunteerRelation(VolunteerRelation volunteerRelation);

    List<VolunteerRelation> queryVolunteerRelationDetail(VolunteerRelation volunteerRelation);

    List<VolunteerRelation> queryVolunteerRelationList(Map<String, Object> paramMap);

    List<Volunteer> queryVolunteerListByRelation(Map<String, Object> paramMap);
}