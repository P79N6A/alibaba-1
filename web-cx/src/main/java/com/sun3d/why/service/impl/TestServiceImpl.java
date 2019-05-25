package com.sun3d.why.service.impl;

import com.sun3d.why.dao.CmsActivityMapper;
import com.sun3d.why.dao.CmsActivityVenueRelevanceMapper;
import com.sun3d.why.dao.CmsTeamUserMapper;
import com.sun3d.why.dao.CmsVenueMapper;
import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.CmsActivityVenueRelevance;
import com.sun3d.why.model.CmsTeamUser;
import com.sun3d.why.model.CmsVenue;
import com.sun3d.why.service.TestService;
import com.sun3d.why.util.UUIDUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

@Service
@Transactional
public class TestServiceImpl implements TestService {

    @Autowired
    private CmsActivityMapper activityMapper;

    @Autowired
    private CmsVenueMapper venueMapper;

    @Autowired
    private CmsTeamUserMapper teamUserMapper;

    @Autowired
    private CmsActivityVenueRelevanceMapper activityVenueRelevanceMapper;

    @Override
    public void saveActivity(int count) {
        DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm");
       // Date date = new Date();
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DATE, 2);
        for (int i = 0; i < count; i++) {
            CmsActivity activity = new CmsActivity();
            activity.setActivityId(UUIDUtils.createUUId());
            activity.setActivityName("活动名称" + (i + 1));
            activity.setActivityType("314f1b8fd6e04f93b5b067ab19d48ea6,");
            activity.setActivityTel("11111111111");
            activity.setActivityMemo("<p>阿道夫</p>");
            activity.setActivityIconUrl("admin/53/201507/Img/Imgb5c3c370a36242d09c9f82a68ed74e0a.jpg");
            activity.setActivityProvince("44,上海市");
            activity.setActivityCity("45,上海市");
            activity.setActivityArea("45,上海市");
            activity.setActivityAddress("测试地址");
            activity.setActivityLon(1111d);
            activity.setActivityLat(1111d);
            activity.setActivityIsFree(1);
            activity.setActivityPrice("0");
            activity.setActivityIsDetails(2);
            activity.setActivityIsReservation(38);
            activity.setActivityStartTime(format.format(new Date()));
            activity.setActivityEndTime(format.format(cal.getTime()));
            activity.setActivityIsDel(1);
            activity.setActivityState(6);
            activity.setActivityCreateTime(new Date());
            activity.setActivityUpdateTime(new Date());
            activity.setActivityCreateUser("1");
            activity.setActivityUpdateUser("1");
            activity.setActivitySalesOnline("Y");
            activity.setActivityMood("018bff4f1c3f42509f04b39d4556e89d,");
            activity.setActivityCrowd("524cf68bda0a4de0b05a139f0f3ff7a0,");
            activity.setActivityLocation("2ebe9b7ee54048b9bce3364a352e09e9");
            activityMapper.addCmsActivity(activity);

            CmsVenue venue = new CmsVenue();
            venue.setVenueId(UUIDUtils.createUUId());
            venue.setVenueName("场馆名称" + (i + 1));
            venue.setVenueIconUrl("admin/47/201507/Img/Img79c4773f08ce4f899790f83b819d9a4f.jpg");
            venue.setVenueMemo("<p>111111111111</p>");
            venue.setVenueLon(121.321702d);
            venue.setVenueLat(31.193896d);
            venue.setVenueProvince("44,上海市");
            venue.setVenueCity("45,上海市");
            venue.setVenueArea("49,长宁区");
            venue.setVenueAddress("虹桥");
            venue.setVenueOpenTime("04:30");
            venue.setVenueType("760aa13c4a4d4b089dbd76eecf9a529c");
            venue.setVenueLinkman("陈杰");
            venue.setVenueMobile("15601919631");
            venue.setVenueIsFree(1);
            venue.setVenuePrice("100");
            venue.setVenueVideoUrl("admin/49/201507/Audio/Audiod3e60f5be14d47fd8dbad83b9e7f6975.mp3");
            venue.setVenueIsRoam(1);
            venue.setVenueRoamUrl("http://baidu.com");
            venue.setVenueCrowd("3397e04f8cdc4bb8802f096c83e54db3,");
            venue.setVenueMood("fe5fb3ccdfe9481aa57d31caf3f7120e");
            venue.setVenueIsDel(1);
            venue.setVenueState(6);
            venue.setVenueCreateTime(new Date());
            venue.setVenueUpdateTime(new Date());
            venue.setVenueUpdateUser("1");
            venue.setVenueCreateUser("1");
            venue.setVenueDept("1.0");
            venue.setVenueIsReserve(1);
            venue.setVenueEndTime("20:30");
            venue.setVenueMon("2");
            venue.setVenueTue("2");
            venue.setVenueWed("2");
            venue.setVenueThu("2");
            venue.setVenueFri("2");
            venue.setVenueSat("2");
            venue.setVenueSun("2");
            venue.setManagerId("326a204342024f388a9120e3e1d71b1c");
            venue.setOpenNotice("例如：每周天上午8:00-11:30");
            venue.setVenueHasRoom(2);
            venue.setVenueHasAntique(1);
            venueMapper.addVenue(venue);

            CmsActivityVenueRelevance activityVenueRelevance = new CmsActivityVenueRelevance();
            activityVenueRelevance.setActivityId(activity.getActivityId());
            activityVenueRelevance.setVenueId(venue.getVenueId());
            activityVenueRelevanceMapper.addActivityVenueRelevance(activityVenueRelevance);
        }
    }

    @Override
    public void saveVenue(int count) {
        Date date = new Date();
        for (int i = 0; i < count; i++) {
            CmsVenue venue = new CmsVenue();
            venue.setVenueId(UUIDUtils.createUUId());
            venue.setVenueName("场馆名称" + (i + 1));
            venue.setVenueIconUrl("admin/47/201507/Img/Img79c4773f08ce4f899790f83b819d9a4f.jpg");
            venue.setVenueMemo("<p>111111111111</p>");
            venue.setVenueLon(121.321702d);
            venue.setVenueLat(31.193896d);
            venue.setVenueProvince("44,上海市");
            venue.setVenueCity("45,上海市");
            venue.setVenueArea("49,长宁区");
            venue.setVenueAddress("虹桥");
            venue.setVenueOpenTime("04:30");
            venue.setVenueType("760aa13c4a4d4b089dbd76eecf9a529c");
            venue.setVenueLinkman("陈杰");
            venue.setVenueMobile("15601919631");
            venue.setVenueIsFree(1);
            venue.setVenuePrice("100");
            venue.setVenueVideoUrl("admin/49/201507/Audio/Audiod3e60f5be14d47fd8dbad83b9e7f6975.mp3");
            venue.setVenueIsRoam(1);
            venue.setVenueRoamUrl("http://baidu.com");
            venue.setVenueCrowd("3397e04f8cdc4bb8802f096c83e54db3,");
            venue.setVenueMood("fe5fb3ccdfe9481aa57d31caf3f7120e");
            venue.setVenueIsDel(1);
            venue.setVenueState(6);
            venue.setVenueCreateTime(date);
            venue.setVenueUpdateTime(date);
            venue.setVenueUpdateUser("1");
            venue.setVenueCreateUser("1");
            venue.setVenueDept("1.0");
            venue.setVenueIsReserve(1);
            venue.setVenueEndTime("20:30");
            venue.setVenueMon("2");
            venue.setVenueTue("2");
            venue.setVenueWed("2");
            venue.setVenueThu("2");
            venue.setVenueFri("2");
            venue.setVenueSat("2");
            venue.setVenueSun("2");
            venue.setManagerId("326a204342024f388a9120e3e1d71b1c");
            venue.setOpenNotice("例如：每周天上午8:00-11:30");
            venue.setVenueHasRoom(2);
            venue.setVenueHasAntique(1);
            venueMapper.addVenue(venue);
        }
    }

    @Override
    public void saveTeamUser(int count) {
        Date date = new Date();
        for (int i = 0; i < count; i++) {
            CmsTeamUser teamUser = new CmsTeamUser();
            teamUser.setTuserId(UUIDUtils.createUUId());
            teamUser.setTuserName("团体名称" + (i + 1));
            teamUser.setTuserIsVenue(1);
            teamUser.setTuserIsActiviey(1);
            teamUser.setTuserIsDisplay(1);
            teamUser.setTuserProvince("44,上海市");
            teamUser.setTuserCity("45,上海市");
            teamUser.setTuserCounty("48,徐汇区");
            teamUser.setTuserTeamType("2d292cf4dad541ada46dd3567e1bdd06");
            teamUser.setTuserPicture("admin/47/201507/Img/Img891b90eaa2c04899a901c1747b44679c.jpg");
            teamUser.setTuserTeamRemark("<p>dddddddddddddddd</p>");
            teamUser.settCreateUser("1");
            teamUser.settCreateTime(date);
            teamUser.settUpdateUser("1");
            teamUser.settUpdateTime(date);
            teamUser.settDept("1.0");
            teamUser.setTuserLimit(i);
            teamUser.setTuserCrowdTag("129d57c89d5d45528064ea9bd1b04e3e,");
            teamUser.setTuserPropertyTag("641b16dcfd9f4dbaa339da9aacfd50c1,");
            teamUser.setTuserSiteTag("470a8435b58640bfa5afec95a8539541,");
            teamUser.setTuserLocationDict("e4dbd29cf6a645ad8e4ba189cb8a807d");
            teamUserMapper.addCmsTeamUser(teamUser);
        }
    }
}
