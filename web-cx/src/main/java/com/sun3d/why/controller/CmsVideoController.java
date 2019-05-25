package com.sun3d.why.controller;

import com.sun3d.why.model.CmsVideo;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsVideoService;
import com.sun3d.why.util.Pagination;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;

@RequestMapping("/video")
@Controller
public class CmsVideoController {
    private Logger logger = LoggerFactory.getLogger(CmsVideoController.class);

    @Autowired
    private HttpSession session;
    @Autowired
    private CmsVideoService cmsVideoService;
    /**
     * addVideo
     * @param videos
     * @param request
     * @return
     */
    @RequestMapping(value="/preAddVideo",method= RequestMethod.GET)
    public ModelAndView preAddVideo(CmsVideo videos,HttpServletRequest request){
         ModelAndView model = new ModelAndView();
        try {
            request.setAttribute("referId",videos.getReferId());
            request.setAttribute("videoType",videos.getVideoType());
            model.setViewName("admin/video/addVideo");
            }
        catch (Exception e) {
            logger.error("addVideoModel error {}", e);
            }
        return model;
    }
    /**
     * 添加Video
     * @param videos
     * return 是否添加成功 (成功：success；失败：false)
     */
    @RequestMapping(value = "/addVideo")
    @ResponseBody
    public String addVideo(CmsVideo videos) throws Exception{
        String result = null;
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            result = cmsVideoService.addVideo(videos,sysUser);
        } catch (Exception e) {
            logger.error("addVideo error {}", e);
        }
        return result;
    }

    /**
     * 活动视频列表
     * @param page
     * @param videos
     * @return
     */
    @RequestMapping(value = "/videoIndex")
    public ModelAndView videoIndex(CmsVideo videos, Pagination page){
        ModelAndView model= new ModelAndView();
        try {
            List<CmsVideo> list= cmsVideoService.cmsVideoList(videos, page);
            model.addObject("page",page);
            model.addObject("list",list);
            model.addObject("videos",videos);
            model.addObject("referId",videos.getReferId());
            model.addObject("referName",videos.getReferName());
            model.addObject("videoType",videos.getVideoType());
            model.setViewName("admin/video/activityVideoIndex");
        }
        catch (Exception e){
            logger.error("activityVideoIndex Error{}",e);
        }
        return model;
    }
    /**
     * editVideo
     * @param videos
     * @return
     */
     @RequestMapping(value="/preEditVideo")
    public ModelAndView preEditVideo(CmsVideo videos){
         ModelAndView model= new ModelAndView();
         try {
             List<CmsVideo> list =cmsVideoService.cmsVideoList(videos, null);
             model.addObject("list",list);
             model.addObject("referId",videos.getReferId());
             model.addObject("videoType", videos.getVideoType());
             model.addObject("videoId",videos.getVideoId());
         } catch (Exception e) {
             e.printStackTrace();
         }
         model.setViewName("admin/video/editVideo");

         return model;
     }
    /**
     * 编辑Video
     * @param videos
     * return 是否编辑成功 (成功：success；失败：false)
     */
    @RequestMapping(value = "/editVideo")
    @ResponseBody
    public String editVideo(CmsVideo videos) throws Exception{
        String result = null;
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            result = cmsVideoService.editVideo(videos,sysUser);
        } catch (Exception e) {
            logger.error("addNews error {}", e);
        }
        return result;
    }

    /**
     * 删除Video
     * @param videos
     * return 是否删除成功 (成功：success；失败：false)
     */
    @RequestMapping(value = "/deleteVideo")
    @ResponseBody
    public String deleteVideo(CmsVideo videos) throws Exception{
        String result = null;
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            result = cmsVideoService.deleteVideo(videos, sysUser);
        } catch (Exception e) {
            logger.error("addNews error {}", e);
        }
        return result;
    }

    /**
     * 根据关联ID获取总有效视频记录数量
     * @param referId
     * @return
     */
    @RequestMapping(value = "/getVideoCount")
    @ResponseBody
    public Integer getVideoCount(String referId){
        Integer count = 0;
        try {
            if (StringUtils.isNotBlank(referId)) {
                count = cmsVideoService.getVideoCount(referId);
            }
        } catch (Exception e) {
            logger.error("getVideoCount error {}", e);
        }
        return count;
    }
}
