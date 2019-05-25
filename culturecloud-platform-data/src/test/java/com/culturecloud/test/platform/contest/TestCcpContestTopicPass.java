package com.culturecloud.test.platform.contest;

import org.junit.Test;

import com.culturecloud.enumeration.SystemSourceEnum;
import com.culturecloud.model.request.contest.QueryTopicPassVO;
import com.culturecloud.test.HttpRequest;
import com.culturecloud.test.TestRestService;

public class TestCcpContestTopicPass extends TestRestService {

	@Test
	public void getTopicPassInfo(){
		
		QueryTopicPassVO queryTopicPassVO=new QueryTopicPassVO();
		
		queryTopicPassVO.setTopicId("sdsdasd");
		
		System.out.println(HttpRequest.sendPost(BASE_URL+"/contestTopicPass/getTopicPassInfo", queryTopicPassVO));
		
	}
}
