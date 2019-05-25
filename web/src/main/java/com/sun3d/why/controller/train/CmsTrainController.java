package com.sun3d.why.controller.train;

import com.alibaba.fastjson.JSONArray;
import com.sun3d.why.dao.CmsSensitiveWordsMapper;
import com.sun3d.why.dao.train.CmsTrainEnrolmentMapper;
import com.sun3d.why.model.*;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.model.train.*;
import com.sun3d.why.service.*;
import com.sun3d.why.service.train.CmsTrainOrderService;
import com.sun3d.why.service.train.CmsTrainService;
import com.sun3d.why.util.*;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Controller
@RequestMapping("/cmsTrain")
public class CmsTrainController {

    private Logger logger = LoggerFactory.getLogger(CmsTrainController.class);

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
    private CmsTrainOrderService orderService;

    @Autowired
    private SysDeptService sysDeptService;

    @Autowired
    private CmsCommentService commentService;
    @Autowired
    private CmsSensitiveWordsMapper cmsSensitiveWordsMapper;
    @Autowired
    private StaticServer staticServer;
    /**
     * 培训列表页
     *
     * @param train
     * @return
     */
    @RequestMapping("/cmsTrainIndex")
    public ModelAndView trainList(CmsTrainBean train, Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
            //培训所有场馆
            CmsVenue cmsVenue = new CmsVenue();
            cmsVenue.setVenueState(Constant.PUBLISH);
            cmsVenue.setVenueIsDel(Constant.NORMAL);
            List<SysDept> deptList = sysDeptService.queryAreaList("02dee52e685f4df9976dc294710e969a",null);
            //List<CmsVenue> venues = venueService.queryFrontCmsVenueByCondition(cmsVenue, null);
            CmsTrainEnrolment enrolment = enrolmentMapper.selectAll();
            List<CmsTag> tagList = cmsTagService.selectAllTrainTag("TRAIN_TYPE");
            model.addObject("page",page);
            model.addObject("tagList",tagList);
            model.addObject("enrolment",enrolment);
            //model.addObject("venues", venues);
            model.addObject("deptList",deptList);
            String areagrade = staticServer.getCityInfo().split(",")[3];
            String areaCode = "";
            if(areagrade.equals("1")){
                areaCode = staticServer.getCityInfo().split(",")[2];
            }if(areagrade.equals("2")){
                areaCode = staticServer.getCityInfo().split(",")[0];
            }else if(areagrade.equals("3")){
                areaCode = staticServer.getCityInfo().split(",")[4];
            }
            SysDept csysdept= sysDeptService.selectDeptByDeptCode(areaCode);
            model.addObject("areaCode", csysdept.getDeptId());
            model.addObject("areagrade", areagrade);
            model.setViewName("admin/train/trainList");
        } catch (Exception e) {
            logger.error("activityIndex error {}", e);
        }
        return model;
    }


    @RequestMapping(value = "/trainList")
    public String wcCmsActivityListByCondition(CmsTrainBean train, HttpServletResponse response, Integer page, Integer pageNum, PaginationApp pageApp) throws Exception {
        CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
        pageApp.setFirstResult(  (page - 1) * pageNum);
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
    public ModelAndView trainDetail(CmsTrainBean train) {
        ModelAndView model = new ModelAndView();
        try {
            CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
            if(terminalUser != null){
                List<CmsTrainOrderBean> order = trainService.queryTrainOrderListByCreateUser(terminalUser.getUserId());
                if(order.size() >= 1){
                    model.addObject("order",order.get(0));
                }
            }
            train = trainService.selectByPrimaryKey(train.getId(),terminalUser!=null?terminalUser.getUserId():null);
            String now = DateUtil.getCurrDate("yyyy-MM-dd HH:mm");
            CmsComment comment = new CmsComment();
            comment.setCommentRkId(train.getId());
            comment.setCommentType(10);
            int count = commentService.queryCommentCountByCondition(comment);
            model.addObject("commentCount", count);
            List<CmsTrainField> fieldsList = trainService.queryFieldListByTrainId(train.getId());
            CmsTrainEnrolment enrolment = enrolmentMapper.selectAll();
            model.addObject("enrolment",enrolment);
            model.addObject("fields", fieldsList);
            model.addObject("train", train);
            model.addObject("now", now);
            model.setViewName("admin/train/trainDetail");
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
            model.setViewName("admin/train/trainField");
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
            model.setViewName("admin/train/trainEntry");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return model;
    }

    @RequestMapping("/saveOrder")
    @ResponseBody
    public Object saveOrder(CmsTrainOrderBean order) {
        CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
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
            model.setViewName("admin/train/entryResult");
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
        model.setViewName("admin/train/trainOrder");
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
    public List<CmsTrainOrderBean> trainOrderList(CmsTrainOrderBean order) {
        CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
        order.setCreateUser(terminalUser.getUserId());
        List<CmsTrainOrderBean> orders = trainService.queryTrainOrderList(order);
        return orders;
    }


    @RequestMapping(value = "/trainComment")
    public ModelAndView trainComment(CmsTrainBean train) {
        ModelAndView model = new ModelAndView();
        try {
            train = trainService.selectByPrimaryKey(train.getId(),null);
            model.addObject("train", train);
            model.setViewName("admin/train/trainComment");
        } catch (Exception e) {
            logger.error("activityIndex error {}", e);
        }
        return model;
    }

    @RequestMapping(value = "/trainIndex")
    public String trainIndex() {
        return "index/userCenter/userTrainOrder";
    }

    @RequestMapping(value = "/trainingList")
    public String trainingList(){return "/wechat/train/trainList";}

    /**
     * 培训订单列表页
     *
     * @param status
     * @return
     */
    @RequestMapping(value = "/centerOrderList")
    public ModelAndView centerOrderList(Integer status, HttpServletRequest request, Pagination page) {
        ModelAndView model = new ModelAndView();
        Map<String,Object> map = new HashMap<>();
        map.put("status",status);
        page.setRows(6);
        CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
        map.put("createUser",terminalUser.getUserId());
        List<CmsTrainOrderBean> orders = trainService.queryCenterTrainOrderList(map,page);
        model.addObject("trainOrderList",orders);
        model.addObject("page",page);
        model.addObject("status",status);
        model.setViewName("index/userCenter/userTrainOrderLoad");
        return model;
    }

    /**
     * 前端2.0 添加评论
     *
     * @param comment
     * @param
     * @return
     */
    @RequestMapping(value = "/addComment", method = {RequestMethod.POST})
    @ResponseBody
    public String addComment(CmsComment comment) {
        try {
            if (session.getAttribute("terminalUser") != null) {
                String sensitiveWords = CmsSensitive.sensitiveWords(comment, cmsSensitiveWordsMapper);
                if (StringUtils.isNotBlank(sensitiveWords) && sensitiveWords.equals("sensitiveWordsExist")) {
                    return Constant.SensitiveWords_EXIST;
                }
                CmsTerminalUser user = (CmsTerminalUser) session.getAttribute("terminalUser");
                comment.setCommentUserId(user.getUserId());
                comment.setCommentType(10);
                return commentService.addComment(comment);
            }
        } catch (Exception e) {
            logger.error("addComment error {}", e);
            return Constant.RESULT_STR_FAILURE;
        }
        return Constant.RESULT_STR_FAILURE;
    }

}
