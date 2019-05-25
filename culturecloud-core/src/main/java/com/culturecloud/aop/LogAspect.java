/**   
 * @Title: LogAspect.java 
 * @Package com.dbcsoft.shopping.core.aop 
 * @Description: 系统业务日志服务
 * @author Arthur  
 * @date 2015年2月27日 上午10:37:47 
 * @version V1.2  
 */
package com.culturecloud.aop;

import java.util.Date;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.stereotype.Component;

import com.culturecloud.annotations.SysBusinessLog;
import com.culturecloud.bean.BaseRequest;
import com.culturecloud.bean.SystemLogVO;
import com.culturecloud.coreutils.DateUtil;
import com.culturecloud.coreutils.ObjectToJson;
import com.culturecloud.exception.BizException;
import com.culturecloud.filter.LogRequestFilter;
import com.culturecloud.kafka.PpsConfig;
import com.culturecloud.kafka.ProducerLog;
import com.culturecloud.service.BaseService;
import com.sdicons.json.mapper.JSONMapper;
import com.sdicons.json.model.JSONValue;




/**************************************
 * @Description：系统业务日志切面类
 * @author zhangchenxi
 * @since 2015-04-22
 * @version 1.0
 **************************************/
@Component
@Aspect
public class LogAspect {
	private static final Logger log = Logger.getLogger(LogAspect.class);

	@Resource
	private BaseService businessLogService;

	@Around("execution(* com.culturecloud.*.rs.*..*.*(..)) && !"
			+ "execution(* com.culturecloud.*.rs.openplatform..*.*(..))")
	public Object getGiveIntegralList(ProceedingJoinPoint joinPoint) {

		Object obj = null;

		String param=null;
		String classFullName=null;
		String methodName=null;
		String paramResponse=null;
		String log=null;
		String version=null;
		String platform=null;
		String userId = null;
		String userLon = null;
		String userLat = null;
		
		try {
			if (joinPoint.getArgs()[0] instanceof BaseRequest) {
				
				version=((BaseRequest) joinPoint.getArgs()[0]).getSysVersion();
				
				platform=((BaseRequest) joinPoint.getArgs()[0]).getSysPlatform();
				
				userId=((BaseRequest) joinPoint.getArgs()[0]).getSysUserId();
				
				userLon=((BaseRequest) joinPoint.getArgs()[0]).getSysUserLon();
				
				userLat=((BaseRequest) joinPoint.getArgs()[0]).getSysUserLat();
				
			}
		} catch (Exception e) {
			BizException.Throw("来源没有注明");
		}
		
		try {
			JSONValue jsonValue=JSONMapper.toJSON(joinPoint.getArgs()[0]);
			param = jsonValue.render(true);
			classFullName = joinPoint.getTarget().getClass().getName();
			MethodSignature ms = (MethodSignature) joinPoint.getSignature();
			methodName = ms.getMethod().getName();
			long startTime;
			long executeTime;
			
			startTime = System.currentTimeMillis();

			obj = joinPoint.proceed();
			
			executeTime = System.currentTimeMillis() - startTime;

			SysBusinessLog sysBusinessLog = ms.getMethod().getAnnotation(
					SysBusinessLog.class);
			String remark = null;
			if (sysBusinessLog != null)
				remark = sysBusinessLog.remark();
			else
				remark = "该方法没有定义系统日志，请联系管理员......";
			
			paramResponse = ObjectToJson.ObjectToJsonString(obj);
			
			SystemLogVO sysLog=new SystemLogVO();
			sysLog.setClassFullName(classFullName);
			sysLog.setCreateTime(DateUtil.getDateStr(new Date()));
			sysLog.setExecuteTime(String.valueOf(executeTime));
			sysLog.setLogRemark(remark);
			sysLog.setMethodName(methodName);
			sysLog.setParams(param);
			sysLog.setSystemTemplate(platform);
			sysLog.setResponse(paramResponse);
			sysLog.setVersion(version);
			sysLog.setUserId(userId);
			sysLog.setUserLon(userLon);
			sysLog.setUserLat(userLat);
			log=ObjectToJson.ObjectToJsonString(sysLog);
			
			if(PpsConfig.getString("logIsOpen").equals("1"))
			{
				ProducerLog.sendlog(log);
			}
			
			

		} catch (Throwable e) {
			// TODO Auto-generated catch block
			SystemLogVO sysLog=new SystemLogVO();
			sysLog.setClassFullName(classFullName);
			sysLog.setCreateTime(DateUtil.getDateStr(new Date()));
			sysLog.setExecuteTime("10000");
			sysLog.setLogRemark("BizException==="+e.getMessage());
			sysLog.setMethodName(methodName);
			sysLog.setParams(param);
			sysLog.setSystemTemplate(platform);
			sysLog.setResponse(paramResponse);
			sysLog.setVersion(version);
			sysLog.setUserId(userId);
			sysLog.setUserLon(userLon);
			sysLog.setUserLat(userLat);
			log=ObjectToJson.ObjectToJsonString(sysLog);

			if(PpsConfig.getString("logIsOpen").equals("1"))
			{
				ProducerLog.sendlog(log);
			}
			

			if(e instanceof BizException){
				throw (BizException)e;
			}else {
				BizException.Throw(e.getMessage());
			}
			

		}
		return obj;
	}
	
}
