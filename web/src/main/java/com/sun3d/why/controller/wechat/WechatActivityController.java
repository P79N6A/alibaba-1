package com.sun3d.why.controller.wechat;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sun3d.why.util.*;

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
import com.culturecloud.model.request.activity.ActivityOrderVO;
import com.culturecloud.model.request.activity.ActivityWcDetailVO;
import com.culturecloud.model.request.activity.RecommendActivityVO;
import com.culturecloud.model.request.common.AddOrderIntegralReqVO;
import com.culturecloud.model.request.common.SysUserIntegralReqVO;
import com.sun3d.why.dao.UserIntegralDetailMapper;
import com.sun3d.why.dao.UserIntegralMapper;
import com.sun3d.why.enumeration.UserOperationEnum;
import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.CmsUserOperatorLog;
import com.sun3d.why.model.SysDict;
import com.sun3d.why.model.UserIntegral;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.redis.RedisDAO;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.CmsActivityOrderService;
import com.sun3d.why.service.CmsActivityService;
import com.sun3d.why.service.CmsAppSettingService;
import com.sun3d.why.service.CmsRoomOrderService;
import com.sun3d.why.service.CmsTerminalUserService;
import com.sun3d.why.service.CmsUserOperatorLogService;
import com.sun3d.why.service.UserIntegralService;
import com.sun3d.why.statistics.service.StatisticActivityUserService;
import com.sun3d.why.webservice.api.util.HttpResponseText;
import com.sun3d.why.webservice.service.ActivityAppService;
import com.sun3d.why.webservice.service.AdvertAppCalendarService;
import com.sun3d.why.webservice.service.AdvertAppRecommendService;
import com.sun3d.why.webservice.service.CollectAppService;
import com.sun3d.why.webservice.service.SysDicAppService;
import com.sun3d.why.webservice.service.TagAppService;
import com.sun3d.why.webservice.service.UserOrderAppService;

@RequestMapping("/wechatActivity")
@Controller
public class WechatActivityController {
	private Logger logger = LoggerFactory.getLogger(WechatActivityController.class);

	@Autowired
	private HttpSession session;
	@Autowired
	private ActivityAppService activityAppService;
	@Autowired
	private TagAppService tagAppService;
	@Autowired
	private CacheService cacheService;
	@Autowired
	private CollectAppService collectAppService;
	@Autowired
	private StatisticActivityUserService statisticActivityUserService;
	@Autowired
	private CmsActivityOrderService cmsActivityOrderService;
	@Autowired
	private CmsTerminalUserService terminalUserService;
	@Autowired
	private CmsRoomOrderService cmsRoomOrderService;
	@Autowired
	private SysDicAppService SysDicAppService;
	@Autowired
	private CmsAppSettingService cmsAppSettingService;
	@Autowired
	private AdvertAppRecommendService advertAppRecommendService;
	@Autowired
	private AdvertAppCalendarService advertAppCalendarService;
	@Autowired
	private CmsUserOperatorLogService cmsUserOperatorLogService;
	@Autowired
	private UserOrderAppService userOrderAppService;
	@Autowired
	private UserIntegralMapper userIntegralMapper;
	@Autowired
	private UserIntegralDetailMapper userIntegralDetailMapper;
	@Autowired
    private UserIntegralService userIntegralService;
	@Autowired
	private CmsActivityService cmsActivityService;
	@Autowired
	private RedisDAO<String> redisDao;
	@Autowired
	private StaticServer staticServer;

	/**
     * 活动首页
     * @return
     */
    @RequestMapping("/index")
    public String index(HttpServletRequest request){
        //微信权限验证配置
        String url = BindWS.getUrl(request);
        Map<String, String> sign = BindWS.sign(url, cacheService);
        request.setAttribute("sign", sign);
        CmsTerminalUser user = (CmsTerminalUser) session.getAttribute("terminalUser");
        if (user == null) {
            user = new CmsTerminalUser();
        }
        //1.在没有添加标签查询的情况下
        if(StringUtils.isBlank(user.getActivityThemeTagId())){
			String ids ="";
			//2.将默认全选标签
			List<CmsActivity> activityThemeList = activityAppService.queryActivityThemeByCode(Constant.ACTIVITY_TYPE);
			for (CmsActivity a:activityThemeList) {
				ids += a.getTagId()+",";
			}
			user.setActivityThemeTagId(ids.substring(0,ids.length()-1));
			session.setAttribute("terminalUser", user);
		}
        return "wechat/activity/activityIndex";
    }
	
	/**
	 * 活动搜索页
	 * @return
	 */
	@RequestMapping("/activitySearchIndex")
	public String activitySearchIndex() {
		return "wechat/activity/activitySearchIndex";
	}

	/**
	 * 活动详情页
	 * @param activityId
	 * @param type（fromComment：评论完跳转）
	 * @param showMenu (不显示菜单)
	 * @return
	 */
	@RequestMapping("/preActivityDetail")
	public String preActivityDetail(HttpServletRequest request, String activityId, String type, String showMenu) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		CmsActivity cmsActivity = cmsActivityService.queryFrontActivityByActivityId(activityId);
		request.setAttribute("sign", sign);
		request.setAttribute("activityId", activityId);
		request.setAttribute("activity", cmsActivity);
		request.setAttribute("type", type);
		request.setAttribute("showMenu", showMenu);
		request.setAttribute("cityName", staticServer.getCityInfo().split(",")[1]);
		return "wechat/activity/activityDetail";
	}
	
//	@RequestMapping("/preActivityOrderPay")
//	public String preActivityOrderPay(HttpServletRequest request,String activityOrderId,String openid){
//		
//		String url = BindWS.getUrl(request);
//		Map<String, String> sign = BindWS.sign(url, cacheService);
//		sign.put("appId", Constant.WX_APP_ID);
//		request.setAttribute("sign", sign);
//		request.setAttribute("activityOrderId", activityOrderId);
//		request.setAttribute("openId", openid);
//		
//		return "wechat/activity/activityOrderPay";
//	}
	
	@RequestMapping("/preActivityOrderPay")
	public String preActivityOrderPay(HttpServletRequest request,String activityOrderId){
		
		request.setAttribute("activityOrderId", activityOrderId);
		request.setAttribute("now", new Date());
		
		return "wechat/activity/activityOrderPay";
	}
	
	@RequestMapping("/activityOrderPaySuccess")
	public String activityOrderPaySuccess(HttpServletRequest request,String activityOrderId){
		
		request.setAttribute("activityOrderId", activityOrderId);
		return "wechat/activity/activityOrderPaySuccess";
	}

	@RequestMapping("/activityOrderPayError")
	public String activityOrderPayError(HttpServletRequest request,String activityOrderId){
		
		request.setAttribute("activityOrderId", activityOrderId);
		return "wechat/activity/activityOrderPayError";
	}


	/**
	 * 活动日历页
	 * @return
	 */
	@RequestMapping("/preActivityCalendar")
	public String preActivityCalendar(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		String relativeUrl = BindWS.getRelativeUrl(request);
		request.setAttribute("url", relativeUrl);
		request.setAttribute("today", DateUtils.formatDate(new Date()));
		return "wechat/activity/activityCalendar";
	}

	/**
	 * 我想去列表页
	 *
	 * @param activityId
	 * @return
	 */
	@RequestMapping("/preWantGo")
	public String preWantGo(HttpServletRequest request, String activityId) {
		request.setAttribute("activityId", activityId);
		return "wechat/activity/wantGoList";
	}

	/**
	 * 活动视频页
	 *
	 * @param activityId
	 * @return
	 */
	@RequestMapping("/preVideoList")
	public String preVideoList(HttpServletRequest request, String activityId) {
		request.setAttribute("activityId", activityId);
		return "wechat/activity/videoList";
	}

	/**
	 * 活动搜索结果页
	 *
	 * @param activityName
	 * @return
	 */
	@RequestMapping("/preActivityList")
	public String preActivityList(HttpServletRequest request, String activityName, String area, String activityType,
			String venueId, String activityIsReservation) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		request.setAttribute("activityName", activityName);
		request.setAttribute("area", area);
		request.setAttribute("venueId", venueId);
		request.setAttribute("activityType", activityType);
		request.setAttribute("activityIsReservation", activityIsReservation);
		request.setAttribute("cityName", staticServer.getCityInfo().split(",")[1]);
		return "wechat/activity/activityList";
	}

	/**
	 * 活动搜索结果页（根据类别或标签）
	 * 
	 * @param activityType
	 * @return
	 */
	@RequestMapping("/preActivityListTagSub")
	public String preActivityListTagSub(HttpServletRequest request, String activityType, String advertTitle) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		request.setAttribute("activityType", activityType);
		request.setAttribute("advertTitle", advertTitle);
		return "wechat/activity/activityListTagSub";
	}

	/**
	 * 根据活动类型进行筛选活动
	 *
	 * @param Lon
	 *            用户经度
	 * @param Lat
	 *            用户纬度
	 * @param pageIndex
	 *            开始位置
	 * @param pageNum
	 *            显示条数
	 * @param appType
	 *            活动类型筛选 1.距离 2.即将开始 3.热门 4.所有活动
	 * @param activityThemeTagId
	 *            活动（主题和类型）标签id
	 * @return json
	 */
	@RequestMapping(value = "/wcActivityIndex")
	public String wcActivityIndex(String pageIndex, String pageNum, PaginationApp pageApp, HttpServletResponse response,
			String appType, String Lon, String Lat, String activityTime, String activityThemeTagId, String userId)
			throws Exception {
		String json = "";
		pageApp.setFirstResult(Integer.valueOf(pageIndex));
		pageApp.setRows(Integer.valueOf(pageNum));
		switch (Integer.valueOf(appType)) {
		// 最热门的活动
		case 3:
			json = activityAppService.queryAppHotByActivity(pageApp, Lon, Lat, activityThemeTagId, appType, userId);
			break;
		// 最近活动或即将开始 所有活动
		default:
			json = activityAppService.queryActivityListPage(appType, pageApp, Lon, Lat, activityTime,
					activityThemeTagId, userId);
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * weChat查看活动详情
	 *
	 * @param userId
	 *            用户id
	 * @param activityId
	 *            活动id
	 * @return json 10107 活动id缺失
	 */
	@RequestMapping(value = "/activityWcDetail")
	public String activityWcDetail(HttpServletResponse response, ActivityWcDetailVO vo) throws Exception {
		if (StringUtils.isNotBlank(vo.getUserId())) {
			UserIntegral userIntegral = userIntegralService.selectUserIntegralByUserId(vo.getUserId());
            vo.setIntegralNow(userIntegral.getIntegralNow());
		}

		HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl() + "activity/activityDetail",
				vo);
		response.setContentType("text/html;charset=UTF-8");

		if (res.getHttpCode() == 500) {
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("status", 500);
			jsonObject.put("data", "超时");
			response.setContentType("text/html;charset=UTF-8");
			response.getWriter().print(jsonObject.toString());
			response.getWriter().flush();
			response.getWriter().close();
		} else {
			response.getWriter().write(res.getData());
			response.getWriter().flush();
			response.getWriter().close();

		}
		return null;
	}

	/**
	 * weChat根据标签随机推送3条活动
	 * 
	 * @param userId
	 *            用户id return
	 */
	// @RequestMapping(value = "/wcRandActivityList")
	// public String wcRandActivityList(HttpServletResponse response, String
	// userId) throws Exception {
	// String json = activityAppService.queryAppRandActivityListById(userId);
	// response.setContentType("text/html;charset=UTF-8");
	// response.getWriter().write(json);
	// response.getWriter().flush();
	// response.getWriter().close();
	// return null;
	// }

	/**
	 * wechat用户报名活动接口
	 *
	 * @param activityId
	 *            活动id
	 * @param userId
	 *            用户id return
	 */
	@RequestMapping(value = "/wcAddActivityUserWantgo")
	public String wcAddActivityUserWantgo(HttpServletResponse response, String activityId, String userId)
			throws Exception {
		String json = "";
		try {
			json = activityAppService.addActivityUserWantgo(activityId, userId);
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("add activityUserWantgo error" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * wechat用户取消报名活动接口
	 *
	 * @param activityId
	 *            活动id
	 * @param userId
	 *            用户id return
	 */
	@RequestMapping(value = "/deleteActivityUserWantgo")
	public String deleteActivityUserWantgo(HttpServletResponse response, String activityId, String userId)
			throws Exception {
		String json = "";
		try {
			json = activityAppService.deleteActivityUserWantgo(activityId, userId);
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("delete activityUserWantgo error" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * weChat获取活动报名列表接口
	 *
	 * @param activityId
	 *            活动id
	 * @param pageIndex
	 *            首页下标
	 * @param pageNum
	 *            显示条数 return
	 */
	@RequestMapping(value = "/wcActivityUserWantgoList")
	public String wcActivityUserWantgoList(HttpServletResponse response, String activityId, String pageIndex,
			String pageNum, PaginationApp pageApp) throws Exception {
		pageApp.setFirstResult(Integer.valueOf(pageIndex));
		pageApp.setRows(Integer.valueOf(pageNum));
		String json = "";
		try {
			json = activityAppService.queryAppActivityUserWantgoList(pageApp, activityId);
		} catch (Exception e) {
			e.printStackTrace();
			logger.info("query activityUserWantgoList error" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * weChat获取活动标签名称
	 *
	 * @return json
	 */
	@RequestMapping(value = "/wcActivityTagByType")
	public String wcActivityTagByType(HttpServletResponse response) throws Exception {
		String json = "";
		try {
			json = tagAppService.queryCmsActivityTagByCondition(Constant.ACTIVITY_MOOD, Constant.ACTIVITY_TYPE,
					Constant.ACTIVITY_CROWD);
		} catch (Exception e) {
			logger.debug("系统出错!");
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * wechat根据不同条件筛选活动列表(搜索功能)
	 *
	 * @param activityArea
	 * @param activityType
	 * @param activityName
	 * @param Lon
	 * @param Lat
	 * @param response
	 * @param pageIndex
	 * @param pageNum
	 * @param pageApp
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/wcCmsActivityListByCondition")
	public String wcCmsActivityListByCondition(String activityArea, String activityType, String activityName,
			String activityIsReservation, String Lon, String Lat, HttpServletResponse response, String pageIndex,
			String pageNum, PaginationApp pageApp) throws Exception {
		pageApp.setFirstResult(Integer.valueOf(pageIndex));
		pageApp.setRows(Integer.valueOf(pageNum));
		String json = "";
		try {
			json = activityAppService.queryAppCmsActivityListByCondition(activityArea, activityType, activityName,
					activityIsReservation, pageApp, Lon, Lat);
		} catch (Exception e) {
			e.printStackTrace();
			logger.info("query activityListByCondition error" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * weChat获取首页活动标签列表接口 return
	 */
	@RequestMapping(value = "/wcActivityTagList")
	public String wcActivityTagList(HttpServletResponse response, String userId) throws Exception {
		String json = activityAppService.queryAppActivityTagList(userId);
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * weChat获取未来天气借口（3.2移除） return
	 */
	@RequestMapping(value = "/wcWeatherList")
	public String wcWeatherList(HttpServletResponse response) throws Exception {
		BufferedReader reader = null;
		String result = null;
		StringBuffer sbf = new StringBuffer();
		String httpUrl = "http://apis.baidu.com/apistore/weatherservice/recentweathers?cityname=上海&cityid=101020100";

		try {
			URL url = new URL(httpUrl);
			HttpURLConnection connection = (HttpURLConnection) url.openConnection();
			connection.setRequestMethod("GET");
			// 填入apikey到HTTP header
			connection.setRequestProperty("apikey", "b02d64acff0e38238c4be1bdc2192243");
			connection.connect();
			InputStream is = connection.getInputStream();
			reader = new BufferedReader(new InputStreamReader(is, "UTF-8"));
			String strRead = null;
			while ((strRead = reader.readLine()) != null) {
				sbf.append(strRead);
				sbf.append("\r\n");
			}
			reader.close();
			result = sbf.toString();
			response.setContentType("text/html;charset=UTF-8");
			response.getWriter().write(result);
			response.getWriter().flush();
			response.getWriter().close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * wechat用户收藏活动
	 *
	 * @param userId
	 *            用户id
	 * @param activityId
	 *            活动id
	 * @return json 10121 用户id 或 活动id缺失 10122 用户已收藏成功 0.收藏成功 1收藏失败 10123.查无此人
	 * @throws Exception
	 */
	@RequestMapping(value = "/wcCollectActivity")
	public String wcCollectActivity(HttpServletRequest request, HttpServletResponse response, String userId,
			String activityId) throws Exception {
		String json = "";
		try {
			if (StringUtils.isNotBlank(userId) && StringUtils.isNotBlank(activityId)) {
				json = collectAppService.addCollectActivity(userId, activityId, request, statisticActivityUserService);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().print(json);
		return null;
	}

	/**
	 * wechat取消活动收藏
	 *
	 * @param userId
	 *            用户id
	 * @param activityId
	 *            活动id
	 * @return json 10121 用户id 或 活动id缺失 0 用户取消收藏成功 1取消收藏失败
	 */
	@RequestMapping(value = "/wcDelCollectActivity")
	public String wcDelCollectActivity(HttpServletRequest request, HttpServletResponse response, String userId,
			String activityId) throws Exception {
		String json = "";
		try {
			if (StringUtils.isNotBlank(userId) && StringUtils.isNotBlank(activityId)) {
				json = collectAppService.delCollectActivity(userId, activityId, request, statisticActivityUserService);
			} else {
				json = JSONResponse.commonResultFormat(10121, "用户或活动id缺失", null);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().print(json);
		return null;
	}

	/**
	 * wechat活动预定
	 *
	 * @param activityId
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/preActivityOrder")
	public ModelAndView preActivityOrder(String activityId, HttpServletRequest request, String userId) {
		ModelAndView model = new ModelAndView();
		request.setAttribute("activityId", activityId);
		
		if(StringUtils.isNotBlank(userId)){
			
			CmsTerminalUser user = terminalUserService.queryTerminalUserById(userId);
			
			String userMobileNo=user.getUserMobileNo();
			
			if(StringUtils.isBlank(userMobileNo)){
				userMobileNo=user.getUserTelephone();
			}
			
			model.addObject("userMobileNo",StringUtils.defaultIfBlank(userMobileNo, ""));
			model.addObject("userName", user.getUserName());
		}
		// 获取服务器当前时间
		Date currentDate = new Date();
		request.setAttribute("currentDate", currentDate.getTime());
		model.setViewName("wechat/activity/activityOrder");
		return model;
	}

	/**
	 * wechat进入提交订单
	 *
	 * @param activityId
	 *            活动id
	 * @param userId
	 *            用户id
	 * @param bookCount
	 *            订购张数
	 * @param orderMobileNum
	 *            预定电话
	 * @param orderName
	 *            姓名
	 * @param orderIdentityCard
	 *            身份证
	 * @param orderPrice
	 *            票价
	 * @param activityEventIds
	 *            活动场次id
	 * @param activityEventimes
	 *            活动具体时间
	 * @param costTotalCredit
	 *            参与此活动消耗的总积分数
	 * @return 14101 活动或用户id缺失
	 * @throws Exception
	 */
	@RequestMapping(value = "/wcActivityOrder")
	public String wcActivityOrder(HttpServletRequest request, HttpServletResponse response, String activityId,
			String userId, String activityEventIds, String bookCount, final String orderMobileNum, String orderPrice,
			String activityEventimes, String orderName, String orderIdentityCard, String costTotalCredit, String orderCustomInfo)
			throws Exception {
		String seatId = request.getParameter("seatIds");
		String seatValues = request.getParameter("seatValues");
		ActivityOrderVO vo = new ActivityOrderVO();
		vo.setActivityId(activityId);
		vo.setEventId(activityEventIds);
		vo.setUserId(userId);
		
		
		vo.setOrderPrice(BigDecimal.valueOf(Double.valueOf(orderPrice)));
		vo.setOrderName(orderName);
		vo.setOrderIdentityCard(orderIdentityCard);
		vo.setOrderPhoneNo(orderMobileNum);
		vo.setCostTotalCredit(costTotalCredit);
		vo.setOrderSummary(seatValues);
		vo.setSeatIds(seatId);
		vo.setOrderVotes(Integer.valueOf(bookCount));
		vo.setActivityOrderId(UUIDUtils.createUUId());
		vo.setOrderCustomInfo(orderCustomInfo);

		// 积分验证
		final CmsActivity cmsActivity = cmsActivityService.queryFrontActivityByActivityId(activityId);
		
		Integer activityIsFree= cmsActivity.getActivityIsFree();
		
		System.out.println("orderPrice==================="+vo.getOrderPrice());
		
		if(activityIsFree==3&&(orderPrice==null||orderPrice.trim().equals("")))
		{
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("status", 600);
			jsonObject.put("data", "请更新最新版本");
			response.setContentType("text/html;charset=UTF-8");
			response.getWriter().print(jsonObject.toString());
			response.getWriter().flush();
			response.getWriter().close();
		}
		//是否超出下单截止时间判断
		Date cancelEndTime = cmsActivity.getCancelEndTime();
		if(cancelEndTime!=null && cancelEndTime.before(new Date())){

			JSONObject jsonObject = new JSONObject();
			jsonObject.put("status", 300);
			jsonObject.put("data", "预订失败，超出预订截止时间！");
			response.setContentType("text/html;charset=UTF-8");
			response.getWriter().print(jsonObject.toString());
			response.getWriter().flush();
			response.getWriter().close();
			return null;
		}
		
		boolean isFree=true;
		
		if(activityIsFree!=null&&activityIsFree==3){
			isFree=false;
		}
		
		AddOrderIntegralReqVO orderIntegralvo = new AddOrderIntegralReqVO();
		orderIntegralvo.setUserId(userId);
		orderIntegralvo.setOrderCostTotalCredit(costTotalCredit);
		orderIntegralvo.setLowestCredit(cmsActivity.getLowestCredit());
		orderIntegralvo.setActivityOrderId(vo.getActivityOrderId());
		HttpResponseText res = CallUtils.callUrlHttpPost(
				staticServer.getPlatformDataUrl() + "integral/validateOrderIntegral", orderIntegralvo);
		JSONObject jsonObject = JSON.parseObject(res.getData());
		if (jsonObject.get("data").toString().equals("success")) {
			res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl() + "order/add", vo);
			if (res.getHttpCode() == 500) {
				jsonObject = new JSONObject();
				jsonObject.put("status", 500);
				jsonObject.put("data", "超时");
				response.setContentType("text/html;charset=UTF-8");
				response.getWriter().print(jsonObject.toString());
				response.getWriter().flush();
				response.getWriter().close();
			} else {
				jsonObject = JSON.parseObject(res.getData());
				if (jsonObject.get("status").toString().equals("1")) { // 返回订单号
					// 积分扣除
					CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl() + "integral/addOrderIntegral",
							orderIntegralvo);
				}
				response.getWriter().write(res.getData());
				response.getWriter().flush();
				response.getWriter().close();
				if (jsonObject.get("data") != null && isFree) {	//非支付活动发送短信
					String result = JSON.parseObject(jsonObject.get("data").toString(), String.class);
					if (result.length() == 10) {
						final Map<String,Object> map = new HashMap<String,Object>();
						String activityName = "";
						String time = "";
						if (cmsActivity.getSingleEvent() == 1) {
							String[] eventDateTime = activityEventimes.split(" ");
							String[] strdata = cmsActivity.getActivityStartTime().split("-");
							String[] enddata = cmsActivity.getActivityEndTime().split("-");
							if (cmsActivity.getActivityStartTime().equals(cmsActivity.getActivityEndTime())) {
								activityName = strdata[1] + "月" + strdata[2] + "日" + cmsActivity.getActivityName();
								time = cmsActivity.getActivityStartTime() + " " + eventDateTime[1];
							} else {
								activityName = strdata[1] + "月" + strdata[2] + "日——" + enddata[1] + "月"
										+ enddata[2] + "日" + cmsActivity.getActivityName();
								time = cmsActivity.getActivityStartTime() + "——"
										+ cmsActivity.getActivityEndTime() + " " + eventDateTime[1];
							}
						}else{
							String[] eventDateTime = activityEventimes.split(" ");
							String[] data = eventDateTime[0].split("-");
							activityName = data[1] + "月" + data[2] + "日" + cmsActivity.getActivityName();
							time = activityEventimes;
						}
						
						if (cmsActivity.getActivitySmsType() == null || cmsActivity.getActivitySmsType() == 0) {	//默认、取票码入场
							map.put("userName", orderName);
							map.put("activityName", activityName);
							map.put("time", time);
							map.put("ticketCount", bookCount);
							map.put("ticketNum", "(" + result + ")");
							map.put("ticketCode", result);
						}else if(cmsActivity.getActivitySmsType() == 1 || cmsActivity.getActivitySmsType() == 2){	//纸质票入场、入场凭证入场
							map.put("username", orderName);
							map.put("activityName", activityName);
							map.put("time", time);
							map.put("num", bookCount);
							map.put("yzcode", result);
						}
							
						Runnable runnable = new Runnable() {
							@Override
							public void run() {
								if (cmsActivity.getActivitySmsType() == null || cmsActivity.getActivitySmsType() == 0) {
									SmsUtil.sendActivityOrderSms(orderMobileNum, map);
								}else if(cmsActivity.getActivitySmsType() == 1){
									SmsUtil.sendActivityOrderSms2(orderMobileNum, map);
								}else if(cmsActivity.getActivitySmsType() == 2){
									SmsUtil.sendActivityOrderSms3(orderMobileNum, map);
								}
							}
						};
						Thread thread = new Thread(runnable);
						thread.start();
					}
				}
			}
		} else {
			jsonObject.put("status", "0");
			response.setContentType("text/html;charset=UTF-8");
			response.getWriter().write(jsonObject.toString());
			response.getWriter().flush();
			response.getWriter().close();
		}
		return null;
	}

	/**
	 * wechat显示或搜索用户活动与活动室订单信息（当前与历史）
	 *
	 * @param userId
	 *            用户id
	 * @param orderValidateCode
	 *            取票码
	 * @param venueName
	 *            展馆名称
	 * @param activityName
	 *            活动名称
	 * @param orderNumber
	 *            订单号
	 * @return json 10111:用户id不存在
	 */
	@RequestMapping(value = "/userOrders")
	public String userOrders(PaginationApp pageApp, HttpServletResponse response, String pageIndex, String pageNum,
			String userId, String orderValidateCode, String venueName, String activityName, String orderNumber)
			throws Exception {
		String json = "";
		pageApp.setFirstResult(Integer.valueOf(pageIndex));
		pageApp.setRows(Integer.valueOf(pageNum));
		try {
			if (StringUtils.isNotBlank(userId) && userId != null) {
				json = userOrderAppService.queryAppOrdersById(pageApp, userId, orderValidateCode, venueName,
						activityName, orderNumber);
			} else {
				json = JSONResponse.commonResultFormat(10111, "用户id缺失", null);
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.info("query userOrders error" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().print(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * app取消用户活动
	 *
	 * @return json 10112:用户与活动订单id缺失 10111 用户不存在 0订单取消成功 @ 在线选座 传
	 * activityOrderId和 orderLine,自由入座 activityOrderId
	 */
	@RequestMapping(value = "/removeAppActivity")
	public String removeAppActivity(HttpServletResponse response, String userId, String activityOrderId,
			String orderSeat,String jobType) throws Exception {
		JSONObject jsonObject = new JSONObject();
		try {
			Map map = new HashMap();
			if (StringUtils.isNotBlank(userId) && StringUtils.isNotBlank(activityOrderId)) {
				CmsTerminalUser terminalUser = terminalUserService.queryTerminalUserById(userId);
				if (terminalUser != null) {
					System.out.println("removeAppActivity====="+jobType);
					map = cmsActivityOrderService.cancelUserOrder(activityOrderId, terminalUser, orderSeat, null,jobType);
					if ("Y".equals(map.get("success"))) {
						jsonObject.put("data", "订单取消成功!");
						jsonObject.put("status", 0);
					} else if ("N".equals(map.get("success"))) {
						jsonObject.put("status", 1);
						jsonObject.put("data", map.get("msg"));
					}else if("S".equals(map.get("success"))){
						jsonObject.put("status", 2);
						jsonObject.put("data", map.get("msg"));
					}
				} else {
					jsonObject.put("data", "用户不存在!");
					jsonObject.put("status", 10111);
				}
			} else {
				jsonObject.put("data", "用户与活动订单id缺失!");
				jsonObject.put("status", 10112);
			}
		} catch (Exception e) {
			logger.error("系统错误!", e);
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().print(jsonObject.toString());
		return null;
	}

	/**
	 * app取消用户活动室
	 *
	 * @return json 10114:用户或活动室id缺失 10111用户id缺失 0 取消活动室预定成功
	 */
	@RequestMapping(value = "/removeAppRoomOrder")
	public String removeAppRoomOrder(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String json = "";
		String userId = request.getParameter("userId");
		String roomOrderId = request.getParameter("roomOrderId");
		try {
			if (StringUtils.isNotBlank(userId) && StringUtils.isNotBlank(roomOrderId)) {
				CmsTerminalUser terminalUser = terminalUserService.queryTerminalUserById(userId);
				if (terminalUser != null) {
					boolean cancelResult = cmsRoomOrderService.cancelRoomOrder(roomOrderId, terminalUser.getUserName());
					if (cancelResult) {

						CmsUserOperatorLog record = CmsUserOperatorLog.createInstance(null, roomOrderId, null, userId,
								CmsUserOperatorLog.USER_TYPE_NORMAL, UserOperationEnum.CANCEL);

						cmsUserOperatorLogService.insert(record);

						json = JSONResponse.commonResultFormat(0, "取消活动室预定成功!", null);
					} else if (cancelResult == false) {
						json = JSONResponse.commonResultFormat(2, "该活动室已取消!", null);
					} else {
						json = JSONResponse.commonResultFormat(1, "取消活动室失败!", null);
					}
				} else {
					json = JSONResponse.commonResultFormat(10115, "该用户不存在!", null);
				}
			} else {
				json = JSONResponse.commonResultFormat(10114, "用户或活动室id缺失!", null);
			}
		} catch (Exception e) {
			logger.info("活动室预定出错了");
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().print(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * app获取活动座位
	 *
	 * @param activityId
	 *            活动id
	 * @param userId
	 *            用户id
	 * @param activityEventimes
	 *            活动具体时间
	 * @return 14101 活动或用户参数缺失
	 * @throws Exception
	 */
	@RequestMapping(value = "/appActivityBook")
	public String appActivityBook(HttpServletResponse response, String activityId, String eventId, String userId,
			String activityEventimes) throws Exception {
		String json = "";
		if (StringUtils.isEmpty(activityId) && StringUtils.isEmpty(userId)) {
			json = JSONResponse.commonResultFormat(14101, "活动或用户id缺失", null);
		} else {
			json = activityAppService.queryAppActivitySeatsById(activityId, userId, activityEventimes);
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * wechat活动预定 - 预定须知
	 *
	 * @return
	 */
	@RequestMapping(value = "/wcOrderNotice")
	public String wcOrderNotice(HttpServletRequest request, String orderNotice) {
		request.setAttribute("orderNotice", orderNotice);
		return "wechat/activity/orderNotice";
	}
	
	@Autowired
	private SmsUtil SmsUtil;

	@RequestMapping(value = "/wcOrderList")
	public String wcOrderList(HttpServletRequest request) {
		
		CmsTerminalUser terminalUser = (CmsTerminalUser) session.getAttribute(Constant.terminalUser);
		String userId = "";
		if(terminalUser==null){
			userId = request.getParameter("userId");
		}else{
			userId = terminalUser.getUserId();
		}

		CmsTerminalUser user = terminalUserService.queryTerminalUserById(userId);

		// 用户实名认证
		Integer userType = user.getUserType();

		request.setAttribute("userType", userType);

		long orderCount = userOrderAppService.queryAppUserOrderCountByUserId(userId);

		request.setAttribute("orderCount", orderCount);

		return "wechat/activity/activityOrderList";
	}

	/**
	 * wechat活动预定 - 选座界面
	 *
	 * @return
	 */
	@RequestMapping(value = "/wcOrderSeat")
	public String wcOrderSeat(String userId,String activityId, String activityEventimes, String userName, String userIdCard,
			String userPhone, String count, HttpServletRequest request) {
		request.setAttribute("activityId", activityId);
		request.setAttribute("activityEventimes", activityEventimes);
		request.setAttribute("userName", userName);
		request.setAttribute("userIdCard", userIdCard);
		request.setAttribute("userPhone", userPhone);
		request.setAttribute("count", count);
		if(StringUtils.isNotBlank(userId)){
			CmsTerminalUser user = terminalUserService.queryTerminalUserById(userId);
			String userMobileNo=user.getUserMobileNo();
			if(StringUtils.isBlank(userMobileNo)){
				userMobileNo=user.getUserTelephone();
			}
			request.setAttribute("userMobileNo",StringUtils.defaultIfBlank(userMobileNo, ""));
		}
		// 获取服务器当前时间
		Date currentDate = new Date();
		request.setAttribute("currentDate", currentDate.getTime());
		return "wechat/activity/activityOrderSeat";
	}

	/**
	 * wechat活动预定(选完座位)
	 *
	 * @return
	 */
	@RequestMapping(value = "/finishSeat")
	public String finishSeat(String activityId, String activityEventimes, String[] seatId, String[] seatValue,
			String userName, String userIdCard, String userPhone, HttpServletRequest request) {
		request.setAttribute("activityId", activityId);
		request.setAttribute("activityEventimes", activityEventimes);
		String seats = "";
		if (seatId != null) {
			for (int i = 0; i < seatId.length; i++) {
				if ("".equals(seats)) {
					seats += seatId[i];
					continue;
				}
				seats += "," + seatId[i];
			}
		}
		request.setAttribute("seats", seats);
		String seatValues = "";
		if (seatValue != null) {
			for (int i = 0; i < seatValue.length; i++) {
				if ("".equals(seatValues)) {
					seatValues += seatValue[i];
					continue;
				}
				seatValues += "," + seatValue[i];
			}
		}
		request.setAttribute("seatValues", seatValues);
		request.setAttribute("userName", userName);
		request.setAttribute("userIdCard", userIdCard);
		request.setAttribute("userPhone", userPhone);
		// 获取服务器当前时间
		Date currentDate = new Date();
		request.setAttribute("currentDate", currentDate.getTime());
		return "wechat/activity/activityOrder";
	}

	/**
	 * wechat即将开始与标签下的活动数目
	 *
	 * @param userId
	 *            用户id
	 * @param tagId
	 *            类型标签id
	 * @return json
	 */
	@RequestMapping(value = "/wcWillStartActivityCount")
	public void wcWillStartActivityCount(HttpServletResponse response, String userId, String tagId) throws Exception {
		String json = "";
		try {
			if (userId != null && StringUtils.isNotBlank(userId)) {
				json = activityAppService.queryAppWillStartActivityCount(userId, tagId);
			} else {
				json = JSONResponse.commonResultFormat(0, "用户id缺失", null);
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.info("系统出错!" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
	}

	/**
	 * wechat添加即将开始时的活动
	 *
	 * @return json
	 */
	@RequestMapping(value = "/wcAddWillStart")
	public void wcAddWillStart(HttpServletResponse response, String userId, String versionNo, String tagId)
			throws Exception {
		String json = "";
		try {
			if (userId != null && StringUtils.isNotBlank(userId)) {
				json = activityAppService.addAppWillStart(userId, versionNo, tagId);
			} else {
				json = JSONResponse.commonResultFormat(10107, "用户id缺失", null);
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.info("add willStart error" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
	}

	/**
	 * 跳转到即将开始
	 *
	 * @return
	 */
	@RequestMapping(value = "/preWillStart")
	public String preWillStart(HttpServletRequest request, String wxEvent) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		// 微信公众号菜单参数（1：展览；2：退休；3：运动；4：养生；5：DIY；6：赛事；7：培训；8：演出；9：旅行；10：亲子；11：电影；12：聚会；13：讲座；14：交友；15：美食；16：戏曲）
		request.setAttribute("wxEvent", wxEvent);
		return "wechat/activity/activityWillStart";
	}

	/**
	 * 跳转到地图活动
	 *
	 * @return
	 */
	@RequestMapping(value = "/preMap")
	public String preMap(HttpServletRequest request) {
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		request.setAttribute("sign", sign);
		CmsTerminalUser user = (CmsTerminalUser) session.getAttribute("terminalUser");
		if (user == null) {
			CmsTerminalUser users = new CmsTerminalUser();
			String Id = "47486962f28e41ceb37d6bcf35d8e5c3," + "bfb37ab6d52f492080469d0919081b2b,"
					+ "e4c2cef5b0d24b2793ac00fd1098e4e7," + "cf719729422c497aa92abdd47acdaa56,"
					+ "526091b990c3494d91275f75726c064f";
			users.setActivityThemeTagId(Id);
			session.setAttribute("terminalUser", users);
		}
		return "wechat/activity/activityMap";
	}

	/**
	 * wechat查询推荐的活动
	 *
	 * @param pageIndex
	 *            开始位置
	 * @param pageNum
	 *            显示条数
	 * @return json
	 */
	@RequestMapping(value = "/wcRecommendActivityList")
	public String wcRecommendActivityList(String pageIndex, String pageNum, PaginationApp pageApp,
			HttpServletResponse response) throws Exception {
		String json = "";
		pageApp.setFirstResult(Integer.valueOf(pageIndex));
		pageApp.setRows(Integer.valueOf(pageNum));
		try {
			json = activityAppService.queryRecommendActivityList(pageApp);
		} catch (Exception e) {
			json = JSONResponse.toAppResultFormat(1, e.getMessage());
			logger.info("query wcRecommendActivityList error" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * wechat查询推荐的活动（带筛选）
	 *
	 * @param activityArea
	 * @param activityLocation
	 *            区域商圈id
	 * @param activityIsFree
	 *            是否收费 1-免费 2-收费
	 * @param activityIsReservation
	 *            是否预定 1-不可预定 2-可预定
	 * @param sortType
	 *            排序 1-智能排序 2-热门排序 3-最新上线 4-即将结束
	 * @param pageIndex
	 *            开始位置
	 * @param pageNum
	 *            显示条数
	 * @return json
	 */
	@RequestMapping(value = "/wcFilterActivityList")
	public String wcFilterActivityList(String pageIndex, String pageNum, PaginationApp pageApp,
			HttpServletResponse response, String activityArea, String activityLocation, String activityIsFree,
			String activityIsReservation, String sortType) throws Exception {
		String json = "";
		pageApp.setFirstResult(Integer.valueOf(pageIndex));
		pageApp.setRows(Integer.valueOf(pageNum));
		try {
			json = activityAppService.queryFilterActivityList(pageApp, activityArea, activityLocation, activityIsFree,
					activityIsReservation, sortType);
		} catch (Exception e) {
			e.printStackTrace();
			logger.info("query wcFilterActivityList error" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * wechat查询标签置顶的活动
	 *
	 * @param tagId
	 * @param activityArea
	 * @param activityLocation
	 *            区域商圈id
	 * @param activityIsFree
	 *            是否收费 1-免费 2-收费
	 * @param activityIsReservation
	 *            是否预定 1-不可预定 2-可预定
	 * @param sortType
	 *            排序 1-智能排序 2-热门排序 3-最新上线 4-即将结束
	 * @param pageIndex
	 *            开始位置
	 * @param pageNum
	 *            显示条数
	 * @return json
	 */
	@RequestMapping(value = "/wcTopActivityList")
	public String wcTopActivityList(String pageIndex, String pageNum, String tagId, PaginationApp pageApp,
			HttpServletResponse response, String activityArea, String activityLocation, String activityIsFree,
			String activityIsReservation, String sortType, String Lon, String Lat) throws Exception {
		String json = "";
		pageApp.setFirstResult(Integer.valueOf(pageIndex));
		pageApp.setRows(Integer.valueOf(pageNum));
		try {
			json = activityAppService.queryTopActivityList(pageApp, tagId, activityArea, activityLocation,
					activityIsFree, activityIsReservation, sortType, Lon, Lat);
		} catch (Exception e) {
			e.printStackTrace();
			logger.info("query wcTopActivityList error" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * wechat查询首页的活动的浏览量、收藏量、评论量、余票、距离
	 *
	 * @return json
	 */
	@RequestMapping(value = "/wcIndexActivityAllCount")
	public String wcIndexActivityAllCount(String activityIds, HttpServletResponse response, String Lon, String Lat)
			throws Exception {
		String json = "";
		try {
			if (StringUtils.isNotBlank(activityIds)) {
				String[] activityId = activityIds.split(",");
				List<String> list = new ArrayList<String>();
				for (String id : activityId) {
					list.add(id);
				}
				json = activityAppService.queryAppIndexData(list, Lon, Lat);
			} else {
				json = JSONResponse.commonResultFormat(10107, "活动id缺失", null);
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.info("query wcIndexActivityAllCount error" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * 获取商圈所有数据
	 *
	 * @return
	 */
	@RequestMapping(value = "/getAllArea")
	@ResponseBody
	public Map<String, Object> getAllArea() {
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("status", 200);
		try {
			List<SysDict> dataList = SysDicAppService.queryAllArea();
			result.put("data", dataList);
			return result;
		} catch (Exception e) {
			e.printStackTrace();
			result.put("status", 500);
			result.put("data", "服务器响应失败");
		}
		return result;
	}

	/**
	 * wechat查询近期活动列表
	 *
	 * @param response
	 * @param pageIndex
	 *            显示下标
	 * @param pageNum
	 *            显示条数
	 * @param activityType
	 *            分类(活动标签id,以逗号拼接成字符串)
	 * @param activityArea
	 *            市区code
	 * @param activityLocation
	 *            区域商圈id
	 * @param sortType
	 *            排序类别 0-智能排序 1-离我最近 2-即将开始 3-即将结束 4-最新发布 5-人气最高 6-评价最好
	 * @param Lon
	 *            经度
	 * @param Lat
	 *            纬度
	 * @param chooseType
	 *            筛选类别 1(5天之内) 2(5-10天) 3(10-15天) 4(15天以后)
	 * @param isWeekend
	 *            是否周末 1-周末 0-工作日 空表示不选
	 * @param bookType
	 *            1-可预订 0-直达现场 空表示所有
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/wcNearActivity")
	public String wcNearActivity(String pageIndex, String pageNum, PaginationApp pageApp, HttpServletResponse response,
			String activityType, String activityArea, String activityLocation, String sortType, String Lon, String Lat,
			String chooseType, String isWeekend, String bookType) throws Exception {
		pageApp.setFirstResult(Integer.valueOf(pageIndex));
		pageApp.setRows(Integer.valueOf(pageNum));
		String json = "";
		try {
			json = activityAppService.queryNearActivityByCondition(pageApp, activityType, activityArea,
					activityLocation, sortType, Lon, Lat, chooseType, isWeekend, bookType);
		} catch (Exception e) {
			json = JSONResponse.toAppResultFormat(10107, e.getMessage());
			logger.info("query wcNearActivity error" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * wechat附近活动列表
	 *
	 * @param response
	 * @param pageApp
	 * @param pageIndex
	 * @param pageNum
	 * @param Lon
	 * @param Lat
	 * @param activityType
	 * @param activityIsFree
	 *            是否收费 1-免费 2-收费
	 * @param activityIsReservation
	 *            是否预定 1-不可预定 2-可预定
	 * @param sortType
	 *            排序 1-智能排序 2-热门排序 3-最新上线 4-即将结束 5-离我最近
	 * @throws Exception
	 */
	@RequestMapping(value = "/wcNearActivityList")
	public void wcNearActivityList(HttpServletResponse response, PaginationApp pageApp, String pageIndex,
			String pageNum, String Lon, String Lat, String activityType, String activityIsFree,
			String activityIsReservation, String sortType) throws Exception {
		pageApp.setFirstResult(Integer.valueOf(pageIndex));
		pageApp.setRows(Integer.valueOf(pageNum));
		String json = "";
		try {
			json = activityAppService.queryAppNearActivityList(pageApp, activityType, activityIsFree,
					activityIsReservation, sortType, Lon, Lat);
		} catch (Exception e) {
			json = JSONResponse.toAppResultFormat(10107, "请求失败！");
			logger.info("query wcNearActivityList error:" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
	}

	/**
	 * wechat获取浏览量
	 *
	 * @param activityId
	 *            活动id return
	 */
	@RequestMapping(value = "/wcCmsActivityBrowseCount")
	public String wcCmsActivityBrowseCount(HttpServletResponse response, String activityId) throws Exception {
		String json = "";
		try {
			if (StringUtils.isNotBlank(activityId)) {
				json = activityAppService.queryAppCmsActivityBrowseCount(activityId);
			} else {
				json = JSONResponse.commonResultFormat(14101, "活动id缺失", null);
			}
		} catch (Exception e) {
			json = JSONResponse.toAppResultFormat(10107, e.getMessage());
			logger.info("query wcCmsActivityBrowseCount error" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * wechat查询广告位列表(首页)
	 *
	 * @return
	 */
	@RequestMapping(value = "/wcAdvertRecommendList")
	public String wcAdvertRecommendList(HttpServletResponse response, String tagId) throws Exception {
		String json = "";
		try {
			json = advertAppRecommendService.queryAppAdvertRecommendList(tagId);
		} catch (Exception e) {
			json = JSONResponse.toAppResultFormat(500, "服务器响应失败");
			logger.info("query wcAdvertRecommendList error" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * wechat活动热门
	 *
	 * @return
	 */
	@RequestMapping(value = "/getActivityHot")
	public String getActivityHot(HttpServletResponse response) throws IOException {
		String json = "";
		try {
			json = tagAppService.activityHot();
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
	 * wechat新的活动天数参数
	 *
	 * @param response
	 *            ,type代表接口请求类型 1=代码请求活动热天数 2=代表热搜关键字
	 * @return json
	 */
	@RequestMapping(value = "/wcSettingPara")
	public String appSettingPara(HttpServletResponse response, String type) throws Exception {
		String json = "";
		Properties properties = new Properties();
		try {
			InputStream is = this.getClass().getClassLoader().getResourceAsStream("pro.properties");
			properties.load(is);
			if ("1".equals(type)) {
				List words = cmsAppSettingService.getList("hotDays");
				StringBuilder result = new StringBuilder();
				boolean flag = false;
				for (Object string : words) {
					if (flag) {
						result.append(",");
					} else {
						flag = true;
					}
					result.append(string);
				}
				json = JSONResponse.toAppResultFormat(0, result.toString());
			} else {
				List words = cmsAppSettingService.getList("activityHotKeywords");
				StringBuilder result = new StringBuilder();
				boolean flag = false;
				for (Object string : words) {
					if (flag) {
						result.append(",");
					} else {
						flag = true;
					}
					result.append(string);
				}
				json = JSONResponse.toAppResultFormat(0, result.toString());
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.info("appHotDaysNum error" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * wechat日历下每天活动场数
	 *
	 * @param response
	 * @param startDate
	 * @param endDate
	 * @throws Exception
	 */
	@RequestMapping(value = "/wcEveryDateActivityCount")
	public void wcEveryDateActivityCount(HttpServletResponse response, String startDate, String endDate, String version)
			throws Exception {
		String json = "";
		try {
			if (StringUtils.isNotBlank(startDate) && StringUtils.isNotBlank(endDate)) {
				json = activityAppService.queryEventDateActivityCount(startDate, endDate, version);
			} else {
				json = JSONResponse.toAppResultFormat(14101, "活动开始日期或活动结束日期缺失");
			}
		} catch (Exception e) {
			json = JSONResponse.toAppResultFormat(10107, e.getMessage());
			logger.info("query appEveryDateActivityCount error:" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
	}

	/**
	 * wechat日历下某一天活动列表
	 *
	 * @param response
	 * @param pageApp
	 * @param pageIndex
	 * @param pageNum
	 * @param everyDate
	 * @param Lon
	 * @param Lat
	 * @throws Exception
	 */
	@RequestMapping(value = "/wcEveryDateActivityList")
	public void wcEveryDateActivityList(HttpServletResponse response, PaginationApp pageApp, String pageIndex,
			String pageNum, String everyDate, String Lon, String Lat) throws Exception {
		pageApp.setFirstResult(Integer.valueOf(pageIndex));
		pageApp.setRows(Integer.valueOf(pageNum));
		String json = "";
		try {
			if (StringUtils.isNotBlank(everyDate)) {
				json = activityAppService.queryAppEveryDateActivityList(pageApp, everyDate, Lon, Lat);
			} else {
				json = JSONResponse.toAppResultFormat(0, "日期缺失");
			}
		} catch (Exception e) {
			json = JSONResponse.toAppResultFormat(10107, e.getMessage());
			logger.info("query appEveryDateActivityList error:" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
	}

	/**
	 * wechat日历下时间段活动场数
	 *
	 * @param response
	 * @param startDate
	 * @param endDate
	 * @throws Exception
	 */
	@RequestMapping(value = "/wcDatePartActivityCount")
	public void wcDatePartActivityCount(HttpServletResponse response, String startDate, String endDate)
			throws Exception {
		String json = "";
		try {
			if (StringUtils.isNotBlank(startDate) && StringUtils.isNotBlank(endDate)) {
				json = activityAppService.queryAppDatePartActivityCount(startDate, endDate);
			} else {
				json = JSONResponse.toAppResultFormat(200, "开始日期或结束日期缺失");
			}
		} catch (Exception e) {
			json = JSONResponse.toAppResultFormat(300, e.getMessage());
			logger.info("query appDatePartActivityCount error:" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
	}

	/**
	 * wechat根据不同条件查询月、周下活动列表
	 * @param response
	 * @param startDate
	 * @param endDate
	 * @param activityArea
	 * @param activityLocation 区域商圈id
	 * @param activityType
	 * @param activityIsFree 是否收费 1-免费 2-收费
	 * @param activityIsReservation 是否预定 1-不可预定 2-可预定
	 * @param pageIndex
	 * @param userId
	 * @param pageNum
	 * @param pageApp
	 * @param type (默认不传值，"month"：查询月开始活动)
	 * @throws Exception
	 */
	@RequestMapping(value = "/wcActivityCalendarList")
	public void wcActivityCalendarList(HttpServletResponse response, String startDate, String endDate,
			String activityArea, String activityLocation, String activityType, String activityIsFree,
			String activityIsReservation, String pageIndex, String userId, String pageNum, PaginationApp pageApp,
			String type) throws Exception {
		if (pageIndex != null && pageNum != null) {
			pageApp.setFirstResult(Integer.valueOf(pageIndex));
			pageApp.setRows(Integer.valueOf(pageNum));
		}
		String json = "";
		try {
			if (StringUtils.isNotBlank(startDate) && StringUtils.isNotBlank(endDate)) {
				json = activityAppService.queryAppActivityCalendarList(pageApp, startDate, endDate, activityArea,
						activityLocation, activityType, activityIsFree, activityIsReservation, userId, type);
			} else {
				json = JSONResponse.toAppResultFormat(200, "开始日期或结束日期缺失");
			}
		} catch (Exception e) {
			json = JSONResponse.toAppResultFormat(300, e.getMessage());
			logger.info("query appActivityList error:" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
	}

	/**
	 * wechat我的活动日历（历史预定活动）列表
	 *
	 * @param pageIndex
	 * @param userId
	 * @param pageNum
	 * @param pageApp
	 * @throws Exception
	 */
	@RequestMapping(value = "/wcHistoryActivityList")
	public void wcHistoryActivityList(HttpServletResponse response, String pageIndex, String userId, String pageNum,
			PaginationApp pageApp) throws Exception {
		if (pageIndex != null && pageNum != null) {
			pageApp.setFirstResult(Integer.valueOf(pageIndex));
			pageApp.setRows(Integer.valueOf(pageNum));
		}
		String json = "";
		try {
			if (StringUtils.isNotBlank(userId)) {
				json = activityAppService.queryAppHistoryActivityList(pageApp, userId);
			} else {
				json = JSONResponse.toAppResultFormat(200, "用户id缺失");
			}
		} catch (Exception e) {
			json = JSONResponse.toAppResultFormat(300, e.getMessage());
			logger.info("query appHistoryActivityList error:" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
	}

	/**
	 * wechat我的活动日历（月份预定活动及收藏）列表
	 *
	 * @param pageIndex
	 * @param userId
	 * @param pageNum
	 * @param pageApp
	 * @param startDate
	 * @param endDate
	 * @throws Exception
	 */
	@RequestMapping(value = "/wcMonthActivityList")
	public void wcMonthActivityList(HttpServletResponse response, String pageIndex, String userId, String pageNum,
			PaginationApp pageApp, String startDate, String endDate) throws Exception {
		if (pageIndex != null && pageNum != null) {
			pageApp.setFirstResult(Integer.valueOf(pageIndex));
			pageApp.setRows(Integer.valueOf(pageNum));
		}
		String json = "";
		try {
			if (StringUtils.isNotBlank(userId) && StringUtils.isNotBlank(startDate)
					&& StringUtils.isNotBlank(endDate)) {
				json = activityAppService.queryAppMonthActivityList(pageApp, userId, startDate, endDate);
			} else {
				json = JSONResponse.toAppResultFormat(200, "用户id或活动时间段缺失");
			}
		} catch (Exception e) {
			json = JSONResponse.toAppResultFormat(300, e.getMessage());
			logger.info("query appHistoryActivityList error:" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
	}

	/**
	 * wechat广告位(日历)
	 *
	 * @return
	 */
	@RequestMapping(value = "/queryCalendarAdvert")
	public String queryCalendarAdvert(HttpServletResponse response, String date) throws Exception {
		String json = "";
		try {
			json = advertAppCalendarService.queryCalendarAdvert(date);
		} catch (Exception e) {
			json = JSONResponse.toAppResultFormat(500, "服务器响应失败");
			logger.info("query wcAdvertCalendar error" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * wechat活动场次列表
	 *
	 * @return
	 */
	@RequestMapping(value = "/wcActivityEventList")
	public String wcActivitySpikeList(HttpServletResponse response, String activityId) throws Exception {
		String json = "";
		try {
			if (StringUtils.isNotBlank(activityId)) {
				json = activityAppService.queryActivityEventList(activityId);
			} else {
				json = JSONResponse.toAppResultFormat(400, "活动id缺失");
			}
		} catch (Exception e) {
			json = JSONResponse.toAppResultFormat(500, "服务器响应失败");
			logger.info("query wcActivitySpikeList error" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	/**
	 * 跳转活动订单详情
	 *
	 * @param request
	 * @param activityOrderId
	 * @return
	 */
	@RequestMapping(value = "/preActivityOrderDetail")
	public String preActivityOrderDetail(HttpServletRequest request, String activityOrderId) {
		request.setAttribute("activityOrderId", activityOrderId);
		return "wechat/activity/activityOrderDetail";
	}

	/**
	 * 获得首页猜你喜欢
	 * 
	 * @return
	 */
	@RequestMapping(value = "/getRecommendActivity.do")
	public String getRecommendActivity(HttpServletResponse response, RecommendActivityVO vo) throws Exception {
		HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl() + "activity/recommendActivity.do", vo);
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}

	@RequestMapping(value = "/userOrderLogin")
	public String userOrderLogin() {

		return "wechat/activity/userOrderLogin";
	}

	@RequestMapping(value = "/sendCode")
	@ResponseBody
	public String sendCode(@RequestParam String userMobileNo) {

		String code = SmsUtil.getValidateCode();

		redisDao.save("login_code_" + userMobileNo, code, 60);

		Map<String, Object> smsParams = new HashMap<>();
		smsParams.put("code", code);
		smsParams.put("product", Constant.PRODUCT);
		SmsUtil.sendActivityCode(userMobileNo, smsParams);

		return "success";

	}
	
	@RequestMapping(value = "/getCode")
	@ResponseBody
	public Map<String, String> getCode(@RequestParam String userMobileNo) {
		
		Map<String, String> map = new HashMap<String, String>();
		
		String value = redisDao.getData("login_code_" + userMobileNo);

		if (value == null) {
			map.put("errorMsg", "验证码已过期，请重新索取!");
			map.put("status", "error");
			return map;
		}
		else{
			
			map.put("status", "success");
			map.put("code", value);
			
		}
		
		return map;
	}

	@RequestMapping(value = "/mobileLogin")
	@ResponseBody
	public Map<String, String> mobileLogin(@RequestParam String userMobileNo, @RequestParam String code) {

		Map<String, String> map = new HashMap<String, String>();

		String value = redisDao.getData("login_code_" + userMobileNo);

		if (value == null) {
			map.put("errorMsg", "验证码已过期，请重新索取!");
			map.put("status", "error");
			return map;
		}

		if (!code.equals(value)) {
			map.put("errorMsg", "验证码不正确!");
			map.put("status", "error");
			return map;
		}

		//String userId = terminalUserService.getTerminalUserIdByMobileNo(userMobileNo);

	//if (StringUtils.isNotBlank(userId)) {

			CmsTerminalUser user = new CmsTerminalUser();
			user.setUserMobileNo(userMobileNo);

			session.setAttribute("terminalUser", user);

			map.put("status", "success");
	//	} else {
		//	map.put("errorMsg", "手机号对应账号不存在!");
		//	map.put("status", "error");
		//	return map;
		//}

		return map;
	}

	@RequestMapping(value = "/userOrderList")
	public String userOrderList() {

		return "wechat/activity/userOrderList";
	}

	@RequestMapping(value = "/searchOrderList")
    public String searchOrderList(@RequestParam String userMobileNo, HttpServletResponse response) throws Exception{

    	String json ;
    	
    	try {
		
				json = userOrderAppService.queryAppUserOrderByOrderPhoneNo(null, userMobileNo);
			
		} catch (Exception e) {
			json = JSONResponse.toAppResultFormat(10112, e.getMessage());
			logger.info("query userOrdersByCondition error" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().print(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
    }
	
	/**
	 * wechat3.6文化日历
	 * @param startDate
	 * @param endDate
	 * @param activityType (0：附近活动)
	 * @param pageIndex
	 * @param userId
	 * @param pageNum
	 * @param pageApp
	 * @throws Exception
	 */
	@RequestMapping(value = "/wcCultureCalendarList")
	public void wcCultureCalendarList(HttpServletResponse response, String selectDate ,
			String activityType, String pageIndex, String userId, String pageNum, PaginationApp pageApp ,String lon, String lat) throws Exception {
		if (pageIndex != null && pageNum != null) {
			pageApp.setFirstResult(Integer.valueOf(pageIndex));
			pageApp.setRows(Integer.valueOf(pageNum));
		}
		String json = "";
		try {
			if (StringUtils.isNotBlank(selectDate)) {
				json = activityAppService.queryCultureCalendarList(pageApp, selectDate, activityType, userId, lon, lat);
			} else {
				json = JSONResponse.toAppResultFormat(200, "日期参数缺失");
			}
		} catch (Exception e) {
			json = JSONResponse.toAppResultFormat(500, e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
	}
	
	/**
	 * wechat3.6我的文化日历（月份预定活动、体系内活动收藏和采集活动收藏）列表
	 * @param pageIndex
	 * @param userId
	 * @param pageNum
	 * @param pageApp
	 * @param startDate
	 * @param endDate
	 * @throws Exception
	 */
	@RequestMapping(value = "/wcMyCultureCalendarList")
	public void wcMyCultureCalendarList(HttpServletResponse response, String pageIndex, String userId, String pageNum,
			PaginationApp pageApp, String startDate, String endDate) throws Exception {
		if (pageIndex != null && pageNum != null) {
			pageApp.setFirstResult(Integer.valueOf(pageIndex));
			pageApp.setRows(Integer.valueOf(pageNum));
		}
		String json = "";
		try {
			if (StringUtils.isNotBlank(userId) && StringUtils.isNotBlank(startDate)
					&& StringUtils.isNotBlank(endDate)) {
				json = activityAppService.queryMyCultureCalendarList(pageApp, userId, startDate, endDate);
			} else {
				json = JSONResponse.toAppResultFormat(500, "参数缺失");
			}
		} catch (Exception e) {
			json = JSONResponse.toAppResultFormat(500, e.getMessage());
			logger.info("query wcMyCultureCalendarList error:" + e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
	}
	
	/**
	 * wechat3.6活动列表-标签位
	 * @throws Exception
	 */
	@RequestMapping(value = "/wcActivityListTagSub")
	public void wcActivityListTagSub(HttpServletResponse response) throws Exception {
		String json = activityAppService.queryActivityListTagSub();
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().write(json);
		response.getWriter().flush();
		response.getWriter().close();
	}
	
}
