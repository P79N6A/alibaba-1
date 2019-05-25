package com.sun3d.why.controller.wechat;

import java.io.IOException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.culturecloud.model.request.pay.PayOrderReqVO;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.util.BindWS;
import com.sun3d.why.util.CallUtils;
import com.sun3d.why.util.Constant;
import com.sun3d.why.webservice.api.util.HttpResponseText;

@Controller
@RequestMapping("/wechatPay")
public class WechatPayController {

	@Autowired
	private CacheService cacheService;
	@Autowired
	private StaticServer staticServer;
	
	@RequestMapping(value = "/wxPayInfo")
	public String wxPayInfo(HttpServletResponse response,PayOrderReqVO vo) throws IOException{
		
		HttpResponseText res = CallUtils.callUrlHttpPost(
				staticServer.getPlatformDataUrl() + "pay/wxprepay", vo);
		
		response.getWriter().write(res.getData());
		response.getWriter().flush();
		response.getWriter().close();
		return null;
		
	}

	@RequestMapping("/index")
	public String index(HttpServletRequest request,String activityOrderId,String openid){
		
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		sign.put("appId", Constant.WX_APP_ID);
		request.setAttribute("sign", sign);
		request.setAttribute("activityOrderId", activityOrderId);
		request.setAttribute("openId", openid);
		
		return "wechat/pay/index";	
	}
	
	@RequestMapping("/wait")
	public String wait(HttpServletRequest request,String activityOrderId){
		
		return "wechat/pay/wait";	
	}
	
	/**@RequestMapping(value = "/index")
	public String index(String prepay_id,String nonceStr,
			HttpServletRequest request) throws UnsupportedEncodingException {
		
		
		String appId="wx847fffbbedaf4065";
		
		String appkey="26bbc861d4d7bd467bf4de6a277dbe74";
		
		// 微信权限验证配置
		String url = BindWS.getUrl(request);
		Map<String, String> sign = BindWS.sign(url, cacheService);
		sign.put("appId", appId);
		request.setAttribute("sign", sign);
		
		String timestamp=sign.get("timestamp");
		
		 Map<String, String> paras = new HashMap<String, String>(); 
		 paras.put("appid", appId); 
		 paras.put("timeStamp", timestamp); 
		 paras.put("noncestr", nonceStr); 
		 paras.put("package", "prepay_id="+prepay_id); 
		 paras.put("appkey", appkey); 
		 
		 String string1 = WeixinPayUtil.createSign(paras, false); 
		 String paySign = DigestUtils.md5Hex(string1); 
		
		request.setAttribute("prepay_id", prepay_id);
		request.setAttribute("appId", appId);
		request.setAttribute("nonceStr", nonceStr);
		request.setAttribute("signType", "MD5");
		request.setAttribute("paySign", paySign);
		
		return "wechat/pay/index";
	}*/
}
