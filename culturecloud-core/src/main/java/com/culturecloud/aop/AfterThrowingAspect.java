package com.culturecloud.aop;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.culturecloud.exception.BizException;


/**
 * 异常处理切面业务增强服务
 * 
 * @author zhangchenxi
 * @since 2015-04-22
 * @version 1.0
 * 
 */
@Component
@Aspect
@Scope("prototype")
public class AfterThrowingAspect {
	
          
	@Around("execution(* com.culturecloud.*.rs.*..*.*(..))")
	public Object doThrowException(ProceedingJoinPoint pjp) {
		try {
			return pjp.proceed();
		} catch (Throwable e) {
			if(e instanceof BizException){
				throw (BizException)e;
			}else {
				BizException.Throw(ExceptionDisplay.display.getValue(), e.getMessage());
			}
			
			return null;
		}
		
	}
}
