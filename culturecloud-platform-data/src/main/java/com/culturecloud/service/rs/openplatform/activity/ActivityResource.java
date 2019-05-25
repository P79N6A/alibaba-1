package com.culturecloud.service.rs.openplatform.activity;

import com.culturecloud.annotations.SysBusinessLog;
import com.culturecloud.coreutils.UUIDUtils;
import com.culturecloud.dao.activity.CmsActivityMapper;
import com.culturecloud.exception.BizException;
import com.culturecloud.model.bean.activity.CmsActivity;
import com.culturecloud.model.bean.activity.CmsActivityEvent;
import com.culturecloud.model.bean.activity.CmsActivityVenueRelevance;
import com.culturecloud.model.bean.common.CmsTag;
import com.culturecloud.model.bean.venue.CmsVenue;
import com.culturecloud.model.request.api.ActivityCreateApi;
import com.culturecloud.model.request.api.ActivityCreateVO;
import com.culturecloud.model.response.api.CreateResponseApi;
import com.culturecloud.model.response.api.CreateResponseVO;
import com.culturecloud.service.BaseService;
import com.culturecloud.utils.StringUtils;
import com.culturecloud.utils.UpdateImgUtils;
import com.culturecloud.utils.ali.AliImageUtils;

import org.apache.commons.beanutils.PropertyUtils;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Component
@Path("/api/activity")
public class ActivityResource {
    @Resource
    private BaseService baseService;

    @Resource
    private CmsActivityMapper cmsActivityMapper;
    /**
     * 新增活动
     */
    @POST
    @Path("/create")
    @SysBusinessLog(remark = "新增活动")
    @Produces(MediaType.APPLICATION_JSON)
    @Transactional
    public CreateResponseVO createActivity(ActivityCreateVO activity) throws Exception {
        CreateResponseApi api = new CreateResponseApi();
        List<CreateResponseApi> list = new ArrayList<CreateResponseApi>();
        CmsActivity addAct = new CmsActivity();
        String source = activity.getPlatSource();
        if (StringUtils.isBlank(source)) {
            BizException.Throw("400", "平台来源不能为空");
        }

        for (ActivityCreateApi activityCreateApi : activity.getActivityList()) {

            try {
                PropertyUtils.copyProperties(addAct, activityCreateApi);
            } catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
                e.printStackTrace();
            }
            if (StringUtils.isBlank(addAct.getActivityId())) {
                BizException.Throw("400", "活动ID不能为空");
            } else {
                List<CmsActivity> act = baseService.find(CmsActivity.class, " where SYS_ID='" + activityCreateApi.getActivityId() + "'");
                if (act.size() > 0) {
                    BizException.Throw("400", "活动已存在");
                }
                addAct.setSysNo(source);
                addAct.setSysId(addAct.getActivityId());
                addAct.setActivityId(UUIDUtils.createUUId());
            }
            if (StringUtils.isBlank(addAct.getActivityName())) {
                BizException.Throw("400", "活动名称不能为空");
            }
            if (StringUtils.isBlank(addAct.getActivityArea())) {
                BizException.Throw("400", "活动区域不能为空");
            }
            if (StringUtils.isBlank(addAct.getActivityCity())) {
                BizException.Throw("400", "活动城市不能为空");
            }
            if (StringUtils.isBlank(addAct.getActivityProvince())) {
                BizException.Throw("400", "活动省份不能为空");
            }
            if (StringUtils.isBlank(addAct.getActivityAddress())) {
                BizException.Throw("400", "活动地址不能为空");
            }
            if (addAct.getActivityIsReservation() == null) {
                BizException.Throw("400", "票务情况不能为空");
            }
            if (addAct.getActivityState() == null) {
                addAct.setActivityState(6);
            }
            if (!StringUtils.isBlank(addAct.getActivityType())) {
                List<CmsTag> tag = baseService.find(CmsTag.class, " where TAG_NAME like '%" + addAct.getActivityType() + "%'");
                if (tag.size() == 0) {
                    addAct.setActivityType(null);
                }else{
                    addAct.setActivityType(tag.get(0).getTagId());
                }
            }

            if (StringUtils.isBlank(activityCreateApi.getVenueId())) {
                List<CmsVenue> ven = baseService.find(CmsVenue.class, " where SYS_ID='" + activityCreateApi.getVenueId() + "'");
                if (ven.size() == 0) {
                    BizException.Throw("400", "场馆不存在");
                }
                //创建活动与场馆关系
                CmsActivityVenueRelevance rel = new CmsActivityVenueRelevance();
                rel.setActivityId(activityCreateApi.getActivityId());
                rel.setVenueId(activityCreateApi.getVenueId());
                baseService.create(rel);
            }
            String iconUrl = activityCreateApi.getActivityIconUrl();

            //创建活动封面图
            if (StringUtils.isBlank(iconUrl)) {
                BizException.Throw("400", "活动封面不能为空");
            } else {
                //上传图片，到文化云系统
                String apiFile = UpdateImgUtils.checkImage(iconUrl);
                
                if (!apiFile.equals("success")) {
                    BizException.Throw("400", apiFile);
                }
                
                String imageUrl = AliImageUtils.uploadByInputStream(apiFile,StringUtils.getUUID());
                
                //String imageUrl = UpdateImgUtils.uploadImage(iconUrl, activity.getPlatSource(), "1");
                if (!StringUtils.isBlank(imageUrl)) {
                    addAct.setActivityIconUrl(imageUrl);
                }
            }


            for (CmsActivityEvent event : activityCreateApi.getEventList()) {
                if (StringUtils.isBlank(event.getEventId())) {
                    BizException.Throw("400", "场次ID不能为空");
                }
                event.setEventDateTime(event.getEventEndDate() + " " + event.getEventTime());
                if (org.apache.commons.lang3.StringUtils.isBlank(addAct.getEndTimePoint())) {
                    addAct.setEndTimePoint(event.getEventDateTime());
                } else if (event.getEventDateTime().compareTo(addAct.getEndTimePoint()) > 1) {
                    addAct.setEndTimePoint(event.getEventDateTime());
                }
                event.setActivityId(addAct.getActivityId());
                baseService.create(event);
                list.add(api);
            }
            switch (addAct.getActivityIsReservation()) {
                case (2):
                    addAct.setActivitySalesOnline("N");
                    addAct.setActivityIsReservation(2);
                    if (StringUtils.isBlank(addAct.getSysUrl())) {
                        BizException.Throw("400", "订票跳转链接不能为空");
                    }
                    break;
                case (3):
                    addAct.setActivitySalesOnline("Y");
                    addAct.setActivityIsReservation(2);
                    if (StringUtils.isBlank(addAct.getSysUrl())) {
                        BizException.Throw("400", "订票跳转链接不能为空");
                    }
                    break;
                default:
                    addAct.setActivitySalesOnline("N");
                    addAct.setActivityIsReservation(1);
            }
            addAct.setPublicTime(new Date());
            addAct.setActivityCreateTime(new Date());
            addAct.setActivityCreateUser("1");
            addAct.setActivityUpdateTime(new Date());
            addAct.setActivityUpdateUser("1");
            addAct.setActivityIsDel(1);
            addAct.setActivityDept("1.0");
            addAct.setEndTimePoint(addAct.getActivityEndTime());
            cmsActivityMapper.insertSelective(addAct);
            api.setInputId(activityCreateApi.getActivityId());
            api.setOutputId(addAct.getActivityId());
            list.add(api);
        }
        CreateResponseVO vo = new CreateResponseVO();
        vo.setList(list);

        return vo;
    }


    /**
     * 更改活动
     */
    @POST
    @Path("/update")
    @SysBusinessLog(remark = "更改活动")
    @Produces(MediaType.APPLICATION_JSON)
    public CreateResponseVO updateActivity(ActivityCreateVO activity) throws Exception {

        CmsActivity addAct = new CmsActivity();
        for (ActivityCreateApi activityCreateApi : activity.getActivityList()) {
            try {
                PropertyUtils.copyProperties(addAct, activityCreateApi);
            } catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
                e.printStackTrace();
            }
            if (StringUtils.isBlank(addAct.getActivityId())) {
                BizException.Throw("400", "活动ID不能为空");
            } else {
                List<CmsActivity> act = baseService.find(CmsActivity.class, " where SYS_ID='" + activityCreateApi.getActivityId() + "'");
                if (act.size() == 0) {
                    return this.createActivity(activity);
                }
                addAct.setActivityId(act.get(0).getActivityId());
            }
            if (!StringUtils.isBlank(addAct.getActivityType())) {
                List<CmsTag> tag = baseService.find(CmsTag.class, " where TAG_NAME like '%" + addAct.getActivityType() + "%'");
                if (tag.size() == 0) {
                    addAct.setActivityType(null);
                }else{
                    addAct.setActivityType(tag.get(0).getTagId());
                }
            }
            //创建活动封面图
            if (!StringUtils.isBlank(activityCreateApi.getActivityIconUrl())) {
                //上传图片，到文化云系统
                String apiFile = UpdateImgUtils.checkImage(activityCreateApi.getActivityIconUrl());
                if (!apiFile.equals("success")) {
                    BizException.Throw("400", apiFile);
                }
                String imageUrl = UpdateImgUtils.uploadImage(activityCreateApi.getActivityIconUrl(), activity.getPlatSource(), "1");
                if (!StringUtils.isBlank(imageUrl)) {
                    addAct.setActivityIconUrl(imageUrl);
                }
            }
            if (addAct.getActivityIsReservation() != null) {
                switch (addAct.getActivityIsReservation()) {
                    case (2):
                        addAct.setActivitySalesOnline("N");
                        addAct.setActivityIsReservation(2);
                        break;
                    case (3):
                        addAct.setActivitySalesOnline("Y");
                        addAct.setActivityIsReservation(2);
                        break;
                    default:
                        addAct.setActivitySalesOnline("N");
                        addAct.setActivityIsReservation(1);
                }
            }
            for (CmsActivityEvent event : activityCreateApi.getEventList()) {
                if (StringUtils.isBlank(event.getEventId())) {
                    BizException.Throw("400", "场次ID不能为空");
                }
                event.setEventDateTime(event.getEventEndDate() + " " + event.getEventTime());
                if (org.apache.commons.lang3.StringUtils.isBlank(addAct.getEndTimePoint())) {
                    addAct.setEndTimePoint(event.getEventDateTime());
                } else if (event.getEventDateTime().compareTo(addAct.getEndTimePoint()) > 1) {
                    addAct.setEndTimePoint(event.getEventDateTime());
                }
                event.setActivityId(addAct.getActivityId());
                baseService.update(event, " where EVENT_ID='" + event.getEventId() + "'");
            }
            if (!StringUtils.isBlank(addAct.getActivityType())) {
                List<CmsTag> tag = baseService.find(CmsTag.class, " where TAG_NAME like '%" + addAct.getActivityType() + "%'");
                if (tag.size() == 0) {
                    addAct.setActivityType(null);
                }else{
                    addAct.setActivityType(tag.get(0).getTagId());
                }
            }
            addAct.setActivityUpdateTime(new Date());
           cmsActivityMapper.updateByPrimaryKeySelective(addAct);
        }
        CreateResponseVO vo = new CreateResponseVO();
        return vo;
    }
}
