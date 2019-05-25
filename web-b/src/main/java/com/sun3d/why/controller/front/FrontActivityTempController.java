package com.sun3d.why.controller.front;

import com.sun3d.why.model.temp.CmsActivityTemp;
import com.sun3d.why.service.CmsActivityTempService;
import com.sun3d.why.util.Pagination;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.List;


/**
 * Created by Administrator on 2015/7/27.
 */
@RequestMapping("/activityTemp")
@Controller
public class FrontActivityTempController {

    @Autowired
    private CmsActivityTempService cmsActivityTempService;


    @RequestMapping("/index")
    public ModelAndView index(){
        return new ModelAndView("index/temp/activityIndex");
    }

    @RequestMapping("/indexLoad")
    public ModelAndView index(Pagination page,HttpServletRequest request){
        ModelAndView model = new ModelAndView();
        try{
            String areaCode = (String) request.getAttribute("areaCode");
            List<CmsActivityTemp> actList = cmsActivityTempService.queryByCondition(page,areaCode);
            model.addObject("dataList",actList);
        }catch (Exception e){
            e.printStackTrace();
        }
        model.setViewName("index/temp/activityList");
        return model;
    }





}
