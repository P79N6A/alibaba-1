package com.sun3d.why.aop;

import java.lang.reflect.Method;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.stereotype.Component;

import com.sun3d.why.annotation.EmojiInspect;
import com.sun3d.why.util.EmojiFilter;

/**
 * app请求controller aop拦截器
 * 
 * @author zhangshun
 *
 */
@Aspect
@Component
public class AppControllerAop {
	
	private  final Logger log = Logger.getLogger(AppControllerAop.class);

	@Around("execution(* com.sun3d.why.controller.wechat.*.*(..)) ||"
			+ " execution(* com.sun3d.why.webservice.controller.*.*(..))")
	public Object around(ProceedingJoinPoint joinPoint) {
		
		Object result=null;
		
		try {
			MethodSignature signature = (MethodSignature) joinPoint.getSignature();
			Method method = signature.getMethod();

			EmojiInspect emojiInspect = method.getAnnotation(EmojiInspect.class);

			if (emojiInspect != null) {
				Object[] args = joinPoint.getArgs();

				for (int i = 0; i < args.length; i++) {
					Object o = args[i];

					if (o instanceof String) {

						String param = (String) o;

						if (StringUtils.isNotBlank(param)) {
							args[i] = EmojiFilter.filterEmoji(param);
						}
					}
				}
				result=joinPoint.proceed(args);
				return result;
			}
			
			result=joinPoint.proceed();
			
		} catch (Throwable e) {
			e.printStackTrace();
		}
		
		return result;

	}
}
