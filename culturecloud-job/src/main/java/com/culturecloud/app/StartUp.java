package com.culturecloud.app;


import com.culturecloud.server.AppContext;
import com.culturecloud.server.HttpServer;
import com.culturecloud.utils.PpsConfig;


/**
 * 应用启动入口类
* @ClassName: StartUp
* @Description: 应用启动入口类
* @author zhangchenxi
* @date 2016年06月06日 
*
 */
public class StartUp {
	/**
	 * 启动http服务
	 */
	public static void main(String[] args) {
		AppContext.INSTANCE.getAppContext();
		if(HttpServer.start(PpsConfig.getint("interface.server.port"))){
			System.out.println("http server started on port : "+PpsConfig.getint("interface.server.port"));
		}else{
			System.out.println("http server start error!!!");
		}
	}
}
