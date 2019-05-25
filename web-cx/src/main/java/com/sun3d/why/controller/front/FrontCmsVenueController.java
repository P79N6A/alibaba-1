package com.sun3d.why.controller.front;

import com.sun3d.why.dao.CmsSensitiveWordsMapper;
import com.sun3d.why.model.*;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.*;
import com.sun3d.why.statistics.service.StatisticService;
import com.sun3d.why.util.CmsSensitive;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * <p/>
 * 处理场馆前台页面请求
 * <p/>
 * Created by cj on 2015/6/16
 */
@RequestMapping("/frontVenue")
@Controller
public class FrontCmsVenueController {
    private Logger logger = Logger.getLogger(FrontCmsVenueController.class);
    //场馆逻辑控制层
    @Autowired
    private CmsVenueService cmsVenueService;
    //数据字典逻辑控制层
    @Autowired
    private SysDictService sysDictService;
    //馆藏逻辑控制层
    @Autowired
    private CmsAntiqueService cmsAntiqueService;
    //标签逻辑控制层
    @Autowired
    private CmsTagService cmsTagService;
    //数据统计逻辑控制层
    @Autowired
    private StatisticService statisticService;
    //活动室逻辑控制层
    @Autowired
    private CmsActivityRoomService cmsActivityRoomService;
    //评论列表
    @Autowired
    private CmsCommentService cmsCommentService;
    //团体逻辑控制层
    @Autowired
    private CmsTeamUserService cmsTeamUserService;
    //当前session
    @Autowired
    private HttpSession session;
    @Autowired
    private CacheService cacheService;
    @Autowired
    private StaticServer staticServer;
    @Autowired
    private CmsSensitiveWordsMapper cmsSensitiveWordsMapper;
    @Autowired
    private CmsVideoService cmsVideoService;
    /**
     * 返回前台场馆首页数据
     *
     * @return
     */
    @RequestMapping(value = "/venueIndex")
    public ModelAndView venueIndex() {
        ModelAndView model = new ModelAndView();
        try {
            //最新需求，只列出场馆类型标签
            List<CmsTag> list = new ArrayList<CmsTag>();
            List<SysDict> dicts = sysDictService.querySysDictByCode("VENUE_TYPE");
            if (dicts != null && dicts.size() > 0) {
                list = cmsTagService.queryCmsTagByCondition(dicts.get(0).getDictId(), 20);
            }
            //列出场馆推荐标签--暂时移除推荐标签、只保留类型标签
//            model.addObject("typeList", cmsTagService.getTagsByDictTagType("venue"));
            model.addObject("typeList",list);
            model.setViewName("index/venue/venueIndex");
        } catch (Exception e) {
            logger.error("加载场馆前台首页数据时出错!", e);
        }
        return model;
    }

    /**
     * 返回前台场馆列表数据
     *
     * @return
     */
    @RequestMapping(value = "/venueList")
    public ModelAndView venueList(HttpServletRequest request,String keyword) {
        ModelAndView model = new ModelAndView();
        List<CmsTag> typeList = null;
        try {
            // 场馆类型
            SysDict sysDict = new SysDict();
            sysDict.setDictCode(Constant.VENUE_TYPE);
            sysDict.setDictName("场馆类型");
            SysDict dict = sysDictService.querySysDict(sysDict);
            if (dict != null && StringUtils.isNotBlank(dict.getDictId())) {
                typeList = cmsTagService.queryCmsTagByCondition(dict.getDictId(), null);
            }
        } catch (Exception e) {
            logger.error("加载场馆前台场馆列表数据时出错!", e);
        }
        model.setViewName("index/venue/venueList");
        model.addObject("typeList", typeList);
        model.addObject("keyword", keyword);
        request.setAttribute("provinceNo", staticServer.getCityInfo().split(",")[2]);
        request.setAttribute("cityNo", staticServer.getCityInfo().split(",")[3]);
        return model;
    }

    /**
     * 返回前台首页场馆列表数据
     *
     * @return
     */
    @RequestMapping(value = "/venueIndexListLoad")
    public ModelAndView venueIndexListLoad(Pagination page, String tagId, String venueName, String venueArea) {
        ModelAndView model = new ModelAndView();
        List<CmsVenue> venueList = null;
        boolean defaultFlag = true;
        try {
            //设置每页30条记录
            page.setRows(30);
            CmsVenue cmsVenue = new CmsVenue();
            cmsVenue.setVenueState(Constant.PUBLISH);
            cmsVenue.setVenueIsDel(Constant.NORMAL);
            //按场馆名称搜索
            if (StringUtils.isNotBlank(venueName)) {
                cmsVenue.setVenueName(venueName);
                defaultFlag = false;
            }
            //按所在区域搜索
            if (StringUtils.isNotBlank(venueArea)) {
                cmsVenue.setVenueArea(venueArea);
                defaultFlag = false;
            }
            //标签模糊匹配搜索
            if (StringUtils.isNotBlank(tagId)) {
                cmsVenue.setTagId(tagId);
                defaultFlag = false;
            }
            List<CmsVenue> redisVenueList = null;
            //如果不加任何条件，则为默认搜索，从Redis中取值
            if(defaultFlag && page.getPage() == 1){
                String venueIndexDefaultKey = Constant.VENUE_INDEX_REDIS_DEFAULT;
                redisVenueList = cacheService.getVenueIndexList(venueIndexDefaultKey);
            }
            if(redisVenueList == null || redisVenueList.size() == 0){
                venueList = cmsVenueService.queryFrontCmsVenueByCondition(cmsVenue, page);
                if(defaultFlag && page.getPage() == 1){
                    cacheService.updateVenueIndex(Constant.VENUE_INDEX_REDIS_DEFAULT,venueList);
                    cacheService.setVenueIndexTotal(Constant.VENUE_INDEX_DEFAULT_TOTAL,page.getTotal());
                }
            }else{
                venueList = redisVenueList;
                int total = cacheService.getVenueIndexTotal(Constant.VENUE_INDEX_DEFAULT_TOTAL);
                page.setTotal(total);
            }
        } catch (Exception e) {
            logger.error("加载场馆前台首页数据时出错!", e);
        }
        model.setViewName("index/venue/venueIndexLoad");
        model.addObject("venueList", venueList);
        model.addObject("page", page);
        return model;
    }

    /**
     * 返回前台场馆列表数据
     *
     * @return
     */
    @RequestMapping(value = "/venueListLoad")
    public ModelAndView venueListLoad(CmsVenue venue, Pagination page) {
        ModelAndView model = new ModelAndView();
        List<CmsVenue> venueList = null;
        try {
            //设置每页20条记录
            page.setRows(20);
            venueList = cmsVenueService.queryVenueByConditionSort(venue, page);
        } catch (Exception e) {
            logger.error("加载场馆前台首页数据时出错!", e);
        }
        model.setViewName("index/venue/venueListLoad");
        model.addObject("venueList", venueList);
        model.addObject("page", page);
        return model;
    }

    /**
     * 前台显示场馆详情数据
     *
     * @param venueId
     * @return
     */
    @RequestMapping(value = "/venueDetail")
    public ModelAndView venueDetail(String venueId) {
        ModelAndView model = new ModelAndView();
        List<CmsTeamUser> teamUserList = null;
        CmsVenue cmsVenue = null;
        List<CmsTag> tagList = null;
        List<CmsTag> typeList = null;
        List<SysDict> venueFacility= null;
        SysDict location = null;
        CmsStatistics statistics = null;
        int commentCount = 0;
        String venueTime = null;
        //从session中获取登录用户
        CmsTerminalUser cmsTerminalUser = (CmsTerminalUser) session.getAttribute("terminalUser");
        //判断用户有哪些团体(用户必须已登录)
        if (cmsTerminalUser != null) {
            teamUserList = cmsTeamUserService.queryTeamUserList(cmsTerminalUser.getUserId());
        }
        if (StringUtils.isNotBlank(venueId)) {
            //场馆信息
            cmsVenue = this.cmsVenueService.queryVenueById(venueId);
            //场馆类型标签
            typeList = cmsTagService.queryTeamTags(cmsVenue.getVenueType());
            //场馆位置
            location = sysDictService.querySysDictByDictId(cmsVenue.getVenueMood());
            
            if(StringUtils.isNotBlank( cmsVenue.getVenueFacility())){
            	
            	venueFacility=sysDictService.querySysDictListByIds( cmsVenue.getVenueFacility());
            }

            //统计数据(喜欢、浏览)
            statistics = statisticService.queryStatistics(venueId, Constant.COLLECT_VENUE);
            //评论数量
            CmsComment cmsComment = new CmsComment();
            cmsComment.setCommentRkId(venueId);
            cmsComment.setCommentType(Constant.TYPE_VENUE);
            commentCount = cmsCommentService.queryCommentCountByCondition(cmsComment);
            //获取前台显示的时间
            venueTime = getVenueTimeStr(cmsVenue);

            String star = cmsVenueService.queryVenueScore(venueId);
            if(StringUtils.isBlank(star) || "0.0".equals(star)){
                cmsVenue.setVenueStars("5");
            }else{
                BigDecimal data = new BigDecimal(star).setScale(0, BigDecimal.ROUND_HALF_UP);
                cmsVenue.setVenueStars(data.toString());
            }

        }
        
        //场馆视频
        CmsVideo cmsVideo = new CmsVideo();
        cmsVideo.setReferId(venueId);
        cmsVideo.setVideoType(2);
        List<CmsVideo> cmsVideoList = cmsVideoService.cmsVideoList(cmsVideo, null);
        
        model.setViewName("index/venue/venueDetail");
        model.addObject("cmsVenue", cmsVenue);
        model.addObject("tagList", tagList);
        model.addObject("statistics", statistics);
        model.addObject("commentCount", commentCount);
        model.addObject("venueTime", venueTime);
        model.addObject("teamUserList", teamUserList);
        model.addObject("typeList", typeList);
        model.addObject("location", location);
        model.addObject("cmsVideoList", cmsVideoList);
        model.addObject("venueFacilityList", venueFacility);
        return model;
    }
    
    /**
     * 场馆视频详情
     * @param venueId 场馆id
     * @param videoId 视频id
     * @return
     */
    @RequestMapping(value = "/frontVenueVideo")
    public ModelAndView frontVenueVideo(String videoId,String venueId) {
        ModelAndView model = new ModelAndView();
        
        try {
			//场馆详情
			CmsVenue cmsVenue = cmsVenueService.queryVenueById(venueId);
			model.addObject("cmsVenue", cmsVenue);
			
			//场馆视频
			CmsVideo cmsVideo = new CmsVideo();
			cmsVideo.setReferId(venueId);
			cmsVideo.setVideoType(2);
			List<CmsVideo> cmsVideoList = cmsVideoService.cmsVideoList(cmsVideo, null);
			model.addObject("cmsVideoList", cmsVideoList);
			
			//视频详情
			CmsVideo video = cmsVideoService.queryVideoByVideoId(videoId);
			model.addObject("CmsVideo", video);
		} catch (Exception e) {
			logger.error("frontVenueVideo error {}", e);
			e.printStackTrace();
		}
        
        model.setViewName("index/venue/venueVideo");
        return model;
    }

    /**
     * 前台场馆详情显示推荐馆藏
     *
     * @param venueId
     * @return
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
     * 前台场馆详情显示推荐活动室
     *
     * @param venueId
     * @param pageNum
     * @return
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
     * 前台场馆详情显示推荐场馆
     *
     * @param venueId
     * @return
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
     * 前台场馆详情显示评论列表
     *
     * @param rkId
     * @param pageNum
     * @param typeId
     * @return
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

    /**
     * 前端2.0 添加评论
     *
     * @param comment
     * @param venueId
     * @return
     */
    @RequestMapping(value = "/addComment", method = {RequestMethod.POST})
    @ResponseBody
    public String addComment(CmsComment comment, String venueId) {
        try {
            if (session.getAttribute("terminalUser") != null) {
                String sensitiveWords = CmsSensitive.sensitiveWords(comment, cmsSensitiveWordsMapper);
                if (StringUtils.isNotBlank(sensitiveWords) && sensitiveWords.equals("sensitiveWordsExist")) {
                    return Constant.SensitiveWords_EXIST;
                }

                CmsTerminalUser user = (CmsTerminalUser) session.getAttribute("terminalUser");
                comment.setCommentUserId(user.getUserId());
                comment.setCommentType(Constant.TYPE_VENUE);
                comment.setCommentRkId(venueId);
                return cmsCommentService.addComment(comment);
            }
        } catch (Exception e) {
            logger.info("addComment error", e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }

    /**
     * 根据后台场馆信息 星期一至星期日的选中情况返回显示信息
     *
     * @param cmsVenue
     * @return
     */
    public String getVenueTimeStr(CmsVenue cmsVenue) {
        String venueTime = "";

        String first = "";
        String last = "";

        if (cmsVenue.getVenueMon().equals("1")) {
            first = "周一";
        }
        if (cmsVenue.getVenueTue().equals("1")) {
            if (first.equals("")) {
                first = "周二";
            }
            last = "周二";
        }
        if (cmsVenue.getVenueWed().equals("1")) {
            if (first.equals("")) {
                first = "周三";
            }
            last = "周三";
        }
        if (cmsVenue.getVenueThu().equals("1")) {
            if (first.equals("")) {
                first = "周四";
            }
            last = "周四";
        }
        if (cmsVenue.getVenueFri().equals("1")) {
            if (first.equals("")) {
                first = "周五";
            }
            last = "周五";
        }
        if (cmsVenue.getVenueSat().equals("1")) {
            if (first.equals("")) {
                first = "周六";
            }
            last = "周六";
        }

        if (cmsVenue.getVenueSun().equals("1")) {
            if (first.equals("")) {
                first = "周日";
            }
            last = "周日";
        }
        if (!first.equals("") && !last.equals("")) {
            if (first.equals(last)) {
                venueTime = first;
            } else {
                venueTime = first + " 至 " + last;
            }
        }
        return venueTime;
    }


}
