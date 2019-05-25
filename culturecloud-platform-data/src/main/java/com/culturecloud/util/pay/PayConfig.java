package com.culturecloud.util.pay;

import com.culturecloud.kafka.PpsConfig;

public class PayConfig {

	/** 公众号支付*/
	public static String APP_KEY="26bbc861d4d7bd467bf4de6a277dbe74";
	
	public static String MCH_id="1340177401";
	
	public static String APP_ID="wx847fffbbedaf4065";
	
	public static String NOTIFY_URL=PpsConfig.getString("xwcallback").toString();
	
	public static String TRADE_TYPE="JSAPI";
	
	/** APP支付*/
	
	public static String APPKEY="26bbc861d4d7bd467bf4de6a277dbe74";
	
	public static String APPMCHid="1261456301";
	
	public static String APPID="wx94a16263c1f82766";
	
//	public static String NOTIFY_URL="http://www.wenhuayun.cn/";
	
	public static String TRADETYPE="APP";
}
