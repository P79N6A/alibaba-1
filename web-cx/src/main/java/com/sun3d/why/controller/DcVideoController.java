package com.sun3d.why.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sun3d.why.model.DcVideo;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.DcVideoService;
import com.sun3d.why.util.Pagination;

@RequestMapping(value = "/dcVideo")
@Controller
public class DcVideoController {

    private Logger logger = Logger.getLogger(DcVideoController.class);
    
    @Autowired
    private HttpSession session;
    @Autowired
    private DcVideoService dcVideoService;
    @Resource
    private StaticServer staticServer;
    
    /**
     * 配送中心列表页
     * @param cmsQuestionAnwser
     * @param searchKey
     * @param page
     * @return
     */
    @RequestMapping("/dcVideoIndex")
    public ModelAndView dcVideoIndex(Pagination page,DcVideo dcVideo) {
        ModelAndView model = new ModelAndView();
        List<DcVideo> list = null;
        try {
            list = dcVideoService.queryDcVideoByCondition(dcVideo,page);
            model.addObject("page", page);
            model.addObject("list", list);
            model.addObject("dcVideo", dcVideo);
            model.setViewName("admin/dc/dcVideoIndex");
        } catch (Exception e) {
            logger.error("dcVideoIndex error {}", e);
        }
        return model;
    }
    
    /**
     * 跳转至审核页面
     *
     * @param request
     * @return
     */
    @RequestMapping(value = "/preEditDcVideo")
    public ModelAndView preEditDcVideo(HttpServletRequest request,DcVideo vo) {
    	ModelAndView model = new ModelAndView();
    	DcVideo dcVideo = null;
        if (StringUtils.isNotBlank(vo.getVideoId())) {
        	dcVideo = dcVideoService.queryDcVideoByCondition(vo,null).get(0);
        	model.addObject("dcVideo", dcVideo);
        }
        model.addObject("reviewType", vo.getReviewType());
        model.addObject("videoType", vo.getVideoType());
        model.addObject("aliImgUrl", staticServer.getAliImgUrl());
        model.setViewName("admin/dc/editDcVideo");
        return model;
    }
    
    /**
     * 编辑
     * @return
     */
    @RequestMapping(value = "/editDcVideo")
    @ResponseBody
    public String editDcVideo(DcVideo dcVideo) {
    	String result;
        try {
        	result = dcVideoService.editDcVideo(dcVideo);
        } catch (Exception e) {
            logger.info("editDcVideo error {}", e);
            return "500";
        }
        return result;
    }
    
    /**
     * 配送中心统计页
     * @return
     */
    @RequestMapping("/dcStatisticsIndex")
    public ModelAndView dcStatisticsIndex() {
        ModelAndView model = new ModelAndView();
        try {
        	Map<String, Object> statisticsMap = dcVideoService.queryStatisticsIndex();
        	model.addObject("statisticsMap", statisticsMap);
            model.setViewName("admin/dc/dcStatisticsIndex");
        } catch (Exception e) {
            logger.error("dcStatisticsIndex error {}", e);
        }
        return model;
    }
    
    /**
     * 最终评分
     * @return
     */
    @RequestMapping(value = "/scoreDcVideo")
    @ResponseBody
    public String scoreDcVideo() {
    	String result;
        try {
        	result = dcVideoService.scoreDcVideo();
        } catch (Exception e) {
            logger.info("scoreDcVideo error {}", e);
            return "500";
        }
        return result;
    }
}
