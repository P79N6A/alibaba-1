package com.sun3d.why.controller.wechat;

import com.sun3d.why.model.BpCarousel;
import com.sun3d.why.model.BpInfo;
import com.sun3d.why.model.BpInfoTag;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.service.BpCarouselService;
import com.sun3d.why.service.BpInfoService;
import com.sun3d.why.service.BpInfoTagServcie;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.util.BindWS;
import com.sun3d.why.util.PaginationApp;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/wechatChuanzhou")
public class WechatChuanzhouController {
	private Logger logger = LoggerFactory.getLogger(WechatActivityController.class);

	@Autowired
	private CacheService cacheService;

	@Autowired
	private BpCarouselService bpCarouselservice;

	@Autowired
	private BpInfoService bpInfoService;

	@Autowired
	private BpInfoTagServcie bpInfoTagServcie;

	@Autowired
	private HttpSession session;

	@RequestMapping("/chuanzhouIndex")
	public ModelAndView chuanzhouIndex() {
		ModelAndView mv = new ModelAndView();
		// h5首页轮播图
		List<BpCarousel> resultList = null;
		resultList = bpCarouselservice.queryBpCarouselList(1);
		mv.addObject("resultList", resultList);

		// 人文洪山首页推荐（选取推荐编号为1的资讯）
		List<BpInfo> bpInfoListNum1 = new ArrayList<>();
		List<BpInfoTag> parentTagList = bpInfoTagServcie.queryParentTag();
		for (BpInfoTag bpInfoTag : parentTagList) {
			List<BpInfo> listByTag = bpInfoService.queryRecommendListByTag(bpInfoTag.getTagCode());
			// 每个标签推荐资讯编号为1的资讯在h5首页显示
			if (listByTag.size() != 0) {
				listByTag.get(0).setParentTagInfo(bpInfoTag.getTagName());
				listByTag.get(0).setBeipiaoinfoTag(bpInfoTag.getTagCode());
				bpInfoListNum1.add(listByTag.get(0));
			}
		}
		mv.addObject("bpInfoListNum1", bpInfoListNum1);
		mv.setViewName("wechat/bpChuanzhou/chuanzhouIndex");
		return mv;
	}

	// 人文洪山列表页(h5)
	@RequestMapping("/chuanzhouList")
	public ModelAndView chuanzhouList(ModelAndView mv, String infoTagCode,HttpServletRequest request) {

		// 顶端子标签集合
		List<BpInfoTag> infoTagList = bpInfoTagServcie.queryChildTagByChildTag(infoTagCode);
		// 列子标签下资讯列表(首次进入列表页显示五条数据)
		// PaginationApp pageApp = new PaginationApp();
		// pageApp.setFirstResult(0);
		// pageApp.setRows(8);
		// List<BpInfo> infoList =
		// bpInfoService.wechatQueryInfoList(infoTagCode, pageApp);

		mv.addObject("infoTagCode", infoTagCode);
		// mv.addObject("infoList", infoList);
		mv.addObject("infoTagList", infoTagList);

		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		mv.setViewName("wechat/bpChuanzhou/chuanzhouList");
		return mv;
	}

	// 人文洪山列表页(h5)下拉加载数据
	@RequestMapping("loadChuanzhouList")
	@ResponseBody
	public List<BpInfo> loadChuanzhouList(String infoTagCode, String startIndex, String pageSize) {
		PaginationApp pageApp = new PaginationApp();
		pageApp.setFirstResult(Integer.parseInt(startIndex));
		pageApp.setRows(Integer.parseInt(pageSize));
		List<BpInfo> infoList = bpInfoService.wechatQueryInfoList(infoTagCode, pageApp);
		return infoList;
	}

	// 人文洪山详情页
	@RequestMapping("/chuanzhouDetail")
	public ModelAndView chuanzhouDetail(ModelAndView mv, String infoId,HttpServletRequest request) {
		BpInfo bpInfo = bpInfoService.queryBpInfo(infoId);
		CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute("terminalUser");
		// 若处于登录状态，根据用户Id，资讯Id查找是否点赞
		if (terminalUser != null) {
			Integer userIsWant = bpInfoService.queryCountUserIsWant(terminalUser.getUserId(), infoId);
			mv.addObject("userIsWant", userIsWant);
		}else{
			String userId = request.getParameter("userId");
			if(StringUtils.isNotBlank(userId)){
				Integer userIsWant = bpInfoService.queryCountUserIsWant(userId, infoId);
				mv.addObject("userIsWant", userIsWant);
			}
		}
		// 查找评论总量
		Integer commentCount = bpInfoService.queryCmsCommentCount(infoId);
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		mv.addObject("commentCount", commentCount);
		mv.addObject("bpInfo", bpInfo);
		mv.setViewName("wechat/bpChuanzhou/chuanzhouDetail");
		return mv;
	}

	// 详情页点赞
	@RequestMapping("addInfoUserWantgo")
	@ResponseBody
	public void addInfoUserWantgo(String bpInfoId, String userId) {
		try {
			bpInfoService.addInfoUserWantgo(bpInfoId, userId);
		} catch (Exception e) {
			logger.error("add addInfoUserWantgo error" + e.getMessage());
		}
	}

	// 详情页取消点赞
	@RequestMapping("delInfoUserWantgo")
	@ResponseBody
	public void delInfoUserWantgo(String bpInfoId, String userId) {
		bpInfoService.delInfoUserWantgo(bpInfoId, userId);
	}
}
