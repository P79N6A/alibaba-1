package com.sun3d.why.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sun3d.why.model.CmsVenue;
import com.sun3d.why.model.SysDept;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.weixin.WeiXin;
import com.sun3d.why.service.SysUserRoleService;
import com.sun3d.why.service.WeiXinService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;

/**
 * 活动室模块控制层，负责跟页面数据的交互以及对下层的数据方法的调用
 * <p/>
 * Created by cj on 2015/4/21.
 */
@Controller
@RequestMapping(value = "/weiXin")
public class WeiXinController {
	    private Logger logger = LoggerFactory.getLogger(CmsActivityController.class);
	    @Autowired
	    private WeiXinService weiXinService;
	    //当前session
	    @Autowired
	    private HttpSession session;
	  /**
     * 自动回复内容列表页
     *
     * @param activity
     * @param page
     * @return
     */
    @RequestMapping("/weiXinIndex")
    public ModelAndView activityIndex(WeiXin weiXin,Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
        	List<WeiXin> list = weiXinService.queryWeiXinByCondition(weiXin, page);
            model.addObject("list", list);
            model.addObject("page", page);
        	model.setViewName("admin/weiXin/weiXinIndex");
        } catch (Exception e) {
            logger.error("activityIndex error {}", e);
        }
        return model;
    }
    /**
     * 编辑自动回复信息
     * @param venueId
     * @return
     */
    @RequestMapping(value = "/preEditWeiXin")
    public ModelAndView preEditVenue(String weiXinId) {
        ModelAndView model = new ModelAndView();
        WeiXin weiXin = null;
        try{
            //从session中获取用户信息
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if(sysUser != null && StringUtils.isNotBlank(weiXinId)) {//00e8bdb1b4a64f3cb475bec6fdc7e729
            	weiXin = weiXinService.queryWeixinById(weiXinId);
            	String autoContent= weiXinService.queryWeiXin().getAutoContent();
            	System.out.println("!!!!!"+autoContent);
            }
        }catch (Exception e){
            logger.error("加载编辑页面时出错!", e);
        }
        model.addObject("weiXin",weiXin);
        model.setViewName("admin/weiXin/weiXinEdit");
        return model;
    }
    /**
     * 保存编辑后的信息
     * @param venue
     * @return
     */
    @RequestMapping(value = "/editWeiXin")
    @ResponseBody
    public String editWeiXin(WeiXin weiXin) {
        //默认为0，如果后续流程执行出错，则操作失败
        int count = 0;
        try {
            //从session中获取用户信息
            SysUser sysUser = (SysUser) session.getAttribute("user");
            System.out.println();
            if(sysUser != null){
            	weiXin.setUpdateTime(new Date());
                count = weiXinService.editWeiXinById(weiXin);
            }else{
                logger.error("当前登录用户不存在或没有登录，添加操作终止!");
            }
        } catch (Exception e) {
            logger.error("添加自动回复信息时出错!", e);
        }
        if(count>0){
            return Constant.RESULT_STR_SUCCESS;
        }else {
            return Constant.RESULT_STR_FAILURE;
        }
}
}
