package com.sun3d.why.controller;

import java.util.HashMap;
import java.util.Map;
import java.util.TreeSet;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sun3d.why.util.SmsUtil;
import com.taobao.api.response.AlibabaAliqinFcSmsNumSendResponse;

@RequestMapping("/sendSMS")
@Controller
public class CcpSendSMSController {

	@RequestMapping("/sendSMSIndex")
	public String sendSMSIndex() {

		return "admin/sendSMS/index";

	}

	@RequestMapping("/selectTemplate")
	public String selectTemplate(@RequestParam Integer templateId,String templateName, HttpServletRequest request) {
		request.setAttribute("templateName", templateName);
		request.setAttribute("templateId", templateId);
		return "admin/sendSMS/send" + templateId;
	}

	@RequestMapping("/send")
	@ResponseBody
	public Map<String, String> send(@RequestParam Integer templateId,Integer month, String area, Integer num,Integer areaRank,Integer cityRank, String[] telephoneNumber) {

		Map<String, String> result = new HashMap<String, String>();

	
			Map<String, Object> params = new HashMap<>();

			if(month!=null)
			params.put("month", month.toString());
			
			if(StringUtils.isNotBlank(area))
			params.put("area", area);
			
			if(num!=null)
			params.put("num", num.toString());
			
			if(areaRank!=null)
				params.put("areaRank", areaRank.toString());
			
			if(cityRank!=null)
				params.put("cityRank", cityRank.toString());

			TreeSet<String> telSet = new TreeSet<>();

			for (String tel : telephoneNumber) {

				telSet.add(tel);
			}	

			for (String tel : telSet) {
				
				AlibabaAliqinFcSmsNumSendResponse  res=null;
				
				switch (templateId) {
				
				case 1:
					res=SmsUtil.sendMonthActivityZero(tel, params);
					break;
				case 2:
					res=SmsUtil.sendMonthActivityCount(tel, params);
					break;
				case 3:
					res=SmsUtil.sendMonthActivityReservationCount(tel, params);
					
					break;
				}
				
				if(res==null){
					result.put("error", "手机号码:"+tel+" 发送失败！ 失败原因：系统错误");
					return result;
				}else if(StringUtils.isNotBlank(res.getErrorCode())){
					result.put("error", "手机号码:"+tel+" 发送失败！ 失败原因："+res.getErrorCode());
					return result;
				}
					
			}

			result.put("success", "发送成功");
		

		return result;
	}

}
