package com.sun3d.why.controller.volunteer;

import com.culturecloud.utils.StringUtils;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.volunteer.Volunteer;
import com.sun3d.why.model.volunteer.VolunteerActivity;
import com.sun3d.why.model.volunteer.VolunteerRelation;
import com.sun3d.why.service.SysDictService;
import com.sun3d.why.service.volunteer.VolunteerActivityService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RequestMapping("/newVolunteerActivity")
@Controller
public class NewVolunteerActivityController {

    private Logger logger = Logger.getLogger(NewVolunteerActivityController.class);

    @Autowired
    private VolunteerActivityService volunteerActivityService;
    @Autowired
    private SysDictService sysDictService;
    @Autowired
    private HttpSession session;


    /**
     * 跳转至志愿活动添加页面
     *
     * @param request
     * @return
     */
    @RequestMapping(value = "/preAddActivity")
    public String preAddActivity(HttpServletRequest request) {
        request.setAttribute("user", session.getAttribute("user"));
        return "admin/volunteer/activity/addActivity";
    }

    //志愿者招募活动新增，新增看是否需要重复校验
    @RequestMapping("/addNewVolunteerActivity")
    public ModelAndView addNewVolunteerActivity(VolunteerActivity volunteerActivity){
        logger.info("addNewVolunteerActivity进来了");
        SysUser loginUser = (SysUser)session.getAttribute("user");
        String uuid = UUIDUtils.createUUId();
        volunteerActivity.setUuid(uuid);
        volunteerActivity.setCreateId(loginUser.getUserId());
        volunteerActivity.setUpdateId(loginUser.getUserId());
//        volunteerActivity.setStatus(3);
        volunteerActivityService.addNewVolunteerActivity(volunteerActivity);

        ModelAndView model = new ModelAndView();
        model.addObject("uuid",uuid);
        model.setViewName("");
        return model;
    }


    //志愿者招募活动列表查询
    @RequestMapping("/queryNewVolunteerActivityList")
    public ModelAndView queryNewVolunteerActivityList(VolunteerActivity volunteerActivity, Pagination page){
        logger.info("queryNewVolunteerActivityList");
        List<VolunteerActivity> volunteerActivityList = volunteerActivityService.queryNewVolunteerActivityList(volunteerActivity, page);

        ModelAndView model = new ModelAndView();
        model.addObject("list", volunteerActivityList);
        model.addObject("page", page);
        model.addObject("model", volunteerActivity);
        model.setViewName("admin/volunteer/activity/activityManager");

        return model;
    }

    //志愿者招募活动业务管理
    @RequestMapping("/queryNewVolunteerActivityBusinessList")
    public ModelAndView queryNewVolunteerActivityBusinessList(VolunteerActivity volunteerActivity, Pagination page){
        logger.info("queryNewVolunteerActivityBusinessList");
        List<VolunteerActivity> volunteerActivityList = volunteerActivityService.queryNewVolunteerActivityList(volunteerActivity, page);

        ModelAndView model = new ModelAndView();
        model.addObject("list", volunteerActivityList);
        model.addObject("page", page);
        model.addObject("model", volunteerActivity);
        model.setViewName("admin/volunteer/activity/activityBusinessManager");

        return model;
    }

    //注册志愿者
    @RequestMapping("/signVolunteer")
    public ModelAndView signVolunteer(){
        ModelAndView model = new ModelAndView();
        model.setViewName("index/volunteer/signVolunteer");
        return model;
    }

    //志愿者招募活动详情查询
    @RequestMapping("/queryNewVolunteerActivityById")
    public ModelAndView queryNewVolunteerActivityById(String uuid){
        logger.info("queryNewVolunteerActivityById");
        VolunteerActivity volunteerActivity = volunteerActivityService.queryNewVolunteerActivityById(uuid);

        ModelAndView model = new ModelAndView();
        model.addObject("volunteerActivity", volunteerActivity);
        model.setViewName("admin/volunteer/activity/viewActivity");

        return model;

    }

    /**
     * 跳转至志愿活动修改页面
     *
     * @param request
     * @return
     */
    @RequestMapping(value = "/preEditActivity")
    public ModelAndView preEditActivity(String uuid) {
        logger.info("preEditActivity");
        VolunteerActivity volunteerActivity = volunteerActivityService.queryNewVolunteerActivityById(uuid);

        ModelAndView model = new ModelAndView();
        model.addObject("volunteerActivity", volunteerActivity);
        model.setViewName("admin/volunteer/activity/preEditActivity");

        return model;
    }

    //志愿者招募活动修改..修改时注意是否需要重复校验
    @RequestMapping("/updateNewVolunteerActivity")
    public ModelAndView updateNewVolunteerActivity(VolunteerActivity volunteerActivity){
        logger.info("updateNewVolunteerActivity");
        //需对id进行非空判断
        if(StringUtils.isBlank(volunteerActivity.getUuid())) {
            return null;
        }
        SysUser loginUser = (SysUser)session.getAttribute("user");
        volunteerActivity.setUpdateId(loginUser.getUserId());
        volunteerActivityService.updateNewVolunteerActivity(volunteerActivity);
        ModelAndView model = new ModelAndView();

        model.setViewName("");

        return model;
    }

    //志愿者招募活动审核
    @RequestMapping("/auditNewVolunteerActivity")
    public ModelAndView auditNewVolunteerActivity(VolunteerActivity volunteerActivity){
        logger.info("auditNewVolunteerActivity");
        //需对id进行非空判断
        if(StringUtils.isBlank(volunteerActivity.getUuid())) {
            return null;
        }
        if(volunteerActivity.getStatus() == null) {
            return null;
        }
        SysUser loginUser = (SysUser)session.getAttribute("user");
        volunteerActivity.setUpdateId(loginUser.getUserId());
        volunteerActivityService.auditNewVolunteerActivity(volunteerActivity);
        ModelAndView model = new ModelAndView();

        model.setViewName("");

        return model;
    }
    //志愿者招募活动删除。。
    @RequestMapping("/deleteNewVolunteerActivity")
    public ModelAndView deleteNewVolunteerActivity(String uuid){
        logger.info("deleteNewVolunteerActivity");
        //需对id进行非空判断
        if(StringUtils.isBlank(uuid)) {
            return null;
        }
        Map<String,Object> paramMap = new HashMap<>();
        paramMap.put("uuid", uuid);
        SysUser loginUser = (SysUser)session.getAttribute("user");
        paramMap.put("updateId", loginUser.getUserId());
        volunteerActivityService.deleteNewVolunteerActivity(paramMap);
        ModelAndView model = new ModelAndView();

        model.setViewName("");

        return model;
    }

    //加入志愿者活动
    @RequestMapping("/inNewVolunteerActivity")
    public ModelAndView inNewVolunteerActivity(VolunteerRelation volunteerRelation){
        logger.info("inNewVolunteerActivity");
        SysUser loginUser = (SysUser)session.getAttribute("user");
        volunteerRelation.setUuid(UUIDUtils.createUUId());
        volunteerRelation.setCreateId(loginUser.getUserId());
        volunteerRelation.setUpdateId(loginUser.getUserId());

        volunteerActivityService.addVolunteerRelation(volunteerRelation);

        ModelAndView model = new ModelAndView();

        model.setViewName("");

        return model;
    }

    //审核或者退出志愿者活动
    @RequestMapping("/updateVolunteerRelation")
    public ModelAndView updateVolunteerRelation(VolunteerRelation volunteerRelation){
        logger.info("updateVolunteerRelation");
        //需对id进行非空判断
        if(StringUtils.isBlank(volunteerRelation.getVolunteerActivityId())|| StringUtils.isBlank(volunteerRelation.getVolunteerId())) {
            return null;
        }
        SysUser loginUser = (SysUser)session.getAttribute("user");
        volunteerRelation.setUpdateId(loginUser.getUserId());
        volunteerActivityService.updateVolunteerRelation(volunteerRelation);
        ModelAndView model = new ModelAndView();

        model.setViewName("");

        return model;
    }

    /**
     * 跳转至招募成员管理页面
     *
     * @param request
     * @return
     */
    @RequestMapping(value = "/preMemberList")
    public ModelAndView preMemberList(VolunteerRelation volunteerRelation, Pagination page) {
        //需对id进行非空判断
//        if(StringUtils.isBlank(volunteerRelation.getVolunteerActivityId())||StringUtils.isBlank(volunteerRelation.getVolunteerId())) {
//            return null;
//        }
        if(StringUtils.isBlank(volunteerRelation.getVolunteerActivityId())) {
            return null;
        }
        Map<String,Object> paramMap = new HashMap<>();
        paramMap.put("volunteerActivityId",volunteerRelation.getVolunteerActivityId());
        List<Volunteer> volunteerList = volunteerActivityService.queryVolunteerListByParam(paramMap);
        ModelAndView model = new ModelAndView();

        model.addObject("list", volunteerList);
        model.addObject("activityId", volunteerRelation.getVolunteerActivityId());

//        model.addObject("page", page);
//        model.addObject("model", volunteerRelation);
        model.setViewName("admin/volunteer/activity/memberList");
        return model;
    }

    //查询活动成员列表
    @RequestMapping("/queryVolunteerListByParam")
    public ModelAndView queryVolunteerListByParam(VolunteerRelation volunteerRelation){
        logger.info("queryVolunteerListByParam");
        //需对id进行非空判断
        if(StringUtils.isBlank(volunteerRelation.getVolunteerActivityId())|| StringUtils.isBlank(volunteerRelation.getVolunteerId())) {
            return null;
        }
        Map<String,Object> paramMap = new HashMap<>();
        paramMap.put("volunteerActivityId",volunteerRelation.getVolunteerActivityId());
        List<Volunteer> volunteerList = volunteerActivityService.queryVolunteerListByParam(paramMap);
        ModelAndView model = new ModelAndView();

        model.addObject("volunteerList",volunteerList);
        model.setViewName("");

        return model;
    }

    //查询活动成员关系明细
    @RequestMapping("/queryVolunteerRelationDetail")
    public ModelAndView queryVolunteerRelationDetail(VolunteerRelation volunteerRelation){
        logger.info("queryVolunteerRelationDetail");
        //需对id进行非空判断
        if(StringUtils.isBlank(volunteerRelation.getVolunteerActivityId())|| StringUtils.isBlank(volunteerRelation.getVolunteerId())) {
            return null;
        }
        List<VolunteerRelation> volunteerRelationList = volunteerActivityService.queryVolunteerRelationDetail(volunteerRelation);

        ModelAndView model = new ModelAndView();
        model.addObject("volunteerRelationList",volunteerRelationList);
        model.setViewName("");

        return model;
    }

    //志愿者招募活动新增，新增看是否需要重复校验
    @RequestMapping("/addNewVolunteerActivityJson")
    @ResponseBody
    public Map<String, Object> addNewVolunteerActivityJson(VolunteerActivity volunteerActivity){
        logger.info("addNewVolunteerActivity进来了");
        SysUser loginUser = (SysUser)session.getAttribute("user");
        if(loginUser == null) {
            loginUser = new SysUser();
            loginUser.setUserId("test");
        }
        String uuid = UUIDUtils.createUUId();
        volunteerActivity.setUuid(uuid);
        volunteerActivity.setCreateId(loginUser.getUserId());
        volunteerActivity.setUpdateId(loginUser.getUserId());
//        volunteerActivity.setStatus(3);
        volunteerActivityService.addNewVolunteerActivity(volunteerActivity);

        Map<String, Object> returnMap = new HashMap<>();
        returnMap.put("status", 200);
        returnMap.put("uuid", uuid);
        return returnMap;
    }

    //志愿者招募活动列表查询
    @RequestMapping("/queryNewVolunteerActivityListJson")
    @ResponseBody
    public Map<String, Object> queryNewVolunteerActivityListJson(VolunteerActivity volunteerActivity, Pagination page){
        logger.info("queryNewVolunteerActivityList");
        List<VolunteerActivity> volunteerActivityList = volunteerActivityService.queryNewVolunteerActivityList(volunteerActivity, page);

//        ModelAndView model = new ModelAndView();
//        model.addObject("volunteerActivityList", volunteerActivityList);
//        model.setViewName("");
//
//        return model;
        Map<String, Object> returnMap = new HashMap<>();
        returnMap.put("status", 200);
        returnMap.put("volunteerActivityList", volunteerActivityList);
        returnMap.put("page", page);
        return returnMap;
    }

    //志愿者招募活动详情查询
    @RequestMapping("/queryNewVolunteerActivityByIdJson")
    @ResponseBody
    public Map<String, Object> queryNewVolunteerActivityByIdJson(String uuid){
        logger.info("queryNewVolunteerActivityList");
        VolunteerActivity volunteerActivity = volunteerActivityService.queryNewVolunteerActivityById(uuid);

//        ModelAndView model = new ModelAndView();
//        model.addObject("volunteerActivity", volunteerActivity);
//        model.setViewName("");
//
//        return model;
        Map<String, Object> returnMap = new HashMap<>();
        returnMap.put("status", 200);
        returnMap.put("volunteerActivity", volunteerActivity);
        return returnMap;
    }
    //志愿者招募活动修改..修改时注意是否需要重复校验
    @RequestMapping("/updateNewVolunteerActivityJson")
    @ResponseBody
    public Map<String, Object> updateNewVolunteerActivityJson(VolunteerActivity volunteerActivity){
        logger.info("updateNewVolunteerActivity");
        //需对id进行非空判断
        if(StringUtils.isBlank(volunteerActivity.getUuid())) {
            return null;
        }
        SysUser loginUser = (SysUser)session.getAttribute("user");
        if(loginUser == null) {
            loginUser = new SysUser();
            loginUser.setUserId("test");
        }
        volunteerActivity.setUpdateId(loginUser.getUserId());
        volunteerActivityService.updateNewVolunteerActivity(volunteerActivity);
//        ModelAndView model = new ModelAndView();
//
//        model.setViewName("");
//
//        return model;

        Map<String, Object> returnMap = new HashMap<>();
        returnMap.put("status", 200);
        returnMap.put("data", "sucess");
        return returnMap;
    }

    //志愿者招募活动审核
    @RequestMapping("/auditNewVolunteerActivityJson")
    @ResponseBody
    public Map<String, Object> auditNewVolunteerActivityJson(VolunteerActivity volunteerActivity){
        logger.info("auditNewVolunteerActivity");
        //需对id进行非空判断
        if(StringUtils.isBlank(volunteerActivity.getUuid())) {
            return null;
        }
        if(volunteerActivity.getStatus() == null) {
            return null;
        }
        SysUser loginUser = (SysUser)session.getAttribute("user");
        if(loginUser == null) {
            loginUser = new SysUser();
            loginUser.setUserId("test");
        }
        volunteerActivity.setUpdateId(loginUser.getUserId());
        volunteerActivityService.auditNewVolunteerActivity(volunteerActivity);
//        ModelAndView model = new ModelAndView();
//
//        model.setViewName("");
//
//        return model;

        Map<String, Object> returnMap = new HashMap<>();
        returnMap.put("status", 200);
        returnMap.put("data", "sucess");
        return returnMap;
    }
    //志愿者招募活动删除。。
    @RequestMapping("/deleteNewVolunteerActivityJson")
    @ResponseBody
    public Map<String, Object> deleteNewVolunteerActivityJson(String uuid){
        logger.info("deleteNewVolunteerActivity");
        //需对id进行非空判断
        if(StringUtils.isBlank(uuid)) {
            return null;
        }
        Map<String,Object> paramMap = new HashMap<>();
        paramMap.put("uuid", uuid);
        SysUser loginUser = (SysUser)session.getAttribute("user");
        if(loginUser == null) {
            loginUser = new SysUser();
            loginUser.setUserId("test");
        }
        paramMap.put("updateId", loginUser.getUserId());
        volunteerActivityService.deleteNewVolunteerActivity(paramMap);
//        ModelAndView model = new ModelAndView();
//
//        model.setViewName("");
//
//        return model;
        Map<String, Object> returnMap = new HashMap<>();
        returnMap.put("status", 200);
        returnMap.put("data", "sucess");
        return returnMap;
    }

    //加入志愿者活动
    @RequestMapping("/inNewVolunteerActivityJson")
    @ResponseBody
    public Map<String, Object> inNewVolunteerActivityJson(VolunteerRelation volunteerRelation){
        logger.info("inNewVolunteerActivity");
        SysUser loginUser = (SysUser)session.getAttribute("user");
        if(loginUser == null) {
            loginUser = new SysUser();
            loginUser.setUserId("test");
        }
        String uuid = UUIDUtils.createUUId();
        volunteerRelation.setUuid(uuid);
        volunteerRelation.setCreateId(loginUser.getUserId());
        volunteerRelation.setUpdateId(loginUser.getUserId());

        volunteerActivityService.addVolunteerRelation(volunteerRelation);

//        ModelAndView model = new ModelAndView();
//
//        model.setViewName("");
//
//        return model;
        Map<String, Object> returnMap = new HashMap<>();
        returnMap.put("status", 200);
        returnMap.put("uuid", uuid);
        return returnMap;
    }

    //审核或者退出志愿者活动
    @RequestMapping("/updateVolunteerRelationJson")
    @ResponseBody
    public Map<String, Object> updateVolunteerRelationJson(VolunteerRelation volunteerRelation){
        logger.info("updateVolunteerRelation");
        //需对id进行非空判断
        if(StringUtils.isBlank(volunteerRelation.getVolunteerActivityId())|| StringUtils.isBlank(volunteerRelation.getVolunteerId())) {
            return null;
        }
        SysUser loginUser = (SysUser)session.getAttribute("user");
        if(loginUser == null) {
            loginUser = new SysUser();
            loginUser.setUserId("test");
        }
        volunteerRelation.setUpdateId(loginUser.getUserId());
        volunteerActivityService.updateVolunteerRelation(volunteerRelation);
//        ModelAndView model = new ModelAndView();
//
//        model.setViewName("");
//
//        return model;
        Map<String, Object> returnMap = new HashMap<>();
        returnMap.put("status", 200);
        returnMap.put("data", "sucess");
        return returnMap;
    }

    //查询活动成员列表
    @RequestMapping("/queryVolunteerListByParamJson")
    @ResponseBody
    public Map<String, Object> queryVolunteerListByParamJson(VolunteerRelation volunteerRelation){
        logger.info("queryVolunteerListByParam");
        //需对id进行非空判断
        if(StringUtils.isBlank(volunteerRelation.getVolunteerActivityId())) {
            return null;
        }
        Map<String,Object> paramMap = new HashMap<>();
        paramMap.put("volunteerActivityId",volunteerRelation.getVolunteerActivityId());
        List<Volunteer> volunteerList = volunteerActivityService.queryVolunteerListByParam(paramMap);
//        ModelAndView model = new ModelAndView();

//        model.addObject("volunteerList",volunteerList);
//        model.setViewName("");
//
//        return model;
        Map<String, Object> returnMap = new HashMap<>();
        returnMap.put("status", 200);
        returnMap.put("volunteerList", volunteerList);
        return returnMap;
    }

    //查询活动成员关系明细
    @RequestMapping("/queryVolunteerRelationDetailJson")
    @ResponseBody
    public Map<String, Object> queryVolunteerRelationDetailJson(VolunteerRelation volunteerRelation){
        logger.info("queryVolunteerRelationDetail");
        //需对id进行非空判断
        if(StringUtils.isBlank(volunteerRelation.getVolunteerActivityId())|| StringUtils.isBlank(volunteerRelation.getVolunteerId())) {
            return null;
        }
        List<VolunteerRelation> volunteerRelationList = volunteerActivityService.queryVolunteerRelationDetail(volunteerRelation);

//        ModelAndView model = new ModelAndView();
//        model.addObject("volunteerRelationList",volunteerRelationList);
//        model.setViewName("");
//
//        return model;
        Map<String, Object> returnMap = new HashMap<>();
        returnMap.put("status", 200);
        returnMap.put("data", volunteerRelationList);
        return returnMap;
    }

}
