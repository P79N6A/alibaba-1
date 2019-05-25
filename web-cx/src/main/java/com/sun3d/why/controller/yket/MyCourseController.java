package com.sun3d.why.controller.yket;

import java.util.List;
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
import org.springframework.web.bind.annotation.ResponseBody;

import com.sun3d.why.common.ProjectConst;
import com.sun3d.why.common.Result;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.bean.yket.YketExternalLink;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.FavoriteService;
import com.sun3d.why.service.RecommandService;
import com.sun3d.why.service.TraceService;
import com.sun3d.why.service.YketExternalLinkService;
import com.sun3d.why.util.BindWS;
import com.sun3d.why.webservice.api.service.CmsApiTerminalUserService;

@Controller
@RequestMapping("/myCourse")
public class MyCourseController {

	@Autowired
	private RecommandService recommandService;

	@Autowired
	private YketExternalLinkService yketExternalLinkService;

	@Autowired
	private HttpSession session;
	
	@Autowired
	private CacheService cacheService;

	
	@Autowired
	private TraceService traceService;
	
	
	private Logger logger = Logger.getLogger(MyCourseController.class);
	@Autowired
	CmsApiTerminalUserService userService; 
	
	@Autowired
	private FavoriteService favoriteService;
	@RequestMapping(value = "/info", method = RequestMethod.GET)
	public String myCourse(Model model,HttpServletRequest request,String userId) {
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		CmsTerminalUser user = (CmsTerminalUser) session.getAttribute(ProjectConst.FRONT_SESSION_KEY);
		if(user==null && StringUtils.isEmpty(userId)){
			/*logger.error("没有登录信息");
			return "wechat/yket/myCourse";*/
		} 
		model.addAttribute("recommend", recommandService.recommandCourse());
		List<YketExternalLink> externalLinkList = this.yketExternalLinkService.queryExternalLinkList();
		model.addAttribute("externalLinkList", externalLinkList);
		return "wechat/yket/myCourse";
	}

	@RequestMapping(value = "/trace", method = RequestMethod.POST)
	@ResponseBody
	public Result trace(String userId) {
		CmsTerminalUser user = (CmsTerminalUser) session.getAttribute(ProjectConst.FRONT_SESSION_KEY);
		if(user==null && StringUtils.isEmpty(userId)){
			return  Result.Unlogin();
		}else{
			if(user!=null){
				return traceService.listTraceByUserId(user.getUserId());	
			}else{
				return traceService.listTraceByUserId(userId);
			}
		}
	}
	
	@RequestMapping(value = "/favoirte", method = RequestMethod.POST)
	@ResponseBody
	public Result favoirte(String userId) {
		CmsTerminalUser user = (CmsTerminalUser) session.getAttribute(ProjectConst.FRONT_SESSION_KEY);
		if(user==null&& StringUtils.isEmpty(userId)){
			return  Result.Unlogin();
		}else{
			if(user!=null){
				return favoriteService.listFavoriteByUserId(user.getUserId());
			}else{
				return favoriteService.listFavoriteByUserId(userId);
			}
		}
	}

}
