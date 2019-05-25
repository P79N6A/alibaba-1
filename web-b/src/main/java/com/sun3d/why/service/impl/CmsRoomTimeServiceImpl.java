package com.sun3d.why.service.impl;

import com.sun3d.why.dao.CmsRoomTimeMapper;
import com.sun3d.why.model.CmsRoomTime;
import com.sun3d.why.service.CmsRoomTimeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Created by cj on 2015/7/3
 */
@Service
@Transactional
public class CmsRoomTimeServiceImpl implements CmsRoomTimeService{

    @Autowired
    private CmsRoomTimeMapper cmsRoomTimeMapper;

    /**
     * 根据活动室时间场次ID获取对应数据
     * @param roomTimeId 活动室场次ID
     * @return
     */
    @Override
    public CmsRoomTime queryRoomTimeById(String roomTimeId) {

        return cmsRoomTimeMapper.queryRoomTimeById(roomTimeId);
    }

    /**
     * 根据活动室时间场次ID删除对应数据
     * @param roomTimeId 活动室场次ID
     * @return
     */
    @Override
    public int deleteRoomTimeById(String roomTimeId) {

        return cmsRoomTimeMapper.deleteRoomTimeById(roomTimeId);
    }



    /**
     * 根据活动室id删除对应时间段记录
     * @param roomId
     * @return
     */
    @Override
    public int deleteByRoomId(String roomId) {

        return cmsRoomTimeMapper.deleteByRoomId(roomId);
    }


    /**
     * 添加活动室时间场次信息
     * @param record 活动室场次信息数据
     * @return
     */
    @Override
    public int addRoomTime(CmsRoomTime record) {

        return cmsRoomTimeMapper.addRoomTime(record);
    }

    /**
     * 编辑活动室时间场次信息
     * @param record 活动室场次信息数据
     * @return
     */
    @Override
    public int editRoomTime(CmsRoomTime record) {

        return cmsRoomTimeMapper.editRoomTime(record);
    }

    /**
     * 根据活动室场次信息查询满足条件的活动室场次列表
     * @param cmsRoomTime 活动室场次信息数据
     * @return
     */
    @Override
    public List<CmsRoomTime> queryRoomTimeByCondition(CmsRoomTime cmsRoomTime) {

        return cmsRoomTimeMapper.queryRoomTimeByCondition(cmsRoomTime);
    }

    /**
     * 根据活动室场次信息查询满足条件的活动室场次总记录数
     * @param cmsRoomTime 活动室场次信息数据
     * @return
     */
    @Override
    public int queryRoomTimeCountByCondition(CmsRoomTime cmsRoomTime) {

        return cmsRoomTimeMapper.queryRoomTimeCountByCondition(cmsRoomTime);
    }

    /**
     * app获取活动室一个星期那几天开放
     * @param cmsRoomTime
     * @return
     */
    @Override
    public CmsRoomTime queryAppRoomTimeByCondition(CmsRoomTime cmsRoomTime) {
        return cmsRoomTimeMapper.queryAppRoomTimeByCondition(cmsRoomTime);
    }

    @Override
    public List<CmsRoomTime> queryAppRoomTimes(CmsRoomTime cmsRoomTime) {

        return cmsRoomTimeMapper.queryAppRoomTimes(cmsRoomTime);
    }
}
