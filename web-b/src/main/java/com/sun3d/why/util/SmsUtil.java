package com.sun3d.why.util;

import com.alibaba.fastjson.JSON;
import com.aliyuncs.DefaultAcsClient;
import com.aliyuncs.IAcsClient;
import com.aliyuncs.dysmsapi.model.v20170525.SendSmsRequest;
import com.aliyuncs.dysmsapi.model.v20170525.SendSmsResponse;
import com.aliyuncs.exceptions.ClientException;
import com.aliyuncs.exceptions.ServerException;
import com.aliyuncs.http.MethodType;
import com.aliyuncs.profile.DefaultProfile;
import com.aliyuncs.profile.IClientProfile;
import com.culturecloud.model.bean.common.SysSmsStatistics;
import com.taobao.api.DefaultTaobaoClient;
import com.taobao.api.TaobaoClient;
import com.taobao.api.request.AlibabaAliqinFcSmsNumSendRequest;
import com.taobao.api.response.AlibabaAliqinFcSmsNumSendResponse;
import org.apache.log4j.Logger;

import java.util.Date;
import java.util.Map;

public class SmsUtil {

    private static Logger logger = Logger.getLogger(SmsUtil.class);

    //短信连接
    private static TaobaoClient getALiClient(){
        return new DefaultTaobaoClient("http://gw.api.taobao.com/router/rest", "23318100", "af05b37a5adb39c81c75137e0f6ace6f");
    }

    //短信req
    private static AlibabaAliqinFcSmsNumSendRequest getSmsReq(final String smsTemplateCode,
                                                              final String mobileNo,
                                                              final Map<String,Object> params){
        AlibabaAliqinFcSmsNumSendRequest req = new AlibabaAliqinFcSmsNumSendRequest();
        req.setExtend(mobileNo);
        req.setSmsType("normal");
        req.setSmsFreeSignName(Constant.PRODUCT);
        req.setSmsTemplateCode(smsTemplateCode);
        req.setSmsParamString(JSON.toJSONString(params));
        req.setRecNum(mobileNo);
        return req;
    }

    //获取随机六位数验证码
    public  static  String  getValidateCode(){
        return String.valueOf(Math.random()).substring(2,8);
    }

    //注册短信验证码
    //内容:验证码${code}，您正在注册成为${product}用户，感谢您的支持！
    public static void sendRegisterCode(final String mobileNo,final Map<String,Object> params){
        try {
            sendSms(Constant.SMS_TPL_REG_CODE,mobileNo,params);
        } catch (Exception e) {
            logger.error("注册短信验证码发送失败");
            e.printStackTrace();
        }
    }

    //找回密码及验证手机号
    //内容：验证码${code}，您正在进行${product}身份验证，打死不要告诉别人哦！
    public static void sendForgetCode(final String mobileNo,final Map<String,Object> params){
        try {
            sendSms(Constant.SMS_TPL_USER_CODE,mobileNo,params);
        } catch (Exception e) {
            logger.error("找回密码验证码发送失败");
            e.printStackTrace();
        }
    }

    //预订活动时验证手机号 SMS_11915059
    //新内容：【文化云】您的验证码为${code},请在页面中输入以完成验证，如有疑问，请致电4000-018-2346。
    public static void sendActivityCode(final String mobileNo,final Map<String,Object> params){
        try {
            sendSms(Constant.SMS_ACTIVITY_CODE,mobileNo,params);
        } catch (Exception e) {
            logger.error("预订活动时验证手机号发送失败");
            e.printStackTrace();
        }
    }

    //用户修改信息(修改手机号码等) 修改个人信息验证码
    //内容：  验证码${code}，您正在尝试变更${product}重要信息，请妥善保管账户信息
    public static void sendUpdateCode(final String mobileNo,final Map<String,Object> params){
        try {
            sendSms(Constant.SMS_TPL_UPDATE_CODE,mobileNo,params);
        } catch (Exception e) {
            logger.error("用户修改验证码发送失败");
            e.printStackTrace();
        }
    }

    //后台添加用户通知短信  SMS_5215439
    //内容：亲爱的${userName}，您已成功注册成为文化云会员，账号为手机号，密码为${userPassWord}。欢迎您使用文化云平台。
    public static void sendUserInfoCode(final String mobileNo,final Map<String,Object> params){
        try {
            sendSms(Constant.SMS_USER_INFO_CODE,mobileNo,params);
        }catch (Exception e) {
            logger.error("后台添加用户短信发送失败");
            e.printStackTrace();
        }
    }

    //活动订单 SMS_12505828
    //新内容：亲爱的${userName}，您已成功预订${activityName}活动的${ticketCount}张票， 时间为${time},请凭验票码${ticketNum}或扫描二维码入场，如需退票，请提前取消订单。
    public static void sendActivityOrderSms(final String mobileNo,final Map<String,Object> params){
        try {
            sendSms(Constant.SMS_ACTIVITY_ORDER_CODE,mobileNo,params);
        } catch (Exception e) {
            logger.error("活动订单短信发送失败") ;
            e.printStackTrace();
        }
    }


    //场馆订单 SMS_5230461
    //内容：亲爱的${userName}，恭喜您成功预订 ${venueName}-${activityRoomName}，请通过验票码${ticketCode}或扫描二维码入场。如需退票，请提前取消订单。
    public static void sendVenueOrderSms(final String mobileNo,final Map<String,Object> params){
        try {
            sendSms(Constant.SMS_VENUE_ORDER_CODE,mobileNo,params);
        } catch (Exception e) {
            logger.error("场馆订单短信发送失败");
            e.printStackTrace();
        }
    }

    //取消场馆订单  SMS_5285494
    //内容：亲爱的${userName}，您预订的编号为${orderId}的场馆已成功取消。
    public static void cancelVenueOrderSms(final String mobileNo,final Map<String,Object> params){
        try {
            sendSms(Constant.SMS_CANCEL_VENUE_ORDER_CODE,mobileNo,params);
        } catch (Exception e) {
            logger.error("取消场馆订单短信发送失败");
            e.printStackTrace();
        }
    }

    //活动开始通知 SMS_5280416
    //内容：亲爱的${userName}，您预订了今天${beginTime}的“${activityName}”活动，距离开始还有2小时，请安排好时间，不要错过哦。感谢您使用文化云平台。
    public static void sendActivityNoticeSms(final String mobileNo,final Map<String,Object> params){
        try {
            sendSms(Constant.SMS_ACTIVITY_NOTICE_CODE,mobileNo,params);
        } catch (Exception e) {
            logger.error("活动开始通知发送失败");
            e.printStackTrace();
        }
    }

    // 活动取消通知已下单的用户 SMS_11875074
    // 新内容：尊敬的用户：因${content}，活动取消，给您带来不便，敬请谅解！
    public static void cancelActivitySms(final String mobileNo,final Map<String,Object> params){
        try{
            sendSms(Constant.SMS_CANCEL_ACTIVITY_CODE,mobileNo,params);
        }catch (Exception e){
            logger.error("活动取消通知发送失败");
            e.printStackTrace();
        }
    }

    // 活动取消通知已下单的用户 SMS_12140508
    // 新内容：【文化云】亲爱的${userName}，您预订的${activityName}活动${num}张票，时间为${time}，因系统升级，
    // 原有座位已被取消，为您安排了新的座位${site1},请凭验证码${ticketNum}于活动开场前取票入场，
    // 如需退票，请提前取消订单。！
    public static void changeActivitySms(final String mobileNo,final Map<String,Object> params){
        try{
            sendSms(Constant.SMS_CHANGE_ACTIVITY_CODE,mobileNo,params);
        }catch (Exception e){
            logger.error("活动取消通知发送失败");
            e.printStackTrace();
        }
    }

    //SMS_11875073  取消自由入座
    //新内容：【文化云】亲爱的${userName}，您预定的【${activityName}】活动的${ticketCount}张票已成功退订。
    public static void cancelActivityFreeOrderSms(final String mobileNo,final Map<String,Object> params){
        try{
            sendSms(Constant.SMS_CANCEL_ACTIVITY_FREE_ORDER_CODE,mobileNo,params);
        }catch (Exception e){
            logger.error("取消自由入座发送失败");
            e.printStackTrace();
        }
    }

    //SMS_11930070  取消在线选座
    //新内容：【文化云】亲爱的${userName}，您预定的【${activityName}】活动的座位(${seatInfo})已成功退订。
    public static void cancelActivitySeatOrderSms(final String mobileNo,final Map<String,Object> params){
        try{
            sendSms(Constant.SMS_CANCEL_ACTIVITY_SEAT_ORDER_CODE,mobileNo,params);
        }catch (Exception e){
            logger.error("取消在线选座发送失败");
            e.printStackTrace();
        }
    }

    //SMS_12180668   票务未核销的通知
    //新内容：【文化云】通知：亲爱的${userName}，很抱歉的通知您，您预订的${month}月${day}日的${activity}活动的${num}张票，在活动开始后未到场核销，按相关规定，您将被扣除${branch}积分。文化云致力于为公众提供免费公益的文化活动，因票务十分抢手，希望预约过的朋友们都能如约到场喔！
    public static void deductionOrderCode(final String mobileNo,final Map<String,Object> params){
        try{
            sendSms(Constant.SMS_DEDUCTION_ORDER_CODE,mobileNo,params);
        }catch (Exception e){
            logger.error("票务未核销的通知发送失败");
            e.printStackTrace();
        }
    }

    //SMS_12180667  场次审核通过的通知
    //新内容：【文化云】亲爱的${userName}，您预订的${venue}场馆-${activity}活动室-${time}的场次，已经审核通过，请凭验票码${ticketCode}或扫描二维码入场。如需退票，请提前取消订单。
    public static void passRoomOrder(final String mobileNo,final Map<String,Object> params){
        try{
            sendSms(Constant.SMS_PASS_ROOM_ORDER_CODE,mobileNo,params);
        }catch (Exception e){
            logger.error("场次审核通过的通知发送失败");
            e.printStackTrace();
        }
    }

    //SMS_12185571   场次审核拒绝的通知(手动)
    //新内容：【文化云】亲爱的${userName}，您预订的${venue}场馆-${activity}活动室-${time}的场次，审核未通过，原因为“自定义内容”，如有疑问，请致电4000-018-2346。
    public static void manCancelRoomOrder(final String mobileNo,final Map<String,Object> params){
        try{
            sendSms(Constant.SMS_MAN_CANCEL_ROOM_ORDER_CODE,mobileNo,params);
        }catch (Exception e){
            logger.error("场次审核拒绝的通知发送失败");
            e.printStackTrace();
        }
    }

    //SMS_12145516   场次审核拒绝的通知(自动)
    //新内容：【文化云】亲爱的${userName}，您预订的${venue}场馆-${activity}活动室-${time}的场次，已经被抢订。更多免费优质场地，请登录文化云。
    public static void autoCancelRoomOrder(final String mobileNo,final Map<String,Object> params){
        try{
            sendSms(Constant.SMS_AUTO_CANCEL_ROOM_ORDER_CODE,mobileNo,params);
        }catch (Exception e){
            logger.error("场次审核拒绝的通知发送失败");
            e.printStackTrace();
        }
    }

    //SMS_12150625   取消场馆订单
    //新内容：【文化云】亲爱的${userName}，您预订的${venue}场馆-${activity}活动室-${time}的场次已成功退订。
    public static void cancelRoomOrder(final String mobileNo,final Map<String,Object> params){
        try{
            sendSms(Constant.SMS_CANCEL_ROOM_ORDER_CODE,mobileNo,params);
        }catch (Exception e){
            logger.error("取消场馆订单发送失败");
            e.printStackTrace();
        }
    }

    //SMS_11905134   实名认证通过的通知
    //新内容：【文化云】亲爱的${userName}，您提交的实名认证申请已经通过审核。您可以进入“我的空间-实名认证”进行查询，更多免费公益活动，请登录文化云。
    public static void passRealName(final String mobileNo,final Map<String,Object> params){
        try{
            sendSms(Constant.SMS_PASS_REAL_NAME_CODE,mobileNo,params);
        }catch (Exception e){
            logger.error("实名认证通过的通知发送失败");
            e.printStackTrace();
        }
    }

    //SMS_11905135   实名认证拒绝的通知
    //新内容：【文化云】亲爱的${userName}，很抱歉的通知您，您提交的实名认证申请未通过审核，原因为“自定义内容”，您可以进入“我的空间-实名认证”修改后重新提交。更多免费公益活动，请登录文化云。
    public static void failRealName(final String mobileNo,final Map<String,Object> params){
        try{
            sendSms(Constant.SMS_FAIL_REAL_NAME_CODE,mobileNo,params);
        }catch (Exception e){
            logger.error("实名认证拒绝的通知发送失败");
            e.printStackTrace();
        }
    }

    //SMS_11865085   使用者认证通过的通知
    //新内容：【文化云】亲爱的${userName}，您提交的“使用者名称”认证申请已通过审核。您可以进入“我的空间-资质认证”修改后重新提交。更多免费优质场地，请登录文化云。
    public static void passUser(final String mobileNo,final Map<String,Object> params){
        try{
            sendSms(Constant.SMS_PASS_USER_CODE,mobileNo,params);
        }catch (Exception e){
            logger.error("使用者认证通过的通知发送失败");
            e.printStackTrace();
        }
    }

    //SMS_11895060   使用者认证拒绝的通知
    //新内容：【文化云】亲爱的${userName}，很抱歉的通知您，您提交的“使用者名称”认证申请未通过审核，原因为“自定义内容”，您可以进入“我的空间-资质认证”修改后重新提交。更多免费优质场地，请登录文化云。
    public static void failUser(final String mobileNo,final Map<String,Object> params){
        try{
            sendSms(Constant.SMS_FAIL_USER_CODE,mobileNo,params);
        }catch (Exception e){
            logger.error("使用者认证拒绝的通知发送失败");
            e.printStackTrace();
        }
    }
    
    // SMS_32140001 发送给场馆老师每个月发活动数
    //【文化云】根据{month}月份数据统计结果，您（${area}）在文化上海云平台上的活动发布数量为（${num}），
    //在本区排名第（${areaRank}），在全市排名第（${cityRank}），您的努力将丰富更多市民的文化活动。文化云客服电话：4000182346
    public static AlibabaAliqinFcSmsNumSendResponse sendMonthActivityCount(final String mobileNo,final Map<String,Object> params){
    	 AlibabaAliqinFcSmsNumSendResponse res= null;
    	try{
              sendSms(Constant.SMS_MONTH_ACTIVITY_COUNT_CODE,mobileNo,params);
    	   }catch (Exception e){
               logger.error("发送给场馆老师每个月发活动数发送失败");
               e.printStackTrace();
           }
    	 return res;
    }
    
 // SMS_32135001 发送给场馆老师每个月发活动数为零
 	//模板内容:
 	//	【文化云】根据${month}月份数据统计结果，您（${area}）在文化上海云平台上的活动发布数量为零，如有疑问或需要帮助请致电4000182346 。
 	public static AlibabaAliqinFcSmsNumSendResponse sendMonthActivityZero(final String mobileNo,
 			final Map<String, Object> params) {
 		AlibabaAliqinFcSmsNumSendResponse res = null;
 		try {
 		    sendSms(Constant.SMS_MONTH_ACTIVITY_ZERO_CODE, mobileNo, params);
 		} catch (Exception e) {
 			logger.error("发送给场馆老师每个月发活动数发送失败");
 			e.printStackTrace();
 		}
 		return res;
 	}
 	
    // SMS_32050002 发送给场馆老师每个月可预订活动数
 	//【文化云】根据{month}月份数据统计结果，您（${area}）在文化上海云平台上发布的可预订活动数量为（${num}），
 	// 在本区排名第（${areaRank}），在全市排名第（${cityRank}），您的努力将丰富更多市民的文化活动。文化云客服电话：4000182346
    public static AlibabaAliqinFcSmsNumSendResponse sendMonthActivityReservationCount(final String mobileNo,final Map<String,Object> params){
    	 AlibabaAliqinFcSmsNumSendResponse res= null;
    	try{
              sendSms(Constant.SMS_MONTH_ACTIVITY_RESERVATION_COUNT_CODE,mobileNo,params);
    	   }catch (Exception e){
               logger.error("发送给场馆老师每个月发活动数发送失败");
               e.printStackTrace();
           }
    	 return res;
    }
    
	
    // SMS_60210262
    // 很抱歉，您提交的身份认证因${reason}未通过审核，请您登陆后进入个人中心重新提交，如有疑问，请拨打客服电话4000182346.
    public static AlibabaAliqinFcSmsNumSendResponse sendTerminalUserAuthNotPass(final String mobileNo,final Map<String,Object> params){
    	
    	 AlibabaAliqinFcSmsNumSendResponse res= null;
     	try{
               sendSms(Constant.SMS_TERMINALUSER_AUTH_NOT_PASS_CODE,mobileNo,params);
     	   }catch (Exception e){
                logger.error("实名认证审核不通过发送失败");
                e.printStackTrace();
            }
     	 return res;
    }
    
    // SMS_60265218 
    // 恭喜您，您提交的身份认证于${dateTime}已通过审核，您可以登录文化云-个人中心查看。如有疑问，请拨打客服电话4000182346
    public static AlibabaAliqinFcSmsNumSendResponse sendTerminalUserAuthPass(final String mobileNo,final Map<String,Object> params){
    	
   	 AlibabaAliqinFcSmsNumSendResponse res= null;
    	
    	try{
              sendSms(Constant.SMS_TERMINALUSER_AUTH_PASS_CODE,mobileNo,params);
    	   }catch (Exception e){
               logger.error("实名认证审核不通过发送失败");
               e.printStackTrace();
           }
    	 return res;
   }

    // 活动取消通知已下单的用户 SMS_149418415
    // 【文化云】您已退订成功！您所报名的"${courseType}"培训"${trainTitle}"已退订。详细报名信息可登陆平台,进入个人中心查看
    public static void sendTrainUnsubscribe(final String mobileNo, final Map<String, Object> params) {
        try {
            sendSms(Constant.SMS_TRAINING_UNSUBSCRIBE_TRAIN, mobileNo, params);
        } catch (Exception e) {
            logger.error("培训取消预订成功短信发送失败");
            e.printStackTrace();
        }
    }

    // SMS_158490808
    // 【文化云】您所报名的培训${trainName},开课时间为${trainStartTime},地点为${location},请按时参加！详细报名信息可登陆平台,进入个人中心查看。
    public static AlibabaAliqinFcSmsNumSendResponse sendStartMessage(final String mobileNo,final Map<String,Object> params){

        AlibabaAliqinFcSmsNumSendResponse res= null;

        try{
            sendSms(Constant.SMS_TRAIN_START_MESSAGE,mobileNo,params);

        }catch (Exception e){
            logger.error("发送开课通知短信失败");
            e.printStackTrace();
        }
        return res;
    }
    // 活动取消通知已下单的用户 SMS_149418415
    // 【文化云】您已退订成功！您所报名的"${courseType}"培训"${trainTitle}"已退订。详细报名信息可登陆平台,进入个人中心查看
    public static void trainOrderUnsubscribe(final String mobileNo, final Map<String, Object> params) {
        try {
            sendSms(Constant.SMS_TRAINING_CANCEL_TRAIN, mobileNo, params);
        } catch (Exception e) {
            logger.error("培训取消预订成功短信发送失败");
            e.printStackTrace();
        }
    }

    // 活动取消通知已下单的用户 SMS_149418413
    // 【文化云】您已被录取！您所报名的"${courseType}"培训"${trainTitle}"开课时间为：${trainStartTime},地点为：${trainAddress},请按时参加！详细报名信息可登陆平台,进入个人中心查看！
    public static void sendTrainEntrySuccess(final String mobileNo, final Map<String, Object> params) {
        try {
            sendSms(Constant.SMS_TRAINING_ENTRY_SUCCESS, mobileNo, params);
        } catch (Exception e) {
            logger.error("培训预订成功短信发送失败");
            e.printStackTrace();
        }
    }

    public static void sendSms(final String SMS_TEMPLATE,final String mobile,final Map<String, Object> params) {
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

