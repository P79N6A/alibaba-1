package com.sun3d.why.aop;

import java.lang.reflect.Field;
import java.lang.reflect.Method;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.stereotype.Component;

import com.culturecloud.bean.BaseRequest;
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
			//字段非空处理
			String[] a= signature.getParameterNames();//获取参数名称
			Object[] obj = joinPoint.getArgs();//获取参数数值
			for(int i = 0; i < obj.length; i++){
				if(obj[i]==null){
					switch (a[i]){
						case ("pageIndex"):
							obj[i]="0";
							break;
						case ("pageNum"):
							obj[i]="20";
							break;
						default:
					}
				}
			}
			EmojiInspect emojiInspect = method.getAnnotation(EmojiInspect.class);
			if (emojiInspect != null) {
				Object[] args = joinPoint.getArgs();

				for (int i = 0; i < args.length; i++) {
					Object o = args[i];
					if(o==null)
						continue;
					if (o instanceof String) {

						String param = (String) o;

						if (StringUtils.isNotBlank(param)) {
							args[i] = EmojiFilter.filterEmoji(param);
						}
					}
					else if (o instanceof BaseRequest || (o.getClass().getPackage()!=null && o.getClass().getPackage().getName().indexOf("com.sun3d.why.model") != -1))
					{
						 Field[] fs =o.getClass().getDeclaredFields();

						 for (Field field : fs) {
							 
							 field.setAccessible(true);
							 
							 Object value=field.get(o);
							 
							 if(value!=null&&field.getType()==String.class){
								 
								 field.set(o, EmojiFilter.filterEmoji(value.toString()));
							 }
						}
					}
				}
				result=joinPoint.proceed(args);
				return result;
			}
			
			result=joinPoint.proceed(obj);
			
		} catch (Throwable e) {
			e.printStackTrace();
		}
		
		return result;

	}
}
