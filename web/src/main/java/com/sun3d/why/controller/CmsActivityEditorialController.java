package com.sun3d.why.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;

import com.sun3d.why.model.ActivityEditorial;
import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.CmsActivityOrder;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsActivityEditorialService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

import net.sf.json.JSONObject;

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

@RequestMapping("/activityEditorial")
@Controller
public class CmsActivityEditorialController {
    private Logger logger = LoggerFactory.getLogger(CmsActivityEditorialController.class);

    @Autowired
    private HttpSession session;

    @Autowired
    private CmsActivityEditorialService cmsActivityEditorialService;


    /**
     * 活动列表页
     *
     * @param activity
     * @param page
     * @return
     */
    @RequestMapping("/activityEditorialIndex")
    public ModelAndView activityIndex(ActivityEditorial activity, Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
            List<ActivityEditorial> activityList = cmsActivityEditorialService.queryActivityEditorialByCondition(activity, page);
            model.addObject("activityList", activityList);
            model.addObject("page", page);
            model.addObject("activity", activity);
            model.setViewName("admin/activityEditorial/activityEditorialIndex");
        } catch (Exception e) {
            logger.error("activityIndex error {}", e);
        }
        return model;
    }

    /**
     * 跳转至活动添加页面
     *
     * @param request
     * @return
     */
    @RequestMapping(value = "/preAddActivityEditorial")
    public String preAddActivityEditorial(HttpServletRequest request) {
        return "admin/activityEditorial/addActivityEditorial";
    }

    /**
     * 添加活动
     * @param activityEditorial
     * @param eventStartTime
     * @param eventEndTime
     * @return
     */
    @RequestMapping(value = "/addActivityEditorial")
    @ResponseBody
    public String addActivityEditorial(ActivityEditorial activityEditorial, String eventStartTime, String eventEndTime) {
    	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
    	SimpleDateFormat dft = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        try {
            //验证活动名称是否重复
            if (StringUtils.isNotBlank(activityEditorial.getActivityName())) {
                boolean exists = cmsActivityEditorialService.isExistsActivityName(activityEditorial.getActivityName().trim());
                if (exists) {
                    return Constant.RESULT_STR_REPEAT;
                }
            }
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if(sysUser!=null){
            	activityEditorial.setActivityId(UUIDUtils.createUUId());
            	String sDate = df.format(activityEditorial.getActivityStartTime()); 
            	activityEditorial.setActivityStartTime(dft.parse(sDate+" "+ eventStartTime));
            	String eDate = df.format(activityEditorial.getActivityEndTime()); 
            	activityEditorial.setActivityEndTime(dft.parse(eDate+" "+ eventEndTime));
            	activityEditorial.setActivityCreateUser(sysUser.getUserId());
            	activityEditorial.setActivityUpdateUser(sysUser.getUserId());
            	boolean rsBoolean = cmsActivityEditorialService.saveActivityEditorial(activityEditorial);
            	if(rsBoolean){
            		return Constant.RESULT_STR_SUCCESS;
            	}else{
            		return Constant.RESULT_STR_FAILURE;
            	}
            }else{
            	return Constant.RESULT_STR_FAILURE;
            }
        } catch (Exception e) {
            logger.info("addActivityEditorial error {}", e);
            return Constant.RESULT_STR_FAILURE;
        }
    }

    /**
     * 跳转至活动添加页面
     * @param request
     * @param id
     * @return
     */
    @RequestMapping(value = "/preEditActivityEditorial")
    public String preEditActivityEditorial(HttpServletRequest request, String id) {
    	ActivityEditorial activityEditorial = null;
        if (StringUtils.isNotBlank(id)) {
        	activityEditorial = cmsActivityEditorialService.queryActivityEditorialByActivityId(id);
            request.setAttribute("activityEditorial", activityEditorial);
        }
        return "admin/activityEditorial/editActivityEditorial";
    }

    /**
     * 编辑活动
     * @param activityEditorial
     * @param eventStartTime
     * @param eventEndTime
     * @return
     */
    @RequestMapping(value = "/editActivityEditorial")
    @ResponseBody
    public String editActivityEditorial(ActivityEditorial activityEditorial, String eventStartTime, String eventEndTime) {
    	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
    	SimpleDateFormat dft = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        try {
        	ActivityEditorial oldActivityEditorial = cmsActivityEditorialService.queryActivityEditorialByActivityId(activityEditorial.getActivityId());
        	if(oldActivityEditorial!=null){
        		if(StringUtils.isNotBlank(activityEditorial.getActivityName())&&StringUtils.isNotBlank(oldActivityEditorial.getActivityName())){
        			if(!oldActivityEditorial.getActivityName().equals(activityEditorial.getActivityName())){
                		//验证活动名称是否重复
                        if (StringUtils.isNotBlank(activityEditorial.getActivityName())) {
                            boolean exists = cmsActivityEditorialService.isExistsActivityName(activityEditorial.getActivityName().trim());
                            if (exists) {
                                return Constant.RESULT_STR_REPEAT;
                            }
                        }
                	}
        		}else{
            		return Constant.RESULT_STR_FAILURE;
            	}
        	}else{
        		return Constant.RESULT_STR_FAILURE;
        	}
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if(sysUser!=null){
            	String sDate = df.format(activityEditorial.getActivityStartTime());
            	activityEditorial.setActivityStartTime(dft.parse(sDate+" "+ eventStartTime));
            	String eDate = df.format(activityEditorial.getActivityEndTime());
            	activityEditorial.setActivityEndTime(dft.parse(eDate+" "+ eventEndTime));
            	activityEditorial.setActivityUpdateUser(sysUser.getUserId());
            	boolean rsBoolean = cmsActivityEditorialService.editActivityEditorial(activityEditorial);
            	if(rsBoolean){
            		return Constant.RESULT_STR_SUCCESS;
            	}else{
            		return Constant.RESULT_STR_FAILURE;
            	}
            }else{
            	return Constant.RESULT_STR_FAILURE;
            }
        } catch (Exception e) {
            logger.info("editActivityEditorial error {}", e);
            return Constant.RESULT_STR_FAILURE;
        }
    }

    /**
     * 删除活动
     *
     * @param id
     * @param request
     * @return
     */
    @RequestMapping(value = "/deleteActivity", method = RequestMethod.POST)
    @ResponseBody
    public Object deleteActivity(final String id, String delOrder, final String msgSMS, HttpServletRequest request) {
        JSONObject json = new JSONObject();
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            final String userId = sysUser.getUserId();
            if (StringUtils.isNotBlank(id)) {
                ActivityEditorial activityEditorial = cmsActivityEditorialService.queryActivityEditorialByActivityId(id);
                //回收站中的撤销
                activityEditorial.setActivityIsDel(2);
                activityEditorial.setActivityState(5);
                activityEditorial.setActivityUpdateTime(new Date());
                activityEditorial.setActivityUpdateUser(userId);
                cmsActivityEditorialService.editActivityEditorial(activityEditorial);
                json.put("status", "200");
                json.put("msg", "该活动已删除");
                return json;
            }
        } catch (Exception e) {
            logger.info("deleteActivity error" + e);
            json.put("status", "404");
            json.put("msg", "该活动撤销失败");
        }
        return json;
    }

    /**
     * 将回收站的活动还原至草稿箱
     *
     * @param id
     * @param request
     * @return
     */
    @RequestMapping(value = "/returnActivity", method = RequestMethod.POST)
    @ResponseBody
    public String returnActivity(String id, HttpServletRequest request) {
        try {
            if (StringUtils.isNotBlank(id)) {
                SysUser sysUser = (SysUser) session.getAttribute("user");
                final String userId = sysUser.getUserId();
                if (StringUtils.isNotBlank(id)) {
                    ActivityEditorial activityEditorial = cmsActivityEditorialService.queryActivityEditorialByActivityId(id);
                    activityEditorial.setActivityIsDel(1);
                    activityEditorial.setActivityState(1);
                    activityEditorial.setActivityUpdateTime(new Date());
                    activityEditorial.setActivityUpdateUser(userId);
                    cmsActivityEditorialService.editActivityEditorial(activityEditorial);
                    return Constant.RESULT_STR_SUCCESS;
                }
            }
        } catch (Exception e) {
            logger.info("deleteActivity error" + e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_SUCCESS;
    }

    /**
     * 发布活动/审核活动/拒绝通过活动
     *
     * @param activityId
     * @return
     */
    @RequestMapping(value = "/publishActivity", method = RequestMethod.POST)
    @ResponseBody
    public String publishActivity(String activityId, Integer activityState) {
        try {
            if (StringUtils.isNotBlank(activityId)) {
                SysUser sysUser = (SysUser) session.getAttribute("user");
                final String userId = sysUser.getUserId();
                if (StringUtils.isNotBlank(activityId)) {
                    ActivityEditorial activityEditorial = cmsActivityEditorialService.queryActivityEditorialByActivityId(activityId);
                    activityEditorial.setActivityIsDel(1);
                    activityEditorial.setActivityState(6);
                    activityEditorial.setActivityCreateTime(new Date());
                    activityEditorial.setActivityCreateUser(userId);
                    activityEditorial.setActivityUpdateTime(new Date());
                    activityEditorial.setActivityUpdateUser(userId);
                    cmsActivityEditorialService.editActivityEditorial(activityEditorial);
                    return Constant.RESULT_STR_SUCCESS;
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            this.logger.error("publishActivity error {}", ex);
            return ex.toString();
        }
        return Constant.RESULT_STR_FAILURE;
    }
}
