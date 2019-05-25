package com.sun3d.why.webservice.api.service.impl;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.sun3d.why.dao.CmsActivityOrderDetailMapper;
import com.sun3d.why.model.*;
import com.sun3d.why.model.extmodel.BookActivitySeatInfo;
import com.sun3d.why.service.CmsActivityOrderDetailService;
import com.sun3d.why.service.CmsActivityOrderService;
import com.sun3d.why.service.CmsActivityService;
import com.sun3d.why.service.CmsTerminalUserService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.StringUtils;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.api.model.CmsApiData;
import com.sun3d.why.webservice.api.model.CmsApiMessage;
import com.sun3d.why.webservice.api.model.CmsApiOrder;
import com.sun3d.why.webservice.api.service.CmsApiActivityOrderService;
import com.sun3d.why.webservice.api.token.TokenHelper;
import com.sun3d.why.webservice.api.util.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.Map;

/*
**@Comments 预定API操作，调用预定系统的API操作
**@author lijing
**@version 1.0 2015年8月24日 下午2:44:09
*/
@Service
@Transactional
public class CmsApiActivityOrderServiceImpl implements CmsApiActivityOrderService {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Autowired
	private CmsTerminalUserService terminalUserService;
	
	@Autowired
	private CmsApiOtherServer cmsApiOtherServer;
	/*
	 * @Autowired private CacheService cacheService;
	 */
	@Autowired
	private CmsActivityService cmsActivityService;

	@Autowired
	private CmsActivityOrderService cmsActivityOrderService;

	@Autowired
	private CmsActivityOrderDetailService cmsActivityOrderDetailService;

	@Autowired
	private CmsActivityOrderDetailMapper cmsActivityOrderDetailMapper;

	public CmsApiMessage save(CmsApiData<CmsActivityOrder> apiData, Integer bookCount) throws Exception {
		/*
		 * CmsApiMessage msg = this.check(apiData); try { String token =
		 * apiData.getToken(); CmsActivityOrder cmsActivityOrder =
		 * apiData.getData(); String orderNumber =
		 * this.cacheService.genOrderNumber();
		 * cmsActivityOrder.setOrderNumber(orderNumber); String seatIds =
		 * apiData.getOtherData(); String userName =
		 * TokenHelper.getUserName(token); SysUser queryUser = new SysUser();
		 * queryUser.setUserAccount(userName);
		 * 
		 * if (bookCount <= 0) { msg.setStatus(false);
		 * msg.setCode(CmsApiStatusConstant.DATA_ERROR);
		 * msg.setText("订票数量不能小于等于0"); return msg; } String userId =
		 * terminalUserService.getTerminalUserId(userName); if
		 * (StringUtils.isNotNull(userId)) { String activityId =
		 * cmsApiService.queryActivityBySysId(cmsActivityOrder.getActivityId(),
		 * apiData.getSysno()); cmsActivityOrder.setActivityId(activityId);
		 * BookActivitySeatInfo activitySeatInfo = new BookActivitySeatInfo();
		 * activitySeatInfo.setActivityId(cmsActivityOrder.getActivityId()); if
		 * (seatIds != null && StringUtils.isNotNull(seatIds)) { String[] seatId
		 * = seatIds.split(","); activitySeatInfo.setSeatIds(seatId); }
		 * 
		 * activitySeatInfo.setUserId(userId); activitySeatInfo.setType(1);
		 * activitySeatInfo.setPrice(cmsActivityOrder.getOrderPrice());
		 * activitySeatInfo.setPhone(cmsActivityOrder.getOrderPhoneNo());
		 * activitySeatInfo.setsId(UUIDUtils.createUUId());
		 * activitySeatInfo.setBookCount(bookCount);
		 * activitySeatInfo.setOrderNumber(orderNumber);
		 * 
		 * ActivityBookClient activityBookClient = new ActivityBookClient();
		 * JMSResult jmsResult =
		 * activityBookClient.bookActivitySeat(activitySeatInfo, cacheService);
		 * if (jmsResult.getSuccess()) { msg.setStatus(true); msg.setCode(-1);
		 * msg.setText("活动预定成功!" + jmsResult.getMessage());
		 * cmsActivityOrder.setActivityOrderId(jmsResult.getMessage()); } else {
		 * msg.setStatus(false); msg.setCode(CmsApiStatusConstant.DATA_ERROR);
		 * msg.setText(cmsActivityOrder.getActivityId() + " 执行预定时候，消息队列错误：" +
		 * jmsResult.getMessage()); return msg; } }
		 * 
		 * } catch (Exception e) { msg.setStatus(false);
		 * msg.setCode(CmsApiStatusConstant.DATA_ERROR); msg.setText("预定发错为止错误:"
		 * + e.toString()); return msg; } return msg;
		 */
		return null;
	}

	private CmsApiMessage check(CmsApiData<CmsActivityOrder> apiData) {
		CmsApiMessage msg = new CmsApiMessage();
		String sysNo = apiData.getSysno();
		String token = apiData.getToken();

		msg = CmsApiUtil.checkToken(sysNo, token);
		if (msg.getStatus()) {
			CmsActivityOrder model = apiData.getData();
			if (model == null) {
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("数据不能为空");
				return msg;
			}
			if (StringUtils.isNull(model.getActivityId())) {
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("活动id不能为空");
				return msg;
			}
			if (StringUtils.isNull(model.getOrderPhoneNo())) {
				msg.setStatus(false);
				msg.setCode(CmsApiStatusConstant.DATA_ERROR);
				msg.setText("手机号码不能为空");
				return msg;
			}

		}
		return msg;
	}

	/**
	 * 取消活动订单
	 * @param activityOrder
	 * @param cmsActivity
	 * @return
	 * @throws Exception
	 */
	@Override
	public CmsApiOrder cancelOrder(CmsActivityOrder activityOrder, CmsActivity cmsActivity) throws Exception {
		// 子系统取消预定接口
		// 向子系统发送请求
		CmsApiOrder apiOrder = new CmsApiOrder();
		apiOrder.setStatus(true);

		CmsTerminalUser terminalUser = null;
		try {
			// 查询活动，判断活动的的外部系统的预定链接地址
			String activityId = cmsActivity.getActivityId();
			terminalUser = this.terminalUserService.queryTerminalUserById(activityOrder.getUserId());
			if (terminalUser != null) {
				String sysNo = cmsActivity.getSysNo();
				String sysId = cmsActivity.getSysId();
				if (StringUtils.isNotNull(sysNo) && StringUtils.isNotNull(sysId)) {
					String token = TokenHelper.generateToken(terminalUser.getUserName());
					String userId = terminalUser.getUserId();

					JSONObject json = new JSONObject();
					json.put("sysNo",sysNo);
					json.put("token", token);
					json.put("userId", userId);
					json.put("activityId", sysId);
					
					String url = cmsApiOtherServer.getCancelOrderUrl(sysNo);

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
				}
			} else {
				apiOrder.setStatus(false);
				apiOrder.setMsg("预定的用户不存在或被禁用!");
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return apiOrder;
	}

	@Override
	public CmsApiOrder addOrder(BookActivitySeatInfo activitySeatInfo, CmsTerminalUser terminalUser,String seatValues) {

		// 向子系统发送请求
		CmsApiOrder apiOrder = new CmsApiOrder();
		apiOrder.setStatus(true);

		try {
			// 查询活动，判断活动的的外部系统的预定链接地址
			String activityId = activitySeatInfo.getActivityId();
			CmsActivity cmsActivity = this.cmsActivityService.queryCmsActivityByActivityId(activityId);
			if (cmsActivity != null) {
				String sysNo = cmsActivity.getSysNo();
				String sysId = cmsActivity.getSysId();

				if (StringUtils.isNotNull(sysNo) && StringUtils.isNotNull(sysId)) {
					String token = TokenHelper.generateToken(terminalUser.getUserName());
					String mobile = activitySeatInfo.getPhone();
					int buyNum = activitySeatInfo.getBookCount() == null ? 0 : activitySeatInfo.getBookCount();
					String userId = terminalUser.getUserId();

					Integer sourceCode = terminalUser.getSourceCode();
					if(sourceCode.equals(TerminalUserConstant.SOURCE_CODE_JIADING)){
						userId = terminalUser.getSysId();
					}

					JSONObject json = new JSONObject();
					json.put("sysNo", sysNo);
					json.put("token", token);
					json.put("userId", userId);
					json.put("activityId", sysId);
					json.put("mobile", mobile);
					json.put("sourceCode",sourceCode);
					if (buyNum != 0 ) {
						json.put("buyNum", String.valueOf(buyNum));
					}
					json.put("fromType","5");
					json.put("orderNumber", activitySeatInfo.getOrderNumber());
					//预定的座位信息 1-1,2-1
					json.put("seatValues", activitySeatInfo.getSeatIds());
					String url = cmsApiOtherServer.getOrderUrl(sysNo);

					HttpResponseText httpResponseText = HttpClientConnection.post(url, json);
					if (httpResponseText.getHttpCode() == 200) {
						String result = httpResponseText.getData();
						logger.info("嘉定活动预订结果："+result);
						apiOrder = JSON.parseObject(result, CmsApiOrder.class);
						//子系统生成订单成功 文化云直接生成订单
						if (apiOrder.isStatus()) {
							//生成订单主表 和子表
							CmsActivityOrder cmsActivityOrder = new CmsActivityOrder();
							cmsActivityOrder.setActivityOrderId(UUIDUtils.createUUId());
							cmsActivityOrder.setOrderType(activitySeatInfo.getType());
							cmsActivityOrder.setUserId(activitySeatInfo.getUserId());
							cmsActivityOrder.setActivityId(activitySeatInfo.getActivityId());
							cmsActivityOrder.setOrderNumber(String.valueOf(apiOrder.getOrderNumber()));
							cmsActivityOrder.setOrderValidateCode(apiOrder.getOrderValidateCode());
							cmsActivityOrder.setOrderPhoneNo(activitySeatInfo.getPhone());
							cmsActivityOrder.setOrderPrice(activitySeatInfo.getPrice());
							//订单是否支付状态(1-未出票 2-已取消 3-已出票 4-已验票 5-已失效 )
							cmsActivityOrder.setOrderPayStatus(Constant.ACTIVITY_ORDER_PAY_STATUS_UNBILLED);
							//记录子系统中的订单id
							cmsActivityOrder.setSysId(apiOrder.getContentId());
							cmsActivityOrder.setSysNo(sysNo);
							cmsActivityOrder.setEventId(activitySeatInfo.getEventId());
							cmsActivityOrder.setEventDateTime(activitySeatInfo.getEventDateTime());
							if (activitySeatInfo.getSeatIds() == null || activitySeatInfo.getSeatIds().length == 0) {
								cmsActivityOrder.setOrderVotes(activitySeatInfo.getBookCount());
							} else {
								cmsActivityOrder.setOrderVotes(activitySeatInfo.getSeatIds().length);
								cmsActivityOrder.setOrderSummary(ArrayToString(activitySeatInfo.getSeatIds()));
							}
							//保存到数据库中
							cmsActivityOrderService.addSubSystemActivityOrder(cmsActivityOrder,seatValues);
						}
						apiOrder.setSysNo(sysNo);

					} else {
						apiOrder.setStatus(false);
						apiOrder.setSysNo("0");
						JSONObject jsonObject = JSON.parseObject(httpResponseText.getData());
						apiOrder.setMsg(jsonObject.get("msg") != null ? "" : jsonObject.getString("msg"));
						logger.info(apiOrder.getMsg());
					}

				}
			}

			else {
				apiOrder.setStatus(true);
				apiOrder.setMsg("sysId,sysNo不存在，无须调用子系统预定功能!");
				logger.info(apiOrder.getMsg());
			}

		} catch (Exception e) {
			e.printStackTrace();
			logger.error("添加预定申请发生错误：" + e.toString());
			apiOrder.setStatus(false);
			apiOrder.setMsg("添加预定申请发生错误：" + e.toString());
		}

		return apiOrder;

	}

	public boolean checkOrder(String activityId) {
		CmsActivity cmsActivity = this.cmsActivityService.queryCmsActivityByActivityId(activityId);
		if (cmsActivity != null) {
			String sysNo = cmsActivity.getSysNo();
			String sysId = cmsActivity.getSysId();
			if (StringUtils.isNotNull(sysNo) && StringUtils.isNotNull(sysId)) {
				return true;
			}
		}

		return false;
	}

	/**
	 * 帮助方法
	 * @param strs
	 * @return
	 */
	public String ArrayToString(String [] strs) {
		StringBuffer sb = new StringBuffer();
		for (String str : strs) {
			sb.append(str + ",");
		}
		return sb.toString();
	}

	/**
	 * 子系统退订成功后 修改文化云中的数据库订单的状态
	 * @param activityOrderId
	 * @param orderLines
	 * @return
	 */
	public String updateActivityOrderState(String activityOrderId,String  orderLines,String type) {
		CmsActivityOrder activityOrder = cmsActivityOrderService.queryCmsActivityOrderById(activityOrderId);
		if ("N".equals(activityOrder.getActivitySalesOnline()) && (orderLines == null || org.apache.commons.lang3.StringUtils.isBlank(orderLines))) {
			Map updateMap = new HashMap();
			updateMap.put("activityOrderId",activityOrder.getActivityOrderId());
			//修改订单主表状态
			int count = cmsActivityOrderService.updateOrderByActivityOrderId(updateMap);
			//修改订单子表状态
			try {
				cmsActivityOrderDetailService.updateOrderSeatStatusByOrderId(updateMap);
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		} else if ("Y".equals(activityOrder.getActivitySalesOnline()) || org.apache.commons.lang3.StringUtils.isNotBlank(orderLines)) {
			Map updateMap = new HashMap();
			updateMap.put("activityOrderId",activityOrder.getActivityOrderId());
			String[] cancelOrderLine = orderLines.split(",");
			String seatCodes = "";
			for (String orderLine : cancelOrderLine) {
				CmsActivityOrderDetailKey orderDetailKey = new CmsActivityOrderDetail();
				orderDetailKey.setActivityOrderId(activityOrderId);
				orderDetailKey.setOrderLine(Integer.parseInt(orderLine));
				CmsActivityOrderDetail activityOrderDetail = cmsActivityOrderDetailMapper.queryByDetailKey(orderDetailKey);
				seatCodes += activityOrderDetail.getSeatCode() + ",";
			}
			updateMap.put("seatCodes", seatCodes.split(","));
			// 1 代表退订操作
			if ("1".equals(type)) {
				cmsActivityOrderDetailService.updateOrderSeatStatusBySeats(updateMap);
				activityOrder.setOrderVotes(activityOrder.getOrderVotes() - orderLines.split(",").length);
			} else if ("2".equals(type)) {
				//2代表 入场
				updateMap.put("seatStatus", 4);
				cmsActivityOrderDetailService.updateDetailSeatStatusBySeats(updateMap);
			} else if ("3".equals(type)) {
				//3 代表验票
				updateMap.put("seatStatus", 4);
				cmsActivityOrderDetailService.updateDetailSeatStatusBySeats(updateMap);
			}
			//全部无预定成功状态时根据子表订单状态修改主表状态
			int count = cmsActivityOrderDetailService.queryCmsActivityOrderDetailByStatus(activityOrder.getActivityOrderId(), Constant.ORDER_PAY_STATUS1);
			//不存在未取票的时候
			if (count == 0) {
				//查询已取票的
				count = cmsActivityOrderDetailService.queryCmsActivityOrderDetailByStatus(activityOrder.getActivityOrderId(), Constant.ORDER_PAY_STATUS3);
				if(count > 0) {
					activityOrder.setOrderPayStatus((short)3);
				}else {
					//查询已验票的
					count = cmsActivityOrderDetailService.queryCmsActivityOrderDetailByStatus(activityOrder.getActivityOrderId(), (int)Constant.ORDER_PAY_STATUS4);
					//如果不存在已验票的
					if (count == 0) {
						activityOrder.setOrderPayStatus((short)2);
					} else {
						activityOrder.setOrderPayStatus((short)4);
					}
				}
			} else {
				activityOrder.setOrderPayStatus((short)1);
			}
			cmsActivityOrderService.editActivityOrder(activityOrder);
		}
		return Constant.RESULT_STR_SUCCESS;
	}


	/**
	 * 根据活动id获得子系统中的剩余票数
	 * @param activityIds
	 * @return
	 */
	public String getSubSystemActivityTicketCount(String[] activityIds) {
		JSONObject json = new JSONObject();
		json.put("sysNo","1");
		json.put("activityIds", activityIds);
		String url = cmsApiOtherServer.getActivityTicketsUrl("1");

		HttpResponseText httpResponseText = HttpClientConnection.post(url, json);
		if (httpResponseText.getHttpCode() == 200) {
			String result = httpResponseText.getData();
			JSONObject jsonObject = JSON.parseObject(result);
			return jsonObject.toString();
		}
		return null;
	}


	/**
	 * 检查活动的预定座位信息
	 * @param activityId
	 * @param seatIds
	 * @param bookCount
	 * @param userId
	 * @return
	 */
	public String checkActivitySeatStatus(String activityId, String [] seatIds, Integer bookCount, String userId) {
		CmsActivity cmsActivity = cmsActivityService.queryCmsActivityByActivityId(activityId);
		CmsTerminalUser cmsTerminalUser = terminalUserService.queryTerminalUserById(userId);
		JSONObject json = new JSONObject();
		if (cmsTerminalUser != null) {
			json.put("userId", org.apache.commons.lang3.StringUtils.isBlank(cmsTerminalUser.getSysId()) ? cmsTerminalUser.getUserId() : cmsTerminalUser.getSysId());
		}
		json.put("sysNo",cmsActivity.getSysNo());
		json.put("activityId", org.apache.commons.lang3.StringUtils.isBlank(cmsActivity.getSysId()) ? cmsActivity.getActivityId() : (cmsActivity.getSysId()));
		if (seatIds != null) {
			json.put("bookCount" ,seatIds.length);
		} else {
			json.put("bookCount" ,bookCount);
		}

		json.put("seatIds",seatIds);
		String url = cmsApiOtherServer.checkActivityBookUrl(cmsActivity.getSysNo());
		HttpResponseText httpResponseText = HttpClientConnection.post(url, json);
		if (httpResponseText.getHttpCode() == 200) {
			String result = httpResponseText.getData();
			JSONObject jsonObject = JSON.parseObject(result);
			if (Boolean.parseBoolean(jsonObject.get("status").toString())) {
				return Constant.RESULT_STR_SUCCESS;
			} else {
				return jsonObject.get("msg").toString();
			}
		}
		return "系统异常";
	}

}
