package com.sun3d.why.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

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

import com.sun3d.why.enumeration.UserOperationEnum;
import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.CmsApplyJoinTeam;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.CmsUserOperatorLog;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CmsApplyJoinTeamService;
import com.sun3d.why.service.CmsOrderService;
import com.sun3d.why.service.CmsTerminalUserService;
import com.sun3d.why.service.CmsUserOperatorLogService;
import com.sun3d.why.service.SyncCmsTerminalUserService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.SmsUtil;
import com.sun3d.why.webservice.api.util.TerminalUserConstant;

@Controller
@RequestMapping("/terminalUser")
public class CmsTerminalUserController {
    private Logger logger = LoggerFactory.getLogger(CmsTerminalUserController.class);

    @Autowired
    private CmsTerminalUserService terminalUserService;

    @Autowired
    private CmsApplyJoinTeamService applyJoinTeamService;

    @Autowired
    private CmsOrderService cmsOrderService;

    @Autowired
    private HttpSession session;

    @Autowired
    private StaticServer staticServer;

    @Autowired
    private SyncCmsTerminalUserService syncCmsTerminalUserService;
    @Autowired
    private CmsUserOperatorLogService cmsUserOperatorLogService;
    @Autowired
	private SmsUtil SmsUtil;
    /**
     * 点击新建会员按钮跳转页面
     *
     * @return
     */
   @RequestMapping(value = "/preAddTerminalUser")
    public String toAdd(HttpServletRequest request) {
       SysUser sysUser = (SysUser) session.getAttribute("user");
       request.setAttribute("user", sysUser);
       return "admin/member/addTerminalUser";
    }

    /**
     * 后台会员列表页
     * @param user 会员对象
     * @param page 分页对象
     * @return
     */
    @RequestMapping("/terminalUserIndex")
    public ModelAndView terminalUserIndex(CmsTerminalUser user, Pagination page) {
        ModelAndView model = new ModelAndView();
        try{
            List<CmsTerminalUser> userList = terminalUserService.queryTerminalUserByCondition(user, page);
            model.addObject("userList", userList);
            model.addObject("page", page);
            model.addObject("user", user);
            model.setViewName("admin/member/terminalUserIndex");
        }catch (Exception e){
            logger.info("terminalUserIndex error" , e);
        }
        return model;
    }

    /**
     * 获取当前数据中已经存在的区县信息
     * @return
     */
    @RequestMapping(value = "/queryExistTerminalUserArea", method = RequestMethod.POST)
    @ResponseBody
    public List<String> queryExistTerminalUserArea(){
        List<String> areaList = null;
        try {
            CmsTerminalUser record = new CmsTerminalUser();
            record.setUserIsDisable(Constant.NORMAL);
            //将设定好的查询条件传入方法中返回符合的CmsTeamUser集合数据
            List<CmsTerminalUser> list = terminalUserService.queryTerminalUserByCondition(record, null);

            areaList = new ArrayList<String>();
            if(list != null && list.size() > 0){
                for (CmsTerminalUser terminalUser:list){
                    if(StringUtils.isNotBlank(terminalUser.getUserArea())){
                        if(!areaList.contains(terminalUser.getUserArea())){
                            areaList.add(terminalUser.getUserArea());
                        }
                    }
                }
            }
        } catch (Exception e) {
            logger.error("查询系统中所有会员所在区域信息时出错", e);
        }
        return areaList;
    }

    @RequestMapping(value = "/addTerminalUser", method = RequestMethod.POST)
    @ResponseBody
    public String addTerminalUser(CmsTerminalUser user){
        try{
            return terminalUserService.addTerminalUser(user);
        }catch (Exception e){
            return Constant.RESULT_STR_FAILURE;
        }
    }

    /**
     * 根据id查看会员信息
     *
     */
    @RequestMapping(value = "/viewTerminalUser", method = RequestMethod.GET)
    public String viewTerminalUser(@RequestParam("userId") String userId, HttpServletRequest request) {
        try{
            if (StringUtils.isNotBlank(userId)) {
                CmsTerminalUser terminalUser = terminalUserService.queryTerminalUserById(userId);
                request.setAttribute("terminalUser", terminalUser);
            }
        }catch (Exception e){
            logger.info("viewTerminalUser error", e);
        }
        return "admin/member/viewTerminalUser";
    }
    /**
     * 根据id编辑会员信息
     *
     */
    @RequestMapping(value = "/preEditTerminalUser", method = RequestMethod.GET)
    public String terminalUseEdit(@RequestParam( "userId" ) String userId,  HttpServletRequest request) {
        logger.debug("进入会员编辑页,userId=" + userId);
        if (StringUtils.isNotBlank(userId)) {
            CmsTerminalUser terminalUser = terminalUserService.queryTerminalUserById(userId);
            SysUser sysUser = (SysUser) session.getAttribute("user");
            request.setAttribute("user", sysUser);
            request.setAttribute("terminalUser", terminalUser);
        }
        return "admin/member/editTerminalUser";
    }

    /**
     * 编辑会员
     * @param user
     * @return
     */
    @RequestMapping(value = "/editTerminalUser", method = RequestMethod.POST)
    @ResponseBody
    public String editTerminalUser(CmsTerminalUser user) {
        try{

            CmsTerminalUser tuser = terminalUserService.queryTerminalUserById(user.getUserId());
            return terminalUserService.editTerminalUserById(user);
        }catch (Exception e){
            return Constant.RESULT_STR_FAILURE;
        }
    }

    /**
     * 冻结
     * @param userId
     * @return
     */
    @RequestMapping(value = "/freezeTerminalUser",  method = RequestMethod.POST)
    @ResponseBody
    public String freezeTerminalUser(@RequestParam("userId") String userId) {
        try{
            terminalUserService.editTerminalUserDisableById(userId, Constant.USER_IS_FREEZE);

            return Constant.RESULT_STR_SUCCESS;
        }catch (Exception e){
            logger.info("freezeTerminalUser error" + e);
            return Constant.RESULT_STR_FAILURE;
        }
    }

    /**
     *  激活
     * @param userId
     * @return
     */
    @RequestMapping(value = "/activeTerminalUser",  method = RequestMethod.POST)
    @ResponseBody
    public String activeTerminalUser(String userId) {
        try{
            terminalUserService.editTerminalUserDisableById(userId, Constant.USER_IS_ACTIVATE);

            return Constant.RESULT_STR_SUCCESS;
        }catch (Exception e){
            logger.info("activeTerminalUser error" + e);
            return Constant.RESULT_STR_FAILURE;
        }
    }

    /**
     *  禁止评论
     * @param userId
     * @return
     */
    @RequestMapping(value = "/disableTerminalUserComment",  method = RequestMethod.POST)
    @ResponseBody
    public String disableTerminalUserComment(String userId) {
        try{
            terminalUserService.disableTerminalUserComment(userId, Constant.DISABLE_TERMINAL_USER_COMMENT);

            return Constant.RESULT_STR_SUCCESS;
        }catch (Exception e){
            logger.info("disableTerminalUserComment error" + e);
            return Constant.RESULT_STR_FAILURE;
        }
    }

    /**
     *  取消禁止评论
     * @param userId
     * @return
     */
    @RequestMapping(value = "/cancelTerminalUserComment",  method = RequestMethod.POST)
    @ResponseBody
    public String cancelTerminalUserComment(String userId) {
        try{
            terminalUserService.disableTerminalUserComment(userId, Constant.NO_DISABLE_TERMINAL_USER_COMMENT);

            return Constant.RESULT_STR_SUCCESS;
        }catch (Exception e){
            logger.info("cancelTerminalUserComment error" + e);
            return Constant.RESULT_STR_FAILURE;
        }
    }

    /**
     * 后端2.0某个团体下的成员列表
     * @param applyJoinTeam
     * @param userName
     * @param page
     * @return
     */
    @RequestMapping(value = "/teamTerminalUserIndex")
    public ModelAndView queryTerminalUserByTuserId(CmsApplyJoinTeam applyJoinTeam,String userName, Pagination page) {
        //准备返回显示视图与数据
        ModelAndView model = new ModelAndView();
        try{
            List<CmsTerminalUser> terminalUserList = terminalUserService.queryTeamTerminalUserByTuserId(applyJoinTeam,userName, page);
            model.addObject("terminalUserList", terminalUserList);
            model.addObject("userName", userName);
            model.addObject("applyJoinTeam", applyJoinTeam);
            model.addObject("page", page);
        }catch (Exception e){
            logger.info("teamTerminalUserIndex error", e);
        }
        model.setViewName("admin/member/teamTerminalUserIndex");
        return model;
    }

    /**
     * 根据id编辑会员信息
     *
     */
    @RequestMapping(value = "/viewTeamTerminalUser", method = RequestMethod.GET)
    public String queryTeamTerminalUser(String applyId,HttpServletRequest request) {
        CmsTerminalUser terminalUser = terminalUserService.queryTeamTerminalUserByApplyId(applyId);
        request.setAttribute("terminalUser", terminalUser);
        return "admin/member/viewTeamTerminalUser";
    }


    /**
     * 根据团体所属站点得到管理员
     * @param user
     * @return
     */
    @RequestMapping(value = "/getTerminalUserByArea", method = RequestMethod.POST)
    @ResponseBody
    public List<CmsTerminalUser> getTerminalUserByArea(CmsTerminalUser user) {
        List<CmsTerminalUser> terminalUserList = null;
        try{
            terminalUserList = terminalUserService.queryTerminalUserByArea(user);
        }catch (Exception e){
            logger.info("getTerminalUserByArea error", e);
        }
        return terminalUserList;
    }

    /**
     * 后端2.0团体动态改变姓名、日期和电话号码
     * @param userId
     * @return
     */
    @RequestMapping(value = "/getTerminalUserByUserId", method = RequestMethod.POST)
    @ResponseBody
    public CmsTerminalUser getTerminalUserByUserId(String userId) {
        CmsTerminalUser terminalUser  = null;
        try{
            terminalUser = terminalUserService.queryTerminalUserById(userId);
        }catch (Exception e){
            logger.info("getTerminalUserByUserId error", e);
        }
        return terminalUser;
    }

    /**
     * 后端2.0团体动态改变姓名、日期和电话号码
     * @param userId
     * @return
     */
    @RequestMapping(value = "/queryManagerCount", method = RequestMethod.POST)
    @ResponseBody
    public int queryManagerCount(String userId) {
        CmsApplyJoinTeam applyJoinTeam = new CmsApplyJoinTeam();
        applyJoinTeam.setApplyCheckState(Constant.APPLY_ALREADY_PASS);
        applyJoinTeam.setApplyIsState(1);
        if(StringUtils.isNotBlank(userId)){
            applyJoinTeam.setUserId(userId);
        }
        return applyJoinTeamService.queryApplyJoinTeamCount(applyJoinTeam);
    }

    /**
     * 用户所订的所有订单
     * @param activity
     * @param page
     * @return
     */
    @RequestMapping("/terminalUserOrderIndex")
    public ModelAndView orderList(CmsActivity activity, Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
            SysUser user = (SysUser) session.getAttribute("user");
            if (user != null) {
                List<CmsActivity> activityList = cmsOrderService.queryCmsOrderByCondition(activity, page, user);
                model.addObject("activityList", activityList);
                model.addObject("activity", activity);
                model.addObject("page", page);
                model.setViewName("admin/member/terminalUserOrderIndex");
            }
        } catch (Exception e) {
            logger.info("orderList error" + e);
        }
        return model;
    }
    
    @RequestMapping("/authInfo")
    @ResponseBody
    public ModelAndView authInfo(@RequestParam String userId,String roomOrderId,String userIsDisable){
    	
    	  ModelAndView model = new ModelAndView();
    	  
    	  try {
    		  
    		  CmsTerminalUser terminalUser = terminalUserService.queryTerminalUserById(userId);
    		  
    		  CmsUserOperatorLog modelLog=new CmsUserOperatorLog();
    	          	
    	      modelLog.setUserId(terminalUser.getUserId());
    	          	
    	      List<CmsUserOperatorLog> logList=cmsUserOperatorLogService.queryCmsUserOperatorLogByModel(modelLog);
    		  
    	      model.addObject("logList", logList);
    	      
    	      model.addObject("user", terminalUser);
    	      
    	      model.addObject("roomOrderId", roomOrderId);
    	      
    	      model.addObject("userIsDisable", userIsDisable);
    	      
    	      model.setViewName("admin/member/authInfo");
    		  
    	  } catch (Exception e) {
              logger.info("auth error" + e);
          }
    	  return model;
    }
    
    
    
    /**
     * @param user
     * @return
     */
    @RequestMapping("/authDo")
    @ResponseBody
    public int authDo(CmsTerminalUser user,String text){
    	
    	int result=0;
    	
    	  try {  
    		  
    		  SysUser sysUser = (SysUser) session.getAttribute("user");
    		  
    		  if(sysUser != null&&StringUtils.isNotBlank(sysUser.getUserId()))
    		  {
    			  result= terminalUserService.updateTerminalUserById(user);
    	    		 
    	    		 if(result>0)
    	    		 {
    	    			Integer userType= user.getUserType();
    	    			
    	    			//已认证
    	    			if(userType==2)
    	    			{
    	    				CmsUserOperatorLog log=CmsUserOperatorLog.createInstance(user.getUserId(),null , null, sysUser.getUserId(), CmsUserOperatorLog.USER_TYPE_ADMIN, UserOperationEnum.AUTH_PASS);
    			        	
    			        	cmsUserOperatorLogService.insert(log);
    			        	
    			        	CmsTerminalUser terminalUser=terminalUserService.queryTerminalUserById(user.getUserId());
    			        	
    			        	String userTelephone=terminalUser.getUserTelephone();
    			        	String userMobileNo=terminalUser.getUserMobileNo();
    			        	
    			        	Map<String,Object> map = new HashMap<String, Object>();
    		                map.put("userName",terminalUser.getUserNickName());
    		                    
    		                SmsUtil.passRealName(StringUtils.isNotBlank(userTelephone)?userTelephone:userMobileNo, map);
    	    			}
    	    			// 认证不通过
    	    			else if(userType==4)
    	    			{
    	    				CmsUserOperatorLog log=CmsUserOperatorLog.createInstance(user.getUserId(),null , null, sysUser.getUserId(), CmsUserOperatorLog.USER_TYPE_ADMIN, UserOperationEnum.AUTH_NOT_PASS);
    			        	
    			        	cmsUserOperatorLogService.insert(log);
    	    			}
    	    		 }
    		  }
    		  
    		 
    		 
    	  } catch (Exception e) {
              logger.info("authDo error" + e);
              
              result=-1;
          }
    	return result;
    }
    
    @RequestMapping("/authRefuse")
    public ModelAndView authRefuse(@RequestParam String userId,String roomOrderId){
    	
    	  ModelAndView model = new ModelAndView();
    	  
    	  try {
    		  
    	      model.addObject("userId", userId);
    	      
    	      model.addObject("roomOrderId", roomOrderId);
    	      
    	      model.setViewName("admin/member/authRefuse");
    		  
    	  } catch (Exception e) {
              logger.info("authRefuse error" + e);
          }
    	  return model;
    }
}
