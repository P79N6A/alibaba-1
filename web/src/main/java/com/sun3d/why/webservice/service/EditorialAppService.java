package com.sun3d.why.webservice.service;

/**
 * Created by Administrator on 2015/7/2.
 */
public interface EditorialAppService {

    /**
     * why3.5 抓取采编库+活动列表
     * @param activityType
     * @param userId
     * @return
     */
    String queryAppEditAndActivityList(String activityType,String userId);

    /**
     *why3.5 app用户报名采编接口
     * @param activityId        采编id
     * @param userId            用户id
     * return 是否报名成功 (成功：success；失败：false)
     */
    String addEditorialUserWantgo(String activityId,String userId);

    /**
     *why3.5 app取消用户报名采编
     * @param activityId  采编id
     * @param userId      用户id
     * @return
     */
    String deleteEditorialUserWantgo(String activityId, String userId);
}
