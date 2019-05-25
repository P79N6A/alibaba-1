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

import com.sun3d.why.kakfa.PpsConfig;
import com.sun3d.why.kakfa.ProducerLog;

@Aspect
@Component
public class PubCityCardAop {

	
	
	@After("execution(* com.sun3d.why.controller.wechat.WechatFunctionController.addCityImg*(..))")
	public void sendCityCardMessage(JoinPoint joinPoint)
	{
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes())
				.getRequest();
		String param = RequestParamsUtil.getRequestParams(request);
		System.out.println("城市名片==="+param);
		if(PpsConfig.getString("areaIsOpen").equals("1"))
		{
			ProducerLog.sendwhgc(param+",whycsmp");
		}
		
		
	}
	
}
