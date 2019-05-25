package com.sun3d.why.service.impl;

import com.sun3d.why.dao.volunteer.VolunteerActivityDemeanorDocumentaryMapper;
import com.sun3d.why.model.volunteer.VolunteerActivityDemeanorDocumentary;
import com.sun3d.why.service.volunteer.VolunteerActivityDemeanorDocumentaryService;
import com.sun3d.why.util.UUIDUtils;
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

    /**
     * 新增活动风采
     * @param documentary
     * @param userId
     * @return
     */
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

    /**
     * 编辑风采
     * @param documentary
     * @param userId
     * @return
     */
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

    /**
     * 删除风采
     * @param documentary
     * @param userId
     * @return
     */
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

    /**
     * 风采纪实列表
     * @param activityId
     * @param volunteerId
     * @param page
     * @return
     */
    @Override
    public List<VolunteerActivityDemeanorDocumentary> Documentarylist(String  OwnerId) {
         return mapper.Documentarylist(OwnerId);

    }

}
