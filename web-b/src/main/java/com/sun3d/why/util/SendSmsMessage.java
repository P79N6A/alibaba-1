package com.sun3d.why.util;


import com.sun3d.why.model.extmodel.SmsConfig;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;

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
}
