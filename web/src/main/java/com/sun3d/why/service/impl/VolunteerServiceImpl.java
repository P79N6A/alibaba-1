package com.sun3d.why.service.impl;


import com.sun3d.why.dao.volunteer.VolunteerMapper;
import com.sun3d.why.model.volunteer.Volunteer;
import com.sun3d.why.service.volunteer.VolunteerService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional
public class VolunteerServiceImpl implements VolunteerService {

    @Autowired
    private VolunteerMapper volunteerMapper;

    /**
     * 新增志愿者
     * @param volunteer
     * @param userId
     * @return
     */
    @Override
    public String SaveVolunteer(Volunteer volunteer, String userId) {
        String result = "";
        volunteer.setUserId(userId);
        volunteer.setUuid(UUIDUtils.createUUId());
        int insert = volunteerMapper.insert(volunteer);

        if(insert > 0){
            result = "success";
        }
        return result;


    }

    /**
     * 修改志愿者
     * @param volunteer
     * @param userId
     * @return
     */
    @Override
    public String UpdateVolunteer(Volunteer volunteer, String userId) {

        String result = "";
        volunteer.setUpdateId(userId);
        volunteer.setUpdateTime(new Date());
        int update = volunteerMapper.updateByPrimaryKey(volunteer);
        if(update>0){
            result = "success";
        }
        return result;

    }

    /**
     * 获取志愿者详情
     * @param uuid
     * @return
     */
    @Override
    public Volunteer queryNewVolunteerById(String uuid) {

        return volunteerMapper.selectByPrimaryKey(uuid);
    }

    /**
     * 获取志愿者列表
     * @return
     */
    @Override
    public List<Volunteer> queryNewVolunteerList(Pagination page) {
        Map<String, Object> queryMap = new HashMap<>();

        if (page != null && page.getFirstResult() != null && page.getRows() != null) {

            // 查询出总数
            int totalVolunteer = volunteerMapper.queryTotalVolunteer(queryMap);
            if(totalVolunteer >14){
                queryMap.put("firstResult", page.getFirstResult());
                queryMap.put("rows", page.getRows());
                page.setTotal(totalVolunteer);
            }
        }
        return volunteerMapper.queryNewVolunteerList(queryMap);


    }

    /**
     * 志愿者审核
     * @return
     */
    @Override
    public String auditNewVolunteer(Volunteer volunteer) {
        String result = "";

        int keySelective = volunteerMapper.updateByPrimaryKeySelective(volunteer);
        if(keySelective >0){
            result = "success";
        }else{
            result = "error";
        }
        return result;
    }

    /**
     * 志愿者退出或删除
     * @param volunteer
     * @param userId
     * @return
     */
    @Override
    public String deleteNewVolunteer(Volunteer volunteer, String userId) {
        String result = "";
        volunteer.setUpdateId(userId);
        volunteer.setUpdateTime(new Date());
        volunteer.setStatus(9);
        int delete = volunteerMapper.updateByPrimaryKey(volunteer);
        if(delete > 0){
            result = "success";
        }
        return result;
    }

    @Override
    public List<Volunteer> queryNewVolunteerListByUserId(String userId) {

        return volunteerMapper.queryNewVolunteerListByUserId(userId);
    }

    /**
     * 查询用户志愿者信息
     * @param userId
     * @return
     */
    @Override
    public List<Volunteer> queryNewVolunteer(String userId,int type) {
        Map<String,Object> map = new HashMap<>();
        map.put("userId",userId);
        map.put("type",type);
        return volunteerMapper.queryNewVolunteer(map);
    }


}
