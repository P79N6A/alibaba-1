package com.culturecloud.service.rs.platformservice.pay;

import java.io.StringReader;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.Unmarshaller;

import org.apache.commons.lang.RandomStringUtils;
import org.springframework.stereotype.Component;

import com.culturecloud.annotations.SysBusinessLog;
import com.culturecloud.exception.BizException;
import com.culturecloud.model.bean.activity.CmsActivity;
import com.culturecloud.model.bean.activity.CmsActivityOrder;
import com.culturecloud.model.request.pay.PayAppOrderReqVO;
import com.culturecloud.model.request.pay.PayOrderReqVO;
import com.culturecloud.service.BaseService;
import com.culturecloud.util.pay.PayConfig;
import com.culturecloud.util.pay.PayUtils;
import com.culturecloud.util.pay.ResultPayBean;
import com.culturecloud.util.pay.WxAPPPayConfig;
import com.culturecloud.util.pay.WxPayConfig;
import com.culturecloud.utils.pay.CreateCDATA;
import com.culturecloud.utils.pay.MD5;
import com.culturecloud.utils.pay.WeixinPayUtil;

import scala.math.BigDecimal;

@Component
@Path("/pay")
public class WxPayResource {

	@Resource
	private BaseService baseService;
	
	/**
	 * 微信预单生产JS支付
	 * */
	@POST
	@Path("/wxprepay")
	@SysBusinessLog(remark="微信预单生产")
	@Produces(MediaType.APPLICATION_JSON)
	public WxPayConfig wxPrePay(PayOrderReqVO req)
	{
		List<CmsActivityOrder> orderList=baseService.find(CmsActivityOrder.class, " where ACTIVITY_ORDER_ID='"+req.getOrderId()+"' and ORDER_PAYMENT_STATUS=1");
		if(orderList!=null&&orderList.size()>0&&orderList.get(0).getOrderPayPreparId()==null)
		{
			String appkey=PayConfig.APP_KEY;
			String mch_id=PayConfig.MCH_id;
			String appid=PayConfig.APP_ID;
			String nonce_str=RandomStringUtils.random(8, "123456789");
			String out_trade_no=req.getOrderId();
			BigDecimal b1 = new BigDecimal(orderList.get(0).getOrderPrice());
			String money = b1.toString();
			String total_fee=PayUtils.getPayMoney(money);
			
			String spbill_create_ip="192.168.1.5";
			String notify_url=PayConfig.NOTIFY_URL;
			//http://139.196.196.110:8080/why/wechatPay/paycallback.do
			
			CmsActivity activity=baseService.findById(CmsActivity.class,orderList.get(0).getActivityId());
			String product_id="";
			String body="";
			if(activity!=null)
			{
				product_id="文化云支付活动";
				body=activity.getActivityName();
			}
			else
			{
				BizException.Throw("无此商品");
			}
			
			String trade_type="JSAPI";
			
			
			String paySign;
			String url="https://api.mch.weixin.qq.com/pay/unifiedorder";
			String openid=req.getOpenId();
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

				String xml=WeixinPayUtil.post(url, str.toString());

				
				JAXBContext context = JAXBContext.newInstance(ResultPayBean.class);  
		        Unmarshaller unmarshaller = context.createUnmarshaller();  
		        ResultPayBean resultPayBean = (ResultPayBean)unmarshaller.unmarshal(new StringReader(xml));  
		        String preorderId=null;
		        if(!resultPayBean.getReturn_code().equals("FAIL"))
		        {
		        	preorderId=resultPayBean.getPrepay_id();
		        	CmsActivityOrder a=baseService.findById(CmsActivityOrder.class,req.getOrderId());
		        	a.setOrderPayPreparId(preorderId);
		        	baseService.update(a," where ACTIVITY_ORDER_ID='"+req.getOrderId()+"'");
		        	
		        	return PayUtils.getWxPayConfig(preorderId);
		        }
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		else
		{
			try {
				CmsActivityOrder a=baseService.findById(CmsActivityOrder.class,req.getOrderId());
				return PayUtils.getWxPayConfig(a.getOrderPayPreparId());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return null;
	}
	
	 
	/** 微信预单生产APP支付*/
	@POST
	@Path("/wxpreapppay")
	@SysBusinessLog(remark="微信预单生产APP支付")
	@Produces(MediaType.APPLICATION_JSON)
	public WxAPPPayConfig wxPreAppPay(PayAppOrderReqVO req)
	{
		List<CmsActivityOrder> orderList=baseService.find(CmsActivityOrder.class, " where ACTIVITY_ORDER_ID='"+req.getOrderId()+"' and ORDER_PAYMENT_STATUS=1");
		if(orderList!=null&&orderList.size()>0&&(orderList.get(0).getOrderPayPreparId()==null||orderList.get(0).getOrderPayPreparId().length()>50))
		{
			String appkey=PayConfig.APPKEY;
			String mch_id=PayConfig.APPMCHid;
			String appid=PayConfig.APPID;
			String nonce_str=RandomStringUtils.random(8, "123456789");
			String out_trade_no=req.getOrderId();
			BigDecimal b1 = new BigDecimal(orderList.get(0).getOrderPrice());
			String money = b1.toString();
			String total_fee=PayUtils.getPayMoney(money);
			String spbill_create_ip="192.168.1.5";
			String notify_url=PayConfig.NOTIFY_URL;
			String trade_type="APP";
			CmsActivity activity=baseService.findById(CmsActivity.class,orderList.get(0).getActivityId());
			String product_id="";
			String body="";
			if(activity!=null)
			{
				product_id="文化云支付活动";
				body=activity.getActivityName();
			}
			else
			{
				BizException.Throw("无此商品");
			}
			String paySign;
			String url="https://api.mch.weixin.qq.com/pay/unifiedorder";
			
			try {
				Map<String, String> paras = new HashMap<String, String>();
				paras.put("appid", appid);
				paras.put("body", body);
				paras.put("mch_id", mch_id);
				paras.put("nonce_str", nonce_str);
				paras.put("notify_url", notify_url);
				paras.put("out_trade_no", out_trade_no);
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
				.append("</xml>");

				String xml=WeixinPayUtil.post(url, str.toString());
				
				JAXBContext context = JAXBContext.newInstance(ResultPayBean.class);  
		        Unmarshaller unmarshaller = context.createUnmarshaller();  
		        ResultPayBean resultPayBean = (ResultPayBean)unmarshaller.unmarshal(new StringReader(xml));  
		        String preorderId=null;
		        if(!resultPayBean.getReturn_code().equals("FAIL"))
		        {
		        	preorderId=resultPayBean.getPrepay_id();
		        	CmsActivityOrder a=baseService.findById(CmsActivityOrder.class,req.getOrderId());
		        	a.setOrderPayPreparId(preorderId+","+nonce_str);
//		        	a.setSysId(nonce_str);
		        	baseService.update(a," where ACTIVITY_ORDER_ID='"+req.getOrderId()+"'");
		        	return PayUtils.getWxAppPayConfig(preorderId,nonce_str);
		        }
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		}
		else
		{
			try {
				CmsActivityOrder a=baseService.findById(CmsActivityOrder.class,req.getOrderId());
				String[] result=a.getOrderPayPreparId().split(",");
				return PayUtils.getWxAppPayConfig(result[0],result[1]);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return null;

	}
}
