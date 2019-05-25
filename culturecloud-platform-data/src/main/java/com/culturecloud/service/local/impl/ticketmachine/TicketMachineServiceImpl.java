package com.culturecloud.service.local.impl.ticketmachine;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.UUID;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.culturecloud.dao.activity.CmsActivityEventMapper;
import com.culturecloud.dao.activity.CmsActivityMapper;
import com.culturecloud.dao.activity.CmsActivityOrderDetailMapper;
import com.culturecloud.dao.activity.CmsActivityOrderMapper;
import com.culturecloud.dao.activity.CmsActivitySeatMapper;
import com.culturecloud.dao.dto.activity.CmsActivityOrderDto;
import com.culturecloud.kafka.PpsConfig;
import com.culturecloud.model.bean.activity.CmsActivity;
import com.culturecloud.model.bean.activity.CmsActivityEvent;
import com.culturecloud.model.bean.activity.CmsActivityOrder;
import com.culturecloud.model.bean.activity.CmsActivityOrderDetail;
import com.culturecloud.model.bean.activity.CmsActivitySeat;
import com.culturecloud.model.request.activity.SysUserAnalyseVO;
import com.culturecloud.service.BaseService;
import com.culturecloud.service.local.activity.CcpActivityOrderService;
import com.culturecloud.service.local.ticketmachine.TicketMachineService;
import com.culturecloud.util.CompareTime;
import com.culturecloud.util.JSONResponse;
import com.culturecloud.util.QRCode;

@Service
public class TicketMachineServiceImpl implements TicketMachineService {

	@Resource
	private CmsActivityOrderMapper cmsActivityOrderMapper;
	@Resource
	private CmsActivityOrderDetailMapper cmsActivityOrderDetailMapper;
	@Resource
	private CmsActivityMapper cmsActivityMapper;
	@Resource
	private CmsActivityEventMapper cmsActivityEventMapper;
	@Resource
	private CmsActivitySeatMapper cmsActivitySeatMapper;
	@Resource
	private BaseService baseService;
	@Resource
	private CcpActivityOrderService ccpActivityOrderService;

	private String staticServerUrl = PpsConfig.getString("staticServerUrl");

	@Override
	public JSONObject getTicketInfoByOrderValidateCode(String orderValidateCode) {
		Map<String, Object> map = new HashMap<String, Object>();
		if (StringUtils.isNotBlank(orderValidateCode)) {
			map.put("orderValidateCode", orderValidateCode);
		}
		List<CmsActivityOrderDto> list = cmsActivityOrderMapper.queryActvityOrderByCondition(map);
		if (list.size() > 0) {
			JSONObject jsonObject = activityOrderInfoFormat(list.get(0));
			return JSONResponse.getResultFormat(200, jsonObject);
		} else {
			return JSONResponse.getResultFormat(404, "订单不存在");
		}
	}

	@Override
	public JSONObject getTicketInfoByOrderIdentityCard(String orderIdentityCard) {
		Map<String, Object> map = new HashMap<String, Object>();
		if (StringUtils.isNotBlank(orderIdentityCard)) {
			map.put("orderIdentityCard", orderIdentityCard);
			map.put("orderPayStatus", 1);
			map.put("orderPaymentStatus", 1);
		}
		List<CmsActivityOrderDto> list = cmsActivityOrderMapper.queryActvityOrderByCondition(map);
		if (list.size() > 0) {
			JSONArray jsonArray = new JSONArray();
			for (CmsActivityOrderDto cmsActivityOrderDto : list) {
				jsonArray.add(activityOrderInfoFormat(cmsActivityOrderDto));
			}
			return JSONResponse.getResultFormat(200, jsonArray);
		} else {
			return JSONResponse.getResultFormat(404, "订单不存在");
		}
	}

	public JSONObject activityOrderInfoFormat(CmsActivityOrderDto cmsActivityOrder) {
		JSONObject jsonObject = new JSONObject();
		SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd");
		String nowDate2 = sdf2.format(new Date());
		String dateTime = cmsActivityOrder.getEventDateTime().substring(0,
				cmsActivityOrder.getEventDateTime().lastIndexOf(" "));
		int statusDate2 = CompareTime.timeCompare1(dateTime, nowDate2);
		if (cmsActivityOrder.getOrderPayStatus() == 2 || cmsActivityOrder.getOrderPayStatus() == 3
				|| cmsActivityOrder.getOrderPayStatus() == 4) {
			jsonObject.put("orderPayStatus", cmsActivityOrder.getOrderPayStatus());
		} else {
			if (statusDate2 == -1) {
				jsonObject.put("orderPayStatus", 5);
			} else {
				jsonObject.put("orderPayStatus", cmsActivityOrder.getOrderPayStatus());
			}
		}

		if (!cmsActivityOrder.getEventDate().equals(cmsActivityOrder.getEventEndDate())) {
			jsonObject.put("activityTime", cmsActivityOrder.getEventDate() + "至" + cmsActivityOrder.getEventEndDate()
					+ " " + cmsActivityOrder.getEventTime());
		} else {
			jsonObject.put("activityTime",
					cmsActivityOrder.getEventDateTime() != null ? cmsActivityOrder.getEventDateTime() : "");
		}

		jsonObject.put("activityId", cmsActivityOrder.getActivityId() != null ? cmsActivityOrder.getActivityId() : "");
		jsonObject.put("orderNumber",
				cmsActivityOrder.getOrderNumber() != null ? cmsActivityOrder.getOrderNumber() : "");
		jsonObject.put("activityName",
				cmsActivityOrder.getActivityName() != null ? cmsActivityOrder.getActivityName() : "");
		jsonObject.put("activityAddress",
				cmsActivityOrder.getActivityAddress() != null ? cmsActivityOrder.getActivityAddress() : "");
		jsonObject.put("activitySalesOnline",
				cmsActivityOrder.getActivitySalesOnline() != null ? cmsActivityOrder.getActivitySalesOnline() : "");
		jsonObject.put("activityIsReservation",
				cmsActivityOrder.getActivityIsReservation() != null ? cmsActivityOrder.getActivityIsReservation() : "");
		StringBuffer seatSB = new StringBuffer();
		; // 改变后座位号
		String seat = ""; // 座位号
		int j = 0;
		if (cmsActivityOrder.getSeatStatus() != null && StringUtils.isNotBlank(cmsActivityOrder.getSeatStatus())) {
			String[] activitySeatStatus = cmsActivityOrder.getSeatStatus().split(",");
			for (int i = 0; i < activitySeatStatus.length; i++) {
				if (Integer.valueOf(activitySeatStatus[i]) == 1) {
					// 在线选座 截取座位重新编辑成几排几座
					seat = cmsActivityOrder.getSeats() != null ? StringUtils.split(cmsActivityOrder.getSeats(), ",")[i]
							: "";

					if (!seat.equals("") && StringUtils.isNotBlank(seat) && seat.contains("_")) {
						String[] seats = seat.split("_");
						seatSB.append(seats[0] + "排");
						seatSB.append(seats[1] + "座");
						seatSB.append(",");
					}
					// 人数
				}
				j++;
			}

			jsonObject.put("orderVotes", Integer.valueOf(j));
		}
		if (cmsActivityOrder.getActivitySalesOnline().equals("Y")) {
			if (seatSB.toString().length() > 0) {
				jsonObject.put("seats", seatSB.toString().substring(0, seatSB.toString().length() - 1));
			} else {
				jsonObject.put("seats", "订单异常");
			}
		} else {
			jsonObject.put("seats", "自由入座");
		}
		jsonObject.put("activityOrderId",
				cmsActivityOrder.getActivityOrderId() != null ? cmsActivityOrder.getActivityOrderId() : "");
		jsonObject.put("orderValidateCode",
				cmsActivityOrder.getOrderValidateCode() != null ? cmsActivityOrder.getOrderValidateCode() : "");
		jsonObject.put("orderPhotoNo",
				cmsActivityOrder.getOrderPhoneNo() != null ? cmsActivityOrder.getOrderPhoneNo() : "");
		jsonObject.put("orderName", cmsActivityOrder.getOrderName() != null ? cmsActivityOrder.getOrderName() : "");
		String activityIconUrl = "";
		if (StringUtils.isNotBlank(cmsActivityOrder.getActivityIconUrl())) {
			if (cmsActivityOrder.getActivityIconUrl().indexOf("http:") > -1) {
				activityIconUrl = cmsActivityOrder.getActivityIconUrl();
			} else {
				activityIconUrl = staticServerUrl + cmsActivityOrder.getActivityIconUrl();
			}
		}
		jsonObject.put("activityIconUrl", activityIconUrl);
		return jsonObject;
	}

	public static void main(String[] args) {
		StringBuffer seatSB = new StringBuffer();
		; // 改变后座位号
		System.out.println(seatSB.toString().length());
	}

	@Override
	@Transactional
	public JSONObject checkTicketByOrderValidateCode(String orderValidateCode) throws Exception {
		Map<String, Object> param = new HashMap<String, Object>();
		if (orderValidateCode != null && StringUtils.isNotBlank(orderValidateCode)) {
			param.put("orderValidateCode", orderValidateCode);
		}
		List<CmsActivityOrderDto> orderList = cmsActivityOrderMapper.queryActvityOrderByCondition(param);
		if (orderList.size() > 0) {
			CmsActivityOrderDto cmsActivityOrder = orderList.get(0);
			if (cmsActivityOrder.getOrderPayStatus() == 1) {
				List<CmsActivityOrderDetail> orderDetailList = cmsActivityOrderDetailMapper
						.queryActivityOrderDetailById(cmsActivityOrder.getActivityOrderId());
				for (CmsActivityOrderDetail cmsActivityOrderDetail : orderDetailList) {
					if (cmsActivityOrderDetail.getSeatStatus() == 1) {
						cmsActivityOrderDetail.setSeatStatus(3);
						cmsActivityOrderDetail.setUpdateTime(new Date());
						cmsActivityOrderDetailMapper.updateByPrimaryKeySelective(cmsActivityOrderDetail);
					}
				}

				CmsActivityOrder newCmsActivityOrder = new CmsActivityOrder();
				newCmsActivityOrder.setActivityOrderId(cmsActivityOrder.getActivityOrderId());
				newCmsActivityOrder.setOrderPayStatus((short) 3);

				// 若为支付活动，取票机取票直接改为已支付
				CmsActivity activity = cmsActivityMapper.selectByPrimaryKey(cmsActivityOrder.getActivityId());
				if (activity.getActivityIsFree() == 3) {
					newCmsActivityOrder.setOrderPaymentStatus((short) 2);
				}
				newCmsActivityOrder.setPrintTicketTimes(cmsActivityOrder.getPrintTicketTimes() + 1);
				newCmsActivityOrder.setOrderUpdateTime(new Date());
				newCmsActivityOrder.setOrderCheckTime(new Date());
				int result = cmsActivityOrderMapper.updateByPrimaryKeySelective(newCmsActivityOrder);
				if (result == 1) {
					SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
					StringBuffer validete = new StringBuffer();
					validete.append(staticServerUrl);
					validete.append(sdf.format(new Date()));
					validete.append("/");
					if (cmsActivityOrder.getOrderValidateCode() != null && org.apache.commons.lang3.StringUtils
							.isNotBlank(cmsActivityOrder.getOrderValidateCode())) {
						validete.append(cmsActivityOrder.getOrderValidateCode());
						validete.append(".jpg");
					}
					QRCode.create_image(cmsActivityOrder.getOrderValidateCode(), validete.toString());
					StringBuffer stringBuffer = new StringBuffer();
					stringBuffer.append(staticServerUrl);
					stringBuffer.append(sdf.format(new Date()));
					stringBuffer.append("/");
					stringBuffer.append(cmsActivityOrder.getOrderValidateCode());
					stringBuffer.append(".jpg");
					return JSONResponse.getResultFormat(200, stringBuffer.toString());
				} else {
					return JSONResponse.getResultFormat(500, "取票失败");
				}
			} else {
				return JSONResponse.getResultFormat(500, "该订单不可出票");
			}
		} else {
			return JSONResponse.getResultFormat(404, "订单不存在");
		}
	}

	/**
	 * 取票机终端下单
	 */
	@Override
	public String addTicketActivityOrder(CmsActivityOrder cmsActivityOrder, String seatId) {
		cmsActivityOrder.setActivityOrderId(UUID.randomUUID().toString().replace("-", ""));
		// 获取活动和场次
		CmsActivity cmsActivity = this.cmsActivityMapper.selectByPrimaryKey(cmsActivityOrder.getActivityId());
		CmsActivityEvent cmsActivityEvent = this.cmsActivityEventMapper
				.selectByPrimaryKey(cmsActivityOrder.getEventId());

		// 传座位信息时，以作为信息为主
		String[] orderSummary;
		String[] seatIds = null;
		if (seatId != null) {
			orderSummary = cmsActivityOrder.getOrderSummary().split(",");
			seatIds = seatId.split(",");
		}
		if (StringUtils.isNotBlank(cmsActivityOrder.getOrderSummary())) {
			cmsActivityOrder.setOrderVotes(seatIds.length);
		}
		String checkResult = checkActivitySeatStatus(cmsActivityOrder, cmsActivityEvent, cmsActivity);
		if (checkResult != "success") {
			return checkResult;
		}
		int count = 0;
		if (cmsActivityEvent.getOrderCount() != null) {
			count = cmsActivityEvent.getOrderCount().intValue()
					- cmsActivityOrderDetailMapper.queryOrderCountByEvent(cmsActivityEvent.getEventId());
		} else {
			count = cmsActivityEvent.getAvailableCount().intValue();
		}
		if (count >= cmsActivityOrder.getOrderVotes().intValue()) {
			count -= cmsActivityOrder.getOrderVotes().intValue();
			cmsActivityEvent.setAvailableCount(Integer.valueOf(count));
		} else {
			return "余票不足";
		}
		cmsActivityOrder.setSurplusCount(count);
		int result = this.cmsActivityEventMapper.updateByPrimaryKeySelective(cmsActivityEvent);
		if (result > 0) {
			cmsActivityOrder.setOrderNumber(genOrderNumber());
			cmsActivityOrder.setOrderCreateTime(new Date());
			cmsActivityOrder.setOrderPayStatus(Short.valueOf((short) 1));
			cmsActivityOrder.setOrderIsValid(Short.valueOf((short) 1));

			// 取票机终端取票码为18+8位随机数
			long value = new Random().nextInt(99999999);
			NumberFormat numberFormat = NumberFormat.getIntegerInstance();
			numberFormat.setGroupingUsed(false);
			numberFormat.setMaximumIntegerDigits(8);
			numberFormat.setMinimumIntegerDigits(8);
			String orderSuffix = numberFormat.format(value);
			String orderNumber = "18" + orderSuffix;
			cmsActivityOrder.setOrderValidateCode(orderNumber);

			// 需要支付
			if (cmsActivity.getActivityIsFree() != null && cmsActivity.getActivityIsFree() == 3) {

				BigDecimal activityPayPrice = cmsActivity.getActivityPayPrice();

				BigDecimal orderPrice = activityPayPrice.multiply(new BigDecimal(cmsActivityOrder.getOrderVotes()));

				cmsActivityOrder.setOrderPrice(orderPrice);

				cmsActivityOrder.setOrderPaymentStatus((short) 1);
			} else
				cmsActivityOrder.setOrderPaymentStatus((short) 0);

			int addOrder = this.cmsActivityOrderMapper.insertSelective(cmsActivityOrder);
			if (addOrder > 0) {
				if (StringUtils.isNotBlank(cmsActivityOrder.getOrderSummary())) {
					int index = 1;
					StringBuilder seatWhere = new StringBuilder();
					seatWhere.append(" where (");
					for (int i = 0; i < seatIds.length; i++) {
						if (i < seatIds.length - 1) {
							seatWhere.append(" SEAT_CODE ='" + seatIds[i] + "' or");
						} else {
							seatWhere.append(" SEAT_CODE ='" + seatIds[i] + "' )");
						}
					}
					seatWhere.append("and EVENT_ID='" + cmsActivityOrder.getEventId() + "'");
					List<CmsActivitySeat> cmsActivitySeats = baseService.find(CmsActivitySeat.class,
							seatWhere.toString());
					for (CmsActivitySeat seat : cmsActivitySeats) {
						if (seat.getSeatIsSold() == 2) {
							return "该座位已被预定";
						} else {
							CmsActivityOrderDetail cmsActivityOrderDetail = new CmsActivityOrderDetail();
							cmsActivityOrderDetail.setSeatVal(seat.getSeatVal());
							cmsActivityOrderDetail.setSeatCode(seat.getSeatCode());
							cmsActivityOrderDetail.setActivityOrderId(cmsActivityOrder.getActivityOrderId());
							cmsActivityOrderDetail.setSeatStatus(Integer.valueOf(1));
							cmsActivityOrderDetail.setOrderLine(Integer.valueOf(index));
							cmsActivityOrderDetail.setUpdateTime(new Date());
							cmsActivityOrderDetail.setUpdateUser(cmsActivityOrder.getUserId());
							seat.setSeatIsSold(Integer.valueOf(2));
							seat.setSeatStatus(Integer.valueOf(2));
							this.cmsActivitySeatMapper.updateByPrimaryKeySelective(seat);
							cmsActivityOrderDetail.setSeatVal(seat.getSeatVal());
							this.cmsActivityOrderDetailMapper.insert(cmsActivityOrderDetail);
							index++;
						}
					}
					Map<String, Object> seatMap = new HashMap<String, Object>();
					seatMap.put("activityId", cmsActivityOrder.getActivityId());
				} else {
					for (int i = 1; i <= cmsActivityOrder.getOrderVotes().intValue(); i++) {
						CmsActivityOrderDetail cmsActivityOrderDetail = new CmsActivityOrderDetail();
						cmsActivityOrderDetail.setSeatCode("" + i);
						cmsActivityOrderDetail.setActivityOrderId(cmsActivityOrder.getActivityOrderId());
						cmsActivityOrderDetail.setSeatStatus(Integer.valueOf(1));
						cmsActivityOrderDetail.setOrderLine(Integer.valueOf(i));
						cmsActivityOrderDetail.setSeatVal(String.valueOf(i));
						cmsActivityOrderDetail.setUpdateTime(new Date());
						cmsActivityOrderDetail.setUpdateUser(cmsActivityOrder.getUserId());
						this.cmsActivityOrderDetailMapper.insert(cmsActivityOrderDetail);
					}
				}
			} else {
				return "添加订单失败";
			}
		} else {
			return "更改票数失败";
		}
		SysUserAnalyseVO vo = new SysUserAnalyseVO();
		vo.setUserId(cmsActivityOrder.getUserId());
		vo.setTagId(cmsActivity.getActivityType());
		ccpActivityOrderService.insertSysUserAnalyse(vo);

		if (cmsActivity.getActivityIsFree() != null && cmsActivity.getActivityIsFree() == 3) {
			return cmsActivityOrder.getActivityOrderId();
		} else
			return cmsActivityOrder.getOrderValidateCode();
	}

	public String checkActivitySeatStatus(CmsActivityOrder cmsActivityOrder, CmsActivityEvent cmsActivityEvent,
			CmsActivity cmsActivity) {
		int bookCount = cmsActivityOrder.getOrderVotes();
		String activityId = cmsActivityOrder.getActivityId();
		String userId = cmsActivityOrder.getUserId();
		String eventId = cmsActivityOrder.getEventId();
		if (cmsActivity.getIdentityCard() == 1 && StringUtils.isBlank(cmsActivityOrder.getOrderIdentityCard())) {
			return "请上传身份证号！";
		}
		if (StringUtils.isBlank(cmsActivityOrder.getOrderSummary()) && cmsActivity.getActivitySalesOnline() == "Y") {
			return "请选择座位！";
		}

		if (cmsActivity.getActivityState() != 6 || cmsActivity.getActivityIsDel() != 1) {
			return "活动已失效!";
		}

		Map<String, Object> orderMap = new HashMap<String, Object>();
		orderMap.put("activityId", activityId);
		if (StringUtils.isNotBlank(eventId)) {
			orderMap.put("eventId", eventId);
		}
		orderMap.put("userId", userId);
		if (cmsActivity.getTicketSettings().equals("N")) {
			int userTickets = cmsActivityOrderMapper.queryOrderCountByUser(orderMap);
			if (userTickets > 0 && cmsActivity.getTicketNumber() != null
					&& userTickets + 1 > cmsActivity.getTicketNumber()) {
				return "该用户购买的订单数超过了单场活动订单数量!";
			}
			int userTicketRetail = cmsActivityOrderMapper.queryOrderDetailCountByUser(orderMap);
			// 为移动接口添加的判断
			if (cmsActivity.getTicketCount() != null && bookCount > cmsActivity.getTicketCount()) {
				return "该用户购买的票数超过了单笔最大购票数!";
			}
		} else {
			// 最大的购买票数
			int userTicketRetail = cmsActivityOrderMapper.queryOrderDetailCountByUser(orderMap);
			int maxBookCount = 5;
			if ((userTicketRetail + bookCount) > maxBookCount) {
				return "该用户购买的票数已达到5张！";
			}

		}
		try {
			DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm");
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(new Date());
			if (cmsActivityEvent == null) {
				return "该活动场次不存在！";
			}
			if (cmsActivityEvent.getEventDateTime() != null) {
				if (df.parse(cmsActivityEvent.getEventDateTime()).before(calendar.getTime())) {
					// 不在规定时间内 不能进行订票
					return "该活动场次已过期！";
				}
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return "success";
	}

	public String genOrderNumber() {
		try {
			long value = new Random().nextInt(999999);
			NumberFormat numberFormat = NumberFormat.getIntegerInstance();
			numberFormat.setGroupingUsed(false);
			numberFormat.setMaximumIntegerDigits(6);
			numberFormat.setMinimumIntegerDigits(6);
			Date current = new Date();
			SimpleDateFormat orderPrefixFormat = new SimpleDateFormat("yyMMdd");
			String orderSuffix = numberFormat.format(value);
			String orderPrefix = orderPrefixFormat.format(current);
			String str1 = orderPrefix + orderSuffix;
			return str1;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
		}
		return "123123123123";
	}

	@Override
	public JSONObject getValidateCodeByOrderId(String activityOrderId) {

		CmsActivityOrder order = cmsActivityOrderMapper.selectByPrimaryKey(activityOrderId);
		if (null != order) {
			return JSONResponse.getResultFormat(200, order.getOrderValidateCode());
		} else {
			return JSONResponse.getResultFormat(404, "订单不存在");
		}
	}
}
