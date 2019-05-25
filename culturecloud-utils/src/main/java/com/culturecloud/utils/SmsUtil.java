package com.culturecloud.utils;

import java.util.Date;
import java.util.Map;

import com.aliyuncs.DefaultAcsClient;
import com.aliyuncs.IAcsClient;
import com.aliyuncs.dysmsapi.model.v20170525.SendSmsRequest;
import com.aliyuncs.dysmsapi.model.v20170525.SendSmsResponse;
import com.aliyuncs.exceptions.ClientException;
import com.aliyuncs.exceptions.ServerException;
import com.aliyuncs.http.MethodType;
import com.aliyuncs.profile.DefaultProfile;
import com.aliyuncs.profile.IClientProfile;
import org.apache.log4j.Logger;

import com.alibaba.fastjson.JSON;
import com.taobao.api.DefaultTaobaoClient;
import com.taobao.api.TaobaoClient;
import com.taobao.api.request.AlibabaAliqinFcSmsNumSendRequest;
import com.taobao.api.response.AlibabaAliqinFcSmsNumSendResponse;

public class SmsUtil {

	private static Logger logger = Logger.getLogger(SmsUtil.class);

	private static TaobaoClient client = null;

	// 短信连接
	public static TaobaoClient getALiClient() {
		if (client == null)
			client = new DefaultTaobaoClient("http://gw.api.taobao.com/router/rest", "23318100", "af05b37a5adb39c81c75137e0f6ace6f");
		return client;
	}

	// 短信req
	private static AlibabaAliqinFcSmsNumSendRequest getSmsReq(final String smsTemplateCode, final String mobileNo,
			final Map<String, Object> params) {
		AlibabaAliqinFcSmsNumSendRequest req = new AlibabaAliqinFcSmsNumSendRequest();
		req.setExtend(mobileNo);
		req.setSmsType("normal");
		req.setSmsFreeSignName(Constant.PRODUCT);
		req.setSmsTemplateCode(smsTemplateCode);
		req.setSmsParamString(JSON.toJSONString(params));
		req.setRecNum(mobileNo);
		return req;
	}

	// 获取随机六位数验证码
	public static String getValidateCode() {
		return String.valueOf(Math.random()).substring(2, 8);
	}

	// 注册短信验证码
	// 内容:验证码${code}，您正在注册成为${product}用户，感谢您的支持！
	public  void sendRegisterCode(final String mobileNo, final Map<String, Object> params) {
		try {
			params.remove("product") ;
			sendSms(Constant.SMS_TPL_REG_CODE, mobileNo, params);
		} catch (Exception e) {
			logger.error("注册短信验证码发送失败");
			e.printStackTrace();
		}
	}

	// 找回密码及验证手机号
	// 内容：验证码${code}，您正在进行${product}身份验证，打死不要告诉别人哦！
	public  void sendForgetCode(final String mobileNo, final Map<String, Object> params) {
		try {
			params.remove("product") ;
			sendSms(Constant.SMS_TPL_USER_CODE, mobileNo, params);
		} catch (Exception e) {
			logger.error("验证手机号发送失败");
			e.printStackTrace();
		}
	}

	// 预订活动时验证手机号 SMS_11915059
	// 新内容：【文化云】您的验证码为${code},请在页面中输入以完成验证，如有疑问，请致电4000-018-2346。
	public void sendActivityCode(final String mobileNo, final Map<String, Object> params) {
		try {
			params.remove("product") ;
			sendSms(Constant.SMS_ACTIVITY_CODE, mobileNo, params);
		} catch (Exception e) {
			logger.error("预订活动时验证手机号发送失败");
			e.printStackTrace();
		}
	}

	// 用户修改信息(修改手机号码等) 修改个人信息验证码
	// 内容： 验证码${code}，您正在尝试变更${product}重要信息，请妥善保管账户信息
	public  void sendUpdateCode(final String mobileNo, final Map<String, Object> params) {
		try {
			params.remove("product") ;
			sendSms(Constant.SMS_TPL_UPDATE_CODE, mobileNo, params);
		} catch (Exception e) {
			logger.error("用户修改验证码发送失败");
			e.printStackTrace();
		}
	}

	// 后台添加用户通知短信 SMS_5215439
	// 内容：亲爱的${userName}，您已成功注册成为文化云会员，账号为手机号，密码为${userPassWord}。欢迎您使用文化云平台。
	public  void sendUserInfoCode(final String mobileNo, final Map<String, Object> params) {
		try {
			sendSms(Constant.SMS_USER_INFO_CODE, mobileNo, params);
		} catch (Exception e) {
			logger.error("后台添加用户短信发送失败");
			e.printStackTrace();
		}
	}

	// 活动订单 SMS_36090002
	// 新内容：【文化云】亲爱的${userName}，您已成功预订【${activityName}】活动的${ticketCount}张票，时间为${time},请凭验证码${ticketCode}入场，如需退票，请提前取消订单。
	public  void sendActivityOrderSms(final String mobileNo, final Map<String, Object> params) {
		try {
			sendSms(Constant.SMS_ACTIVITY_ORDER_CODE, mobileNo, params);
		} catch (Exception e) {
			logger.error("活动订单短信发送失败");
			e.printStackTrace();
		}
	}

	// 场馆订单 SMS_5230461
	// 内容：亲爱的${userName}，恭喜您成功预订
	// ${venueName}-${activityRoomName}，请通过验票码${ticketCode}或扫描二维码入场。如需退票，请提前取消订单。
	public  void sendVenueOrderSms(final String mobileNo, final Map<String, Object> params) {
		try {
			sendSms(Constant.SMS_VENUE_ORDER_CODE, mobileNo, params);
		} catch (Exception e) {
			logger.error("场馆订单短信发送失败");
			e.printStackTrace();
		}
	}

	// 取消场馆订单 SMS_5285494
	// 内容：亲爱的${userName}，您预订的编号为${orderId}的场馆已成功取消。
	public  void cancelVenueOrderSms(final String mobileNo, final Map<String, Object> params) {
		try {
			sendSms(Constant.SMS_CANCEL_VENUE_ORDER_CODE, mobileNo, params);
		} catch (Exception e) {
			logger.error("取消场馆订单短信发送失败");
			e.printStackTrace();
		}
	}

	// 活动开始通知 SMS_5280416
	// 内容：亲爱的${userName}，您预订了今天${beginTime}的“${activityName}”活动，距离开始还有2小时，请安排好时间，不要错过哦。感谢您使用文化云平台。
	public  void sendActivityNoticeSms(final String mobileNo, final Map<String, Object> params) {
		try {
			sendSms(Constant.SMS_ACTIVITY_NOTICE_CODE, mobileNo, params);
		} catch (Exception e) {
			logger.error("活动开始通知发送失败");
			e.printStackTrace();
		}
	}

	// 活动取消通知已下单的用户 SMS_11875074
	// 新内容：尊敬的用户：因${content}，活动取消，给您带来不便，敬请谅解！
	public  void cancelActivitySms(final String mobileNo, final Map<String, Object> params) {
		try {
			sendSms(Constant.SMS_CANCEL_ACTIVITY_CODE, mobileNo, params);
		} catch (Exception e) {
			logger.error("活动取消通知发送失败");
			e.printStackTrace();
		}
	}

	// 活动取消通知已下单的用户 SMS_12140508
	// 新内容：【文化云】亲爱的${userName}，您预订的${activityName}活动${num}张票，时间为${time}，因系统升级，
	// 原有座位已被取消，为您安排了新的座位${site1},请凭验证码${ticketNum}于活动开场前取票入场，
	// 如需退票，请提前取消订单。！
	public  void changeActivitySms(final String mobileNo, final Map<String, Object> params) {
		try {
			sendSms(Constant.SMS_CHANGE_ACTIVITY_CODE, mobileNo, params);
		} catch (Exception e) {
			logger.error("活动取消通知发送失败");
			e.printStackTrace();
		}
	}

	// SMS_11875073 取消自由入座
	// 新内容：【文化云】亲爱的${userName}，您预定的【${activityName}】活动的${ticketCount}张票已成功退订。
	public  void cancelActivityFreeOrderSms(final String mobileNo, final Map<String, Object> params) {
		try {
			sendSms(Constant.SMS_CANCEL_ACTIVITY_FREE_ORDER_CODE, mobileNo, params);
		} catch (Exception e) {
			logger.error("取消自由入座发送失败");
			e.printStackTrace();
		}
	}

	// SMS_11930070 取消在线选座
	// 新内容：【文化云】亲爱的${userName}，您预定的【${activityName}】活动的座位(${seatInfo})已成功退订。
	public  void cancelActivitySeatOrderSms(final String mobileNo, final Map<String, Object> params) {
		try {
			sendSms(Constant.SMS_CANCEL_ACTIVITY_SEAT_ORDER_CODE, mobileNo, params);
		} catch (Exception e) {
			logger.error("取消在线选座发送失败");
			e.printStackTrace();
		}
	}

	// SMS_12180668 票务未核销的通知
	// 新内容：【文化云】通知：亲爱的${userName}，很抱歉的通知您，您预订的${month}月${day}日的${activity}活动的${num}张票，在活动开始后未到场核销，按相关规定，您将被扣除${branch}积分。文化云致力于为公众提供免费公益的文化活动，因票务十分抢手，希望预约过的朋友们都能如约到场喔！
	public  void deductionOrderCode(final String mobileNo, final Map<String, Object> params) {
		try {
			sendSms(Constant.SMS_DEDUCTION_ORDER_CODE, mobileNo, params);
		} catch (Exception e) {
			logger.error("票务未核销的通知发送失败");
			e.printStackTrace();
		}
	}

	// SMS_12180667 场次审核通过的通知
	// 新内容：【文化云】亲爱的${userName}，您预订的${venue}场馆-${activity}活动室-${time}的场次，已经审核通过，请凭验票码${ticketCode}或扫描二维码入场。如需退票，请提前取消订单。
	public  void passRoomOrder(final String mobileNo, final Map<String, Object> params) {
		try {
			sendSms(Constant.SMS_PASS_ROOM_ORDER_CODE, mobileNo, params);
		} catch (Exception e) {
			logger.error("场次审核通过的通知发送失败");
			e.printStackTrace();
		}
	}

	// SMS_12185571 场次审核拒绝的通知(手动)
	// 新内容：【文化云】亲爱的${userName}，您预订的${venue}场馆-${activity}活动室-${time}的场次，审核未通过，原因为“自定义内容”，如有疑问，请致电4000-018-2346。
	public  void manCancelRoomOrder(final String mobileNo, final Map<String, Object> params) {
		try {
			sendSms(Constant.SMS_MAN_CANCEL_ROOM_ORDER_CODE, mobileNo, params);
		} catch (Exception e) {
			logger.error("场次审核拒绝的通知发送失败");
			e.printStackTrace();
		}
	}

	// SMS_12145516 场次审核拒绝的通知(自动)
	// 新内容：【文化云】亲爱的${userName}，您预订的${venue}场馆-${activity}活动室-${time}的场次，已经被抢订。更多免费优质场地，请登录文化云。
	public  void autoCancelRoomOrder(final String mobileNo, final Map<String, Object> params) {
		try {
			sendSms(Constant.SMS_AUTO_CANCEL_ROOM_ORDER_CODE, mobileNo, params);
		} catch (Exception e) {
			logger.error("场次审核拒绝的通知发送失败");
			e.printStackTrace();
		}
	}

	// SMS_12150625 取消场馆订单
	// 新内容：【文化云】亲爱的${userName}，您预订的${venue}场馆-${activity}活动室-${time}的场次已成功退订。
	public  void cancelRoomOrder(final String mobileNo, final Map<String, Object> params) {
		try {
			sendSms(Constant.SMS_CANCEL_ROOM_ORDER_CODE, mobileNo, params);
		} catch (Exception e) {
			logger.error("取消场馆订单发送失败");
			e.printStackTrace();
		}
	}

	// SMS_11905134 实名认证通过的通知
	// 新内容：【文化云】亲爱的${userName}，您提交的实名认证申请已经通过审核。您可以进入“我的空间-实名认证”进行查询，更多免费公益活动，请登录文化云。
	public  void passRealName(final String mobileNo, final Map<String, Object> params) {
		try {
			sendSms(Constant.SMS_PASS_REAL_NAME_CODE, mobileNo, params);
		} catch (Exception e) {
			logger.error("实名认证通过的通知发送失败");
			e.printStackTrace();
		}
	}

	// SMS_11905135 实名认证拒绝的通知
	// 新内容：【文化云】亲爱的${userName}，很抱歉的通知您，您提交的实名认证申请未通过审核，原因为“自定义内容”，您可以进入“我的空间-实名认证”修改后重新提交。更多免费公益活动，请登录文化云。
	public  void failRealName(final String mobileNo, final Map<String, Object> params) {
		try {
			sendSms(Constant.SMS_FAIL_REAL_NAME_CODE, mobileNo, params);
		} catch (Exception e) {
			logger.error("实名认证拒绝的通知发送失败");
			e.printStackTrace();
		}
	}

	// SMS_11865085 使用者认证通过的通知
	// 新内容：【文化云】亲爱的${userName}，您提交的“使用者名称”认证申请已通过审核。您可以进入“我的空间-资质认证”修改后重新提交。更多免费优质场地，请登录文化云。
	public  void passUser(final String mobileNo, final Map<String, Object> params) {
		try {
			sendSms(Constant.SMS_PASS_USER_CODE, mobileNo, params);
		} catch (Exception e) {
			logger.error("使用者认证通过的通知发送失败");
			e.printStackTrace();
		}
	}

	// SMS_11895060 使用者认证拒绝的通知
	// 新内容：【文化云】亲爱的${userName}，很抱歉的通知您，您提交的“使用者名称”认证申请未通过审核，原因为“自定义内容”，您可以进入“我的空间-资质认证”修改后重新提交。更多免费优质场地，请登录文化云。
	public  void failUser(final String mobileNo, final Map<String, Object> params) {
		try {
			sendSms(Constant.SMS_FAIL_USER_CODE, mobileNo, params);
		} catch (Exception e) {
			logger.error("使用者认证拒绝的通知发送失败");
			e.printStackTrace();
		}
	}

	public static void cnwdSendMessage(String mobileNo, Map<String, Object> params) {
		try {
			getALiClient().execute(getSmsReq(Constant.SMS_CNWD_CODE, mobileNo, params));
		} catch (Exception e) {
			logger.error("长宁舞蹈大赛短信通知");
			e.printStackTrace();
		}
	}


	public void sendSms(final String SMS_TEMPLATE,final String mobile,final Map<String, Object> params) {
		final String product = "Dysmsapi";//短信API产品名称（短信产品名固定，无需修改）
		final String domain = "dysmsapi.aliyuncs.com";//短信API产品域名（接口地址固定，无需修改）
		IClientProfile profile = DefaultProfile.getProfile("cn-hangzhou", "LTAIkn922Fva8AfD",
				"31oZJ8eTtlLvQvqhUmPXxnuc73bdRB");
		try {
			DefaultProfile.addEndpoint("cn-hangzhou", "cn-hangzhou", product, domain);
		} catch (ClientException e) {
			e.printStackTrace();
		}
		IAcsClient client1 = new DefaultAcsClient(profile);


		SendSmsRequest sendSmsRequest = new SendSmsRequest();
		//使用post提交
		sendSmsRequest.setMethod(MethodType.POST);
		//必填:待发送手机号。支持以逗号分隔的形式进行批量调用，批量上限为1000个手机号码,批量调用相对于单条调用及时性稍有延迟,验
		// 证码类型的短信推荐使用单条调用的方式；发送国际/港澳台消息时，接收号码格式为00+国际区号+号码，
		// 如“0085200000000”
		sendSmsRequest.setPhoneNumbers(mobile); //必填:短信签名-可在短信
		// 控制台中找到
		sendSmsRequest.setSignName(Constant.PRODUCT); //必填:短信模板-可在短信控制台中找到，发送国际
		// /港澳台消息时，请使用国际/港澳台短信模版
		sendSmsRequest.setTemplateCode(SMS_TEMPLATE);
		sendSmsRequest.setTemplateParam(JSON.toJSONString(params));
		try {
			SendSmsResponse sendSmsResponse = client1.getAcsResponse(sendSmsRequest);
			if (sendSmsResponse.getCode() != null && sendSmsResponse.getCode().equals("OK")) {
				//请求成功
				System.out.println("=====success====");
			} else {
				System.out.println("=====fail=======");
			}


//			System.out.println(response.getData());
		} catch (ServerException e) {
			e.printStackTrace();
		} catch (ClientException e) {
			e.printStackTrace();
		}
	}
}
