package com.sun3d.why.controller.front;

import com.sun3d.why.enumeration.UserOperationEnum;
import com.sun3d.why.model.CmsComment;
import com.sun3d.why.model.CmsRoomOrder;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.CmsUserOperatorLog;
import com.sun3d.why.service.CmsCommentService;
import com.sun3d.why.service.CmsRoomOrderService;
import com.sun3d.why.service.CmsUserOperatorLogService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;

/**
 * Created by Administrator on 2015/7/3.
 */
@RequestMapping("/roomOrder")
@Controller
public class FrontCmsRoomOrderController {

    private Logger logger = Logger.getLogger(FrontCmsRoomOrderController.class);
    @Autowired
    private CmsRoomOrderService cmsRoomOrderService;

    @Autowired
    private CmsCommentService cmsCommentService;

    @Autowired
    private HttpSession session;

    @Autowired
    private CmsUserOperatorLogService cmsUserOperatorLogService;
    
    /**
     * 加载前端我的场馆表头
     * @return
     */
    @RequestMapping("/queryRoomOrder")
    public ModelAndView queryRoomOrder(String fromTicket){
        ModelAndView modelAndView = new ModelAndView();
        //获取用户信息
        CmsTerminalUser user = (CmsTerminalUser)session.getAttribute("terminalUser");
        if ("Y".equals(fromTicket) && user == null) {
            return new ModelAndView("redirect:/frontActivity/venueBookIndex.do");
        } else {
            modelAndView.setViewName("/index/userCenter/userVenues");
        }
        return modelAndView;
    }
    /**
     * 前端我的场馆列表
     * @param pagination
     * @return
     */
    @RequestMapping("/queryRoomOrderList")
    public ModelAndView queryRoomOrderList(Pagination pagination){
        ModelAndView modelAndView = new ModelAndView();
        pagination.setRows(5);
        //获取用户信息
        CmsTerminalUser user = (CmsTerminalUser)session.getAttribute("terminalUser");
        if(user != null){
            String userId = user.getUserId();
            List<CmsRoomOrder> cmsRoomOrders =  cmsRoomOrderService.queryRoomOrderListService(userId, pagination, null);

            modelAndView.addObject("cmsRoomOrders",cmsRoomOrders);
            modelAndView.addObject("page", pagination);
            modelAndView.setViewName("/index/userCenter/userVenuesLoad");
        }
        return modelAndView;
    }

    /**
     * 前端我的场馆  历史预定头加载
     * @return
     */
    @RequestMapping("/queryRoomOrderHistory")
    public ModelAndView queryRoomOrderHistory(String fromTicket){
        ModelAndView modelAndView = new ModelAndView();
        //获取用户信息
        CmsTerminalUser user = (CmsTerminalUser)session.getAttribute("terminalUser");
        if ("Y".equals(fromTicket) && user == null) {
            return new ModelAndView("redirect:/frontActivity/frontActivityList.do");
        } else {
            modelAndView.setViewName("/index/userCenter/userVenuesHistory");
        }
        return modelAndView;
    }

    /**
     * 抢断我的场馆  历史预定列表
     * @param pagination
     * @return
     */
    @RequestMapping("/queryRoomOrderHistoryList")
    public ModelAndView queryRoomOrderHistoryList(Pagination pagination){
        ModelAndView modelAndView = new ModelAndView();

        pagination.setRows(5);
        //获取用户信息
        CmsTerminalUser user = (CmsTerminalUser)session.getAttribute("terminalUser");

        if(user != null){
            String userId = user.getUserId();
            List<CmsRoomOrder> cmsRoomOrders =  cmsRoomOrderService.queryRoomOrderListHistoryService(userId, pagination, null);

            modelAndView.addObject("cmsRoomOrders",cmsRoomOrders);
            modelAndView.addObject("page", pagination);
            modelAndView.setViewName("/index/userCenter/userVenuesHistoryLoad");
        }
        return modelAndView;
    }

    /**
     * 取消预定订单
     * @param roomOrderId
     * @return
     */
    @RequestMapping(value = "/cancelRoomOrderFront")
    @ResponseBody
    public String cancelRoomOrderFront(String roomOrderId){
        String result = Constant.RESULT_STR_FAILURE;

        CmsTerminalUser cmsTerminalUser = (CmsTerminalUser)session.getAttribute("terminalUser");
        if(cmsTerminalUser != null){
            boolean cancelResult = cmsRoomOrderService.cancelRoomOrder(roomOrderId,cmsTerminalUser.getUserName());
            if(cancelResult){
            	
            	CmsUserOperatorLog record =CmsUserOperatorLog.createInstance(null, roomOrderId, null, cmsTerminalUser.getUserId(), CmsUserOperatorLog.USER_TYPE_NORMAL, UserOperationEnum.CANCEL); 
                
              	cmsUserOperatorLogService.insert(record);
            	
                result = Constant.RESULT_STR_SUCCESS;
            }
        }else {
            logger.info("当前没有用户登录，取消订单操作取消!");
        }
        return result;
    }


    /**
     * 删除预定订单
     * @param roomOrderId
     * @return
     */
    @RequestMapping(value = "/deleteRoomOrder")
    @ResponseBody
    public String deleteRoomOrder(String roomOrderId){
        String result = Constant.RESULT_STR_FAILURE;

        CmsTerminalUser cmsTerminalUser = (CmsTerminalUser)session.getAttribute("terminalUser");
        if(cmsTerminalUser != null){
            //物理删除暂时关闭
//            int deleteCount = cmsRoomOrderService.deleteRoomOrder(roomOrderId);
//            if(deleteCount > 0){
//                result = Constant.RESULT_STR_SUCCESS;
//            }
        }else {
            logger.info("当前没有用户登录，删除订单操作取消!");
        }
        return result;
    }


    /**
     * 删除预定订单
     * @param roomOrderId
     * @return
     */
    @RequestMapping(value = "/logicalDeleteRoomOrder")
    @ResponseBody
    public String logicalDeleteRoomOrder(String roomOrderId){
        String result = Constant.RESULT_STR_FAILURE;

        CmsTerminalUser cmsTerminalUser = (CmsTerminalUser)session.getAttribute("terminalUser");
        if(cmsTerminalUser != null){

            CmsRoomOrder cmsRoomOrder = cmsRoomOrderService.queryCmsRoomOrderById(roomOrderId);
            //订单状态为4代表已逻辑删除
            cmsRoomOrder.setBookStatus(4);
            cmsRoomOrder.setOrderUpdateTime(new Date());
            cmsRoomOrder.setOrderUpdateUser(cmsTerminalUser.getUserNickName());
            int editCount = cmsRoomOrderService.editCmsRoomOrder(cmsRoomOrder);
            if(editCount > 0){
                result = Constant.RESULT_STR_SUCCESS;
            }
        }else {
            logger.info("当前没有用户登录，删除订单操作取消!");
        }
        return result;
    }

    /**
     *根据活动室ID获取评论数量
     * @return
     */
    @RequestMapping(value = "/getCommentCountById")
    @ResponseBody
    public int getCommentCountById(String roomId){
        CmsComment cmsComment = new CmsComment();
        cmsComment.setCommentRkId(roomId);
        cmsComment.setCommentType(Constant.TYPE_ACTIVITY_ROOM);
        int commentCount = cmsCommentService.queryCommentCountByCondition(cmsComment);
        return commentCount;
    }

}
