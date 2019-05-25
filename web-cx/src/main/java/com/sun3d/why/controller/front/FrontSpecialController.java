package com.sun3d.why.controller.front;

import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.service.CmsSpecialService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

@RequestMapping("/frontSpecial")
@Controller
public class FrontSpecialController {
    private Logger logger = LoggerFactory.getLogger(FrontActivityController.class);

    @Autowired
    private CmsSpecialService specialService;
    /**
     * 活动列表页
     *
     * @param activity
     * @return
     */
    @RequestMapping(value = "/frontSpecialOneList")
    public ModelAndView querySpecialOneList(CmsActivity activity) {
        ModelAndView model = new ModelAndView();
        List<CmsActivity> activitylist = specialService.querySpecialOneList(activity);
        model.setViewName("special/specialOne");
        model.addObject("activity", activitylist);
        return model;
    }

    /**
     * 活动列表页
     *
     * @param activity
     * @return
     */
    @RequestMapping(value = "/frontSpecialTwoList")
    public ModelAndView querySpecialTwoList(CmsActivity activity) {
        ModelAndView model = new ModelAndView();
        List<CmsActivity> activitylist = specialService.querySpecialTwoList(activity);
        model.setViewName("special/specialTwo");
        model.addObject("activity", activitylist);
        return model;
    }

}
