package com.sun3d.why.service;

import com.sun3d.why.model.CmsApplyJoinTeam;
import com.sun3d.why.model.CmsTerminalUser;

public interface CmsApplyJoinTeamService {

    /**
     * 添加团体申请
     * @param applyJoinTeam 团体申请
     * @param terminalUser
     * @return
     */
    String addApplyJoinTeam(CmsApplyJoinTeam applyJoinTeam,CmsTerminalUser terminalUser);

    /**
     * 前端2.0查询该用户是否存在
     * @param applyJoinTeam
     * @return
     */
    int queryApplyJoinTeamCount(CmsApplyJoinTeam applyJoinTeam);

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
     * app根据用户id与团体id获取审核状态
     * @param userId
     * @param teamUserId
     * @param applyCheckState
     * @param applyIsState
     * @return
     */
    Integer queryApplyJoinTeamByStatus(String userId, String teamUserId, Integer applyCheckState, Integer applyIsState);

    /**
     * app判断该用户是否为该团体管理员
     * @param userId
     * @param teamUserId
     * @param i
     * @return
     */
    int queryApplyJoinTeamManage(String userId, String teamUserId, int applyIsState);
}
