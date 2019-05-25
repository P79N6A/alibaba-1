package com.culturecloud.service.local.ticketmachine;

import com.alibaba.fastjson.JSONObject;
import com.culturecloud.model.bean.activity.CmsActivityOrder;

public interface TicketMachineService {

	public JSONObject getTicketInfoByOrderValidateCode(String orderValidateCode);
	
	public JSONObject getTicketInfoByOrderIdentityCard(String orderIdentityCard);
	
	public JSONObject checkTicketByOrderValidateCode(String orderValidateCode) throws Exception;
	
	String addTicketActivityOrder(CmsActivityOrder cmsActivityOrder,String seatId);

	public JSONObject getValidateCodeByOrderId(String activityOrderId);
	
}
