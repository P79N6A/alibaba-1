package com.sun3d.why.webservice.api.util;

import java.util.Map;

/*
**
**@author lijing
**@version 1.0 2015年8月26日 下午8:28:57
*/
public class CmsApiOtherServer {
	private Map<String,String> serverIps;
	
	/*private String puDongIp;
	private String jingAnIp;
	private String jiaDingIp;
	*/
	//浦东接口调用 cancel
	public static String PUDONG_ACTIVITY_ORDER="/PuDongCulture/client/orderActivity.jspx";//活动预定
	public static String PUDONG_ACTIVITY_CANCEL_ORDER="/PuDongCulture/client/unsubscribeActivity.jspx";//活动取消
	public static String PUDONG_VENUE_ORDER="/PuDongCulture/client/orderVenue.jspx";//场馆活动室预定
	public static String PUDONG_VENUE_CACNEL_ORDER="/PuDongCulture/client/unsubscribeVenue.jspx";//场馆活动室取消
	
	//静安
	public static String JINAN_ACTIVITY_ORDER="/JingAnWhy/client/orderActivity.jspx";//活动预定
	public static String JINAN_ACTIVITY_CANCEL_ORDER="/JingAnWhy/client/unsubscribeActivity.jspx";//活动取消
	public static String JINAN_VENUE_ORDER="/PuDongCulture/client/orderVenue.jspx";//场馆活动室预定
	public static String JINAN_VENUE_CANCEL_ORDER="/PuDongCulture/client/unsubscribeVenue.jspx";//场馆活动室取消
	
	//嘉定
	public static String JIADING_ACTIVITY_ORDER="/api/activity/bookActivity.do";//活动预定
	public static String JIADING_ACTIVITY_ORDER_CHECK="/api/activity/checkBookActivityInfo.do";//检查活动能否预定和预定信息是否正确
	public static String JIADING_ACTIVITY_CANCEL_ORDER="/api/activity/deBookActivity.do";//活动取消
	public static String JIADING_ACTIVITY_SEAT_INFO="/api/activity/getActivitySeat.do";//活动座位信息
	public static String JIADING_ACTIVITY_TICKET_COUNT="/api/activity/getActivityTicketCount.do";//活动余票信息
	public static String JIADING_ACTIVITYS_TICKETS="/api/activity/getTicketCounts.do";//获取活动的余票数量
	public static String JIADING_VENUE_ORDER="/api/venue/bookVenue.do";//场馆活动室预定
	public static String JIADING_VENUE_CANCEL_ORDER="/api/venue/deBookVenue.do";//场馆活动室取消
	
	public CmsApiOtherServer(){
		
	}
	public CmsApiOtherServer(Map<String,String> serverIps){
		this.serverIps=serverIps;
	}
	public String getOrderUrl(String sysNo){
		String ipAddress=this.getIpAddress(sysNo);
		String url="";
		if("1".equals(sysNo)){
			url=ipAddress+CmsApiOtherServer.JIADING_ACTIVITY_ORDER;
			
		}
		else if("2".equals(sysNo)){
			url=ipAddress+CmsApiOtherServer.PUDONG_ACTIVITY_ORDER;
		}
		else if("3".equals(sysNo)){
			url=ipAddress+CmsApiOtherServer.JINAN_ACTIVITY_ORDER;
		}
		return url;
	}

	public String getActivitySeatInfoUrl(String sysNo){
		String ipAddress=this.getIpAddress(sysNo);
		String url="";
		if("1".equals(sysNo)){
			url=ipAddress+CmsApiOtherServer.JIADING_ACTIVITY_SEAT_INFO;
		}
/*		else if("2".equals(sysNo)){
			url=ipAddress+CmsApiOtherServer.PUDONG_ACTIVITY_ORDER;
		}
		else if("3".equals(sysNo)){
			url=ipAddress+CmsApiOtherServer.JINAN_ACTIVITY_ORDER;
		}*/
		return url;
	}

	public String getActivityTicketCountUrl(String sysNo){
		String ipAddress=this.getIpAddress(sysNo);
		String url="";
		if("1".equals(sysNo)){
			url=ipAddress+CmsApiOtherServer.JIADING_ACTIVITY_TICKET_COUNT;
		}
/*		else if("2".equals(sysNo)){
			url=ipAddress+CmsApiOtherServer.PUDONG_ACTIVITY_ORDER;
		}
		else if("3".equals(sysNo)){
			url=ipAddress+CmsApiOtherServer.JINAN_ACTIVITY_ORDER;
		}*/
		return url;
	}

	public String checkActivityBookUrl(String sysNo){
		String ipAddress=this.getIpAddress(sysNo);
		String url="";
		if("1".equals(sysNo)){
			url=ipAddress+CmsApiOtherServer.JIADING_ACTIVITY_ORDER_CHECK;
		}
/*		else if("2".equals(sysNo)){
			url=ipAddress+CmsApiOtherServer.PUDONG_ACTIVITY_ORDER;
		}
		else if("3".equals(sysNo)){
			url=ipAddress+CmsApiOtherServer.JINAN_ACTIVITY_ORDER;
		}*/
		return url;
	}
	
	public String getCancelOrderUrl(String sysNo){
		String ipAddress=this.getIpAddress(sysNo);
		String url="";
		if("1".equals(sysNo)){
			url=ipAddress+CmsApiOtherServer.JIADING_ACTIVITY_CANCEL_ORDER;
			
		}
		else if("2".equals(sysNo)){
			url=ipAddress+CmsApiOtherServer.PUDONG_ACTIVITY_CANCEL_ORDER;
		}
		else if("3".equals(sysNo)){
			url=ipAddress+CmsApiOtherServer.JINAN_ACTIVITY_CANCEL_ORDER;
		}
		return url;
	}



	public String getActivityTicketsUrl(String sysNo){
		String ipAddress=this.getIpAddress(sysNo);
		String url="";
		if("1".equals(sysNo)){
			url=ipAddress+CmsApiOtherServer.JIADING_ACTIVITYS_TICKETS;
		}
/*		else if("2".equals(sysNo)){
			url=ipAddress+CmsApiOtherServer.PUDONG_ACTIVITY_CANCEL_ORDER;
		}
		else if("3".equals(sysNo)){
			url=ipAddress+CmsApiOtherServer.JINAN_ACTIVITY_CANCEL_ORDER;
		}*/
		return url;
	}
	
	public String getVenueOrderUrl(String sysNo){
		String url="";
		String ipAddress=this.getIpAddress(sysNo);
		if("1".equals(sysNo)){
			url=ipAddress+CmsApiOtherServer.JIADING_VENUE_ORDER;
			
		}
		else if("2".equals(sysNo)){
			url=ipAddress+CmsApiOtherServer.PUDONG_VENUE_ORDER;
		}
		else if("3".equals(sysNo)){
			url=ipAddress+CmsApiOtherServer.JINAN_VENUE_ORDER;
		}
		return url;
	}
	
	public String getVenueCancelOrderUrl(String sysNo){
		String url="";
		String ipAddress=this.getIpAddress(sysNo);
		if("1".equals(sysNo)){
			url=ipAddress+CmsApiOtherServer.JIADING_VENUE_CANCEL_ORDER;
			
		}
		else if("2".equals(sysNo)){
			url=ipAddress+CmsApiOtherServer.PUDONG_VENUE_CACNEL_ORDER;
		}
		else if("3".equals(sysNo)){
			url=ipAddress+CmsApiOtherServer.JINAN_VENUE_CANCEL_ORDER;
		}
		return url;
	}
	public String getIpAddress(String sysNo){
		String ipAddress="";

		if("1".equals(sysNo)){
			ipAddress=this.serverIps.get("jiaDingIp");
		}
		else if("2".equals(sysNo)){
			ipAddress=this.serverIps.get("puDongIp");
		}
		else if("3".equals(sysNo)){
			ipAddress=this.serverIps.get("jingAnIp");
		}
		ipAddress=ipAddress==null?"":ipAddress;

		return ipAddress;
	}
	
	public void setServerIps(Map<String, String> serverIps) {
		this.serverIps = serverIps;
	}
	
	
	
}
