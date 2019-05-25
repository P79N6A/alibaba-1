package com.sun3d.why.controller.yket;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sun3d.why.common.ProjectConst;
import com.sun3d.why.enumeration.LabelTypeEnum;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.bean.yket.YketCourse;
import com.sun3d.why.model.bean.yket.YketExternalLink;
import com.sun3d.why.model.bean.yket.YketLabel;
import com.sun3d.why.model.vo.yket.YketCourseList4FrontVo;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.LabelService;
import com.sun3d.why.service.YketCourseService;
import com.sun3d.why.service.YketExternalLinkService;
import com.sun3d.why.util.BindWS;
import com.sun3d.why.webservice.api.service.CmsApiTerminalUserService;

@RequestMapping("/yketIndex")
@Controller
public class YketIndexController {

	@Autowired
	private CacheService cacheService;

	@Autowired
	private YketCourseService courseService;

	@Autowired
	private LabelService labelService;

	@Autowired
	CmsApiTerminalUserService userService; 
	
	
	@Autowired
	private YketExternalLinkService yketExternalLinkService;

	@Autowired
	private HttpSession session;

	private Logger logger = Logger.getLogger(YketIndexController.class);

	
	/**
	 * 首页
	 * 
	 * @param request
	 * @param tab
	 * @return
	 */
	@RequestMapping("/index")
	public String index(HttpServletRequest request, String tab, Model model, String course,String userId) {
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		Map<String, String> map = new HashMap<String, String>();
		request.setAttribute("sign", sign);
		request.setAttribute("tab", tab);
		request.setAttribute("course", course);

		if (!StringUtils.isEmpty(tab)) {
			map.put("courseType", tab);
		} else {
			map.put("courseType", "1");
			request.setAttribute("tab", "1");
		}
		if (!StringUtils.isEmpty(course)) {
			map.put("course", course);
		}
		CmsTerminalUser user = (CmsTerminalUser) session.getAttribute(ProjectConst.FRONT_SESSION_KEY);
 
 		if (StringUtils.isEmpty(userId) && user==null) {
			/*logger.error("没有登录信息");
			return "wechat/yket/index";  */
		} else {
				//map.put("userId", StringUtils.isEmpty(userId)?user.getUserId():userId);
				map.put("userId", userId);
		}
		List<YketCourseList4FrontVo> list=null;
		list = this.courseService.getCourseList4Front(map);
		List<YketExternalLink> externalLinkList = this.yketExternalLinkService.queryExternalLinkList();
		model.addAttribute("externalLinkList", externalLinkList);
		model.addAttribute("list", list);
		return "wechat/yket/index";
	}

	@Deprecated
	public String indexOld(HttpServletRequest request, String tab, Model model, String labelType) {
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		Map<String, Object> map = new HashMap<String, Object>();
		request.setAttribute("sign", sign);
		request.setAttribute("tab", tab);
		if (!StringUtils.isEmpty(labelType)) {
			LabelTypeEnum e = LabelTypeEnum.valueOf(labelType);
			if (!StringUtils.isEmpty(tab)) {
				if (e.getIndex() == 1) {
					map.put("labelId", tab);
				} else if (e.getIndex() == 2) {
					if (tab.equals("1")) {
						map.put("labelId", tab);
					} else if (tab.equals("2")) {
						map.put("labelId", tab);
					} else if (tab.equals("3")) {
						map.put("labelId", tab);
					} else if (tab.equals("4")) {
						map.put("labelId", tab);
					} else {
						map.put("labelId", "1");
					}
				}
			}
			map.put("labelType", e.getIndex());

			// new start

			switch (e) {

			}

			// new end

		}

		List<YketCourse> list = this.courseService.queryFrontYketCourseList(map);
		List<YketExternalLink> externalLinkList = this.yketExternalLinkService.queryExternalLinkList();
		model.addAttribute("externalLinkList", externalLinkList);
		model.addAttribute("list", list);
		return "wechat/yket/index";
	}

	@RequestMapping(value = "/labelTypeList", method = RequestMethod.POST)
	@ResponseBody
	public List<YketLabel> typeList(String labelType) {
		LabelTypeEnum e = LabelTypeEnum.valueOf(labelType);
		return labelService.typeList(e.getIndex());
	}
}
