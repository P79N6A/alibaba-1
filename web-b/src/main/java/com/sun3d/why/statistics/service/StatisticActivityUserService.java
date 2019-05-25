package com.sun3d.why.statistics.service;

import com.sun3d.why.model.ActivityUserStatistics;
import com.sun3d.why.model.CmsCollect;

import java.text.ParseException;

/**
 * Created by Administrator on 2015/5/5.
 * 活动明细表模块处理
 */
public interface StatisticActivityUserService {


   public  int queryActivityStatisticsByType(String type) throws ParseException;

    /**
     * 添加活动用户统计信息
     * @param activityUserStatistics 活动用户统计对象
     */
    int  addActivityUserStatistics(ActivityUserStatistics activityUserStatistics);

    /**
     * 删除收藏活动
     * @param cmsCollect
     */
    public void deleteCmsCollectActivity(CmsCollect cmsCollect);


 /**
  * 根据条件查询用户关系数据
  * @param activityId    活动id
  * @param operateType  操作类型
  * @param userId         用户id
  * @param status        用户身份
  * @return
  */
 int activityUserCountByCondition(String activityId, Integer operateType, String remortIP, String userId, Integer status) throws ParseException;

 /**
  * app添加活动收藏信息
  * @param activityUserStatistics 用户活动统计信息
  * @param userId 用户id
  */
 int addAppActivityUserStatistics(ActivityUserStatistics activityUserStatistics, String userId);

 /**
  * app删除用户活动统计
  */

 int deleteActivityUser(ActivityUserStatistics activityUserStatistics);


}
