package com.sun3d.why.controller.wechat;

import java.io.IOException;
import java.util.Calendar;
import java.util.Date;
import java.util.Map;
import java.util.Random;

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

import com.alibaba.fastjson.JSONObject;
import com.sun3d.why.dao.CmsUserMessageMapper;
import com.sun3d.why.model.CmsFeedback;
import com.sun3d.why.model.CmsRoomOrder;
import com.sun3d.why.model.CmsTeamUser;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.CmsUserMessage;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.model.extmodel.WxInfo;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.CmsRoomOrderService;
import com.sun3d.why.service.CmsTeamUserService;
import com.sun3d.why.service.CmsTerminalUserService;
import com.sun3d.why.service.CmsUserMessageService;
import com.sun3d.why.service.UserIntegralDetailService;
import com.sun3d.why.service.UserIntegralService;
import com.sun3d.why.util.BindWS;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.EmojiFilter;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.api.util.HttpClientConnection;
import com.sun3d.why.webservice.service.ActivityAppService;
import com.sun3d.why.webservice.service.CmsFeedbackService;
import com.sun3d.why.webservice.service.CommentAppService;
import com.sun3d.why.webservice.service.TerminalUserAppService;
import com.sun3d.why.webservice.service.UserCollectAppService;
import com.sun3d.why.webservice.service.UserMessageAppService;
import com.sun3d.why.webservice.service.UserOrderAppService;
import com.sun3d.why.webservice.service.VenueAppService;

@RequestMapping("/wechatUser")
@Controller
public class WechatUserController {
	private Logger logger = LoggerFactory.getLogger(WechatUserController.class);

	@Autowired
	private CmsFeedbackService cmsFeedbackService;
	@Autowired
	private TerminalUserAppService terminalUserAppService;
	@Autowired
	private WxInfo wxToken;
	@Autowired
	private CacheService cacheService;
	@Autowired
	private UserCollectAppService userCollectAppService;
	@Autowired
	private UserMessageAppService userMessageAppService;
	@Autowired
	private CmsUserMessageService cmsUserMessageService;
	@Autowired
	private CmsUserMessageMapper cmsUserMessageMapper;
	@Autowired
	private ActivityAppService activityAppService;
	@Autowired
	private VenueAppService venueAppService;
	@Autowired
	private CommentAppService commentAppService;
	@Autowired
	private UserOrderAppService userOrderAppService;

	@Autowired
	private CmsTerminalUserService terminalUserService;

	@Autowired
	private UserIntegralService userIntegralService;

	@Autowired
	private CmsRoomOrderService roomOrderService;

	@Autowired
	private CmsTeamUserService teamUserService;
	
	@Autowired
	private UserIntegralDetailService userIntegralDetailService;

	@Autowired
    private StaticServer staticServer;
	
	@Autowired
	private HttpSession session;

	/**
	 * 跳转到个人中心
	 * 
	 * @return
	 */
	@RequestMapping(value = "/preTerminalUser")
	public String preTerminalUser(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/user/userCenter";
	}

	/**
	 * wechat根据用户id返回用户信息
	 * @param userId 用户id
	 * @return json 10111 用户id缺失
	 * @throws Exception
	 */
	@RequestMapping(value = "/queryTerminalUserById")
	public String queryTerminalUserById(HttpServletRequest request,HttpServletResponse response, String userId) throws Exception {
		String json = "";
		if (StringUtils.isNotBlank(userId) && userId != null) {
			json = terminalUserAppService.queryCmsTerminalUserById(userId);
		} else {
			json = JSONResponse.commonResultFormat(500, "用户id为空!", null);
		}
		response.setContentType("text/html;charset=UTF-8");
		//跨域
		String callback = request.getParameter("callback");
		if(callback!=null){
			response.getWriter().print(callback+"("+json+")");
		}else{
			response.getWriter().print(json);
		}
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}
	
	/**
	 * wechat根据用户id返回用户信息(简化)
	 * @param userId 用户id
	 * @throws Exception
	 */
	@RequestMapping(value = "/queryTerminalUserByUserId")
	@ResponseBody
	public CmsTerminalUser queryTerminalUserByUserId(String userId) throws Exception {
		return terminalUserAppService.queryTerminalUserByUserId(userId);
	}

	/**
	 * 跳转到个人设置
	 * @return
	 */
	@RequestMapping(value = "/preUserSetting")
	public String preUserSetting(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/user/userSetting";
	}

	/**
	 * 跳转到用户帮助和反馈
	 * 
	 * @return
	 * @authours hucheng
	 * @date 2016/2/22
	 * @content add
	 */
	@RequestMapping(value = "/preFeedBack")
	public String preFeedBack(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/user/mobileFeedback";
	}

	/**
	 * 跳转到关于文化云
	 */
	@RequestMapping(value = "/preCulture")
	public String preCulture(String type, HttpServletRequest request,String version) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		request.setAttribute("type", type);
		request.setAttribute("version", version!=null?version:"3.5.4");
		return "wechat/user/mobileCul";
	}

	/**
	 * 跳转到关于文化云
	 */
	@RequestMapping(value = "/preProtocol")
	public String preProtocol(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/user/mobileProtocol";
	}

	/**
	 * webchat用户反馈信息
	 * 
	 * @param cmsFeedback
	 *            反馈对象 return json 0.添加成功
	 */
	@RequestMapping(value = "/addWechatFeedBack")
	public String addWechatFeedBack(HttpServletResponse response, CmsFeedback cmsFeedback) throws Exception {
		int count = 0;
		String json = "";
		String feedImgUrl = "";
		if (cmsFeedback != null) {
			if (cmsFeedback.getFeedImgUrl() != null && StringUtils.isNotBlank(cmsFeedback.getFeedImgUrl())) {
				String[] feedImgUrls = cmsFeedback.getFeedImgUrl().split(";");
				for (String imgUrls : feedImgUrls) {
					int index = imgUrls.indexOf("front");
					feedImgUrl += imgUrls.substring(index, imgUrls.length()) + ";";
				}
				feedImgUrl = feedImgUrl.substring(0, feedImgUrl.length() - 1);
				cmsFeedback.setFeedImgUrl(feedImgUrl.toString());
				cmsFeedback.setFeedContent(EmojiFilter.filterEmoji(cmsFeedback.getFeedContent()));
			}
			count = cmsFeedbackService.insertFeedInformation(cmsFeedback);
		} else {
			json = JSONResponse.commonResultFormat(10111, "用户id或反馈内容为空!", null);
		}
		if (count > 0) {
			json = JSONResponse.commonResultFormat(0, "添加反馈信息成功!", null);
		} else {
			json = JSONResponse.commonResultFormat(1, "添加反馈信息失败!", null);
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().print(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * 跳转到用户收藏页面
	 * 
	 * @return listData
	 * @authours hucheng
	 * @date 2016/2/22
	 * @content add
	 */
	@RequestMapping(value = "/preMobileCollect")
	public String preMobileCollect() {

		return "wechat/user/mobileCollectIndex";
	}

	/**
	 * app显示用户收藏活动与展馆列表
	 * 
	 * @param userId
	 *            用户id
	 * @param activityName
	 *            活动名称
	 * @param venueName
	 *            展馆名称
	 * @param pageIndex
	 *            首页下标
	 * @param pageNum
	 *            显示条数
	 * @return json 10111:用户id不存在
	 */
	@RequestMapping(value = "/queryWebchatUserCollectList")
	public String queryWebchatUserCollectList(PaginationApp pageApp, HttpServletResponse response, String userId,
			String pageIndex, String pageNum, String activityName, String venueName, String searchText)
			throws Exception {
		String json = "";
		pageApp.setFirstResult(Integer.valueOf(pageIndex));
		pageApp.setRows(Integer.valueOf(pageNum));
		activityName = searchText;
		venueName = searchText;
		try {
			if (StringUtils.isNotBlank(userId) && userId != null) {
				json = userCollectAppService.queryAppUserCollectByCondition(userId, pageApp, 1, 2, activityName,
						venueName);
			} else {
				json = JSONResponse.commonResultFormat(10111, "用户id不存在", null);
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.info("query userCollect error!" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * 跳转到用户信息列表页
	 * 
	 * @return
	 * @authours
	 * @date 2016/2/22
	 * @content add
	 */
	@RequestMapping(value = "/preMobileMessage")
	public String preMobileMessage() {

		return "wechat/user/mobileMessage";
	}

	/**
	 * 个人积分
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/userIntegral")
	public String userIntegral(HttpServletRequest request) {
		return "wechat/user/userIntegral";
	}

	/**
	 * 个人积分
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/userIntegralAll")
	public String userIntegralAll(HttpServletRequest request) {
		return "wechat/user/userIntegralAll";
	}

	/**
	 * 3.5.2 app 用户近30天积分列表
	 * 
	 * @param response
	 * @param userId
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/userIntegralDetail")
	public String queryUserIntegralDetail(HttpServletRequest request,PaginationApp pageApp, Integer pageIndex, Integer pageNum,
			HttpServletResponse response, String userId) throws Exception {
		String json = "";

		try {
			if (StringUtils.isNotBlank(userId)) {

				if (pageIndex != null && pageNum != null) {
					pageApp.setFirstResult(Integer.valueOf(pageIndex));
					pageApp.setRows(Integer.valueOf(pageNum));
				}

				Calendar calendar = Calendar.getInstance();
				calendar.setTime(new Date());
				calendar.set(Calendar.DATE, calendar.get(Calendar.DATE) - 30);
				Date beforeDate = calendar.getTime();

				json = terminalUserAppService.queryUserIntegralDetail(pageApp, userId, beforeDate);
			} else {
				json = JSONResponse.commonResultFormat(10111, "用户id缺失", null);
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.info("query queryUserIntegralDetail error" + e.getMessage());
			json = JSONResponse.toAppResultFormat(0, "系统异常");
		}

		response.setContentType("text/html;charset=UTF-8");
		//跨域
		String callback = request.getParameter("callback");
		if(callback!=null){
			response.getWriter().print(callback+"("+json+")");
		}else{
			response.getWriter().print(json);
		}
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * 3.5.2 app 用户详细积分列表
	 * 
	 * @param response
	 * @param userId
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/userIntegralDetailAll")
	public String queryUserIntegralDetailList(HttpServletRequest request,PaginationApp pageApp, Integer pageIndex, Integer pageNum,
			HttpServletResponse response, String userId) throws Exception {
		String json = "";

		try {
			if (StringUtils.isNotBlank(userId)) {

				if (pageIndex != null && pageNum != null) {
					pageApp.setFirstResult(Integer.valueOf(pageIndex));
					pageApp.setRows(Integer.valueOf(pageNum));
				}

				json = terminalUserAppService.queryUserIntegralDetail(pageApp, userId, null);
			} else {
				json = JSONResponse.commonResultFormat(10111, "用户id缺失", null);
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.info("query queryUserIntegralDetail error" + e.getMessage());

			json = JSONResponse.toAppResultFormat(0, "系统异常");
		}

		response.setContentType("text/html;charset=UTF-8");
		//跨域
		String callback = request.getParameter("callback");
		if(callback!=null){
			response.getWriter().print(callback+"("+json+")");
		}else{
			response.getWriter().print(json);
		}
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * app获取用户信息
	 * 
	 * @param userId
	 *            用户id
	 * @return json 10111:用户id不存在
	 */
	@RequestMapping(value = "/userWebchatMessage")
	public String userWebchatMessage(HttpServletResponse response, String userId) throws Exception {
		String json = "";
		if (StringUtils.isNotBlank(userId) && userId != null) {
			json = userMessageAppService.queryUserMessageById(userId);
		} else {
			json = JSONResponse.commonResultFormat(10111, "用户id缺失!", null);
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * wechat修改用户信息 根据用户id
	 * 
	 * @param terminalUser
	 *            用户对象
	 * @return json 10111:用户id不存在 13108.查无此人 0.更新成功 1.更新失败
	 */
	@RequestMapping(value = "/editTerminalUser")
	public String editTerminalUser(HttpServletResponse response, CmsTerminalUser terminalUser) throws Exception {
		String json = "";
		try {
			if (terminalUser != null && StringUtils.isNotBlank(terminalUser.getUserId())) {
				CmsTerminalUser updateTerminalUser = terminalUserAppService
						.queryTerminalUserByUserId(terminalUser.getUserId());
				json = terminalUserAppService.editTerminalUserById(updateTerminalUser, terminalUser);
			} else {
				json = JSONResponse.commonResultFormat(10111, "用户id缺失", null);
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.info("edit terminalUserInformation error" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().print(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * 进入用户消息详情页
	 * 
	 * @return
	 * @authours
	 * @date 2016/2/22
	 * @content add
	 */
	@RequestMapping(value = "/preMobileMessageDetail")
	public String preMobileMessageDetail(HttpServletRequest request, String userMessageId) {

		CmsUserMessage message = cmsUserMessageService.queryCmsUserMessageById(userMessageId);
		message.setUserMessageStatus("Y");
		cmsUserMessageMapper.updateUserMessageById(message);
		request.setAttribute("message", message);
		return "wechat/user/mobileMessageDetail";
	}

	/**
	 * 跳转到个人评论
	 * 
	 * @return
	 */
	@RequestMapping(value = "/myComment")
	public String myComment(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/user/myComment";
	}

	/**
	 * why3.5 个人设置-我的所有的活动评论
	 * 
	 * @param response
	 * @param pageApp
	 * @param pageIndex
	 * @param pageNum
	 * @param userId
	 * @throws Exception
	 */
	@RequestMapping(value = "/activityCommentList")
	public void activityCommentList(HttpServletResponse response, PaginationApp pageApp, String pageIndex,
			String pageNum, String userId) throws Exception {
		pageApp.setFirstResult(Integer.valueOf(pageIndex));
		pageApp.setRows(Integer.valueOf(pageNum));
		String json = "";
		try {
			if (StringUtils.isNotBlank(userId)) {
				json = commentAppService.queryAppActivityCommentByUserId(pageApp, userId);
			} else {
				json = JSONResponse.toAppResultFormat(0, "用户id缺失");
			}
		} catch (Exception e) {
			json = JSONResponse.toAppResultFormat(10107, e.getMessage());
			logger.info("query appRecommendActivity error:" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
	}

	/**
	 * why3.5 个人设置-我的所有的场馆评论
	 * 
	 * @param response
	 * @param pageApp
	 * @param pageIndex
	 * @param pageNum
	 * @param userId
	 * @throws Exception
	 */
	@RequestMapping(value = "/venueCommentList")
	public void venueCommentList(HttpServletResponse response, PaginationApp pageApp, String pageIndex, String pageNum,
			String userId) throws Exception {
		pageApp.setFirstResult(Integer.valueOf(pageIndex));
		pageApp.setRows(Integer.valueOf(pageNum));
		String json = "";
		try {
			if (StringUtils.isNotBlank(userId)) {
				json = commentAppService.queryAppVenueCommentByUserId(pageApp, userId);
			} else {
				json = JSONResponse.toAppResultFormat(0, "用户id缺失");
			}
		} catch (Exception e) {
			json = JSONResponse.toAppResultFormat(10107, e.getMessage());
			logger.info("query appRecommendActivity error:" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
	}

	/**
	 * 跳转到个人收藏
	 * 
	 * @return
	 */
	@RequestMapping(value = "/myCollect")
	public String myCollect(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		return "wechat/user/mobileCollectIndex";
	}

	/**
	 * why3.5 wechat显示用户收藏活动列表
	 * 
	 * @param userId
	 *            用户id
	 * @param pageIndex
	 *            首页下标
	 * @param pageNum
	 *            显示条数
	 * @return json 10111:用户id不存在
	 */
	@RequestMapping(value = "/userCollectAct")
	public String userCollectAct(PaginationApp pageApp, HttpServletResponse response, String userId, String pageIndex,
			String pageNum) throws Exception {
		String json = "";
		try {
			if (StringUtils.isNotBlank(userId) && userId != null) {
				pageApp.setFirstResult(Integer.valueOf(pageIndex));
				pageApp.setRows(Integer.valueOf(pageNum));
				json = activityAppService.queryUserAppCollectAct(userId, pageApp);
			} else {
				json = JSONResponse.commonResultFormat(10111, "用户id不存在", null);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * why3.5 wechat显示用户收藏展馆列表
	 * 
	 * @param userId
	 *            用户id
	 * @param pageIndex
	 *            首页下标
	 * @param pageNum
	 *            显示条数
	 * @return json 10111:用户id不存在
	 */
	@RequestMapping(value = "/userCollectVen")
	public String userCollectVen(PaginationApp pageApp, HttpServletResponse response, String userId, String pageIndex,
			String pageNum) throws Exception {
		String json = "";
		try {
			if (StringUtils.isNotBlank(userId) && userId != null) {
				pageApp.setFirstResult(Integer.valueOf(pageIndex));
				pageApp.setRows(Integer.valueOf(pageNum));
				json = venueAppService.queryCollectVenue(userId, pageApp);
			} else {
				json = JSONResponse.commonResultFormat(10111, "用户id不存在", null);
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.info("query userCollectVen error!" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * why3.5 wechat显示或搜索用户活动与活动室订单信息（当前未过期订单）
	 * 
	 * @param userId
	 *            用户id
	 * @return json 10111:用户id不存在
	 */
	@RequestMapping(value = "/userOrder")
	public String userOrder(PaginationApp pageApp, HttpServletResponse response, Integer pageIndex, Integer pageNum,
			String userId) throws Exception {
		String json = "";

		try {
			if (StringUtils.isNotBlank(userId)) {

				if (pageIndex != null && pageNum != null) {
					pageApp.setFirstResult(Integer.valueOf(pageIndex));
					pageApp.setRows(Integer.valueOf(pageNum));
				}

				json = userOrderAppService.queryAppUserOrderByUserId(pageApp, userId);
			} else {
				json = JSONResponse.commonResultFormat(10111, "用户id缺失", null);
			}
		} catch (Exception e) {
			json = JSONResponse.toAppResultFormat(10112, e.getMessage());
			logger.info("query userOrder error" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().print(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}
	
	/**
	 * why3.6 wechat显示或搜索用户活动与活动室订单信息（待支付订单）
	 * 
	 * @param userId
	 *            用户id
	 * @return json 10111:用户id不存在
	 */
	@RequestMapping(value = "/userPayOrder")
	public String userPayOrder(PaginationApp pageApp, HttpServletResponse response, Integer pageIndex, Integer pageNum,
			String userId) throws Exception {
		String json = "";

		try {
			if (StringUtils.isNotBlank(userId)) {

				if (pageIndex != null && pageNum != null) {
					pageApp.setFirstResult(Integer.valueOf(pageIndex));
					pageApp.setRows(Integer.valueOf(pageNum));
				}

				json = userOrderAppService.queryAppUserPayOrderByUserId(pageApp, userId);
			} else {
				json = JSONResponse.commonResultFormat(10111, "用户id缺失", null);
			}
		} catch (Exception e) {
			json = JSONResponse.toAppResultFormat(10112, e.getMessage());
			logger.info("query userPayOrder error" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().print(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * why3.5 wechat显示或搜索用户活动与活动室历史订单信息（过期订单，即历史订单）
	 * 
	 * @param userId
	 *            用户id
	 * @return json 10111:用户id不存在
	 */
	@RequestMapping(value = "/userHistoryOrder")
	public String userHistoryOrderByUserId(PaginationApp pageApp, HttpServletResponse response, Integer pageIndex,
			Integer pageNum, String userId) throws Exception {
		String json = "";

		try {
			if (StringUtils.isNotBlank(userId)) {
				if (pageIndex != null && pageNum != null) {
					pageApp.setFirstResult(Integer.valueOf(pageIndex));
					pageApp.setRows(Integer.valueOf(pageNum));
				}

				json = userOrderAppService.queryAppUserHistoryOrderByUserId(pageApp, userId);
			} else {
				json = JSONResponse.commonResultFormat(10111, "用户id缺失", null);
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.info("query userOrdersByCondition error" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().print(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * why3.5.2 wechat显示或搜索用户活动室待审核订单（当前未过期订单）
	 * 
	 * @param userId
	 *            用户id
	 * @return json 10111:用户id不存在
	 */
	@RequestMapping(value = "/userCheckOrder")
	public String queryAppUserCheckOrderByUserId(PaginationApp pageApp, HttpServletResponse response, Integer pageIndex,
			Integer pageNum, String userId) throws Exception {
		String json = "";

		try {
			if (StringUtils.isNotBlank(userId)) {
				if (pageIndex != null && pageNum != null) {
					pageApp.setFirstResult(Integer.valueOf(pageIndex));
					pageApp.setRows(Integer.valueOf(pageNum));
				}

				json = userOrderAppService.queryAppUserCheckOrderByUserId(pageApp, userId);
			} else {
				json = JSONResponse.commonResultFormat(10111, "用户id缺失", null);
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.info("query userOrdersByCondition error" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().print(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * why3.5.2 wechat获取用户活动订单详情
	 * 
	 * @param userId
	 *            用户id
	 * @param activityOrderId
	 *            订单ID
	 */
	@RequestMapping(value = "/userActivityOrderDetail")
	public String userActivityOrderDetail(HttpServletResponse response, String userId, String activityOrderId)
			throws Exception {
		String json = "";
		try {
			if (StringUtils.isNotBlank(userId)) {
				json = userOrderAppService.queryAppUserActivityOrderDetail(userId, activityOrderId);
			} else {
				json = JSONResponse.toAppResultFormat(400, "用户id缺失");
			}
		} catch (Exception e) {
			json = JSONResponse.toAppResultFormat(500, e.getMessage());
			logger.info("query userActivityOrderDetail error" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().print(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * why3.5.2 app获取用户活动室订单详情
	 * 
	 * @param userId
	 *            用户id
	 * @param activityOrderId
	 *            订单ID
	 */
	@RequestMapping(value = "/userRoomOrderDetail")
	public String userRoomOrderDetail(HttpServletResponse response, String userId, String roomOrderId)
			throws Exception {
		String json = "";
		try {
			if (StringUtils.isNotBlank(userId)) {
				json = userOrderAppService.queryAppUserRoomOrderDetail(userId, roomOrderId);
			} else {
				json = JSONResponse.toAppResultFormat(400, "用户id缺失");
			}
		} catch (Exception e) {
			json = JSONResponse.toAppResultFormat(500, e.getMessage());
			logger.info("query userActivityOrderDetail error" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().print(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * 实名认证发送激活码
	 * 
	 * @param userId
	 * @param userMobileNo
	 * @return
	 * @throws IOException
	 */
	@RequestMapping("/sendAuthCode")
	public String sendAuthCode(HttpServletResponse response, String userId, String userTelephone) throws IOException {
		String json = "";
		try {
			CmsTerminalUser cmsTerminalUser = terminalUserAppService.queryTerminalUserByUserId(userId);
			if (StringUtils.isBlank(userId)) {
				json = JSONResponse.commonResultFormat(10111, "用户id缺失", null);
			} else if (!Constant.isMobile(userTelephone)) {
				json = JSONResponse.commonResultFormat(10222, "手机号码不规范!", null);
			} else {
				json = terminalUserAppService.sendAuthCode(cmsTerminalUser, userTelephone);
			}
		} catch (Exception e) {
			json = JSONResponse.toAppResultFormat(10112, e.getMessage());
			logger.info("发送实名认证激活码失败 error" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().print(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * 跳转到实名认证
	 * 
	 * @return
	 */
	@RequestMapping(value = "/auth")
	public ModelAndView auth(HttpServletRequest request, String userId, String roomOrderId, String tuserName,
			Integer tuserIsDisplay, String type) {

		ModelAndView model = new ModelAndView();

		if (StringUtils.isBlank(userId)) {
			CmsTerminalUser cmsTerminalUser = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);

			userId = cmsTerminalUser.getUserId();
		}

		CmsTerminalUser user = terminalUserService.queryTerminalUserById(userId);

		model.addObject("userType", user.getUserType());
		model.addObject("user", user);

		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);

		request.setAttribute("type", type);

		model.setViewName("wechat/user/auth");

		model.addObject("tuserName", tuserName);

		model.addObject("tuserIsDisplay", tuserIsDisplay);

		if (StringUtils.isNotBlank(roomOrderId)) {
			tuserIsDisplay = 0;

			CmsRoomOrder roomOrder = roomOrderService.queryCmsRoomOrderById(roomOrderId);

			String tuserId = roomOrder.getTuserId();

			if (tuserId != null) {
				CmsTeamUser tuser = teamUserService.queryTeamUserById(tuserId);

				if (tuser != null) {
					if (tuser.getTuserIsDisplay() == 1)
						tuserIsDisplay = 1;
					else 
						model.addObject("tuserId", tuser.getTuserId());
					
				}
			}

			model.addObject("tuserIsDisplay", tuserIsDisplay);

		}

		model.addObject("roomOrderId", roomOrderId);

		return model;
	}

	/**
	 * 用户实名认证
	 * 
	 * @param userId
	 * @param realName
	 * @param code
	 * @param idCardNo
	 * @param idCardPhotoUrl
	 * @return
	 * @throws IOException
	 */
	@RequestMapping(value = "/userAuth")
	public String userAuth(HttpServletResponse response, String userId, String nickName, String idCardPhotoUrl,
			String code, String idCardNo, String userTelephone, String userEmail) throws IOException {

		String json = "";

		try {

			json = terminalUserAppService.userAuth(userId, nickName, userTelephone, code, idCardNo, idCardPhotoUrl,
					userEmail);

		} catch (Exception e) {
			json = JSONResponse.toAppResultFormat(10112, e.getMessage());
			logger.info("实名认证失败 error" + e.getMessage());
			e.printStackTrace();
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().print(json);
		response.getWriter().flush();
		response.getWriter().close();

		return null;
	}

	/**
	 * 跳转到积分规则页面
	 * 
	 * @return
	 */
	@RequestMapping(value = "/preIntegralRule")
	public String preIntegralRule(HttpServletRequest request, String type) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		request.setAttribute("type", type);
		return "wechat/user/userIntegralRule";
	}
	
	 /**
     * 转发添加积分
     * @param response
     * @param userId
     * @param url
     * @return
     * @throws IOException 
     */
    @RequestMapping(value = "/forwardingIntegral")
    public String forwardingIntegral(HttpServletResponse response,@RequestParam String userId,@RequestParam String url) throws IOException{
    	String json="";
    	try {
    		if(userId != null){
        		userIntegralDetailService.forwardAddIntegral(userId, url);
    		}else{
    			json = JSONResponse.toAppResultFormat(500, "参数缺失");
    		}
    	}catch (Exception e) {
			json = JSONResponse.toAppResultFormat(10112, e.getMessage());
			logger.info("转发添加积分失败 error"+e.getMessage());
        }
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().print(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}
    
    /**
     * 用户点赞
     * @param relateId 点赞id
     * @param userId     用户id
     * @param type 点赞类型（1-场馆 2-活动 3-采编 4-非遗）
     * return
     */
    @RequestMapping(value = "/addUserWantgo")
    public String addUserWantgo(HttpServletResponse response, String relateId, String userId, Integer type) throws Exception {
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

    /**
     * 用户取消点赞
     * @param relateId 点赞id
     * @param userId     用户id
     * return
     */
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
    
    /**
     * 生成用户
     * @param 
     */
    @RequestMapping(value = "/createTerminalUser")
    @ResponseBody
    public String createTerminalUser(Integer num) {
    	for(int i=0;i<num;i++){
    		CmsTerminalUser tuser = new CmsTerminalUser();
    		tuser.setUserId(UUIDUtils.createUUId());
    		tuser.setUserName("createUser"+tuser.getUserId().substring(0,8));
    		tuser.setUserPwd("c4ca4238a0b923820dcc509a6f75849b");	//密码：1
    		tuser.setUserSex(1);
    		tuser.setCreateTime(new Date());
    		tuser.setUserIsLogin(1);
    		tuser.setUserType(1);
    		tuser.setLastLoginTime(new Date());
    		tuser.setLoginType(1);
    		tuser.setUserIsDisable(1);
    		tuser.setSourceCode(0);
    		Random ra = new Random();
    		int r = ra.nextInt(100000000);
    		/* 
    		 * 0 指前面补充零 
    		 * formatLength 字符总长度为 formatLength 
    		 * d 代表为正数。 
    		 */  
    		String newString = String.format("%08d", r);
    		tuser.setUserMobileNo("158"+newString);
    		int result = terminalUserService.insertTerminalUser(tuser);
    		if(result<=0){
    			System.out.println("false");
    		}
    		System.out.println(i+1);
    	}
    	System.out.println("OK");
        return "OK";
    }
}
