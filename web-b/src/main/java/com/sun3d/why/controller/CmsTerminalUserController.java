package com.sun3d.why.controller;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.fastjson.JSON;
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
import com.sun3d.why.util.DateUtils;
import com.sun3d.why.util.NsExcelReadUtils;
import com.sun3d.why.util.NsExcelReadXUtils;
import com.sun3d.why.util.NsExcelWriteUtils;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.SmsUtil;
import com.sun3d.why.webservice.api.util.HttpClientConnection;
import com.sun3d.why.webservice.api.util.HttpResponseText;
import com.sun3d.why.webservice.api.util.TerminalUserConstant;

import net.sf.json.JSONObject;

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
            List<CmsTerminalUser> userList = terminalUserService.queryTerminalUserbehaviorAnalysis(user,null,null, page);
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
     * 用户行为分析
     * @return
     */
    @RequestMapping(value = "/userbehaviorAnalysisIndex")
    @ResponseBody
    public ModelAndView userbehaviorAnalysisIndex(CmsTerminalUser user,
    		String curDateStart,String curDateEnd,
    		HttpServletRequest request, Pagination page){
    	  ModelAndView model = new ModelAndView();
          try{
        	  
        	  List<Integer> userRegisterCountList =terminalUserService.queryByRegisterDate(curDateStart, curDateEnd);
        	  
        	  model.addObject("userRegisterCountList", userRegisterCountList);
        	  
              List<CmsTerminalUser> userList = terminalUserService.queryTerminalUserbehaviorAnalysis(user,curDateStart, curDateEnd, page);
            
              
              
              Date now=new Date();
              SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMdd");
              
              String strNow=sdf.format(now);
              int dateNowNum=Integer.valueOf(strNow);
              model.addObject("dateNowNum", dateNowNum);
              
              int dateStartDateNum=0;
              
              if(StringUtils.isNotBlank(curDateStart)){
            	  
            	  Date startDate;
	      		  
            	  try {
	      			 startDate = new SimpleDateFormat(DateUtils.DEFAULT_FORMAT).parse(curDateStart);
	      				
	      			  String strStartDate=sdf.format(startDate);
	      			  
	      			  dateStartDateNum=Integer.valueOf(strStartDate);
	      				
	      			} catch (Exception e) {
	      			  
	      			}	
              }
              model.addObject("dateStartDateNum", dateStartDateNum);
             
              
              model.addObject("curDateStart", curDateStart);
              model.addObject("curDateEnd", curDateEnd);
              model.addObject("userList", userList);
              model.addObject("page", page);
              model.addObject("user", user);
              model.setViewName("admin/member/userbehaviorAnalysisIndex");
          }catch (Exception e){
              logger.info("terminalUserIndex error" , e);
          }
          return model;
    }
    
    @RequestMapping(value = "/importUser")
    @ResponseBody   
    public ModelAndView importUser(HttpServletRequest request){
    	
    	 ModelAndView model = new ModelAndView();
    	  
    	 model.setViewName("admin/member/importUser");
    	
    	 return model;
    }
    
    /**
     * 导出用户行为分析
     * @param request
     * @param response
     * @param user
     * @param curDateStart
     * @param curDateEnd
     */
    @RequestMapping(value = "/exportUserAnalysisList")
    public void exportUserAnalysisList(HttpServletRequest request, HttpServletResponse response,CmsTerminalUser user,String curDateStart,String curDateEnd) {
        try {
            
            List<CmsTerminalUser> userList = terminalUserService.queryTerminalUserbehaviorAnalysis(user,curDateStart, curDateEnd, null);
            
            SimpleDateFormat sdf=new SimpleDateFormat("yyyyMMddHHmmss");
            
            SimpleDateFormat sdf1=new SimpleDateFormat("yyyy-MM-dd HH:mm");
            
            String fileName=sdf.format(new Date());
            
            //exportExcel.exportActivityExcel("测试title", "EXPORT_ACTIVITY_STATISTICS_EXCEL", list, out, null);
            
            File file=File.createTempFile(fileName,".xls");
            
            NsExcelWriteUtils writer=new NsExcelWriteUtils(file.getPath());
            
            
            writer.createSheet("导出用户");
            
            String []title=new String[]{"用户名","真实姓名","注册手机号","个人信息手机号","订单使用手机号","积分","注册来源","注册时间"};
            
            writer.createRow(0);
            for (int i = 0; i < title.length; i++) {
            	writer.createCell(i, title[i]);
			}
            
            for (int i = 1; i <= userList.size(); i++) {
				
            	writer.createRow(i);
            	
            	CmsTerminalUser u=userList.get(i-1);
            	
            	writer.createCell(0, u.getUserName());
            	writer.createCell(1, u.getUserNickName());
            	writer.createCell(2, u.getUserMobileNo());
            	writer.createCell(3, u.getUserTelephone());
            	writer.createCell(4, u.getOrderUserTelephone());
            	writer.createCell(5, String.valueOf(u.getIntegralNow()));
            	
            	String soucre="";
            	if(StringUtils.isNotBlank(u.getSysId())){
            		soucre="子平台";
            	}
            	else if(u.getRegisterOrigin()!=null){
            		
            		switch (u.getRegisterOrigin()) {
					case 1:
						soucre="文化云";
						break;
					case 2:
						soucre="QQ";
						break;
					case 3:
						soucre="新浪微博";
						break;
						
					case 4:
						soucre="微信";
						break;

					default:
						soucre="文化云";
						break;
					}
            	}
            	else
            		soucre="文化云";
            	
            	writer.createCell(6, soucre);
            		
            	writer.createCell(7, sdf1.format(u.getCreateTime()));
			}
            
            writer.createExcel();
            
            
            NsExcelWriteUtils.downLoadFileByInputStream(file, fileName+".xls", response);
            
        } catch (IOException e) {
            e.printStackTrace();
        } catch (Exception e) {
			e.printStackTrace();
		}

    }
    
    /**
     * 上传导入用户
     * @param mulFile
     * @param registerOrigin 
     * @param response
     */
    @RequestMapping(value = "/upload")
	public void upload(@RequestParam("file") MultipartFile mulFile,String registerOrigin, HttpServletResponse response) {
		
		JSONObject jsonResult = new JSONObject();

		try {
			
			 SysUser sysUser = (SysUser) session.getAttribute("user");
			 
			 if(sysUser==null)
			 {
				 jsonResult.put("status", 2);
					
				jsonResult.put("errorMessage","请先登录");
				
				response.getWriter().write(jsonResult.toString());
				
				return ;
			 }

			String originalFilename=mulFile.getOriginalFilename();
			
			InputStream is=mulFile.getInputStream();
			
			 List<String> errorList=new ArrayList<String>();
			 
			 Integer ro=null;
			 
			 if(StringUtils.isNoneBlank(registerOrigin))
			 {
				 ro=Integer.valueOf(registerOrigin);
			 }
			
			if(originalFilename.endsWith(".xls"))
			{
				NsExcelReadUtils read=new NsExcelReadUtils(is, 0);
				
				int rowNumber=read.getRowNumber();
				
				List<List<String>> dataList= read.getLists(1, rowNumber, 2);
				
				errorList=terminalUserService.importUser(sysUser, dataList,ro);
			
			}
			else if (originalFilename.endsWith(".xlsx"))
			{
				NsExcelReadXUtils read=new NsExcelReadXUtils(is, 0);
				
				 List<List<String>> dataList= read.getLists(1, 2);
				 
				 errorList=terminalUserService.importUser(sysUser, dataList,ro);
				
			}

			jsonResult.put("status", 1);
			
			jsonResult.put("errorList", errorList);
			
			response.getWriter().write(jsonResult.toString());
			
		} catch (IOException e) {
			jsonResult = new JSONObject();

			jsonResult.put("status", 0);
			
			jsonResult.put("errorMessage", e.getMessage());
			
			try {
				response.getWriter().write(jsonResult.toString());
			} catch (IOException e1) {
				e1.printStackTrace();
			}
		}
		
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
            //同步文化云用户至文化嘉定云
            final CmsTerminalUser finalCmsTerminalUser = user;
            if(StringUtils.isNotBlank(user.getUserHeadImgUrl()) && !user.getUserHeadImgUrl().equals(tuser.getUserHeadImgUrl())){
                finalCmsTerminalUser.setUserHeadImgUrl(staticServer.getStaticServerUrl()+user.getUserHeadImgUrl());
            }
            finalCmsTerminalUser.setSourceCode(tuser.getSourceCode());
            finalCmsTerminalUser.setSysId(tuser.getSysId());
            Runnable runnable = new Runnable() {
                @Override
                public void run() {
                    if(staticServer.isSyncServerState()){
                        finalCmsTerminalUser.setFunctionCode(TerminalUserConstant.UPDATE_USER_INFO);
                        syncCmsTerminalUserService.editTerminalUser(finalCmsTerminalUser);
                    }
                }
            };
            Thread thread=new Thread(runnable);
            thread.start();

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

            //同步文化云用户至文化嘉定云**************************************************start
            CmsTerminalUser tempTerminalUser = terminalUserService.queryTerminalUserById(userId);
            final CmsTerminalUser finalCmsTerminalUser = new CmsTerminalUser();
            finalCmsTerminalUser.setUserId(userId);
            if(tempTerminalUser != null){
                finalCmsTerminalUser.setSourceCode(tempTerminalUser.getSourceCode());
                finalCmsTerminalUser.setSysId(tempTerminalUser.getSysId());
            }
            Runnable runnable = new Runnable() {
                @Override
                public void run() {
                    if(staticServer.isSyncServerState()){
                        finalCmsTerminalUser.setFunctionCode(TerminalUserConstant.UPDATE_USER_FREEZE);
                        syncCmsTerminalUserService.editTerminalUser(finalCmsTerminalUser);
                    }
                }
            };
            Thread thread=new Thread(runnable);
            thread.start();
            //同步文化云用户至文化嘉定云**************************************************end
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

            //同步文化云用户至文化嘉定云**************************************************start
            CmsTerminalUser tempTerminalUser = terminalUserService.queryTerminalUserById(userId);
            final CmsTerminalUser finalCmsTerminalUser = new CmsTerminalUser();
            finalCmsTerminalUser.setUserId(userId);
            if(tempTerminalUser != null){
                finalCmsTerminalUser.setSourceCode(tempTerminalUser.getSourceCode());
                finalCmsTerminalUser.setSysId(tempTerminalUser.getSysId());
            }
            Runnable runnable = new Runnable() {
                @Override
                public void run() {
                    if (staticServer.isSyncServerState()) {
                        finalCmsTerminalUser.setFunctionCode(TerminalUserConstant.UPDATE_USER_ACTIVE);
                        syncCmsTerminalUserService.editTerminalUser(finalCmsTerminalUser);
                    }
                }
            };
            Thread thread=new Thread(runnable);
            thread.start();
            //同步文化云用户至文化嘉定云**************************************************end
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

            //同步文化云用户至文化嘉定云**************************************************start
            CmsTerminalUser tempTerminalUser = terminalUserService.queryTerminalUserById(userId);
            final CmsTerminalUser finalCmsTerminalUser = new CmsTerminalUser();
            finalCmsTerminalUser.setUserId(userId);
            if(tempTerminalUser != null){
                finalCmsTerminalUser.setSourceCode(tempTerminalUser.getSourceCode());
                finalCmsTerminalUser.setSysId(tempTerminalUser.getSysId());
            }
            Runnable runnable = new Runnable() {
                @Override
                public void run() {
                    if (staticServer.isSyncServerState()) {
                        finalCmsTerminalUser.setFunctionCode(TerminalUserConstant.UPDATE_USER_COMMENT_DISABLE);
                        syncCmsTerminalUserService.editTerminalUser(finalCmsTerminalUser);
                    }
                }
            };
            Thread thread=new Thread(runnable);
            thread.start();
            //同步文化云用户至文化嘉定云**************************************************end
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

            //同步文化云用户至文化嘉定云**************************************************start
            CmsTerminalUser tempTerminalUser = terminalUserService.queryTerminalUserById(userId);
            final CmsTerminalUser finalCmsTerminalUser = new CmsTerminalUser();
            finalCmsTerminalUser.setUserId(userId);
            if(tempTerminalUser != null){
                finalCmsTerminalUser.setSourceCode(tempTerminalUser.getSourceCode());
                finalCmsTerminalUser.setSysId(tempTerminalUser.getSysId());
            }
            Runnable runnable = new Runnable() {
                @Override
                public void run() {
                    if (staticServer.isSyncServerState()) {
                        finalCmsTerminalUser.setSourceCode(TerminalUserConstant.SOURCE_CODE_SHANGHAI);
                        finalCmsTerminalUser.setFunctionCode(TerminalUserConstant.UPDATE_USER_COMMENT_ACTIVE);
                        syncCmsTerminalUserService.editTerminalUser(finalCmsTerminalUser);
                    }
                }
            };
            Thread thread=new Thread(runnable);
            thread.start();
            //同步文化云用户至文化嘉定云**************************************************end
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
    			  user.setLastLoginTime(new Date());
    			  terminalUserService.updateTerminalUserById(user);
    			  
    	    			Integer userType= user.getUserType();
    	    			if(userType!=null){

    	    				Map<String, Object> params = new HashMap<>();
    	    			
    	    				//已认证
        	    			if(userType==2)
        	    			{
        	    				
        	    				CmsUserOperatorLog log=CmsUserOperatorLog.createInstance(user.getUserId(),null , null, sysUser.getUserId(), CmsUserOperatorLog.USER_TYPE_ADMIN, UserOperationEnum.AUTH_PASS);
        			        	
        			        	cmsUserOperatorLogService.insert(log);
        			        	
        			        	CmsTerminalUser cmsTerminalUser=terminalUserService.queryTerminalUserById(user.getUserId());
        			        	
        			        	String date =DateUtils.getDateToString(new Date());
        			        	
        			        	params.put("dateTime", date);
        			        	
        			        	SmsUtil.sendTerminalUserAuthPass(cmsTerminalUser.getUserTelephone(), params);
        	    			}
        	    			// 认证不通过
        	    			else if(userType==4)
        	    			{
        	    				
        	    				CmsUserOperatorLog log=CmsUserOperatorLog.createInstance(user.getUserId(),null , null, sysUser.getUserId(), CmsUserOperatorLog.USER_TYPE_ADMIN, UserOperationEnum.AUTH_NOT_PASS);
        			        	
        			        	cmsUserOperatorLogService.insert(log);
        			        	
        			        	CmsTerminalUser cmsTerminalUser=terminalUserService.queryTerminalUserById(user.getUserId());
        			        	
        			        	params.put("reason", text);
        			        	
        			        	SmsUtil.sendTerminalUserAuthNotPass(cmsTerminalUser.getUserTelephone(), params);
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
    public ModelAndView authRefuse(@RequestParam String userId,String roomOrderId,String userIsDisable){
    	
    	  ModelAndView model = new ModelAndView();
    	  
    	  try {
    		  
    	      model.addObject("userId", userId);
    	      
    	      model.addObject("roomOrderId", roomOrderId);
    	      
    	      model.addObject("userIsDisable", userIsDisable);
    	      
    	      model.setViewName("admin/member/authRefuse");
    		  
    	  } catch (Exception e) {
              logger.info("authRefuse error" + e);
          }
    	  return model;
    }
    
    @RequestMapping("/aestomd5")
    public String aestomd5(){
    	  terminalUserService.aestomd5();
    	  return "admin/member/addTerminalUser";
    }
    
}
