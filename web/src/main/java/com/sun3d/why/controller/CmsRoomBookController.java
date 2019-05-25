package com.sun3d.why.controller;

import com.sun3d.why.enumeration.UserOperationEnum;
import com.sun3d.why.model.CmsActivityRoom;
import com.sun3d.why.model.CmsRoomBook;
import com.sun3d.why.model.CmsRoomOrder;
import com.sun3d.why.model.CmsUserOperatorLog;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.CmsActivityRoomService;
import com.sun3d.why.service.CmsRoomBookService;
import com.sun3d.why.service.CmsRoomOrderService;
import com.sun3d.why.service.CmsUserOperatorLogService;
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
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * Created by lt on 2015/7/8.
 */

@RequestMapping("/cmsRoomBook")
@Controller
public class CmsRoomBookController {

    @Autowired
    private HttpSession session;

    @Autowired
    private CmsActivityRoomService cmsActivityRoomService;

    @Autowired
    private CmsRoomBookService cmsRoomBookService;

    @Autowired
    private CmsRoomOrderService cmsRoomOrderService;

    @Autowired
    private CacheService cacheService;
    
    @Autowired
    private CmsUserOperatorLogService cmsUserOperatorLogService;


    private Logger logger = Logger.getLogger(CmsRoomBookController.class);


    @RequestMapping("/queryRoomBookList")
    public ModelAndView queryRoomBookList(CmsRoomBook cmsRoomBook,Pagination page,String startDate){
        ModelAndView model = new ModelAndView();
        List<CmsRoomBook> roomBookList = null;
        CmsActivityRoom cmsActivityRoom = null;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        try {
            if(StringUtils.isNotBlank(startDate)){
                cmsRoomBook.setCurDate(sdf.parse(startDate));
            }

            if(cmsRoomBook != null && StringUtils.isNotBlank(cmsRoomBook.getRoomId())){
                cmsActivityRoom = cmsActivityRoomService.queryCmsActivityRoomById(cmsRoomBook.getRoomId());
                roomBookList = cmsRoomBookService.queryCmsRoomBookListByDays(cmsRoomBook,7,page);
            }
        } catch (Exception e) {
            logger.error("加载活动室预订信息列表出错！",e);
        }
        model.addObject("roomBookList",roomBookList);
        model.addObject("page",page);
        model.addObject("startDate",startDate);
        model.addObject("activityRoom",cmsActivityRoom);
        model.setViewName("admin/activityRoom/activityRoomBookList");
        return model;
    }


    @RequestMapping("/preEditRoomBook")
    public ModelAndView preEditRoomBook(String bookId){
        ModelAndView model = new ModelAndView();
        CmsRoomBook cmsRoomBook = null;
        CmsRoomOrder cmsRoomOrder = null;

        if(StringUtils.isNotBlank(bookId)){
            cmsRoomBook = cmsRoomBookService.queryCmsRoomBookById(bookId);
        }

        List<CmsRoomOrder> roomOrderList = cmsRoomOrderService.queryRoomOrderListByBookId(bookId);
        if(roomOrderList != null && roomOrderList.size()>0){
            cmsRoomOrder = roomOrderList.get(0);
        }

        model.addObject("cmsRoomOrder",cmsRoomOrder);
        model.addObject("cmsRoomBook",cmsRoomBook);
        model.setViewName("admin/activityRoom/editRoomBook");
        return model;
    }


    @RequestMapping("/editRoomBook")
    @ResponseBody
    public String editRoomBook(CmsRoomBook cmsRoomBook,Integer changedStatus){
        String result = Constant.RESULT_STR_FAILURE;
        SysUser sysUser = (SysUser)session.getAttribute("user");
        ModelAndView model = new ModelAndView();
        if(StringUtils.isBlank(cmsRoomBook.getOpenPeriod())){
            cmsRoomBook.setOpenPeriod("OFF");
        }
        try{
            if(StringUtils.isNotBlank(cmsRoomBook.getBookId()) && sysUser != null){
                CmsRoomBook tempCmsRoomBook = cmsRoomBookService.queryCmsRoomBookById(cmsRoomBook.getBookId());
                tempCmsRoomBook.setOpenPeriod(cmsRoomBook.getOpenPeriod());
                if(changedStatus == tempCmsRoomBook.getBookStatus()){
                    int updateCount = cmsRoomBookService.editCmsRoomBook(tempCmsRoomBook);
                    if(updateCount>0){
                        result = Constant.RESULT_STR_SUCCESS;
                    }
                }else{
                    Integer openStatus = 1;
                    Integer bookedStatus = 2;
                    Integer closedStatus = 3;

                    if(changedStatus == openStatus){
                        if(tempCmsRoomBook.getBookStatus() == closedStatus){
                            //改为开放状态
                            tempCmsRoomBook.setBookStatus(openStatus);
                            int updateCount = cmsRoomBookService.editCmsRoomBook(tempCmsRoomBook);
                            if(updateCount>0){
                                result = Constant.RESULT_STR_SUCCESS;
                            }
                        }else if(tempCmsRoomBook.getBookStatus() == bookedStatus){
                            //改为开放状态
                            tempCmsRoomBook.setBookStatus(openStatus);
                            //已预订状态变更为开放状态，修改订单信息
                            int updateCount = cmsRoomBookService.editCmsRoomBook(tempCmsRoomBook);
                            if(updateCount>0){
                                result = Constant.RESULT_STR_SUCCESS;
                            }

                            //取消订单代码
                            List<CmsRoomOrder> roomOrderList = cmsRoomOrderService.queryRoomOrderListByBookId(cmsRoomBook.getBookId());
                            if(roomOrderList != null && roomOrderList.size()>0){
                                String roomOrderId = roomOrderList.get(0).getRoomOrderId();
                                
                               boolean b= cmsRoomOrderService.cancelRoomOrder(roomOrderId,sysUser.getUserNickName());
                           
                                if(b)
                                {
                                	 CmsUserOperatorLog record =CmsUserOperatorLog.createInstance(null, roomOrderId, null, sysUser.getUserId(), CmsUserOperatorLog.USER_TYPE_ADMIN, UserOperationEnum.CANCEL); 
                                     
                                 	cmsUserOperatorLogService.insert(record);
                                }
                                
                            }
                        }
                        //更新缓存数据
                        cacheService.changeBookIdInRedis(tempCmsRoomBook.getRoomId(),tempCmsRoomBook.getBookId(),true);
                    }else if(changedStatus == bookedStatus){
                        //*****************不支持从其它状态改为已预订状态
                        //改为已预订状态
                        if(tempCmsRoomBook.getBookStatus() == openStatus){

                            result = Constant.RESULT_STR_SUCCESS;
                        }else if(tempCmsRoomBook.getBookStatus() == closedStatus){

                            result = Constant.RESULT_STR_SUCCESS;
                        }
                    }else if(changedStatus == closedStatus){
                        if(tempCmsRoomBook.getBookStatus() == openStatus){
                            //改为不开放状态
                            tempCmsRoomBook.setBookStatus(closedStatus);
                            int updateCount = cmsRoomBookService.editCmsRoomBook(tempCmsRoomBook);
                            if(updateCount>0){
                                result = Constant.RESULT_STR_SUCCESS;
                            }
                        }else if(tempCmsRoomBook.getBookStatus() == bookedStatus){
                            //已预订状态变更为开放状态，修改订单信息
                            tempCmsRoomBook.setBookStatus(closedStatus);
                            int updateCount = cmsRoomBookService.editCmsRoomBook(tempCmsRoomBook);
                            if (updateCount > 0) {
                                result = Constant.RESULT_STR_SUCCESS;
                            }

                            //取消订单代码
                            List<CmsRoomOrder> roomOrderList = cmsRoomOrderService.queryRoomOrderListByBookId(cmsRoomBook.getBookId());
                            if(roomOrderList != null && roomOrderList.size()>0){
                                String roomOrderId = roomOrderList.get(0).getRoomOrderId();
                                
                                boolean b=cmsRoomOrderService.cancelRoomOrder(roomOrderId,sysUser.getUserNickName());
                                if(b)
                                {
                                	 CmsUserOperatorLog record =CmsUserOperatorLog.createInstance(null, roomOrderId, null, sysUser.getUserId(), CmsUserOperatorLog.USER_TYPE_ADMIN, UserOperationEnum.CANCEL); 
                                     
                                 	cmsUserOperatorLogService.insert(record);
                                }
                            }
                        }
                        //更新缓存数据
                        cacheService.changeBookIdInRedis(tempCmsRoomBook.getRoomId(),tempCmsRoomBook.getBookId(),false);
                    }else{
                        logger.info("状态无效，不做更改！");
                        result = Constant.RESULT_STR_SUCCESS;
                    }
                }
            }
        } catch (Exception ex){
            logger.error("更改场次信息时出错,",ex);
        }

        model.setViewName("admin/activityRoom/editRoomBook");
        return result;
    }
}
