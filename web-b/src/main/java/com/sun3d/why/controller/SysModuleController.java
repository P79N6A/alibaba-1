package com.sun3d.why.controller;

import com.sun3d.why.model.SysModule;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.SysModuleService;
import com.sun3d.why.util.Constant;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * 模块管理控制层，负责跟页面数据的交互以及对下层的数据方法的调用
 * <p/>
 * Created by wangfan on 2015/4/22.
 */
@Controller
@RequestMapping(value = "/module")
public class SysModuleController {

    /**
     * 导入log4j日志管理，记录错误信息
     */
    private Logger logger = Logger.getLogger(SysModuleController.class.getName());

    /**
     * 权限service层对象，注解自动注入
     */
    @Autowired
    private SysModuleService sysModuleService;


    @Autowired
    private HttpSession session;

    /**
     * 跳转到权限管理的首页面
     */
    @RequestMapping("/moduleIndex")
    public String roleModuleIndex(HttpServletRequest request, String roleId) {
        // 与该角色有关联的权限
        List<SysModule> sysModuleList = sysModuleService.queryModuleByRoleId(roleId);

        // 所有权限
        List<SysModule> sysModules = sysModuleService.queryModuleByModuleState(Constant.NORMAL);

        request.setAttribute("sysModules", sysModules);
        request.setAttribute("myModules", sysModuleList);
        request.setAttribute("roleId", roleId);
        return "admin/module/moduleIndex";
    }

    @RequestMapping("/initModule")
    @ResponseBody
    public String initModule() {
        String userId = "";
        if (session.getAttribute("user") != null) {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            userId = sysUser.getUserId();
            return sysModuleService.initModule(userId);
        }
        return Constant.RESULT_STR_FAILURE;
    }

    @RequestMapping("/preInitModule")
    public String toInitModule() {
        return "admin/module/initModuleSucess";
    }
}
