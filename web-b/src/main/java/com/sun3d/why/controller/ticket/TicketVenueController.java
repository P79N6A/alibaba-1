package com.sun3d.why.controller.ticket;

import com.sun3d.why.model.*;
import com.sun3d.why.service.*;
import com.sun3d.why.statistics.service.StatisticService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Title: TicketVenueController
 * @Package com.sun3d.why.controller.ticket
 * @Description: 【订票-场馆模块】对应请求的处理
 * @Author CJ
 * @Date 2015/12/23
 * @Version V3.1
 */
@RequestMapping(value = "/ticketVenue")
@Controller
public class TicketVenueController {

    /**
     * 日志
     */
    private Logger logger = Logger.getLogger(TicketVenueController.class);
    /**
     * 场馆所有服务接口
     */
    @Autowired
    private CmsVenueService cmsVenueService;
    /**
     * 字典服务接口
     */
    @Autowired
    private SysDictService sysDictService;
    /**
     * 标签服务接口
     */
    @Autowired
    private CmsTagService cmsTagService;
    /**
     * 团体服务接口
     */
    @Autowired
    private CmsTeamUserService cmsTeamUserService;
    /**
     * 评论服务接口
     */
    @Autowired
    private CmsCommentService cmsCommentService;
    /**
     * 藏品服务接口
     */
    @Autowired
    private CmsAntiqueService cmsAntiqueService;
    /**
     * 活动室服务接口
     */
    @Autowired
    private CmsActivityRoomService cmsActivityRoomService;
    /**
     * 数据统计
     */
    @Autowired
    private StatisticService statisticService;
    /**
     * session信息
     */
    @Autowired
    private HttpSession session;

    /**
     * @Description: 仅仅跳转至【订票-场馆列表】页面
     * @Return ModelAndView 数据与视图
     * @Throws
     * @Author CJ
     * @Date 2015/12/23
     */
    @RequestMapping(value = "/venueList")
    public ModelAndView venueList() {
        ModelAndView modelAndView = new ModelAndView();
        //最新需求，只列出场馆类型标签
        List<CmsTag> typeList = new ArrayList<CmsTag>();
        List<SysDict> dictList = sysDictService.querySysDictByCode(Constant.VENUE_TYPE);
        if (dictList != null && dictList.size() > 0) {
            typeList = cmsTagService.queryCmsTagByCondition(dictList.get(0).getDictId(), 20);
        }
        modelAndView.addObject("typeList",typeList);
        //跳转视图名称【why/ticket/venue/ticketVenueList.jsp】
        modelAndView.setViewName("ticket/venue/ticketVenueList");
        return modelAndView;
    }

    /**
     * @Description: 显示场馆列表数据以及检索【场馆类型、所在区县、所属商圈】
     * @Param Pagination page 分页信息
     * @Param CmsVenue venueCondition 查询条件
     * @Return ModelAndView 数据与视图
     * @Throws
     * @Author CJ
     * @Date 2015/12/23
     */
    @RequestMapping(value = "/venueListLoad")
    public ModelAndView venueListLoad(Pagination page,CmsVenue venue){
        ModelAndView modelAndView = new ModelAndView();
        //每页显示9条
        page.setRows(12);
        //场馆列表数据
        List<CmsVenue> venueList = null;
        try {
           venueList = cmsVenueService.queryVenueByConditionSort(venue, page);
        } catch (Exception e) {
            logger.error("[TicketVenueController.venueListLoad——>]数据出错：",e);
        }
        //场馆列表页分页信息
        modelAndView.addObject("page",page);
        modelAndView.addObject("venueList",venueList);
        //跳转视图名称【why/ticket/venue/ticketVenueList.jsp】
        modelAndView.setViewName("ticket/venue/ticketVenueListLoad");
        return modelAndView;
    }

    /**
     * @Description: 根据场馆ID查询场馆详情
     * @Param String venueId 场馆ID
     * @Return ModelAndView 数据与视图
     * @Throws
     * @Author CJ
     * @Date 2015/12/24
     */
    @RequestMapping(value = "/venueDetail")
    public ModelAndView venueDetail(String venueId) {
        ModelAndView model = new ModelAndView();
        List<CmsTeamUser> teamUserList = null;
        CmsVenue cmsVenue = null;
        List<CmsTag> tagList = null;
        List<CmsTag> typeList = null;
        SysDict location = null;
        CmsStatistics statistics = null;
        int commentCount = 0;
        String venueTime = null;
        //从session中获取登录用户
        CmsTerminalUser cmsTerminalUser = (CmsTerminalUser) session.getAttribute("terminalUser");
        //判断用户有哪些团体(用户必须已登录)
        if (cmsTerminalUser != null) {
            teamUserList = cmsTeamUserService .queryTeamUserList(cmsTerminalUser.getUserId());
        }
        if (StringUtils.isNotBlank(venueId)) {
            //场馆信息
            cmsVenue = this.cmsVenueService.queryVenueById(venueId);
            //场馆类型标签
            typeList = cmsTagService.queryTeamTags(cmsVenue.getVenueType());
            //场馆位置
            location = sysDictService.querySysDictByDictId(cmsVenue.getVenueMood());

            //统计数据(喜欢、浏览)
            statistics = statisticService.queryStatistics(venueId, Constant.COLLECT_VENUE);
            //评论数量
            CmsComment cmsComment = new CmsComment();
            cmsComment.setCommentRkId(venueId);
            cmsComment.setCommentType(Constant.TYPE_VENUE);
            commentCount = cmsCommentService.queryCommentCountByCondition(cmsComment);
            //获取前台显示的时间
//            venueTime = getVenueTimeStr(cmsVenue);
        }
        model.setViewName("ticket/venue/ticketVenueDetail");
        model.addObject("cmsVenue", cmsVenue);
        model.addObject("tagList", tagList);
        model.addObject("statistics", statistics);
        model.addObject("commentCount", commentCount);
        model.addObject("venueTime", venueTime);
        model.addObject("teamUserList", teamUserList);
        model.addObject("typeList", typeList);
        model.addObject("location", location);
        return model;
    }

    /**
     * @Description: 场馆详情显示推荐馆藏
     * @Param String venueId 场馆ID
     * @Return ModelAndView 数据与视图
     * @Throws
     * @Author CJ
     * @Date 2015/12/24
     */
    @RequestMapping(value = "/antiqueList")
    @ResponseBody
    public List<CmsAntique> antiqueList(String venueId) {
        CmsAntique condition = new CmsAntique();
        condition.setVenueId(venueId);
        condition.setAntiqueIsDel(Constant.NORMAL);
        condition.setAntiqueState(Constant.PUBLISH);
        condition.setRows(6);
        List<CmsAntique> antiqueList = cmsAntiqueService.queryByCmsAntique(condition);
        return antiqueList;
    }

    /**
     * @Description: 场馆详情显示推荐活动室
     * @Param String venueId 场馆ID
     * @Param Integer pageNum 分页码
     * @Return ModelAndView 数据与视图
     * @Throws
     * @Author CJ
     * @Date 2015/12/24
     */
    @RequestMapping(value = "/roomList")
    @ResponseBody
    public Map<String, Object> roomList(String venueId, Integer pageNum) {
        CmsActivityRoom cmsActivityRoom = new CmsActivityRoom();
        cmsActivityRoom.setVenueId(venueId);
        //活动室显示数量每页为4个
        cmsActivityRoom.setRows(4);
        if (pageNum != null) {
            cmsActivityRoom.setPage(pageNum);
        }
        List<CmsActivityRoom> roomList = cmsActivityRoomService.queryRelatedRoom(cmsActivityRoom, false);
        int roomCount = cmsActivityRoomService.queryRelatedRoomCount(cmsActivityRoom, false);

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("roomList", roomList);
        map.put("roomCount", roomCount);
        return map;
    }

    /**
     * @Description: 场馆详情显示推荐场馆
     * @Param String venueId 场馆ID
     * @Return ModelAndView 数据与视图
     * @Throws
     * @Author CJ
     * @Date 2015/12/24
     */
    @RequestMapping(value = "/relatedVenueList")
    @ResponseBody
    public List<CmsVenue> relatedVenueList(String venueId) {
        List<CmsVenue> venueList = null;
        int maxCount = 3;
        if (StringUtils.isNotBlank(venueId)) {
            //场馆信息
            CmsVenue cmsVenue = this.cmsVenueService.queryVenueById(venueId);
            CmsVenue venueCondition = new CmsVenue();
            venueCondition.setVenueArea(cmsVenue.getVenueArea());
            venueCondition.setVenueId(venueId);
            venueCondition.setRows(maxCount);

            int relatedVenueCount = cmsVenueService.queryRelatedVenueCount(venueCondition,true);
            if(relatedVenueCount >= maxCount){
                venueList = cmsVenueService.queryRelatedVenue(venueCondition,true);
            }else{
                venueCondition.setVenueArea("");
                venueList = cmsVenueService.queryRelatedVenue(venueCondition,true);
            }
        }
        return venueList;
    }

    /**
     * @Description: 场馆详情显示评论列表
     * @Param String rkId 关联ID(如果为场馆，则为场馆ID)
     * @Param Integer pageNum 分页码
     * @Param Integer typeId 类型代码(如果为场馆，则为1)
     * @Return ModelAndView 数据与视图
     * @Throws
     * @Author CJ
     * @Date 2015/12/24
     */
    @RequestMapping(value = "/commentList")
    @ResponseBody
    public List<CmsComment> commentList(String rkId, Integer pageNum, Integer typeId) {
        //评论列表
        CmsComment cmsComment = new CmsComment();
        cmsComment.setCommentRkId(rkId);
        cmsComment.setCommentType(typeId);
        Pagination page = new Pagination();
        page.setRows(5);
        page.setPage(pageNum);
        List<CmsComment> commentList = cmsCommentService.queryCommentByCondition(cmsComment, page, null);
        return commentList;
    }

}
