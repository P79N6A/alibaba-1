package com.sun3d.why.dao;

import com.sun3d.why.model.ActivityEditorial;

import java.util.List;
import java.util.Map;

import com.sun3d.why.util.Pagination;
import org.apache.ibatis.annotations.Param;

public interface ActivityEditorialMapper {
    /**
     * 新增采編信息
     *
     * @param example 採編對象
     * @return 0 失敗 1 成功
     */
    int saveActivityEditorial(ActivityEditorial example);

    /**
     * 修改採編信息
     *
     * @param example 採編對象
     * @return 0 失敗 1 成功
     */
    int editActivityEditorial(ActivityEditorial example);



    /**
     * 根据採編活动对象查询活动列表信息
     *
     * @param map 查詢條件
     * @return 活动采編列表信息
     */
    List<ActivityEditorial> queryActivityEditorialByCondition(Map<String, Object> map);

    /**
     * 根据採編活动对象查询活动列表信息总数
     *
     * @param map 查詢條件
     * @return 活动采編信息条数
     */
    int  queryActivityEditorialCountByCondition(Map<String, Object> map);

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
    int updateStatusByActivityId(String status,String activityId);


    /**
     * 查询是否有重复的活动名称
     * @param activityName  活动名称
     * @return 0 不存在 1 存在
     */
    int isExistsActivityName(String activityName);


    /**
     * 根据活动id查询评级信息
     * @param activityId 活动id
     * @return 评级信息
     */
    String queryEditorialRatingsInfoById(String activityId);

    /**
     *why3.5 抓取采编库+活动列表
     * @param map
     * @return
     */
    List<ActivityEditorial> queryAppEditAndActivityList(Map<String, Object> map);

    /**
     * why3.5 7天内浏览量（UV）最高的活动自动置顶（第一条）
     * @param map
     * @return
     */
    ActivityEditorial queryMaxBrowseCountActivity(Map<String, Object> map);
}