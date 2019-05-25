package com.sun3d.why.controller;

import com.sun3d.why.model.SysRole;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.SysRoleService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;

@RequestMapping("/role")
@Controller
public class SysRoleController {
    private Logger logger = LoggerFactory.getLogger(SysRoleController.class);

    @Autowired
    private SysRoleService roleService;

    @Autowired
    private HttpSession session;

    /**
     * 跳转到角色管理的首页面
     *
     * @param role SysRole 角色信息模型
     * @param page Pagination 分页功能类
     * @return ModelAndView 页面及参数
     */
    @RequestMapping(value = "/roleIndex")
    public ModelAndView roleIndex(SysRole role, Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
            List<SysRole> roleList = roleService.queryRoleByCondition(role, page);
            model.setViewName("admin/role/roleIndex");
            model.addObject("roleList", roleList);
            model.addObject("page", page);
            model.addObject("role", role);
        } catch (Exception e) {
            logger.info("activityIndex error" + e);
        }
        return model;
    }

    /**
     * 跳转到角色管理的首页面
     */
    @RequestMapping("/allRole")
    public String allRole(HttpServletRequest request, String userId) {
        // 与该用户有关联的角色
        try {
            List<SysRole> sysRoleList = roleService.queryRoleByUserId(userId);
            request.setAttribute("myRoles", sysRoleList);
            request.setAttribute("userId", userId);

            // 所有角色
            List<SysRole> sysRoles = roleService.queryRoleByConditionOrderRoleSort();
            request.setAttribute("sysRoles", sysRoles);
        } catch (Exception e) {
            logger.info("allRole error" + e);
        }
        return "admin/role/roleList";
    }

    /**
     * 去新增页面
     *
     * @return
     */
    @RequestMapping(value = "/preAddRole")
    public String preAddRole() {
        return "admin/role/addRole";
    }

    /**
     * 新增角色保存
     *
     * @param role
     * @return
     */
    @RequestMapping(value = "/saveRole", method = RequestMethod.POST)
    @ResponseBody
    public String saveRole(SysRole role) {
        try {
            if (role != null) {
                SysUser sysUser = (SysUser) session.getAttribute("user");
                return roleService.addRole(role, sysUser);
            }
        } catch (Exception e) {
            logger.info("saveRole error" + e.getMessage());
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }

    /**
     * 删除角色
     *
     * @param roleId
     * @return
     */
    @RequestMapping(value = "/deleteRole", method = RequestMethod.POST)
    @ResponseBody
    public String deleteRole(String roleId) {
        try {
            if (StringUtils.isNotBlank(roleId)) {
                roleService.updateRoleStateStatus(roleId);
                return Constant.RESULT_STR_SUCCESS;
            }
        } catch (Exception e) {
            logger.info("deleteRole error" + e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }

    @RequestMapping(value = "/preEditRole")
    public String preEditRole(String roleId, HttpServletRequest request) {
        if (StringUtils.isNotBlank(roleId)) {
            SysRole sysRole = roleService.queryRoleById(roleId);
            request.setAttribute("role", sysRole);
        }
        return "admin/role/editRole";
    }

    @RequestMapping(value = "/editRole", method = RequestMethod.POST)
    @ResponseBody
    public String editRole(SysRole role) {
        try {
            if (role != null) {
                SysUser sysUser = (SysUser) session.getAttribute("user");
                return roleService.editRole(role, sysUser);
            }
        } catch (Exception e) {
            logger.info("editRole error" + e.getMessage());
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }

    // 进入角色查看页面
    @RequestMapping(value = "/viewRole")
    public String viewRole(String roleId, HttpServletRequest request) {
        if (StringUtils.isNotBlank(roleId)) {
            SysRole sysRole = roleService.queryRoleById(roleId);
            request.setAttribute("role", sysRole);
        }
        return "admin/role/viewRole";
    }
}
