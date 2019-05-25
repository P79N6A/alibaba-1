package com.sun3d.why.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.sun3d.why.model.extmodel.StaticServer;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Controller
public class IndexController {
    private Logger logger = LoggerFactory.getLogger(IndexController.class);

    @Autowired
    private StaticServer staticServer;
    
    @RequestMapping(value = "/admin", method = {RequestMethod.GET})
    public String index(HttpServletRequest request) {

        return "admin/main";
    }

    @RequestMapping(value = "/top", method = {RequestMethod.GET})
    public String top(HttpServletRequest request) {

        return "admin/top";
    }

    @RequestMapping(value = "/left.do", method = {RequestMethod.GET})
    public String left(HttpServletRequest request) {
        return "admin/left";
    }

    @RequestMapping(value = "/right", method = {RequestMethod.GET})
    public String right(HttpServletRequest request) {

        return "admin/right";
    }

    @RequestMapping(value = "/login", method = {RequestMethod.GET})
    public String login(HttpServletRequest request) {
    	request.setAttribute("cityName", staticServer.getCityInfo().split(",")[1]);
        return "admin/user/userLogin";
    }

    @RequestMapping(value = "/help", method = {RequestMethod.GET})
    public String help(HttpServletRequest request,String link) {
        request.setAttribute("link",link);
        return "admin/help/question";
    }

}
