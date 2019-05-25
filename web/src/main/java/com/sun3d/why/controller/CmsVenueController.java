//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//
package com.sun3d.why.controller;

import java.io.File;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.fastjson.JSONArray;
import com.sun3d.why.dao.CmsVenueMapper;
import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.CmsAntique;
import com.sun3d.why.model.CmsTagSubRelate;
import com.sun3d.why.model.CmsVenue;
import com.sun3d.why.model.SysDept;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.extmodel.AreaData;
import com.sun3d.why.model.extmodel.BasePath;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.CmsActivityOrderService;
import com.sun3d.why.service.CmsActivityService;
import com.sun3d.why.service.CmsAntiqueService;
import com.sun3d.why.service.CmsDeptService;
import com.sun3d.why.service.CmsTagSubRelateService;
import com.sun3d.why.service.CmsUserService;
import com.sun3d.why.service.CmsVenueService;
import com.sun3d.why.util.CommonUtil;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.EncodeImgZingLogo;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.QRCode;

import net.sf.json.JSONObject;

@RequestMapping(value = "/venue")
@Controller
public class CmsVenueController {

    private Logger logger = Logger.getLogger(CmsVenueController.class);
    //场馆逻辑控制层
    @Autowired
    private CmsVenueService cmsVenueService;
    //活动逻辑控制层
    @Autowired
    private CmsActivityService activityService;
    //系统用户逻辑控制层
    @Autowired
    private CmsUserService cmsUserService;
    //馆藏逻辑控制层
    @Autowired
    private CmsAntiqueService cmsAntiqueService;
    //当前session
    @Autowired
    private HttpSession session;
    @Autowired
    private CmsActivityOrderService cmsActivityOrderService;
    @Autowired
    private CmsDeptService cmsDeptService;
    @Autowired
    private CacheService cacheService;

    @Autowired
    private CmsVenueMapper  CmsVenueMapper;
    
    @Autowired 
    private CmsTagSubRelateService cmsTagRelateService;
    @Autowired
    private BasePath basePath;
    @Autowired
 	private StaticServer staticServer;

    //添加场所获取小时数
    @RequestMapping(value = "/getVenueHours")
    @ResponseBody
    public String getVenueHours() {

        return cmsVenueService.venueHours();
    }

    //添加场馆获取分钟
    @RequestMapping(value = "/getVenueMin")
    @ResponseBody
    public String getVenueMin() {

        return cmsVenueService.venueMin();
    }

    /**
     * 文化云平台后台管理-场馆列表
     * @param venue
     * @param areaData
     * @param page
     * @return
     */
    @RequestMapping(value ="/venueIndex")
    public ModelAndView venueIndex(CmsVenue venue, String areaData, String venueType, String searchKey, Pagination page) {
        ModelAndView model = new ModelAndView();
        List<CmsVenue> list = null;
        try{
            if(session.getAttribute("user") != null){
                SysUser user = (SysUser)session.getAttribute("user");
                String userDeptPath = null;
                if(user != null){
                    userDeptPath = user.getUserDeptPath();
                    venue.setUserLabel1(user.getUserLabel1());
                    venue.setUserLabel2(user.getUserLabel2());
                    venue.setUserLabel3(user.getUserLabel3());
                }
                if(StringUtils.isNotBlank(areaData)){
                    venue.setVenueArea(areaData);
                }
                if(StringUtils.isNotBlank(venueType)){
                    venue.setVenueType(venueType);
                }
                if(StringUtils.isNotBlank(searchKey)){
                    venue.setSearchKey(searchKey);
                }
                venue.setVenueState(Constant.PUBLISH);
                list = cmsVenueService.queryVenueByCondition(venue,page, null, userDeptPath);
            }
            model.addObject("list", list);
            model.addObject("venue", venue);
            model.addObject("page", page);
            model.addObject("areaData", areaData);
            model.addObject("venueType", venueType);
            model.addObject("searchKey", searchKey);
            model.setViewName("admin/venue/venueIndex");
        }catch (Exception e){
            logger.error("venueIndex error" , e);
        }
        return model;
    }

    /**
     * 文化云平台后台管理-草稿列表
     * @param venue
     * @param areaData
     * @param page
     * @return
     */
    @RequestMapping(value ="/venueDraftList")
    public ModelAndView venueDraftList(CmsVenue venue, String areaData, String venueType, String searchKey, Pagination page) {
        ModelAndView model = new ModelAndView();
        List<CmsVenue> list = null;
        try{
            if(session.getAttribute("user") != null){
                SysUser user = (SysUser)session.getAttribute("user");
                String userDeptPath = null;
                if(user != null){
                    userDeptPath = user.getUserDeptPath();
                    venue.setUserLabel1(user.getUserLabel1());
                    venue.setUserLabel2(user.getUserLabel2());
                    venue.setUserLabel3(user.getUserLabel3());
                }
                if(StringUtils.isNotBlank(areaData)){
                    venue.setVenueArea(areaData);
                }
                if(StringUtils.isNotBlank(venueType)){
                    venue.setVenueType(venueType);
                }
                if(StringUtils.isNotBlank(searchKey)){
                    venue.setSearchKey(searchKey);
                }
                venue.setVenueState(Constant.DRAFT);
                list = cmsVenueService.queryVenueByCondition(venue,page, null, userDeptPath);
            }
            model.addObject("list", list);
            model.addObject("venue", venue);
            model.addObject("page", page);
            model.addObject("areaData", areaData);
            model.addObject("venueType", venueType);
            model.addObject("searchKey", searchKey);
            model.setViewName("admin/venue/venueDraftList");
        }catch (Exception e){
            logger.error("venueDraftList error" , e);
        }
        return model;
    }

    /**
     * 文化云平台后台管理-回收站
     * @param venue
     * @param areaData
     * @param page
     * @return
     */
    @RequestMapping(value ="/venueRecycleList")
    public ModelAndView venueRecycleList(CmsVenue venue, String areaData, String venueType, String searchKey, Pagination page) {
        ModelAndView model = new ModelAndView();
        List<CmsVenue> list = null;
        try{
            if(session.getAttribute("user") != null){
                SysUser user = (SysUser)session.getAttribute("user");
                String userDeptPath = null;
                if(user != null){
                    userDeptPath = user.getUserDeptPath();
                    venue.setUserLabel1(user.getUserLabel1());
                    venue.setUserLabel2(user.getUserLabel2());
                    venue.setUserLabel3(user.getUserLabel3());
                }
                if(StringUtils.isNotBlank(areaData)){
                    venue.setVenueArea(areaData);
                }
                if(StringUtils.isNotBlank(venueType)){
                    venue.setVenueType(venueType);
                }
                if(StringUtils.isNotBlank(searchKey)){
                    venue.setSearchKey(searchKey);
                }
                venue.setVenueIsDel(Constant.DELETE);
                list = cmsVenueService.queryVenueByCondition(venue,page, null, userDeptPath);
            }
            model.addObject("list", list);
            model.addObject("venue", venue);
            model.addObject("page", page);
            model.addObject("areaData", areaData);
            model.addObject("venueType", venueType);
            model.addObject("searchKey", searchKey);
            model.setViewName("admin/venue/venueRecycleList");
        }catch (Exception e){
            logger.error("venueRecycleList error" , e);
        }
        return model;
    }

    /**
     * 预添加场馆
     * @return
     */
    @RequestMapping(value = "/preAddVenue")
    public ModelAndView preAddVenue(@RequestParam(value="parentId",required=false,defaultValue="") String parentDeptId) {
        ModelAndView model = new ModelAndView();
        model.addObject("parentDeptId", parentDeptId);
        model.setViewName("admin/venue/addVenue");
        return model;
    }

    /**
     * 添加场馆
     * @param venue
     * @return
     */
    @RequestMapping(value = "/addVenue")
    @ResponseBody
    public String addVenue(CmsVenue venue,String []commonTag,String []childTag) {
        //默认为0，如果后续流程执行出错，则操作失败
        int count = 0;
        try {
            //从session中获取用户信息
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if(sysUser != null){

                // 判断是否有重名的部门
                Map map = new HashMap();
                map.put("deptIsFromVenue",1);
                map.put("deptName",venue.getVenueName());
//                map.put("deptParentId",venue.getVenueParentDeptId());
                int countName = cmsDeptService.queryCountByMap(map);
                if (countName > 0) {
                    return "repeat";
                }
                count = cmsVenueService.saveVenue(venue,sysUser);

                //更新Redis中场馆首页缓存数据
              /*  Pagination page = new Pagination();
                CmsVenue tempCmsVenue = new CmsVenue();
                tempCmsVenue.setVenueState(Constant.PUBLISH);
                tempCmsVenue.setVenueIsDel(Constant.NORMAL);
                page.setRows(30);
                List<CmsVenue> venueList = cmsVenueService.queryFrontCmsVenueByCondition(tempCmsVenue, page);
                cacheService.updateVenueIndex(Constant.VENUE_INDEX_REDIS_DEFAULT,venueList);
                cacheService.setVenueIndexTotal(Constant.VENUE_INDEX_DEFAULT_TOTAL,page.getTotal());*/
                //将缓存的场馆列表置空
                cacheService.updateVenueIndex(Constant.VENUE_INDEX_REDIS_DEFAULT,new ArrayList<CmsVenue>());
            }else{
                logger.error("当前登录用户不存在或没有登录，添加操作终止!");
            }
        } catch (Exception e) {
            logger.error("添加场所信息时出错!", e);
        }
        if(count>0){
        	
        	String venueId=venue.getVenueId();
        	
        	Integer type= Constant.TYPE_VENUE;
        	
        	cmsTagRelateService.insertTagRelateList(venueId, type, commonTag);
        	
        	cmsTagRelateService.insertTagRelateList(venueId, type, childTag);
        	
            return venueId;
        }else {
            return Constant.RESULT_STR_FAILURE;
        }
    }

    /**
     * 预编辑场馆
     * @param venueId
     * @return
     */
    @RequestMapping(value = "/preEditVenue")
    public ModelAndView preEditVenue(String venueId) {
        ModelAndView model = new ModelAndView();
        CmsVenue cmsVenue = null;
        try{
            //从session中获取用户信息
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if(sysUser != null && StringUtils.isNotBlank(venueId)) {
                cmsVenue = cmsVenueService.queryVenueById(venueId);
                
               List<CmsTagSubRelate> tagRelateList= cmsTagRelateService.queryTagRelateByEntityId(venueId);
               
               String [] venueTags=new String[tagRelateList.size()];
               
               for (int i = 0; i < tagRelateList.size(); i++) {
            	   
            	   CmsTagSubRelate relate= tagRelateList.get(i);
            	   String tagId=relate.getTagSubId();
            	   venueTags[i]=tagId;
               }
               
               model.addObject("venueTags",StringUtils.join(venueTags, ",")); 
            }
        }catch (Exception e){
            logger.error("加载编辑页面时出错!", e);
        }
        model.addObject("cmsVenue",cmsVenue);
        model.setViewName("admin/venue/editVenue");
        return model;
    }

    /**
     * 编辑场馆
     * @param venue
     * @return
     */
    @RequestMapping(value = "/editVenue")
    @ResponseBody
    public String editVenue(CmsVenue venue,String []commonTag,String []childTag) {
        //默认为0，如果后续流程执行出错，则操作失败
        int count = 0;
        try {
            //从session中获取用户信息
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if(sysUser != null){
                CmsVenue tempVenue = cmsVenueService.queryVenueById(venue.getVenueId());
                // 判断是否有重名的部门
                Map map = new HashMap();
                map.put("deptIsFromVenue",1);
                map.put("deptName",venue.getVenueName());
//                map.put("deptParentId",venue.getVenueParentDeptId());
                List<SysDept> deptList = cmsDeptService.querySysDeptByMap(map);
                if (deptList != null && deptList.size() >0) {
                    if(!tempVenue.getVenueName().equals(venue.getVenueName())){
                        return "repeat";
                    }else{
                        SysDept sysDept = deptList.get(0);
                        venue.setVenueDeptId(sysDept.getDeptId());
                    }
                }else{
                    if(StringUtils.isBlank(tempVenue.getVenueDeptId())){
                        //针对文化云线上环境，特追加以下代码
                        SysDept sysDept = cmsVenueService.saveDept(venue,sysUser);
                        venue.setVenueDeptId(sysDept.getDeptId());
                    }
                }

                venue.setVenueUpdateTime(new Date());
                venue.setVenueUpdateUser(sysUser.getUserId());
                if(StringUtils.isNotBlank(venue.getVenueRoamUrl())){
                    //2代表支持虚拟漫游地址
                    venue.setVenueIsRoam(2);
                }else{
                    //1代表不支持虚拟漫游地址
                    venue.setVenueIsRoam(1);
                }
                count = cmsVenueService.editVenueById(venue);
                
                Set<String>tagSet=new HashSet<String>();
                tagSet.addAll(Arrays.asList(commonTag));
                tagSet.addAll(Arrays.asList(childTag));
                
                String venueId=venue.getVenueId();
            	
            	Integer type= Constant.TYPE_VENUE;
            	
            	cmsTagRelateService.updateEntityTagRelateList(venueId, type, tagSet);

                //将缓存的场馆列表置空
                cacheService.updateVenueIndex(Constant.VENUE_INDEX_REDIS_DEFAULT,new ArrayList<CmsVenue>());
            }else{
                logger.error("当前登录用户不存在或没有登录，添加操作终止!");
            }
        } catch (Exception e) {
            logger.error("添加场所信息时出错!", e);
        }
        if(count>0){
            return venue.getVenueId();
        }else {
            return Constant.RESULT_STR_FAILURE;
        }
    }

    /**
     * 预生成场馆座位
     * @param venueId
     * @return
     */
    @RequestMapping(value = "/preBuildVenueSeat")
    public ModelAndView preBuildVenueSeat(String venueId) {
        ModelAndView model = new ModelAndView();
        CmsVenue cmsVenue = null;
        try{
            if(StringUtils.isNotBlank(venueId)){
                cmsVenue = cmsVenueService.queryVenueById(venueId);
            }
        }catch (Exception e){
            logger.error("加载场馆生成页面时出错!", e);
        }
        model.addObject("cmsVenue",cmsVenue);
        model.setViewName("admin/venue/venueSeatBuild");
        return model;
    }

    /**
     * 逻辑删除场馆信息
     * @param venueId
     * @return
     */
    @RequestMapping(value = "/deleteVenue")
    @ResponseBody
    public String deleteVenue(String venueId) {
        int count = 0;
        String result = Constant.RESULT_STR_FAILURE;
        try{
            //从session中获取用户信息
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if(sysUser != null){
                if(StringUtils.isNotBlank(venueId)) {
                    count = cmsVenueService.updateStateByVenueIds(venueId, sysUser.getUserId());
                    if (count > 0) {
                        result = Constant.RESULT_STR_SUCCESS;

                        //将缓存的场馆列表置空
                        cacheService.updateVenueIndex(Constant.VENUE_INDEX_REDIS_DEFAULT,new ArrayList<CmsVenue>());
                    }
                }
            }else{
                logger.error("用户没有登录，删除操作终止!");
            }
        }catch (Exception e){
            logger.info("删除场馆时出错!", e);
        }
        return result;
    }
    
    /**
     * 草稿箱列表-发布场馆信息
     * @param venueId
     * @return
     */
    @RequestMapping(value = "/publishVenue")
    @ResponseBody
    public String publishVenue(String venueId) {
        int count = 0;
        String result = Constant.RESULT_STR_FAILURE;
        try{
            //从session中获取用户信息
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if(sysUser != null){
                if(StringUtils.isNotBlank(venueId)) {
                    CmsVenue cmsVenue = new CmsVenue();
                    cmsVenue.setVenueId(venueId);
                    cmsVenue.setVenueUpdateUser(sysUser.getUserId());
                    cmsVenue.setVenueUpdateTime(new Date());
                    cmsVenue.setVenueState(Constant.PUBLISH);
                    count = cmsVenueService.editVenueById(cmsVenue);
                    if (count > 0) {
                        result = Constant.RESULT_STR_SUCCESS;

                        //将缓存的场馆列表置空
                        cacheService.updateVenueIndex(Constant.VENUE_INDEX_REDIS_DEFAULT,new ArrayList<CmsVenue>());
                    }
                }
            }else{
                logger.error("用户没有登录，发布操作终止!");
            }
        }catch (Exception e){
            logger.info("发布场馆时出错!", e);
        }
        return result;
    }

    /**
     * 将回收站的场馆恢复至草稿箱中
     * @param venueId
     * @return
     */
    @RequestMapping(value = "/backVenue")
    @ResponseBody
    public String backVenue(String venueId) {
        int count = 0;
        String result = Constant.RESULT_STR_FAILURE;
        try{
            //从session中获取用户信息
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if(sysUser != null){
                if(StringUtils.isNotBlank(venueId)) {
                    CmsVenue cmsVenue = new CmsVenue();
                    cmsVenue.setVenueId(venueId);
                    cmsVenue.setVenueUpdateUser(sysUser.getUserId());
                    cmsVenue.setVenueUpdateTime(new Date());
                    cmsVenue.setVenueState(Constant.DRAFT);
                    cmsVenue.setVenueIsDel(Constant.NORMAL);
                    count = cmsVenueService.editVenueById(cmsVenue);
                    if (count > 0) {
                        result = Constant.RESULT_STR_SUCCESS;
                    }
                }
            }else{
                logger.error("用户没有登录，发布操作终止!");
            }
        }catch (Exception e){
            logger.info("发布场馆时出错!", e);
        }
        return result;
    }

    /**
     * 彻底删除场馆信息
     * @param venueId
     * @return
     */
    @RequestMapping(value = "/totalDeleteVenue")
    @ResponseBody
    public String totalDeleteVenue(String venueId) {
        int count = 0;
        String result = Constant.RESULT_STR_FAILURE;
        try{
            //从session中获取用户信息
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if(sysUser != null ){
                if(StringUtils.isNotBlank(venueId)){
                    count = cmsVenueService.deleteVenueById(venueId);
                    if(count > 0){
                        result = Constant.RESULT_STR_SUCCESS;
                    }
                }
            }else{
                logger.error("用户没有登录，彻底删除操作终止!");
            }
        }catch (Exception e){
            logger.info("彻底删除场馆时出错!", e);
        }
        return result;
    }

    /**
     * @param venueId
     * @return
     * @author cj
     * @date 2015年5月13日 下午19:20
     */
    @RequestMapping("/preAssignManager")
    public ModelAndView toAssignManager(String venueId) {
        ModelAndView model = new ModelAndView();
        List<SysUser> tempUserList = null;
        CmsVenue venue = null;
        SysUser loginUser = (SysUser) session.getAttribute("user");
        if(loginUser != null){
            tempUserList = cmsUserService.getNotAssignedUsers(loginUser);
            if(StringUtils.isNotBlank(venueId)){
                venue = cmsVenueService.queryVenueById(venueId);
            }
        }
        model.setViewName("admin/venue/preAssign");
        model.addObject("venue", venue);
        model.addObject("userList", tempUserList);
        return model;
    }

    /**
     * @param venueId
     * @param userDeptPath
     * @param userId
     * @return
     * @author cj
     * @date 2015年5月13日 下午20:09
     */
    @RequestMapping("/assignManager")
    @ResponseBody
    public String assignManager(String venueId, String userDeptPath, String userId) {
        try{
            String result = Constant.RESULT_STR_FAILURE;
            SysUser user = (SysUser) session.getAttribute("user");
            if(user != null){
                if(StringUtils.isNotBlank(venueId)){
                    result = cmsVenueService.saveAssignManager(user,venueId,userDeptPath,userId);
                }
            }
            return  result;
        }catch (Exception e){
            return Constant.RESULT_STR_FAILURE;
        }
    }

    /**
     * 查看管理员
     * @param venueId
     * @return
     * @author cj
     * @date 2015年5月13日 下午20:09
     */
    @RequestMapping("/preViewAssign")
    public ModelAndView toViewAssign(String venueId) {
        ModelAndView modelAndView = new ModelAndView();
        SysUser sysUser = null;
        if(StringUtils.isNotBlank(venueId)) {
            CmsVenue venue = cmsVenueService.queryVenueById(venueId);
            String managerId = venue.getManagerId();
            sysUser = cmsUserService.querySysUserByUserId(managerId);
        }
        modelAndView.setViewName("admin/venue/viewAssign");
        modelAndView.addObject("sysUser", sysUser);
        modelAndView.addObject("viewAssign", 1);
        return modelAndView;
    }

    /**
     * 得到所有区域的编码信息
     */
    @RequestMapping(value = "/getLocArea")
    @ResponseBody
    public List<AreaData> getLocArea() {
        List<AreaData> areaDataList = null;
        try {
            areaDataList = cmsVenueService.queryVenueAllArea();
        } catch(Exception e){
            logger.error("获取区县信息出错!",e);
        }
        return areaDataList;
    }




    @RequestMapping(value = "/getMoreAntiqueList")
    @ResponseBody
    public List<CmsAntique> getMoreAntiqueList(int pageNum, String venueId) {
        List<CmsAntique> antiqueList = new ArrayList<CmsAntique>();
        CmsAntique condition = new CmsAntique();
        if(StringUtils.isNotBlank(venueId)){
            condition.setVenueId(venueId);
            condition.setAntiqueIsDel(Constant.NORMAL);
            condition.setAntiqueState(Constant.PUBLISH);
            condition.setRows(6);
            condition.setPage(pageNum);
            antiqueList = cmsAntiqueService.queryByCmsAntique(condition);
        }
        return antiqueList;
    }

    //前台场馆获取正在进行的活动
    @RequestMapping(value = "/activityIndex")
    @ResponseBody
    public List<CmsActivity> activityDetail(@RequestParam(value = "venueArea", required = false) String venueArea, @RequestParam(value = "venueId", required = false
    ) String venueId, Pagination page) {
        this.logger.debug("venueId=" + venueId);
        CmsActivity cmsActivity = new CmsActivity();
        if (venueArea != null && (venueArea = CommonUtil.enCodeStr(venueArea)) != null) {
            cmsActivity.setVenueArea(venueArea);
        }
        cmsActivity.setVenueId(venueId);
        Date nowTime = new Date(System.currentTimeMillis());
        SimpleDateFormat sdFormatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String retStrFormatNowDate = sdFormatter.format(nowTime);
        cmsActivity.setActivityStartTime(retStrFormatNowDate);
        List activityList = this.activityService.queryCmsVenueActivity(cmsActivity, page);
        return activityList;
    }

    //前台场馆详情显示推荐馆藏
    @RequestMapping(value = "/antiqueLeading")
    @ResponseBody
    public String antiqueDetail(@RequestParam(value = "venueId", required = false) String venueId, Pagination page) {
        CmsAntique cmsAntique = new CmsAntique();
        cmsAntique.setVenueId(venueId);
        cmsAntique.setAntiqueIsDel(1);
        cmsAntique.setAntiqueState(6);
        List<CmsAntique> antiqueList = cmsVenueService.queryCmsAntique(cmsAntique, page);
        JSONObject json = new JSONObject();
        json.put("data", antiqueList);
        json.put("page", page);
        return json.toString();
    }

    /**
     * 得到所有区域的编码信息
     *
     * @param request
     * @param response
     */
    @RequestMapping(value = "/getActivityArea", method = RequestMethod.GET)
    @ResponseBody
    public void getActivityArea(HttpServletRequest request, HttpServletResponse response) {
        PrintWriter printWriter = null;
        try {
            JSONArray jsonObject = new JSONArray();
            jsonObject.add(cmsVenueService.queryVenueAllArea());
            String allAreas = jsonObject.toJSONString();
            allAreas = allAreas.substring(1, allAreas.length() - 1);
            allAreas = "{\"data\":" + allAreas + "}";
            printWriter = response.getWriter();
            response.setCharacterEncoding("UTF-8");
            printWriter.printf(allAreas.toString());
            printWriter.flush();
        } catch (Exception e) {
            logger.info("getLocArea error ", e);
        } finally {
            if (printWriter != null) {
                try {
                    printWriter.close();
                } catch (Exception e) {
                    logger.info("printWriter error ", e);
                }
            }
        }

    }

    /**
     * 根据区县信息查询得到 场馆类型信息
     *
     * @param request
     * @return
     */
    @RequestMapping(value = "/getVenueType", method = RequestMethod.GET)
    @ResponseBody
    public void getVenueType(HttpServletRequest request, HttpServletResponse response) {
        PrintWriter printWriter = null;
        try {
            String venueArea = request.getParameter("areaId");
            JSONArray jsonObject = new JSONArray();
            jsonObject.add(cmsVenueService.queryVenueAllType(venueArea));
            String rsStr = jsonObject.toJSONString();
            rsStr = rsStr.substring(1, rsStr.length() - 1);
            rsStr = "{\"data\":" + rsStr + "}";
            printWriter = response.getWriter();
            response.setCharacterEncoding("UTF-8");
            printWriter.printf(rsStr.toString());
            printWriter.flush();
        } catch (Exception e) {
            logger.info("getVenueType error ", e);

        } finally {
            if (printWriter != null) {
                try {
                    printWriter.close();
                } catch (Exception e) {
                    logger.info("printWriter error ", e);
                }
            }
        }
    }

    /**
     * 根据区县信息查询和场馆类型信息 的到场馆名字列表
     *
     * @param request
     * @return
     */
    @RequestMapping(value = "/getVenueName", method = RequestMethod.GET)
    @ResponseBody
    public void getVenueName(HttpServletRequest request, HttpServletResponse response) {
        PrintWriter printWriter = null;
        try {
            String venueType = request.getParameter("venueType");
            String areaId = request.getParameter("areaId");

            JSONArray jsonObject = new JSONArray();
            SysUser sysUser = (SysUser) session.getAttribute("user");
            jsonObject.add(cmsVenueService.queryVenueNameByAreaAndType(areaId,venueType,sysUser));
            String nameDatas = jsonObject.toJSONString();
            nameDatas = nameDatas.substring(1, nameDatas.length() - 1);
            nameDatas = "{\"data\":" + nameDatas + "}";

            printWriter = response.getWriter();
            response.setCharacterEncoding("UTF-8");
            printWriter.printf(nameDatas.toString());
            printWriter.flush();

        } catch (Exception e) {
            logger.info("getVenueName error ", e);
            e.printStackTrace();
        } finally {
            if (printWriter != null) {
                try {
                    printWriter.close();
                } catch (Exception e) {
                    logger.info("printWriter error ", e);
                }
            }
        }
    }

    /**
     * 文化云平台后台管理-3.0场馆评论管理列表
     * @param venue
     * @param page
     * @return
     */
    @RequestMapping(value ="/venueCommentIndex")
    public ModelAndView venueIndex(CmsVenue venue,Pagination page) {
        ModelAndView model = new ModelAndView();
        List<CmsVenue> list = null;
        try{
            if(session.getAttribute("user") != null){
                SysUser user = (SysUser)session.getAttribute("user");
                String userDeptPath = null;
                if(user != null){
                    userDeptPath = user.getUserDeptPath();
                }
                list = cmsVenueService.queryVenueCommentByCondition(venue, page, userDeptPath);
            }

            model.addObject("list", list);
            model.addObject("venue", venue);
            model.addObject("page", page);
            model.setViewName("admin/venue/venueCommentIndex");
        }catch (Exception e){
            logger.error("venueCommentIndex error" + e);
        }
        return model;
    }

    /**
     * 文化云平台后台管理-3.0场馆评论管理 所属区县
     * @param venue
     * @return
     */
    @RequestMapping(value ="/getVenueCommentExistArea")
    @ResponseBody
    public List<String> venueCommentExistArea(CmsVenue venue) {
        List<String> areaList = null;
        try {
            if(session.getAttribute("user") != null){
                SysUser user = (SysUser)session.getAttribute("user");
                String userDeptPath = null;
                if(user != null){
                    userDeptPath = user.getUserDeptPath();
                }
                List<CmsVenue> venueCommentArea = cmsVenueService.queryVenueCommentExitArea(venue, userDeptPath);
                areaList = new ArrayList<String>();
                if (CollectionUtils.isNotEmpty(venueCommentArea)) {
                    for (CmsVenue cmsVenue : venueCommentArea) {
                        if (!areaList.contains(cmsVenue.getVenueArea())) {
                            areaList.add(cmsVenue.getVenueArea());
                        }
                    }
                }
            }
        } catch (Exception e) {
            logger.error("查询系统中所有团体所在区域信息时出错", e);
        }
        return areaList;
    }
    
    /**
     * 
     * @Description: 后台场馆列表 推荐和取消推荐功能
     * @author hucheng
     * @Created 2015-10-19
     * @param venueId 场馆ID
     * @param type 'yes'-推荐操作|'no'-取消推荐操作
     * @return
     */
    @RequestMapping(value="/recommendVenue")
    @ResponseBody
    public String recommendVenue(String venueId,String type,HttpServletResponse response){

    	if(StringUtils.isNotBlank(venueId)){
    		CmsVenue venue = cmsVenueService.queryVenueById(venueId);
            //页面点置顶操作
            if("yes".equals(type)){
                //查询是否置顶的场馆List
                Map<String,Object> map = new HashMap<String,Object>();
                map.put("venueIsRocemmend",2);
                map.put("venueIsDel",1);
                map.put("venueState",6);
                List<CmsVenue> venueList =  CmsVenueMapper.queryRecommendVenueByConditionList(map);
                if(venueList.size()>=5){
                    CmsVenue cVenue = venueList.get(4);
                    cVenue.setVenueIsRecommend(Constant.RECOMMEND_NO);
                    cVenue.setVenueRecommendTime(null);
                    //cVenue.setVenueUpdateTime(new Date());
                    cmsVenueService.editVenueById(cVenue);
                    venue.setVenueIsRecommend(Constant.RECOMMEND_YES); //推荐状态 ：2-推荐
                    venue.setVenueRecommendTime(new Date());
                    //venue.setVenueUpdateTime(new Date());
                    cmsVenueService.editVenueById(venue);
                    return Constant.RESULT_STR_SUCCESS;
                }else {
                    if (venue != null) {
                        venue.setVenueIsRecommend(Constant.RECOMMEND_YES); //推荐状态 ：2-推荐
                        /******更新推荐时间 2015.11.13 add by niu*******/
                        venue.setVenueRecommendTime(new Date());
                        //venue.setVenueUpdateTime(new Date());
                        cmsVenueService.editVenueById(venue);
                        return Constant.RESULT_STR_SUCCESS;
                    }
                }
            }else{
                venue.setVenueIsRecommend(Constant.RECOMMEND_NO); //推荐状态 ：1-没有推荐
                venue.setVenueRecommendTime(null);
                cmsVenueService.canleRecommendVenue(venue.getVenueId());
                return Constant.RESULT_STR_SUCCESS;
            }
    	}
            return Constant.RESULT_STR_FAILURE;
    }
    
    
    @RequestMapping(value="/preDeleteVenue",method=RequestMethod.POST)
    @ResponseBody
    public Object preDeleteVenue(String venueId){
    	JSONObject json = new JSONObject();
    	int count = 0;
    	if(StringUtils.isNotBlank(venueId)){
    		CmsVenue venue = cmsVenueService.queryVenueById(venueId);
    		Map<String, Object> map = new HashMap<String, Object>();
    		if(venue!=null){
                SysDept dept = this.cmsDeptService.querySysDeptByDeptId(venue.getVenueDeptId());
                SysUser sysUser = new SysUser();
                sysUser.setUserDeptId(venue.getVenueDeptId());
                //查询这个部门下面是否存在用户  如果存在进行提示不能进行删除
                List<SysUser> userList = this.cmsUserService.querySysUserByCondition(sysUser);
                if (userList != null && userList.size() > 0) {
                    json.put("status","1");
                    json.put("msg", "该场馆对应的部门下存在用户,不能进行删除");
                    return json;
                }

    			//场馆下有效的活动数
    			//map.put("activityState", Constant.PUBLISH);
    			//map.put("activityIsDel", Constant.NORMAL);
    			map.put("venueId", venueId);
    			count =  cmsVenueService.queryVenueOfActivityCountByVenueId(map);
    			if(count>0){
    				json.put("status","1");
    				json.put("msg", "该场馆下存在活动，不能删除");
    				return json;
    			}
    			//场馆下的藏品数
    			map.put("antiqueState", Constant.PUBLISH);
    			map.put("antiqueIsDel", Constant.NORMAL);
    			map.put("venueId", venueId);
    			count = cmsAntiqueService.countAntique(map);
    			if(count>0){
    				json.put("status","1");
    				json.put("msg", "该场馆下存在藏品，不能删除");
    				return json;
    			}
    			map.put("bookStatus", Constant.DELETE);
    			map.put("venueId", venueId);
    			count = cmsActivityOrderService.queryCountRoomOrderOfVenue(map);
    			if(count>0){
    				json.put("status","1");
    				json.put("msg", "该场馆下的活动室已被预订，不能删除");
    				return json;
    			}

                if(dept != null){
                    dept.setDeptState(2);
                    int editCount = this.cmsDeptService.editSysDept(dept);
                }
                //删除至回收站
                cmsVenueService.updateStateByVenueIds(venueId, "");

                //更新Redis中场馆首页缓存数据
                Pagination page = new Pagination();
                CmsVenue tempCmsVenue = new CmsVenue();
                tempCmsVenue.setVenueState(Constant.PUBLISH);
                tempCmsVenue.setVenueIsDel(Constant.NORMAL);
                page.setRows(30);
                List<CmsVenue> venueList = cmsVenueService.queryFrontCmsVenueByCondition(tempCmsVenue, page);
                cacheService.updateVenueIndex(Constant.VENUE_INDEX_REDIS_DEFAULT,venueList);
                cacheService.setVenueIndexTotal(Constant.VENUE_INDEX_DEFAULT_TOTAL,page.getTotal());

                json.put("status","2");
                json.put("msg", "该场馆已删除至回收站");
    		}else{
    			json.put("msg", "对象不存在，请刷新后重新选择");
    		}
    	}else{
    		json.put("mgs", "对象不存在，请刷新后重新选择");
    	}
    	return json ;
    }
    
    //获取场馆信息
    @RequestMapping(value = "/getVenue")
    @ResponseBody
    public CmsVenue getVenue(String id) {
        return cmsVenueService.queryVenueById(id);
    }
    
    //跳转到场馆推广
    @RequestMapping(value = "/preExtension")
    public String preExtension(HttpServletRequest request, String venueId) throws Exception {
    	//封装二维码路径生成二维码图片
    	String content = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/wechatStatic/venueActivity.do?venueId="+venueId;
    	String localUrl = basePath.getBasePath()+"venueQRCode/"+venueId+".jpg";
        QRCode.create_image(content, localUrl, 1000);
        //添加logo图片  
        File qrImg = new File(localUrl);
        File logoImg = new File(basePath.getBasePath() + "venueQRCode/logo.png");
        String format = "png";
        EncodeImgZingLogo.writeToFile(qrImg, logoImg, format, qrImg);
        
        String serviceUrl = staticServer.getStaticServerUrl()+"venueQRCode/"+venueId+".jpg";
        request.setAttribute("linkUrl", content);
        request.setAttribute("QRCodeUrl", serviceUrl);
        return "admin/venue/venueExtension";
    }

    @RequestMapping(value = "/previewVenue")
    @ResponseBody
    public ModelAndView preview(String venueName,
    		String venueIconUrl,
    		String venueAddress,
    		Double venueLon,
    		Double venueLat,
    		String venueEndTime,
    		String venueOpenTime,
    		String venueMobile,
    		String venueIsFree,
    		String venuePrice,
    		String venueMemo,
    		String roomTagName
    		){
    	
    	ModelAndView model = new ModelAndView();
    	
    	CmsVenue cmsVenue= new CmsVenue();
    	
    	cmsVenue.setVenueName(venueName);
    	
    	venueIconUrl= staticServer.getStaticServerUrl() +venueIconUrl;
    	
    	cmsVenue.setVenueIconUrl(venueIconUrl);
    	cmsVenue.setVenueAddress(venueAddress);
    	cmsVenue.setVenueLon(venueLon);
    	cmsVenue.setVenueLat(venueLat);
    	cmsVenue.setVenueEndTime(venueEndTime);
    	cmsVenue.setVenueOpenTime(venueOpenTime);
    	cmsVenue.setVenueMobile(venueMobile);
    	cmsVenue.setVenuePrice(venuePrice);
    	cmsVenue.setVenueMemo(venueMemo);
    	
    	cmsVenue.setTagName(roomTagName);
    	
		if(StringUtils.isNotBlank(venueIsFree))
	         if(venueIsFree.equals( "yes")){
	             //2为收费
	        	 cmsVenue.setVenueIsFree(2);
	         }else{
	             //1为免费
	        	 cmsVenue.setVenueIsFree(1);
	         }
    	
    	  model.addObject("cmsVenue", cmsVenue);
          model.setViewName("admin/venue/venue_detail");
          
          return model;
    }
}
