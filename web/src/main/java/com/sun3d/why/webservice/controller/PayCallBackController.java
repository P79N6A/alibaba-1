package com.sun3d.why.webservice.controller;

import java.io.IOException;
import java.io.InputStream;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.sun3d.why.model.CmsActivityOrder;
import com.sun3d.why.service.CmsActivityOrderService;
import com.sun3d.why.util.SmsUtil;

public class PayCallBackController extends HttpServlet{

	private static final long serialVersionUID = 7516481916010198161L;
	
	@Override
	protected void service(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		
		ApplicationContext ctx = WebApplicationContextUtils.getWebApplicationContext(this.getServletContext());
		
		SmsUtil SmsUtil=(com.sun3d.why.util.SmsUtil) ctx.getBean("SmsUtil");
		
		Map<String, String> map = null;
		
		try {
			map = this.parseXml(req);
			

			String return_code=String.valueOf(map.get("return_code"));
			String result_code=String.valueOf(map.get("result_code"));
			String out_trade_no=String.valueOf(map.get("out_trade_no"));
			String transaction_id=String.valueOf(map.get("transaction_id"));
			
			// 成功
			if("SUCCESS".equals(return_code)){
				
				String activityOrderId=out_trade_no;
				
				System.out.println("**********订单号："+activityOrderId+" 支付回调成功！*************");
				
				CmsActivityOrderService cmsActivityOrderService=(CmsActivityOrderService) ctx.getBean("cmsActivityOrderService");
				CmsActivityOrder cmsActivityOrder=cmsActivityOrderService.queryCmsActivityOrderById(activityOrderId);
				
				Integer priceType= cmsActivityOrder.getPriceType();
				
				String pType="张";
				
				if(priceType!=null&&priceType==3){
					
					pType="份";
				}
				
				Short orderPaymentStatus=cmsActivityOrder.getOrderPaymentStatus();
				// 修改支付状态
				if(orderPaymentStatus!=null&&orderPaymentStatus==1){
					
					cmsActivityOrder.setOrderPaymentStatus((short)2);
					cmsActivityOrder.setOrderPayTime(new Date());
					// 微信支付
					cmsActivityOrder.setOrderPayType((short)2);
					
					int i=cmsActivityOrderService.editActivityOrder(cmsActivityOrder);
					
					if(i>0){
						System.out.println("**********订单号："+activityOrderId+" 修改支付状态成！*************");
						
						final Map<String, Object> tempMap1 = new HashMap<String, Object>();
		            	
		            	   String[] eventDateTime = cmsActivityOrder.getEventDateTime().split(" ");
		                   String[] data = eventDateTime[0].split("-");
		                   tempMap1.put("userName", cmsActivityOrder.getOrderName());
		                   tempMap1.put("activityName", data[1] + "月" + data[2] + "日" + cmsActivityOrder.getActivityName());
		                   tempMap1.put("ticketCount", cmsActivityOrder.getOrderVotes().toString()+pType);
		                   String ticketCode = cmsActivityOrder.getOrderValidateCode();
						tempMap1.put("time", eventDateTime[1]);
		                   //发送验证码
		                   tempMap1.put("ticketCode", ticketCode );
		            	
		                SmsUtil.payOrderSuccess(cmsActivityOrder.getOrderPhoneNo(), tempMap1);
					}
						
					
				}
			}
			
//			System.out.println(map.get("return_code") + "wxxwwxxwxwwwwxwxwxw");//SUCCESS
//			System.out.println(map.get("result_code") + "wxxwwxxwxwwwwxwxwxw");
//			System.out.println(map.get("out_trade_no") + "wxxwwxxwxwwwwxwxwxw");//订单ID
//			System.out.println(map.get("transaction_id") + "wxxwwxxwxwwwwxwxwxw");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
//	@Override
//    protected void service(HttpServletRequest req, HttpServletResponse resp) {
//            
//		try {
//			System.out.println("1111111111111");
//			Map<String, String> map =this.parseXml(req);
//			System.out.println(map.get("return_code") + "wxxwwxxwxwwwwxwxwxw");
//			System.out.println(map.get("result_code") + "wxxwwxxwxwwwwxwxwxw");
//			System.out.println(map.get("out_trade_no") + "wxxwwxxwxwwwwxwxwxw");
//			System.out.println(map.get("transaction_id") + "wxxwwxxwxwwwwxwxwxw");
//			
//		} catch (Exception e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
//    }
	
	public static Map<String, String> parseXml(HttpServletRequest request)
			throws Exception {
		// 解析结果存储在HashMap
		Map<String, String> map = new HashMap<String, String>();
		InputStream inputStream = request.getInputStream();
		// 读取输入流
		SAXReader reader = new SAXReader();
		Document document = reader.read(inputStream);
		// 得到xml根元素
		Element root = document.getRootElement();
		// 得到根元素的所有子节点
		List<Element> elementList = root.elements();

		// 遍历所有子节点
		for (Element e : elementList)
			map.put(e.getName(), e.getText());

		// 释放资源
		inputStream.close();
		inputStream = null;

		return map;
	}
}
