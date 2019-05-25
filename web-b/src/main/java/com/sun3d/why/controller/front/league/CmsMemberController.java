package com.sun3d.why.controller.front.league;

import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.league.CmsMemberBO;
import com.sun3d.why.service.league.CmsMemberService;
import com.sun3d.why.util.JSONResponse;
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


    /**
     * 成员列表页
     * @return
     */
    @RequestMapping("/list")
    public ModelAndView list(CmsMemberBO member) {
        ModelAndView model = new ModelAndView();
        try {
            List<CmsMemberBO> list = memberService.queryList(member);
            model.addObject("member", member);
            model.addObject("list", list);
            model.setViewName("admin/league/member_list");
        } catch (Exception e) {
            logger.error("activityIndex error {}", e);
        }
        return model;
    }


    /**
     * 新增培训页
     *
     * @return
     */
    @RequestMapping("/toSave")
    public String preActivityDetail(CmsMemberBO bo, HttpServletRequest request) {
        if (StringUtils.isNotBlank(bo.getId())) {
            CmsMemberBO member = memberService.selectByPrimaryKey(bo.getId());
            request.setAttribute("member", member);
        }
        return "admin/league/member_add";
    }

    @RequestMapping("/save")
    @ResponseBody
    public String save(CmsMemberBO member) {
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            return memberService.save(member, sysUser);
        } catch (Exception e) {
            e.printStackTrace();
            return JSONResponse.getResult(500, "系统异常，操作失败!");
        }
    }

    /**
     * 关联场馆页
     * @param venueIds
     * @param memberId
     * @param state
     * @return
     */
    @RequestMapping("/relationVenue")
    @ResponseBody
    public String relationVenue(String[] venueIds,String memberId,Integer state){
        return memberService.relationVenue(venueIds,memberId,state);
    }




    /**
     * 关联成员页
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
     * 资讯关联成员页
     * @param state
     * @return
     */
    @RequestMapping("/relationMember")
    @ResponseBody
    public String relationMember(String[] memberIds,String infoId,Integer state){
        return memberService.relationMember(memberIds,infoId,state);
    }

}