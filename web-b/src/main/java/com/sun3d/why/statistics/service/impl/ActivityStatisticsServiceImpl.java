package com.sun3d.why.statistics.service.impl;

import com.alibaba.fastjson.JSONObject;
import com.sun3d.why.dao.ActivityStatisticsMapper;
import com.sun3d.why.dao.StatDataMapper;
import com.sun3d.why.dao.StatReactMapper;
import com.sun3d.why.model.*;
import com.sun3d.why.statistics.service.ActivityStatisticsService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.PaginationApp;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@Service
public class ActivityStatisticsServiceImpl implements ActivityStatisticsService {

    @Autowired
    private ActivityStatisticsMapper activityStatisticsMapper;

    @Autowired
    private StatDataMapper statDataMapper;

    @Autowired
    private StatReactMapper statReactMapper;

    @Override
    public int editByActivityStatistics(ActivityStatistics record) {
        return activityStatisticsMapper.editByActivityStatistics(record);
    }

    @Override
    public int addActivityStatistics(ActivityStatistics record) {
        return activityStatisticsMapper.addActivityStatistics(record);
    }

    @Override
    public List<ActivityStatistics> queryByMap(Map map) {
        return activityStatisticsMapper.queryByMap(map);
    }

    @Override
    public List<ActivityStatistics> queryByArea(ActivityStatistics activityStatistics) {
        Map<String, Object> map = new HashMap<String, Object>();
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        if (StringUtils.isNotBlank(activityStatistics.getActivityStartTime())) {
            try {
                map.put("activityStartTime", df.parse(activityStatistics.getActivityStartTime() + " 00:00:00"));
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
        if (StringUtils.isNotBlank(activityStatistics.getActivityEndTime())) {
            try {
                map.put("activityEndTime", df.parse(activityStatistics.getActivityEndTime() + " 23:59:59"));
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
        return activityStatisticsMapper.queryByArea();
    }

    @Override
    public List<ActivityStatistics> queryByBook(ActivityStatistics activityStatistics) {
        Map<String, Object> map = new HashMap<String, Object>();
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        if (StringUtils.isNotBlank(activityStatistics.getActivityStartTime())) {
            try {
                map.put("activityStartTime", df.parse(activityStatistics.getActivityStartTime() + " 00:00:00"));
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
        if (StringUtils.isNotBlank(activityStatistics.getActivityEndTime())) {
            try {
                map.put("activityEndTime", df.parse(activityStatistics.getActivityEndTime() + " 23:59:59"));
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
        return activityStatisticsMapper.queryByBook(map);
    }

    @Override
    public List<ActivityStatistics> queryByTag(ActivityStatistics activityStatistics) {
        Map<String, Object> map = new HashMap<String, Object>();
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        if (StringUtils.isNotBlank(activityStatistics.getActivityStartTime())) {
            try {
                map.put("activityStartTime", df.parse(activityStatistics.getActivityStartTime() + " 00:00:00"));
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
        if (StringUtils.isNotBlank(activityStatistics.getActivityEndTime())) {
            try {
                map.put("activityEndTime", df.parse(activityStatistics.getActivityEndTime() + " 23:59:59"));
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
        return activityStatisticsMapper.queryByTag(map);
    }

    @Override
    public List<ActivityStatistics> queryByMessage(ActivityStatistics activityStatistics, Pagination page, PaginationApp pageApp) throws ParseException {
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        Map<String, Object> map = new HashMap<String, Object>();
        List<ActivityStatistics> CommentList = new ArrayList<ActivityStatistics>();
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        if (StringUtils.isNotBlank(activityStatistics.getActivityStartTime())) {
            try {
                map.put("activityStartTime", df.parse(activityStatistics.getActivityStartTime() + " 00:00:00"));
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
        if (StringUtils.isNotBlank(activityStatistics.getActivityEndTime())) {
            try {
                map.put("activityEndTime", df.parse(activityStatistics.getActivityEndTime() + " 23:59:59"));
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
        Date currentDate = format.parse(format.format(new Date()));
        //网页分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            page.setTotal(activityStatisticsMapper.queryMessageCountByActivity(map));
        }
        CommentList = activityStatisticsMapper.queryByMessage(map);
        if (CommentList.size() > 0) {
            CommentList.get(0).setCommentCount(activityStatisticsMapper.queryCommentCount(map));
        }
        return CommentList;
    }

    /**
     * 查询列表页面
     *
     * @param activityId 评论对象
     * @param page       分页对象
     * @return 评论集合
     */
    @Override
    public List<ActivityStatistics> queryCommentByActivity(ActivityStatistics activityId, Pagination page, PaginationApp pageApp) {
        Map<String, Object> map = new HashMap<String, Object>();
        if (activityId != null) {
            if (activityId.getActivityId() != null) {
                map.put("activityId", activityId.getActivityId());
            }
        }
        //网页分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("activityId", activityId.getActivityId());
            map.put("rows", page.getRows());
            page.setTotal(activityStatisticsMapper.queryCommentCountByActivity(map));
        }
        List<ActivityStatistics> commentList = activityStatisticsMapper.queryCommentByActivity(map);
        return commentList;
    }

    /**
     * 评论列表条数
     *
     * @param comment 评论对象
     * @return 评论个数
     */
    @Override
    public int queryCommentCountByActivity(ActivityStatistics comment) {
        Map<String, Object> map = new HashMap<String, Object>();

        if (StringUtils.isNotBlank(comment.getCommentRkId())) {
            map.put("commentRkId", comment.getCommentRkId());
        }
        return activityStatisticsMapper.queryCommentCountByActivity(map);
    }

    public String queryAllAreaInfo(String type) {
        JSONObject jsonObject = new JSONObject();
        Map map2 = new HashMap();
        if (type != null && StringUtils.isNotBlank(type)) {
            map2.put("statisticsType", type);
        }
        List<ActivityStatistics> activityStatisticsList = activityStatisticsMapper.queryByMap(map2);
        String area = "";
        String count = "";
        String scale = "";
        DecimalFormat df = new DecimalFormat("######0.0000");
        if (activityStatisticsList != null && activityStatisticsList.size() > 0) {
            for (ActivityStatistics bean : activityStatisticsList) {
                area += bean.getArea().split(",")[1] + ",";
                count += bean.getActivityCount() + ",";
                double pre = (double) bean.getPreActivityCount();
                if ((double) bean.getPreActivityCount() == 0) {
                    pre = 1;
                }
                double sc = ((double) ((double) bean.getActivityCount() - (double) bean.getPreActivityCount()) / pre) * 100;
                scale += df.format(sc) + ",";
            }
            area = area.substring(0, area.length() - 1);
            count = count.substring(0, count.length() - 1);
            scale = scale.substring(0, scale.length() - 1);
        }


        jsonObject.put("areas", area);
        jsonObject.put("counts", count);
        jsonObject.put("scales", scale);
        return jsonObject.toJSONString();
    }

    public int deleteBySid(Map map) {
        return activityStatisticsMapper.deleteBySid(map);
    }


    public ActivityStatistics queryBySid(Integer sid, String area) {
        Map map = new HashMap();
        map.put("sid", sid);
        map.put("area", area);
        return activityStatisticsMapper.queryBySid(map);
    }

    public Map queryCountInfo(Map map) {
        return activityStatisticsMapper.queryCountInfo(map);
    }

    /**
     * 活动发布统计
     */
    @Override
    public List<StatData> selectStatDataByAdmin(Map map) {
        String type = (String) map.get("cType");
        if (type.equals("activity")) {
            return statDataMapper.selectByAdmin(map);
        } else {
            return statDataMapper.selectVenueByAdmin(map);
        }
    }

    /**
     * 活动发布统计
     */
    @Override
    public List<StatReact> selectStatReactByAdmin(Map map) {
        return statReactMapper.selectByAdmin(map);
    }

    /**
     * 活动常规统计
     *
     * @param map
     * @return
     */
    @Override
    public List<ActivityRoutineStatistics> activityRoutineStatisticsData(Map map) {
        List<ActivityRoutineStatistics> list = new ArrayList<ActivityRoutineStatistics>();
        try {
            list = activityStatisticsMapper.activityRoutineStatisticsData(map);
            for (ActivityRoutineStatistics b : list) {
                b.setVenueName(StringUtils.isBlank(b.getVenueName()) ? "-" : b.getVenueName());
                b.setCheckOrders(nullTo0(b.getCheckOrders()));
                b.setDeadTickets(nullTo0(b.getDeadTickets()));
                b.setTakeTickets(nullTo0(b.getTakeTickets()));
                b.setCheckTickets(nullTo0(b.getCheckTickets()));
                b.setValidOrders(nullTo0(b.getValidOrders()));
                b.setValidTickets(nullTo0(b.getValidTickets()));
                b.setTickets(nullTo0(b.getTickets()));
                b.setBookPer(accuracy(b.getValidTickets(), b.getTickets(), 2));
                b.setPresentPer(accuracy(b.getCheckTickets(), b.getTickets(), 2));
                b.setTakeTicketsPer(accuracy(b.getTakeTickets(), b.getValidTickets(), 2));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Integer nullTo0(Integer s) {
        if (s == null) return 0;
        return s;
    }

    //方法1
    public static String accuracy(double num, double total, int scale) {
        DecimalFormat df = (DecimalFormat) NumberFormat.getInstance();
        //可以设置精确几位小数
        df.setMaximumFractionDigits(scale);
        //模式 例如四舍五入
        df.setRoundingMode(RoundingMode.HALF_UP);
        Double accuracy_num = num / total * 100;
        if (accuracy_num.isNaN()) accuracy_num = 0.0;
        return df.format(accuracy_num) + "%";
    }

    @Override
    public List<ActivityData> queryAreaData(ActivityData record) {
        Map map = new HashMap();
        if (StringUtils.isNotBlank(record.getActivityStartTime())) {
            map.put("activityStartTime", record.getActivityStartTime() + " 00:00:00");
        }
        if (StringUtils.isNotBlank(record.getActivityEndTime())) {
            map.put("activityEndTime", record.getActivityEndTime() + " 23:59:59");
        }
        if (record.getQueryType()!=null) {
            map.put("queryType",record.getQueryType());
        }
        List<ActivityData> list = activityStatisticsMapper.queryVenueArea(map);
        for (ActivityData activityData : list) {
            map.put("area",activityData.getArea());
            ActivityData data  = activityStatisticsMapper.queryActivityByArea(map);
            activityData.setBookActivityCount(data.getBookActivityCount());
            activityData.setOrderCount(data.getOrderCount());
            activityData.setActivityTicketCount(data.getActivityTicketCount());
            activityData.setOrderTicketCount(data.getOrderTicketCount());
            activityData.setActivityStartTime(record.getActivityStartTime());
            activityData.setActivityEndTime(record.getActivityEndTime());
        }
        return list;
    }

    @Override
    public List<ActivityData> queryLocationData(ActivityData record) {
        Map map = new HashMap();
        if (StringUtils.isNotBlank(record.getActivityStartTime())) {
            map.put("activityStartTime", record.getActivityStartTime() + " 00:00:00");
        }
        if (StringUtils.isNotBlank(record.getActivityEndTime())) {
            map.put("activityEndTime", record.getActivityEndTime() + " 23:59:59");
        }
        if (record.getQueryType()!=null) {
            map.put("queryType",record.getQueryType());
        }
        if (record.getArea()!=null) {
            map.put("dictCode",record.getArea());
        }
        List<ActivityData> list = activityStatisticsMapper.queryActivityLocation(map);
        for (ActivityData activityData : list) {
            map.put("activityLocation",activityData.getDictId());
            ActivityData data  = activityStatisticsMapper.queryActivityByArea(map);
            activityData.setBookActivityCount(data.getBookActivityCount());
            activityData.setOrderCount(data.getOrderCount());
            activityData.setActivityTicketCount(data.getActivityTicketCount());
            activityData.setOrderTicketCount(data.getOrderTicketCount());
            activityData.setActivityStartTime(record.getActivityStartTime());
            activityData.setActivityEndTime(record.getActivityEndTime());
        }
        return list;
    }

    @Override
    public List<ActivityData> queryActivityTypeData(ActivityData record) {
        Map map = new HashMap();
        if (StringUtils.isNotBlank(record.getActivityStartTime())) {
            map.put("activityStartTime", record.getActivityStartTime() + " 00:00:00");
        }
        if (StringUtils.isNotBlank(record.getActivityEndTime())) {
            map.put("activityEndTime", record.getActivityEndTime() + " 23:59:59");
        }
        if (record.getQueryType()!=null) {
            map.put("queryType",record.getQueryType());
        }
        if (record.getArea()!=null) {
            map.put("dictCode", Constant.ACTIVITY_TYPE);
        }
        List<ActivityData> list = activityStatisticsMapper.queryActivityType(map);
        for (ActivityData activityData : list) {
            map.put("activityType",activityData.getDictId());
            ActivityData data  = activityStatisticsMapper.queryActivityByArea(map);
            activityData.setBookActivityCount(data.getBookActivityCount());
            activityData.setOrderCount(data.getOrderCount());
            activityData.setActivityTicketCount(data.getActivityTicketCount());
            activityData.setOrderTicketCount(data.getOrderTicketCount());
            activityData.setActivityStartTime(record.getActivityStartTime());
            activityData.setActivityEndTime(record.getActivityEndTime());
        }
        return list;
    }

    @Override
    public List<ActivityData> queryActivityVenueData(ActivityData record) {
        Map map = new HashMap();
        if (StringUtils.isNotBlank(record.getActivityStartTime())) {
            map.put("activityStartTime", record.getActivityStartTime() + " 00:00:00");
        }
        if (StringUtils.isNotBlank(record.getActivityEndTime())) {
            map.put("activityEndTime", record.getActivityEndTime() + " 23:59:59");
        }
        if (record.getQueryType()!=null) {
            map.put("queryType",record.getQueryType());
        }
        if (record.getDictId()!=null) {
            map.put("venueMood", record.getDictId());
        }
        List<ActivityData> list = activityStatisticsMapper.queryActivityVenue(map);
        for (ActivityData activityData : list) {
            map.put("venueId",activityData.getVenueId());
            ActivityData data  = activityStatisticsMapper.queryActivityByArea(map);
            activityData.setBookActivityCount(data.getBookActivityCount());
            activityData.setOrderCount(data.getOrderCount());
            activityData.setActivityTicketCount(data.getActivityTicketCount());
            activityData.setOrderTicketCount(data.getOrderTicketCount());
            activityData.setActivityStartTime(record.getActivityStartTime());
            activityData.setActivityEndTime(record.getActivityEndTime());
        }
        return list;
    }
}