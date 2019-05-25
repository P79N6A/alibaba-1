package com.sun3d.why.controller.mobile;

import com.sun3d.why.model.extmodel.MobileNos;
import com.sun3d.why.service.CacheConstant;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.util.Constant;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by niubiao on 2016/3/9.
 * 群发短信
 */
@Controller
@RequestMapping("/sms")
public class SmsController {

    @Autowired
    private MobileNos mobileNos;

    @Autowired
    private CacheService cacheService;

    @RequestMapping(value = "/send",method = RequestMethod.GET)
    public ModelAndView toSendPage(){
        ModelAndView modelAndView = new ModelAndView();
        List<String> dataList = Arrays.asList(mobileNos.getSendSmsMobileNo().split(","));
        modelAndView.addObject("dataList",dataList);
        modelAndView.setViewName("mobile/sms/sendPage");
        return  modelAndView;
    }

    @RequestMapping(value = "/send",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> send(String mobileNo){
        Map<String,Object> result = new HashMap<>();
        //发送结果
        List<Map<String,Object>> sendList = new ArrayList<>();
        Map<String,Object> sendMap =null;
        //短信模板参数
        Map<String,Object> params = new HashMap<>();
        params.put("indexUrl", Constant.SMS_INDEX_URL);
        //前台提交的
        if(StringUtils.isNotEmpty(mobileNo)){
            String mobileArr[] = mobileNo.split(",");
            for (String str:mobileArr){
                   if(StringUtils.isNotBlank(str)){
                       sendMap = new HashMap<>();
                       sendMap.put("mobileNo",str);
                       //发送短信
//                       if(SmsUtil.sendWhyPublishSms(str,params)){
//                           sendMap.put("code",200);
//                       }else{
//                           sendMap.put("code",500);
//                       }
                       sendList.add(sendMap);
                   }
            }
        }

/*
        if(true){
            result.put("code",200);
            return result;
        }
*/


        //判断后台配置是否发送过 如果redis存在 则不重复发送
        try{
/*            List<Map<String,Object>> cacheList = cacheService.getSendSmsInfo(CacheConstant.SEND_SMS_INFO+new SimpleDateFormat("yyyy-MM-dd").format(new Date()));*/
            //不存在发送结果则发送


        /*    if (tf){
                System.out.println("后台配置的已经发送过了。。。");
            }
*/
            boolean tf = cacheService.isExistKey(CacheConstant.SEND_SMS_INFO+new SimpleDateFormat("yyyy-MM-dd").format(new Date()));

            if(!tf){
                //后台配置号码
                if(StringUtils.isNotBlank(mobileNos.getSendSmsMobileNo())){
                    List<String> dataList = Arrays.asList(mobileNos.getSendSmsMobileNo().split(","));
                    for(String str:dataList){
                        sendMap = new HashMap<>();
                        sendMap.put("mobileNo",str);
                        //发送短信
//                        if(SmsUtil.sendWhyPublishSms(str,params)){
//                            sendMap.put("code",200);
//                        }else{
//                            sendMap.put("code",500);
//                        }
                        sendList.add(sendMap);
                    }
                }
            }
        }catch (Exception e){
            e.printStackTrace();
        }

        //发送短信结果放入redis  200 发送成功  500发送失败
        try{
            cacheService.setSendSmsInfo(CacheConstant.SEND_SMS_INFO+new SimpleDateFormat("yyyy-MM-dd").format(new Date()),sendList);
        }catch (Exception e){
            e.printStackTrace();
        }

        //获取放入redis的数据
/*
List<Map<String,Object>> cacheList = cacheService.getSendSmsInfo(CacheConstant.SEND_SMS_INFO+new SimpleDateFormat("yyyy-MM-dd").format(new Date()));

        if(!CollectionUtils.isEmpty(cacheList)){
            for(Map<String,Object> map:cacheList){
                    System.out.println("发送手机号码--->"+ map.get("mobileNo") + "-----ResCode--->" + map.get("code"));
            }
        }
*/

        result.put("code",200);
        return result;
    }

}
