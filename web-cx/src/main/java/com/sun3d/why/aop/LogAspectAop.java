package com.sun3d.why.aop;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.sun3d.why.annotation.SysBusinessLog;
import com.sun3d.why.kakfa.ProducerLog;
import com.sun3d.why.model.CmsTerminalUser;

@Aspect
@Component
public class LogAspectAop {
	

	@Around("execution(* com.sun3d.why.controller.wechat.*.*(..)) ||"
			+ " execution(* com.sun3d.why.webservice.controller.*.*(..))")
	public Object CreateLog(ProceedingJoinPoint joinPoint) {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes())
				.getRequest();

		Object obj = null;
		String classFullName = null;
		String methodName = null;
		String log = null;
		long startTime;
		long executeTime = 0;
		String remark = null;
		String operation = null;
		String version = null;
		String platform = null;
		String userLon = null;
		String userLat = null;
		String userId = null;

		userLon = request.getHeader("sysUserLon");
		userLat = request.getHeader("sysUserLat");

		version = request.getHeader("version");

		if (!StringUtils.isNotBlank(version)) {
			version = request.getHeader("sysVersion");
		}

		platform = request.getHeader("platform");

		if (!StringUtils.isNotBlank(platform)) {
			platform = request.getHeader("sysPlatform");
		}
		
		
		

		CmsTerminalUser terminalUser = (CmsTerminalUser) request.getSession().getAttribute("terminalUser");
		if (terminalUser != null) {
			if (terminalUser.getUserId() != null) {
				userId = terminalUser.getUserId();
			}
		}

		if (terminalUser == null) {
			userId = request.getHeader("sysUserId");
		}

		try {

			String param = this.getRequestParams(request);
			classFullName = joinPoint.getTarget().getClass().getName();
			MethodSignature ms = (MethodSignature) joinPoint.getSignature();
			methodName = ms.getMethod().getName();
			SysBusinessLog sysBusinessLog = ms.getMethod().getAnnotation(SysBusinessLog.class);

			if (sysBusinessLog != null) {
				if (sysBusinessLog.remark() != null) {
					remark = sysBusinessLog.remark();
				}
				if (sysBusinessLog.operation() != null) {
					operation = sysBusinessLog.operation().toString();
				}

			} else {
				remark = "该方法没有定义系统日志，请联系管理员......";
				operation = "该方法没有定义运营功能......";
			}

			startTime = System.currentTimeMillis();
			obj = joinPoint.proceed();

			executeTime = System.currentTimeMillis() - startTime;
			SystemLogVO sysLog = new SystemLogVO();
			sysLog.setUserLon(userLon);
			sysLog.setUserLat(userLat);
			sysLog.setClassFullName(classFullName);
			sysLog.setCreateTime(this.getDateStr(new Date()));
			sysLog.setExecuteTime(String.valueOf(executeTime));
			sysLog.setLogRemark(remark);
			sysLog.setMethodName(methodName);
			sysLog.setParams(param);
			sysLog.setOperation(operation);
			sysLog.setUserId(userId);

			if (version != null && !version.trim().equals("")) {
				sysLog.setVersion(version);
			}
			if (platform != null && !platform.trim().equals("")) {
				sysLog.setSystemTemplate(platform);
			}

			String result = classFullName.substring(25, 31);
			if (result.equals("wechat")) {
				sysLog.setSystemTemplate("h5");
			}
			
			if(methodName.equals("appActivityOrder"))
			{
				if(platform.equals("android"))
				{
					if(!version.equals("3.7.0"))
					{
						
						new Exception();
					}
				}
			}
			

			// sysLog.setResponse(paramResponse);
			log = ObjectToJson.ObjectToJsonString(sysLog);
			
			if(com.sun3d.why.kakfa.PpsConfig.getString("logIsOpen").equals("1"))
			{
				ProducerLog.sendlog(log);
			}

		} catch (Throwable e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return obj;
	}
     
	
	public String getDateStr(Date date) {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		return formatter.format(date);
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
