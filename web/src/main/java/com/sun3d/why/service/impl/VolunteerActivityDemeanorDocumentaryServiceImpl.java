package com.sun3d.why.service.impl;

import com.sun3d.why.dao.volunteer.VolunteerActivityDemeanorDocumentaryMapper;
import com.sun3d.why.model.volunteer.VolunteerActivityDemeanorDocumentary;
import com.sun3d.why.service.volunteer.VolunteerActivityDemeanorDocumentaryService;
import com.sun3d.why.util.UUIDUtils;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Service
@Transactional
public class VolunteerActivityDemeanorDocumentaryServiceImpl implements VolunteerActivityDemeanorDocumentaryService {
    @Autowired
    private VolunteerActivityDemeanorDocumentaryMapper mapper;


    @Override
    public String addDocumentary(VolunteerActivityDemeanorDocumentary documentary, String userId) {
        String result = "";
        documentary.setCreateId(userId);
        documentary.setUuid(UUIDUtils.createUUId());
        documentary.setStatus(1);
        int insert = mapper.insert(documentary);
        if(insert >0){
            result = "success";
        }else{
            result = "error";
        }
        return result;
    }


    @Override
    public String editDocumentary(VolunteerActivityDemeanorDocumentary documentary, String userId) {
        String result = "";
        documentary.setUpdateId(userId);
        documentary.setUpdateTime(new Date());
        int update = mapper.updateByPrimaryKey(documentary);
        if(update >0){
            result = "success";
        }else{
            result = "error";
        }
        return result;


    }

    @Override
    public String deleteDocumentary(VolunteerActivityDemeanorDocumentary documentary, String userId) {
        String result = "";
        documentary.setUpdateId(userId);
        documentary.setUpdateTime(new Date());

        int update = mapper.updateByPrimaryKey(documentary);
        if(update >0){
            result = "success";
        }else{
            result = "error";
        }
        return result;

    }


    @Override
    public List<VolunteerActivityDemeanorDocumentary> Documentarylist(@Param("ownerId") String  ownerId) {
        //String ownerId = OwnerId;
         return mapper.Documentarylist(ownerId);

    }

    @Override
    public VolunteerActivityDemeanorDocumentary getDetailByownerId(String uuid) {
        return mapper.selectByPrimaryKey(uuid);
    }

}
