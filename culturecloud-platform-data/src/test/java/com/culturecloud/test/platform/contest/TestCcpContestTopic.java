package com.culturecloud.test.platform.contest;

import org.junit.Test;

import com.culturecloud.bean.BaseRequest;
import com.culturecloud.enumeration.SystemSourceEnum;
import com.culturecloud.test.HttpRequest;
import com.culturecloud.test.TestRestService;

public class TestCcpContestTopic extends TestRestService{

	
	@Test
	public void getAllTopics()
	{
		for(int i=0;i<=10;i++)
		{
			BaseRequest request=new BaseRequest();
			System.out.println(HttpRequest.sendPost(BASE_URL+"/contestTopic/getAllTopics", request));
		}
		
	}
}
