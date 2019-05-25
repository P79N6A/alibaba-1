package com.sun3d.why.controller.train;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.SysDict;
import com.sun3d.why.model.peopleTrain.Course;
import com.sun3d.why.model.peopleTrain.CourseOrder;
import com.sun3d.why.model.peopleTrain.CourseOrderTemp;
import com.sun3d.why.model.peopleTrain.TrainTerminalUser;
import com.sun3d.why.service.CmsTerminalUserService;
import com.sun3d.why.service.CourseOrderService;
import com.sun3d.why.service.CourseService;
import com.sun3d.why.service.PeopleTrainService;
import com.sun3d.why.service.SysDictService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;

@Controller
@RequestMapping("/train")
public class TrainController {
	
	private Logger logger = LoggerFactory.getLogger(TrainController.class);
	
	@Autowired
    private HttpSession session;
	@Autowired
	private PeopleTrainService peopleTrainService;
	@Autowired
	private CourseService courseService;
	@Autowired
	private CourseOrderService courseOrderService;
	@Autowired
	private SysDictService sysDictService;
	@Autowired
	private CmsTerminalUserService terminalUserService ;
	
	@RequestMapping("/toBookTrain")
	public ModelAndView tofillPersonalInfo(HttpServletRequest request){
		ModelAndView view = new ModelAndView();
        CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute("terminalUser");
		if(terminalUser==null){
			String path = request.getContextPath();
			String basePath = request.getScheme() + "://"
		            + request.getServerName() + ":" + request.getServerPort()
		            + path + "/";
			basePath = basePath + "train/toBookTrain.do";
			view.setViewName("redirect:/frontTerminalUser/userLogin.do?callback="+basePath);
			return view;
		}
		
		TrainTerminalUser trainTerminalUser = peopleTrainService.queryTrainUserByUserId(terminalUser.getUserId());
		SysDict d1 = sysDictService.querySysDictByDictName("万人培训职务", "COURSE_JOB");
		if(d1!=null){
			SysDict dic1 = new SysDict();
			dic1.setDictParentId(d1.getDictId());
			List<SysDict> jobs = sysDictService.querySysDictByByCondition(dic1);
			view.addObject("jobs", jobs);
		}
		
		SysDict d2 = sysDictService.querySysDictByDictName("万人培训职称", "COURSE_JOB_TITLE");
		if(d2!=null){
			SysDict dic1 = new SysDict();
			dic1.setDictParentId(d2.getDictId());
			List<SysDict> titles = sysDictService.querySysDictByByCondition(dic1);
			view.addObject("titles", titles);
		}
		SysDict d3 = sysDictService.querySysDictByDictName("万人培训从事领域", "COURSE_FIELD");
		if(d3!=null){
			SysDict dic1 = new SysDict();
			dic1.setDictParentId(d3.getDictId());
			List<SysDict> fields = sysDictService.querySysDictByByCondition(dic1);
			view.addObject("fields", fields);
		}
		if(trainTerminalUser!=null){
			view.addObject("trainUser", trainTerminalUser);
			if(StringUtils.isNotBlank(trainTerminalUser.getIdNumber())){
				String idNum = StringUtils.substring(trainTerminalUser.getIdNumber(), 0, 4);
				idNum = idNum+"**************";
				trainTerminalUser.setIdNumber(idNum);
			}
			if(StringUtils.isNotBlank(trainTerminalUser.getVerificationCode())){
				String code = StringUtils.substring(trainTerminalUser.getVerificationCode(), 0, 2);
				code = code+"****";
				trainTerminalUser.setVerificationCode(code);
			}
			
		}
		view.addObject("user", terminalUser);
		view.setViewName("train/trainBook");
		return view;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value="/savePersonalInfo",method=RequestMethod.POST)
	@ResponseBody
	public Map savePersonalInfo(TrainTerminalUser trainTerminalUser,CmsTerminalUser user){
		Map map = new HashMap();
		CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute("terminalUser");
		if(terminalUser==null){
			map.put("msg", "请先登录");
			map.put("success", "N");
			return map;
		}
		String result = peopleTrainService.addTrainTerminalUser(trainTerminalUser,user);
		if(result!=null){
			map.put("msg", result);
			map.put("success", "N");
			return map;
		}
		map.put("success", "Y");
		return map;
	}
	
	@RequestMapping("/toOrder")
	public ModelAndView toOrder(String type){
		ModelAndView view = new ModelAndView();
		CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute("terminalUser");
		if(terminalUser==null){
			view.setViewName("redirect:/frontTerminalUser/userLogin.do");
			return view;
		}
		TrainTerminalUser trainTerminalUser = peopleTrainService.queryTrainUserByUserId(terminalUser.getUserId());
		Map<String,Object> map1 = new HashMap<String,Object>();
		Map<String,Object> map2 = new HashMap<String,Object>();
		SysDict dic1 = sysDictService.querySysDictByDictName("三天短训", "STDX");
		SysDict dic2 = sysDictService.querySysDictByDictName("专题讲座", "ZTJZ");
		SysDict dic3=null;
		if(StringUtils.isBlank(type)){
			dic3 = sysDictService.querySysDictByDictName("第三次培训课程", "DSCPXKC");
			view.setViewName("train/threeTrainBookSelect");
			/**
			 * 时间控制  到2016-09-07 09:00 开放
			 *  
			 */
			DateFormat df = new SimpleDateFormat("yyyy-MM-dd hh:mm"); 
			try {
				Date dt1 = df.parse("2016-09-07 09:00");
				Date  dt2 = new Date();
				if(dt1.getTime()>dt2.getTime()){
					view.addObject("registerStatus", "close");
				}else{
					view.addObject("registerStatus","open");
				}
				
			} catch (ParseException e) {
				e.printStackTrace();
			}
		}else if(type.equals("2")){
			dic3 = sysDictService.querySysDictByDictName("第二次培训课程", "DECPXKC");
			view.setViewName("train/twoTrainBookSelect");
		}else if(type.equals("1")){
			dic3 = sysDictService.querySysDictByDictName("第一次培训课程", "DYCPXKC");
			view.setViewName("train/oneTrainBookSelect");
		}
        
		
		/*  OLD
		if(StringUtils.isBlank(type)){
			dic3 = sysDictService.querySysDictByDictName("第二次培训课程", "DECPXKC");
			view.setViewName("train/twoTrainBookSelect");
		}else if(type.equals("1")){
			dic3 = sysDictService.querySysDictByDictName("第一次培训课程", "DYCPXKC");
			view.setViewName("train/oneTrainBookSelect");
		}*/
		map1.put("courseType", dic1.getDictId());
		//map1.put("courseField", "%" + trainTerminalUser.getEngagedField() + "%");
		map1.put("courseState", 1);
		map1.put("courseRank", dic3.getDictId());
		
		map2.put("courseType", dic2.getDictId());
		//map2.put("courseField", "%" + trainTerminalUser.getEngagedField() + "%");
		map2.put("courseState", 1);
		map2.put("courseRank", dic3.getDictId());
		//三天短训类
		List<Course> shortCourses = courseService.queryCourseListForFront(map1);
		//讲座类
		List<Course> lectureCourses = courseService.queryCourseListForFront(map2);
		view.addObject("trainUser", trainTerminalUser);
		view.addObject("user", terminalUser);
		view.addObject("shortCourses", shortCourses);
		view.addObject("lectureCourses", lectureCourses);
		return view;
	}
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value="/saveCourseOrder",method=RequestMethod.POST)
	@ResponseBody
	public Map saveCourseOrder(CourseOrderTemp temp,HttpServletResponse response) throws Exception{
		Map map = new HashMap();
		CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute("terminalUser");
		if(terminalUser==null){
			map.put("msg", "请先登录");
			map.put("success", "N");
			return map;
		}
		SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String limitStartTime = "2016-06-02 10:00:00";
		String limitEndTime = "2016-06-07 09:00:00";
		Date limitStart = f.parse(limitStartTime);
		Date limitEnd = f.parse(limitEndTime);
		Date currentTime = new Date();
		if(limitStart.getTime()<=currentTime.getTime() && currentTime.getTime()<limitEnd.getTime()){
			map.put("msg", "友情提醒：正式选课报名将于6月7日上午9:00正式开启！");
			map.put("success", "N");
			return map;
		}
		String result = null;
		if(temp!=null){
			result = courseOrderService.checkCourseOrder(temp.getCourseId(), temp.getCourseType(),temp.getCourseTitle(), temp.getUserId());
		}
		if(result!=null){
			map.put("msg", result);
			map.put("success", "N");
			return map;
		}
		courseOrderService.courseOrder(temp);
		map.put("msg", "报名成功");
		map.put("success", "Y");
		return map;
	}
	
	@RequestMapping("/toOrderSucess")
	public ModelAndView toOrderSucess(CourseOrderTemp temp){
		ModelAndView view = new ModelAndView();
		CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute("terminalUser");
		if(terminalUser==null){
			view.setViewName("redirect:/frontTerminalUser/userLogin.do");
			return view;
		}
		List<Course> courses = courseService.queryCourseByIn(temp);
		view.addObject("courses", courses);
		view.setViewName("train/trainBookSuccess");
		return view;
	}
	
	@RequestMapping("/queryCourseOrder")
	public ModelAndView queryTrainOrder(){
		ModelAndView view = new ModelAndView();
		CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute("terminalUser");
		if(terminalUser==null){
			view.setViewName("redirect:/frontTerminalUser/userLogin.do");
			return view;
		}
		view.setViewName("/index/userCenter/userCourseOrder");
		return view;
	}
	
	@RequestMapping("/userCourseList")
	public ModelAndView userCourseList(Pagination page){
		ModelAndView view = new ModelAndView();
		CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute("terminalUser");
		if(terminalUser==null){
			view.setViewName("redirect:/frontTerminalUser/userLogin.do");
			return view;
		}
		String userId = terminalUser.getUserId();
        page.setRows(5);
        List<CourseOrder> courseOrderList = courseOrderService.queryUserOrderList(userId,page);
//        SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
//        String currentDate = f.format(new Date());
//        view.addObject("currentDate", currentDate);
        view.addObject("courseOrderList", courseOrderList);
        view.addObject("page", page);
		view.setViewName("/index/userCenter/userCourseOrderLoad");
		return view;
	}
	
	/**
     * 通过ID删除报名
     * @param orderId
     * @return
     */
    @RequestMapping("/cancelUserCourseOrder")
    @ResponseBody
    public String cancelUserCourseOrder(String orderId){
		CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute("terminalUser");
		if(terminalUser==null){
			return "redirect:/frontTerminalUser/userLogin.do";
		}
		CourseOrder courseOrder = courseOrderService.queryCourseOrderByorderId(orderId);
		if(courseOrder==null){
			 return Constant.RESULT_STR_FAILURE;
		}
		String str = courseOrderService.cancelOrder(courseOrder,terminalUser);
		return str;
    }
    
    /**
     * 检查身份证是否存在
     * @param orderId
     * @return
     */
    @RequestMapping("/checkIDExsits")
    @ResponseBody
    public String checkIDExsits(String IDNumber){
    	TrainTerminalUser trainTerminalUser = peopleTrainService.queryPeopleTrainById(IDNumber);
    	if(trainTerminalUser!=null){
    		return "exists";
    	}
    	return "noexists";
    }
    /**
     * 检查身份证是否存在
     * @param orderId
     * @return
     */
    @RequestMapping("/checkPhoneNumExsits")
    @ResponseBody
    public String checkPhoneNumExsits(String userMobileNo){
    	CmsTerminalUser cmsTerminalUser = terminalUserService.getCmsTerminalUserByMobile(userMobileNo);
    	if(cmsTerminalUser!=null){
    		return "exists";
    	}
    	return "noexists";
    }

}
