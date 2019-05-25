package com.sun3d.why.controller.front;

import com.sun3d.why.model.*;
import com.sun3d.why.service.*;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.webservice.service.TerminalUserAppService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("beipiaoInfo")
public class BpInfoFrontController {
	private Logger logger = LoggerFactory.getLogger(BpInfoFrontController.class);

	@Autowired
	private BpInfoService bpInfoService;

	@Autowired
	private BpCarouselService bpCarouselservice;

	@Autowired
	private BpInfoTagServcie bpInfoTagServcie;

	@Autowired
	private CmsCommentService cmsCommentService;

	@Autowired
	private TerminalUserAppService terminalUserAppService;

	@Autowired
	private CmsReportService cmsReportService;

	@Autowired
	private HttpSession session;

	@RequestMapping("chuanzhouIndex")
	public ModelAndView chuanzhouIndex(ModelAndView mv) {

		List<BpInfo> jinribeipiaoList = bpInfoService.queryRecommendListByTag("jinribeipiao");
		List<BpInfo> lishiwenhuaList = bpInfoService.queryRecommendListByTag("lishiwenhua");
		List<BpInfo> wenhualvyouList = bpInfoService.queryRecommendListByTag("wenhualvyou");
		List<BpInfo> chuanzhoumeishiList = bpInfoService.queryRecommendListByTag("chuanzhoumeishi");
		List<BpInfo> wenhuayichanList = bpInfoService.queryRecommendListByTag("wenhuayichan");

		mv.setViewName("index/chuanzhou/chuanzhouIndex");
		mv.addObject("jinribeipiaoList", jinribeipiaoList);
		mv.addObject("lishiwenhuaList", lishiwenhuaList);
		mv.addObject("wenhualvyouList", wenhualvyouList);
		mv.addObject("chuanzhoumeishiList", chuanzhoumeishiList);
		mv.addObject("wenhuayichanList", wenhuayichanList);
		return mv;
	}

	@RequestMapping("bpCarouselList")
	@ResponseBody
	public List<BpCarousel> bpCarouselList(Integer carouselType) {
		List<BpCarousel> resultList = null;

		resultList = bpCarouselservice.queryBpCarouselList(carouselType);

		return resultList;
	}

	// 资讯详情页
	@RequestMapping("bpInfoDetail")
	public ModelAndView bpInfoDetail(ModelAndView mv, String infoId) {
		// 推荐位管理
		List<BpInfo> recommendList = bpInfoService.queryRecommendList(infoId);
		mv.addObject("recommendList", recommendList);
		// 详情页资讯信息
		BpInfo bpInfo = bpInfoService.queryBpInfo(infoId);
		mv.addObject("bpInfo", bpInfo);
		// 标签位置信息(至存放父子标签信息)
		BpInfo bpTagInfo = bpInfoService.queryBpTagInfo(infoId);
		mv.addObject("bpTagInfo", bpTagInfo);
		// 详情页评论总量
		Integer commentCount = bpInfoService.queryCmsCommentCount(infoId);
		mv.addObject("commentCount", commentCount);
		// 详情页点攒数
		Integer wantgoCount = bpInfoService.queryWantgoCount(infoId);
		mv.addObject("wantgoCount", wantgoCount);
		CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute("terminalUser");
		// 若处于登录状态，根据用户Id，资讯Id查找是否点赞
		if (terminalUser != null) {
			Integer userIsWant = bpInfoService.queryCountUserIsWant(terminalUser.getUserId(), infoId);
			mv.addObject("userIsWant", userIsWant);
		}
		mv.setViewName("index/chuanzhou/chuanzhouDetail");
		return mv;
	}

	// 资讯详情页评论列表
	@RequestMapping(value = "/commentList")
	@ResponseBody
	public List<CmsComment> commentList(String rkId, Integer pageNum, Integer typeId) {
		// 评论列表
		CmsComment cmsComment = new CmsComment();
		cmsComment.setCommentRkId(rkId);
		cmsComment.setCommentType(typeId);
		Pagination page = new Pagination();
		page.setRows(5);
		page.setPage(pageNum);
		List<CmsComment> commentList = cmsCommentService.queryCommentByCondition(cmsComment, page, null);
		return commentList;
	}

	// 跳转至资讯列表页
	@RequestMapping("chuanzhouList")
	public String chuanzhouList(String infoTagCode, String parentTagCode, HttpServletRequest request, Pagination page) {
		if (infoTagCode == null && parentTagCode != null) {
			List<BpInfoTag> childTagList = bpInfoTagServcie.queryChildTags(parentTagCode);
			if (childTagList.size()!=0) {
				infoTagCode = childTagList.get(0).getTagCode();
			}
		}
		// 加载页面父标签
		List<BpInfoTag> parentTagList = bpInfoTagServcie.queryParentTag();
		request.setAttribute("parentTagList", parentTagList);
		// 加载页面子标签
		List<BpInfoTag> childTagList = bpInfoTagServcie.queryChildTagByChildTag(infoTagCode);
		request.setAttribute("childTagList", childTagList);
		// 设置每页12条数据
		page.setRows(12);
		List<BpInfo> infoList = bpInfoService.queryInfoList(infoTagCode, page);
		request.setAttribute("infoList", infoList);
		request.setAttribute("page", page);

		BpInfoTag parentTagInfo = bpInfoTagServcie.queryParentTagByCode(infoTagCode);
		request.setAttribute("parentTagInfo", parentTagInfo);
		request.setAttribute("infoTagCode", infoTagCode);
		return "index/chuanzhou/chuanzhouList";
	}

	// 点赞
	@RequestMapping("/addUserWantgo")
	public String addUserWantgo(HttpServletResponse response, String relateId, String userId, Integer type)
			throws Exception {
		String json = "";
		try {
			json = terminalUserAppService.addUserWantgo(relateId, userId, type);
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("addUserWantgo error" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	// 取消点攒
	@RequestMapping(value = "/deleteUserWantgo")
	public String deleteUserWantgo(HttpServletResponse response, String relateId, String userId) throws Exception {
		String json = "";
		try {
			json = terminalUserAppService.deleteUserWantgo(relateId, userId);
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("deleteUserWantgo error" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	// 跳转至举报页面
	@RequestMapping("/chuanzhouReport")
	public String chuanzhouReport(HttpServletRequest request, String bpInfoId) {
		request.setAttribute("bpInfoId", bpInfoId);
		return "index/chuanzhou/chuanzhouReport";
	}

	// 提交举报信息
	@RequestMapping(value = "/addReport")
	@ResponseBody
	public String addReport(String bpInfoId, String reportType, String reportContent) {
		CmsTerminalUser user = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
		String userId = null;
		if (user == null) {
			return "timeOut";
		} else {
			userId = user.getUserId();
		}
		try {
			String result = cmsReportService.insertReport(bpInfoId, userId, reportType, reportContent);
			return result;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return Constant.RESULT_STR_FAILURE;
	}
}
