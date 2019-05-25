package com.culturecloud.service.rs.platformservice.contest;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;

import com.culturecloud.annotations.SysBusinessLog;
import com.culturecloud.aop.ExceptionDisplay;
import com.culturecloud.coreutils.UUIDUtils;
import com.culturecloud.dao.contest.CcpContestUserInfoMapper;
import com.culturecloud.enumeration.common.IntegralTypeEnum;
import com.culturecloud.exception.BizException;
import com.culturecloud.model.bean.common.CmsTerminalUser;
import com.culturecloud.model.bean.common.SysUserIntegral;
import com.culturecloud.model.bean.common.SysUserIntegralDetail;
import com.culturecloud.model.bean.contest.CcpContestUserInfo;
import com.culturecloud.model.request.contest.ContestUserInfoVO;
import com.culturecloud.model.response.contest.CcpContestUserInfoVO;
import com.culturecloud.model.response.contest.JoinUserInfoVO;
import com.culturecloud.model.response.contest.TopHelpInfoVO;
import com.culturecloud.model.response.contest.TopHelpListVO;
import com.culturecloud.service.BaseService;

/**
 * 用户相关信息 resource
 */
@Component
@Path("/contestUserInfo")
public class CcpContestUserInfoResource {
    @Resource
    private BaseService baseService;
    @Resource
    private CcpContestUserInfoMapper ccpContestUserInfoMapper;
    /**
     * 查询用户信息
     *
     * @param contestUserInfoVO
     * @return
     */
    @POST
    @Path("/getContestUserResult")
    @SysBusinessLog(remark = "查询用户主题答题情况")
    @Produces(MediaType.APPLICATION_JSON)
    public CcpContestUserInfoVO getContestUserResult(ContestUserInfoVO contestUserInfoVO) {
        List<CcpContestUserInfo> userList = baseService.find(CcpContestUserInfo.class, "where user_id='" + contestUserInfoVO.getUserId() + "' and contest_system_type='" + contestUserInfoVO.getContestSystemType() + "'");
        CmsTerminalUser terUser = baseService.findById(CmsTerminalUser.class, contestUserInfoVO.getUserId());
        CcpContestUserInfoVO user = new CcpContestUserInfoVO();
        CcpContestUserInfo addUser = new CcpContestUserInfo();
        String num = "";
        if (userList.size() > 0) {
            addUser = userList.get(0);
            Date now = new Date();
            if (addUser.getLastLoginTime()==null|| !this.isSameDate(addUser.getLastLoginTime(), now)){
            		
            		if(addUser.getLastLoginTime()!=null){
                    addUser.setHelpUserId("1");
                    addUser.setChanceTemporaryNumber(5);
            		}
            		
            		addUser.setLastLoginTime(now);
                    baseService.update(addUser, "where user_id='" + contestUserInfoVO.getUserId() + "'");
            	
            	
            }
            try {
                PropertyUtils.copyProperties(user, addUser);
            } catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
                e.printStackTrace();
            }
            num = Integer.toBinaryString(addUser.getContestScore());
        } else {
            addUser.setContestUserId(UUIDUtils.createUUId());
            addUser.setUserId(contestUserInfoVO.getUserId());
            addUser.setContestScore(0);
            addUser.setContestResult(0);
            addUser.setHelpNumber(0);
            addUser.setChancePermanentNumber(0);
            addUser.setChanceTemporaryNumber(5);
            addUser.setContestSystemType(contestUserInfoVO.getContestSystemType());
            addUser.setCreateTime(new Date());
            addUser.setHelpUserId("1");
            addUser.setUserName(terUser.getUserName());
            addUser.setShareHelpImg(terUser.getUserHeadImgUrl());
            addUser.setShareSuccessImg(terUser.getUserHeadImgUrl());
            baseService.create(addUser);
            num = Integer.toBinaryString(0);
            try {
                PropertyUtils.copyProperties(user, addUser);
            } catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
                e.printStackTrace();
            }
        }
        user.setContestScores(this.addIntegralString(num));
        return user;
    }

    /**
     * 查询用户信息
     *
     * @param contestUserInfoVO
     * @return
     */
    @POST
    @Path("/getEditUser")
    @SysBusinessLog(remark = "编辑用户信息")
    @Produces(MediaType.APPLICATION_JSON)
    public String getEditUser(ContestUserInfoVO contestUserInfoVO) {
        List<CcpContestUserInfo> userList = baseService.find(CcpContestUserInfo.class, "where user_id='" + contestUserInfoVO.getUserId() + "' and contest_system_type='" + contestUserInfoVO.getContestSystemType() + "'");
        CcpContestUserInfo user = userList.get(0);
        Integer success = 1;
        
      
        
        if (StringUtils.isNotBlank(contestUserInfoVO.getHelpuserId())) {
            if (user.getHelpUserId().indexOf(contestUserInfoVO.getHelpuserId()) > 0) {
                BizException.Throw("400", "用户已经助力过");
            } else {
                user.setHelpUserId(user.getHelpUserId() + "," + contestUserInfoVO.getHelpuserId());
                user.setChanceTemporaryNumber(user.getChanceTemporaryNumber() + 1);
                user.setHelpNumber(user.getHelpNumber() + 1);
                
                Calendar now = Calendar.getInstance();  
                
               int y=now.get(Calendar.YEAR);
               
               int m=now.get(Calendar.MONTH) + 1;
               
               if(y>=2016&&m>10)
                BizException.Throw(ExceptionDisplay.display.getValue(),"活动已结束，不能助力了");
            }
        }
        if (contestUserInfoVO.getContestScores() != null) {
            Integer[] result = this.addIntegralString(Integer.toBinaryString(user.getContestScore()));
            if (result[contestUserInfoVO.getContestScores()] == 0) {
                result[contestUserInfoVO.getContestScores()] = 1;
                user.setChancePermanentNumber(user.getChancePermanentNumber() + 1);
            }
            for (int i : result) {
                if (i == 0) {
                    success = 0;
                }
            }
            user.setContestScore(this.addIntegralArray(result));
            if (success == 1 && user.getSuccessRanking()==null) {
                List<CcpContestUserInfo> userSuccess = baseService.find(CcpContestUserInfo.class, "where success_ranking > 0");
                user.setSuccessTime(new Date());
                if (userSuccess != null) {
                    user.setSuccessRanking(userSuccess.size() + 1);
                } else {
                    user.setSuccessRanking(1);
                }
            }
        }

        if (StringUtils.isNotBlank(contestUserInfoVO.getShareSuccessImg())) {
            user.setShareSuccessImg(contestUserInfoVO.getShareSuccessImg());
        }
        if (StringUtils.isNotBlank(contestUserInfoVO.getShareHelpImg())) {
            user.setShareHelpImg(contestUserInfoVO.getShareHelpImg());
        }
        if (StringUtils.isNotBlank(contestUserInfoVO.getUserTelephone())) {
            user.setUserTelephone(contestUserInfoVO.getUserTelephone());
        }
        if (StringUtils.isNotBlank(contestUserInfoVO.getUserName())) {
            user.setUserName(contestUserInfoVO.getUserName());
        }
        if (contestUserInfoVO.getContestResult() != null) {
            user.setContestResult(contestUserInfoVO.getContestResult());
            user.setSuccessTime(new Date());
        }
        baseService.update(user, "where user_id='" + contestUserInfoVO.getUserId() + "' and contest_system_type='" + contestUserInfoVO.getContestSystemType() + "'");
        return "success";
    }

    /**
     * 查询参与用户信息
     *
     * @param contestUserInfoVO
     * @return
     */
    @POST
    @Path("/getJoinUserInfo")
    @SysBusinessLog(remark = "查询参与用户信息")
    @Produces(MediaType.APPLICATION_JSON)
    public JoinUserInfoVO getJoinUserInfo(ContestUserInfoVO contestUserInfoVO) {
        if (contestUserInfoVO.getContestSystemType() == null) {
            BizException.Throw("400", "请发送答题类型");
        }
        JoinUserInfoVO info = new JoinUserInfoVO();
        List<CcpContestUserInfo> totalUserList = baseService.find(CcpContestUserInfo.class, "where contest_system_type='" + contestUserInfoVO.getContestSystemType() + "'");
        List<CcpContestUserInfo> finishUserList = baseService.find(CcpContestUserInfo.class, "where contest_system_type='" + contestUserInfoVO.getContestSystemType() + "' and contest_result='1'");
        List<CcpContestUserInfo> todayFinishUserList = baseService.find(CcpContestUserInfo.class, "where contest_system_type='" + contestUserInfoVO.getContestSystemType() + "' and contest_result='1' and success_time > curdate()");
        info.setTotalUserCount(totalUserList.size());
        info.setFinishUserCount(finishUserList.size());
        info.setTodayFinishUserCount(todayFinishUserList.size());
        return info;
    }

    /**
     * 查询参与用户信息
     *
     * @param contestUserInfoVO
     * @return
     */
    @POST
    @Path("/getTopHelpList")
    @SysBusinessLog(remark = "查询参与用户信息")
    @Produces(MediaType.APPLICATION_JSON)
    public TopHelpListVO getTopHelpList(ContestUserInfoVO contestUserInfoVO) {
        if (contestUserInfoVO.getContestSystemType() == null) {
            BizException.Throw("400", "请发送答题类型");
        }
        List<CcpContestUserInfo> user = baseService.find(CcpContestUserInfo.class, "where user_id='" + contestUserInfoVO.getUserId() + "' and contest_system_type='" + contestUserInfoVO.getContestSystemType() + "'limit 1");
        int b = ccpContestUserInfoMapper.selectTop(user.get(0));
        List<CcpContestUserInfo> userTop = ccpContestUserInfoMapper.selectTopList(user.get(0));
        TopHelpListVO response = new TopHelpListVO();
        TopHelpInfoVO info = new TopHelpInfoVO();
        List<TopHelpInfoVO> infoList = new ArrayList<>();
        CmsTerminalUser terUser1 = baseService.findById(CmsTerminalUser.class, user.get(0).getUserId());
        info.setHelpCount(user.get(0).getHelpNumber());
        info.setName(terUser1.getUserName());
        info.setRanking(b+1);
        info.setHeadImg(terUser1.getUserHeadImgUrl());
        response.setUserRank(info);
        for (int i = 0; i < userTop.size(); i++) {
            info = new TopHelpInfoVO();
            info.setHelpCount(userTop.get(i).getHelpNumber());
            info.setName(userTop.get(i).getUserName());
            info.setHeadImg(userTop.get(i).getShareSuccessImg());
            info.setRanking(i + 1);
            infoList.add(info);
        }
        response.setTopRank(infoList);
        return response;
    }


    @POST
    @Path("/usedChance")
    @SysBusinessLog(remark = "减次数")
    @Produces(MediaType.APPLICATION_JSON)
    public String usedChance(ContestUserInfoVO contestUserInfoVO) {
        List<CcpContestUserInfo> users = baseService.find(CcpContestUserInfo.class, "where user_id='" + contestUserInfoVO.getUserId() + "' and contest_system_type='" + contestUserInfoVO.getContestSystemType() + "'");
        CcpContestUserInfo user = users.get(0);
        if (user.getChanceTemporaryNumber() > 0) {
            user.setChanceTemporaryNumber(user.getChanceTemporaryNumber() - 1);
        } else if (user.getChancePermanentNumber() > 0) {
            user.setChancePermanentNumber(user.getChancePermanentNumber() - 1);
        } else {
            BizException.Throw("400", "机会不足");
        }
        baseService.update(user, "where user_id='" + contestUserInfoVO.getUserId() + "' and contest_system_type='" + contestUserInfoVO.getContestSystemType() + "'");
        if (contestUserInfoVO.getCodeCount() != null) {
            this.addIntegral(contestUserInfoVO);
        }
        return "success";
    }


    @POST
    @Path("/getGift")
    @SysBusinessLog(remark = "领取礼物")
    @Produces(MediaType.APPLICATION_JSON)
    public Integer getGift(ContestUserInfoVO contestUserInfoVO) {
        List<CcpContestUserInfo> users = baseService.find(CcpContestUserInfo.class, "where user_id='" + contestUserInfoVO.getUserId() + "' and contest_system_type='" + contestUserInfoVO.getContestSystemType() + "'");
        CcpContestUserInfo user = users.get(0);
        baseService.update(user, "where user_id='" + contestUserInfoVO.getUserId() + "' and contest_system_type='" + contestUserInfoVO.getContestSystemType() + "'");
        int a = 0;
        if (user.getSuccessRanking() < 500) {
            a = 80;
        } else if (user.getSuccessRanking() < 1000) {
            a = 50;
        } else if (user.getSuccessRanking() < 5000) {
            a = 5;
        } else {
            a = 0;
        }
        return a;
    }

    public String addIntegral(ContestUserInfoVO contestUserInfoVO) {

        List<SysUserIntegral> userIntegrals = baseService.find(SysUserIntegral.class, " where user_id='" + contestUserInfoVO.getUserId() + "'");
        SysUserIntegral userIntegral = userIntegrals.get(0);
        userIntegral.setIntegralNow(userIntegral.getIntegralNow() + contestUserInfoVO.getCodeCount());
        baseService.update(userIntegral, "where user_id='" + contestUserInfoVO.getUserId() + "'");
        List<SysUserIntegralDetail> userIntegralDetailList = baseService.find(SysUserIntegralDetail.class, " where INTEGRAL_ID='" + userIntegral.getIntegralId() + "' and INTEGRAL_TYPE='" + IntegralTypeEnum.RS_ANSWER.getIndex() + "'");
        if (userIntegralDetailList == null || userIntegralDetailList.isEmpty()) {
            SysUserIntegralDetail userIntegralDetail = new SysUserIntegralDetail();
            userIntegralDetail.setIntegralDetailId(UUIDUtils.createUUId());
            userIntegralDetail.setCreateTime(new Date());
            userIntegralDetail.setIntegralId(userIntegral.getIntegralId());
            userIntegralDetail.setIntegralChange(contestUserInfoVO.getCodeCount());
            userIntegralDetail.setChangeType(0);
            userIntegralDetail.setIntegralFrom("答题活动赠积分");
            userIntegralDetail.setIntegralType(IntegralTypeEnum.RS_ANSWER.getIndex());
            baseService.create(userIntegralDetail);
        }
        contestUserInfoVO.setContestScores(4);
        this.getEditUser(contestUserInfoVO);
        return "success";
    }

    public Integer[] addIntegralString(String a) {
        char[] rights = a.toCharArray();
        if (rights.length < 5) {
            int x = 5 - rights.length;
            for (int i = 0; i < x; i++) {
                a = "0" + a;
            }

            rights = a.toCharArray();
        }

        Integer[] rig = new Integer[5];
        for (int i = 0; i < 5; i++) {
            if (i < rights.length) {
                rig[i] = Integer.parseInt(String.valueOf(rights[i]));
            } else {
                rig[i] = 0;
            }
        }
        return rig;
    }

    public Integer addIntegralArray(Integer[] a) {

        String num = StringUtils.join(a, "");

        return Integer.valueOf(num, 2);
    }
    
    private static boolean isSameDate(Date date1, Date date2) {
        Calendar cal1 = Calendar.getInstance();
        cal1.setTime(date1);

        Calendar cal2 = Calendar.getInstance();
        cal2.setTime(date2);

        boolean isSameYear = cal1.get(Calendar.YEAR) == cal2
                .get(Calendar.YEAR);
        boolean isSameMonth = isSameYear
                && cal1.get(Calendar.MONTH) == cal2.get(Calendar.MONTH);
        boolean isSameDate = isSameMonth
                && cal1.get(Calendar.DAY_OF_MONTH) == cal2
                        .get(Calendar.DAY_OF_MONTH);

        return isSameDate;
    }

}
