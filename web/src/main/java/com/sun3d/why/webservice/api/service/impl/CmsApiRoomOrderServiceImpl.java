package com.sun3d.why.webservice.api.service.impl;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.sun3d.why.model.*;
import com.sun3d.why.service.CmsActivityRoomService;
import com.sun3d.why.service.CmsTeamUserService;
import com.sun3d.why.service.CmsTerminalUserService;
import com.sun3d.why.util.DateUtils;
import com.sun3d.why.util.StringUtils;
import com.sun3d.why.webservice.api.model.CmsApiOrder;
import com.sun3d.why.webservice.api.service.CmsApiRoomOrderService;
import com.sun3d.why.webservice.api.token.TokenHelper;
import com.sun3d.why.webservice.api.util.CmsApiOtherServer;
import com.sun3d.why.webservice.api.util.HttpClientConnection;
import com.sun3d.why.webservice.api.util.HttpResponseText;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/*
**
**@author lijing
**@version 1.0 2015年8月27日 下午8:24:05
*/
@Service
@Transactional
public class CmsApiRoomOrderServiceImpl implements CmsApiRoomOrderService {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Autowired
	private CmsActivityRoomService cmsActivityRoomService;
	@Autowired
	private CmsTerminalUserService terminalUserService;

	@Autowired
	private CmsTeamUserService cmsTeamUserService;
	@Autowired
	private CmsApiOtherServer cmsApiOtherServer;

	@Override
	public CmsApiOrder addOrder(CmsRoomBook cmsRoomBook, CmsTerminalUser terminalUser) {
		// 子系统添加预定接口
		CmsApiOrder apiOrder = new CmsApiOrder();
		apiOrder.setStatus(true);
		logger.info("开始向子系统发送请求.....");
		try {
			// 查询活动，判断活动的的外部系统的预定链接地址
			String roomId = cmsRoomBook.getRoomId();
			CmsActivityRoom cmsRoom = this.cmsActivityRoomService.queryCmsActivityRoomById(roomId);
			if (cmsRoom != null) {
				String sysNo = cmsRoom.getSysNo();
				String sysId = cmsRoom.getSysId();

				if (StringUtils.isNotNull(sysNo) && StringUtils.isNotNull(sysId)) {
					String token = TokenHelper.generateToken(terminalUser.getUserName());
					String userId = terminalUser.getUserId();

					String mobile = cmsRoomBook.getUserTel();
					String curDate=DateUtils.formatDate(cmsRoomBook.getCurDate());
					String openPeriod=cmsRoomBook.getOpenPeriod();
					
					String orderTime = curDate + " "+openPeriod;
					String teamName = "";
					String tId = cmsRoomBook.getTuserId();

					if (StringUtils.isNotNull(tId)) {
						CmsTeamUser teamUser = cmsTeamUserService.queryTeamUserById(tId);
						if (teamUser != null) {
							teamName = teamUser.getTuserName();
						}
					}


					JSONObject json = new JSONObject();
					json.put("sysNo", sysNo);
					json.put("token", token);
					json.put("userId", userId);
					json.put("roomId", sysId);
					json.put("mobile", mobile);
					json.put("orderTime", orderTime);
					json.put("tuserId", tId);
					json.put("userGropName", teamName);
					json.put("userGroupName", teamName);
					json.put("orderNumber", cmsRoomBook.getOrderNo());
					json.put("curDate", curDate);
					json.put("openPeriod", openPeriod);
					
				
					String url = cmsApiOtherServer.getVenueOrderUrl(sysNo);
					HttpResponseText httpResponseText = HttpClientConnection.post(url, json);
					if (httpResponseText.getHttpCode() == 200) {
						String result = httpResponseText.getData();

						apiOrder = JSON.parseObject(result, CmsApiOrder.class);
						apiOrder.setSysNo(sysNo);

					} else {
						apiOrder.setStatus(false);
						apiOrder.setMsg("系统请求子系统发生错误:" + httpResponseText.getData());
					}

				}
			}

			else {
				apiOrder.setStatus(true);
				apiOrder.setMsg("sysId,sysNo不存在，无须调用子系统预定功能!");
				logger.info("本地系统不需要向子系统发送活动室预定");
			}

		} catch (Exception e) {
			e.printStackTrace();
			apiOrder.setStatus(false);
			apiOrder.setMsg("发生未知错误：" + e.toString());
			logger.error("子系统发送预定申请时候发生错误：" + e.toString());
		}

		return apiOrder;
	}

	@Override
	public CmsApiOrder cancelOrder(CmsRoomOrder cmsRoomOrder) throws Exception {
		// 子系统取消预定接口
		CmsApiOrder apiOrder = new CmsApiOrder();
		apiOrder.setStatus(true);

		CmsTerminalUser terminalUser = null;
		try {
			// 查询活动，判断活动的的外部系统的预定链接地址
			String roomId = cmsRoomOrder.getRoomId();
			CmsActivityRoom cmsRoom = this.cmsActivityRoomService.queryCmsActivityRoomById(roomId);
			terminalUser = this.terminalUserService.queryTerminalUserById(cmsRoomOrder.getUserId());
			if (terminalUser != null) {
				String sysNo = cmsRoomOrder.getSysNo();
				String sysId = cmsRoomOrder.getSysId();
				if (StringUtils.isNotNull(sysNo) && StringUtils.isNotNull(sysId)) {
					String token = TokenHelper.generateToken(terminalUser.getUserName());
					String userId = terminalUser.getUserId();

					JSONObject json = new JSONObject();
					json.put("sysNo", sysNo);
					json.put("token", token);
					json.put("userId", userId);
					json.put("roomId", sysId);

					String url = cmsApiOtherServer.getVenueCancelOrderUrl(sysNo);

					HttpResponseText httpResponseText = HttpClientConnection.post(url, json);
					if (httpResponseText.getHttpCode() == 200) {
						String result = httpResponseText.getData();

						apiOrder = JSON.parseObject(result, CmsApiOrder.class);
					} else {
						apiOrder.setStatus(false);
						apiOrder.setMsg("系统请求子系统发生错误:" + httpResponseText.getData());
					}

				} else {
					apiOrder.setStatus(true);
					apiOrder.setMsg("sysId,sysNo不存在，无须调用子系统预定功能!");
					logger.info("本地系统不需要向子系统发送活动室预定");
				}
			} else {
				apiOrder.setStatus(false);
				apiOrder.setMsg("预定的用户不存在或被禁用!");
			}

		} catch (Exception e) {
			e.printStackTrace();
			logger.error("子系统取消预定申请时候发生错误：" + e.toString());
		}

		return apiOrder;

	}

}
