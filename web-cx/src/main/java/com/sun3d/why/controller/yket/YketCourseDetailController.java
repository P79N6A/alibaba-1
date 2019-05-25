package com.sun3d.why.controller.yket;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.sun3d.why.common.ProjectConst;
import com.sun3d.why.enumeration.TraceTypeEnum;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.bean.yket.YketTrace;
import com.sun3d.why.model.vo.yket.YketCourse4FrontVo;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.RecommandService;
import com.sun3d.why.service.TraceService;
import com.sun3d.why.service.YketCourseService;
import com.sun3d.why.util.BindWS;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.api.service.CmsApiTerminalUserService;

@Controller
@RequestMapping("/ykytCourseDetail")
public class YketCourseDetailController {

	@Autowired
	private CacheService cacheService;

	@Autowired
	private HttpSession session;

	@Autowired
	private YketCourseService courseService;

	@Autowired
	private TraceService traceService;

	@Autowired
	private RecommandService recommandService;
	
	@Autowired
	CmsApiTerminalUserService userService; 
	private Logger logger = Logger.getLogger(YketCourseDetailController.class);
	@RequestMapping(value = "/share", method = RequestMethod.GET)
	public String login(HttpServletRequest request) {
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "";
	}

	@RequestMapping(value = "/detail")
	public String detail(String courseId, Model model,HttpServletRequest request,String userId) {
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		CmsTerminalUser user = (CmsTerminalUser) session.getAttribute(ProjectConst.FRONT_SESSION_KEY);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("courseId", courseId);
		YketCourse4FrontVo detail=null;
		if(user!=null || !StringUtils.isEmpty(userId)){
			/*if(user!=null){
				map.put("userId", user.getUserId());
			}else{*/
				map.put("userId", userId);
 			/*}*/
			detail = this.courseService.getCourseDetailFront(map);
			YketTrace trace = new YketTrace();
			trace.setTraceId(UUIDUtils.createUUId());
			trace.setObjectId(courseId);
			trace.setTraceType(TraceTypeEnum.COURSE.getIndex());
			trace.setUserId(map.get("userId").toString());
			trace.setCreateTime(new Date());
			traceService.addTrace(trace);		
		}else{
			logger.error("没有登录信息");
			return "wechat/yket/detail";
		}
		model.addAttribute("courseDetail", detail);
		model.addAttribute("recommend", recommandService.recommandCourse());
		return "wechat/yket/detail";
	}

}
