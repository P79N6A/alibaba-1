package com.sun3d.why.webservice.controller;

import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.webservice.service.*;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import javax.servlet.http.HttpServletResponse;

/**
 * 手机app3.5接口
 * Created by Administrator on 2015/7/1
 */
@RequestMapping("/appMagazine")
@Controller
public class EditorialAppController {
    private Logger logger = Logger.getLogger(EditorialAppController.class);
    @Autowired
    private EditorialAppService editorialAppService;

    /**
     * why3.5 抓取采编库+活动列表
     * @param response
     * @param activityType
     * @param userId
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/appMagazineList")
    public String appEditorialList(HttpServletResponse response,String activityType,String userId) throws Exception {
        String json="";
        try {
            json = editorialAppService.queryAppEditAndActivityList(activityType,userId);
        }catch (Exception e){
            json = JSONResponse.toAppResultFormat(500, e.getMessage());
            logger.info("query activityBanner error"+e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     *why3.5 app用户报名采编接口
     * @param activityId        采编id
     * @param userId            用户id
     * return
     */
    @RequestMapping(value = "/appAddEditorialUserWantgo")
    public String appAddEditorialUserWantgo(HttpServletResponse response,String activityId,String userId) throws Exception {
        String json="";
        try{
            if(StringUtils.isNotBlank(activityId) && StringUtils.isNotBlank(userId)){
                json = editorialAppService.addEditorialUserWantgo(activityId, userId);
            }else{
                json = JSONResponse.toAppResultFormat(10107, "采编id或用户id缺失");
            }
        }catch (Exception e){
            json = JSONResponse.toAppResultFormat(11111, e.getMessage());
            logger.error("appAddEditorialUserWantgo error" + e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    /**
     *why3.5 app用户取消报名采编接口
     * @param activityId        采编id
     * @param userId            用户id
     * return
     */
    @RequestMapping(value = "/deleteEditorialUserWantgo")
    public String deleteEditorialUserWantgo(HttpServletResponse response,String activityId,String userId) throws Exception {
        String json="";
        try{
            if(StringUtils.isNotBlank(activityId) && StringUtils.isNotBlank(userId)){
                json = editorialAppService.deleteEditorialUserWantgo(activityId, userId);
            }else{
                json = JSONResponse.toAppResultFormat(10107, "采编id或用户id缺失");
            }
        }catch (Exception e){
            json = JSONResponse.toAppResultFormat(11111, e.getMessage());
            logger.error("deleteEditorialUserWantgo error" + e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
}

