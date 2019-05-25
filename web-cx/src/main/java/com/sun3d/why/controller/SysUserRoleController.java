package com.sun3d.why.controller;

import com.sun3d.why.service.SysUserRoleService;
import com.sun3d.why.util.Constant;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;

@RequestMapping("/userRole")
@Controller
public class SysUserRoleController {
    private Logger logger = LoggerFactory.getLogger(SysUserRoleController.class);

    @Autowired
    private SysUserRoleService userRoleService;

    @RequestMapping(value = "/saveUserRole", method = RequestMethod.POST)
    @ResponseBody
    public String saveUserRole(HttpServletRequest request,String userId) {
        try{
            String[] roleArr = request.getParameterValues("roleId");
            return userRoleService.saveUserRole(userId,roleArr);
        }catch (Exception e){
            return Constant.RESULT_STR_FAILURE;
        }
    }
}
