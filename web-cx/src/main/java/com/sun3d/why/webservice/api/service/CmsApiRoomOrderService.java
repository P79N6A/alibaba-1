package com.sun3d.why.webservice.api.service;

import com.sun3d.why.model.CmsRoomBook;
import com.sun3d.why.model.CmsRoomOrder;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.webservice.api.model.CmsApiOrder;

/*
**
**@author lijing
**@version 1.0 2015年8月27日 下午8:23:30
*/
public interface CmsApiRoomOrderService {
	public CmsApiOrder addOrder(CmsRoomBook cmsRoomBook, CmsTerminalUser terminalUser);
	public CmsApiOrder cancelOrder(CmsRoomOrder cmsRoomOrder) throws Exception;
}
