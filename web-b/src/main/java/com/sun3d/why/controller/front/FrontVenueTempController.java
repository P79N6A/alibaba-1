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
@RequestMapping("/venueTemp")
@Controller
public class FrontVenueTempController  {

    @Autowired
    private CmsActivityTempService cmsActivityTempService;

    public ModelAndView index(){
        return new ModelAndView("index/temp/venueIndex");
    }

    @RequestMapping("/indexLoad")
    public ModelAndView indexLoad(Pagination page,HttpServletRequest request){

        ModelAndView model = new ModelAndView();
        try{
            String areaCode = (String) request.getAttribute("areaCode");
            List<CmsActivityTemp> venueList = cmsActivityTempService.queryByCondition(page,areaCode);
            model.addObject("dataList",venueList);
        }catch (Exception e){
            e.printStackTrace();
        }
        model.setViewName("index/temp/venueList");
        return model;
    }

}
