package com.culturecloud.test.demo;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.RandomStringUtils;

import com.culturecloud.utils.pay.CreateCDATA;
import com.culturecloud.utils.pay.MD5;
import com.culturecloud.utils.pay.WeixinPayUtil;

public class TestPayDemo {

	public static void main(String[] args) {
		// TODO Auto-generated method stub

		String appkey="26bbc861d4d7bd467bf4de6a277dbe74";
		String mch_id="1340177401";
		String appid="wx847fffbbedaf4065";
		String nonce_str=RandomStringUtils.random(8, "123456789");
		System.out.println(nonce_str);
		String out_trade_no="why0000108";
		String total_fee="100";
		String spbill_create_ip="116.226.76.18";
		String notify_url="http://www.wenhuayun.cn/";
		String trade_type="JSAPI";
		String product_id="why00008";
		String body="why00008";
		String paySign;
		String url="https://api.mch.weixin.qq.com/pay/unifiedorder";
		String openid="oVEW6s9u56P8oLQck8-oAKq84o68";
		
		try {
			Map<String, String> paras = new HashMap<String, String>();
			paras.put("appid", appid);
			paras.put("body", body);
			paras.put("mch_id", mch_id);
			paras.put("nonce_str", nonce_str);
			paras.put("notify_url", notify_url);
			paras.put("out_trade_no", out_trade_no);
			paras.put("openid", openid);
			paras.put("product_id", product_id);
			paras.put("spbill_create_ip", spbill_create_ip);
			paras.put("trade_type", trade_type);
			paras.put("total_fee", total_fee);
			paySign = WeixinPayUtil.createSign(paras, false);
			StringBuilder str1= new StringBuilder();
			str1.append(paySign).append("&key=").append(appkey);
			String sign=MD5.MD5Encode(str1.toString()).toUpperCase();
			StringBuilder str = new StringBuilder();
			str.append("<xml>").append("<appid>").append(CreateCDATA.Create(appid))
			.append("</appid>").append("<mch_id>").append(mch_id).append("</mch_id>")
			.append(" <nonce_str>").append(nonce_str).append("</nonce_str>")
			.append("<sign>").append(CreateCDATA.Create(sign)).append("</sign>")
			.append(" <body>").append(CreateCDATA.Create(body)).append("</body>")
			.append(" <out_trade_no>").append(CreateCDATA.Create(out_trade_no)).append("</out_trade_no>")
			.append(" <total_fee>").append(total_fee).append("</total_fee>")
			.append("<spbill_create_ip>").append(CreateCDATA.Create(spbill_create_ip)).append("</spbill_create_ip>")
			.append("<notify_url>").append(CreateCDATA.Create(notify_url)).append("</notify_url>")
			.append("<trade_type>").append(CreateCDATA.Create(trade_type)).append("</trade_type>")
			.append("<product_id>").append(CreateCDATA.Create(product_id)).append("</product_id>")
			.append("<openid>").append(CreateCDATA.Create(openid)).append("</openid>")
			.append("</xml>");
			System.out.println("paySign="+paySign);
			String xml=WeixinPayUtil.post(url, str.toString());
			System.out.println("xml");
			
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
