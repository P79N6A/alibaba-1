package com.sun3d.why.controller;

import com.sun3d.why.model.CmsApplyJoinTeam;
import com.sun3d.why.service.CmsApplyJoinTeamService;
import com.sun3d.why.util.Constant;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@RequestMapping("/applyJoinTeam")
@Controller
public class CmsApplyJoinTeamController {
    private Logger logger = LoggerFactory.getLogger(CmsApplyJoinTeamController.class);

    @Autowired
    private CmsApplyJoinTeamService applyJoinTeamService;

    /**
     * 后端2.0某一团体下的会员删除
     * @param applyJoinTeam
     * @return
     */
    @RequestMapping(value = "/deleteTeamTerminalUser", method = RequestMethod.POST)
    @ResponseBody
    public String deleteTeamTerminalUser(CmsApplyJoinTeam applyJoinTeam) {
        try {
            if (applyJoinTeam != null) {
                applyJoinTeam.setApplyCheckState(Constant.APPLY_ALREADY_QUIT);
                applyJoinTeamService.editApplyJoinTeamById(applyJoinTeam);
                return Constant.RESULT_STR_SUCCESS;
            }
        } catch (Exception e) {
            logger.info("deleteTeamTerminalUser error" + e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }
}
