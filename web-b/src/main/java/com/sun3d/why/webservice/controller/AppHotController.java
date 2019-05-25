package com.sun3d.why.webservice.controller;

import com.sun3d.why.service.CmsAppSettingService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.webservice.service.TagAppService;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * 设置热门
 *
 */
@Controller
@RequestMapping("/appHot")
public class AppHotController {
    @Autowired
    private TagAppService tagAppService;
    private Logger logger = Logger.getLogger(AppHotController.class);




    /**
     * why3.5 活动热门
     *
     * @param
     * @return
     */
    @RequestMapping(value = "/getActivity")
    public String getSetting(HttpServletResponse response) throws IOException {
        String json = "";
        try {
            json=tagAppService.activityHot();
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    /**
     * why3.5 场馆热门
     *
     * @param
     * @return
     */
    @RequestMapping(value = "/getVenue")
    public String getVenue(HttpServletResponse response) throws IOException {
        String json = "";
        try {
            json=tagAppService.venueHot();
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

}
