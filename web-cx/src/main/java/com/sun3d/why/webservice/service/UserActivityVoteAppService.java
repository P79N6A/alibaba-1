package com.sun3d.why.webservice.service;

import com.sun3d.why.util.PaginationApp;

/**
 * Created by wangkun on 2016/2/25.
 */
public interface UserActivityVoteAppService {
    /**
     * app查询活动投票信息
     * @param activityId 活动id
     * @return
     */
    public String queryAppUserVoteById(String activityId);

    /**
     * app查询活动投票列表
     * @param activityId 活动id
     * @param pageApp     分页对象
     * @return
     */
    public String queryAppActivityVoteById(String activityId, PaginationApp pageApp);
}
