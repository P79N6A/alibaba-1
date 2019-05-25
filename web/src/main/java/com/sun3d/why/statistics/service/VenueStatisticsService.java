package com.sun3d.why.statistics.service;


import com.sun3d.why.model.VenueStatistics;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.PaginationApp;

import java.util.List;
import java.util.Map;

public interface VenueStatisticsService {



    List<VenueStatistics> queryByArea();

    List<VenueStatistics> queryByAreaRoom(VenueStatistics venueStatistics);

    List<VenueStatistics> queryByTag(VenueStatistics venueStatistics);

    List<VenueStatistics> queryByTagRoom(VenueStatistics venueStatistics);

    List<VenueStatistics> queryByMessage(VenueStatistics venueStatistics, Pagination page);

    /**
     * 查询列表页面
     * @param venueId 评论对象
     * @param page 网页分页对象
     * @param  pageApp app分页对象
     * @return 评论集合
     */
    List<VenueStatistics> queryCommentByVenue(VenueStatistics venueId, Pagination page, PaginationApp pageApp);
    /**
     * 评论列表条数
     * @param comment 评论对象
     * @return 评论个数
     */
    int queryCommentCountByVenue(VenueStatistics comment);
}