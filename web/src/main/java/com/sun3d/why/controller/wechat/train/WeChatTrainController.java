package com.sun3d.why.controller.wechat.train;

import com.alibaba.fastjson.JSONArray;
import com.sun3d.why.dao.CmsTerminalUserMapper;
import com.sun3d.why.dao.train.CmsTrainEnrolmentMapper;
import com.sun3d.why.model.CmsTag;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.CmsVenue;
import com.sun3d.why.model.SysDept;
import com.sun3d.why.model.train.*;
import com.sun3d.why.service.*;
import com.sun3d.why.service.train.CmsTrainOrderService;
import com.sun3d.why.service.train.CmsTrainService;
import com.sun3d.why.util.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;


@Controller
@RequestMapping("/wechatTrain")
public class WeChatTrainController {

    private Logger logger = LoggerFactory.getLogger(WeChatTrainController.class);

    @Autowired
    private HttpSession session;

    @Autowired
    private CmsTrainService trainService;

    @Autowired
    private CmsVenueService venueService;

    @Autowired
    private CmsTrainEnrolmentMapper enrolmentMapper;

    @Autowired
    private CmsTagService cmsTagService;

    @Autowired
    private SysDictService sysDictService;

    @Autowired
    private CmsTrainOrderService orderService;

    @Autowired
    private CacheService cacheService;

    @Autowired
    private SysDeptService sysDeptService;

    @Autowired
    private CmsTerminalUserMapper userMapper;

    /**
     * 个人中心，我的订单列表
     * @param train
     * @param request
     * @param response
     * @param pageIndex
     * @param pageNum
     * @param pageApp
     * @param userId
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/trainList2")
    public String trainList2(Integer typeStatus, CmsTrainBean train, HttpServletRequest request, HttpServletResponse response, String pageIndex, String pageNum, PaginationApp pageApp, String userId) throws Exception {
        //CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
        CmsTerminalUser terminalUser = userMapper.queryTerminalUserById(userId);
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        String json = "";
        try {
            json = trainService.queryTrainList2(typeStatus,train, terminalUser, pageApp);
        } catch (Exception e) {
            e.printStackTrace();
            logger.info("query activityListByCondition error" + e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }


    /**
     * 培训列表页
     *
     * @param train
     * @return
     */
    @RequestMapping("/index")
    public ModelAndView trainList(CmsTrainBean train, HttpServletRequest request) {
        ModelAndView model = new ModelAndView();
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
        try {
            //培训所有场馆
            CmsVenue cmsVenue = new CmsVenue();
            cmsVenue.setVenueState(Constant.PUBLISH);
            cmsVenue.setVenueIsDel(Constant.NORMAL);
            //List<CmsVenue> venues = venueService.queryFrontCmsVenueByCondition(cmsVenue, null);
            CmsTrainEnrolment enrolment = enrolmentMapper.selectAll();
            List<CmsTag> tagList = cmsTagService.selectAllTrainTag("TRAIN_TYPE");
            List<SysDept> deptList = sysDeptService.queryAreaList("be4cb27979a845c1b42153adc442b117",null);
            String now = DateUtil.getCurrDate("yyyy-MM-dd HH:mm");
            model.addObject("now",now);
            model.addObject("tagList",tagList);
            model.addObject("enrolment",enrolment);
            //model.addObject("venues", venues);
            model.addObject("deptList",deptList);
            model.setViewName("wechat/train/trainList");
        } catch (Exception e) {
            logger.error("activityIndex error {}", e);
        }
        return model;
    }


    @RequestMapping(value = "/trainList")
    public String wcCmsActivityListByCondition(CmsTrainBean train, HttpServletRequest request, HttpServletResponse response, String pageIndex, String pageNum, PaginationApp pageApp,String userId) throws Exception {
        //CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
        CmsTerminalUser terminalUser = userMapper.queryTerminalUserById(userId);
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
        pageApp.setFirstResult(Integer.valueOf(pageIndex));
        pageApp.setRows(Integer.valueOf(pageNum));
        String json = "";
        try {
            json = trainService.queryTrainList(train,terminalUser, pageApp);
        } catch (Exception e) {
            e.printStackTrace();
            logger.info("query activityListByCondition error" + e.getMessage());
        }
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }

    @RequestMapping(value = "/trainDetail")
    public ModelAndView trainDetail(CmsTrainBean train, HttpServletRequest request,String userId) {
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
        ModelAndView model = new ModelAndView();
        try {
            //CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
            CmsTerminalUser terminalUser = userMapper.queryTerminalUserById(userId);
            train = trainService.selectByPrimaryKey(train.getId(),terminalUser!=null?terminalUser.getUserId():null);
            String now = DateUtil.getCurrDate("yyyy-MM-dd HH:mm");

            model.addObject("train", train);
            model.addObject("now", now);
            model.setViewName("wechat/train/trainDetail");
        } catch (Exception e) {
            logger.error("activityIndex error {}", e);
        }
        return model;
    }

    @RequestMapping(value = "/trainField")
    public ModelAndView trainField(CmsTrainBean train) {
        ModelAndView model = new ModelAndView();
        try {
            String jsonObject = trainService.queryTrainFieldListByTrainId(train.getId());
            model.addObject("fields", JSONArray.parseArray(jsonObject));
            model.setViewName("wechat/train/trainField");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return model;
    }

    @RequestMapping(value = "/checkEntry")
    @ResponseBody
    public String checkEntry(CmsTrainBean train) {
        return trainService.checkEntry(trainService.selectByPrimaryKey(train.getId(),null));
    }

    @RequestMapping(value = "/toEntry")
    public ModelAndView trainEntry(CmsTrainBean train, String userId) {
        ModelAndView model = new ModelAndView();
        try {
            CmsTrainOrder order = orderService.findOrderByUserId(userId);
            String trainId = train.getId();
            CmsTrain trainS = trainService.selectByPrimaryKey(trainId,userId);
            model.addObject("order",order);
            model.addObject("train", trainS);
            model.addObject("userId",userId);
            model.setViewName("wechat/train/trainEntry");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return model;
    }

    @RequestMapping("/saveOrder")
    @ResponseBody
    public Object saveOrder(CmsTrainOrderBean order,String userId) {
        //CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
        CmsTerminalUser terminalUser = userMapper.queryTerminalUserById(userId);
        if (terminalUser == null) {
            logger.error("当前登录用户不存在，返回登录页!");
            return JSONResponse.getResult(300, "当前登录用户不存在，返回登录页!");
        }
        return trainService.saveOrder(order, terminalUser);
    }

    /**
     * 报名结果页面
     *
     * @param order
     * @return
     */
    @RequestMapping(value = "/entryResult")
    public ModelAndView entryResult(CmsTrainOrder order) {
        ModelAndView model = new ModelAndView();
        try {
            order = trainService.queryTrainOrderById(order.getId());
            model.addObject("order", order);
            model.setViewName("wechat/train/entryResult");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return model;
    }

    /**
     * 订单列表页
     *
     * @param order
     * @return
     */
    @RequestMapping(value = "/trainOrder")
    public ModelAndView trainOrder(CmsTrainOrderBean order) {
        ModelAndView model = new ModelAndView();
        model.setViewName("wechat/train/trainOrder");
        return model;
    }

    /**
     * 订单列表页
     *
     * @param order
     * @return
     */
    @RequestMapping(value = "/trainOrderList")
    @ResponseBody
    public List<CmsTrainOrderBean> trainOrderList(CmsTrainOrderBean order,String userId) {
        //CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
        //CmsTerminalUser terminalUser = userMapper.queryTerminalUserById(userId);
        order.setCreateUser(userId);
        List<CmsTrainOrderBean> orders = trainService.queryTrainOrderList(order);
        return orders;
    }


    @RequestMapping(value = "/trainComment")
    public ModelAndView trainComment(CmsTrainBean train) {
        ModelAndView model = new ModelAndView();
        try {
            train = trainService.selectByPrimaryKey(train.getId(),null);
            model.addObject("train", train);
            model.setViewName("wechat/train/trainComment");
        } catch (Exception e) {
            logger.error("activityIndex error {}", e);
        }
        return model;
    }

}
