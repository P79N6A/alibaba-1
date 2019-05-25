package com.sun3d.why.util;

/**
 * 发送短信接口
 * Created by Administrator on 2015/7/7.
 */
public class SendSmsMessage {

/*    public static String sendSmsMessage(String userMobileNo, String smsContent, SmsConfig smsConfig, Logger logger){

    /*public static String sendSmsMessage(String userMobileNo, String smsContent, SmsConfig smsConfig, Logger logger){

        String code = "";
        try{
            SmsSend send = new SmsSend();
            code = send.sendSmsMessage(smsConfig.getSmsUrl(),smsConfig.getuId(),smsConfig.getPwd(),userMobileNo,smsContent);
            return code;
        }catch (Exception e){
            logger.info("sendSms error", e);
        }
        return code;
    }*/
	
//	 private static Logger logger = Logger.getLogger(SendSmsMessage.class);
//
//
//	    public static String sendSmsMessage(String userMobile,String content, SendMsgUrl sendMsgUrl){
//	        String responseText="";
//	        String  smsContent = ""+content;
//	        try{
//	            JSONObject jsonObject = new JSONObject();
//	            jsonObject.put("phone", userMobile);
//	            jsonObject.put("msg", smsContent);
//	            responseText = HttpClientConnection.post2(sendMsgUrl.getSendMsgUrl() + "/sms/api/msg/sendMsg.do", jsonObject);
//	            System.out.println("test:"+responseText);
//	            net.sf.json.JSONObject rsJN =  net.sf.json.JSONObject.fromObject(responseText);
//	            return rsJN.get("code").toString();
//	        }catch (Exception e){
//	            e.printStackTrace();
//	            logger.error("短信发送失败",e);
//	        }
//	        return responseText;
//	    }
//
//	    public static void main(String[] args) {
//	    	SendMsgUrl sendMsgUrl = new SendMsgUrl();
//	    	sendMsgUrl.setSendMsgUrl("http://139.196.4.184:9000");
//	    	sendMsgUrl.setCustomerMobile("13817406320");
//	    	sendMsgUrl.setDeveloprMobile("13817406320");
//	    	SendSmsMessage.sendSmsMessage("13817406320","test", sendMsgUrl);
//		}
}
