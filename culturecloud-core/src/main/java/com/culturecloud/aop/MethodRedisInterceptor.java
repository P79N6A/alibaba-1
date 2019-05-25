package com.culturecloud.aop;

import java.io.Serializable;

import org.aopalliance.intercept.MethodInterceptor;
import org.aopalliance.intercept.MethodInvocation;
import org.springframework.beans.factory.InitializingBean;

import com.culturecloud.redis.RedisDAO;
import com.sdicons.json.mapper.JSONMapper;
import com.sdicons.json.model.JSONValue;

public class MethodRedisInterceptor implements MethodInterceptor,InitializingBean{

	
	private RedisDAO redisDao;
	
	
	public RedisDAO getRedisDao() {
		return redisDao;
	}

	public void setRedisDao(RedisDAO redisDao) {
		this.redisDao = redisDao;
	}

	@Override
	public Object invoke(MethodInvocation invocation) throws Throwable {
		// TODO Auto-generated method stub
		
		String targetName = invocation.getThis().getClass().getName();
		String methodName = invocation.getMethod().getName();
		//Object[] arguments = invocation.getArguments();
		JSONValue jsonValue=JSONMapper.toJSON(invocation.getArguments()[0]);
		String param = jsonValue.render(true);
		Object result = null;
		String cacheKey = getCacheKey(targetName, methodName, param);
//		System.out.println("cacheKey==========="+cacheKey);
//		result=invocation.proceed();
		synchronized(this)
		{
			result = redisDao.getData(cacheKey);//通过key获取redis缓存数据
			if(result==null)
			{
				result=invocation.proceed();
				redisDao.save(cacheKey, (Serializable) result);
				return result;
			}
		}
		return result;
	}

	@Override
	public void afterPropertiesSet() throws Exception {
		// TODO Auto-generated method stub
		
	}

	private String getCacheKey(String targetName, String methodName,
			String arguments) {
		StringBuffer sb = new StringBuffer();
		sb.append(targetName).append(".").append(methodName).append(".").append(arguments);
//		if ((arguments != null) && (arguments.length != 0)) {
//			for (int i = 0; i < arguments.length; i++) {
//				sb.append(".").append(arguments[i].toString());
//			}
//		}
		return sb.toString();
	}
	
}
