package com.culturecloud.app;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.culturecloud.server.AppContext;
import com.culturecloud.server.HttpServer;
import com.culturecloud.utils.PpsConfig;

/**
 * 应用启动入口类
* @ClassName: StartUp
* @Description: 应用启动入口类
* @author jpwen
* @date 2014年10月10日 上午11:39:37
*
 */
public class StartUp {
	private static Logger log = LoggerFactory.getLogger(StartUp.class);
	/**
	 * 启动http服务
	 */
	public static void main(String[] args) {
		AppContext.getInstance().getAppContext();
		if(HttpServer.start(PpsConfig.getint("interface.server.port"))){
			log.info("http server started on port : "+PpsConfig.getint("interface.server.port"));
		}else{
			log.error("http server start error!!!");
		}
	}
}
