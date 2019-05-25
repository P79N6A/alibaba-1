package com.sun3d.why.controller;

import com.sun3d.why.enumeration.UserOperationEnum;
import com.sun3d.why.model.*;
import com.sun3d.why.service.*;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;

/**
 * <p/>
 * 团队会员控制层，负责跟页面数据的交互以及对下层的数据方法的调用
 * <p/>
 * Created by cj on 2015/4/24.
 */
@Controller
@RequestMapping(value = "/teamUser")
public class CmsTeamUserController {

    /**
     * 导入log4j日志管理，记录错误信息
     */
    private Logger logger = Logger.getLogger(CmsTeamUserController.class);
    /**
     * 自动注入团体业务层service实例
     */
    @Autowired
    private CmsTeamUserService cmsTeamUserService;
    /**
     * 自动注入标签关联信息业务层service实例
     */
    @Autowired
    private CmsTagSubRelateService cmsTagRelateService;
    /**
     * 自动注入数据字典业务层service实例
     */
    @Autowired
    private SysDictService sysDictService;

    @Autowired
    private CmsApplyJoinTeamService applyJoinTeamService;

    @Autowired
    private CmsTerminalUserService terminalUserService;
    
    @Autowired
    private CmsTeamUserDetailPicService cmsTeamUserDetailPicService;
    
    @Autowired
    private CmsRoomOrderService roomOrderService;
    
    @Autowired
    private CmsUserOperatorLogService cmsUserOperatorLogService;

    /**
     * 自动注入请求对应的session实例
     */
    @Autowired
    private HttpSession session;

    /**
     * 跳转到团队会员管理的首页面，获取数据查询条件，分页信息，返回分页数据和分页信息
     *
     * @param record CmsTeamUser 团队会员对象，用于获取前台传递的查询参数
     * @param page   Pagination 分页功能对象
     * @return ModelAndView 页面跳转及数据传递
     */
    @RequestMapping(value = "/teamUserIndex")
    public ModelAndView teamUserIndex(CmsTeamUser record, Pagination page, String tuserCounty) {
        //创建一个ModelAndView对象，代表了MVC Web程序中Model与View的对象
        //view代表跳转的页面，model代表传到前台的数据
        ModelAndView model = new ModelAndView();
        List<CmsTeamUser> list = null;
        try {
            //从session中获取用户信息
            SysUser sysUser = (SysUser) session.getAttribute("user");
            //注入查询条件至参数实体中
            record.setTuserCounty(tuserCounty);
            //将设定好的查询条件传入方法中返回符合的CmsTeamUser集合数据
            list = cmsTeamUserService.queryCmsTeamUserByCondition(record, page, sysUser);
        } catch (Exception e) {
            logger.error("加载团体信息列表页时出错", e);
        }
        //设置跳转的页面
        model.setViewName("admin/teamUser/teamUserIndex");
        //将集合数据放入到model中传到前台页面
        model.addObject("list", list);
        //设置前台分页数据的对象，从前台获取再传回前台
        model.addObject("page", page);
        model.addObject("record", record);
        //保证页面查询条件的数据不丢失
        model.addObject("tuserCounty", tuserCounty);
        return model;
    }

    /**
     * 跳转到添加团体用户的页面
     *
     * @return ModelAndView 页面及参数
     * @author cj
     * @date 2015-04-29
     */
    @RequestMapping(value = "/preAddTeamUser")
    public ModelAndView preAddTeamUser() {
        ModelAndView model = new ModelAndView();
        SysUser sysUser = null;
        SysDict dict = null;
        try {
            //从session中获取用户信息
            sysUser = (SysUser) session.getAttribute("user");
            SysDict sysDict = new SysDict();
            sysDict.setDictCode(Constant.TAG_TYPE);
            sysDict.setDictName("团体");
            dict = sysDictService.querySysDict(sysDict);
        } catch (Exception e) {
            logger.error("加载团体添加页面时出错", e);
        }
        model.setViewName("admin/teamUser/addTeamUser");
        model.addObject("dictId", dict.getDictId());
        model.addObject("user", sysUser);
        return model;
    }

    /**
     * 根绝前台传过来的属性添加团队会员信息
     * 返回添加操作的返回值，后续跳转交由前台控制
     *
     * @param record CmsTeamUser 团体会员
     * @param tagIds String 标签ID
     * @return String  操作成功为'success'、操作失败为'failure'
     * @author cj
     * @date 2015-04-28
     */
    @RequestMapping(value = "/addTeamUser")
    @ResponseBody
    public String addTeamUser(CmsTeamUser record, String tagIds) {
        //默认为0，如果后续流程执行出错，则操作失败
        int count = 0;
        SysUser sysUser = null;
        try {
            //从session中获取用户信息
            sysUser = (SysUser) session.getAttribute("user");
            if (sysUser != null) {
                //执行团体信息入库操作
                count = cmsTeamUserService.addCmsTeamUser(record, tagIds, sysUser);
            } else {
                logger.error("当前登录用户不存在，添加操作终止!");
            }
        } catch (Exception e) {
            logger.error("添加团体信息时出错!", e);
        }
        if (count > 0) {
            return Constant.RESULT_STR_SUCCESS;
        } else {
            return Constant.RESULT_STR_FAILURE;
        }
    }

    /**
     * 跳转到修改藏品信息的页面
     *
     * @param tuserId String 团体用户ID
     * @return ModelAndView 页面及参数
     * @author cj
     * @date 2015-04-29
     */
    @RequestMapping(value = "/preEditTeamUser")
    public ModelAndView preEditTeamUser(String tuserId) {
        //准备返回显示视图与数据
        ModelAndView model = new ModelAndView();
        CmsTeamUser cmsTeamUser = null;
        int count = 0;
        try {
            //如果团体用户ID为空，则不可进行编辑
            if (StringUtils.isNotBlank(tuserId)) {
                //根据团体ID查询团体信息
                cmsTeamUser = cmsTeamUserService.queryTeamUserById(tuserId);
                // 该团体成员数量
                CmsApplyJoinTeam applyJoinTeam = new CmsApplyJoinTeam();
                applyJoinTeam.setTuserId(tuserId);
                applyJoinTeam.setApplyCheckState(Constant.APPLY_ALREADY_PASS);
                count = applyJoinTeamService.queryApplyJoinTeamCount(applyJoinTeam);
            } else {
                logger.error("团体用户ID为空，无法加载团体编辑页面!");
            }
        } catch (Exception e) {
            logger.error("加载团体编辑页面时出错!", e);
        }
        model.setViewName("admin/teamUser/editTeamUser");
        model.addObject("teamUser", cmsTeamUser);
        model.addObject("count", count);
        return model;
    }

    /**
     * 根绝前台传过来的属性修改团队会员信息
     * 返回修改操作的返回值，后续跳转交由前台控制
     *
     * @param record CmsTeamUser 团队会员模型
     * @param tagIds String 标签ID
     * @return String  操作成功为'success'、操作失败为'failure'
     * @author cj
     * @date 2015-04-29
     */
    @RequestMapping(value = "/editTeamUser", method = RequestMethod.POST)
    @ResponseBody
    public String editTeamUser(CmsTeamUser record, String tagIds) {
        //默认为0，如果后续流程执行出错，则操作失败
        int count = 0;
        SysUser sysUser = null;
        try {
            sysUser = (SysUser) session.getAttribute("user");
            if (sysUser != null) {
                //执行团体信息表数据更新操作
                count = cmsTeamUserService.editCmsTeamUser(record, tagIds, sysUser);
            } else {
                logger.error("当前登录用户不存在，更新操作终止!");
            }
        } catch (Exception e) {
            logger.error("修改团体信息时出错!", e);
        }
        if (count > 0) {
            return Constant.RESULT_STR_SUCCESS;
        } else {
            return Constant.RESULT_STR_FAILURE;
        }
    }

    /**
     * 冻结团体
     * 返回删除操作的返回值，后续跳转交由前台控制
     *
     * @param tuserId String 团体用户ID
     * @return String  操作成功为'success'、操作失败为'failure'
     * @author cj
     * @date 2015-04-29
     */
    @RequestMapping(value = "/freezeTeamUser")
    @ResponseBody
    public String freezeTeamUser(String tuserId) {
        //默认为0，如果后续流程执行出错，则操作失败
        int count = 0;
        SysUser sysUser = null;
        try {
            sysUser = (SysUser) session.getAttribute("user");
            if (sysUser != null) {
                //根据团体ID查询团体信息
                CmsTeamUser cmsTeamUser = cmsTeamUserService.queryTeamUserById(tuserId);
                cmsTeamUser.setTuserIsActiviey(Constant.DELETE);
                //执行团体信息表数据更新操作
                count = cmsTeamUserService.deleteCmsTeamUser(cmsTeamUser, sysUser);
            } else {
                logger.error("当前登录用户不存在，逻辑删除操作终止!");
            }
        } catch (Exception e) {
            logger.error("逻辑删除团体信息时出错!", e);
        }
        if (count > 0) {
            return Constant.RESULT_STR_SUCCESS;
        } else {
            return Constant.RESULT_STR_FAILURE;
        }
    }

    /**
     * 激活团体
     * 返回删除操作的返回值，后续跳转交由前台控制
     *
     * @param tuserId String 团体用户ID
     * @return String  操作成功为'success'、操作失败为'failure'
     * @author cj
     * @date 2015-04-29
     */
    @RequestMapping(value = "/activeTeamUser")
    @ResponseBody
    public String activeTeamUser(String tuserId) {
        int count = 0;
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if (sysUser != null) {
                //根据团体ID查询团体信息
                CmsTeamUser cmsTeamUser = cmsTeamUserService.queryTeamUserById(tuserId);
                cmsTeamUser.setTuserIsActiviey(Constant.NORMAL);
                //执行团体信息表数据更新操作
                count = cmsTeamUserService.deleteCmsTeamUser(cmsTeamUser, sysUser);
            } else {
                logger.error("当前登录用户不存在，逻辑删除操作终止!");
            }
        } catch (Exception e) {
            logger.error("逻辑删除团体信息时出错!", e);
        }
        if (count > 0) {
            return Constant.RESULT_STR_SUCCESS;
        } else {
            return Constant.RESULT_STR_FAILURE;
        }
    }

    /**
     * 团体查看详情
     * @param tuserId
     * @return
     */
    @RequestMapping(value = "/viewTeamUser")
    public ModelAndView viewTeamUser(String tuserId){
        ModelAndView model = new ModelAndView();
        CmsTeamUser cmsTeamUser = null;
        CmsTerminalUser user = null;
        SysDict dict = null;
        try {
            //如果团体用户ID为空，则不可进行编辑
            if (StringUtils.isNotBlank(tuserId)) {
                //根据团体ID查询团体信息
//                cmsTeamUser = cmsTeamUserService.queryTeamUserById(tuserId);
//                if(StringUtils.isNotBlank(cmsTeamUser.getUserId())) {
//                    user = terminalUserService.queryTerminalUserById(cmsTeamUser.getUserId());
//                }
//                if(StringUtils.isNotBlank(cmsTeamUser.getTuserTeamType())){
//                    dict = sysDictService.querySysDictByDictId(cmsTeamUser.getTuserTeamType());
//                }
            	
            	  CmsTeamUser teamUser=cmsTeamUserService.queryTeamUserById(tuserId);
        		  
        		  List<CmsTeamUserDetailPic>  teamUserDetailPics=cmsTeamUserDetailPicService.queryCmsTeamUserDetailByTuserId(tuserId);
      	    		
        		 CmsUserOperatorLog modelLog=new CmsUserOperatorLog();
              	
              	modelLog.setTuserId(teamUser.getTuserId());
              	
              	List<CmsUserOperatorLog> logList=cmsUserOperatorLogService.queryCmsUserOperatorLogByModel(modelLog);
              	  
              	model.addObject("logList", logList);
        		  
        		  model.addObject("teamUser", teamUser);
        		  
        	      model.addObject("teamUserDetailPics", teamUserDetailPics);
        	      
        	      model.setViewName("admin/teamUser/viewTeamUser");
            	
            } else {
                logger.error("团体用户ID为空，无法加载团体详情页面!");
            }
        } catch (Exception e) {
            logger.error("加载团体详情页面时出错!", e);
        }
     //   model.setViewName("admin/teamUser/viewTeamUser");
     // model.addObject("record", cmsTeamUser);
     //   model.addObject("user", user == null ? new CmsTerminalUser() : user);
     //   model.addObject("dict", dict);
        return model;
    }

    /**
     * 获取当前数据中已经存在的区县信息
     *
     * @param teamUser
     * @return
     */
    @RequestMapping(value = "/getExistArea", method = RequestMethod.POST)
    @ResponseBody
    public List<String> getExistArea(CmsTeamUser teamUser) {
        List<String> areaList = null;
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            //将设定好的查询条件传入方法中返回符合的CmsTeamUser集合数据
            List<CmsTeamUser> list = cmsTeamUserService.queryCmsTeamUserByCondition(teamUser, null, sysUser);

            areaList = new ArrayList<String>();
            if (list != null && list.size() > 0) {
                for (CmsTeamUser cmsTeamUser : list) {
                    if (!areaList.contains(cmsTeamUser.getTuserCounty())) {
                        areaList.add(cmsTeamUser.getTuserCounty());
                    }
                }
            }
        } catch (Exception e) {
            logger.error("查询系统中所有团体所在区域信息时出错", e);
        }
        return areaList;
    }
    
    @RequestMapping("/authTeamUserInfo")
    @ResponseBody
    public ModelAndView authTeamUserInfo(@RequestParam String tuserId,String roomOrderId,String tuserIsActiviey,String userId){
    	
    	  ModelAndView model = new ModelAndView();
    	  
    	  try {
    		  
    		  CmsTeamUser teamUser=cmsTeamUserService.queryTeamUserById(tuserId);
    		  
    		  List<CmsTeamUserDetailPic>  teamUserDetailPics=cmsTeamUserDetailPicService.queryCmsTeamUserDetailByTuserId(tuserId);
  	    		
    		 CmsUserOperatorLog modelLog=new CmsUserOperatorLog();
          	
          	modelLog.setTuserId(teamUser.getTuserId());
          	
          	List<CmsUserOperatorLog> logList=cmsUserOperatorLogService.queryCmsUserOperatorLogByModel(modelLog);
          	  
          	model.addObject("logList", logList);
    		  
    		  model.addObject("teamUser", teamUser);
    	      
    	      model.addObject("roomOrderId", roomOrderId);
    	      
    	      model.addObject("teamUserDetailPics", teamUserDetailPics);
    	      
    	      model.addObject("userId", userId);
    	      model.addObject("tuserIsActiviey", tuserIsActiviey);
    	      
    	      model.setViewName("admin/teamUser/authTeamUserInfo");
    		  
    	  } catch (Exception e) {
              logger.info("auth error" + e);
          }
    	  return model;
    }
    
    @RequestMapping("/editTeamUserInfo")
    @ResponseBody
    public ModelAndView editTeamUserInfo(@RequestParam String tuserId,String userId){
    	
    	  ModelAndView model = new ModelAndView();
    	  
    	  try {
    		  
    		  CmsTeamUser teamUser=cmsTeamUserService.queryTeamUserById(tuserId);
    		  
    		  List<CmsTeamUserDetailPic>  teamUserDetailPics=cmsTeamUserDetailPicService.queryCmsTeamUserDetailByTuserId(tuserId);
  	    		
    		 CmsUserOperatorLog modelLog=new CmsUserOperatorLog();
          	
          	modelLog.setTuserId(teamUser.getTuserId());
          	
          	List<CmsUserOperatorLog> logList=cmsUserOperatorLogService.queryCmsUserOperatorLogByModel(modelLog);
          	  
          	model.addObject("logList", logList);
    		  
    		  model.addObject("teamUser", teamUser);
    		  
    		  model.addObject("userId", userId);
    	      
    	      model.addObject("teamUserDetailPics", teamUserDetailPics);
    	      
    	      model.setViewName("admin/teamUser/editTeamUserInfo");
    		  
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
    public int authDo( CmsTeamUser teamUser,String roomOrderId,String text){
    	
    	int result=0;
    	
    	  try {  
    		  
    		  SysUser sysUser = (SysUser) session.getAttribute("user");
    		  
    		  String userId=teamUser.getUserId();
    		  
    		  if(StringUtils.isBlank(userId))
    		  {
    			  CmsTeamUser tuser=cmsTeamUserService.queryTeamUserById(teamUser.getTuserId());
    			  
    			  userId=tuser.getUserId();
    			  
    			  teamUser.setUserId(userId);
    		  }    		  
    		 result= cmsTeamUserService.editCmsTeamUser(teamUser, null, sysUser);
    		 
    		 if(result>0&&StringUtils.isNotBlank(roomOrderId)){
    			 
    			 CmsRoomOrder roomOrder=roomOrderService.queryCmsRoomOrderById(roomOrderId);
    			 
    			 if(roomOrder.getTuserId()!=null&&roomOrder.getTuserId().equals(teamUser.getTuserId()))
    			 {
    				 roomOrder.setTuserName(teamUser.getTuserName());
    				 
    				 roomOrderService.editCmsRoomOrder(roomOrder);
    			 }	 
    		 }
    		 
    		 if(result>0)
    		 {
    			 Integer tuserIsDisplay=teamUser.getTuserIsDisplay();
    			 
    			 if(tuserIsDisplay==null)
    			 {
    				 CmsUserOperatorLog log=CmsUserOperatorLog.createInstance(null, null, teamUser.getTuserId(), sysUser.getUserId(), CmsUserOperatorLog.USER_TYPE_ADMIN, UserOperationEnum.EDIT_INFO);
  		        	
  		        	cmsUserOperatorLogService.insert(log);
    			 }
    			 
    			 // 认证通过
    			 else if(tuserIsDisplay==1)
    			 {
    				 CmsUserOperatorLog log=CmsUserOperatorLog.createInstance(null, null, teamUser.getTuserId(), sysUser.getUserId(), CmsUserOperatorLog.USER_TYPE_ADMIN, UserOperationEnum.AUTH_PASS);
 		        	
 		        	cmsUserOperatorLogService.insert(log);
    			 }
    			 
    			 // 认证不通过
    			 else if(tuserIsDisplay==3)
    			 {
    				 CmsUserOperatorLog log=CmsUserOperatorLog.createInstance(null, null, teamUser.getTuserId(), sysUser.getUserId(), CmsUserOperatorLog.USER_TYPE_ADMIN, UserOperationEnum.AUTH_NOT_PASS);
  		        	
  		        	cmsUserOperatorLogService.insert(log);
    			 }
    			
    		 }
    		  
    	  } catch (Exception e) {
              logger.info("authDo error" + e);
              
              result=-1;
          }
    	return result;
    }
    
    @RequestMapping("/authRefuse")
    public ModelAndView authRefuse(@RequestParam String tuserId,String roomOrderId,String applyId,
    		String userId,String tuserIsActiviey){
    	
    	  ModelAndView model = new ModelAndView();
    	  
    	  try {
    		  
    	      model.addObject("tuserId", tuserId);
    	      model.addObject("roomOrderId", roomOrderId);
    	      model.addObject("applyId", applyId);
    	      model.addObject("userId", userId);
    	      model.addObject("tuserIsActiviey", tuserIsActiviey);
    	      
    	      model.setViewName("admin/teamUser/authRefuse");
    		  
    	  } catch (Exception e) {
              logger.info("authRefuse error" + e);
          }
    	  return model;
    }
}