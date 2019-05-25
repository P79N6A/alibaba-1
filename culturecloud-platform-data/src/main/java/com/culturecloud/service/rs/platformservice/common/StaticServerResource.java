package com.culturecloud.service.rs.platformservice.common;

import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

import org.springframework.stereotype.Component;

import com.culturecloud.annotations.SysBusinessLog;
import com.culturecloud.bean.BaseRequest;
import com.culturecloud.kafka.PpsConfig;

@Component
@Path("/staticServer")
public class StaticServerResource {

	
	@POST
	@Path("/path")
	@SysBusinessLog(remark="获取配置服务器图片地址")
	@Produces(MediaType.APPLICATION_JSON)
	public String path(BaseRequest request){
		
		 String staticServerUrl=PpsConfig.getString("staticServerUrl");
		
		return staticServerUrl;
		
	}
	
}
