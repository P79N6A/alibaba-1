package com.sun3d.why.service.impl;


import com.sun3d.why.dao.volunteer.VolunteerActivityMapper;
import com.sun3d.why.dao.volunteer.VolunteerRelationMapper;
import com.sun3d.why.model.volunteer.Volunteer;
import com.sun3d.why.model.volunteer.VolunteerActivity;
import com.sun3d.why.model.volunteer.VolunteerRelation;
import com.sun3d.why.service.volunteer.VolunteerActivityService;
import com.sun3d.why.util.Pagination;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class VolunteerActivityServiceImpl implements VolunteerActivityService {

    @Autowired
    private VolunteerActivityMapper volunteerActivityMapper;
    @Autowired
    private VolunteerRelationMapper volunteerRelationMapper;

    @Override
    public void addNewVolunteerActivity(VolunteerActivity volunteerActivity) {
        volunteerActivityMapper.addNewVolunteerActivity(volunteerActivity);
    }

    @Override
    public List<VolunteerActivity> queryNewVolunteerActivityList(VolunteerActivity volunteerActivity, Pagination page) {
        //网页分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            volunteerActivity.setFirstResult(page.getFirstResult());
            volunteerActivity.setRows(page.getRows());
            page.setTotal(volunteerActivityMapper.queryNewVolunteerActivityListCount(volunteerActivity));
        }
        return volunteerActivityMapper.queryNewVolunteerActivityList(volunteerActivity);
    }

    @Override
    public VolunteerActivity queryNewVolunteerActivityById(String uuid) {
        return volunteerActivityMapper.queryNewVolunteerActivityById(uuid);
    }

    @Override
    public void updateNewVolunteerActivity(VolunteerActivity volunteerActivity) {
        volunteerActivityMapper.updateNewVolunteerActivity(volunteerActivity);
    }

    @Override
    public void auditNewVolunteerActivity(VolunteerActivity volunteerActivity) {
        volunteerActivityMapper.auditNewVolunteerActivity(volunteerActivity);
    }

    @Override
    public void deleteNewVolunteerActivity(Map<String, Object> paramMap) {
        volunteerActivityMapper.deleteNewVolunteerActivity(paramMap);
    }

    @Override
    public void addVolunteerRelation(VolunteerRelation volunteerRelation) {
        volunteerRelationMapper.addVolunteerRelation(volunteerRelation);
    }

    @Override
    public void updateVolunteerRelation(VolunteerRelation volunteerRelation) {
        volunteerRelationMapper.updateVolunteerRelation(volunteerRelation);
    }

    @Override
    public List<Volunteer> queryVolunteerListByParam(Map<String, Object> paramMap) {
        return volunteerRelationMapper.queryVolunteerListByRelation(paramMap);
    }

    @Override
    public List<VolunteerRelation> queryVolunteerRelationDetail(VolunteerRelation volunteerRelation) {
        return volunteerRelationMapper.queryVolunteerRelationDetail(volunteerRelation);
    }
}
