package com.sun3d.why.service;

import com.sun3d.why.model.*;
import com.sun3d.why.model.temp.ActivityForCompare;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.PaginationApp;

import java.text.ParseException;
import java.util.Date;
import java.util.List;
import java.util.Map;

public interface CmsActivityEditorialService {

    /**
     * 新增采編信息
     * @param example 採編對象
     * @return false 失敗 true 成功
     */
    boolean saveActivityEditorial(ActivityEditorial example);

    /**
     * 修改採編信息
     * @param example 採編對象
     * @return false 失敗 true 成功
     */
    boolean editActivityEditorial(ActivityEditorial example);


    /**
     * 根据採編活动对象查询活动列表信息
     *
     * @param activityEditorial 活动对象
     * @param page     分页对象
     * @return 活动采編列表信息
     */
    List<ActivityEditorial> queryActivityEditorialByCondition(ActivityEditorial activityEditorial, Pagination page);



    /**
     * 根据主键id查询采编活动信息
     *  @param activityId 主键id
     * @return 活动采编对象
     */
    ActivityEditorial queryActivityEditorialByActivityId(String activityId);


    /**
     * 修改活动状态
     * @param status 状态
     * @param activityId  活动ID
     * @return true 修改成功 ;false 修改失败
     */
    boolean updateStatusByActivityId(String status,String activityId);


    /**
     * 查询是否有重复的活动名称
     * @param activityName  活动名称
     * @return false 不存在 true 存在
     */
    boolean isExistsActivityName(String activityName);


    /**
     * 根据活动id查询评级信息
     * @param activityId 活动id
     * @return 评级信息
     */
    String queryEditorialRatingsInfoById(String activityId);
 }

