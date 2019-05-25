package com.sun3d.why.util;

import javax.servlet.http.HttpServletRequest;
import org.apache.commons.lang3.StringUtils;
public class IpUtil {
	/**
	 * 获取登录用户IP地址
	 * 
	 * @param request
	 * @return
	 */
	public static String getIpAddress(HttpServletRequest request) {
		String ip = request.getHeader("X-Forwarded-For");
		if(StringUtils.isNotBlank(ip) && !"unKnown".equalsIgnoreCase(ip)){
			    //多次反向代理后会有多个ip值，第一个ip才是真实ip
				int index = ip.indexOf(",");
				if(index != -1){
					return ip.substring(0,index);
				}else{
					 return ip;
				}
		}
		ip = request.getHeader("X-Real-IP");
		if(StringUtils.isNotBlank(ip) && !"unKnown".equalsIgnoreCase(ip)){
			  return ip;
		}
		return request.getRemoteAddr();
	}

}
