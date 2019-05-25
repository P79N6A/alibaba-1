package com.culturecloud.server;

import java.net.InetSocketAddress;
import java.util.concurrent.Executors;

import org.jboss.netty.bootstrap.ServerBootstrap;
import org.jboss.netty.channel.socket.nio.NioServerSocketChannelFactory;

/**
 * An HTTP server that sends back the content of the received HTTP request in a
 * pretty plaintext form.
 */
public class HttpServer {

	private final int port;


	public HttpServer(int port) {
		this.port = port;
	}
	/**
	 * netty服务程序启动
	 */
	public void run() {

		// Configure the server.
		ServerBootstrap bootstrap = new ServerBootstrap(
				new NioServerSocketChannelFactory(
						Executors.newCachedThreadPool(),
						Executors.newCachedThreadPool()));

		// Set up the event pipeline factory.
		bootstrap.setPipelineFactory(new HttpServerPipelineFactory());

		// Bind and start to accept incoming connections.
		bootstrap.bind(new InetSocketAddress(port));
		
	}

	/**
	 * 应用程序启动
	 * @param port
	 * @return
	 */
	public static boolean start(int port) {

		try {
			// 初始化jersey和spring bean
			//AppContext.INSTANCE.initJerseySpring();
			
			new HttpServer(port).run();
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}

	}


}