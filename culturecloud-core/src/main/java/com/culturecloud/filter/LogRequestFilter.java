/**   
* @Title: RequestFilter.java 
* @Package com.dbcsoft.shopping.service.rs.filters 
* @Description: TODO(用简洁的语句描述该文件做什么) 
* @author A18ccms A18ccms_gmail_com   
* @date 2015年2月27日 下午1:42:35 
* @version V1.0   
*/
package com.culturecloud.filter;

import java.lang.annotation.Annotation;
import java.util.LinkedHashMap;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MultivaluedMap;
import javax.ws.rs.ext.Provider;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Component;

import com.sun.jersey.spi.container.ContainerRequest;

/**************************************
 * @Description：系统业务日志请求过滤器
 * @author zhangchenxi
 * @since 2015-04-22
 * @version 1.0
 **************************************/
@Component("logFilter")
@Provider
public class LogRequestFilter extends RequestFilter {

	
	
	@Override
	public ContainerRequest filter(ContainerRequest request) {
		try {
			String version=null;
			version = request.getHeaderValue("sysVersion");
			
			if(version==null)
			{
				version=request.getHeaderValue("version");
			}
			
			String platform=null;
			platform = request.getHeaderValue("sysPlatform");
			if(platform==null)
			{
				platform=request.getHeaderValue("platform");
			}
			
			String userId = request.getHeaderValue("sysUserId");
			String userLon = request.getHeaderValue("sysUserLon");
			String userLat = request.getHeaderValue("sysUserLat");
			
			if(StringUtils.isNotBlank(version)&&StringUtils.isNotBlank(platform)){
				
				LinkedHashMap<String,String> object = request.getEntity(LinkedHashMap.class);
				
				object.put("sysVersion", version);
				object.put("sysPlatform", platform);
				object.put("sysUserId", userId);
				object.put("sysUserLon", userLon);
				object.put("sysUserLat", userLat);
				
				MultivaluedMap map=request.getRequestHeaders();
				
				request.setEntity(LinkedHashMap.class ,LinkedHashMap.class, 
						new Annotation[0], request.getMediaType(), map, object);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return request;
	}


	

}
