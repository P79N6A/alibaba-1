package com.sun3d.why.dao;

import com.sun3d.why.model.CmsRoomTime;

import java.util.List;

public interface CmsRoomTimeMapper {

    /**
     * 根据活动室时间场次ID获取对应数据
     * @param roomTimeId 活动室场次ID
     * @return
     */
    CmsRoomTime queryRoomTimeById(String roomTimeId);

    /**
     * 根据活动室时间场次ID删除对应数据
     * @param roomTimeId 活动室场次ID
     * @return
     */
    int deleteRoomTimeById(String roomTimeId);

    /**
     * 添加活动室时间场次信息
     * @param record 活动室场次信息数据
     * @return
     */
    int addRoomTime(CmsRoomTime record);

    /**
     * 编辑活动室时间场次信息
     * @param record 活动室场次信息数据
     * @return
     */
    int editRoomTime(CmsRoomTime record);


    /**
     * 根据活动室id删除对应时间段记录
     * @param roomId
     * @return
     */
    int deleteByRoomId(String roomId);


    /**
     * 根据活动室场次信息查询满足条件的活动室场次列表
     * @param cmsRoomTime 活动室场次信息数据
     * @return
     */
    List<CmsRoomTime> queryRoomTimeByCondition(CmsRoomTime cmsRoomTime);

    /**
     * 根据活动室场次信息查询满足条件的活动室场次总记录数
     * @param cmsRoomTime 活动室场次信息数据
     * @return
     */
    int queryRoomTimeCountByCondition(CmsRoomTime cmsRoomTime);

    /**
     * app获取活动室哪些天开放
     * @param cmsRoomTime
     * @return
     */
    CmsRoomTime queryAppRoomTimeByCondition(CmsRoomTime cmsRoomTime);
    /**
     * app获取活动室开放时间段
     * @param cmsRoomTime
     * @return
     */
    List<CmsRoomTime> queryAppRoomTimes(CmsRoomTime cmsRoomTime);
}