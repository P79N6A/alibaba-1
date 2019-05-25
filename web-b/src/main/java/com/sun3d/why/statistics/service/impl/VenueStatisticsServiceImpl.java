package com.sun3d.why.statistics.service.impl;

import com.alibaba.fastjson.JSONObject;
import com.sun3d.why.dao.VenueStatisticsMapper;
import com.sun3d.why.model.VenueStatistics;
import com.sun3d.why.statistics.service.VenueStatisticsService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.PaginationApp;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Service
public class VenueStatisticsServiceImpl implements VenueStatisticsService{
    @Autowired
    private VenueStatisticsMapper venueStatisticsMapper;

    @Override
    public List<VenueStatistics> queryByArea() {
        return venueStatisticsMapper.queryByArea();
    }

    @Override
    public List<VenueStatistics> queryByAreaRoom(VenueStatistics venueStatistics) {
        Map<String, Object> map = new HashMap<String, Object>();
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        if(StringUtils.isNotBlank(venueStatistics.getActivityStartTime())){
            try {
                map.put("activityStartTime",df.parse(venueStatistics.getActivityStartTime() + " 00:00:00"));
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
        if(StringUtils.isNotBlank(venueStatistics.getActivityEndTime())){
            try {
                map.put("activityEndTime",df.parse(venueStatistics.getActivityEndTime() + " 23:59:59"));
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
        return venueStatisticsMapper.queryByAreaRoom(map);}

    @Override
    public List<VenueStatistics> queryByTag(VenueStatistics venueStatistics) {
        Map<String, Object> map = new HashMap<String, Object>();
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        if(StringUtils.isNotBlank(venueStatistics.getActivityStartTime())){
            try {
                map.put("activityStartTime",df.parse(venueStatistics.getActivityStartTime() + " 00:00:00"));
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
        if(StringUtils.isNotBlank(venueStatistics.getActivityEndTime())){
            try {
                map.put("activityEndTime",df.parse(venueStatistics.getActivityEndTime() + " 23:59:59"));
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
        return venueStatisticsMapper.queryByTag(map);}

    @Override
    public List<VenueStatistics> queryByTagRoom(VenueStatistics venueStatistics) {
        Map<String, Object> map = new HashMap<String, Object>();
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        if(StringUtils.isNotBlank(venueStatistics.getActivityStartTime())){
            try {
                map.put("activityStartTime",df.parse(venueStatistics.getActivityStartTime() + " 00:00:00"));
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
        if(StringUtils.isNotBlank(venueStatistics.getActivityEndTime())){
            try {
                map.put("activityEndTime",df.parse(venueStatistics.getActivityEndTime() + " 23:59:59"));
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }

        return venueStatisticsMapper.queryByTagRoom(map);}

    @Override
    public List<VenueStatistics> queryByMessage(VenueStatistics venueStatistics, Pagination page) {
        Map<String, Object> map = new HashMap<String, Object>();
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        List<VenueStatistics> CommentList = new ArrayList<VenueStatistics>();
        if(StringUtils.isNotBlank(venueStatistics.getActivityStartTime())){
            try {
                map.put("activityStartTime",df.parse(venueStatistics.getActivityStartTime() + " 00:00:00"));
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
        if(StringUtils.isNotBlank(venueStatistics.getActivityEndTime())){
            try {
                map.put("activityEndTime",df.parse(venueStatistics.getActivityEndTime() + " 23:59:59"));
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
        //网页分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("rows", page.getRows());
            page.setTotal(venueStatisticsMapper.queryByMessageCount(map));
        }
        CommentList =venueStatisticsMapper.queryByMessage(map);
        if(CommentList.size()>0){
            CommentList.get(0).setCommentCount(venueStatisticsMapper.queryCommentCount(map));
        }
        return CommentList;
    }


    /**
     * 查询列表页面
     * @param venueId 评论对象
     * @param page 分页对象
     * @return 评论集合
     */
    @Override
    public List<VenueStatistics> queryCommentByVenue(VenueStatistics venueId, Pagination page,PaginationApp pageApp) {
        Map<String, Object> map = new HashMap<String, Object>();
        if(venueId != null){
            if(venueId.getVenueId() != null){
                map.put("venueId", venueId.getVenueId());
            }
        }
        //网页分页
        if (page != null && page.getFirstResult() != null && page.getRows() != null) {
            map.put("firstResult", page.getFirstResult());
            map.put("venueId", venueId.getVenueId());
            map.put("rows", page.getRows());
            page.setTotal(venueStatisticsMapper.queryCommentCountByVenue(map));
        }
        List<VenueStatistics> commentList =  venueStatisticsMapper.queryCommentByVenue(map);
        return commentList;
    }

    @Override
    public int queryCommentCountByVenue(VenueStatistics comment) {
        return 0;
    }

}