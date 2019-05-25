package com.sun3d.why.controller.mobile;

import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.service.CmsTerminalUserService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.UUIDUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Created by niubiao on 2016/1/13.
 */
@Controller
@RequestMapping(value = "/muser")
public class MuserController {

    @Autowired
    private CmsTerminalUserService terminalUserService;

    @Autowired
    private HttpSession session;

    @RequestMapping(value = "/register",method = RequestMethod.GET)
    public String toReg(){
        return "/mobile/user/register";
    }

    @RequestMapping(value="/regResult",method = RequestMethod.GET)
    public  String regResult(){
        return "/mobile/user/regResult";
    }

    /**
     * 移动登陆
     * @param m
     * @param request
     * @param type	（P：潘多拉个人中心 url:登陆前跳转页面）
     * @return
     *//*
    @RequestMapping(value = "/login",method = RequestMethod.GET)
    public  String login(String m,HttpServletRequest request,String type,String tips){
        if(StringUtils.isNotEmpty(m) && m.length()==11){
            request.setAttribute("m",m);
        }
        request.setAttribute("type",type);
        request.setAttribute("tips",tips);
        return "/mobile/user/login";
    }*/

    @RequestMapping(value = "/forget",method = RequestMethod.GET)
    public  String forget(){
        return "/mobile/user/forget";
    }


    @RequestMapping(value = "/setPass",method =RequestMethod.POST)
    public ModelAndView setPass(String code){

        String userId = (String) session.getAttribute(Constant.SESSION_USER_ID);
        String sessionUserCode = (String) session.getAttribute(Constant.SESSION_USER_CODE);

        try{
            if(StringUtils.isBlank(userId)||userId.length()!=32||StringUtils.isBlank(code)){
                return new ModelAndView("redirect:/muser/forget.do");
            }
            CmsTerminalUser user = terminalUserService.queryTerminalUserById(userId);
            if(user==null){
                return null;
            }
            if(!user.getRegisterCode().equals(code)){
                return new ModelAndView("redirect:/muser/forget.do");
            }
            if(!Constant.USER_IS_ACTIVATE.equals(user.getUserIsDisable())){
                return new ModelAndView("redirect:/muser/forget.do");
            }
            ModelAndView model = new ModelAndView();
            model.setViewName("/mobile/user/setPass");
            String reqCode = UUIDUtils.createUUId();
            model.addObject("reqCode", reqCode);
            session.setAttribute(Constant.SESSION_USER_CODE, reqCode);
            return model;
        }catch (Exception e){
            return new ModelAndView("redirect:/muser/forget.do");
        }
    }
    
    /**
     * wechat个人中心跳转到修改密码
     * @return
     */
    @RequestMapping(value = "/preSetPass")
    public ModelAndView preSetPass(){
        try{
            CmsTerminalUser user = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
            if(user==null){
                return new ModelAndView("redirect:/muser/login.do");
            }
            ModelAndView model = new ModelAndView();
            model.setViewName("/mobile/user/editPass");
            model.addObject("user",user);
            return model;
        }catch (Exception e){
            return null;
        }
    }
    
  	/**
  	 * wechat登出
  	 * @param request
  	 * @param response
  	 */
    @RequestMapping("/outLogin")
    public String outLogin(HttpServletRequest request,HttpServletResponse response){
        try{
            request.getSession().removeAttribute(Constant.terminalUser);
            CmsTerminalUser users = new CmsTerminalUser();
            String Id = "47486962f28e41ceb37d6bcf35d8e5c3," +
                    "bfb37ab6d52f492080469d0919081b2b," +
                    "e4c2cef5b0d24b2793ac00fd1098e4e7," +
                    "75ee8a017c444903872c59d954644eac," +
                    "526091b990c3494d91275f75726c064f";
            users.setActivityThemeTagId(Id);
            session.setAttribute("terminalUser", users);
            return "/wechat/index";
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @RequestMapping(value = "setPassResult",method = RequestMethod.GET)
    public String setPassResult(String m,HttpServletRequest request){
        request.setAttribute("m",m);
        return "/mobile/user/setPassResult";
    }



}
