package com.sun3d.why.webservice.service;

import com.sun3d.why.util.PaginationApp;

/**
 * Created by wangkun on 2016/2/17.
 */
public interface UserCollectAppService {
    /**
     * 获取用户活动与展馆收藏列表
     * @param userId 用户id
     * @param activityType 活动类型
     * @param venueType     展馆类型
     * @param activityName  活动名称
     * @param venueName      展馆名称
     * @param pageApp 分页对象
     * @return
     */
    public  String queryAppUserCollectByCondition(String userId, PaginationApp pageApp,int activityType,int venueType,String activityName,String venueName);
}
