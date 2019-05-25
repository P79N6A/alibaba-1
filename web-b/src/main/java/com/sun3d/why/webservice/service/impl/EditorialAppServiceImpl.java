package com.sun3d.why.webservice.service.impl;

import com.sun3d.why.dao.*;
import com.sun3d.why.model.ActivityEditorial;
import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.CmsUserWantgo;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.util.*;
import com.sun3d.why.webservice.service.EditorialAppService;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.SimpleDateFormat;
import java.util.*;

@Transactional
@Service
public class EditorialAppServiceImpl implements EditorialAppService {
    private Logger logger = Logger.getLogger(EditorialAppServiceImpl.class);
    @Autowired
    private ActivityEditorialMapper activityEditorialMapper;
    @Autowired
    private StaticServer staticServer;
    @Autowired
    private CmsUserWantgoMapper cmsUserWantgoMapper;

    /**
     * why3.5 抓取采编库+活动列表
     * @param activityType
     * @param userId
     * @return
     */
    @Override
    public String queryAppEditAndActivityList(String activityType, String userId){
        Map<String, Object> map = new HashMap<String, Object>();
        if(StringUtils.isNotBlank(activityType)){
            map.put("activityType", activityType);
        }
        if(StringUtils.isNotBlank(userId)){
            map.put("userId", userId);
        }

        List<ActivityEditorial> list = new ArrayList<ActivityEditorial>();
        ActivityEditorial activityEditorial = activityEditorialMapper.queryMaxBrowseCountActivity(map);
        if(activityEditorial != null){
            map.put("activityId", activityEditorial.getActivityId());
            list.add(activityEditorial);
        }
        List<ActivityEditorial> editorialList = activityEditorialMapper.queryAppEditAndActivityList(map);
        // 排序(按结束时间升序，如果结束时间相同就按场次)
        Collections.sort(editorialList, new Comparator() {
            public int compare(Object a, Object b) {
                ActivityEditorial one = (ActivityEditorial)a;
                ActivityEditorial two = (ActivityEditorial)b;
                int timeStatus = one.getActivityEndTime().compareTo(two.getActivityEndTime());
                if(timeStatus > 0){
                    return 1;
                }else if(timeStatus < 0){
                    return -1;
                }else{
                    if(one.getType() == 2 && two.getType() == 1){
                        return -1;
                    }else if(one.getType() == 1 && two.getType() == 2){
                        return 1;
                    }else {
                        return 0;
                    }
                }
            }
        });
        list.addAll(editorialList);
        List<Map<String, Object>> mapList = this.getAppActivityResult(list, staticServer);
        if(CollectionUtils.isEmpty(mapList)){
            mapList = new ArrayList<Map<String, Object>>();
        }
        return JSONResponse.toAppResultFormat(100, mapList);
    }

    /**
     * why3.5 公共获取根据条件筛选活动列表
     */
    private List<Map<String, Object>> getAppActivityResult(List<ActivityEditorial> list, StaticServer staticServer) {
        List<Map<String, Object>> listMap = new ArrayList<Map<String, Object>>();
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        try {
            if (CollectionUtils.isNotEmpty(list)) {
                for (ActivityEditorial editorial : list) {
                    Map<String, Object> map = new HashMap<String, Object>();
                    map.put("type", editorial.getType() != null ? editorial.getType() : 1);
                    map.put("activityName", StringUtils.isNotBlank(editorial.getActivityName()) ? editorial.getActivityName() : "");
                    map.put("activityId", StringUtils.isNotBlank(editorial.getActivityId()) ? editorial.getActivityId() : "");
                    map.put("activityIsReservation", editorial.getActivityIsReservation() != null ? editorial.getActivityIsReservation() : "");
                    map.put("activityIsFree", editorial.getActivityIsFree() != null ? editorial.getActivityIsFree() : 1);
                    map.put("activityPrice", StringUtils.isNotBlank(editorial.getActivityPrice()) ? editorial.getActivityPrice() : "");
                    map.put("tagName", StringUtils.isNotBlank(editorial.getTagName()) ? editorial.getTagName() : "");
                    map.put("activitySubject", StringUtils.isNotBlank(editorial.getActivitySubject()) ? editorial.getActivitySubject() : "");
                    map.put("activityAddress", StringUtils.isNotBlank(editorial.getActivityAddress()) ? editorial.getActivityAddress() : "");
                    map.put("activityStartTime", editorial.getActivityStartTime() != null ? format.format(editorial.getActivityStartTime()) : "");
                    map.put("activityEndTime", editorial.getActivityEndTime() != null ? format.format(editorial.getActivityEndTime()) : "");
                    map.put("eventTime", StringUtils.isNotBlank(editorial.getEventTime()) ? editorial.getEventTime() : "");
                    map.put("activityTimeDes", StringUtils.isNotBlank(editorial.getActivityTimeDes()) ? editorial.getActivityTimeDes() : "");
                    map.put("activityMemo", StringUtils.isNotBlank(editorial.getActivityMemo()) ? editorial.getActivityMemo() : "");
                    map.put("activityIconUrl", StringUtils.isNotBlank(editorial.getActivityIconUrl()) ? staticServer.getStaticServerUrl() + editorial.getActivityIconUrl() : "");
                    map.put("count", editorial.getCount() != null ? editorial.getCount() : 0);
                    map.put("activityTel", StringUtils.isNotBlank(editorial.getActivityTel()) ? editorial.getActivityTel() : "");
                    map.put("activityUrl", StringUtils.isNotBlank(editorial.getActivityUrl()) ? editorial.getActivityUrl() : "");
                    map.put("isLike", editorial.getIsLike() != null ? editorial.getIsLike() : 0);
                    listMap.add(map);
                }
            }
            return listMap;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return listMap;
    }

    /**
     *why3.5 app用户报名采编接口
     *
     * @param activityId 活动id
     * @param userId     用户id
     * return 是否报名成功 (成功：success；失败：false)
     */
    @Override
    public String addEditorialUserWantgo(String activityId, String userId) {
        CmsUserWantgo userWantgo = new CmsUserWantgo();
        userWantgo.setRelateId(activityId);
        userWantgo.setUserId(userId);
        int status = cmsUserWantgoMapper.queryAppUserWantCountById(userWantgo);
        if (status > 0) {
            return JSONResponse.toAppResultFormat(14111, "该用户已报名该采编活动,不可重复报名");
        }
        userWantgo.setSid(UUIDUtils.createUUId());
        userWantgo.setCreateTime(new Date());
        userWantgo.setRelateType(Constant.WANT_GO_EDITORIAL);
        int flag = cmsUserWantgoMapper.addUserWantgo(userWantgo);
        if (flag > 0) {
            return JSONResponse.toAppResultFormat(0, "用户报名成功");
        } else {
            return JSONResponse.toAppResultFormat(1, "用户报名失败");
        }
    }

    /**
     *why3.5 app取消用户报名采编
     *
     * @param activityId 采编id
     * @param userId     用户id
     * @return
     */
    @Override
    public String deleteEditorialUserWantgo(String activityId, String userId) {
        CmsUserWantgo userWantgo = new CmsUserWantgo();
        userWantgo.setRelateId(activityId);
        userWantgo.setUserId(userId);
        int flag = cmsUserWantgoMapper.deleteUserWantgo(userWantgo);
        if (flag > 0) {
            return JSONResponse.toAppResultFormat(0, "用户取消报名成功");
        } else {
            return JSONResponse.toAppResultFormat(1, "用户取消报名失败");
        }
    }
}