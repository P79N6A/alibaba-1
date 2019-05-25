package com.sun3d.why.controller.front.league;

import com.alibaba.fastjson.JSONObject;
import com.sun3d.why.model.*;
import com.sun3d.why.model.league.CmsMemberBO;
import com.sun3d.why.service.*;
import com.sun3d.why.service.league.CmsMemberService;
import com.sun3d.why.util.Pagination;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;

/*
 * @auther liunima
 * 联盟成员
 */
@Controller
@RequestMapping(value = "/member")
public class CmsMemberController {
    /**
     * 导入log4j日志管理，记录错误信息
     */
    private Logger logger = Logger.getLogger(this.getClass().getName());


    @Autowired
    private HttpSession session;

    @Autowired
    private CmsMemberService memberService;

    @Autowired
    private CmsActivityService activityService;

    @Autowired
    private CmsVenueService venueService;

    @Autowired
    private BpInfoService infoService;

    @Autowired
    private CmsCommentService commentService;

    @Autowired
    private CmsCulturalOrderService culturalOrderService;

    /**
     * 成员列表页
     *
     * @return
     */
    @RequestMapping("/leagueMember")
    @ResponseBody
    public String list(CmsMemberBO member) {
        JSONObject obj = new JSONObject();
        try {
            obj.put("list", memberService.queryList(member));
            obj.put("member", member);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return obj.toJSONString();
    }


    /**
     * 成员首页
     *
     * @return
     */
    @RequestMapping("/memberIndex")
    public String memberIndex(CmsMemberBO bo, HttpServletRequest request) {
        if (StringUtils.isNotBlank(bo.getId())) {
            CmsMemberBO member = memberService.selectByPrimaryKey(bo.getId());
            request.setAttribute("member", member);
        }
        return "index/league/member_index";
    }

    @RequestMapping("/activityQueryList")
    @ResponseBody
    public String activityQueryList(CmsMemberBO bo) {
        JSONObject jsonObject = new JSONObject();
        try {
            CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute("terminalUser");
            if (terminalUser != null) {
                bo.setCreateUser(terminalUser.getUserId());
            }
            List<CmsActivity> activities = activityService.queryCmsActivityByMember(bo);
            jsonObject.put("list", activities);
            jsonObject.put("member", bo);
            System.out.println(jsonObject.toString());
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return jsonObject.toString();
    }

    @RequestMapping("/activityList")
    public String activityList(CmsMemberBO bo, HttpServletRequest request) {
       /* try {
            CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute("terminalUser");
            if(terminalUser!=null){
                bo.setCreateUser(terminalUser.getUserId());
            }
            List<CmsActivity> activities = activityService.queryCmsActivityByMember(bo);
            request.setAttribute("list", activities);*/
        request.setAttribute("member", bo);
       /* } catch (Exception ex) {
            ex.printStackTrace();
        }*/
        return "index/league/member_activity_load";
    }

    @RequestMapping("/venueList")
    public String venueList(CmsMemberBO bo, HttpServletRequest request) {
        request.setAttribute("member", bo);
        return "index/league/member_venue_load";
    }

    @RequestMapping("/venueQueryList")
    @ResponseBody
    public String venueQueryList(CmsMemberBO bo) {
        JSONObject jsonObject = new JSONObject();
        try {
            List<CmsVenue> venues = venueService.queryVenueByMember(bo);
            jsonObject.put("list", venues);
            jsonObject.put("member", bo);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return jsonObject.toString();
    }

    @RequestMapping("/infoList")
    public String infoList(CmsMemberBO bo, HttpServletRequest request) {
        request.setAttribute("member", bo);
        return "index/league/member_info_load";
    }

    @RequestMapping("/infoQueryList")
    @ResponseBody
    public String infoQueryList(CmsMemberBO bo) {
        JSONObject jsonObject = new JSONObject();
        try {
            List<BpInfo> infos = infoService.queryInfoByMember(bo);
            jsonObject.put("list", infos);
            jsonObject.put("member", bo);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return jsonObject.toString();
    }


    /**
     * 关联成员页
     *
     * @return
     */
    @RequestMapping("/relationMemberList")
    public ModelAndView relationMemberList(CmsMemberBO member) {
        ModelAndView model = new ModelAndView();
        try {
            List<CmsMemberBO> list = memberService.queryRelationMemberList(member);
            model.addObject("member", member);
            model.addObject("list", list);
            model.setViewName("admin/league/relation_member_list");
        } catch (Exception e) {
            logger.error("activityIndex error {}", e);
        }
        return model;
    }

    /**
     * 成员评论页
     *
     * @return
     */
    @RequestMapping("/memberComment")
    public String memberComment(CmsMemberBO bo, HttpServletRequest request, Pagination page) {
        request.setAttribute("member", bo);
        //评论列表 CmsComment comment, Pagination page, SysUser sysUser
        CmsComment comment = new CmsComment();
        comment.setCommentType(21);
        comment.setCommentRkId(bo.getId());
        List<CmsComment> commentList = commentService.queryCommentByCondition(comment, page, null);
        request.setAttribute("list", commentList);
        request.setAttribute("page", page);
        return "index/league/member_comment";
    }


    /**
     * 文化点单页
     * @param bo
     * @param request
     * @return
     */
    @RequestMapping("/culturalOrderList")
    public String culturalOrderList(CmsMemberBO bo, HttpServletRequest request) {
        request.setAttribute("member", bo);
        return "index/league/member_cultural_order_load";
    }

    @RequestMapping("/loadCulturalOrderList")
    @ResponseBody
    public String loadCulturalOrderList(CmsMemberBO bo, CmsCulturalOrder cmsCulturalOrder, Pagination page) {
        JSONObject jsonObject = new JSONObject();
        try {
            List<CmsCulturalOrder> orders = culturalOrderService.queryCulturalOrderList(
                    cmsCulturalOrder, page, 2, bo.getId());
            jsonObject.put("list", orders);
            jsonObject.put("page", page);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return jsonObject.toString();
    }

}