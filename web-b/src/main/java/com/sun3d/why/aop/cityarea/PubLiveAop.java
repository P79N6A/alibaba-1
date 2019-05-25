package com.sun3d.why.aop.cityarea;

import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.sun3d.why.kafkab.PpsConfig;
import com.sun3d.why.kafkab.ProducerLog;

@Aspect
@Component
public class PubLiveAop {

	/*@After("execution(* com.sun3d.why.controller.CcpLiveController.saveLiveActivity*(..)) ")*/
	public void sendLiveMessage(JoinPoint joinPoint) {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes())
				.getRequest();
		String param = this.getRequestParams(request);
		//liveStatus:1,liveActivityId:bfebcf220bbf42aba29d14d09884350f
		System.out.println(param);
		if (PpsConfig.getString("areaIsOpen").equals("1")&&param.indexOf("liveCheck")!=-1) {
			System.out.println("aop添加活动");
			ProducerLog.sendwhgc(param + ",whylive");
		}
	}

	private String getRequestParams(HttpServletRequest request) {
		Map map = new HashMap();
		Enumeration paramNames = request.getParameterNames();
		while (paramNames.hasMoreElements()) {
			String paramName = (String) paramNames.nextElement();

			String[] paramValues = request.getParameterValues(paramName);
			if (paramValues.length == 1) {
				String paramValue = paramValues[0];
				if (paramValue.length() != 0) {
					map.put(paramName, paramValue);
				}
			}
		}
		String str = "";
		Set<Map.Entry<String, String>> set = map.entrySet();

		for (Map.Entry entry : set) {
			str += entry.getKey() + ":" + entry.getValue() + ",";
			// System.out.println(entry.getKey() + ":" + entry.getValue());
		}
		if (str != null && str.length() > 0) {
			str = str.substring(0, str.length() - 1);

		}
		return str;
	}
}
