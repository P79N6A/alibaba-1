package com.sun3d.why.controller;

import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.CmsActivityService;
import com.sun3d.why.service.WebIndexService;
import com.sun3d.why.util.Constant;
import org.apache.commons.collections.CollectionUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RequestMapping("/webIndex")
@Controller
public class WebIndexController {
    private Logger logger = LoggerFactory.getLogger(WebIndexController.class);

    @Autowired
    private WebIndexService webIndexService;

    @Autowired
    private CacheService cacheService;

    @Autowired
    private CmsActivityService cmsActivityService;

    /**
     * 传入id和key，查出活动详情并保存到Redis
     *
     * @param Ids
     * @return
     */
    @RequestMapping(value = "/saveToRedis", method = RequestMethod.POST)
    @ResponseBody
    public String saveToRedis(String Ids, String Key) {
        try {
            if (Ids != null && Ids != "") {
                String[] Id = Ids.split(",");
                List<String> list = new ArrayList<String>();
                for (String id : Id) {
                    list.add(id);
                }
                String result = webIndexService.activityList(list, Key);
                if (result == "success") {
                    return Constant.RESULT_STR_SUCCESS;
                } else {
                    return Constant.RESULT_STR_FAILURE;
                }
            } else {
                return Constant.RESULT_STR_FAILURE;
            }
        } catch (Exception ex) {
            this.logger.error("frontNewestActivity error {}", ex);
            ex.printStackTrace();
            return Constant.RESULT_STR_FAILURE;
        }
    }

    /**
     * 根据key从Redis中读取活动信息
     *
     *
     * @return
     */
    @RequestMapping(value = "/getFromRedis")
    public String getFromRedis(final String Key, HttpServletRequest request, String Tag) {
        try {
            final List<CmsActivity> rsList;
            final List<String> list = new ArrayList<String>();
             rsList = cacheService.queryActivityList(Key);
            //存到Redis中
            Runnable runner = new Runnable() {
                @Override
                public void run() {
                    //根据页面传来的活动id查询
                    if (CollectionUtils.isNotEmpty(rsList)) {
                        for (CmsActivity data : rsList) {
                            list.add(data.getActivityId());
                        }
                        String result = webIndexService.activityList(list, Key);
                    }
                }
            }; new Thread(runner).start();
            request.setAttribute(Key, rsList);
            return "index/index/frontIndexLoad";
        } catch (Exception ex) {
            this.logger.error("frontNewestActivity error {}", ex);
            ex.printStackTrace();
            return null;
        }
    }

    /**
     * 后台进入首页信息管理页面
     *
     *
     * @return
     */
    @RequestMapping(value = "/webIndex")
    private ModelAndView webIndex(){
        ModelAndView model=new ModelAndView();
        List<CmsActivity> newestActivity;
        List<CmsActivity> weekEndActivity;
        newestActivity = cacheService.queryActivityList("newestActivity");
        weekEndActivity = cacheService.queryActivityList("weekEndActivity");
        model.addObject("newestActivity", newestActivity);
        model.addObject("weekEndActivity", weekEndActivity);
        model.setViewName("admin/webIndex/webIndex");
        return model;

    }
}
