package com.culturecloud.job;

import java.util.List;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.culturecloud.dao.activity.CmsActivityOrderMapper;
import com.culturecloud.dao.common.CmsTerminalUserMapper;
import com.culturecloud.dao.dto.activity.CmsCancelOrderDto;
import com.culturecloud.util.HttpRequest;
import com.culturecloud.util.PpsConfig;


@Component("orderCancelTaskJob")
public class OrderCancelTaskJob {

	@Autowired
	private CmsActivityOrderMapper cmsActivityOrderMapper;
	
	@Autowired
	private CmsTerminalUserMapper cmsTerminalUserMapper;
	
	
	
	public void orderCancel()
	{
		List<CmsCancelOrderDto> list=cmsActivityOrderMapper.cancelOrder();
		if(list!=null&list.size()>0)
		{
			for(int i=0;i<list.size();i++)
			{
				System.out.println("订单取消短信");
				HttpRequest.sendGet(PpsConfig.getString("orderCancel"),"userId="+list.get(i).getUserId()+"&activityOrderId="+list.get(i).getActivityOrderId()+"&jobType=1");
			}
			
		}
	}
	

}
