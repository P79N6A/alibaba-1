package com.sun3d.why.controller;

import com.alibaba.fastjson.JSONArray;
import com.sun3d.why.model.SysDept;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.extmodel.AreaData;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CmsDeptService;
import com.sun3d.why.service.CmsUserService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.MD5Util;
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

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by yujinbing on 2015/4/27.
 */
@RequestMapping("/user")
@Controller
public class CmsUserController {
    private Logger logger = LoggerFactory.getLogger(CmsUserController.class);

    @Autowired
    private CmsUserService cmsUserService;

    @Autowired
    private CmsDeptService cmsDeptService;

    @Autowired
    private HttpSession session;
    
    @Autowired
    private StaticServer staticServer;

    /**
     * 进入用户列表页面
     * @param request
     * @param page
     * @return
     */
    @RequestMapping(value="/sysUserIndex")
    public ModelAndView sysUserIndex(HttpServletRequest request, Pagination page) {
        SysUser loginUser = (SysUser)session.getAttribute("user");
        List<SysUser> tempUserList = cmsUserService.getNotAssignedUsers(loginUser);
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("firstResult",page.getFirstResult());
        map.put("rows",page.getRows());
        if (loginUser != null && loginUser.getUserDeptPath() != null) {
            map.put("userDeptPath", loginUser.getUserDeptPath() + "%");
        }
        ModelAndView model = new ModelAndView();
        String userAccount = request.getParameter("userAccount");
        if (!StringUtils.isBlank(userAccount)) {
            map.put("userAccount", "%" + userAccount + "%");
            request.setAttribute("userAccount",userAccount);
        }
        String areaData = request.getParameter("areaData");
        if (!StringUtils.isBlank(areaData)) {
            map.put("areaData", areaData);
            request.setAttribute("areaData",areaData);
        }
        int total = this.cmsUserService.querySysUserIndexCount(map);
        page.setTotal(total);
        List<SysUser> userList = this.cmsUserService.querySysUserIndex(map);
        model.setViewName("admin/user/userIndex");
        model.addObject("userList", userList);
        model.addObject("page", page);
        request.setAttribute("userList", userList);
        return model;
    }

    /**
     * 进入用户编辑页面
     * @param request
     * @return
     */
    @RequestMapping(value="/preEditSysUser",  method = {RequestMethod.GET})
    public String preEditSysUser(HttpServletRequest request) {
        String userId = request.getParameter("userId");
        SysUser user =  this.cmsUserService.querySysUserByUserId(userId);
        String path = "";
        if (user != null) {
            SysDept dept =  cmsDeptService.querySysDeptByDeptId(user.getUserDeptId());
            if(dept != null) {
                request.setAttribute("deptName",dept.getDeptName());
                request.setAttribute("dept",dept);
                path = dept.getDeptPath();
                if (path != null) {
                    String[] strs = path.split("\\.");
                    if (strs != null) {
                        path = strs[0];
                    }
                }
            }
        } else {
            return "";
        }
        request.setAttribute("user", user);
        request.setAttribute("deptPath",path);
        return "admin/user/userEdit";
    }

    /**
     * 保存用户修改信息
     * @param request
     * @param user
     * @param birthday
     * @param userProvinceText
     * @param userCityText
     * @param userCountyText
     * @return
     */
    @RequestMapping(value="/updateSysUser",  method = {RequestMethod.POST})
    @ResponseBody
    public String updateSysUser(HttpServletRequest request,SysUser user ,String birthday,String userProvinceText, String userCityText, String userCountyText) {
        try {
            SysUser loginUser = (SysUser)session.getAttribute("user");
            return cmsUserService.editSysUserByLoginUser(user,loginUser,birthday,userProvinceText,userCityText,userCountyText);
        } catch (Exception e) {
            this.logger.error("update error {}", e);
            return "error" + e.toString();
        }
    }

    /**
     *冻结/激活用户
     * @param request
     * @return
     */
    @RequestMapping(value="/deleteSysUser",  method = {RequestMethod.GET})
    public ModelAndView deleteSysUser(HttpServletRequest request, Pagination page) {
        try {
            String userId = request.getParameter("userId");
            SysUser loginUser = (SysUser)session.getAttribute("user");
            SysUser user =  this.cmsUserService.querySysUserByUserId(userId);
            if (user == null) {
                return null;
            }
            if (user.getUserState() == null || user.getUserState() == 1) {
                user.setUserState(2);
            } else {
                user.setUserState(1);
            }
            user.setUserUpdateUser(loginUser.getUserId());
            user.setUserUpdateTime(new Date());
            int rs = this.cmsUserService.editBySysUser(user);
            return this.sysUserIndex(request, page);
        } catch (Exception e) {
            this.logger.error("update error {}", e);
            return null;
        }
    }

    /**
     *进入新建用户页面
     * @param request
     * @return
     */
    @RequestMapping(value="/preAddSysUser",  method = {RequestMethod.GET})
    public String preAddSysUser(HttpServletRequest request) {
        try {
            return  "admin/user/userAdd";
        } catch (Exception e) {
            this.logger.error("update error {}", e);
            return "error";
        }
    }


    /**
     *保存用户信息
     * @param
     * @param user
     * @return
     */
    @RequestMapping(value = "/saveSysUser", method = RequestMethod.POST)
    @ResponseBody
    public String saveSysUser(SysUser user,String birthday,String userProvinceText,
                       String userCityText, String userCountyText,
                       HttpServletRequest request) {
        try {
            SysUser loginUser = (SysUser)session.getAttribute("user");
            return cmsUserService.checkUserCanSave(user,loginUser , userProvinceText,userCityText,userCountyText,birthday);
        } catch (Exception e) {
            this.logger.error("save error {}", e);
            return e.toString();
        }
    }

    /**
     *用户信息浏览页面
     * @param request
     * @return
     */
    @RequestMapping(value="/viewSysUser",  method = {RequestMethod.GET})
    public String viewSysUser(HttpServletRequest request) {
        String userId = request.getParameter("userId");
        SysUser user = this.cmsUserService.querySysUserByUserId(userId);
        if (user != null) {
            SysDept sysDept = this.cmsDeptService.querySysDeptByDeptId(user.getUserDeptId());
            if(sysDept != null)
                user.setUserDeptId(sysDept.getDeptName());
        } else {
            return "admin/user/userDetail";
        }
        request.setAttribute("user", user);
        return "admin/user/userDetail";
    }


    /**
     *用户登录验证
     * @param request
     * @return
     */
    @RequestMapping(value="/loginCheckSysUser",  method = {RequestMethod.POST})
    @ResponseBody
    public String loginCheckSysUser(HttpServletRequest request,HttpSession session,HttpServletResponse response) {
        try {
            String userAccount = request.getParameter("userAccount");
            String userPassword = request.getParameter("userPassword");
            String userType= request.getParameter("userType");

            SysUser sysUser  = cmsUserService.loginCheckUser(userAccount, userPassword);
            if (sysUser != null) {
                if (sysUser.getUserState() == 1) {
                    session.setAttribute("user", sysUser);
                } else {
                    return "freeze";
                }
                if(StringUtils.isNotBlank(userType)){
                    response.setContentType("text/html;charset=utf-8");
                    Cookie userName = new Cookie("ticketUserName", URLEncoder.encode(userAccount, "UTF-8") );
                    userName.setPath("/");
                    userName.setMaxAge(Integer.MAX_VALUE);
                    response.addCookie(userName);
                    Cookie pwd = new Cookie("ticketPwd", URLEncoder.encode(userPassword, "UTF-8") );
                    pwd.setPath("/");
                    pwd.setMaxAge(Integer.MAX_VALUE);
                    response.addCookie(pwd);

                    Cookie userId = new Cookie("ticketUserId", URLEncoder.encode(sysUser.getUserId(), "UTF-8") );
                    userId.setPath("/");
                    userId.setMaxAge(Integer.MAX_VALUE);
                    response.addCookie(userId);
                }
                return "success";
            } else {
                return "error";
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            return ex.toString();
        }
    }

    /**
     *用户退出登录
     * @param request
     * @return
     */
    @RequestMapping(value="/sysUserLoginOut",  method = {RequestMethod.GET})
    public String sysUserLoginOut(HttpServletRequest request,HttpSession session) {
        SysUser user  = (SysUser)session.getAttribute("user");
        if (user != null) {
            session.removeAttribute("user");
        }
        request.setAttribute("cityName", staticServer.getCityInfo().split(",")[1]);
        return "admin/user/userLogin";
    }

    /**
     *进入用户选择部门页面
     * @param request
     * @return
     */
    @RequestMapping(value="/selectDept",  method = {RequestMethod.GET})
    public ModelAndView selectDept(HttpServletRequest request,HttpSession session) {
    	/**add by YH 新增场馆时需要选择部门  2015-10-29 begin*/
    	ModelAndView model = new ModelAndView(); 
    	String type = request.getParameter("type");
    	if("venue".equals(type)){
    		model.addObject("type", type);
    		model.setViewName("admin/venue/venueSelectDept");
    	}else{
    		model.setViewName("admin/user/selectDept");
    	}
    	/**add by YH 新增场馆时需要选择部门  end*/
        return model;
    }


    /**
     * 得到用户可以选择的部门信息
     * @param request
     * @return
     */
    @RequestMapping(value = "/getDeptList",  method = {RequestMethod.POST})
    @ResponseBody
    public String getDeptList(HttpServletRequest request){
        SysUser user = (SysUser)session.getAttribute("user");
        Map map = new HashMap();
        map.put("deptState", 1);
        map.put("deptPath", user.getUserDeptPath() + "%");
        String type = request.getParameter("type");
        if( type!=null &&	StringUtils.isNotBlank(type)){
        	map.put("deptIsFromVenue", 2);
        }
        List<SysDept> list = this.cmsDeptService.querySysDeptByMap(map);
        JSONArray jsonArray = new JSONArray();
        jsonArray.add(list);
        String rs = jsonArray.toJSONString();
        rs =  rs.substring(1,rs.length() - 1);
        return  rs;
    }

    @RequestMapping(value = "/preEditPass")
    public ModelAndView preModInfo(){
        ModelAndView model = new ModelAndView();
        SysUser user = (SysUser) session.getAttribute("user");
        if(user==null){
            return new ModelAndView("redirect:/login.do");
        }
        SysUser sessionUser = cmsUserService.querySysUserByUserId(user.getUserId());
        model.setViewName("admin/user/userEditPass");
        model.addObject("user",sessionUser);
        return model;
    }


    @RequestMapping("/modUserInfo")
    @ResponseBody
    public Map<String,Object> modUserInfo(SysUser user,String oldPass){
        Map<String,Object> result = new HashMap<String, Object>();

        /**
         * 验证sessionuser是否存在
         */
        SysUser sessionUser = (SysUser) session.getAttribute("user");
        if(sessionUser==null){
            result.put("result","timeOut");
            return  result;
        }

        SysUser extUser = cmsUserService.querySysUserByUserId(user.getUserId());
        if(!MD5Util.toMd5(oldPass).equals(extUser.getUserPassword())){
            result.put("result","oldPassError");
            return result;
        }

        if(StringUtils.isNotBlank(user.getUserPassword())){
            user.setUserPassword(MD5Util.toMd5(user.getUserPassword()));
            cmsUserService.editBySysUser(user);
            /**
             * 重新登陆
             */
            session.invalidate();
            result.put("result", Constant.RESULT_STR_SUCCESS);
        }else{
            result.put("result", Constant.RESULT_STR_FAILURE);
        }
        return result;
    }

    /**
     * 得到所有区域的编码信息
     */
    @RequestMapping(value = "/getLocArea")
    @ResponseBody
    public List<AreaData> getLocArea() {
        List<AreaData> areaDataList = null;
        try {
            areaDataList = cmsUserService.queryUserAllArea();
        } catch(Exception e){
            logger.error("获取区县信息出错!",e);
        }
        return areaDataList;
    }
    
   
}
