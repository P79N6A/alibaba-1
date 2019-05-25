package com.sun3d.why.controller.train;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sun3d.why.controller.CmsActivityController;
import com.sun3d.why.model.ActivityStatistics;
import com.sun3d.why.model.CmsVenue;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.peopleTrain.Course;
import com.sun3d.why.model.peopleTrain.CourseOrder;
import com.sun3d.why.model.peopleTrain.TrainTerminalUser;
import com.sun3d.why.service.CourseOrderService;
import com.sun3d.why.service.CourseService;
import com.sun3d.why.service.PeopleTrainService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.ExportExcel;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;

@RequestMapping("/peopleTrain")
@Controller
public class PeopleTrainController {
    private Logger logger = LoggerFactory.getLogger(CmsActivityController.class);
    @Autowired
    private HttpSession session;
    @Autowired
    private PeopleTrainService peopleTrainService;
    @Autowired
    private CourseService courseService;
    @Autowired
    private CourseOrderService  courseOrderService;
    @Autowired
    private ExportExcel exportExcel;
    /**
     * 报名列表
     *
     * @param activity
     * @param page
     * @return
     */
    @RequestMapping("/applyList")
    public ModelAndView activityIndex(String searchKey, CourseOrder courseOrder, Pagination page) {
        ModelAndView model = new ModelAndView();
        try {
            SysUser sysUser = (SysUser) session.getAttribute("user");
            if(sysUser==null){
            	model.setViewName("redirect:/admin.do");
            	return model;
            }
            List<CourseOrder> courseOrderList = courseOrderService.queryCourseOrderByCondition(searchKey,courseOrder, page, sysUser);
            model.addObject("list", courseOrderList);
            model.addObject("page", page);
            model.addObject("courseOrder", courseOrder);
            model.addObject("searchKey", searchKey);
            model.setViewName("admin/peopleTrain/applyList");
        } catch (Exception e) {
            logger.error("applyList error {}", e);
        }
        return model;
    }
    /**
     * 万人培训用户导出
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/exportTrainTerminalExcel")
    public void exportTrainTerminalExcel(HttpServletRequest request, HttpServletResponse response,String searchKey) {
        try {
            response.setContentType("application/vnd.ms-excel;charset=utf-8");
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Content-Disposition", "attachment;filename=" + "Info.xls");
            ServletOutputStream out = response.getOutputStream();
            SysUser sysUser = (SysUser) session.getAttribute("user");
            List<CourseOrder> courseOrderList=courseOrderService.queryCourseOrderExport(sysUser,searchKey);
            exportExcel.TrainTerminalExcel("报名列表", "EXPORT_TRAINTERMINAL_EXCEL", courseOrderList, out, null);
        } catch (IOException e) {
            e.printStackTrace();
        }

    }
    /**
     * 对应课程用户导出
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/exportByCourseIdExcel")
    public void exportByCourseIdExcel(String courseId, HttpServletRequest request, HttpServletResponse response,String searchKey) {
    	try {
    		response.setContentType("application/vnd.ms-excel;charset=utf-8");
    		response.setCharacterEncoding("UTF-8");
    		response.setHeader("Content-Disposition", "attachment;filename=" + "Info.xls");
    		ServletOutputStream out = response.getOutputStream();
    		SysUser sysUser = (SysUser) session.getAttribute("user");
    		List<CourseOrder> courseOrderList=courseOrderService.queryExportByCourseIdExcel(courseId,sysUser,searchKey);
    		exportExcel.TrainTerminalExcel("报名列表", "EXPORT_TRAINTERMINAL_EXCEL", courseOrderList, out, null);
    	} catch (IOException e) {
    		e.printStackTrace();
    	}
    	
    }

    /**
     * 查看用户报名详情列表
     * @param request
     * @param response
     * @return
     */
        @RequestMapping(value = "/userDetails")
        @ResponseBody
    public TrainTerminalUser userDetails(String searchKey) {
        	TrainTerminalUser trainTerminalUser = new  TrainTerminalUser();
             try {
                 SysUser sysUser = (SysUser) session.getAttribute("user");
                  trainTerminalUser = peopleTrainService.queryPeopleTrainById(searchKey);
             } catch (Exception e) {
                 logger.error("userDetailsIndex error {}", e);
             }
             return trainTerminalUser;
    }

        /**
         * 课程列表
         * @param request
         * @param response
         * @return
         */
        @RequestMapping(value = "/courseList")
        public ModelAndView courseList(String pages,String courseType, String courseField,String searchKey, Course course, Pagination page) {
            ModelAndView model = new ModelAndView();
            try {
                SysUser sysUser = (SysUser) session.getAttribute("user");
                if(sysUser==null){
                	model.setViewName("redirect:/admin.do");
                	return model;
                }
                if(StringUtils.isNotBlank(pages)){
                	page.setPage(Integer.valueOf(pages));
                	}
                List<Course> courseList = courseService.queryCourseByCondition(courseType,courseField,searchKey,course, page, sysUser);

                model.addObject("list", courseList);
                model.addObject("courseType", courseType);
                model.addObject("courseField", courseField);
                model.addObject("searchKey", searchKey);
                model.addObject("page", page);
                model.addObject("course", course);
                model.setViewName("admin/peopleTrain/courseList");
            } catch (Exception e) {
                logger.error("applyList error {}", e);
            }
            return model;
        }
        /**
         * 添加课程列表
         * @author weixianchao
         */
        @RequestMapping(value = "/addCourse")
        public ModelAndView addCourse(){
        	   ModelAndView model = new ModelAndView();
        	     model.setViewName("admin/peopleTrain/addCourse");
        	     return model;
        }
        /**
         * 保存课程
         * @author weixianchao
         */
        @RequestMapping(value = "/saveCourse")
        @ResponseBody
        public String saveCourse(Course course){
        	   //默认为0，如果后续流程执行出错，则操作失败
            int count = 0;
            try {
                //从session中获取用户信息
                SysUser sysUser = (SysUser) session.getAttribute("user");
                if(sysUser != null){

                    count = courseService.saveCourse(course,sysUser);

                }else{
                    logger.error("当前登录用户不存在或没有登录，添加操作终止!");
                }
                
            } catch (Exception e) {
                logger.error("添加课程信息时出错!", e);
            }
            if(count>0){
                return Constant.RESULT_STR_SUCCESS;
            }else {
                return Constant.RESULT_STR_FAILURE;
            }
        }
        /**
         * 课程上架和下架
         * @author weixianchao
         */
       @RequestMapping(value = "/editState")
        @ResponseBody
        public String editState(String courseId, String state){
        	Course	course = new Course();
        	course = courseService.queryCourseByCourseId(courseId);
        	//默认为0，如果后续流程执行出错，则操作失败
        	int count = 0;
        	try {
        		//从session中获取用户信息
        		SysUser sysUser = (SysUser) session.getAttribute("user");
        		if(sysUser != null){
        			
        			count = courseService.editState(course,state,null);
        			
        		}else{
        			logger.error("当前登录用户不存在或没有登录，添加操作终止!");
        		}
        	} catch (Exception e) {
        		logger.error("更新课程信息时出错!", e);
        	}
        	if(count>0){
        		return Constant.RESULT_STR_SUCCESS;
        	}else {
        		return Constant.RESULT_STR_FAILURE;
        	}
        }
       
       /**
        * 课程上架和下架
        * @author weixianchao
        */
      @RequestMapping(value = "/check")
       @ResponseBody
       public String check(String courseId, String checkState){
       	Course	course = new Course();
       	course = courseService.queryCourseByCourseId(courseId);
       	//默认为0，如果后续流程执行出错，则操作失败
       	int count = 0;
       	try {
       		//从session中获取用户信息
       		SysUser sysUser = (SysUser) session.getAttribute("user");
       		if(sysUser != null){
       			
       			count = courseService.editState(course,null,checkState);
       			
       		}else{
       			logger.error("当前登录用户不存在或没有登录，添加操作终止!");
       		}
       	} catch (Exception e) {
       		logger.error("更新课程信息时出错!", e);
       	}
       	if(count>0){
       		return Constant.RESULT_STR_SUCCESS;
       	}else {
       		return Constant.RESULT_STR_FAILURE;
       	}
       }
       /**
        *课程查看
        * @author weixianchao
        */
       @RequestMapping(value = "/courseView")
       @ResponseBody
       public ModelAndView courseView(String courseId,String searchKey, CourseOrder courseOrder, Pagination page,HttpServletRequest request){
    	   ModelAndView model = new ModelAndView();
    	   try {
               SysUser sysUser = (SysUser) session.getAttribute("user");
               if(sysUser==null){
               	model.setViewName("redirect:/admin.do");
               	return model;
               }
               String status = request.getParameter("status");
               List<CourseOrder> courseOrderList = courseOrderService.queryCourseViewByCondition(courseId, page,sysUser,searchKey,status);
               model.addObject("status", status);
               model.addObject("list", courseOrderList);
               model.addObject("page", page);
               model.addObject("courseId", courseId);
               model.addObject("searchKey", searchKey);
               model.setViewName("admin/peopleTrain/courseView");
           } catch (Exception e) {
               logger.error("applyList error {}", e);
           }
    	   return model;
       }
       
       /**
        *课程编辑
        * @author weixianchao
        */
       @RequestMapping(value = "/editCourse")
       @ResponseBody
       public ModelAndView courseView(String courseId ,String pages){
    	   Course	course = new Course();
    	   ModelAndView model = new ModelAndView();
    	   try {
               SysUser sysUser = (SysUser) session.getAttribute("user");
           	course = courseService.queryCourseByCourseId(courseId);

               model.addObject("course", course);
               model.addObject("pages", pages);
               model.setViewName("admin/peopleTrain/editCourse");
           } catch (Exception e) {
               logger.error("applyList error {}", e);
           }
    	   return model;
       }
       /**
        *课程编辑保存
        * @author weixianchao
        */
       @RequestMapping(value = "/editSaveCourse")
       @ResponseBody
       public String editSaveCourse(Course course){
       	int count = 0;
    	try {
    		//从session中获取用户信息
    		SysUser sysUser = (SysUser) session.getAttribute("user");
    		if(sysUser != null){
    			
    			count = courseService.editSaveCourse(course);
    			
    		}else{
    			logger.error("当前登录用户不存在或没有登录，添加操作终止!");
    		}
    	} catch (Exception e) {
    		logger.error("更新课程信息时出错!", e);
    	}
    	if(count>0){
    		return Constant.RESULT_STR_SUCCESS;
    	}else {
    		return Constant.RESULT_STR_FAILURE;
    	}
       }
       /**
        * 添加报名人
        * @author weixianchao
        */
       @RequestMapping(value = "/addCourseUser")
       public ModelAndView addCourseUser(String courseId){
       	   ModelAndView model = new ModelAndView();
       	SysUser sysUser = (SysUser) session.getAttribute("user");
       	if(sysUser==null){
        	model.setViewName("redirect:/admin.do");
        	return model;
        }
       	Course	course = new Course();
    	course = courseService.queryCourseByCourseId(courseId);
                 model.addObject("course", course);
       	     model.setViewName("admin/peopleTrain/addCourseUser");
       	     return model;
       }
       /**
        * 保存报名人
        * @author weixianchao
        */
       @RequestMapping(value = "/saveCourseUser")
       @ResponseBody
       public Map saveCourseUser(String courseId,String userId){
    	   CourseOrder courseOrder =new CourseOrder();
    	   SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss:SSS");
    	   Map map = new HashMap();
    	   //默认为0，如果后续流程执行出错，则操作失败
           int count = 0;
           try {
               //从session中获取用户信息
               SysUser sysUser = (SysUser) session.getAttribute("user");
               if(sysUser != null){
            	   String result = null;
            	   result=courseOrderService.checkOrder(courseId,userId);
            	   if(result!=null){
           			map.put("msg", result);
           			map.put("success", "N");
           			return map;
           		}
            	   courseOrder.setOrderId(UUIDUtils.createUUId());  
            	   courseOrder.setCreateTime(dateFormat.format(new Date().getTime()));
            	   courseOrder.setCourseId(courseId);
            	   courseOrder.setUserId(userId);
            	   courseOrder.setOrderStatus(1);
            	   courseOrder.setMessageState(1);
            	   courseOrder.setAttendState(1);
                   courseOrderService.addCourseOrder(courseOrder); 
                   map.put("msg", "报名成功");
           		   map.put("success", "Y");
           		   map.put("courseId", courseId);	
           		return map;

               }else{
                   logger.error("当前登录用户不存在或没有登录，添加操作终止!");
               }
           } catch (Exception e) {
               logger.error("添加课程信息时出错!", e);
           }
           return null;
       }
       
       @RequestMapping(value = "/peopleTrainList")
       public ModelAndView peopleTrainList(String searchKey,TrainTerminalUser trainTerminalUser, Pagination page){
    	   ModelAndView model = new ModelAndView();
    	   SysUser sysUser = (SysUser) session.getAttribute("user");
    	   if(sysUser==null){
              	model.setViewName("redirect:/admin.do");
              	return model;
              }
    	   List<TrainTerminalUser> users = peopleTrainService.queryPeopleTrainByCondition(searchKey, trainTerminalUser, page, sysUser);
    	   model.addObject("users", users);
    	   model.addObject("trainTerminalUser", trainTerminalUser);
    	   model.addObject("page", page);
    	   model.setViewName("admin/peopleTrain/peopleTrainList");
    	   return model;
       }
       
       @RequestMapping(value = "/viewTrainUser")
       public ModelAndView viewTrainUser(String userId){
    	   ModelAndView model = new ModelAndView();
    	   SysUser sysUser = (SysUser) session.getAttribute("user");
    	   if(sysUser==null){
              	model.setViewName("redirect:/admin.do");
              	return model;
              }
    	   TrainTerminalUser user = peopleTrainService.queryTrainUserByUserId(userId);
    	   model.addObject("trainUser", user);
    	   model.setViewName("admin/peopleTrain/viewTrainUser");
    	   return model;
       }
	   
	   /**
        * 删除对应的报名订单
        * @author weixianchao
        */
      @RequestMapping(value = "/deleteOrder")
       @ResponseBody
       public String deleteOrder(String orderId, String state){
    	  CourseOrder	courseOrder = new CourseOrder();
    	  courseOrder = courseOrderService.queryCourseOrderByorderId(orderId);
       	//默认为0，如果后续流程执行出错，则操作失败
       	int count = 0;
       	try {
       		//从session中获取用户信息
       		SysUser sysUser = (SysUser) session.getAttribute("user");
       		if(sysUser != null){
       			
       			count = courseOrderService.deleteOrder(courseOrder,state,sysUser);
       			
       		}else{
       			logger.error("当前登录用户不存在或没有登录，添加操作终止!");
       		}
       	} catch (Exception e) {
       		logger.error("更新课程信息时出错!", e);
       	}
       	if(count>0){
       		//courseOrderService.sendMessageForDelete(orderId);
       		return Constant.RESULT_STR_SUCCESS;
       	}else {
       		return Constant.RESULT_STR_FAILURE;
       	}
       }
	   
      /**
       * 确认参加课程培训
       * @author weixianchao
       */
     @RequestMapping(value = "/attendCourse")
      @ResponseBody
      public String attendCourse(String orderId, String state){
    	  CourseOrder	courseOrder = new CourseOrder();
    	  courseOrder = courseOrderService.queryCourseOrderByorderId(orderId);
      	//默认为0，如果后续流程执行出错，则操作失败
      	int count = 0;
      	try {
      		//从session中获取用户信息
      		SysUser sysUser = (SysUser) session.getAttribute("user");
      		if(sysUser != null){
      			
      			count = courseOrderService.editAttendState(courseOrder,state);
      			
      		}else{
      			logger.error("当前登录用户不存在或没有登录，添加操作终止!");
      			return "redirect:/admin.do";
      		}
      	} catch (Exception e) {
      		logger.error("更新课程信息时出错!", e);
      	}
      	if(count>0){
      		return Constant.RESULT_STR_SUCCESS;
      	}else {
      		return Constant.RESULT_STR_FAILURE;
      	}
      }
     
     /**
      * 发短息
      * 
      */
     @RequestMapping(value = "/sendMessage")
     @ResponseBody
     public Map sendMessage(String orderId,String state,String type){
    	 Map map = new HashMap();
    	 String result = null;
    	 if("1".equals(type)){
    		 if("1".equals(state)){
    			 result = courseOrderService.sendMessageForCancel(orderId, state);
    		 }else{
    			 result = courseOrderService.sendMessage(orderId,state); 
    		 }
    	 }else{
    		 result = courseOrderService.sendMessagesAll(orderId,state);
    	 }
    	 if(result!=null){
    		 map.put("sucess", "N"); 
    	 }else{
    		 map.put("sucess", "Y"); 
    	 }
     	 return map;
     }
      
     @RequestMapping(value = "/courseDetails")
     public ModelAndView courseDetails(String courseId){
  	   ModelAndView model = new ModelAndView();
  	   SysUser sysUser = (SysUser) session.getAttribute("user");
  	   if(sysUser==null){
            	model.setViewName("redirect:/admin.do");
            	return model;
            }
  	   Course course = courseService.queryCourseByCourseId(courseId);
  	   model.addObject("course", course);
  	   model.setViewName("admin/peopleTrain/courseDetails");
  	   return model;
     }
     /**
      * 添加课程列表
      * @author weixianchao
      */
     @RequestMapping(value = "/messageView")
     public ModelAndView messageView(String courseId,String orderId,String type,String state){
    	 Course course =new Course();
    	 course = courseService.queryCourseByCourseId(courseId);
     	   ModelAndView model = new ModelAndView();
     	  model.addObject("course", course);
     	  model.addObject("orderId", orderId);
     	  model.addObject("type", type);
     	  model.addObject("state", state);
     	     model.setViewName("admin/peopleTrain/messageView");
     	     return model;
     }     
}
