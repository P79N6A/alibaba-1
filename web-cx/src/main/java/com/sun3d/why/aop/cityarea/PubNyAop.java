package com.sun3d.why.aop.cityarea;

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
public class PubNyAop {

	
	@After("execution(* com.sun3d.why.controller.wechat.WechatStaticController.addNyImg*(..))")
	public void sendNyMessage(JoinPoint joinPoint)
	{
//		System.out.println("111111111111111111111111111");
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes())
				.getRequest();
		String param = RequestParamsUtil.getRequestParams(request);
		System.out.println("文化过新年==="+param);
		if(PpsConfig.getString("areaIsOpen").equals("1"))
		{
			ProducerLog.sendwhgc(param+",whyny");
		}
		
		
	}
}
