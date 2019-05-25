package com.culturecloud.util.pay;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.RandomStringUtils;

import com.culturecloud.utils.pay.MD5;
import com.culturecloud.utils.pay.WeixinPayUtil;

public class PayUtils {

	
	
	public static WxPayConfig getWxPayConfig(String prepay_id) throws Exception
	{
		 WxPayConfig wx=new WxPayConfig();
		 Map<String, String> paras = new HashMap<String, String>(); 
		 String nonce_str1=RandomStringUtils.random(8, "123456789");
		 wx.setNonce_str(nonce_str1);
		 String timestamp=String.valueOf(System.currentTimeMillis());
		 wx.setTimestamp(timestamp);
		 String appkey=PayConfig.APP_KEY;
		 paras.put("appId",PayConfig.APP_ID); 
		 wx.setAppId(PayConfig.APP_ID);
		 paras.put("timeStamp",timestamp); 
		 paras.put("nonceStr", nonce_str1); 
		 paras.put("signType", "MD5");
		 wx.setSignType("MD5");
		 paras.put("package", "prepay_id="+prepay_id); 
		 wx.setPack_age("prepay_id="+prepay_id);

		 String string1 = WeixinPayUtil.createSign(paras, false);
		 
		 StringBuilder str1= new StringBuilder();
			str1.append(string1).append("&key=").append(appkey);
		 String paySign = MD5.MD5Encode(str1.toString()).toUpperCase(); 
		 wx.setPaySign(paySign);
		 
		 System.out.println(paySign);
		return wx;
	}
	
	public static WxAPPPayConfig getWxAppPayConfig(String prepay_id,String nonce_str) throws Exception
	{
		 WxAPPPayConfig wx=new WxAPPPayConfig();
		 Map<String, String> paras = new HashMap<String, String>(); 
//		 String nonce_str1=RandomStringUtils.random(8, "123456789");
		
		 String timestamp=String.valueOf(System.currentTimeMillis()/1000);
		
		 String appkey=PayConfig.APPKEY;
		 paras.put("appid",PayConfig.APPID); 
		 paras.put("partnerid",PayConfig.APPMCHid);
		 wx.setPartnerId(PayConfig.APPMCHid);
		 
		 paras.put("prepayid",prepay_id);
		 wx.setPrepayId(prepay_id);
		 paras.put("package", "Sign=WXPay");
		 wx.setPack_age("Sign=WXPay");
		 paras.put("noncestr",nonce_str);
		 wx.setNoncestr(nonce_str);
		 paras.put("timestamp",timestamp); 
		 wx.setTimestamp(timestamp);

		 String string1 = WeixinPayUtil.createSign(paras, false);
		 StringBuilder str1= new StringBuilder();
			str1.append(string1).append("&key=").append(appkey);
		 System.out.println("str1="+str1);
			
		 String paySign = MD5.MD5Encode(str1.toString()).toUpperCase(); 
		 wx.setSign(paySign);
		 System.out.println("paySign="+paySign);
		return wx;
	}
	
	
	public static void main(String args[]) throws UnsupportedEncodingException
	{
//		Map<String, String> paras = new HashMap<String, String>(); 
//		 String appkey=PayConfig.APPKEY;
//		 paras.put("appid",PayConfig.APPID); 
//		 paras.put("partnerid",PayConfig.APPMCHid);
//		
//		 
//		 paras.put("prepayid","wx201702222128379b87445c7c0285844541");
//		
//		 paras.put("package", "Sign=WXPay");
//		 
//		 paras.put("noncestr","22194319");
//		
//		 paras.put("timestamp","1487770117"); 
//		 
//
//		 String string1 = WeixinPayUtil.createSign(paras, false);
//		 
//		 StringBuilder str1= new StringBuilder();
//			str1.append(string1).append("&key=").append(appkey);
//		System.out.println("str1="+str1);
		
		String aa="appid=wx94a16263c1f82766&noncestr=21613858&package=Sign=WXPay&partnerid=1261456301&prepayid=prepay_id&timestamp=1487771484&key=26bbc861d4d7bd467bf4de6a277dbe74";
		String paySign = MD5.MD5Encode(aa).toUpperCase(); 
		System.out.println(paySign);
	}
	
	
	
	
	
	public static String getPayMoney(String amt)
	{
		int money=(int) (Double.valueOf(amt)*100);
		return String.valueOf(money);
	}
	
	
	

}
