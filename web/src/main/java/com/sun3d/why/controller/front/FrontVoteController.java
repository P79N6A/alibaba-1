package com.sun3d.why.controller.front;

import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.CmsActivityVote;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.CmsActivityVoteService;
import com.sun3d.why.service.CmsUserVoteService;
import com.sun3d.why.util.BindWS;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by niubiao on 2016/2/18.
 */
@Controller
@RequestMapping("/frontVote")
public class FrontVoteController {

    @Autowired
    private CmsActivityVoteService cmsActivityVoteService;

    @Autowired
    private CmsUserVoteService cmsUserVoteService;

    @Autowired
    private HttpSession session;
    
    @Autowired
    private CacheService cacheService;

    @RequestMapping("/index")
    private ModelAndView index(String activityId){
        ModelAndView model = new ModelAndView();
        Map<String,Object> params = new HashMap<>();
        params.put("firstResult", "0");
        params.put("rows", "3");
        params.put("activityId",activityId);
        try{
            List<CmsActivityVote> activityVoteList = cmsActivityVoteService.queryVoteList(params);
            model.addObject("list",activityVoteList);
        }catch (Exception e){
            e.printStackTrace();
        }
        model.setViewName("wechat/activity/voteIndex");
        return model;
    }


    @RequestMapping("/indexData")
    @ResponseBody
    private Map<String,Object> indexData(String voteId){
        ModelAndView model = new ModelAndView();
        try{
           return  cmsActivityVoteService.queryForIndexData(voteId);
        }catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }


    //根据活动id查询投票列表
    @RequestMapping("/list")
    private ModelAndView getList(String userId,String activityId){
        ModelAndView model = new ModelAndView();
        if(StringUtils.isBlank(userId)){
            CmsTerminalUser user = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
            if(user!=null){
                userId=user.getUserId();
            }
        }
        model.addObject("userId",userId);
        Map<String,Object> params = new HashMap<>();
        params.put("activityId",activityId);
        try{
            model.addObject("dataList", cmsActivityVoteService.queryVoteList(params));
        }catch (Exception e){
            e.printStackTrace();
        }
        model.setViewName("wechat/activity/voteList");
        return model;
    }


    //根据投票id查询投票详情
    @RequestMapping("/detail")
    private ModelAndView detail(HttpServletRequest request,String userId,String dataId,String reqFrom){
    	//微信权限验证配置
   	    String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url,cacheService);
        request.setAttribute("sign", sign);
    	
        ModelAndView model = new ModelAndView();
        if(StringUtils.isBlank(userId)){
            CmsTerminalUser user = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
            if(user!=null){
                userId=user.getUserId();
            }
        }else{
            if(userId.length()!=32){
                userId="";
            }
        }

        model.addObject("userId",userId);
        model.addObject("reqFrom",reqFrom);
        try{
            model.addObject("data",cmsActivityVoteService.queryDetailById(dataId));
        }catch (Exception e){
            e.printStackTrace();
        }
        model.setViewName("wechat/activity/voteDetail");
        return model;
    }


    //Test
    @RequestMapping("/list2")
    @ResponseBody
    private Map getList2(String userId,String activityId){

        Map<String,Object> result = new HashMap<>();

        Map<String,Object> params = new HashMap<>();
        params.put("activityId",activityId);
        try{
            result.put("dataList",cmsActivityVoteService.queryVoteList(params));
        }catch (Exception e){
            e.printStackTrace();
        }
        return  result;
    }


    //Test
    @RequestMapping("/detail2")
    @ResponseBody
    private Map detail2(String userId,String dataId){
        Map<String,Object> result = new HashMap<>();
        try{
            result.put("data", cmsActivityVoteService.queryDetailById(dataId));
        }catch (Exception e){
            e.printStackTrace();
        }
        return result;
    }

}
