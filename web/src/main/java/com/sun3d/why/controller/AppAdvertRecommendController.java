package com.sun3d.why.controller;


import com.sun3d.why.model.AppAdvertRecommend;
import com.sun3d.why.model.AppAdvertRecommendRfer;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.AppAdvertRecommendService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

@Controller
@RequestMapping(value = "/advertRecommend")
public class AppAdvertRecommendController {
    @Autowired
    private HttpSession session;
    @Autowired
    private AppAdvertRecommendService appAdvertRecommendService;

    /**
     * App广告位列表
     *
     * @param
     * @return
     */
    @RequestMapping(value = "/appAdvertRecommendIndex")
    public ModelAndView appAdvertRecommendIndex(AppAdvertRecommend record, Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
            List<AppAdvertRecommend> pageList = new ArrayList<AppAdvertRecommend>();
            String tagIds = "";
            pageList = appAdvertRecommendService.queryCmsAdvertByCondition(record, page);
            for (AppAdvertRecommend adv : pageList) {
                tagIds+=adv.getAdvPostion();
                tagIds+=",";
            }
//            for(CmsAdvert cmsAdvert:list){
//                CmsAdvert cmsAdverts = cmsAdvert;
//                String url = cmsAdvert.getAdvertPicUrl();
//                if(org.apache.commons.lang3.StringUtils.isNotBlank(url)){
//                    String[] picUrl = url.split("\\.");
//                    String picUrls = picUrl[0]+"_300_300."+picUrl[1];
//                    cmsAdverts.setAdvertPicUrl(picUrls);
//                }
//                pageList.add(cmsAdverts);
//            }
            model.addObject("list", pageList);
            model.addObject("page", page);
            model.addObject("tagIds", tagIds);
            model.addObject("record", record);
            model.setViewName("admin/advert/appAdvertRecommendIndex");
        } catch (Exception e) {

        }
        return model;
    }

    /**
     * App广告位新增页面
     *
     * @param
     * @return
     */
    @RequestMapping(value = "/addAdvertRecommend")
    public ModelAndView addAdvertRecommend(String tagIds) {
        ModelAndView model = new ModelAndView();
        try {
            model.addObject("tagIds", tagIds);
            model.setViewName("admin/advert/addAdvReco");
        } catch (Exception e) {

        }
        return model;
    }

    /**
     * App广告位编辑页面
     *
     * @param
     * @return
     */
    @RequestMapping(value = "/editAdvertRecommendIndex")
    public ModelAndView editAdvertRecommendIndex(String advertId) {
        ModelAndView model = new ModelAndView();
        AppAdvertRecommend appAdvertRecommend = null;
        try {
            List<AppAdvertRecommendRfer> appAdvertRecommendRferList = new ArrayList<AppAdvertRecommendRfer>();
            AppAdvertRecommendRfer appAdvertRecommendRfer = new AppAdvertRecommendRfer();
            appAdvertRecommendRfer.setAdvertReferId(advertId);
            appAdvertRecommendRferList = appAdvertRecommendService.queryAdvertRecommendRferCondition(appAdvertRecommendRfer);
            appAdvertRecommend = appAdvertRecommendService.selectAdvertById(advertId);
            model.addObject("appAdvertRecommend", appAdvertRecommend);
            model.addObject("appAdvertRecommendRfer", appAdvertRecommendRferList);
            model.setViewName("admin/advert/editAdvReco");
        } catch (Exception e) {

        }
        return model;
    }

    /**
     * 保存添加App广告位
     *
     * @return
     */
    @RequestMapping(value = "/addAdvert")
    @ResponseBody
    public String addAdvert(AppAdvertRecommend appadvertrecommend) {
        try {
            if (appadvertrecommend != null) {
                //验证广告位是否存在
                if (StringUtils.isNotBlank(appadvertrecommend.getAdvPostion())) {
                    SysUser sysUser = (SysUser) session.getAttribute("user");
                    String exists = appAdvertRecommendService.addAdvert(appadvertrecommend, sysUser);
                    if (exists == "success") {
                        return Constant.RESULT_STR_SUCCESS;
                    }
                } else {
                    return Constant.RESULT_STR_FAILURE;
                }
            }
        } catch (Exception e) {
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_SUCCESS;
    }

    /**
     * 删除广告位
     *
     * @return
     */
    @RequestMapping(value = "/delete", method = RequestMethod.POST)
    @ResponseBody
    public String delete(String advertId) {
        try {
            if (advertId != null) {
                appAdvertRecommendService.deletedvertById(advertId);
            }
            return Constant.RESULT_STR_SUCCESS;
        } catch (Exception e) {
            return Constant.RESULT_STR_FAILURE;
        }
    }

}
