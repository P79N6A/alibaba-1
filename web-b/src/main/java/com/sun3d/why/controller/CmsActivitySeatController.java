package com.sun3d.why.controller;

import com.sun3d.why.model.CmsActivitySeat;
import com.sun3d.why.model.CmsVenueSeat;
import com.sun3d.why.model.CmsVenueSeatTemplate;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsActivitySeatService;
import com.sun3d.why.service.CmsVenueSeatService;
import com.sun3d.why.service.CmsVenueSeatTemplateService;
import com.sun3d.why.util.Constant;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.text.ParseException;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * <p>
 * 处理场馆座位请求
 * <p/>
 * Created by yujinbing on 2015/6/16
 */
@RequestMapping("/activitySeat")
@Controller
public class CmsActivitySeatController {
    private Logger logger = Logger.getLogger(CmsActivitySeatController.class);
    //场馆逻辑控制层
    @Autowired
    private CmsVenueSeatService cmsVenueSeatService;
    /**
     * 自动注入请求对应的session实例
     */
    @Autowired
    private HttpSession session;

    @Autowired
    private CmsActivitySeatService cmsActivitySeatService;

    @Autowired
    private CmsVenueSeatTemplateService cmsVenueSeatTemplateService;




    /**
     * 添加活动时加载选中的 场馆座位信息
     * @return
     */
    @RequestMapping(value = "/activityVenueSeat")
    @ResponseBody
    public Map<String,String> activityVenueSeat(String templateId) {
        Map map = new LinkedHashMap();
        //根据场馆座位模板ID获取场馆座位模板记录
        CmsVenueSeatTemplate cmsVenueSeatTemplate = cmsVenueSeatTemplateService.queryVenueSeatTemplateById(templateId);
        CmsVenueSeat cmsVenueSeat = new CmsVenueSeat();
        cmsVenueSeat.setTemplateId(templateId);
        //获取所有座位列表
        List<CmsVenueSeat> venueSeatList = cmsVenueSeatService.queryCmsVenueSeatByCondition(cmsVenueSeat);
        //获取所有座位所需显示信息
        String  seatInfo = getSeatInfo2(venueSeatList);
        map.put("seatInfo",seatInfo);
//        String seatInfo = map.get("seatInfo");
//        model.addObject("record", cmsVenueSeatTemplate);
//        model.addObject("venueSeatList",venueSeatList);
//        model.addObject("seatInfo",seatInfo);
//        model.addObject("allInfo",map.get("allInfo"));
//        model.setViewName("admin/activity/editActivityVenueSeat");
        return map;
    }

    /**
     * 根据查询出的座位列表绘制前台展示座位信息
     * @param venueSeatList
     * @return
     */
    public String getSeatInfo2(List<CmsVenueSeat> venueSeatList){
        StringBuilder seatInfoBuilder = new StringBuilder();

        String normalSeat = "A";        //正常
        String deleteSeat = "D";        //删除
        String occupySeat = "U";        //占用
        String giveSeat = "G";          //赠票

        int tmpVar = 1;
        for (int i=0; i<venueSeatList.size(); i++){
            CmsVenueSeat venueSeat = venueSeatList.get(i);
            if(tmpVar != venueSeat.getSeatRow()){
                seatInfoBuilder.deleteCharAt(seatInfoBuilder.length()-1);
                seatInfoBuilder.append("*");
                tmpVar++;
            }
            if(venueSeat.getSeatStatus() == Constant.VENUE_SEAT_STATUS_NORMAL){
                seatInfoBuilder.append(normalSeat);
            }
            if(venueSeat.getSeatStatus() == Constant.VENUE_SEAT_STATUS_NONE){
                seatInfoBuilder.append(deleteSeat);
            }
            if(venueSeat.getSeatStatus() == Constant.VENUE_SEAT_STATUS_MAINTANANCE){
                seatInfoBuilder.append(occupySeat);
            }
            if(venueSeat.getSeatStatus() == Constant.VENUE_SEAT_STATUS_VIP){
                seatInfoBuilder.append(occupySeat);
            }
            seatInfoBuilder.append("-"+venueSeat.getSeatVal()+ "-" + ",");
        }
        if (seatInfoBuilder != null && seatInfoBuilder.length() > 0)
            seatInfoBuilder.deleteCharAt(seatInfoBuilder.length()-1);
        String seatInfo = seatInfoBuilder.toString();
        return seatInfo;
    }

/*    *//**
     * 根据查询出的座位列表绘制前台展示座位信息
     * @param venueSeatList
     * @return
     *//*
    public Map<String, String> getSeatInfo(List<CmsVenueSeat> venueSeatList){
        Map map = new HashMap();
        StringBuilder seatInfoBuilder = new StringBuilder();

        String commonSeat = "A";
        String noneSeat = "D";
        String vipSeat = "U";
        String allInfo = "";
        int tmpVar = 1;

        for (int i=0; i<venueSeatList.size(); i++){
            CmsVenueSeat venueSeat = venueSeatList.get(i);
            allInfo += venueSeat.getRows() + "_" + venueSeat.getSeatColumn() + "_" + venueSeat.getSeatStatus() + ",";
            if(tmpVar != venueSeat.getSeatRow()){
                seatInfoBuilder.append(",");
                tmpVar++;
            }
            if(venueSeat.getSeatStatus() == Constant.VENUE_SEAT_STATUS_NORMAL){
                seatInfoBuilder.append(commonSeat);
            }
            if(venueSeat.getSeatStatus() == Constant.VENUE_SEAT_STATUS_NONE){
                seatInfoBuilder.append(noneSeat);
            }
            if(venueSeat.getSeatStatus() == Constant.VENUE_SEAT_STATUS_VIP){
                seatInfoBuilder.append(vipSeat);
            }
        }

        String seatInfo = seatInfoBuilder.toString();
        map.put("seatInfo",seatInfo);
        map.put("allInfo",allInfo.substring(0,allInfo.length() -1));
        return map;
    }*/



    /**
     * 根据查询出的座位列表绘制前台展示座位信息
     * @param cmsActivitySeats
     * @return
     */
    public Map<String, String> getActivitySeatInfos(List<CmsActivitySeat> cmsActivitySeats){
        Map map = new HashMap();
        StringBuilder seatInfoBuilder = new StringBuilder();
        String commonSeat = "A";
        String noneSeat = "D";
        String vipSeat = "U";
        int tmpVar = 1;
        for (int i=0; i<cmsActivitySeats.size(); i++){
            CmsActivitySeat cmsActivitySeat = cmsActivitySeats.get(i);
            //allInfo += cmsActivitySeat.getRows() + "_" + cmsActivitySeat.getSeatColumn() + "_" + cmsActivitySeat.getSeatStatus() + ",";
            if(tmpVar != cmsActivitySeat.getSeatRow()){
                seatInfoBuilder.append(",");
                tmpVar++;
            }
            if(cmsActivitySeat.getSeatStatus() == Constant.VENUE_SEAT_STATUS_NORMAL){
                seatInfoBuilder.append(commonSeat);
            }
            if(cmsActivitySeat.getSeatStatus() == Constant.VENUE_SEAT_STATUS_NONE){
                seatInfoBuilder.append(noneSeat);
            }
            if(cmsActivitySeat.getSeatStatus() == Constant.VENUE_SEAT_STATUS_MAINTANANCE){
                seatInfoBuilder.append(vipSeat);
            }
        }
        String seatInfo = seatInfoBuilder.toString();
        map.put("seatInfo",seatInfo);
        return map;
    }
    /**
     * 修改活动时加载选中的 活动已经存在的座位信息
     * @return
     */
    @RequestMapping(value = "/editActivitySeat")
    public ModelAndView editActivitySeat(String activityId) {
        ModelAndView model = new ModelAndView();
        Map map = new HashMap();
        map.put("activityId", activityId);
        //获取所有座位列表
        List<CmsActivitySeat> activitySeats = cmsActivitySeatService.queryCmsActivitySeatCondition(map);
        //获取所有座位所需显示信息
        Map<String,String> seatMap = getActivitySeatInfos(activitySeats);
        String seatInfo = seatMap.get("seatInfo");
        //显示界面绘制所需座位信息
//        model.addObject("record", cmsVenueSeatTemplate);
//        model.addObject("venueSeatList",venueSeatList);
        model.addObject("seatInfo",seatInfo);
//        model.addObject("allInfo",map.get("allInfo"));

        model.setViewName("admin/activity/editActivitySeat");

        return model;
    }




    /**
     * 根据查询出的座位列表绘制前台展示座位信息
     * @param activitySeats
     * @return
     */
    public Map<String,String> getActivitySeatInfo(List<CmsActivitySeat> activitySeats){
        Map<String,String> allSeatInfo = new HashMap<String, String>();

        StringBuilder seatInfoBuilder = new StringBuilder();
        StringBuilder maintananceBuilder = new StringBuilder();
        StringBuilder vipBuilder = new StringBuilder();
        StringBuilder seatStatusInfo =  new StringBuilder();
        String commonSeat = "a";
        String noneSeat = "_";
        String maintenanceSeat = "m";
        String vipSeat = "v";

        int tmpVar = 1;

        for (int i=0; i<activitySeats.size(); i++){
            CmsActivitySeat activitySeat = activitySeats.get(i);
            seatStatusInfo.append(activitySeat.getSeatRow() + "_"+ activitySeat.getSeatColumn() + "_" + activitySeat.getSeatStatus() + ",");
            if(tmpVar != activitySeat.getSeatRow()){
                seatInfoBuilder.append(",");
                tmpVar++;
            }
            if(activitySeat.getSeatStatus() == Constant.VENUE_SEAT_STATUS_NORMAL){
                seatInfoBuilder.append(commonSeat);
            }
            if(activitySeat.getSeatStatus() == Constant.VENUE_SEAT_STATUS_MAINTANANCE){
                seatInfoBuilder.append(maintenanceSeat);
                maintananceBuilder.append(activitySeat.getSeatCode()+",");
            }
            if(activitySeat.getSeatStatus() == Constant.VENUE_SEAT_STATUS_NONE){
                seatInfoBuilder.append(noneSeat);
            }
            if(activitySeat.getSeatStatus() == Constant.VENUE_SEAT_STATUS_VIP){
                seatInfoBuilder.append(vipSeat);
                vipBuilder.append(activitySeat.getSeatCode()+",");
            }
        }

        String seatInfo = seatInfoBuilder.toString();
        String maintananceSeatInfo = maintananceBuilder.toString();
        String vipSeatInfo = vipBuilder.toString();
        if(!maintananceSeatInfo.equals("")){
            maintananceSeatInfo = maintananceSeatInfo.substring(0,(maintananceSeatInfo.length()-1));
        }
        if(!vipSeatInfo.equals("")){
            vipSeatInfo = vipSeatInfo.substring(0,(vipSeatInfo.length()-1));
        }
        allSeatInfo.put("seatInfo",seatInfo);
        allSeatInfo.put("maintananceInfo",maintananceSeatInfo);
        allSeatInfo.put("vipInfo",vipSeatInfo);
        allSeatInfo.put("seatStatusInfo", seatStatusInfo.toString().substring(0,seatStatusInfo.length()-1));
        return allSeatInfo;
    }


    /**
     * 跳转至生成场馆座位页面
     * @return
     */
    @RequestMapping(value = "/preGenerateVenueSeat")
    public ModelAndView preGenerateVenueSeat(String venueId,Integer rows,Integer columns) {
        ModelAndView model = new ModelAndView();

        venueId = "6ca187cabe594973b1a82b8108d9a488";

        model.setViewName("index/venue/generateVenueSeat");
        model.addObject("venueId",venueId);
        model.addObject("rows",rows);
        model.addObject("columns",columns);
        return model;
    }

    /**
     * 返回前台场馆首页数据
     * @return
     */
    @RequestMapping(value = "/addActivitySeat")
    @ResponseBody
    public String addActivitySeat(String seatIds, String venueId,String activityId) {
        //session中获取用户信息
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if(sysUser == null){
                sysUser = new SysUser();
                sysUser.setUserId("1");
            }
            try {
                cmsActivitySeatService.addActivitySeatInfo(activityId, seatIds,null,sysUser, null,null,null);
            } catch (ParseException e) {
                e.printStackTrace();
                return  e.toString();
            } catch (Exception e) {
                e.printStackTrace();
            }
        } catch (NumberFormatException e) {
            logger.error("生成座位信息时出错!",e);
            return  Constant.RESULT_STR_FAILURE;
        }
        return  Constant.RESULT_STR_SUCCESS;
    }
}

