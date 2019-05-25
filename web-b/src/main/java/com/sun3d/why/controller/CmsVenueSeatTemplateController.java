package com.sun3d.why.controller;

import com.sun3d.why.model.CmsVenue;
import com.sun3d.why.model.CmsVenueSeat;
import com.sun3d.why.model.CmsVenueSeatTemplate;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsVenueSeatService;
import com.sun3d.why.service.CmsVenueSeatTemplateService;
import com.sun3d.why.service.CmsVenueService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * <p>
 * 处理场馆座位请求
 * <p/>
 * Created by cj on 2015/6/16
 */
@RequestMapping("/venueSeatTemplate")
@Controller
public class CmsVenueSeatTemplateController {
    private Logger logger = Logger.getLogger(CmsVenueSeatTemplateController.class);
    //场馆逻辑控制层
    @Autowired
    private CmsVenueService cmsVenueService;
    //场馆座位逻辑控制层
    @Autowired
    private CmsVenueSeatService cmsVenueSeatService;
    //场馆座位模板逻辑控制层
    @Autowired
    private CmsVenueSeatTemplateService cmsVenueSeatTemplateService;
    /**
     * 自动注入请求对应的session实例
     */
    @Autowired
    private HttpSession session;

    /**
     * 添加场馆座位模板记录
     * @return
     */
    @RequestMapping(value = "/addVenueSeatTemplate")
    @ResponseBody
    public String addVenueSeatTemplate(String seatIds,CmsVenueSeatTemplate cmsVenueSeatTemplate) {
        String strResult = Constant.RESULT_STR_FAILURE;
        try {
            //session中获取用户信息
            SysUser sysUser = (SysUser)session.getAttribute("user");

            boolean result = cmsVenueSeatTemplateService.addVenueSeatTemplate(cmsVenueSeatTemplate,sysUser,seatIds);
            if(result){
                strResult = Constant.RESULT_STR_SUCCESS;
            }
        } catch (NumberFormatException e) {
            logger.error("生成座位信息时出错!",e);
            return  Constant.RESULT_STR_FAILURE;
        }
        return  strResult;
    }

    /**
     *
     * @param record
     * @param page
     * @param cmsVenue
     * @return
     */
    @RequestMapping(value = "/ venueSeatTemplateIndex")
    public ModelAndView  venueSeatTemplateIndex(CmsVenueSeatTemplate record, Pagination page,CmsVenue cmsVenue) {
        ModelAndView model = new ModelAndView();
        List<CmsVenueSeatTemplate> list = null;
        if(cmsVenue != null){
            cmsVenue = cmsVenueService.queryVenueById(cmsVenue.getVenueId());
        }
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if(sysUser != null){
                list = cmsVenueSeatTemplateService.queryVenueSeatTemplateByCondition(record,page);
            }else{
                logger.error("当前登录用户不存在或没有登录，场馆座位模板列表请求操作终止!");
            }
        } catch (Exception e) {
            logger.error("场馆座位模板列表页面时出错!",e);
        }
        model.setViewName("admin/venue/venueSeatTemplateIndex");
        model.addObject("list", list);
        model.addObject("page", page);
        model.addObject("record", record);
        model.addObject("cmsVenue",cmsVenue);
        return model;
    }



    /**
     * 删除场馆座位模板记录
     * @return
     */
    @RequestMapping(value = "/deleteVenueSeatTemplate")
    @ResponseBody
    public String deleteVenueSeatTemplate(String templateId) {
        String strResult = Constant.RESULT_STR_FAILURE;
        try {

            int count = cmsVenueSeatTemplateService.deleteVenueSeatTemplateById(templateId);

            CmsVenueSeat cmsVenueSeat = new CmsVenueSeat();
            cmsVenueSeat.setTemplateId(templateId);
            List<CmsVenueSeat> venueSeatList = cmsVenueSeatService.queryCmsVenueSeatByCondition(cmsVenueSeat);
            if(venueSeatList != null && venueSeatList.size()>0){
                for (int i=0; i<venueSeatList.size(); i++){
                    cmsVenueSeat = venueSeatList.get(i);
                    cmsVenueSeatService.deleteVenueSeat(cmsVenueSeat);
                }
            }

            if(count > 0){
                strResult = Constant.RESULT_STR_SUCCESS;
            }
        } catch (NumberFormatException e) {
            logger.error("生成座位信息时出错!",e);
            return  Constant.RESULT_STR_FAILURE;
        }
        return  strResult;
    }


    /**
     * 返回前台场馆首页数据
     * @return
     */
    @RequestMapping(value = "/preEditVenueSeatTemplate")
    public ModelAndView preEditVenueSeatTemplate(String templateId) {

        ModelAndView model = new ModelAndView();
        //根据场馆座位模板ID获取场馆座位模板记录
        CmsVenueSeatTemplate cmsVenueSeatTemplate = cmsVenueSeatTemplateService.queryVenueSeatTemplateById(templateId);

        CmsVenueSeat cmsVenueSeat = new CmsVenueSeat();
        cmsVenueSeat.setTemplateId(templateId);
        //获取所有座位列表
        List<CmsVenueSeat> venueSeatList = cmsVenueSeatService.queryCmsVenueSeatByCondition(cmsVenueSeat);
        //获取所有座位所需显示信息
        String seatInfo = getSeatInfo(venueSeatList);

        model.setViewName("admin/venue/venueSeatEdit");
        model.addObject("record",cmsVenueSeatTemplate);
        model.addObject("venueSeatList",venueSeatList);
        model.addObject("seatInfo",seatInfo);
        return model;
    }


    /**
     * 添加场馆座位模板记录
     * @return
     */
    @RequestMapping(value = "/editVenueSeatTemplate")
    @ResponseBody
    public String editVenueSeatTemplate(String seatIds,CmsVenueSeatTemplate cmsVenueSeatTemplate) {
        String strResult = Constant.RESULT_STR_FAILURE;
        try {
            //session中获取用户信息
            SysUser sysUser = (SysUser)session.getAttribute("user");

            boolean result = cmsVenueSeatTemplateService.editVenueSeatTemplate(cmsVenueSeatTemplate,sysUser,seatIds);
            if(result){
                strResult = Constant.RESULT_STR_SUCCESS;
            }
        } catch (NumberFormatException e) {
            logger.error("生成座位信息时出错!",e);
            return  Constant.RESULT_STR_FAILURE;
        }
        return  strResult;
    }


    /**
     * 根据查询出的座位列表绘制前台展示座位信息
     * @param venueSeatList
     * @return
     */
    public String getSeatInfo(List<CmsVenueSeat> venueSeatList){
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
            if(venueSeat.getSeatStatus() == Constant.VENUE_SEAT_STATUS_VIP){
                seatInfoBuilder.append(occupySeat);
            }
/*            if(venueSeat.getSeatStatus() == Constant.VENUE_SEAT_STATUS_MAINTANANCE){
                seatInfoBuilder.append(giveSeat);
            }*/
            seatInfoBuilder.append("-"+venueSeat.getSeatVal()+",");
        }
        seatInfoBuilder.deleteCharAt(seatInfoBuilder.length()-1);
        String seatInfo = seatInfoBuilder.toString();
        return seatInfo;
    }
    /*public String getSeatInfo(List<CmsVenueSeat> venueSeatList){
        StringBuilder seatInfoBuilder = new StringBuilder();

        String commonSeat = "A";
        String noneSeat = "D";
        String vipSeat = "U";

        int tmpVar = 1;

        for (int i=0; i<venueSeatList.size(); i++){
            CmsVenueSeat venueSeat = venueSeatList.get(i);
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
        return seatInfo;
    }*/

}
