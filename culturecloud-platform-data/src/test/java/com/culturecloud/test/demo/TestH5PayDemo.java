package com.culturecloud.test.demo;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang.RandomStringUtils;

import com.culturecloud.utils.pay.MD5;
import com.culturecloud.utils.pay.WeixinPayUtil;

public class TestH5PayDemo {

	public static void main(String[] args) throws UnsupportedEncodingException {
		// TODO Auto-generated method stub
		 Map<String, String> paras = new HashMap<String, String>(); 
		 String nonce_str1=RandomStringUtils.random(8, "123456789");
		 String timestamp=String.valueOf(System.currentTimeMillis());
		 String appkey="26bbc861d4d7bd467bf4de6a277dbe74";
		 paras.put("appId","wx847fffbbedaf4065"); 
		 paras.put("timeStamp",timestamp); 
		 paras.put("nonceStr", nonce_str1); 
		 paras.put("signType", "MD5");
		 paras.put("package", "prepay_id=wx201702081533262be4c034e50134966557"); 
//		 paras.put("appkey",appkey); 
		 // appid、timestamp、noncestr、package 以及 appkey。 
		 String string1 = WeixinPayUtil.createSign(paras, false);
		 
		 StringBuilder str1= new StringBuilder();
			str1.append(string1).append("&key=").append(appkey);
			
		 String paySign = MD5.MD5Encode(str1.toString()).toUpperCase(); 
		 
		 System.out.println("timestamp="+timestamp+"||nonce_str1="+nonce_str1);
		 
		 System.out.println(paySign);
//		 return paySign; 
	}

}
