package com.sun3d.why.controller;

import com.sun3d.why.dao.CmsCulturalSquareMapper;
import com.sun3d.why.model.*;
import com.sun3d.why.model.temp.ActivityForCompare;
import com.sun3d.why.service.*;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.ExportExcel;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.*;

@RequestMapping("/activity")
@Controller
public class CmsActivityController {
    private Logger logger = LoggerFactory.getLogger(CmsActivityController.class);
    @Autowired
    private CmsActivityService activityService;
    @Autowired
    private HttpSession session;
    @Autowired
    private SysDictService sysDictService;
    @Autowired
    private CmsActivitySeatService cmsActivitySeatService;
    @Autowired
    private CmsVenueSeatTemplateService cmsVenueSeatTemplateService;

    @Autowired
    private CmsActivityOrderService cmsActivityOrderService;

    @Autowired
    private CmsActivityEventService cmsActivityEventService;

    @Autowired
    private CacheService cacheService;

    @Autowired
    private ExportExcel exportExcel;

    @Autowired
    private CmsActivityEditorialService editorialService;

    @Autowired
    private SysUserAddressService sysUserAddressService;

    @Autowired
    private CmsTagSubRelateService cmsTagRelateService;
    
    @Autowired
	private CmsCulturalSquareMapper cmsCulturalSquareMapper;

    /**
     * 活动列表页
     * @param activity
     * @param page
     * @return
     */
    @RequestMapping("/activityIndex")
    public ModelAndView activityIndex(CmsActivity activity, Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            List<CmsActivity> activityList = activityService.queryCmsActivityByAdminCondition(activity, page, sysUser);

            model.addObject("activityList", activityList);
            model.addObject("page", page);
            model.addObject("activity", activity);
            model.setViewName("admin/activity/activityIndex");
        } catch (Exception e) {
            logger.error("activityIndex error {}", e);
        }
        return model;
    }
    
    /**
     * 活动审核列表页
     * @param activity
     * @param page
     * @return
     */
    @RequestMapping("/activityExamineIndex")
    public ModelAndView activityExamineIndex(CmsActivity activity, Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            List<CmsActivity> activityList = activityService.queryCmsActivityByAdminCondition(activity, page, sysUser);

            model.addObject("activityList", activityList);
            model.addObject("page", page);
            model.addObject("activity", activity);
            model.setViewName("admin/activity/activityExamineIndex");
        } catch (Exception e) {
            logger.error("activityExamineIndex error {}", e);
        }
        return model;
    }

    /**
     * 主题栏目跳转活动列表页
     *
     * @param activity
     * @param page
     * @return
     */
    @RequestMapping("/subjectActivityIndex")
    public ModelAndView subjectActivityIndex(CmsActivity activity, String referId, Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            List<CmsActivity> activityList = activityService.queryCmsActivityByCondition(activity, page, sysUser);
            model.addObject("activityList", activityList);
            model.addObject("page", page);
            model.addObject("activity", activity);
            model.addObject("referId", referId);
            model.setViewName("admin/activity/subjectActivityIndex");
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
    @RequestMapping(value = "/preAddActivity")
    public String preAdd(HttpServletRequest request) {
        //数据字典
        SysDict sysDict = new SysDict();
        sysDict.setDictCode(Constant.TAG_TYPE);
        sysDict.setDictName(Constant.ACTIVITY_NAME);
        SysDict dict = sysDictService.querySysDict(sysDict);
        if (dict != null && StringUtils.isNotBlank(dict.getDictId())) {
            request.setAttribute("dictId", dict.getDictId());
        }
        //user
        request.setAttribute("user", session.getAttribute("user"));
        return "admin/activity/addAct";
    }

    /**
     * 保存添加活动
     *
     * @param activity
     * @return
     */
    @RequestMapping(value = "/addActivity")
    @ResponseBody
    public String addActivity(final CmsActivity activity) {
        try {
            if (activity != null) {
                final SysUser sysUser = (SysUser) session.getAttribute("user");
                if (StringUtils.isNotBlank(activity.getActivityId())) {
                    List<CmsActivityOrder> cmsActivityOrders = cmsActivityOrderService.queryCmsActivityOrderListByActivityId(activity.getActivityId());
                    //存在订单的时候 不对座位信息进行修改
                    boolean hadOrderInfo = false;
                    if (cmsActivityOrders != null && cmsActivityOrders.size() > 0) {
                        hadOrderInfo = true;
                    }
                    
                    //如果状态为审核未通过，修改后变为未审核
                    CmsActivity oldCmsActivity = activityService.queryCmsActivityByActivityId(activity.getActivityId());
                    if(oldCmsActivity.getActivityIsDel() == 3){
                    	activity.setActivityIsDel(0);
                    }
                    
                    String rsStrs = activityService.editActivity(activity, sysUser, null, hadOrderInfo);
                    /*插入标签*/
                    String[] ids = activity.getTagIds().split(",");
                    Set<String> tagSet = new HashSet<String>();
                    tagSet.addAll(Arrays.asList(ids));
                    cmsTagRelateService.updateEntityTagRelateList(activity.getActivityId(), Constant.TYPE_ACTIVITY, tagSet);
                    return rsStrs;
                }
//                //验证活动名称是否重复
//                if (StringUtils.isNotBlank(activity.getActivityName())) {
//                    boolean exists = activityService.queryActivityNameIsExists(activity.getActivityName().trim());
//                    if (exists) {
//                        return Constant.RESULT_STR_REPEAT;
//                    }
//                }

                String rsStrs = "";
                if (sysUser != null && StringUtils.isNotBlank(sysUser.getUserId())) {
                    rsStrs = activityService.addActivity(activity, sysUser);
                    String[] ids = activity.getTagIds().split(",");
                    cmsTagRelateService.insertTagRelateList(activity.getActivityId(), Constant.TYPE_ACTIVITY, ids);
                } else {
                    return Constant.RESULT_STR_NOACTIVE;
                }
                return rsStrs;
            }
        } catch (Exception e) {
            logger.info("saveActivity error {}", e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_SUCCESS;
    }

    /**
     * 座位模版查询
     *
     * @param request
     * @param record
     * @param seatInfo
     * @return
     */
    @RequestMapping(value = "/queryVenueSeatTemplateList")
//    @ResponseBody
    public String queryVenueSeatTemplateList(HttpServletRequest request, CmsVenueSeatTemplate record, String seatInfo) {
        List<CmsVenueSeatTemplate> list = null;
        try {
            Pagination page = new Pagination();
            page.setRows(6);
            list = cmsVenueSeatTemplateService.queryVenueSeatTemplateByCondition(record, page);
            request.setAttribute("list", list);
            //AAAAAADDDDUUUU 类型数据
            request.setAttribute("seatInfo", seatInfo);
            request.setAttribute("venueId", record.getVenueId());
        } catch (Exception ex) {
            logger.error("queryVenueSeatTemplateList error {}", ex);
        }
        return "admin/activity/editActivityVenueSeat";
    }

    /**
     * 根据查询出的座位列表绘制前台展示座位信息
     *
     * @param cmsActivitySeats
     * @return
     */
    public Map<String, String> getActivitySeatInfos(List<CmsActivitySeat> cmsActivitySeats) {
        Map map = new HashMap();
        StringBuilder seatInfoBuilder = new StringBuilder();
        StringBuffer seatIdsBuilder = new StringBuffer();
        String commonSeat = "A";
        String noneSeat = "D";
        String vipSeat = "U";
        int tmpVar = 1;
        for (int i = 0; i < cmsActivitySeats.size(); i++) {
            CmsActivitySeat cmsActivitySeat = cmsActivitySeats.get(i);
            //allInfo += cmsActivitySeat.getRows() + "_" + cmsActivitySeat.getSeatColumn() + "_" + cmsActivitySeat.getSeatStatus() + ",";
            if (tmpVar != cmsActivitySeat.getSeatRow()) {
                seatInfoBuilder.append(",");
                tmpVar++;
            }
            //正常
            if (cmsActivitySeat.getSeatStatus() == 1) {
                seatInfoBuilder.append(commonSeat);
                seatIdsBuilder.append(commonSeat + "-" + cmsActivitySeat.getSeatCode());
            }
            //删除
            if (cmsActivitySeat.getSeatStatus() == 3) {
                seatInfoBuilder.append(noneSeat);
                seatIdsBuilder.append(noneSeat + "-" + cmsActivitySeat.getSeatCode());
            }
            //占用
            if (cmsActivitySeat.getSeatStatus() == 2) {
                seatInfoBuilder.append(vipSeat);
                seatIdsBuilder.append(vipSeat + "-" + cmsActivitySeat.getSeatCode());
            }
/*            if(cmsActivitySeat.getSeatIsSold() != null && cmsActivitySeat.getSeatIsSold() == 2){
                seatInfoBuilder.append(vipSeat);
                seatIdsBuilder.append(vipSeat + "-" + cmsActivitySeat.getSeatCode());
            }*/
            seatIdsBuilder.append(",");
        }
        String seatInfo = seatInfoBuilder.toString();
        map.put("seatInfo", seatInfo);
        map.put("seatIds", seatIdsBuilder.toString());
        return map;
    }


    /**
     * 跳转至活动编辑页面
     *
     * @param request
     * @param id
     * @return
     */
    @RequestMapping(value = "/preEditActivity", method = RequestMethod.GET)
    public String preEditActivity(HttpServletRequest request, String id) {
        CmsActivity activity = null;
        if (StringUtils.isNotBlank(id)) {
            activity = activityService.queryCmsActivityByActivityId(id);
            request.setAttribute("activityId", id);
            if (StringUtils.isNotBlank(activity.getActivityAttachment())) {
                String[] ActivityAttachment = activity.getActivityAttachment().split(",");
                List<String> fileUrlList = new ArrayList<String>();
                Collections.addAll(fileUrlList, ActivityAttachment);
                request.setAttribute("fileUrlList", fileUrlList);
                System.out.println(fileUrlList);
            }
        }

        //判断活动是否已经有订票，如果有的话则只能修改活动部分内容， 不可编辑以下字段：标题、活动日期、活动时间、是否收费、在线售票。其余字段可编辑
        List<CmsActivityOrder> cmsActivityOrder = cmsActivityOrderService.queryCmsActivityOrderListByActivityId(id);
        //如果list中不为空，说明活动已经有票订出了 orderPayStatus 订单状态(1-未出票 2-已取消 3-已出票 4-已验票 5-已失效 )
        //isPayStatus表示当前活动是否已经订票 0代表没有订票 1代表已经订票 传到前台页面做判断
        if (cmsActivityOrder == null || cmsActivityOrder.size() == 0) {
            request.setAttribute("isPayStatus", 0);
        } else {
            request.setAttribute("isPayStatus", 1);
        }
        request.setAttribute("user", session.getAttribute("user"));
        return "admin/activity/addAct";
    }

    /**
     * 根据id读取活动
     *
     * @return
     */
    @RequestMapping(value = "/getActivity")
    @ResponseBody
    public CmsActivity getInformation(String id) {
        try {
            CmsActivity activity = activityService.queryCmsActivityByActivityId(id);
            //查找活动标签
            List<CmsTagSubRelate> tagRelateList = cmsTagRelateService.queryTagRelateByEntityId(id);
            String activityTags = new String();
            for (int i = 0; i < tagRelateList.size(); i++) {
                CmsTagSubRelate relate = tagRelateList.get(i);
                String tagId = relate.getTagSubId();
                activityTags += tagId + ',';
            }
            activity.setTagIds(activityTags);
            return activity;
        } catch (Exception e) {
            logger.info("addActivityEditorial error {}", e);
        }
        return null;
    }

    /**
     * @return
     */
    @RequestMapping("/subjectAddressIndex")
    public ModelAndView subjectAddressIndex(String addressId) {
        ModelAndView model = new ModelAndView();
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if (sysUser != null && StringUtils.isNotBlank(sysUser.getUserId())) {
                String userId = sysUser.getUserId();
                List<UserAddress> userAddresses = sysUserAddressService.userAddressList(userId);
                if (StringUtils.isNotBlank(addressId)) {
                    model.addObject("addressId", addressId);
                }
                model.addObject("userAddresses", userAddresses);
                model.setViewName("admin/activity/subjectAddressIndex");
            }
        } catch (Exception e) {
            logger.error("activityIndex error {}", e);
        }
        return model;
    }

    /**
     * 根据id读取活动场次
     *
     * @return
     */
    @RequestMapping(value = "/getActivityEvent")
    @ResponseBody
    public List<CmsActivityEvent> getActivityEvent(String activityId) {
        try {
        	List<CmsActivityEvent> activityEvents=cmsActivityEventService.queryCmsActivityEventByActivityId(activityId);
        	return activityEvents;
        } catch (Exception e) {
            logger.info("addActivityEditorial error {}", e);
        }
        return null;
    }

    /**
     * 根据查询出的座位列表绘制前台展示座位信息
     *
     * @param activitySeatList
     * @return
     */
    public String getSeatInfo2(List<CmsActivitySeat> activitySeatList) {
        StringBuilder seatInfoBuilder = new StringBuilder();

        String normalSeat = "A";        //正常
        String deleteSeat = "D";        //删除
        String occupySeat = "U";        //占用
        String giveSeat = "G";          //赠票

        int tmpVar = 1;
        for (int i = 0; i < activitySeatList.size(); i++) {
            CmsActivitySeat activitySeat = activitySeatList.get(i);
            if (tmpVar != activitySeat.getSeatRow()) {
                seatInfoBuilder.deleteCharAt(seatInfoBuilder.length() - 1);
                seatInfoBuilder.append("*");
                tmpVar++;
            }
            if (Integer.valueOf(activitySeat.getSeatStatus()) == Constant.VENUE_SEAT_STATUS_NORMAL) {
                seatInfoBuilder.append(normalSeat);
            }
            if (Integer.valueOf(activitySeat.getSeatStatus()) == Constant.VENUE_SEAT_STATUS_NONE) {
                seatInfoBuilder.append(deleteSeat);
            }
            if (Integer.valueOf(activitySeat.getSeatStatus()) == Constant.VENUE_SEAT_STATUS_VIP) {
                seatInfoBuilder.append(occupySeat);
            }
            if (Integer.valueOf(activitySeat.getSeatStatus()) == Constant.VENUE_SEAT_STATUS_MAINTANANCE) {
                seatInfoBuilder.append(occupySeat);
            }
            String showSeatVal = StringUtils.isBlank(activitySeat.getSeatVal()) ? activitySeat.getSeatColumn().toString() : activitySeat.getSeatVal().split("_")[1];
            seatInfoBuilder.append("-" + showSeatVal + "-" + ",");
        }
        if (seatInfoBuilder != null && seatInfoBuilder.length() > 0)
            seatInfoBuilder.deleteCharAt(seatInfoBuilder.length() - 1);
        String seatInfo = seatInfoBuilder.toString();
        return seatInfo;
    }

    /**
     * 保存编辑活动
     *
     * @param cur
     * @param seatIds
     * @return
     */
    @RequestMapping(value = "/editActivity", method = RequestMethod.POST)
    @ResponseBody
    public String editActivity(CmsActivity cur, String seatIds, String eventStartTimes, String eventEndTimes) {
        try {
            if (cur != null) {
                SysUser sysUser = (SysUser) session.getAttribute("user");
                //判断活动是否已经有订票，如果有的话则只能修改活动部分内容， 不可编辑以下字段：标题、活动日期、活动时间、是否收费、在线售票。其余字段可编辑
                List<CmsActivityOrder> cmsActivityOrders = cmsActivityOrderService.queryCmsActivityOrderListByActivityId(cur.getActivityId());
                //存在订单的时候 不对座位信息进行修改
                boolean hadOrderInfo = false;
                if (cmsActivityOrders != null && cmsActivityOrders.size() > 0) {
                    hadOrderInfo = true;
                }
                String rsStrs = activityService.editActivity(cur, sysUser, seatIds, hadOrderInfo);
                if (Constant.RESULT_STR_SUCCESS.equals(rsStrs)) {
                    //成功后将最新数据放至内存中  需要在数据库执行完后操作 不然由于spring 进行了数据库事物控制 不会马上查询到推荐的活动信息
                    activityService.setIndexListInfoToRedis();
                }
                return rsStrs;
            }
        } catch (Exception e) {
            logger.error("editActivity error {}", e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }

    /**
     * 审核不通过活动
     * @param id
     * @param request
     * @return
     */
    @RequestMapping(value = "/pullActivity", method = RequestMethod.POST)
    @ResponseBody
    public Object pullActivity(final String id, String delOrder, final String msgSMS, HttpServletRequest request) {
        JSONObject json = new JSONObject();
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            final String userId = sysUser.getUserId();
            if (StringUtils.isNotBlank(id)) {
                CmsActivity cmsActivity = activityService.queryCmsActivityByActivityId(id);
                if (cmsActivity.getActivityState() == 5) {
                    //activityService.deleteByActivityId(id);
                    //回收站中的撤销
                    cmsActivity.setActivityIsDel(2);
                    activityService.updateActivityDelStatus(id, 2);
                    json.put("status", "2");
                    json.put("msg", "该活动已删除");
                    return json;
                }
                if (cmsActivity.getActivityState() == 6) {
                    int orderCount = activityService.queryOrderCountByActivityId(id);
                    if (orderCount > 0 && delOrder == null) {
                        json.put("status", "3");
                        json.put("activityName", cmsActivity.getActivityName());
                       /* json.put("msg", "该活动已预定过，不可撤销");*/
                        return json;
                    }
                }
                boolean status = activityService.updateActivityPushStatus(id, 3);
                if (status) {
                	//删除广场信息
                	cmsCulturalSquareMapper.deleteByOutId(id);
                	
                    json.put("status", "2");
                    json.put("msg", "已将该活动审核不通过");
                    Runnable command = new Runnable() {
                        @Override
                        public void run() {
                            if (StringUtils.isNotBlank(msgSMS)) {
                                cmsActivityOrderService.revocationActivitySendSMS(id, msgSMS, userId);
                            }
                        }
                    };
                    new Thread(command).start();
                    return json;
                } else {
                    json.put("status", "1");
                    json.put("msg", "操作失败");
                    return json;
                }
            }
        } catch (Exception e) {
            logger.info("deleteActivity error" + e);
            json.put("status", "1");
            json.put("msg", "该活动审核不通过失败");
        }
        return json;
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
                CmsActivity cmsActivity = activityService.queryCmsActivityByActivityId(id);
                if (cmsActivity.getActivityState() == 5) {
                    //回收站中的撤销
                    cmsActivity.setActivityIsDel(2);
                    activityService.updateActivityDelStatus(id, 2);
                    json.put("status", "2");
                    json.put("msg", "该活动已删除");
                    return json;
                }
                if (cmsActivity.getActivityState() == 6) {
                    int orderCount = activityService.queryOrderCountByActivityId(id);
                    if (orderCount > 0 && delOrder == null) {
                        json.put("status", "3");
                        json.put("activityName", cmsActivity.getActivityName());
                        return json;
                    }
                }
                boolean status = activityService.updateActivityDelStatus(id, 1);
                if (status) {
                    json.put("status", "2");
                    json.put("msg", "该活动已删除至回收站");
                    Runnable command = new Runnable() {
                        @Override
                        public void run() {
                            if (StringUtils.isNotBlank(msgSMS)) {
                                cmsActivityOrderService.revocationActivitySendSMS(id, msgSMS, userId);
                            }
                        }
                    };
                    new Thread(command).start();
                    return json;
                } else {
                    json.put("status", "1");
                    json.put("msg", "操作失败");
                    return json;
                }
            }
        } catch (Exception e) {
            logger.info("deleteActivity error" + e);
            json.put("status", "1");
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
                CmsActivity cmsActivity = activityService.queryCmsActivityByActivityId(id);
                cmsActivity.setActivityIsDel(Constant.NORMAL);
                cmsActivity.setActivityState(1);
                boolean status = activityService.backActivityStatus(id);
                if (status) {
                    return Constant.RESULT_STR_SUCCESS;
                } else {
                    return Constant.RESULT_STR_FAILURE;
                }
            }
        } catch (Exception e) {
            logger.info("deleteActivity error" + e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_SUCCESS;
        // return new ModelAndView("redirect:/activity/activityIndex.do");
    }


    /**
     * 推荐活动
     *
     * @param activity
     * @return
     */
    @RequestMapping(value = "/recommendActivity", method = RequestMethod.POST)
    @ResponseBody
    public String recommendActivity(CmsActivity activity, String platform) {
        try {
            System.out.print(platform + "================================>");
            //String activityId,String activityRecommend
            SysUser sysUser = (SysUser) session.getAttribute("user");
            String rsStrs = activityService.recommendActivity(activity.getActivityId(), sysUser, platform);
            if (Constant.RESULT_STR_SUCCESS.equals(rsStrs)) {
                //成功后将最新数据放至内存中  需要在数据库执行完后操作 不然由于spring 进行了数据库事物控制 不会马上查询到推荐的活动信息
                activityService.setIndexListInfoToRedis();
            }
            return rsStrs;
        } catch (Exception ex) {
            ex.printStackTrace();
            this.logger.error("recommendActivity error {}", ex);
            return ex.toString();
        }
    }

    /**
     * 查询活动中存在的区县
     *
     * @param activityState
     * @return
     */
    @RequestMapping(value = "/queryExistArea", method = RequestMethod.GET)
    @ResponseBody
    public List<Map> queryExistArea(String activityState) {
        List<Map> list = activityService.queryExistArea(activityState);
        return list;
    }


    /**
     * 获取地址经纬度
     */
    @RequestMapping(value = "/queryMapAddressPoint", method = RequestMethod.GET)
    public String queryMapAddressPoint(HttpServletRequest request, String address) {
        try {
            request.setAttribute("address", URLDecoder.decode(address, "UTF-8"));
        } catch (Exception e) {
            e.printStackTrace();
        }

        return "admin/activity/mapAddressPoint";
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
            SysUser sysUser = (SysUser) session.getAttribute("user");


            List<CmsActivityEvent> eventList = activityService.queryCmsActivityEventByActivityId(activityId);

            if (eventList.size() == 0)
                return "event";

            String rsStrs = activityService.updateStateByActivityId(activityId, activityState, sysUser);
            return rsStrs;
        } catch (Exception ex) {
            ex.printStackTrace();
            this.logger.error("publishActivity error {}", ex);
            return ex.toString();
        }
    }

    /**
     * 老的数据将时间设置到场次表中
     *
     * @return
     */
    @RequestMapping(value = "/setOldEvent")
    @ResponseBody
    public String setOldEvent() {
        try {
            activityService.setOldEvent();
            return Constant.RESULT_STR_SUCCESS;
        } catch (Exception ex) {
            ex.printStackTrace();
            this.logger.error("setOldEvent error {}", ex);
            return ex.toString();
        }
    }

    /**
     * 下属活动列表页
     *
     * @param activity
     * @param page
     * @return
     */
    @RequestMapping("/activityUnderling")
    public ModelAndView activityUnderling(CmsActivity activity, Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
            List<CmsActivity> activityList = activityService.queryUnderlingActivityByCondition(activity, page);

            model.addObject("activityList", activityList);
            model.addObject("page", page);
            model.addObject("activity", activity);
            model.setViewName("admin/activity/activityUnderling");
        } catch (Exception e) {
            logger.error("activityIndex error {}", e);
        }
        return model;
    }

    /**
     * 下属活动列表页
     *
     * @param activity
     * @param page
     * @return
     */
    @RequestMapping("/activityBookUnderling")
    public ModelAndView activityBookUnderling(CmsActivity activity, Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
            List<CmsActivity> activityList = activityService.queryBookUnderlingActivityByCondition(activity, page);

            model.addObject("activityList", activityList);
            model.addObject("page", page);
            model.addObject("activity", activity);
            model.setViewName("admin/activity/activityBookUnderling");
        } catch (Exception e) {
            logger.error("activityBookUnderling error {}", e);
        }
        return model;
    }

    @RequestMapping(value = "/exportActivityExcel")
    public void exportActivityExcel(HttpServletRequest request, HttpServletResponse response, CmsActivity activity, Pagination pagination) {
        try {
            response.setContentType("application/vnd.ms-excel;charset=utf-8");
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Content-Disposition", "attachment;filename=" + "activity.xls");
            ServletOutputStream out = response.getOutputStream();
            SysUser sysUser = (SysUser) session.getAttribute("user");
            List<CmsActivity> activityList = activityService.queryCmsActivityByCondition(activity, null, sysUser);
            exportExcel.exportActivityExcel("测试title", "EXPORT_ACTIVITY_EXCEL", activityList, out, null);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


    /**
     * 跳转至拒绝审核的理由页面
     *
     * @param request
     * @param activityId
     */
    @RequestMapping(value = "/preRefuseUserActivity")
    public String preRefuseUserActivity(HttpServletRequest request, String activityId) {
        try {
            request.setAttribute("activityId", activityId);
            return "admin/activity/refuseUserActivity";
        } catch (Exception e) {
            e.printStackTrace();
            return "admin/activity/refuseUserActivity";
        }
    }

    /**
     * 拒绝通过审核的理由
     *
     * @param request
     * @param activityId
     */
    @ResponseBody
    @RequestMapping(value = "/refuseUserActivity")
    public String refuseUserActivity(HttpServletRequest request, String activityId, String[] reason) {
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            String rsStrs = activityService.refuseTuserActivityByActivityId(activityId, 7, sysUser, reason);
            if (Constant.RESULT_STR_SUCCESS.equals(rsStrs)) {
                //成功后将最新数据放至内存中  需要在数据库执行完后操作 不然由于spring 进行了数据库事物控制 不会马上查询到推荐的活动信息
                activityService.setIndexListInfoToRedis();
                return Constant.RESULT_STR_SUCCESS;
            }
            return rsStrs;
        } catch (Exception e) {
            e.printStackTrace();
            return e.toString();
        }
    }


    /**
     * 同步数据库和redis的余票数据
     *
     * @param request
     * @param activityId
     * @param
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/setActivityDataBaseAndRedisCount")
    public String setActivityDataBaseAndRedisCount(HttpServletRequest request, String activityId, String eventId) {
        try {
            activityService.setRightToRedisAndDataBase(activityId, eventId);

        } catch (Exception ex) {
            ex.printStackTrace();
            return ex.toString();
        }
        return Constant.RESULT_STR_SUCCESS;
    }


    /**
     * 查询活动中存在的区县
     *
     * @param
     * @return
     */
    @RequestMapping(value = "/queryActivityCompare", method = RequestMethod.GET)
    public String queryActivityCompare(HttpServletRequest request) {
        List<ActivityForCompare> list = activityService.queryOngoingActivityCanBook();
        request.setAttribute("activityList", list);
        return "admin/activity/activityCompare";
    }

    /**
     * 进入评级信息编辑页面
     */
    @RequestMapping(value = "/toEditRatingsInfo")
    public String toEditRatingsInfo(String activityId, String type, HttpServletRequest request) {
        if (StringUtils.isNotEmpty(activityId)) {
            request.setAttribute("activityId", activityId);
            request.setAttribute("type", type);
            String ratingsInfo = null;
            if (StringUtils.isNotBlank(type) && Constant.EDITORIAL.equals(type)) {
                ratingsInfo = editorialService.queryEditorialRatingsInfoById(activityId);
            } else if (StringUtils.isNotBlank(type) && Constant.ACTIVITY.equals(type)) {
                ratingsInfo = activityService.queryRatingsInfoByActivityId(activityId);
            }
            request.setAttribute("ratingsInfo", ratingsInfo);
            request.setAttribute("dictList", sysDictService.querySysDictByCode(Constant.RATINGS_INFO));
        }
        return "admin/activity/ratingsInfo";
    }

    /**
     * 进入评级信息编辑页面
     */
    @RequestMapping(value = "/editRatingsInfo")
    @ResponseBody
    public String editRatingsInfo(String activityId, String ratingsInfo, String type) {
        if (StringUtils.isNotEmpty(activityId) && StringUtils.isNotEmpty(ratingsInfo)) {
            try {
                boolean status = false;
                if (StringUtils.isNotBlank(type) && Constant.EDITORIAL.equals(type)) {
                    ActivityEditorial editorial = new ActivityEditorial();
                    editorial.setActivityId(activityId);
                    editorial.setRatingsInfo(ratingsInfo);
                    status = editorialService.editActivityEditorial(editorial);
                } else if (StringUtils.isNotBlank(type) && Constant.ACTIVITY.equals(type)) {
                    status = activityService.editRatingsInfo(ratingsInfo, activityId);
                }
                if (status) {
                    return Constant.RESULT_STR_SUCCESS;
                }
            } catch (Exception e) {
                return Constant.RESULT_STR_FAILURE;
            }
        }
        return Constant.RESULT_STR_FAILURE;

    }

    /**
     * 审核通过活动
     * @param activityId
     * @return
     */
    @RequestMapping(value = "/pushActivity", method = RequestMethod.POST)
    @ResponseBody
    public String pushActivity(String activityId, Integer activityState) {
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            String rsStrs = activityService.updateStateByActivityId(activityId, activityState, sysUser);
            return rsStrs;
        } catch (Exception ex) {
            ex.printStackTrace();
            this.logger.error("pushActivity error {}", ex);
            return ex.toString();
        }
    }


    /**
     * 活动详情页
     *
     * @param activity
     * @return
     */
    @RequestMapping("/previewActivityDetail")
    public String preActivityDetail(HttpServletRequest request, CmsActivity activity) {
        request.setAttribute("activity", activity);
        return "admin/activity/previewActivityDetail";
    }


    @RequestMapping(value = "/copyActivity", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, String> copyActivity(@RequestParam String activityId) {

        Map<String, String> result = new HashMap<String, String>();

        try {

            SysUser sysUser = (SysUser) session.getAttribute("user");

            CmsActivity cmsActivity = activityService.queryCmsActivityByActivityId(activityId);

            cmsActivity.setActivityId(UUIDUtils.createUUId());

            cmsActivity.setActivityUpdateUser(sysUser.getUserId());
            cmsActivity.setActivityCreateUser(sysUser.getUserId());
            cmsActivity.setActivityUpdateTime(new Date());
            cmsActivity.setActivityCreateTime(new Date());
            cmsActivity.setActivityIsDel(Constant.NORMAL);
            cmsActivity.setActivityState(Constant.DRAFT);
    		cmsActivity.setActivityStartTime(null);
			cmsActivity.setActivityEndTime(null);

            activityService.addActivity(cmsActivity);

            result.put("result", Constant.RESULT_STR_SUCCESS);
            result.put("activityId", cmsActivity.getActivityId());

        } catch (Exception e) {

            result.put("result", Constant.RESULT_STR_FAILURE);
            return result;
        }

        return result;
    }

    /**
     * 获取活动订单数
     * @param activityId
     * @return
     */
    @RequestMapping(value = "/queryOrderCountByActivityId", method = RequestMethod.POST)
    @ResponseBody
    public int queryOrderCountByActivityId(String activityId) {
        return activityService.queryOrderCountByActivityId(activityId);
    }
}
