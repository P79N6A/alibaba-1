package com.sun3d.why.dao.volunteer;


import com.sun3d.why.model.volunteer.VolunteerActivity;

import java.util.List;
import java.util.Map;

public interface VolunteerActivityMapper {

    void addNewVolunteerActivity(VolunteerActivity volunteerActivity);

    List<VolunteerActivity> queryNewVolunteerActivityList(VolunteerActivity volunteerActivity);

    VolunteerActivity queryNewVolunteerActivityById(String uuid);

    void updateNewVolunteerActivity(VolunteerActivity volunteerActivity);

    void deleteNewVolunteerActivity(Map<String, Object> paramMap);

    void auditNewVolunteerActivity(VolunteerActivity volunteerActivity);

    Integer queryNewVolunteerActivityListCount(VolunteerActivity volunteerActivity);
    Integer countActivity();

}