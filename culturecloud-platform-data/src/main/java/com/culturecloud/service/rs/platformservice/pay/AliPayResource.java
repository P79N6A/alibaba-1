package com.culturecloud.service.rs.platformservice.pay;

import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.springframework.stereotype.Component;

import com.alipay.api.internal.util.AlipaySignature;
import com.culturecloud.annotations.SysBusinessLog;
import com.culturecloud.model.bean.activity.CmsActivity;
import com.culturecloud.model.bean.activity.CmsActivityOrder;
import com.culturecloud.model.request.pay.PayAppOrderReqVO;
import com.culturecloud.service.BaseService;
import com.culturecloud.util.pay.AliPayConfig;
import com.culturecloud.util.pay.AlipayCore;

import net.sf.json.JSONObject;

@Component
@Path("/alipay")
public class AliPayResource {

	@Resource
	private BaseService baseService;
	

	/** 支付宝预单生产APP支付*/
	@POST
	@Path("/preapppay")
	@SysBusinessLog(remark="支付宝APP支付")
	@Produces(MediaType.APPLICATION_JSON)
	public String AliPreAppPay(PayAppOrderReqVO req)
	{
		List<CmsActivityOrder> orderList=baseService.find(CmsActivityOrder.class, " where ACTIVITY_ORDER_ID='"+req.getOrderId()+"' and ORDER_PAYMENT_STATUS=1");
		if(orderList!=null&&orderList.size()>0&&(orderList.get(0).getOrderPayPreparId()==null||orderList.get(0).getOrderPayPreparId().length()<50))
		{
			try {
				SimpleDateFormat sf =new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				String timestamp=sf.format(new Date());
				System.out.println(timestamp);		
				//公共参数
		        Map<String, String> map = new HashMap<String, String>();
		        map.put("app_id", AliPayConfig.appId);
		        map.put("method", "alipay.trade.app.pay");
		        map.put("format", "json");
		        map.put("charset", "utf-8");
		        map.put("sign_type", "RSA");
		        map.put("timestamp",timestamp);
		        map.put("version", "1.0");
		        map.put("notify_url", AliPayConfig.callback);
		        
		        CmsActivity activity=baseService.findById(CmsActivity.class,orderList.get(0).getActivityId());
		        
		        Map<String, String> m = new HashMap<String, String>();

//		        m.put("body", "");
		        m.put("subject",activity.getActivityName());
		        m.put("out_trade_no",req.getOrderId());
		        m.put("timeout_express", "15m");
		        m.put("total_amount",orderList.get(0).getOrderPrice().toString());
//		        m.put("seller_id", "");
		        m.put("product_code", "QUICK_MSECURITY_PAY");

		        JSONObject bizcontentJson= JSONObject.fromObject(m);

		        map.put("biz_content", bizcontentJson.toString());
				String rsaSign = AlipaySignature.rsaSign(map,AliPayConfig.privateKey,"utf-8");
				Map<String, String> map4 = new HashMap<String, String>();

		        map4.put("app_id", AliPayConfig.appId);
		        map4.put("method", "alipay.trade.app.pay");
		        map4.put("format", "json");
		        map4.put("charset", "utf-8");
		        map4.put("sign_type", "RSA");
		        map4.put("timestamp", URLEncoder.encode(timestamp,"UTF-8"));
		        map4.put("version", "1.0");
		        map4.put("notify_url",  URLEncoder.encode(AliPayConfig.callback,"UTF-8"));
		        //最后对请求字符串的所有一级value（biz_content作为一个value）进行encode，编码格式按请求串中的charset为准，没传charset按UTF-8处理
		        map4.put("biz_content", URLEncoder.encode(bizcontentJson.toString(), "UTF-8"));
		        Map par = AlipayCore.paraFilter(map4); //除去数组中的空值和签名参数
		        String json4 = AlipayCore.createLinkString(map4);   //拼接后的字符串
		        json4=json4 + "&sign=" + URLEncoder.encode(rsaSign, "UTF-8");
		        CmsActivityOrder a=baseService.findById(CmsActivityOrder.class,req.getOrderId());
	        	a.setOrderPayPreparId(json4);
	        	baseService.update(a," where ACTIVITY_ORDER_ID='"+req.getOrderId()+"'");
		        return json4;
		    
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		else
		{
			CmsActivityOrder a=baseService.findById(CmsActivityOrder.class,req.getOrderId());
			return a.getOrderPayPreparId();
		}
		return null;
	}
}
