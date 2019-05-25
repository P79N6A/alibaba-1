package com.sun3d.why.controller.wechat;

import java.io.IOException;
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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.culturecloud.enumeration.operation.OperatFunction;
import com.culturecloud.model.bean.brandact.CmsActivityBrand;
import com.culturecloud.model.bean.culture.CcpCultureContestAnswer;
import com.culturecloud.model.bean.culture.CcpCultureContestUser;
import com.culturecloud.model.bean.moviessay.CcpMoviessayArticle;
import com.culturecloud.model.bean.moviessay.CcpMoviessayUser;
import com.culturecloud.model.bean.musicessay.CcpMusicessayArticle;
import com.culturecloud.model.bean.musicessay.CcpMusicessayUser;
import com.culturecloud.model.bean.volunteer.CcpVolunteerApply;
import com.culturecloud.model.request.beautycity.CcpBeautycityImgReqVO;
import com.culturecloud.model.request.beautycity.CcpBeautycityReqVO;
import com.culturecloud.model.request.beautycity.CcpBeautycityVenueReqVO;
import com.culturecloud.model.request.beautycity.CcpBeautycityVoteReqVO;
import com.culturecloud.model.request.contest.QueryQuestionAnswerInfoVO;
import com.culturecloud.model.request.contest.QueryQuestionShareInfoVO;
import com.culturecloud.model.request.contest.QueryTopicPassShareVO;
import com.culturecloud.model.request.contest.QueryTopicPassVO;
import com.culturecloud.model.request.contest.QueryUserTopicResultVO;
import com.culturecloud.model.request.contest.SaveContestUserResultVO;
import com.culturecloud.model.request.heritage.CcpHeritageReqVO;
import com.culturecloud.model.request.live.CcpLiveMessagePageVO;
import com.culturecloud.model.request.live.CcpLiveUserDetailVO;
import com.culturecloud.model.request.live.CcpLiveUserImgPageVO;
import com.culturecloud.model.request.live.SaveLiveUserVO;
import com.culturecloud.model.request.micronote.CcpMicronoteReqVO;
import com.culturecloud.model.request.micronote.CcpMicronoteVoteReqVO;
import com.culturecloud.model.request.special.GetSpecCodeReqVO;
import com.culturecloud.model.request.special.SpecialCodeReqVO;
import com.culturecloud.model.request.special.SpecialCodeUseReqVO;
import com.culturecloud.model.request.special.SpecialNameReqVO;
import com.culturecloud.model.request.volunteer.SaveVolunteerApplyVO;
import com.culturecloud.model.request.volunteer.VolunteerRecruitDetailVO;
import com.culturecloud.model.response.contest.QuestionShareInfoVO;
import com.culturecloud.model.response.contest.TopicShareInfoVO;
import com.culturecloud.model.response.special.SpecChangeIndexResVO;
import com.sun3d.why.annotation.EmojiInspect;
import com.sun3d.why.annotation.SysBusinessLog;
import com.sun3d.why.dao.CmsUserWantgoMapper;
import com.sun3d.why.dao.ccp.CcpMoviessayArticleDto;
import com.sun3d.why.dao.ccp.CcpMusicessayArticleDto;
import com.sun3d.why.dao.dto.CcpCultureContestAnswerDto;
import com.sun3d.why.dao.dto.CcpCultureTeamDto;
import com.sun3d.why.dao.dto.CmsCulturalSquareDto;
import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.CmsUserAnswer;
import com.sun3d.why.model.CmsUserCnAnswer;
import com.sun3d.why.model.CmsUserFxAnswer;
import com.sun3d.why.model.CmsUserMovieAnswer;
import com.sun3d.why.model.ccp.CcpComedy;
import com.sun3d.why.model.ccp.CcpCultureTeamUser;
import com.sun3d.why.model.ccp.CcpCultureTeamVote;
import com.sun3d.why.model.ccp.CcpCultureTeamWorks;
import com.sun3d.why.model.ccp.CcpDrama;
import com.sun3d.why.model.ccp.CcpDramaComment;
import com.sun3d.why.model.ccp.CcpDramaUser;
import com.sun3d.why.model.ccp.CcpDramaVote;
import com.sun3d.why.model.ccp.CcpJiazhouInfo;
import com.sun3d.why.model.ccp.CcpNyImg;
import com.sun3d.why.model.ccp.CcpNyUser;
import com.sun3d.why.model.ccp.CcpNyVote;
import com.sun3d.why.model.ccp.CcpPoem;
import com.sun3d.why.model.ccp.CcpPoemLector;
import com.sun3d.why.model.ccp.CcpPoemUser;
import com.sun3d.why.model.ccp.CcpSceneImg;
import com.sun3d.why.model.ccp.CcpSceneUser;
import com.sun3d.why.model.ccp.CcpSceneVote;
import com.sun3d.why.model.ccp.CcpWalkImg;
import com.sun3d.why.model.ccp.CcpWalkUser;
import com.sun3d.why.model.ccp.CcpWalkVote;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.model.weixin.resp.News;
import com.sun3d.why.publicWebservice.model.HandWritingImg;
import com.sun3d.why.publicWebservice.service.UserPublicService;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.CcpComedyService;
import com.sun3d.why.service.CcpCultureContestAnswerService;
import com.sun3d.why.service.CcpCultureContestUserService;
import com.sun3d.why.service.CcpCultureTeamService;
import com.sun3d.why.service.CcpDramaService;
import com.sun3d.why.service.CcpMoviessayArticleService;
import com.sun3d.why.service.CcpMoviessayUserService;
import com.sun3d.why.service.CcpMusicessayArticleService;
import com.sun3d.why.service.CcpMusicessayUserService;
import com.sun3d.why.service.CcpNyImgService;
import com.sun3d.why.service.CcpPoemService;
import com.sun3d.why.service.CcpSceneImgService;
import com.sun3d.why.service.CcpWalkImgService;
import com.sun3d.why.service.CcpJiazhouInfoService;
import com.sun3d.why.service.CmsActivityBrandService;
import com.sun3d.why.service.CmsActivityService;
import com.sun3d.why.service.CmsCulturalSquareService;
import com.sun3d.why.service.CmsUserAnswerService;
import com.sun3d.why.service.CmsUserCnAnswerService;
import com.sun3d.why.service.CmsUserFxAnswerService;
import com.sun3d.why.service.CmsUserMovieAnswerService;
import com.sun3d.why.service.UserIntegralDetailService;
import com.sun3d.why.util.BindWS;
import com.sun3d.why.util.CallUtils;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.util.SmsUtil;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.api.util.HttpResponseText;
import com.sun3d.why.webservice.service.ActivityAppService;
import com.sun3d.why.webservice.service.EditorialAppService;
import com.sun3d.why.webservice.service.TerminalUserAppService;
import com.sun3d.why.webservice.service.VenueAppService;

@RequestMapping("/wechatStatic")
@Controller
public class WechatStaticController {

	@Autowired
	private CacheService cacheService;
	@Autowired
	private EditorialAppService editorialAppService;
	@Autowired
	private UserPublicService userPublicService;
	@Autowired
	private CmsUserAnswerService userAnswerService;
	@Autowired
	private CmsUserMovieAnswerService userMovieAnswerService;
	@Autowired
	private CmsUserCnAnswerService userCnAnswerService;
	@Autowired
	private CmsUserFxAnswerService userFxAnswerService;
	@Autowired
	private VenueAppService venueAppService;
	@Autowired
	private TerminalUserAppService terminalUserAppService;
	@Autowired
	private CmsActivityService cmsActivityService;
	@Autowired
	private ActivityAppService activityAppService;
	@Autowired
	private CcpDramaService ccpDramaService;
	@Autowired
	private CcpComedyService ccpComedyService;
	@Autowired
	private CcpNyImgService ccpNyImgService;
	@Autowired
	private CcpWalkImgService ccpWalkImgService;
	@Autowired
	private CcpSceneImgService ccpSceneImgService;
	@Autowired
	private CcpCultureTeamService ccpCultureTeamService;
	@Autowired
	private CmsCulturalSquareService cmsCulturalSquareService;
	@Autowired
	private CmsUserWantgoMapper cmsUserWantgoMapper;
	@Autowired
	private CcpPoemService ccpPoemService;
	@Autowired
	private HttpSession session;
	@Autowired
	private StaticServer staticServer;
	@Autowired
	private CcpMusicessayArticleService ccpMusicessayArticleService;
	@Autowired
	private CcpMusicessayUserService ccpMusicessayUserService;
	@Autowired
	private CcpMoviessayArticleService ccpMoviessayArticleService;
	@Autowired
	private CcpMoviessayUserService ccpMoviessayUserService;
	@Autowired
	private CcpCultureContestUserService ccpCultureContestUserService;
	@Autowired
	private CcpCultureContestAnswerService ccpCultureContestAnswerSerice;
	@Autowired
	private SmsUtil SmsUtil;
	@Autowired
	private CmsActivityBrandService cmsActivityBrandService;
	@Autowired
    private UserIntegralDetailService userIntegralDetailService;
	@Autowired
    private CcpJiazhouInfoService ccpJiazhouInfoService;

	private Logger logger = LoggerFactory.getLogger(WechatStaticController.class);

	/**
	 * 跳转到爱童心
	 * 
	 * @return
	 */
	@RequestMapping(value = "/aitongxin")
	public String aitongxin(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/static/aitongxin";
	}

	/**
	 * 跳转到金山
	 * 
	 * @return
	 */
	@RequestMapping(value = "/jinshan")
	public String jinshan(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/static/jinshan";
	}

	/**
	 * 跳转到轻文艺
	 * 
	 * @return
	 */
	@RequestMapping(value = "/qingwescenei")
	public String qingwenyi(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/static/qingwenyi";
	}

	/**
	 * 跳转到畅想文化生活新体验
	 * 
	 * @return
	 */
	@RequestMapping(value = "/guide")
	public String index(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/static/guide";
	}

	/**
	 * 跳转到文化云活动周刊
	 * 
	 * @param request
	 * @param activityType
	 *            活动类型ID，全部为空
	 * @return
	 */
	@RequestMapping(value = "/magazine")
	@SysBusinessLog(remark = "跳转到文化云活动周刊", operation = OperatFunction.HDZK)
	public String magazine(HttpServletRequest request, String activityType) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		request.setAttribute("activityType", activityType);

		String relativeUrl = BindWS.getRelativeUrl(request);
		request.setAttribute("url", relativeUrl);
		return "wechat/static/magazine";
	}

	/**
	 * 抓取采编库+活动列表
	 * 
	 * @param response
	 * @param activityType
	 * @param userId
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/wcMagazineList")
	public String wcEditorialList(HttpServletResponse response, String activityType, String userId) throws Exception {
		String json = "";
		try {
			json = editorialAppService.queryAppEditAndActivityList(activityType, userId);
		} catch (Exception e) {
			json = JSONResponse.toAppResultFormat(500, e.getMessage());
			logger.info("query activityBanner error" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * why3.5 app用户报名采编接口
	 * 
	 * @param activityId
	 *            采编id
	 * @param userId
	 *            用户id return
	 */
	@RequestMapping(value = "/wcAddEditorialUserWantgo")
	public String wcAddEditorialUserWantgo(HttpServletResponse response, String activityId, String userId)
			throws Exception {
		String json = "";
		try {
			if (StringUtils.isNotBlank(activityId) && StringUtils.isNotBlank(userId)) {
				json = editorialAppService.addEditorialUserWantgo(activityId, userId);
			} else {
				json = JSONResponse.toAppResultFormat(10107, "采编id或用户id缺失");
			}
		} catch (Exception e) {
			json = JSONResponse.toAppResultFormat(11111, e.getMessage());
			logger.error("appAddEditorialUserWantgo error" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * why3.5 app用户取消报名采编接口
	 * 
	 * @param activityId
	 *            采编id
	 * @param userId
	 *            用户id return
	 */
	@RequestMapping(value = "/deleteEditorialUserWantgo")
	public String deleteEditorialUserWantgo(HttpServletResponse response, String activityId, String userId)
			throws Exception {
		String json = "";
		try {
			if (StringUtils.isNotBlank(activityId) && StringUtils.isNotBlank(userId)) {
				json = editorialAppService.deleteEditorialUserWantgo(activityId, userId);
			} else {
				json = JSONResponse.toAppResultFormat(10107, "采编id或用户id缺失");
			}
		} catch (Exception e) {
			json = JSONResponse.toAppResultFormat(11111, e.getMessage());
			logger.error("deleteEditorialUserWantgo error" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * 跳转到文化云系列活动
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/series")
	public String series(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);

		String relativeUrl = BindWS.getRelativeUrl(request);
		request.setAttribute("url", relativeUrl);
		return "wechat/static/series";
	}

	/**
	 * 系列活动图片列表
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/seriesImgList")
	@ResponseBody
	public List<HandWritingImg> seriesImgList(HttpServletRequest request, String pageIndex, String pageNum,
			PaginationApp pageApp, String userId) {
		pageApp.setFirstResult(Integer.valueOf(pageIndex));
		pageApp.setRows(Integer.valueOf(pageNum));
		List<HandWritingImg> list = null;
		try {
			list = userPublicService.querySeriesImgList(pageApp, userId);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	/**
	 * 系列活动保存图片
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/seriesSaveImg")
	@ResponseBody
	public String seriesSaveImg(HttpServletRequest request, String userId, String url) {
		HandWritingImg handWritingImg = new HandWritingImg();
		handWritingImg.setId(UUIDUtils.createUUId());
		handWritingImg.setUserId(userId);
		handWritingImg.setCreateTime(new Date());
		handWritingImg.setImgUrl(url);
		handWritingImg.setUpdateType(3);
		return userPublicService.insert(handWritingImg);
	}

	/**
	 * 系列活动删除图片
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/seriesImgDel")
	@ResponseBody
	public String seriesImgDel(HttpServletRequest request, String userId) {
		return userPublicService.seriesImgDel(userId);
	}

	/**
	 * 跳转到文化云电影节活动
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/movies")
	public String movies(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);

		String relativeUrl = BindWS.getRelativeUrl(request);
		request.setAttribute("url", relativeUrl);
		return "wechat/static/movies";
	}

	/**
	 * 跳转到文化云媒体矩阵
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/media")
	public String media(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/static/media";
	}

	/*************************************************** 电影节问答 **************************************************************************/

	/**
	 * 跳转到电影节问答首页
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/movieAnswer")
	public String movieAnswer(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/static/movieAnswer/index";
	}

	/**
	 * 跳转到电影节分享炫耀页面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/movieShare")
	public String movieShare(HttpServletRequest request, Integer userScore) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);

		CmsTerminalUser sessionUser = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
		if (null != sessionUser) {
			if (StringUtils.isNotBlank(sessionUser.getUserId())) {
				CmsUserMovieAnswer result = userMovieAnswerService.statisticsMovieAnswer(userScore,
						sessionUser.getUserId());
				request.setAttribute("total", result.getTotal());
				request.setAttribute("ranking", result.getRanking());
				request.setAttribute("proportion", result.getProportion());
				request.setAttribute("userScore", userScore);
				request.setAttribute("userName", result.getUserName());
				String userHeadImgUrl = "";
				if (StringUtils.isNotBlank(result.getUserHeadImgUrl())) {
					if (result.getUserHeadImgUrl().contains("http://")) {
						userHeadImgUrl = result.getUserHeadImgUrl();
					} else {
						userHeadImgUrl = staticServer.getStaticServerUrl() + result.getUserHeadImgUrl();
					}
				}
				request.setAttribute("userHeadImgUrl", userHeadImgUrl);
				return "wechat/static/movieAnswer/share";
			}
		}
		return "wechat/static/movieAnswer/index";
	}

	/**
	 * 跳转到电影节补填信息页面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/movieInfo")
	public String movieInfo(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);

		CmsTerminalUser sessionUser = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
		if (null != sessionUser) {
			if (StringUtils.isNotBlank(sessionUser.getUserId())) {
				CmsUserMovieAnswer result = userMovieAnswerService.queryMovieUserInfo(sessionUser.getUserId());
				request.setAttribute("userName", result.getUserName());
				request.setAttribute("userMobile", result.getUserMobile());
				return "wechat/static/movieAnswer/info";
			}
		}
		return "wechat/static/movieAnswer/index";
	}

	/**
	 * 保存或更新电影节问答信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/saveOrUpdateMovieAnswer")
	@ResponseBody
	public String saveOrUpdateMovieAnswer(HttpServletRequest request, CmsUserMovieAnswer cmsUserMovieAnswer) {
		return userMovieAnswerService.saveOrUpdateMovieAnswer(cmsUserMovieAnswer);
	}

	/**
	 * 电影节问答保存虚拟用户数据
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/saveMovieAnswerData")
	@ResponseBody
	public String saveMovieAnswerData(HttpServletRequest request) {
		return userMovieAnswerService.saveMovieAnswerData();
	}

	/***************************************************
	 * 百个全叔（文化竞赛）
	 **************************************************************************/

	/**
	 * 跳转到百科全叔首页
	 * 
	 * @return
	 */
	@RequestMapping(value = "/contest")
	@SysBusinessLog(remark = "跳转到百科全叔首页（文化竞赛）", operation = OperatFunction.WHJS)
	public String contest(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);

		HttpResponseText res = CallUtils
				.callUrlHttpPost(staticServer.getPlatformDataUrl() + "contestUserResult/getAllUserNum", null);
		JSONObject jsonObject = JSON.parseObject(res.getData());
		request.setAttribute("userSum", Integer.parseInt(jsonObject.get("data").toString()) + 1670);
		return "wechat/static/contest/index";
	}

	/**
	 * 跳转到百科全叔主题页
	 * 
	 * @return
	 */
	@RequestMapping(value = "/topic")
	public String topic(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);

		HttpResponseText res = CallUtils
				.callUrlHttpPost(staticServer.getPlatformDataUrl() + "contestUserResult/getAllUserNum", null);
		JSONObject jsonObject = JSON.parseObject(res.getData());
		request.setAttribute("userSum", Integer.parseInt(jsonObject.get("data").toString()) + 1670);
		return "wechat/static/contest/topic";
	}

	/**
	 * 跳转到百科全叔选题页
	 * 
	 * @return
	 */
	@RequestMapping(value = "/question")
	public String question(HttpServletRequest request, String topicId) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		request.setAttribute("topicId", topicId);

		HttpResponseText res = CallUtils
				.callUrlHttpPost(staticServer.getPlatformDataUrl() + "contestUserResult/getAllUserNum", null);
		JSONObject jsonObject = JSON.parseObject(res.getData());
		request.setAttribute("userSum", Integer.parseInt(jsonObject.get("data").toString()) + 1670);
		return "wechat/static/contest/question";
	}

	/**
	 * 跳转到百科全叔答题页
	 * 
	 * @return
	 */
	@RequestMapping(value = "/answer")
	public String answer(HttpServletRequest request, String topicId, String questionId, String passStr, String sum) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		request.setAttribute("questionId", questionId);
		request.setAttribute("topicId", topicId);
		request.setAttribute("passStr", passStr);
		request.setAttribute("sum", sum);

		HttpResponseText res = CallUtils
				.callUrlHttpPost(staticServer.getPlatformDataUrl() + "contestUserResult/getAllUserNum", null);
		JSONObject jsonObject = JSON.parseObject(res.getData());
		request.setAttribute("userSum", Integer.parseInt(jsonObject.get("data").toString()) + 1670);
		return "wechat/static/contest/answer";
	}

	/**
	 * 跳转到百科全叔升级页
	 * 
	 * @return
	 */
	@RequestMapping(value = "/upgrade")
	public String upgrade(HttpServletRequest request, QueryQuestionShareInfoVO vo) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);

		HttpResponseText res = CallUtils
				.callUrlHttpPost(staticServer.getPlatformDataUrl() + "contestQuestion/getQuestionShareInfo", vo);
		JSONObject jsonObject = JSON.parseObject(res.getData());
		QuestionShareInfoVO questionShareInfoVO = JSON.parseObject(jsonObject.get("data").toString(),
				QuestionShareInfoVO.class);
		request.setAttribute("passName", questionShareInfoVO.getPassName());
		request.setAttribute("ranking", Integer.parseInt(questionShareInfoVO.getRanking()) + 1260); // 假数据
		request.setAttribute("passNumber", vo.getPassNumber());
		request.setAttribute("topicId", vo.getTopicId());
		request.setAttribute("topicTitle", questionShareInfoVO.getTopicTitle());
		request.setAttribute("topicName", questionShareInfoVO.getTopicName());
		return "wechat/static/contest/upgrade";
	}

	/**
	 * 跳转到百科全叔通关页
	 * 
	 * @return
	 */
	@RequestMapping(value = "/pass")
	public String pass(HttpServletRequest request, QueryTopicPassShareVO vo, String userId) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);

		HttpResponseText res = CallUtils
				.callUrlHttpPost(staticServer.getPlatformDataUrl() + "contestTopicPass/getTopicShareInfo", vo);
		JSONObject jsonObject = JSON.parseObject(res.getData());
		TopicShareInfoVO topicShareInfoVO = JSON.parseObject(jsonObject.get("data").toString(), TopicShareInfoVO.class);
		request.setAttribute("topicName", topicShareInfoVO.getTopicName());
		request.setAttribute("topicTitle", topicShareInfoVO.getTopicTitle());
		request.setAttribute("passName", topicShareInfoVO.getPassName());
		request.setAttribute("passText", topicShareInfoVO.getPassText());
		request.setAttribute("ranking", Integer.parseInt(topicShareInfoVO.getRanking()) + 120); // 假数据

		if (StringUtils.isNotBlank(userId)) {
			String userHeadImgUrl = terminalUserAppService.queryTerminalUserByUserId(userId).getUserHeadImgUrl();
			request.setAttribute("userHeadImgUrl", userHeadImgUrl);
		}
		return "wechat/static/contest/pass";
	}

	/**
	 * 获得全部主题
	 * 
	 * @return
	 */
	@RequestMapping(value = "/getAllTopics")
	public String getAllTopics(HttpServletResponse response) throws Exception {
		HttpResponseText res = CallUtils
				.callUrlHttpPost(staticServer.getPlatformDataUrl() + "contestTopic/getAllTopics", null);
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * 获取主题下的关卡信息
	 * 
	 * @return
	 */
	@RequestMapping(value = "/getTopicPassInfo")
	public String getTopicPassInfo(HttpServletResponse response, QueryTopicPassVO vo) throws Exception {
		HttpResponseText res = CallUtils
				.callUrlHttpPost(staticServer.getPlatformDataUrl() + "contestTopicPass/getTopicPassInfo", vo);
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * 获取试题的题目信息
	 * 
	 * @return
	 */
	@RequestMapping(value = "/getQuestionAnswerInfo")
	public String getQuestionAnswerInfo(HttpServletResponse response, QueryQuestionAnswerInfoVO vo) throws Exception {
		HttpResponseText res = CallUtils
				.callUrlHttpPost(staticServer.getPlatformDataUrl() + "contestQuestion/getQuestionAnswerInfo", vo);
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * 添加修改用户答题信息
	 * 
	 * @return
	 */
	@RequestMapping(value = "/saveOrUpdateContestUser")
	public String saveOrUpdateContestUser(HttpServletResponse response, SaveContestUserResultVO vo) throws Exception {
		HttpResponseText res = CallUtils
				.callUrlHttpPost(staticServer.getPlatformDataUrl() + "contestUserResult/saveContestUserResult", vo);
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		;
		response.getWriter().close();
		return null;
	}

	/**
	 * 获取用户答题信息
	 * 
	 * @return
	 */
	@RequestMapping(value = "/getContestUserResult")
	public String getContestUserResult(HttpServletResponse response, QueryUserTopicResultVO vo) throws Exception {
		HttpResponseText res = CallUtils
				.callUrlHttpPost(staticServer.getPlatformDataUrl() + "contestUserResult/getContestUserResult", vo);
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/*************************************************** 文化地铁 **************************************************************************/

	/**
	 * 跳转到文化地铁
	 * 
	 * @return
	 */
	@RequestMapping(value = "/subway")
	@SysBusinessLog(remark = "跳转到文化地铁", operation = OperatFunction.WHDT)
	public String subway(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/static/venue/subway";
	}

	/*************************************************** 热门场馆 **************************************************************************/

	/**
	 * 跳转到热门场馆
	 * 
	 * @return
	 */
	@RequestMapping(value = "/hotVenue")
	@SysBusinessLog(remark = "跳转到热门场馆", operation = OperatFunction.RMCG)
	public String hotVenue(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/static/venue/hotVenue";
	}

	/**
	 * 热门场馆点赞数、评论数
	 * 
	 * @param response
	 * @param venueId
	 * @param userId
	 * @return
	 */
	@RequestMapping(value = "/hotVenueInfo")
	public String hotVenueInfo(HttpServletResponse response, String venueId, String userId) throws Exception {
		String json = "";
		try {
			if (StringUtils.isNotBlank(venueId)) {
				json = venueAppService.queryHotVenueInfo(venueId, userId);
			} else {
				json = JSONResponse.commonResultFormat(10107, "场馆对象id缺失", null);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().print(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/*************************************************** 场馆相关活动列表 **************************************************************************/

	/**
	 * 跳转到场馆相关活动列表
	 * 
	 * @return
	 */
	@RequestMapping(value = "/venueActivity")
	@SysBusinessLog(remark = "跳转到场馆相关活动列表", operation = OperatFunction.CGHD)
	public String venueActivity(HttpServletRequest request, String venueId) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		request.setAttribute("venueId", venueId);
		return "wechat/static/venue/venueActivity";
	}

	/***************************************************
	 * 海派小品-文脉虹口
	 **************************************************************************/

	/**
	 * 跳转到海派小品-文脉虹口(原虹口区文化馆相关活动列表)
	 * 
	 * @return
	 */
	@RequestMapping(value = "/hkVenue")
	@SysBusinessLog(remark = "跳转到海派小品-文脉虹口", operation = OperatFunction.HKHD)
	public String hkVenue(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/static/hkActivity";
	}

	/*************************************************** 奉贤相关活动列表 **************************************************************************/

	/**
	 * 跳转到奉贤相关活动列表
	 * 
	 * @return
	 */
	@RequestMapping(value = "/fxActivity")
	@SysBusinessLog(remark = "跳转到奉贤相关活动列表", operation = OperatFunction.FXHD)
	public String fxActivity(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/static/fxActivity";
	}

	/*************************************************** 非物质文化遗产 **************************************************************************/

	/**
	 * 跳转到非遗页面
	 * 
	 * @return
	 */
	@RequestMapping(value = "/heritageList")
	@SysBusinessLog(remark = "跳转到非物质文化遗产", operation = OperatFunction.WHFY)
	public String heritageList(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/static/heritage/heritageList";
	}

	/**
	 * 获取非遗列表
	 * 
	 * @return
	 */
	@RequestMapping(value = "/getCcpHeritageList")
	public String getCcpHeritageList(HttpServletResponse response, CcpHeritageReqVO vo) throws Exception {
		HttpResponseText res = CallUtils
				.callUrlHttpPost(staticServer.getPlatformDataUrl() + "heritage/getCcpHeritageList", vo);
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * 跳转到非遗详情页面
	 * 
	 * @return
	 */
	@RequestMapping(value = "/heritageDetail")
	public String heritageDetail(HttpServletRequest request, String heritageId) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		request.setAttribute("heritageId", heritageId);
		return "wechat/static/heritage/heritageDetail";
	}

	/**
	 * 获取非遗详情
	 * 
	 * @return
	 */
	@RequestMapping(value = "/getCcpHeritageDetail")
	public String getCcpHeritageDetail(HttpServletResponse response, CcpHeritageReqVO vo) throws Exception {
		HttpResponseText res = CallUtils
				.callUrlHttpPost(staticServer.getPlatformDataUrl() + "heritage/getCcpHeritageById", vo);
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}
	
	/*************************************************** 古韵嘉州 **************************************************************************/
	
	/**
	 * 跳转到嘉州页面
	 * 
	 * @return
	 */
	@RequestMapping(value = "/jiazhouInfoList")
	public String jiazhouInfoList(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/static/jiazhouInfo/jiazhouInfoList";
	}
	
	/**
	 * 获取嘉州列表
	 * 
	 * @return
	 */
	@RequestMapping(value = "/getCcpJiazhouInfoList")
	@ResponseBody
	public Map<String, Object> getCcpJiazhouInfoList(CcpJiazhouInfo cJiazhouInfo) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
		 try {
			 List<CcpJiazhouInfo> jiazhouInfoLists = ccpJiazhouInfoService.jiazhouInfoList(cJiazhouInfo);
			    result.put("status", 200);
	            result.put("data", jiazhouInfoLists);
	        } catch (Exception e) {
	            e.printStackTrace();
	            result.put("status", 500);
	            result.put("data", e.getMessage());
	        }
		 return result;
	}
	
	/**
	 * 跳转到嘉州详情页面
	 * 
	 * @return
	 */
	@RequestMapping(value = "/jiazhouInfoDetail")
	public String jiazhouInfoDetail(HttpServletRequest request, String jiazhouInfoId,String userId) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		CcpJiazhouInfo jiazhouInfo = ccpJiazhouInfoService.getCcpJiazhouInfoDetail(jiazhouInfoId,userId);
		request.setAttribute("jiazhouInfo", jiazhouInfo);
		request.setAttribute("jiazhouInfoId", jiazhouInfoId);
		return "wechat/static/jiazhouInfo/jiazhouInfoDetail";
	}
	
	/**
	 * 获取嘉州详情
	 * 
	 * @return
	 */
	@RequestMapping(value = "/getCcpJiazhouInfoDetail")
	@ResponseBody
	public Map<String, Object> getCcpJiazhouInfoDetail(String jiazhouInfoId,String userId) throws Exception {
		Map<String, Object> result = new HashMap<String, Object>();
        try {
			 CcpJiazhouInfo jiazhouInfo = ccpJiazhouInfoService.getCcpJiazhouInfoDetail(jiazhouInfoId,userId);	
			    result.put("status", 200);
			    result.put("data", jiazhouInfo);
	        } catch (Exception e) {
	            e.printStackTrace();
	            result.put("status", 500);
	            result.put("data", e.getMessage());
	        }
		 return result;
	}
	
	
	/*************************************************** 微笔记投票大赛 **************************************************************************/

	/**
	 * 跳转到微笔记大赛引导页
	 * 
	 * @return
	 */
	@RequestMapping(value = "/micronote")
	@SysBusinessLog(remark = "跳转到微笔记投票大赛", operation = OperatFunction.WBJDS)
	public String micronote(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/static/micronote/micronoteIndex";
	}

	/**
	 * 跳转到微笔记大赛首页
	 * 
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping(value = "/toMicronoteList")
	public String toNoteList(HttpServletRequest request) throws ParseException {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);

		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date endTime = df.parse("2016-09-15 23:59:59");
		Date voteTime = df.parse("2016-09-23 23:59:59");
		if (endTime.before(new Date())) {
			request.setAttribute("isEnd", 1);
		}
		if (voteTime.before(new Date())) {
			request.setAttribute("isVote", 1);
		}
		return "wechat/static/micronote/micronoteList";
	}

	/**
	 * 跳转到微笔记大赛排名页
	 * 
	 * @return
	 */
	@RequestMapping(value = "/toMicronoteRanking")
	public String toMicronoteRanking(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/static/micronote/micronoteRanking";
	}

	/**
	 * 跳转到微笔记大赛分享页
	 * 
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping(value = "/toMicronoteShare")
	public String toMicronoteShare(HttpServletRequest request, String noteId) throws ParseException {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		request.setAttribute("noteId", noteId);

		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date voteTime = df.parse("2016-09-23 23:59:59");
		if (voteTime.before(new Date())) {
			request.setAttribute("isVote", 1);
		}
		return "wechat/static/micronote/micronoteShare";
	}

	/**
	 * 跳转到微笔记大赛申请页
	 * 
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping(value = "/toMicronoteApply")
	public String toMicronoteApply(HttpServletRequest request) throws ParseException {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);

		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date endTime = df.parse("2016-09-15 23:59:59");
		if (endTime.before(new Date())) {
			request.setAttribute("isEnd", 1);
		}
		return "wechat/static/micronote/micronoteApply";
	}

	/**
	 * 获取微笔记列表
	 * 
	 * @return
	 */
	@RequestMapping(value = "/getMicronoteList")
	public String getMicronoteList(HttpServletResponse response, CcpMicronoteReqVO vo) throws Exception {
		HttpResponseText res = CallUtils
				.callUrlHttpPost(staticServer.getPlatformDataUrl() + "micronote/getMicronoteList", vo);
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * 获取微笔记排名列表
	 * 
	 * @return
	 */
	@RequestMapping(value = "/getMicronoteRankingList")
	public String getMicronoteRankingList(HttpServletResponse response, CcpMicronoteReqVO vo) throws Exception {
		HttpResponseText res = CallUtils
				.callUrlHttpPost(staticServer.getPlatformDataUrl() + "micronote/getMicronoteRankingList", vo);
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * 根据userId或noteId获取微笔记信息
	 * 
	 * @return
	 */
	@RequestMapping(value = "/getMicronoteByCondition")
	public String getMicronoteByUserId(HttpServletResponse response, CcpMicronoteReqVO vo) throws Exception {
		HttpResponseText res = CallUtils
				.callUrlHttpPost(staticServer.getPlatformDataUrl() + "micronote/getMicronoteByCondition", vo);
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * 保存微笔记信息
	 * 
	 * @return
	 */
	@RequestMapping(value = "/saveMicronote")
	@EmojiInspect
	public String saveMicronote(HttpServletResponse response, CcpMicronoteReqVO vo) throws Exception {
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date endTime = df.parse("2016-09-15 23:59:59");
		HttpResponseText res = new HttpResponseText();
		if (endTime.before(new Date())) {
			res.setData("活动已结束");
		} else {
			vo.setNoteId(UUIDUtils.createUUId());
			vo.setCreateTime(new Date());
			vo.setUpdateTime(new Date());
			res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl() + "micronote/saveMicronote", vo);
		}

		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * 微笔记投票
	 * 
	 * @return
	 */
	@RequestMapping(value = "/voteMicronote")
	public String voteMicronote(HttpServletResponse response, CcpMicronoteVoteReqVO vo) throws Exception {
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date voteTime = df.parse("2016-09-23 23:59:59");
		HttpResponseText res = new HttpResponseText();
		if (voteTime.before(new Date())) {
			res.setData("活动已结束");
		} else {
			vo.setNoteVoteId(UUIDUtils.createUUId());
			vo.setCreateTime(new Date());
			res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl() + "micronote/voteMicronote", vo);
		}

		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/*************************************************** 文化志愿者 **************************************************************************/

	/**
	 * 志愿者招募首页
	 * 
	 * @return
	 */
	@RequestMapping("/volunteerRecruitIndex")
	@SysBusinessLog(remark = "跳转到文化志愿者招募", operation = OperatFunction.WHZYZ)
	public String volunteerRecruitList(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/static/volunteer/recruitList";
	}

	/**
	 * 招募列表
	 * 
	 * @return
	 */
	@RequestMapping(value = "/getVolunteerRecruitList")
	public String getVolunteerRecruitList(HttpServletResponse response) throws Exception {
		HttpResponseText res = CallUtils
				.callUrlHttpPost(staticServer.getPlatformDataUrl() + "volunteerRecruit/recruitList", "{}");
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * 招募详情
	 * 
	 * @return
	 */
	@RequestMapping(value = "/toVolunteerDetail")
	public String toVolunteerDetail(@RequestParam String recruitId, HttpServletRequest request) throws Exception {

		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		request.setAttribute("recruitId", recruitId);

		return "wechat/static/volunteer/volunteerDetail";
	}

	@RequestMapping(value = "/getVolunteerDetail")
	public String getVolunteerDetail(@RequestParam String recruitId, HttpServletResponse response) throws Exception {

		VolunteerRecruitDetailVO requestVO = new VolunteerRecruitDetailVO();
		requestVO.setRecruitId(recruitId);

		HttpResponseText res = CallUtils
				.callUrlHttpPost(staticServer.getPlatformDataUrl() + "volunteerRecruit/recruitDetail", requestVO);

		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * 我要报名 创建申请人
	 * 
	 * @param recruitId
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/createVolunteerApply")
	public String createVolunteerApply(String recruitId, HttpServletRequest request) {

		request.setAttribute("recruitId", recruitId);

		return "wechat/static/volunteer/createVolunteerApply";
	}

	@RequestMapping(value = "/saveVolunteerApply")
	@EmojiInspect
	public String saveVolunteerApply(CcpVolunteerApply acpVolunteerApply, String[] volunteerApplyPic,
			HttpServletResponse response) throws Exception {

		SaveVolunteerApplyVO requestVO = new SaveVolunteerApplyVO();

		requestVO.setAcpVolunteerApply(acpVolunteerApply);
		requestVO.setVolunteerApplyPic(volunteerApplyPic);

		HttpResponseText res = CallUtils
				.callUrlHttpPost(staticServer.getPlatformDataUrl() + "volunteerRecruit/applyVolunteer", requestVO);

		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/*************************************************** 奉贤问答 **************************************************************************/

	/**
	 * 跳转到奉贤问答首页
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/fxAnswer")
	public String fxAnswer(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/static/fxAnswer/index";
	}

	/**
	 * 跳转到奉贤分享炫耀页面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/fxAnswerShare")
	public String fxAnswerShare(HttpServletRequest request, Integer userScore, String userId) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);

		if (null != userId) {
			CmsUserFxAnswer result = userFxAnswerService.queryFxUserInfo(userId);
			request.setAttribute("userName", result.getUserName());
			request.setAttribute("userScore", userScore);
			return "wechat/static/fxAnswer/share";
		}
		return "wechat/static/fxAnswer/index";
	}

	/**
	 * 跳转到奉贤补填信息页面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/fxAnswerInfo")
	public String fxAnswerInfo(HttpServletRequest request, String userId) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);

		if (null != userId) {
			CmsUserFxAnswer result = userFxAnswerService.queryFxUserInfo(userId);
			request.setAttribute("userName", result.getUserName());
			request.setAttribute("userMobile", result.getUserMobile());
			String userHeadImgUrl = "";
			if (StringUtils.isNotBlank(result.getUserHeadImgUrl())) {
				if (result.getUserHeadImgUrl().contains("http://")) {
					userHeadImgUrl = result.getUserHeadImgUrl();
				} else {
					userHeadImgUrl = staticServer.getStaticServerUrl() + result.getUserHeadImgUrl();
				}
			}
			request.setAttribute("userHeadImgUrl", userHeadImgUrl);
			return "wechat/static/fxAnswer/info";
		}
		return "wechat/static/fxAnswer/index";
	}

	/**
	 * 保存或更新奉贤问答信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/saveOrUpdateFxAnswer")
	@ResponseBody
	public String saveOrUpdateFxAnswer(HttpServletRequest request, CmsUserFxAnswer cmsUserFxAnswer) {
		return userFxAnswerService.saveOrUpdateFxAnswer(cmsUserFxAnswer);
	}

	/*************************************************** 发现城市之美 **************************************************************************/

	/**
	 * 跳转到发现城市之美
	 * 
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping(value = "/beautyCity")
	@SysBusinessLog(remark = "跳转到发现城市之美", operation = OperatFunction.CSZM)
	public String beautyCity(HttpServletRequest request, String tagNum) throws ParseException {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		request.setAttribute("tagNum", tagNum);

		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date endTime = df.parse("2016-10-19 23:59:59");
		if (endTime.before(new Date())) {
			request.setAttribute("isEnd", 1);
		}
		return "wechat/static/beautyCity/index";
	}

	/**
	 * 跳转到城市之美拉票页
	 * 
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping(value = "/beautyCityShare")
	public String beautyCityShare(HttpServletRequest request, String beautycityImgId) throws ParseException {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		request.setAttribute("beautycityImgId", beautycityImgId);

		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date endTime = df.parse("2016-10-19 23:59:59");
		if (endTime.before(new Date())) {
			request.setAttribute("isEnd", 1);
		}
		return "wechat/static/beautyCity/share";
	}

	/**
	 * 获取最美城市图片列表
	 * 
	 * @return
	 */
	@RequestMapping(value = "/getBeautycityImgList")
	public String getBeautycityImgList(HttpServletResponse response, CcpBeautycityImgReqVO vo) throws Exception {
		HttpResponseText res = CallUtils
				.callUrlHttpPost(staticServer.getPlatformDataUrl() + "beautycity/getBeautycityImgList", vo);
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * 获取最美城市图片排名列表
	 * 
	 * @return
	 */
	@RequestMapping(value = "/getBeautycityImgRankingList")
	public String getBeautycityImgRankingList(HttpServletResponse response, CcpBeautycityImgReqVO vo) throws Exception {
		HttpResponseText res = CallUtils
				.callUrlHttpPost(staticServer.getPlatformDataUrl() + "beautycity/getBeautycityImgRankingList", vo);
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * 最美城市保存用户信息
	 * 
	 * @return
	 */
	@RequestMapping(value = "/saveBeautycity")
	@EmojiInspect
	public String saveBeautycity(HttpServletResponse response, CcpBeautycityReqVO vo) throws Exception {
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date voteTime = df.parse("2016-10-19 23:59:59");
		HttpResponseText res = new HttpResponseText();
		if (voteTime.before(new Date())) {
			res.setData("活动已结束");
		} else {
			vo.setBeautycityId(UUIDUtils.createUUId());
			vo.setCreateTime(new Date());
			res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl() + "beautycity/saveBeautycity", vo);
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * 最美城市保存图片
	 * 
	 * @return
	 */
	@RequestMapping(value = "/saveBeautycityImg")
	public String saveBeautycityImg(HttpServletResponse response, CcpBeautycityImgReqVO vo) throws Exception {
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date voteTime = df.parse("2016-10-19 23:59:59");
		HttpResponseText res = new HttpResponseText();
		if (voteTime.before(new Date())) {
			res.setData("活动已结束");
		} else {
			vo.setBeautycityImgId(UUIDUtils.createUUId());
			vo.setCreateTime(new Date());
			res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl() + "beautycity/saveBeautycityImg", vo);
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * 最美城市图片投票
	 * 
	 * @return
	 */
	@RequestMapping(value = "/voteBeautycityImg")
	public String voteBeautycityImg(HttpServletResponse response, CcpBeautycityVoteReqVO vo) throws Exception {
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date voteTime = df.parse("2016-10-19 23:59:59");
		HttpResponseText res = new HttpResponseText();
		if (voteTime.before(new Date())) {
			res.setData("活动已结束");
		} else {
			vo.setBeautycityVoteId(UUIDUtils.createUUId());
			vo.setCreateTime(new Date());
			res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl() + "beautycity/voteBeautycityImg", vo);
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * 获取最美城市场馆列表
	 * 
	 * @return
	 */
	@RequestMapping(value = "/getBeautycityVenueList")
	public String getBeautycityVenueList(HttpServletResponse response, CcpBeautycityVenueReqVO vo) throws Exception {
		HttpResponseText res = CallUtils
				.callUrlHttpPost(staticServer.getPlatformDataUrl() + "beautycity/getBeautycityVenueList", vo);
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * 获取最美城市用户信息
	 * 
	 * @return
	 */
	@RequestMapping(value = "/getBeautycityList")
	public String getBeautycityList(HttpServletResponse response, CcpBeautycityVenueReqVO vo) throws Exception {
		HttpResponseText res = CallUtils
				.callUrlHttpPost(staticServer.getPlatformDataUrl() + "beautycity/getBeautycityList", vo);
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/*************************************************** 专题活动banner页 **************************************************************************/

	/**
	 * 跳转到专题活动banner页
	 * 
	 * @return
	 */
	@RequestMapping(value = "/bannerList")
	public String bannerList(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/static/bannerList";
	}

	/*************************************************** 文化竞赛聚合页 **************************************************************************/

	/**
	 * 跳转到文化竞赛聚合页
	 * 
	 * @return
	 */
	@RequestMapping(value = "/contestList")
	public String contestList(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/static/contestList";
	}

	/*************************************************** 曼舞长宁 **************************************************************************/

	/**
	 * 跳转到曼舞长宁页
	 * 
	 * @return
	 */
	@RequestMapping(value = "/cnDance")
	public String cnDance(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/static/cnDance";
	}

	/***************************************************
	 * 长宁歌剧问答(已改为通用项目，非长宁，路径文件名不变)
	 **************************************************************************/

	/**
	 * 跳转到长宁歌剧问答首页
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/cnAnswer")
	public String cnAnswer(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/static/cnAnswer/index";
	}

	/**
	 * 跳转到长宁歌剧问答分享炫耀页面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/cnAnswerShare")
	public String cnAnswerShare(HttpServletRequest request, Integer userScore, String userId) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);

		CmsUserCnAnswer result = userCnAnswerService.statisticsCnAnswer(userScore, userId);
		request.setAttribute("total", result.getTotal());
		request.setAttribute("ranking", result.getRanking());
		request.setAttribute("proportion", result.getProportion());
		request.setAttribute("userScore", userScore);
		request.setAttribute("userName", result.getUserName());
		String userHeadImgUrl = "";
		if (StringUtils.isNotBlank(result.getUserHeadImgUrl())) {
			if (result.getUserHeadImgUrl().contains("http://")) {
				userHeadImgUrl = result.getUserHeadImgUrl();
			} else {
				userHeadImgUrl = staticServer.getStaticServerUrl() + result.getUserHeadImgUrl();
			}
		}
		request.setAttribute("userHeadImgUrl", userHeadImgUrl);

		CmsUserCnAnswer cmsUserCnAnswer = userCnAnswerService.queryCnUserInfo(userId);
		request.setAttribute("isFirst", cmsUserCnAnswer.getUserName() != null ? 0 : 1);
		return "wechat/static/cnAnswer/share";
	}

	/**
	 * 跳转到长宁歌剧问答补填信息页面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/cnAnswerInfo")
	public String cnAnswerInfo(HttpServletRequest request, String userId) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);

		CmsTerminalUser cmsTerminalUser = terminalUserAppService.queryTerminalUserByUserId(userId);
		request.setAttribute("userNickName", cmsTerminalUser.getUserNickName());
		request.setAttribute("userTelephone", cmsTerminalUser.getUserTelephone());
		return "wechat/static/cnAnswer/info";
	}

	/**
	 * 保存或更新长宁歌剧问答信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/saveOrUpdateCnAnswer")
	@ResponseBody
	@EmojiInspect
	public String saveOrUpdateCnAnswer(HttpServletRequest request, CmsUserCnAnswer cmsUserCnAnswer) {
		return userCnAnswerService.saveOrUpdateCnAnswer(cmsUserCnAnswer);
	}

	/**
	 * 长宁歌剧问答保存虚拟用户数据
	 * 
	 * @param request
	 * @param num
	 *            添加数量
	 * @return
	 */
	@RequestMapping(value = "/saveCnAnswerData")
	@ResponseBody
	public String saveCnAnswerData(HttpServletRequest request, Integer num) {
		return userCnAnswerService.saveCnAnswerData(num);
	}

	/***************************************************
	 * 艺术天空（Y码兑换）
	 **************************************************************************/

	/**
	 * 跳转到红星耀中国资讯页
	 * 
	 * @param enterParam
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/redStarIntro")
	public String redStar(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/static/redStar/redStarIntro";
	}

	/***************************************************
	 * 艺术天空（Y码兑换）
	 **************************************************************************/

	/**
	 * 跳转到艺术天空资讯页（专场）
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/artSky")
	public String artSky(HttpServletRequest request) throws ParseException {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);

		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date orderTime = df.parse("2016-10-10 15:00:00");
		if (orderTime.before(new Date())) {
			request.setAttribute("isOrder", 1);
		}
		return "wechat/static/artSky/artSky";
	}

	/**
	 * 跳转到艺术天空首页
	 * 
	 * @param enterParam
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/artSkyIndex")
	public String artSkyIndex(HttpServletRequest request, String enterParam) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		request.setAttribute("enterParam", enterParam);

		SpecialNameReqVO vo = new SpecialNameReqVO();
		vo.setSpecialName(enterParam);
		HttpResponseText res = CallUtils
				.callUrlHttpPost(staticServer.getPlatformDataUrl() + "specialchange/getImageByChannelName", vo);
		JSONObject jsonObject = JSON.parseObject(res.getData());
		SpecChangeIndexResVO resVo = JSON.parseObject(jsonObject.get("data").toString(), SpecChangeIndexResVO.class);
		request.setAttribute("enterName", resVo.getEnterName());
		request.setAttribute("enterLogoImageUrl", resVo.getLogoImage());
		request.setAttribute("enterId", resVo.getEnterId());
		return "wechat/static/artSky/index";
	}

	/**
	 * 跳转到艺术天空Y码索取页
	 * 
	 * @param enterParam
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/artSkyInfo")
	public String artSkyInfo(HttpServletRequest request, String enterParam) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		request.setAttribute("enterParam", enterParam);

		SpecialNameReqVO vo = new SpecialNameReqVO();
		vo.setSpecialName(enterParam);
		HttpResponseText res = CallUtils
				.callUrlHttpPost(staticServer.getPlatformDataUrl() + "specialchange/getImageByChannelName", vo);
		JSONObject jsonObject = JSON.parseObject(res.getData());
		SpecChangeIndexResVO resVo = JSON.parseObject(jsonObject.get("data").toString(), SpecChangeIndexResVO.class);
		request.setAttribute("enterName", resVo.getEnterName());
		request.setAttribute("enterLogoImageUrl", resVo.getLogoImage());
		request.setAttribute("enterId", resVo.getEnterId());
		return "wechat/static/artSky/info";
	}

	/**
	 * 跳转到艺术天空列表页
	 * 
	 * @param enterParam
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/artSkyList")
	public String artSkyList(HttpServletRequest request, String ycode, String enterParam) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		request.setAttribute("ycode", ycode);
		request.setAttribute("enterParam", enterParam);

		SpecialNameReqVO vo = new SpecialNameReqVO();
		vo.setSpecialName(enterParam);
		HttpResponseText res = CallUtils
				.callUrlHttpPost(staticServer.getPlatformDataUrl() + "specialchange/getImageByChannelName", vo);
		JSONObject jsonObject = JSON.parseObject(res.getData());
		SpecChangeIndexResVO resVo = JSON.parseObject(jsonObject.get("data").toString(), SpecChangeIndexResVO.class);
		request.setAttribute("enterName", resVo.getEnterName());
		request.setAttribute("enterLogoImageUrl", resVo.getLogoImage());
		request.setAttribute("enterId", resVo.getEnterId());
		return "wechat/static/artSky/list";
	}

	/**
	 * 跳转到艺术天空填写个人信息
	 * 
	 * @param enterParam
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/artSkyUserInfo")
	public String userInfo(HttpServletRequest request) {

		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);

		return "wechat/static/artSky/userInfo";
	}

	@RequestMapping(value = "/artSkyUserSuccess")
	public String artSkyUserSuccess(HttpServletRequest request) {

		return "wechat/static/artSky/userInfoSuccess";
	}

	/**
	 * 索取Y码(保存用户信息)
	 * 
	 * @return
	 */
	@RequestMapping(value = "/getYCode")
	public String getYCode(HttpServletResponse response, GetSpecCodeReqVO vo) throws Exception {
		HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl() + "specialchange/getYCode",
				vo);
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * 根据Y码展示活动LIST
	 * 
	 * @return
	 */
	@RequestMapping(value = "/getActivityListByCode")
	public String getActivityListByCode(HttpServletResponse response, SpecialCodeReqVO vo) throws Exception {
		HttpResponseText res = CallUtils
				.callUrlHttpPost(staticServer.getPlatformDataUrl() + "specialchange/getActivityListByCode", vo);
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * 兑换活动
	 * 
	 * @return
	 */
	@RequestMapping(value = "/changeActivity")
	public String changeActivity(HttpServletResponse response, SpecialCodeUseReqVO vo) throws Exception {
		HttpResponseText res = CallUtils
				.callUrlHttpPost(staticServer.getPlatformDataUrl() + "specialchange/changeActivity", vo);

		JSONObject jsonObject = JSON.parseObject(res.getData());
		if (jsonObject.get("data") != null) {
			String result = JSON.parseObject(jsonObject.get("data").toString(), String.class);
			if (result.length() == 15) {
				final Map<String, Object> map = new HashMap<String, Object>();
				final Map<String, Object> mapArtSky = new HashMap<String, Object>();
				final CmsActivity cmsActivity = cmsActivityService.queryFrontActivityByActivityId(vo.getActivityId());
				final String telphone = vo.getTelphone();

				map.put("userName", "文化云用户");
				map.put("activityName", cmsActivity.getActivityName());
				map.put("time", cmsActivity.getActivityStartTime());
				map.put("ticketCount", "1");
				map.put("ticketNum", "(" + result + ")");
				map.put("ticketCode", result);

				// 艺术天空用短信模板参数
				mapArtSky.put("username", "文化云用户");
				mapArtSky.put("date", cmsActivity.getActivityStartTime());
				mapArtSky.put("activityName", cmsActivity.getActivityName());
				mapArtSky.put("ticket", "1");
				mapArtSky.put("getCode", result);
				Runnable runnable = new Runnable() {
					@Override
					public void run() {
						if (cmsActivity.getTagName() != null && cmsActivity.getTagName().indexOf("艺术天空") != -1) {
							SmsUtil.sendActivityOrderSmsArtSky(telphone, mapArtSky);
						} else {
							SmsUtil.sendActivityOrderSms(telphone, map);
						}
					}
				};
				Thread thread = new Thread(runnable);
				thread.start();
			}
		}

		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/*************************************************** 浦东图书馆第六届读书节 **************************************************************************/

	/**
	 * 跳转到浦东图书馆第六届读书节
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/pdReadFestival")
	public String pdReadFestival(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/static/pdReadFestival";
	}

	/*************************************************** 12小时直播 **************************************************************************/

	/**
	 * 跳转到12小时直播
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/liveText")
	public String liveText(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/static/live/liveText";
	}

	/**
	 * 跳转到直播分享
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/liveShare")
	public String liveShare(HttpServletRequest request, String liveUserId) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		request.setAttribute("liveUserId", liveUserId);
		return "wechat/static/live/liveShare";
	}

	/**
	 * 直播列表
	 * 
	 * @return
	 */
	@RequestMapping(value = "/getLiveMessageList")
	public String getLiveMessageList(HttpServletResponse response, CcpLiveMessagePageVO vo) throws Exception {
		HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl() + "live/liveMessageList",
				vo);
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * 保存直播用户信息
	 * 
	 * @return
	 */
	@RequestMapping(value = "/saveLiveUserInfo")
	public String saveLiveUserInfo(HttpServletResponse response, SaveLiveUserVO vo) throws Exception {
		HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl() + "live/saveLiveUserInfo",
				vo);
		response.setContentType("text/html;charset=UTF-8");

		String userId = vo.getUserId();

		JSONObject jsonObject = JSON.parseObject(res.getData());

		String status = String.valueOf(jsonObject.get("status"));

		Integer userIsLike = vo.getUserIsLike();

		if ("1".equals(status) && userIsLike != null && userIsLike == 1) {

			userIntegralDetailService.liveLikeAddIntegral(userId, vo.getLiveActivity());
		}

		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * 直播用户图片列表
	 * 
	 * @return
	 */
	@RequestMapping(value = "/getLiveUserImgList")
	public String getLiveUserImgList(HttpServletResponse response, CcpLiveUserImgPageVO vo) throws Exception {
		HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl() + "live/liveUserImgList",
				vo);
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * 直播用户详情
	 * 
	 * @return
	 */
	@RequestMapping(value = "/getLiveUserDetail")
	public String getLiveUserDetail(HttpServletResponse response, CcpLiveUserDetailVO vo) throws Exception {
		HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl() + "live/liveUserDetail", vo);
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/*************************************************** 喜剧节 **************************************************************************/

	/**
	 * 跳转喜剧节
	 * 
	 * @param request
	 * @param tab
	 *            (0:首页列表；1:规则；2:喜剧节链接（暂不用）；3:留资；4:上传)
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping(value = "/comedyFestival")
	public String comedyFestival(HttpServletRequest request, String tab) throws ParseException {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		request.setAttribute("tab", tab);

		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date time = df.parse("2016-12-11 00:00:00");
		if (time.before(new Date())) {
			request.setAttribute("noControl", 1);
		}
		return "wechat/static/comedyFestival/index";
	}

	/**
	 * 跳转喜剧节分享页
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/comedyDetail")
	public String comedyDetail(HttpServletRequest request, String userId) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		request.setAttribute("userId", userId);
		return "wechat/static/comedyFestival/detail";
	}

	/**
	 * 获取喜剧列表
	 * 
	 * @return
	 */
	@RequestMapping(value = "/queryComedyList")
	@ResponseBody
	public List<CcpComedy> queryComedyList(CcpComedy vo) {
		List<CcpComedy> list = null;
		try {
			list = ccpComedyService.queryComedyList(vo);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	/**
	 * 添加喜剧节信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/saveOrUpdateCcpComedy")
	@ResponseBody
	@EmojiInspect
	public String saveOrUpdateCcpComedy(CcpComedy vo) {
		return ccpComedyService.saveOrUpdateCcpComedy(vo);
	}

	/**
	 * 获取喜剧详情
	 * 
	 * @return
	 */
	@RequestMapping(value = "/queryComedyDetail")
	@ResponseBody
	public CcpComedy queryComedyDetail(String userId) {
		CcpComedy ccpComedy = null;
		try {
			ccpComedy = ccpComedyService.selectByPrimaryKey(userId);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ccpComedy;
	}

	/*************************************************** 艺术狂欢答题 **************************************************************************/

	/**
	 * 跳转到艺术狂欢问答首页
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/artAnswer")
	public String artAnswer(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/static/artAnswer/index";
	}

	/**
	 * 跳转到艺术狂欢问答分享炫耀页面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/artAnswerShare")
	public String artAnswerShare(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/static/artAnswer/share";
	}

	/**
	 * 跳转到艺术狂欢问答补填信息页面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/artAnswerInfo")
	public String artAnswerInfo(HttpServletRequest request, CmsUserAnswer record) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);

		CmsUserAnswer result = userAnswerService.queryUserInfo(record);
		if (result.getUserName() == null) {
			return "wechat/static/artAnswer/info";
		} else {
			return "redirect:/wechatStatic/artAnswerShare.do";
		}
	}

	/**
	 * 保存或更新艺术狂欢问答信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/saveOrUpdateArtAnswer")
	@ResponseBody
	@EmojiInspect
	public String saveOrUpdateArtAnswer(HttpServletRequest request, CmsUserAnswer cmsUserAnswer) {
		return userAnswerService.saveOrUpdateAnswer(cmsUserAnswer);
	}

	/*************************************************** 浦东图书馆 **************************************************************************/

	/**
	 * 跳转浦东图书馆
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/pdLibrary")
	public String pdLibrary(HttpServletRequest request, Integer page, String point) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);

		request.setAttribute("point", point);
		if (page != null) {
			if (page == 1) {
				return "wechat/static/pdLibrary/page1";
			} else if (page == 2) {
				return "wechat/static/pdLibrary/page2";
			} else if (page == 3) {
				return "wechat/static/pdLibrary/page3";
			} else if (page == 4) {
				return "wechat/static/pdLibrary/page4";
			} else if (page == 5) {
				return "wechat/static/pdLibrary/page5";
			} else if (page == 6) {
				return "wechat/static/pdLibrary/page6";
			} else {
				return "wechat/static/pdLibrary/page1";
			}
		} else {
			return "wechat/static/pdLibrary/page1";
		}
	}

	/*************************************************** 戏剧节 **************************************************************************/

	/**
	 * 跳转戏剧节首页
	 * 
	 * @param request
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping(value = "/dramaFestival")
	public String dramaFestival(HttpServletRequest request, Integer tab) throws ParseException {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		request.setAttribute("tab", tab);

		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date time = df.parse("2016-12-11 00:00:00");
		if (time.before(new Date())) {
			request.setAttribute("noControl", 1);
		}
		return "wechat/static/dramaFestival/index";
	}

	/**
	 * 跳转戏剧节详情页面
	 * 
	 * @param request
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping(value = "/toDramaDetail")
	public String toDramaDetail(HttpServletRequest request, String dramaId, Integer tab) throws ParseException {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		request.setAttribute("dramaId", dramaId);
		request.setAttribute("tab", tab);

		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date time = df.parse("2016-12-11 00:00:00");
		if (time.before(new Date())) {
			request.setAttribute("noControl", 1);
		}
		return "wechat/static/dramaFestival/detail";
	}

	/**
	 * 跳转戏剧节填写信息页面
	 * 
	 * @param request
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping(value = "/toDramaUser")
	public String toDramaUser(HttpServletRequest request, String dramaId) throws ParseException {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		request.setAttribute("dramaId", dramaId);

		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date time = df.parse("2016-12-11 00:00:00");
		if (time.before(new Date())) {
			request.setAttribute("noControl", 1);
		}
		return "wechat/static/dramaFestival/user";
	}

	/**
	 * 跳转戏剧节评论页面
	 * 
	 * @param request
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping(value = "/toDramaComment")
	public String toDramaComment(HttpServletRequest request, String dramaId) throws ParseException {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		request.setAttribute("dramaId", dramaId);

		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date time = df.parse("2016-12-11 00:00:00");
		if (time.before(new Date())) {
			request.setAttribute("noControl", 1);
		}
		return "wechat/static/dramaFestival/comment";
	}

	/**
	 * 获取戏剧列表
	 * 
	 * @return
	 */
	@RequestMapping(value = "/queryCcpDramalist")
	@ResponseBody
	public List<CcpDrama> queryCcpDramalist(CcpDrama vo) {
		List<CcpDrama> list = null;
		try {
			list = ccpDramaService.queryCcpDramalist(vo);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	/**
	 * 获取评论列表
	 * 
	 * @return
	 */
	@RequestMapping(value = "/queryCcpDramaCommentlist")
	@ResponseBody
	public List<CcpDramaComment> queryCcpDramaCommentlist(CcpDramaComment vo) {
		List<CcpDramaComment> list = null;
		try {
			list = ccpDramaService.queryCcpDramaCommentlist(vo);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	/**
	 * 戏剧投票
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/addDramaVote")
	@ResponseBody
	public String addDramaVote(CcpDramaVote vo) {
		return ccpDramaService.addDramaVote(vo);
	}

	/**
	 * 戏剧填写个人信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/addDramaUser")
	@ResponseBody
	@EmojiInspect
	public String addDramaUser(CcpDramaUser vo) {
		return ccpDramaService.addDramaUser(vo);
	}

	/**
	 * 戏剧评论
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/addDramaComment")
	@ResponseBody
	@EmojiInspect
	public String addDramaComment(CcpDramaComment vo) {
		return ccpDramaService.addDramaComment(vo);
	}

	/**
	 * 获取个人信息(姓名)(判断是否需要填写信息)
	 * 
	 * @return
	 */
	@RequestMapping(value = "/queryCcpDramaUserName")
	@ResponseBody
	public String queryCcpDramaUserName(String userId) {
		String name = "";
		try {
			CcpDramaUser ccpDramaUser = ccpDramaService.queryCcpDramaUser(userId);
			if (ccpDramaUser != null) {
				name = ccpDramaUser.getUserName();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return name;
	}

	/*************************************************** 戏剧节答题 **************************************************************************/

	/**
	 * 跳转到戏剧节问答首页
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/dramaAnswer")
	public String dramaAnswer(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/static/dramaAnswer/index";
	}

	/**
	 * 跳转到戏剧节问答分享炫耀页面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/dramaAnswerShare")
	public String dramaAnswerShare(HttpServletRequest request, Integer userScore) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);

		request.setAttribute("userScore", userScore);
		return "wechat/static/dramaAnswer/share";
	}

	/**
	 * 跳转到戏剧节问答补填信息页面
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/dramaAnswerInfo")
	public String dramaAnswerInfo(HttpServletRequest request, CmsUserAnswer record) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);

		CmsUserAnswer result = userAnswerService.queryUserInfo(record);
		request.setAttribute("userScore", result.getUserScore());
		if (result.getUserName() == null) {
			return "wechat/static/dramaAnswer/info";
		} else {
			return "redirect:/wechatStatic/dramaAnswerShare.do?userScore=" + result.getUserScore();
		}
	}

	/**
	 * 保存或更新戏剧节问答信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/saveOrUpdateDramaAnswer")
	@ResponseBody
	@EmojiInspect
	public String saveOrUpdateDramaAnswer(HttpServletRequest request, CmsUserAnswer cmsUserAnswer) {
		return userAnswerService.saveOrUpdateAnswer(cmsUserAnswer);
	}

	/**
	 * 戏剧节问答保存虚拟用户数据
	 * 
	 * @param request
	 * @param num
	 *            添加数量
	 * @return
	 */
	@RequestMapping(value = "/saveDramaAnswerData")
	@ResponseBody
	public String saveDramaAnswerData(HttpServletRequest request, Integer num, String type) {
		return userAnswerService.saveAnswerData(num, type);
	}

	/*************************************************** 文化广场 **************************************************************************/

	/**
	 * 跳转到文化广场
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/cultureSquare")
	public String cultureSquare(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/static/cultureSquare";
	}

	/**
	 * 文化广场列表
	 * 
	 * @param request
	 * @param num
	 *            添加数量
	 * @return
	 * @throws IOException
	 */
	@RequestMapping(value = "/getCultureSquareList")
	@ResponseBody
	public List<CmsCulturalSquareDto> getCultureSquareList(HttpServletRequest request, HttpServletResponse response,
			PaginationApp pageApp, String userId) throws IOException {
		return cmsCulturalSquareService.getCultureSquareList(pageApp, userId);
	}

	/*************************************************** 文化新年 **************************************************************************/

	/**
	 * 跳转到首页
	 * 
	 * @param request
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping(value = "/nyIndex")
	public String nyIndex(HttpServletRequest request) throws ParseException {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);

		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date time = df.parse("2017-02-21 00:00:00");
		if (time.before(new Date())) {
			request.setAttribute("noControl", 1);
		}
		return "wechat/static/newYear/index";
	}

	/**
	 * 跳转到排名页
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/nyRanking")
	public String nyRanking(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/static/newYear/ranking";
	}

	/**
	 * 跳转到规则页
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/nyRule")
	public String nyRule(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/static/newYear/rule";
	}

	/**
	 * 跳转到获奖页
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/nyAward")
	public String nyAward(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/static/newYear/award";
	}

	/**
	 * 跳转到详情页
	 * 
	 * @param request
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping(value = "/nyDetail")
	public String nyDetail(HttpServletRequest request, String nyImgId) throws ParseException {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);

		request.setAttribute("nyImgId", nyImgId);

		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date time = df.parse("2017-02-21 00:00:00");
		if (time.before(new Date())) {
			request.setAttribute("noControl", 1);
		}
		return "wechat/static/newYear/detail";
	}

	/**
	 * 获取图片列表
	 * 
	 * @return
	 */
	@RequestMapping(value = "/queryNyImgList")
	@ResponseBody
	public List<CcpNyImg> queryNyImgList(CcpNyImg vo) {
		return ccpNyImgService.queryNyImgList(vo);
	}

	/**
	 * 获取精选图片列表
	 * 
	 * @return
	 */
	@RequestMapping(value = "/querySelectNyImgList")
	@ResponseBody
	public List<CcpNyImg> querySelectNyImgList(CcpNyImg vo) {
		return ccpNyImgService.querySelectNyImgList(vo);
	}

	/**
	 * 获取排名列表
	 * 
	 * @return
	 */
	@RequestMapping(value = "/queryNyUserRanking")
	@ResponseBody
	public List<CcpNyUser> queryNyUserRanking() {
		return ccpNyImgService.queryNyUserRanking();
	}

	/**
	 * 投票
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/addNyVote")
	@ResponseBody
	public String addNyVote(CcpNyVote vo) {
		return ccpNyImgService.addNyVote(vo);
	}

	/**
	 * 添加图片
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/addNyImg")
	@ResponseBody
	@EmojiInspect
	public String addNyImg(CcpNyImg vo) {
		return ccpNyImgService.addNyImg(vo);
	}

	/**
	 * 添加用户信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/addNyUser")
	@ResponseBody
	@EmojiInspect
	public String addNyUser(CcpNyUser vo) {
		return ccpNyImgService.addNyUser(vo);
	}

	/**
	 * 获取用户信息
	 * 
	 * @return
	 */
	@RequestMapping(value = "/queryNyUser")
	@ResponseBody
	public Map<String, Object> queryNyUser(String userId) {
		Map<String, Object> data = new HashMap<String, Object>();
		data.put("ccpNyUser", ccpNyImgService.queryNyUser(userId));
		return data;
	}

	/***************************************************
	 * 文化直播-我在现场
	 **************************************************************************/

	/**
	 * 跳转到首页
	 * 
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sceneIndex")
	public String sceneIndex(HttpServletRequest request, String venueId) throws Exception {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		request.setAttribute("venueId", venueId);

		// 获奖名单
		HttpResponseText res = BindWS.getMaterialList(cacheService, "rnOPWYDmAF7FrE5sd5nEvhDReR2boWFIUkL3ZV1mQek");
		JSONObject jsonObject = JSON.parseObject(res.getData());
		if (jsonObject.get("news_item") != null) {
			List<News> newsList = JSON.parseArray(jsonObject.get("news_item").toString(), News.class);
			request.setAttribute("awardUrl", newsList.get(0).getUrl());
		}
		return "wechat/static/scene/index";
	}

	/**
	 * 跳转到排名页
	 * 
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sceneRanking")
	public String sceneRanking(HttpServletRequest request) throws Exception {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);

		// 获奖名单
		HttpResponseText res = BindWS.getMaterialList(cacheService, "rnOPWYDmAF7FrE5sd5nEvhDReR2boWFIUkL3ZV1mQek");
		JSONObject jsonObject = JSON.parseObject(res.getData());
		if (jsonObject.get("news_item") != null) {
			List<News> newsList = JSON.parseArray(jsonObject.get("news_item").toString(), News.class);
			request.setAttribute("awardUrl", newsList.get(0).getUrl());
		}
		return "wechat/static/scene/ranking";
	}

	/**
	 * 跳转到规则页
	 * 
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sceneRule")
	public String sceneRule(HttpServletRequest request) throws Exception {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);

		// 获奖名单
		HttpResponseText res = BindWS.getMaterialList(cacheService, "rnOPWYDmAF7FrE5sd5nEvhDReR2boWFIUkL3ZV1mQek");
		JSONObject jsonObject = JSON.parseObject(res.getData());
		if (jsonObject.get("news_item") != null) {
			List<News> newsList = JSON.parseArray(jsonObject.get("news_item").toString(), News.class);
			request.setAttribute("awardUrl", newsList.get(0).getUrl());
		}
		return "wechat/static/scene/rule";
	}

	/**
	 * 跳转到详情页
	 * 
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/sceneDetail")
	public String sceneDetail(HttpServletRequest request, String sceneImgId) throws Exception {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		request.setAttribute("sceneImgId", sceneImgId);

		// 获奖名单
		HttpResponseText res = BindWS.getMaterialList(cacheService, "rnOPWYDmAF7FrE5sd5nEvhDReR2boWFIUkL3ZV1mQek");
		JSONObject jsonObject = JSON.parseObject(res.getData());
		if (jsonObject.get("news_item") != null) {
			List<News> newsList = JSON.parseArray(jsonObject.get("news_item").toString(), News.class);
			request.setAttribute("awardUrl", newsList.get(0).getUrl());
		}
		return "wechat/static/scene/detail";
	}

	/**
	 * 获取图片列表
	 * 
	 * @return
	 */
	@RequestMapping(value = "/querySceneImgList")
	@ResponseBody
	public List<CcpSceneImg> querySceneImgList(CcpSceneImg vo) {
		vo.setSceneStatus(1);
		return ccpSceneImgService.querySceneImgList(vo);
	}

	/**
	 * 获取精选图片列表
	 * 
	 * @return
	 */
	@RequestMapping(value = "/querySelectSceneImgList")
	@ResponseBody
	public List<CcpSceneImg> querySelectSceneImgList(CcpSceneImg vo) {
		vo.setSceneStatus(1);
		return ccpSceneImgService.querySelectSceneImgList(vo);
	}

	/**
	 * 获取排名列表
	 * 
	 * @return
	 */
	@RequestMapping(value = "/querySceneUserRanking")
	@ResponseBody
	public List<CcpSceneUser> querySceneUserRanking() {
		return ccpSceneImgService.querySceneUserRanking();
	}

	/**
	 * 投票
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/addSceneVote")
	@ResponseBody
	public String addSceneVote(CcpSceneVote vo) {
		return ccpSceneImgService.addSceneVote(vo);
	}

	/**
	 * 添加图片
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/addSceneImg")
	@ResponseBody
	@EmojiInspect
	public String addSceneImg(CcpSceneImg vo) {
		return ccpSceneImgService.addSceneImg(vo);
	}

	/**
	 * 添加用户信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/addSceneUser")
	@ResponseBody
	@EmojiInspect
	public String addSceneUser(CcpSceneUser vo) {
		return ccpSceneImgService.addSceneUser(vo);
	}

	/**
	 * 获取用户信息
	 * 
	 * @return
	 */
	@RequestMapping(value = "/querySceneUser")
	@ResponseBody
	public Map<String, Object> querySceneUser(String userId) {
		Map<String, Object> data = new HashMap<String, Object>();
		data.put("ccpSceneUser", ccpSceneImgService.querySceneUser(userId));
		return data;
	}

	/*************************************************** 浦东文化团队 **************************************************************************/

	/**
	 * 跳转文化团队首页
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/cultureTeamIndex")
	public String cultureTeamIndex(HttpServletRequest request, Integer tab) throws ParseException {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		request.setAttribute("tab", tab);
		if (tab != null) {
			if (tab == 1) {
				request.setAttribute("cultureTeamType", "1");
			} else if (tab == 2) {
				request.setAttribute("cultureTeamType", "2");
			} else if (tab == 3) {
				request.setAttribute("cultureTeamType", "3");
			} else if (tab == 4) {
				request.setAttribute("cultureTeamType", "4");
			} else if (tab == 5) {
				request.setAttribute("cultureTeamType", "5");
			} else if (tab == 6) {
				request.setAttribute("cultureTeamType", "6");
			}
		} else {
			request.setAttribute("cultureTeamType", "1");
		}

		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		// 结束日期
		Date voteEndTime = df.parse("2017-03-10 17:00:00");
		if (voteEndTime.before(new Date())) {
			request.setAttribute("noVote", 1);
		}
		return "wechat/static/cultureTeam/index";
	}

	/**
	 * 跳转文化团队详情页面
	 * 
	 * @param request
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping(value = "/cultureTeamDetail")
	public ModelAndView cultureTeamDetail(HttpServletRequest request, String cultureTeamId) throws ParseException {
		// 微信权限验证配置
		ModelAndView model = new ModelAndView();
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		CcpCultureTeamDto team = ccpCultureTeamService.queryCultureTeamByPrimaryKey(cultureTeamId);
		List<CcpCultureTeamWorks> list = ccpCultureTeamService.queryUserByCultureTeamIdList(cultureTeamId);
		model.addObject("sign", sign);
		model.addObject("cultureTeamId", cultureTeamId);
		model.addObject("team", team);
		model.addObject("list", list);
		model.setViewName("/wechat/static/cultureTeam/detail");
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		// 结束日期
		Date voteEndTime = df.parse("2017-03-10 17:00:00");
		if (voteEndTime.before(new Date())) {
			request.setAttribute("noVote", 1);
		}
		return model;
	}

	/**
	 * 跳转文化团队排名页面
	 * 
	 * @param request
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping(value = "/cultureTeamRanking")
	public String cultureTeamRanking(HttpServletRequest request, Integer tab) throws ParseException {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		request.setAttribute("tab", tab);
		if (tab != null) {
			if (tab == 1) {
				request.setAttribute("cultureTeamType", "1");
			} else if (tab == 2) {
				request.setAttribute("cultureTeamType", "2");
			} else if (tab == 3) {
				request.setAttribute("cultureTeamType", "3");
			} else if (tab == 4) {
				request.setAttribute("cultureTeamType", "4");
			} else if (tab == 5) {
				request.setAttribute("cultureTeamType", "5");
			} else if (tab == 6) {
				request.setAttribute("cultureTeamType", "6");
			}
		} else {
			request.setAttribute("cultureTeamType", "1");
		}

		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		// 结束日期
		Date voteEndTime = df.parse("2017-03-10 17:00:00");
		if (voteEndTime.before(new Date())) {
			request.setAttribute("noVote", 1);
		}

		return "wechat/static/cultureTeam/ranking";
	}

	/**
	 * 获取文化团队列表
	 * 
	 * @return
	 */
	@RequestMapping(value = "/queryCultureTeamlist")
	@ResponseBody
	public List<CcpCultureTeamDto> queryCultureTeamlist(CcpCultureTeamDto vo, PaginationApp page) {
		List<CcpCultureTeamDto> list = null;
		try {
			list = ccpCultureTeamService.queryWcCultureTeamByCondition(vo, page);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	/**
	 * 浦东H5投票
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/addVote")
	@ResponseBody
	public String addVote(CcpCultureTeamVote vote) {
		String saveVote = ccpCultureTeamService.saveVote(vote);
		return saveVote;
	}

	/**
	 * 添加用户信息
	 * 
	 * @param user
	 * @return
	 */
	@RequestMapping("/insertUserMessage")
	@ResponseBody
	public String insertUserMessage(CcpCultureTeamUser user) {
		int rs = ccpCultureTeamService.insertUserMessage(user);
		if (rs > 0) {
			return "success";
		}
		return "error";
	}

	/*************************************************** 公共文化服务保障法 **************************************************************************/

	/**
	 * 跳转到公共文化服务保障法
	 * 
	 * @return
	 */
	@RequestMapping(value = "/cultureSecurityLaw")
	public String cultureSecurityLaw(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/static/securityLaw";
	}

	/***************************************************
	 * “文化上海云”应用大赛
	 **************************************************************************/

	/**
	 * 跳转到“文化上海云”应用大赛
	 * 
	 * @return
	 */
	@RequestMapping(value = "/cultureAwardList")
	public String cultureAwardList(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/static/cultureAwardList";
	}

	/*************************************************** PC首页临时直播 **************************************************************************/

	@RequestMapping(value = "/pcLive1")
	public String pcLive1(HttpServletRequest request) {
		return "wechat/static/pcLive/pcLive1";
	}

	@RequestMapping(value = "/pcLive2")
	public String pcLive2(HttpServletRequest request) {
		return "wechat/static/pcLive/pcLive2";
	}

	@RequestMapping(value = "/pcLive3")
	public String pcLive3(HttpServletRequest request) {
		return "wechat/static/pcLive/pcLive3";
	}

	@RequestMapping(value = "/pcLive4")
	public String pcLive4(HttpServletRequest request) {
		return "wechat/static/pcLive/pcLive4";
	}

	/*************************************************** 重大品牌活动 **************************************************************************/

	/**
	 * 跳转到重大品牌活动
	 * 
	 * @return
	 */
	@RequestMapping(value = "/brandAct")
	public String brandAct(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/static/brandAct";
	}
	
	/**
	 * 查询重大品牌活动
	 * 
	 * @return
	 */
	@RequestMapping(value = "/queryBrandAct")
	@ResponseBody
	public List<CmsActivityBrand> queryBrandAct(Integer actType) {
		return cmsActivityBrandService.queryActivityBrand(actType);
	}
	

	/**
	 * 重大品牌活动点赞数
	 * 
	 * @param response
	 * @param venueId
	 * @param userId
	 * @return
	 */
	@RequestMapping(value = "/brandActWantGo")
	public String brandActWantGo(HttpServletResponse response, String relateId, String userId) throws Exception {
		// 点赞人数
		Map<String, Object> wantGoMap = new HashMap<String, Object>();
		wantGoMap.put("relateId", relateId);
		int wantGoCount = cmsUserWantgoMapper.queryUserWantgoCount(wantGoMap);

		Integer isWantGo = 0;
		if (StringUtils.isNotBlank(userId)) {
			wantGoMap.put("userId", userId);
			isWantGo = cmsUserWantgoMapper.queryUserWantgoCount(wantGoMap);
		}
		isWantGo = isWantGo > 0 ? 1 : 0;
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().print(JSONResponse.toAppResultObject(200, wantGoCount, isWantGo));
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/*************************************************** 我们的行走故事 **************************************************************************/

	/**
	 * 跳转到首页
	 * 
	 * @param request
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping(value = "/walkIndex")
	public String walkIndex(HttpServletRequest request) throws ParseException {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);

		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date time = df.parse("2017-08-01 00:00:00");
		if (time.before(new Date())) {
			request.setAttribute("noControl", 1);
		}
		time = df.parse("2017-08-12 00:00:00");
		if (time.before(new Date())) {
			request.setAttribute("noVote", 1);
		}
		return "wechat/static/walk/index";
	}

	/**
	 * 跳转到排名页
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/walkRanking")
	public String walkRanking(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/static/walk/ranking";
	}

	/**
	 * 跳转到规则页
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/walkRule")
	public String walkRule(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/static/walk/rule";
	}

	/**
	 * 跳转到详情页
	 * 
	 * @param request
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping(value = "/walkDetail")
	public String walkDetail(HttpServletRequest request, String walkImgId) throws ParseException {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);

		request.setAttribute("walkImgId", walkImgId);

		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date time = df.parse("2017-08-12 00:00:00");
		if (time.before(new Date())) {
			request.setAttribute("noVote", 1);
		}
		return "wechat/static/walk/detail";
	}

	/**
	 * 获取图片列表
	 * 
	 * @return
	 */
	@RequestMapping(value = "/queryWalkImgList")
	@ResponseBody
	public List<CcpWalkImg> queryWalkImgList(CcpWalkImg vo) {
		return ccpWalkImgService.queryWalkImgList(vo);
	}

	/**
	 * 获取精选图片列表
	 * 
	 * @return
	 */
	@RequestMapping(value = "/querySelectWalkImgList")
	@ResponseBody
	public List<CcpWalkImg> querySelectWalkImgList(CcpWalkImg vo) {
		vo.setWalkStatus(1);
		return ccpWalkImgService.querySelectWalkImgList(vo);
	}

	/**
	 * 获取排名列表
	 * 
	 * @return
	 */
	@RequestMapping(value = "/queryWalkUserRanking")
	@ResponseBody
	public List<CcpWalkUser> queryWalkUserRanking() {
		return ccpWalkImgService.queryWalkUserRanking();
	}

	/**
	 * 投票
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/addWalkVote")
	@ResponseBody
	public String addWalkVote(CcpWalkVote vo) {
		return ccpWalkImgService.addWalkVote(vo);
	}

	/**
	 * 添加图片
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/addWalkImg")
	@ResponseBody
	@EmojiInspect
	public String addWalkImg(CcpWalkImg vo) {
		return ccpWalkImgService.addWalkImg(vo);
	}

	/**
	 * 添加用户信息
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/addWalkUser")
	@ResponseBody
	@EmojiInspect
	public String addWalkUser(CcpWalkUser vo) {
		return ccpWalkImgService.addWalkUser(vo);
	}

	/**
	 * 获取用户信息
	 * 
	 * @return
	 */
	@RequestMapping(value = "/queryWalkUser")
	@ResponseBody
	public Map<String, Object> queryWalkUser(String userId) {
		Map<String, Object> data = new HashMap<String, Object>();
		data.put("ccpWalkUser", ccpWalkImgService.queryWalkUser(userId));
		return data;
	}

	/*************************************************** 音乐中的真善美 **************************************************************************/

	/**
	 * 跳转到音乐中的真善美引导页
	 * 
	 * @return
	 */
	@RequestMapping(value = "/musicIndex")
	public String musicIndex(HttpServletRequest request, String indexTag) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		request.setAttribute("indexTag", indexTag);

		return "wechat/static/music/index";
	}

	@RequestMapping(value = "/musicRule")
	public String musicRule(HttpServletRequest request) {

		return "wechat/static/music/rule";
	}

	@RequestMapping(value = "/musicRanking")
	public String musicRanking(HttpServletRequest request, String userId, String indexTag) {

		List<CcpMusicessayArticleDto> list =

				ccpMusicessayArticleService.queryMusicessayArticleRanking(userId);

		if (StringUtils.isNotBlank(userId)) {

			CcpMusicessayArticleDto myBestArticle = ccpMusicessayArticleService.myMusicessayArticleBest(userId);

			request.setAttribute("myBestArticle", myBestArticle);

		}

		request.setAttribute("rankList", list);

		return "wechat/static/music/ranking";
	}

	@RequestMapping(value = "/musicessayArticleDetail")
	public String musicessayArticleDetail(HttpServletRequest request, @RequestParam String articleId,
			String loginUser) {

		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		request.setAttribute("articleId", articleId);

		CcpMusicessayArticleDto musicessayArticle = ccpMusicessayArticleService.queryMusicessayArticleDetail(loginUser,articleId);
		request.setAttribute("article", musicessayArticle);
		return "wechat/static/music/musicessayArticleDetail";
	}

	@RequestMapping(value = "/createMusicessayArticle")
	public String createMusicessayArticle(HttpServletRequest request, String userId, Integer articleType) {

		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);

		if (StringUtils.isNotBlank(userId)) {

			CcpMusicessayUser userInfo = ccpMusicessayUserService.queryUserInfo(userId);

			request.setAttribute("userInfo", userInfo);

			CcpMusicessayArticle musicessayArticle = new CcpMusicessayArticle();

			musicessayArticle.setUserId(userId);
			musicessayArticle.setArticleType(2);

			int articleCount = ccpMusicessayArticleService.queryMusicessayArticleCount(musicessayArticle);

			request.setAttribute("articleCount", articleCount);
		}

		request.setAttribute("articleType", articleType);

		return "wechat/static/music/musicessayArticle";
	}

	@RequestMapping(value = "/myMusicIndex")
	public String myMusicIndex(HttpServletRequest request, String indexTag) {

		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);

		request.setAttribute("sign", sign);
		request.setAttribute("indexTag", indexTag);

		return "wechat/static/music/myMusicIndex";
	}

	@RequestMapping(value = "/queryMusicessayArticleList")
	@ResponseBody
	public List<CcpMusicessayArticleDto> queryMusicessayArticleList(CcpMusicessayArticle musicessayArticle,
			String loginUser, PaginationApp pageApp) {
		List<CcpMusicessayArticleDto> list = null;
		try {
			list = ccpMusicessayArticleService.queryMusicessayArticle(musicessayArticle, loginUser, pageApp);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	@RequestMapping(value = "/queryMusicessayUserInfo")
	@ResponseBody
	public CcpMusicessayUser queryMusicessayUserInfo(String userId) {

		return ccpMusicessayUserService.queryUserInfo(userId);

	}

	@RequestMapping(value = "/saveMusicessayUserInfo")
	@ResponseBody
	public int saveMusicessayUserInfo(CcpMusicessayUser ccpMusicessayUser) {

		return ccpMusicessayUserService.saveUserInfo(ccpMusicessayUser);

	}

	@RequestMapping(value = "/saveMusicessayArticle")
	@ResponseBody
	@EmojiInspect
	public String saveMusicessayArticle(CcpMusicessayArticle musicessayArticle) {

		try {

			int i = ccpMusicessayArticleService.saveMusicessayArticle(musicessayArticle);

		} catch (Exception e) {
			e.printStackTrace();
			return "error";
		}

		return "success";
	}

	@RequestMapping(value = "/likeMusicessayArticle")
	@ResponseBody
	public void likeMusicessayArticle(String articleId, String userId) {

		ccpMusicessayArticleService.likeMusicessayArticle(userId, articleId);
	}
	
	/*******************************************************电影中的真善美*************************************************************************/
	
	/**
	 * 跳转到音乐中的真善美引导页
	 * 
	 * @return
	 */
	@RequestMapping(value = "/movieIndex")
	public String movieIndex(HttpServletRequest request, String indexTag,HttpSession session) {
		
		
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		request.setAttribute("indexTag", indexTag);
		
		try{
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date now = new Date();
			//用户投稿截止时间
			Date endTg = df.parse("2017-07-17 23:59:59");
			//用户点赞截止时间
			Date endDz = df.parse("2017-08-14 23:59:59");
			if (endTg.before(now)) {
				session.setAttribute("endTg", true);
			}else{
				session.setAttribute("endTg", false);
			}
			if(endDz.before(now)){
				session.setAttribute("endDz", true);
			}else{
				session.setAttribute("endDz", false);
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return "wechat/static/movie/index";
	}

	@RequestMapping(value = "/movieRule")
	public String movieRule(HttpServletRequest request) {

		return "wechat/static/movie/rule";
	}

	@RequestMapping(value = "/movieRanking")
	public String movieRanking(HttpServletRequest request, String userId, String indexTag) {

		//获取所有的排名集合
		List<CcpMoviessayArticleDto> list = ccpMoviessayArticleService.queryMoviessayArticleRanking(userId);
		//如果userId不为空，则查询该用户的最大的点赞数
		if (StringUtils.isNotBlank(userId)) {
			CcpMoviessayArticleDto myBestArticle = ccpMoviessayArticleService.myMoviessayArticleBest(userId);
			request.setAttribute("myBestArticle", myBestArticle);
		}
		request.setAttribute("rankList", list);
		return "wechat/static/movie/ranking";
	}

	@RequestMapping(value = "/moviessayArticleDetail")
	public String moviessayArticleDetail(HttpServletRequest request, @RequestParam String articleId, String loginUser) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		request.setAttribute("articleId", articleId);

		CmsTerminalUser sessionUser = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);

		if (null != sessionUser) {
			if (StringUtils.equals(sessionUser.getUserId(), loginUser)) {
				CcpMoviessayArticleDto moviessayArticle = ccpMoviessayArticleService.queryMoviessayArticleDetail(loginUser, articleId);
				request.setAttribute("article", moviessayArticle);
			} else {
				CcpMoviessayArticleDto moviessayArticle = ccpMoviessayArticleService.queryMoviessayArticleDetail(sessionUser.getUserId(), articleId);
				request.setAttribute("article", moviessayArticle);
			}
		} else {
			CcpMoviessayArticleDto moviessayArticle = ccpMoviessayArticleService.queryMoviessayArticleDetail(null,articleId);
			request.setAttribute("article", moviessayArticle);
		}
		return "wechat/static/movie/moviessayArticleDetail";
	}

	@RequestMapping(value = "/createMoviessayArticle")
	public String createMoviessayArticle(HttpServletRequest request, String userId, Integer articleType) {

		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);

		if (StringUtils.isNotBlank(userId)) {

			CcpMoviessayUser userInfo = ccpMoviessayUserService.queryUserInfo(userId);

			if(userInfo==null){
				request.setAttribute("articleType", articleType);
				request.setAttribute("userInfo", null);
				return "wechat/static/movie/moviessayArticle";
			}
			
			request.setAttribute("userInfo", userInfo);

			CcpMoviessayArticle moviessayArticle = new CcpMoviessayArticle();

			moviessayArticle.setUserId(userId);
			moviessayArticle.setArticleType(2);

//			int articleCount = ccpMoviessayArticleService.queryMoviessayArticleCount(moviessayArticle);

//			request.setAttribute("articleCount", articleCount);
		}

		request.setAttribute("articleType", articleType);

		return "wechat/static/movie/moviessayArticle";
	}

	@RequestMapping(value = "/myMovieIndex")
	public String myMovieIndex(HttpServletRequest request, String indexTag) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);	
		Map<String, String> sign = BindWS.sign(url, cacheService);

		request.setAttribute("sign", sign);
		request.setAttribute("indexTag", indexTag);

		return "wechat/static/movie/myMovieIndex";
	}

	@RequestMapping(value = "/queryMoviessayArticleList")
	@ResponseBody
	public List<CcpMoviessayArticleDto> queryMoviessayArticleList(CcpMoviessayArticle moviessayArticle,
			String loginUser, PaginationApp pageApp) {
		List<CcpMoviessayArticleDto> list = null;
		try {

			list = ccpMoviessayArticleService.queryMoviessayArticle(moviessayArticle, loginUser, pageApp);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	@RequestMapping(value = "/queryMoviessayUserInfo")
	@ResponseBody
	public CcpMoviessayUser queryMoviessayUserInfo(String userId) {

		return ccpMoviessayUserService.queryUserInfo(userId);

	}

	@RequestMapping(value = "/saveMoviessayUserInfo")
	@ResponseBody
	public int saveMoviessayUserInfo(CcpMoviessayUser ccpMoviessayUser) {
		
		return ccpMoviessayUserService.saveUserInfo(ccpMoviessayUser);

	}

	@RequestMapping(value = "/saveMoviessayArticle")
	@ResponseBody
	@EmojiInspect
	public String saveMoviessayArticle(CcpMoviessayArticle moviessayArticle,String articleText) {
		
		moviessayArticle.setArticleText(articleText);
		try {
			
			int i = ccpMoviessayArticleService.saveMoviessayArticle(moviessayArticle);

		} catch (Exception e) {
			e.printStackTrace();
			return "error";
		}

		return "success";
	}

	@RequestMapping(value = "/likeMoviessayArticle")
	@ResponseBody
	public void likeMoviessayArticle(String articleId, String userId) {

		ccpMoviessayArticleService.likeMoviessayArticle(userId, articleId);
	}
	
	
	
	@RequestMapping(value = "/queryMoviessayArticleByArticleType")
	@ResponseBody
	public String queryMoviessayArticleByArticleType(CcpMoviessayArticle moviessayArticle) {
		if(moviessayArticle!=null){
			return ccpMoviessayArticleService.queryMoviessayTimes(moviessayArticle.getUserId());
		}		
		return null;
	}
	
	
	
	
	@RequestMapping(value = "/queryMoviessayZWCountByMovieName")
	@ResponseBody
	public int queryMoviessayZWCountByMovieName(CcpMoviessayArticle moviessayArticle) {
		if(moviessayArticle!=null){
			return ccpMoviessayArticleService.queryMoviessayArticleCount(moviessayArticle);
		}		
		return -1;
	}
	/*************************************************** 每日一诗 **************************************************************************/

	/**
	 * 跳转到每日一诗首页
	 * 
	 * @return
	 */
	@RequestMapping(value = "/poemIndex")
	public String poemIndex(HttpServletRequest request, String poemDate) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);

		if (StringUtils.isNotBlank(poemDate)) {
			request.setAttribute("poemDate", poemDate);
		} else {
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			request.setAttribute("poemDate", df.format(new Date()));
		}
		return "wechat/static/poem/poemIndex";
	}

	/**
	 * 跳转到每日一诗完成页
	 * 
	 * @return
	 */
	@RequestMapping(value = "/poemComplete")
	public String poemComplete(HttpServletRequest request, String poemDate) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);

		if (StringUtils.isNotBlank(poemDate)) {
			request.setAttribute("poemDate", poemDate);
		} else {
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			request.setAttribute("poemDate", df.format(new Date()));
		}
		return "wechat/static/poem/poemComplete";
	}

	/**
	 * 跳转到每日一诗列表页
	 * 
	 * @return
	 */
	@RequestMapping(value = "/poemList")
	public String poemList(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);

		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM");
		request.setAttribute("poemDate", df.format(new Date()));
		return "wechat/static/poem/poemList";
	}

	/**
	 * 跳转到讲师列表页
	 * 
	 * @return
	 */
	@RequestMapping(value = "/poemLectorList")
	public String poemLectorList(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);

		List<CcpPoemLector> poemLector = ccpPoemService.queryAllPoemLector();
		request.setAttribute("poemLector", poemLector);
		return "wechat/static/poem/poemLectorList";
	}

	/**
	 * 跳转到规则页
	 * 
	 * @return
	 */
	@RequestMapping(value = "/poemRule")
	public String poemRule(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/static/poem/poemRule";
	}

	/**
	 * 获取每日一诗列表
	 * 
	 * @return
	 */
	@RequestMapping(value = "/queryPoemList")
	@ResponseBody
	public List<CcpPoem> queryPoemList(CcpPoem vo) {
		return ccpPoemService.queryPoemByCondition(vo);
	}

	/**
	 * 记录用户答对信息（添加积分）
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/addPoemUser")
	@ResponseBody
	public String addPoemUser(CcpPoemUser vo) {
		return ccpPoemService.addPoemUser(vo);
	}

	@RequestMapping(value = "/cultureContestIndex")
	public String cultureContestIndex(HttpServletRequest request) throws ParseException {
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);

		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		Date now = new Date();

		Date end = df.parse("2017-10-10 23:59:59");

		if (end.before(now)) {

			request.setAttribute("end", true);
		} else {
			Date time = df.parse("2017-06-02 10:00:00");
			if (time.before(now)) {

				request.setAttribute("stage1", true);
			}

			Date time1 = df.parse("2017-07-14 00:00:00");
			if (time1.before(now)) {

				request.setAttribute("stage2", true);
			}

			Date time2 = df.parse("2017-09-01 00:00:00");
			if (time2.before(now)) {

				request.setAttribute("stage3", true);
			}
		}

		return "wechat/static/cultureContest/index";
	}

	@RequestMapping(value = "/cultureContestRule")
	public String cultureContestRule(HttpServletRequest request) {

		return "wechat/static/cultureContest/rule";
	}

	@RequestMapping(value = "/cultureContestQuestions")
	public String cultureContestQuestions(HttpServletRequest request) {

		return "wechat/static/cultureContest/questions";
	}

	@RequestMapping(value = "/cultureContestEnd")
	public String cultureContestEnd(HttpServletRequest request, @RequestParam String cultureAnswerId,
			@RequestParam(defaultValue = "false") boolean autoEnd) {

		CcpCultureContestAnswer answer = ccpCultureContestAnswerSerice
				.queryCcpCultureContestAnswerById(cultureAnswerId);

		if (autoEnd == true) {
			answer.setAnswerTime(15 * 60);

			ccpCultureContestAnswerSerice.updateCcpCultureContestAnswer(answer);
		}

		Integer time = answer.getAnswerTime();

		String t1 = String.valueOf(time / 60);
		if (t1.length() == 1)
			t1 = "0" + t1;

		String t2 = String.valueOf(time % 60);
		if (t2.length() == 1)
			t2 = "0" + t2;

		String strTime = t1 + ":" + t2;

		String cultureUserId = answer.getCultureUserId();

		Integer stageNumber = answer.getStageNumber();

		request.setAttribute("answerTime", strTime);

		List<CcpCultureContestAnswerDto> answerDtoList = ccpCultureContestAnswerSerice.queryAnswerRanking(cultureUserId,
				stageNumber, null, answer.getUserGroupType(), null);

		List<CcpCultureContestAnswerDto> answerSumDtoList = ccpCultureContestAnswerSerice
				.queryAnswerSumRanking(cultureUserId, null, null, answer.getUserGroupType(), null);

		request.setAttribute("stageRanking", answerDtoList.get(0));

		request.setAttribute("sumRanking", answerSumDtoList.get(0));

		request.setAttribute("stageNumber", answer.getStageNumber());

		request.setAttribute("userName", answerDtoList.get(0).getUserName());

		request.setAttribute("userHeadImgUrl", answerDtoList.get(0).getUserHeadImgUrl());

		request.setAttribute("answer", answer);

		// 用户组别 1.少年组 2.中青年组 3.老年组
		switch (answer.getUserGroupType()) {
		case 1:
			request.setAttribute("groupName", "少年组");
			break;
		case 2:
			request.setAttribute("groupName", "中青年组");
			break;
		case 3:
			request.setAttribute("groupName", "老年组");
			break;
		}

		return "wechat/static/cultureContest/end";
	}

	@RequestMapping(value = "/cultureContestEnter")
	public String cultureContestEnter(HttpServletRequest request, @RequestParam String userId,
			@RequestParam Integer stageNumber) {

		Integer rightNumber = 0;

		CcpCultureContestUser userInfo = ccpCultureContestUserService.queryUserInfo(userId);

		request.setAttribute("stageNumber", stageNumber);

		if (userInfo == null) {

			return "wechat/static/cultureContest/userInfo";
		}

		List<CcpCultureContestAnswer> answerList = ccpCultureContestAnswerSerice
				.queryCcpCultureContestAnswerByUser(userId, stageNumber);

		Integer testChance = 3;

		if (answerList.size() > 0) {

			rightNumber = answerList.get(0).getAnswerRightNumber();

			for (CcpCultureContestAnswer ccpCultureContestAnswer : answerList) {

				// 已答题
				if (ccpCultureContestAnswer.getAnswerStatus() == 1) {
					testChance--;
				}
			}

		} else {

		}
		
		request.setAttribute("userId", userId);

		request.setAttribute("bestRightNumber", rightNumber);

		request.setAttribute("cultureUserId", userInfo.getCultureUserId());

		request.setAttribute("testChance", testChance);

		return "wechat/static/cultureContest/stageIndex";
	}

	@RequestMapping(value = "/cultureContestTest")
	public String cultureContestTest(HttpServletRequest request, @RequestParam String userId,
			@RequestParam Integer stageNumber) {

		List<CcpCultureContestAnswer> answerList = ccpCultureContestAnswerSerice
				.queryCcpCultureContestAnswerByUser(userId, stageNumber);

		request.setAttribute("stageNumber", stageNumber);
		request.setAttribute("userId", userId);

		for (CcpCultureContestAnswer ccpCultureContestAnswer : answerList) {

			// 未答题
			if (ccpCultureContestAnswer.getAnswerStatus() == 0) {

				ccpCultureContestAnswer.setAnswerStatus(1);
				ccpCultureContestAnswer.setAnswerUseTime(new Date());

				int i = ccpCultureContestAnswerSerice.updateCcpCultureContestAnswer(ccpCultureContestAnswer);

				if (i > 0) {

					request.setAttribute("cultureAnswerId", ccpCultureContestAnswer.getCultureAnswerId());

					return "wechat/static/cultureContest/test";
				} else {
					continue;
				}

			}
		}

		return "redirect:cultureContestEnter.do?stageNumber=" + stageNumber + "&userId=" + userId;

	}

	@RequestMapping(value = "/cultureContestRanking")
	public String cultureContestRanking(HttpServletRequest request, String userId,
			@RequestParam(defaultValue = "1") Integer stageNumber,
			@RequestParam(defaultValue = "1") Integer userGroupType) throws ParseException {

		Date now = new Date();

		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		Date time1 = df.parse("2017-07-14 00:00:00");
		if (time1.before(now)) {

			request.setAttribute("stage2", true);
		}

		Date time2 = df.parse("2017-09-01 00:00:00");
		if (time2.before(now)) {

			request.setAttribute("stage3", true);
		}

		request.setAttribute("stageNumber", stageNumber);

		request.setAttribute("userGroupType", userGroupType);

		return "wechat/static/cultureContest/ranking";
	}

}
