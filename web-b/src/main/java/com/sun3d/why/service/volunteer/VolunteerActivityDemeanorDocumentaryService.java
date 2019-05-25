package com.sun3d.why.service.volunteer;

import com.sun3d.why.model.volunteer.VolunteerActivityDemeanorDocumentary;

import java.util.List;

public interface VolunteerActivityDemeanorDocumentaryService {


    String addDocumentary(VolunteerActivityDemeanorDocumentary documentary, String userId);

    String editDocumentary(VolunteerActivityDemeanorDocumentary documentary, String userId);

    String deleteDocumentary(VolunteerActivityDemeanorDocumentary documentary, String userId);

    List<VolunteerActivityDemeanorDocumentary> Documentarylist(String ownerId);
}
