package com.sun3d.why.statistics.service.impl;

import com.alibaba.fastjson.JSONObject;
import com.sun3d.why.dao.ActivityStatisticsMapper;
import com.sun3d.why.dao.StatDataMapper;
import com.sun3d.why.dao.StatReactMapper;
import com.sun3d.why.model.ActivityStatistics;
import com.sun3d.why.model.StatData;
import com.sun3d.why.model.StatReact;
import com.sun3d.why.statistics.service.ActivityStatisticsService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.PaginationApp;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.DecimalFormat;
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
}