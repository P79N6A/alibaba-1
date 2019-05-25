package com.sun3d.why.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.httpclient.util.DateUtil;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.culturecloud.model.bean.live.CcpLiveActivity;
import com.culturecloud.model.bean.live.CcpLiveMessage;
import com.sun3d.why.dao.dto.CcpLiveActivityDto;
import com.sun3d.why.dao.dto.CcpLiveMessageDto;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.ccp.CcpAdvertRecommend;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CcpAdvertRecommendService;
import com.sun3d.why.service.CcpLiveActivityService;
import com.sun3d.why.service.CcpLiveMessageService;
import com.sun3d.why.service.UserIntegralDetailService;
import com.sun3d.why.service.UserIntegralService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.webservice.api.util.HttpClientConnection;

@RequestMapping("/live")
@Controller
public class CcpLiveController {

	private Logger logger = Logger.getLogger(CcpLiveController.class.getName());

	@Autowired
	private CcpLiveMessageService ccpLiveMessageService;

	@Resource
	private StaticServer staticServer;

	@Autowired
	private HttpSession session;

	@Autowired
	private CcpLiveActivityService ccpLiveActivityService;

	@Autowired
	private CcpAdvertRecommendService ccpAdvertRecommendService;
	
	@Autowired
	private UserIntegralDetailService userIntegralDetailService;


	@RequestMapping("/messageIndex")
	public ModelAndView messageIndex(CcpLiveMessage message, Pagination page) {
		ModelAndView model = new ModelAndView();

		List<CcpLiveMessageDto> list = ccpLiveMessageService.queryLiveMessageByCondition(message,null, page);
		model.addObject("list", list);
		model.addObject("page", page);
		model.addObject("entity", message);
		model.setViewName("admin/live/messageIndex");

		return model;
	}

	@RequestMapping("/liveCommentIndex")
	public ModelAndView liveCommentIndex(CcpLiveMessage message,String liveActvityName, Pagination page) {
		
		String userId= null;
		ModelAndView model = new ModelAndView();
		
		SysUser sysUser = (SysUser) session.getAttribute("user");
		if (sysUser != null) {
			
			 if(sysUser.getUserIsManger()==null||sysUser.getUserIsManger()!=1)
        	 {
				 userId = sysUser.getUserId();
        	 }
			 message.setMessageCreateUser(userId);
				message.setMessageIsInteraction(1);
				
				List<CcpLiveMessageDto> list = ccpLiveMessageService.queryLiveMessageByCondition(message,liveActvityName, page);

				model.addObject("list", list);
		}

	
		model.addObject("page", page);
		model.addObject("entity", message);
		model.addObject("liveActvityName", liveActvityName);
		model.setViewName("admin/live/messageIndex");

		return model;
	}
	
	
	@RequestMapping(value = "/preSaveLiveActivityMessage")
	public String saveLiveActivityMessage(String liveActivityId, HttpServletRequest request) {

		CcpLiveActivity CcpLiveActivity=ccpLiveActivityService.queryLiveActivityById(liveActivityId);
		
		request.setAttribute("liveActivity", CcpLiveActivity);

		request.setAttribute("aliImgUrl", staticServer.getAliImgUrl());

		return "admin/live/liveActivityMessage";
	}

	@RequestMapping(value = "/preSaveMessage")
	public String preSaveMessage(String messageId, HttpServletRequest request) {

		CcpLiveMessage message = new CcpLiveMessage();

		if (StringUtils.isNotBlank(messageId)) {

			message = ccpLiveMessageService.findById(messageId);
		}

		request.setAttribute("entity", message);

		request.setAttribute("aliImgUrl", staticServer.getAliImgUrl());

		return "admin/live/messageEntity";
	}
	
	
	@RequestMapping(value = "/preAddManyMessage")
	public String preAddManyMessage(String liveActivityId, HttpServletRequest request){
	
	CcpLiveActivity CcpLiveActivity=ccpLiveActivityService.queryLiveActivityById(liveActivityId);
		
		request.setAttribute("liveActivity", CcpLiveActivity);

		request.setAttribute("aliImgUrl", staticServer.getAliImgUrl());

		return "admin/live/addManyMessage";
		
	}
	
	
	
	
	@RequestMapping("/saveManyMessage")
	@ResponseBody
	public String saveManyMessage(String messageActivity, Integer commontNum,Integer likeNum) {
		try {
			SysUser sysUser = (SysUser) session.getAttribute("user");
			if (sysUser != null) {
				
				ccpLiveActivityService.addManyMessage(messageActivity,commontNum,likeNum);
					
				return Constant.RESULT_STR_SUCCESS;
			
			} else {
				return "login";
			}
		} catch (Exception e) {
			return Constant.RESULT_STR_FAILURE;
		}
	}

	@RequestMapping("/saveMessage")
	@ResponseBody
	public String saveMessage(CcpLiveMessage message) {

		try {
			SysUser sysUser = (SysUser) session.getAttribute("user");
			if (sysUser != null) {
				
				Integer messageIsRecommend=message.getMessageIsRecommend();
				
				if(messageIsRecommend!=null&&messageIsRecommend==1){
					message.setMessageRecommendTime(new Date());
				}
				
				int result = ccpLiveMessageService.saveMessage(message, sysUser);
				if (result > 0) {
					
					if(message.getMessageIsDel()!=null&&message.getMessageIsDel()==2){
						
						CcpLiveMessage m = ccpLiveMessageService.findById(message.getMessageId());

						userIntegralDetailService.liveCommentDeleteIntegral(m);
						
					}
					
					return Constant.RESULT_STR_SUCCESS;
				} else {
					return Constant.RESULT_STR_FAILURE;
				}
			} else {
				return "login";
			}
		} catch (Exception e) {
			return Constant.RESULT_STR_FAILURE;
		}
	}
	
	@RequestMapping("/saveLiveActivityMessage")
	@ResponseBody
	public String saveLiveActivityMessage(String messageContent,String messageActivity,String messageImg,
			
			Integer messageIsInteraction,Integer messageIsRecommend,String messageCreateTime,String messageRecommendTime){
		try {
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			
			CcpLiveMessage message=new CcpLiveMessage();
			
			message.setMessageActivity(messageActivity);
			message.setMessageContent(messageContent);
			message.setMessageImg(messageImg);
			message.setMessageIsInteraction(messageIsInteraction);
			message.setMessageIsRecommend(messageIsRecommend);
			
			Date mct=sdf.parse(messageCreateTime);
			message.setMessageCreateTime(mct);
			
			if(messageIsRecommend!=null&&messageIsRecommend==1)
			{
				Date mrt=sdf.parse(messageRecommendTime);
				message.setMessageRecommendTime(mrt);
				message.setSortTime(mrt.getTime());
			}
			else
			{
				message.setSortTime(mct.getTime());
			}
		
			
			int result = ccpLiveMessageService.saveAutoMessage(message);
			
			if(result>0){
				return Constant.RESULT_STR_SUCCESS;
			} else {
				return Constant.RESULT_STR_FAILURE;
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			return Constant.RESULT_STR_FAILURE;
		}
	}

	@RequestMapping("/setMessageTop")
	@ResponseBody
	public String setMessageTop(CcpLiveMessage message) {

		try {

			SysUser sysUser = (SysUser) session.getAttribute("user");
			if (sysUser != null) {

				int result = ccpLiveMessageService.setMessageTop(message, sysUser);
				if (result > 0) {
					return Constant.RESULT_STR_SUCCESS;
				} else {
					return Constant.RESULT_STR_FAILURE;
				}
			} else
				return "login";

		} catch (Exception e) {
			return Constant.RESULT_STR_FAILURE;
		}
	}

	// 直播活动状态 1.正在直播 2.尚未开始 3.已结束
	// 直播状态 0.未发布 1.已发布
	@RequestMapping("/liveActivityListIndex")
	public String liveActivityListIndex(HttpServletRequest request, Integer liveActivityTimeStatus, Integer liveStatus,
			Integer liveType,Integer liveCheck, Pagination page) {

		List<CcpLiveActivityDto> list = new ArrayList<CcpLiveActivityDto>();

		SysUser sysUser = (SysUser) session.getAttribute("user");
		if (sysUser != null) {
			
			String userId= null;
			
			 if(sysUser.getUserIsManger()==null||sysUser.getUserIsManger()!=1)
        	 {
				 userId = sysUser.getUserId();
        	 }

			list = ccpLiveActivityService.queryLiveActivityByCondition(userId, liveActivityTimeStatus, liveStatus,
					liveType,liveCheck, page);
		}

		request.setAttribute("liveActivityTimeStatus", liveActivityTimeStatus);
		
		request.setAttribute("liveStatus", liveStatus);
		
		request.setAttribute("liveCheck", liveCheck);

		request.setAttribute("list", list);

		request.setAttribute("page", page);

		return "admin/live/liveActivityListIndex";
	}

	@RequestMapping("/saveLiveActivity")
	@ResponseBody
	public String saveLiveActivity(CcpLiveActivity live) {

		try {
			SysUser sysUser = (SysUser) session.getAttribute("user");
			if (sysUser != null) {
				int result = ccpLiveActivityService.updateLiveActivity(live);
				if (result > 0) {
					return Constant.RESULT_STR_SUCCESS;
				} else {
					return Constant.RESULT_STR_FAILURE;
				}
			} else {
				return "login";
			}
		} catch (Exception e) {
			return Constant.RESULT_STR_FAILURE;
		}
	}

	/**
	 * App广告位列表
	 *
	 * @param
	 * @return
	 */
	@RequestMapping(value = "/liveAdvertRecommendIndex")
	public ModelAndView liveAdvertRecommendIndex(CcpAdvertRecommend advert) {
		ModelAndView model = new ModelAndView();
		try {
			advert.setAdvertPostion(5);
			advert.setAdvertType("A");
			List<CcpAdvertRecommend> list = ccpAdvertRecommendService.queryCcpAdvertRecommend(advert);
			model.addObject("list", list);
			model.setViewName("admin/live/liveAdvertIndex");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return model;
	}

	/**
	 * 运营位置添加页面
	 *
	 * @param advert
	 * @return
	 */
	@RequestMapping("/addAdvertIndex")
	public ModelAndView addAdvertIndex(CcpAdvertRecommend advert) {
		ModelAndView model = new ModelAndView();
		try {
			if (StringUtils.isNotBlank(advert.getAdvertId())) {
				List<CcpAdvertRecommend> list = ccpAdvertRecommendService.queryCcpAdvertRecommend(advert);
				if (list.size() > 0) {
					advert = list.get(0);
				}
			}
			model.addObject("advert", advert);
			model.setViewName("admin/live/liveAddAdvert");
		} catch (Exception e) {
		}
		return model;
	}

	@RequestMapping("/editAdvert")
	@ResponseBody
	public String editAdvert(CcpAdvertRecommend advert) {
		try {
			SysUser sysUser = (SysUser) session.getAttribute("user");
			if (StringUtils.isBlank(sysUser.getUserId())) {
				return "noLogin";
			}
			int result = ccpAdvertRecommendService.updateAdvert(advert, sysUser);
			if (result > 0)
				return Constant.RESULT_STR_SUCCESS;
		} catch (Exception e) {
			logger.error("editAdvert error {}", e);
		}
		return Constant.RESULT_STR_FAILURE;
	}
}
