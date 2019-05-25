package com.sun3d.why.dao;

import com.sun3d.why.model.CmsApplyJoinTeam;

import java.util.Map;

public interface CmsApplyJoinTeamMapper {

    /**
     * 前端2.0添加团体申请
     * @param applyJoinTeam 团体申请对象
     * @return
     */
    int addApplyJoinTeam(CmsApplyJoinTeam applyJoinTeam);

    /**
     * 前端2.0查询该用户是否存在
     * @param map
     * @return
     */
    int queryApplyJoinTeamCount(Map<String, Object> map);

    /**
     * 前端2.0更新申请
     * @param applyJoinTeam
     * @return
     */
    int editApplyJoinTeamById(CmsApplyJoinTeam applyJoinTeam);

    /**
     * 根据id查询申请表
     * @param applyId
     * @return
     */
    CmsApplyJoinTeam queryApplyJoinTeamById(String applyId);

    /**
     * app根据用户或团体id获取审核状态
     * @param map
     * @return
     */
    Integer queryApplyJoinTeamByStatus(Map<String, Object> map);

    /**
     * app判断该用户是否为该团体管理员
     * @param map
     * @return
     */
    int queryApplyJoinTeamManage(Map<String, Object> map);
}