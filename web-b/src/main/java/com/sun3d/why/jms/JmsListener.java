package com.sun3d.why.jms;


import com.sun3d.why.jms.server.ActivityBookServer;
import com.sun3d.why.jms.server.ActivityRoomBookServer;
import com.sun3d.why.service.CacheConstant;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.util.SpringContextUtil;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import java.util.Iterator;

/**
 * JMS 消息监听
 * @author yjb
 *
 */
public class JmsListener implements ServletRequestListener , ServletContextListener {

	private CacheService cacheService = null;

	private  ServletContextEvent event = null;

	private ServletRequestEvent servletRequestEvent = null;

	@Override
	public void requestDestroyed(ServletRequestEvent servletRequestEvent) {

	}

	@Override
	public void requestInitialized(ServletRequestEvent servletRequestEvent) {
		ApplicationContext context = SpringContextUtil.getContext();
		ServletRequest servletRequest = servletRequestEvent.getServletRequest();
		HttpServletRequest request = (HttpServletRequest) servletRequest;
		String URI = request.getRequestURI();
//		ServletContextEvent event1 = (ServletContextEvent) servletRequestEvent.getServletContext();
		//标记活动是否已经监听  只监听标记为未标记的queens
		if (URI.contains("saveActivityOder") || URI.contains("appActivityBook")){
			cacheService = (CacheService) context.getBean("cacheService");
			//得到 内存中的set
			Iterator iterator = cacheService.queryQueueName("activityQueues");
			while (iterator != null && iterator.hasNext()) {
				//value值  由 activityId + "_"  + 加监听状态组成  Y代表已经被监听  N代表未被监听
				String value = (String) iterator.next();

				String [] info = value.split("_");
				if (info != null && info.length == 2) {
					String activityId = info[0];
					String status = info[1];
					//有未标记状态时启动监听
//					if ("N".equals(status)) {
//					//	contextInitialized(event);
//					}
					if ("N".equals(status)) {
						new ActivityBookServer(event, activityId);
						cacheService.saveQueueName("activityQueues", activityId + "_Y");
						cacheService.deleteSetComment("activityQueues",activityId + "_N");
					}
				}
			}
		} 	else if (URI.contains("roomBook") || URI.contains("roomOrderCheck")){
			cacheService = (CacheService) context.getBean("cacheService");
			//得到 内存中的set
			Iterator iterator = cacheService.queryQueueName(CacheConstant.ACTIVITY_ROOM_QUEUES);
			while (iterator != null && iterator.hasNext()) {
				//value值  由 activityId + "_"  + 加监听状态组成  Y代表已经被监听  N代表未被监听
				String value = (String) iterator.next();
				String [] info = value.split("_");
				if (info != null && info.length == 2) {
					String roomId = info[0];
					String status = info[1];
					//有未标记状态时启动监听
					if ("N".equals(status)) {
						//contextInitialized(event);
						new ActivityRoomBookServer(event, roomId);
						cacheService.saveQueueName(CacheConstant.ACTIVITY_ROOM_QUEUES, roomId + "_Y");
						cacheService.deleteSetComment(CacheConstant.ACTIVITY_ROOM_QUEUES,roomId + "_N");
					}
				}
			}
		}
	}

	@Override
	public void contextInitialized(ServletContextEvent event) {
		this.event = event;
		WebApplicationContext context = WebApplicationContextUtils.getRequiredWebApplicationContext(event.getServletContext());
		cacheService = (CacheService) context.getBean("cacheService");
		//得到 内存中的set
		Iterator iterator = cacheService.queryQueueName("activityQueues");
		while (iterator != null && iterator.hasNext()) {
			//value值  由 activityId + "_"  + 加监听状态组成  Y代表已经被监听  N代表未被监听
			String value = (String) iterator.next();
			String [] info = value.split("_");
			if (info != null && info.length == 2) {
				String activityId = info[0];
				String status = info[1];
//				if ("N".equals(status)) {
					new ActivityBookServer(event, activityId);
					cacheService.saveQueueName("activityQueues", activityId + "_Y");
					cacheService.deleteSetComment("activityQueues",activityId + "_N");
//				}
			}
		}

		/**
		得到活动室所有的队列
		Iterator iteratorRoom = cacheService.queryQueueName(CacheConstant.ACTIVITY_ROOM_QUEUES);
		while (iteratorRoom != null && iteratorRoom.hasNext()) {
			//value值  由 activityId + "_"  + 加监听状态组成  Y代表已经被监听  N代表未被监听
			String value = (String) iteratorRoom.next();
			String [] info = value.split("_");
			if (info != null && info.length == 2) {
				String roomId = info[0];
				String status = info[1];
			//	if ("N".equals(status)) {
					new ActivityRoomBookServer(event, roomId);
					cacheService.saveQueueName(CacheConstant.ACTIVITY_ROOM_QUEUES, roomId + "_Y");
					cacheService.deleteSetComment(CacheConstant.ACTIVITY_ROOM_QUEUES,roomId + "_N");
				//}
			}
		}**/
	}

	@Override
	public void contextDestroyed(ServletContextEvent event) {
/*
		//服务关闭时全部标记为 未监听状态
		WebApplicationContext context = WebApplicationContextUtils.getRequiredWebApplicationContext(event.getServletContext());
		cacheService = (CacheService) context.getBean("cacheService");
		//得到 内存中的set
		Iterator iterator = cacheService.queryQueueName("activityQueues");
		while (iterator != null && iterator.hasNext()) {
			//value值  由 activityId + "_"  + 加监听状态组成  Y代表已经被监听  N代表未被监听
			String value = (String) iterator.next();
			String activityId = value.split("_")[0];
			String statue = value.split("_")[1];
			if ("Y".equals(statue)) {
				cacheService.deleteSetComment("activityQueues", activityId + "_Y");
			}
			cacheService.saveQueueName("activityQueues", activityId + "_N");
		}




		//销毁活动室所有的队列
		Iterator iteratorRoom = cacheService.queryQueueName(CacheConstant.ACTIVITY_ROOM_QUEUES);
		while (iteratorRoom != null && iteratorRoom.hasNext()) {
			//value值  由 activityId + "_"  + 加监听状态组成  Y代表已经被监听  N代表未被监听
			String value = (String) iteratorRoom.next();
			String roomId = value.split("_")[0];
			cacheService.saveQueueName(CacheConstant.ACTIVITY_ROOM_QUEUES, roomId + "_N");
			cacheService.deleteSetComment(CacheConstant.ACTIVITY_ROOM_QUEUES,roomId + "_Y");
		}
		*/
	}

}
