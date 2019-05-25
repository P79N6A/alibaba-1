package com.sun3d.why.service.impl;

import com.sun3d.why.dao.CmsApplyJoinTeamMapper;
import com.sun3d.why.model.CmsApplyJoinTeam;
import com.sun3d.why.model.CmsTeamUser;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.service.CmsApplyJoinTeamService;
import com.sun3d.why.service.CmsTeamUserService;
import com.sun3d.why.service.CmsTerminalUserService;
import com.sun3d.why.service.CmsUserMessageService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.UUIDUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Service
@Transactional
public class CmsApplyJoinTeamServiceImpl implements CmsApplyJoinTeamService {

    @Autowired
    private CmsApplyJoinTeamMapper applyJoinTeamMapper;

    @Autowired
    private CmsTerminalUserService terminalUserService;

    @Autowired
    private CmsTeamUserService cmsTeamUserService;

    @Autowired
    private CmsUserMessageService userMessageService;

    private Logger logger = Logger.getLogger(CmsApplyJoinTeamServiceImpl.class);

    /**
     * 添加团体申请
     * @param applyJoinTeam 团体申请
     * @param terminalUser
     * @return
     */
    @Override
    public String addApplyJoinTeam(CmsApplyJoinTeam applyJoinTeam, CmsTerminalUser terminalUser) {
        try{
            Date date = new Date();
            if(applyJoinTeam != null){
                if(terminalUser != null){
                    terminalUserService.updateTerminalUserById(terminalUser);
                }
                applyJoinTeam.setApplyId(UUIDUtils.createUUId());
                applyJoinTeam.setApplyCreateTime(date);
                applyJoinTeam.setApplyUpdateTime(date);
                applyJoinTeam.setApplyTime(date);
                int count1 = applyJoinTeamMapper.addApplyJoinTeam(applyJoinTeam);
                if(count1 > 0){
                    if(terminalUser != null){
                        CmsTerminalUser user = terminalUserService.queryTerminalUserById(terminalUser.getUserId());
                        CmsTeamUser teamUser = cmsTeamUserService.queryTeamUserById(applyJoinTeam.getTuserId());
                        Map<String, Object> map = new HashMap<String, Object>();
                        map.put("userName", user.getUserName());
                        map.put("teamName", teamUser.getTuserName());
                        userMessageService.sendSystemMessage(Constant.TEAM_JOIN_APPLY, map, applyJoinTeam.getUserId());
                    }
                    return Constant.RESULT_STR_SUCCESS;
                }
            }
        }catch (Exception e){
            logger.info("addApplyJoinTeam error" + e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }

    /**
     * 前端2.0查询该用户是否存在
     * @param applyJoinTeam
     * @return
     */
    @Override
    public int queryApplyJoinTeamCount(CmsApplyJoinTeam applyJoinTeam){
        Map<String, Object> map = new HashMap<String, Object>();
        if(StringUtils.isNotBlank(applyJoinTeam.getTuserId())){
            map.put("tuserId", applyJoinTeam.getTuserId());
        }
        if(StringUtils.isNotBlank(applyJoinTeam.getUserId())){
            map.put("userId", applyJoinTeam.getUserId());
        }
        if(applyJoinTeam.getApplyCheckState() != null){
            map.put("applyCheckState", applyJoinTeam.getApplyCheckState());
        }
        if(applyJoinTeam.getApplyIsState() != null){
            map.put("applyIsState", applyJoinTeam.getApplyIsState());
        }
        return applyJoinTeamMapper.queryApplyJoinTeamCount(map);
    }

    /**
     * 前端2.0更新申请
     * @param applyJoinTeam
     * @return
     */
    @Override
    public int editApplyJoinTeamById(CmsApplyJoinTeam applyJoinTeam){
        Date date= new Date();
        applyJoinTeam.setApplyCheckTime(date);
        applyJoinTeam.setApplyUpdateTime(date);
        return applyJoinTeamMapper.editApplyJoinTeamById(applyJoinTeam);
    }

    /**
     * 根据id查询申请表
     * @param applyId
     * @return
     */
    @Override
    public CmsApplyJoinTeam queryApplyJoinTeamById(String applyId){
        return applyJoinTeamMapper.queryApplyJoinTeamById(applyId);
    }

    @Override
    public Integer queryApplyJoinTeamByStatus(String userId, String teamUserId, Integer applyCheckState, Integer applyIsState) {
        Map<String,Object> map=new HashMap<String, Object>();
        if(StringUtils.isNotBlank(userId)){
            map.put("userId", userId);
        }
        if(StringUtils.isNotBlank(teamUserId)){
            map.put("teamUserId",teamUserId);
        }
        if(applyCheckState!=0){
            map.put("applyCheckState",applyCheckState);
        }
        if(applyIsState != 0){
            map.put("applyIsState", applyIsState);
        }
        return applyJoinTeamMapper.queryApplyJoinTeamByStatus(map);
    }

    @Override
    public int queryApplyJoinTeamManage(String userId, String teamUserId, int applyIsState) {
        Map<String,Object> map=new HashMap<String, Object>();
        if(StringUtils.isNotBlank(userId)){
            map.put("userId", userId);
        }
        if(StringUtils.isNotBlank(teamUserId)){
            map.put("teamUserId",teamUserId);
        }
        if(applyIsState != 0){
            map.put("applyIsState", applyIsState);
        }
        return applyJoinTeamMapper.queryApplyJoinTeamManage(map);
    }
}
