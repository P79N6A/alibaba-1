package com.sun3d.why.webservice.api.util;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;



/*
**记录当前逻辑的执行时间
**@author lijing
**@version 1.0 2015年8月18日 上午11:13:33
*/
public class TimeCounter {
	private static final Log logger=LogFactory.getLog(TimeCounter.class);
	
	private static ThreadLocal threadMap=new ThreadLocal();
	
	public static void logTime(String key,boolean isStart,Class cls){
		if(!logger.isDebugEnabled()) return;
		Map timeMap=(Map) threadMap.get();
		if(timeMap==null){
			timeMap =new HashMap();
			threadMap.set(timeMap);
		}
		String mapKey=cls.getName()+":"+key;
		Date curDate=new Date();
		if(isStart){
			timeMap.put(mapKey, curDate);
		}
		else{
			Date lastDate=(Date) timeMap.get(mapKey);
			if(lastDate!=null){
				timeMap.remove(mapKey);
				StringBuffer logInfo=new StringBuffer("======开始");
				logInfo.append(lastDate).append(",结束：").append(curDate);
				logInfo.append("间隔：").append(curDate.getTime()-lastDate.getTime());
				logInfo.append(" ,在:").append(cls.getName());
				logger.debug(logInfo);
			}
		}
	}
}
