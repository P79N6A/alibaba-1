package com.sun3d.why.controller.front;

import com.sun3d.why.model.CmsApplyJoinTeam;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.service.CmsApplyJoinTeamService;
import com.sun3d.why.util.Constant;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;

/**
 * 团队会员前台请求处理控制层
 * 负责跟页面数据的交互以及对下层的数据方法的调用
 * <p/>
 * Created by cj on 2015/4/24.
 */
@Controller
@RequestMapping(value = "/frontApplyJoinTeam")
public class FrontApplyJoinTeamController {

    /**
     * 导入log4j日志管理，记录错误信息
     */
    private Logger logger = Logger.getLogger(FrontApplyJoinTeamController.class);

    @Autowired
    private CmsApplyJoinTeamService applyJoinTeamService;

    @Autowired
    private HttpSession session;

    /**
     * 前端2.0 添加团体申请
     * @return
     */
    @RequestMapping(value = "/addGroupJoin")
    @ResponseBody
    public String addGroupJoin(CmsApplyJoinTeam applyJoinTeam,String userNickName,Integer userSex,String userMobileNo,Integer userAge) {
        try{
            // 现更新会员
            if(session.getAttribute(Constant.terminalUser) != null) {
                CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
                applyJoinTeam.setApplyCreateUser(terminalUser.getUserId());
                applyJoinTeam.setApplyUpdateUser(terminalUser.getUserId());
                applyJoinTeam.setApplyCheckState(Constant.APPLY_CHECK_ING);
                applyJoinTeam.setApplyIsState(2);

                CmsTerminalUser user = new CmsTerminalUser();
                user.setUserId(applyJoinTeam.getUserId());
                user.setUserSex(userSex);
                user.setUserMobileNo(userMobileNo);
                user.setUserNickName(userNickName);
                user.setUserAge(userAge);
                return applyJoinTeamService.addApplyJoinTeam(applyJoinTeam, user);
            }
        }catch (Exception e){
            logger.info("addGroupJoin error", e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }

    /**
     * 前端2.0 添加团体申请
     * @return
     */
    @RequestMapping(value = "/queryApplyJoinTeamCount")
    @ResponseBody
    public int queryApplyJoinTeamCount(CmsApplyJoinTeam applyJoinTeam) {
        return applyJoinTeamService.queryApplyJoinTeamCount(applyJoinTeam);
    }
}