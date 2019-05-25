package com.sun3d.why.service.volunteer;

import com.sun3d.why.model.volunteer.Volunteer;
import com.sun3d.why.model.volunteer.VolunteerActivity;
import com.sun3d.why.model.volunteer.VolunteerRelation;
import com.sun3d.why.util.Pagination;

import java.util.List;
import java.util.Map;

public interface VolunteerActivityService {

    void addNewVolunteerActivity(VolunteerActivity volunteerActivity);

    List<VolunteerActivity> queryNewVolunteerActivityList(VolunteerActivity volunteerActivity, Pagination page);

    VolunteerActivity queryNewVolunteerActivityById(String uuid);

    void updateNewVolunteerActivity(VolunteerActivity volunteerActivity);

    void auditNewVolunteerActivity(VolunteerActivity volunteerActivity);


    void addVolunteerRelation(VolunteerRelation volunteerRelation);

    void updateVolunteerRelation(VolunteerRelation volunteerRelation);

    List<Volunteer> queryVolunteerListByParam(Map<String, Object> paramMap);

    List<VolunteerRelation> queryVolunteerRelationDetail(VolunteerRelation volunteerRelation);

    void deleteNewVolunteerActivity(Map<String, Object> paramMap);

    List<VolunteerActivity> queryVolunteerActivityByRelationJson(Map<String, Object> paramMap);
}
