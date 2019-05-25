package com.sun3d.why.controller.train.wechat;

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
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.fastjson.JSONObject;
import com.sun3d.why.controller.CmsActivityController;
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
import com.sun3d.why.util.Pagination;

/**
 * 
 * Filename: MillionPeopleController.java Description:万人培训报名微信端
 * Copyright:Copyright (c)2016 Company: sun3d
 * 
 * @author: weixianchao
 * @version: 1.0
 * @Create: 2016-5-24 Modification History: Date Author Version
 *          ------------------------------------------------------------------
 *          2016-5-24 上午11:21:52 weixianchao 1.0
 */
@RequestMapping("/millionPeople")
@Controller
public class MillionPeopleController {
	private Logger logger = LoggerFactory
			.getLogger(MillionPeopleController.class);
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
	private CmsTerminalUserService terminalUserService;

	@RequestMapping("/index")
	public ModelAndView tofillPersonalInfo(HttpServletRequest request) {
		ModelAndView view = new ModelAndView();
		CmsTerminalUser terminalUser = (CmsTerminalUser) session
				.getAttribute("terminalUser");
		view.setViewName("train/weChat/index");
		if (terminalUser != null) {
			if (terminalUser.getUserId() == null) {
				String path = request.getContextPath();
				String basePath = request.getScheme() + "://"
						+ request.getServerName() + ":"
						+ request.getServerPort() + path + "/";
				basePath = basePath + "millionPeople/index.do";
				view.setViewName("redirect:/muser/login.do?type=" + basePath);
				return view;
			}
		}else{
			String path = request.getContextPath();
			String basePath = request.getScheme() + "://"
					+ request.getServerName() + ":"
					+ request.getServerPort() + path + "/";
			basePath = basePath + "millionPeople/index.do";
			view.setViewName("redirect:/muser/login.do?type=" + basePath);
			return view;	
		}
		TrainTerminalUser trainTerminalUser = peopleTrainService
				.queryTrainUserByUserId(terminalUser.getUserId());
		SysDict d1 = sysDictService.querySysDictByDictName("万人培训职务",
				"COURSE_JOB");
		if (d1 != null) {
			SysDict dic1 = new SysDict();
			dic1.setDictParentId(d1.getDictId());
			List<SysDict> jobs = sysDictService.querySysDictByByCondition(dic1);
			view.addObject("jobs", jobs);
		}

		SysDict d2 = sysDictService.querySysDictByDictName("万人培训职称",
				"COURSE_JOB_TITLE");
		if (d2 != null) {
			SysDict dic1 = new SysDict();
			dic1.setDictParentId(d2.getDictId());
			List<SysDict> titles = sysDictService
					.querySysDictByByCondition(dic1);
			view.addObject("titles", titles);
		}
		SysDict d3 = sysDictService.querySysDictByDictName("万人培训从事领域",
				"COURSE_FIELD");
		if (d3 != null) {
			SysDict dic1 = new SysDict();
			dic1.setDictParentId(d3.getDictId());
			List<SysDict> fields = sysDictService
					.querySysDictByByCondition(dic1);
			view.addObject("fields", fields);
		}
		if (trainTerminalUser != null) {
			view.addObject("trainUser", trainTerminalUser);
			if (StringUtils.isNotBlank(trainTerminalUser.getIdNumber())) {
				String idNum = StringUtils.substring(
						trainTerminalUser.getIdNumber(), 0, 4);
				idNum = idNum + "**************";
				trainTerminalUser.setIdNumber(idNum);
			}
			if (StringUtils.isNotBlank(trainTerminalUser.getVerificationCode())) {
				String code = StringUtils.substring(
						trainTerminalUser.getVerificationCode(), 0, 2);
				code = code + "****";
				trainTerminalUser.setVerificationCode(code);
			}

		}
		view.addObject("user", terminalUser);
		return view;
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "/savePersonalInfo", method = RequestMethod.POST)
	@ResponseBody
	public Map savePersonalInfo(TrainTerminalUser trainTerminalUser,
			CmsTerminalUser user) {
		Map map = new HashMap();
		CmsTerminalUser terminalUser = (CmsTerminalUser) session
				.getAttribute("terminalUser");
		if (terminalUser == null) {
			map.put("msg", "请先登录");
			map.put("success", "N");
			return map;
		}
		String result = peopleTrainService.addTrainTerminalUser(
				trainTerminalUser, user);
		if (result != null) {
			map.put("msg", result);
			map.put("success", "N");
			return map;
		}
		map.put("success", "Y");
		return map;
	}

	/**
	 * 
	 * @Description:选课页面
	 * @author weixianchao
	 * @Created 2016-5-26
	 * @return
	 */
	@RequestMapping("/toOrder")
	public ModelAndView toOrder(String type, HttpServletRequest request) {
		ModelAndView view = new ModelAndView();
		CmsTerminalUser terminalUser = (CmsTerminalUser) session
				.getAttribute("terminalUser");
		if (terminalUser != null) {
			if (terminalUser.getUserId() == null) {
				String path = request.getContextPath();
				String basePath = request.getScheme() + "://"
						+ request.getServerName() + ":"
						+ request.getServerPort() + path + "/";
				basePath = basePath + "millionPeople/toOrder.do";
				view.setViewName("redirect:/muser/login.do?type=" + basePath);
				return view;
			}
		}else{
			String path = request.getContextPath();
			String basePath = request.getScheme() + "://"
					+ request.getServerName() + ":"
					+ request.getServerPort() + path + "/";
			basePath = basePath + "millionPeople/toOrder.do";
			view.setViewName("redirect:/muser/login.do?type=" + basePath);
			return view;
		}
		TrainTerminalUser trainTerminalUser = peopleTrainService
				.queryTrainUserByUserId(terminalUser.getUserId());
		Map<String, Object> map1 = new HashMap<String, Object>();
		Map<String, Object> map2 = new HashMap<String, Object>();

		SysDict dic1 = sysDictService.querySysDictByDictName("三天短训", "STDX");
		SysDict dic2 = sysDictService.querySysDictByDictName("专题讲座", "ZTJZ");
		SysDict dic3 = null;
		if (StringUtils.isBlank(type)) {
			dic3 = sysDictService.querySysDictByDictName("第二次培训课程", "DECPXKC");
			view.setViewName("train/weChat/twoSelClass");
		} else {
			dic3 = sysDictService.querySysDictByDictName("第一次培训课程", "DYCPXKC");
			view.setViewName("train/weChat/oneSelClass");
		}
		map1.put("courseType", dic1.getDictId());
		map1.put("courseState", 1);
		map1.put("courseRank", dic3.getDictId());
		map2.put("courseType", dic2.getDictId());
		map2.put("courseState", 1);
		map2.put("courseRank", dic3.getDictId());
		// 三天短训类
		List<Course> shortCourses = courseService.queryCourseListForFront(map1);
		// 讲座类
		List<Course> lectureCourses = courseService
				.queryCourseListForFront(map2);
		view.addObject("trainUser", trainTerminalUser);
		view.addObject("user", terminalUser);
		view.addObject("shortCourses", shortCourses);
		view.addObject("lectureCourses", lectureCourses);

		return view;
	}

	/**
	 * 
	 * @Description:添加报名
	 * @author weixianchao
	 * @Created 2016-5-26
	 * @param temp
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping(value = "/saveCourseOrder", method = RequestMethod.POST)
	@ResponseBody
	public Map saveCourseOrder(CourseOrderTemp temp,
			HttpServletResponse response) throws Exception {
		Map map = new HashMap();
		CmsTerminalUser terminalUser = (CmsTerminalUser) session
				.getAttribute("terminalUser");
		if (terminalUser == null) {
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
		if (temp != null) {
			result = courseOrderService.checkCourseOrder(temp.getCourseId(),
					temp.getCourseType(), temp.getCourseTitle(),
					temp.getUserId());
		}
		if (result != null) {
			map.put("msg", result);
			map.put("success", "N");
			return map;
		}
		courseOrderService.courseOrder(temp);
		map.put("msg", "报名成功");
		map.put("success", "Y");
		return map;
	}

	/**
	 * 
	 * @Description:跳转到报名成功页面
	 * @author weixianchao
	 * @Created 2016-5-26
	 * @param temp
	 * @return
	 */
	@RequestMapping("/toOrderSucess")
	public ModelAndView toOrderSucess(CourseOrderTemp temp,
			HttpServletRequest request) {
		ModelAndView view = new ModelAndView();
		CmsTerminalUser terminalUser = (CmsTerminalUser) session
				.getAttribute("terminalUser");
		view.setViewName("train/weChat/waitFrim");
		if (terminalUser != null) {
			if (terminalUser.getUserId() == null) {
				String path = request.getContextPath();
				String basePath = request.getScheme() + "://"
						+ request.getServerName() + ":"
						+ request.getServerPort() + path + "/";
				basePath = basePath + "millionPeople/toOrderSucess.do";
				view.setViewName("redirect:/muser/userLogin.do?type="
						+ basePath);
				return view;
			}
		}else{
				String path = request.getContextPath();
				String basePath = request.getScheme() + "://"
						+ request.getServerName() + ":"
						+ request.getServerPort() + path + "/";
				basePath = basePath + "millionPeople/toOrderSucess.do";
				view.setViewName("redirect:/muser/userLogin.do?type="
						+ basePath);
				return view;
		}
		List<Course> courses = courseService.queryCourseByIn(temp);
		view.addObject("courses", courses);

		return view;
	}

	/**
	 * 
	 * @Description:个人中心
	 * @author weixianchao
	 * @Created 2016-5-26
	 * @param request
	 * @return
	 */
	@RequestMapping("/queryCourseOrder")
	public ModelAndView queryTrainOrder(HttpServletRequest request) {
		ModelAndView view = new ModelAndView();
		CmsTerminalUser terminalUser = (CmsTerminalUser) session
				.getAttribute("terminalUser");
		view.setViewName("/train/weChat/mySignUp");
		if (terminalUser != null) {
			if (terminalUser.getUserId() == null) {
				String path = request.getContextPath();
				String basePath = request.getScheme() + "://"
						+ request.getServerName() + ":"
						+ request.getServerPort() + path + "/";
				basePath = basePath + "millionPeople/queryCourseOrder.do";
				view.setViewName("redirect:/muser/userLogin.do?type="
						+ basePath);
				return view;
			}
		}else{
			String path = request.getContextPath();
			String basePath = request.getScheme() + "://"
					+ request.getServerName() + ":"
					+ request.getServerPort() + path + "/";
			basePath = basePath + "millionPeople/queryCourseOrder.do";
			view.setViewName("redirect:/muser/userLogin.do?type="
					+ basePath);
		}
		return view;
	}

	@RequestMapping("/userCourseList")
	@ResponseBody
	public List userCourseList(String page, String pagesize,
			HttpServletResponse response) {
		Pagination pages = new Pagination();
		CmsTerminalUser terminalUser = (CmsTerminalUser) session
				.getAttribute("terminalUser");
		String userId = terminalUser.getUserId();
		pages.setRows(Integer.valueOf(pagesize));
		pages.setPage(Integer.valueOf(page));
		List<CourseOrder> courseOrderList = courseOrderService
				.queryUserOrderList(userId, pages);

		return courseOrderList;

	}
}
