package com.sun3d.why.service.volunteer;

import com.sun3d.why.model.volunteer.Volunteer;
import com.sun3d.why.util.Pagination;

import java.util.List;

public interface VolunteerService {

    String SaveVolunteer(Volunteer volunteer, String userId);

    String UpdateVolunteer(Volunteer volunteer, String userId);

    Volunteer queryNewVolunteerById(String uuid);

    List<Volunteer> queryNewVolunteerList(Pagination page);

    String auditNewVolunteer(Volunteer volunteer);

    String deleteNewVolunteer(Volunteer volunteer, String userId);

    List<Volunteer> queryNewVolunteerListByUserId(String userId);

    List<Volunteer> queryNewVolunteer(String userId, int type);
}
