package com.sun3d.why.controller;

import com.sun3d.why.service.SysRoleModuleService;
import com.sun3d.why.util.Constant;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;

@RequestMapping("/roleModule")
@Controller
public class SysRoleModuleController {
    private Logger logger = LoggerFactory.getLogger(SysRoleModuleController.class);

    @Autowired
    private SysRoleModuleService roleModuleService;

   @RequestMapping(value = "/saveRoleModule", method = RequestMethod.POST)
   @ResponseBody
   public String saveRoleModule(HttpServletRequest request, String roleId) {
       try {
           String[] moduleArr = request.getParameterValues("moduleId");
           return roleModuleService.saveRoleModule(roleId,moduleArr);
       } catch (Exception e) {
           logger.info("saveRoleModule error", e);
          return Constant.RESULT_STR_FAILURE;
       }
   }
}
