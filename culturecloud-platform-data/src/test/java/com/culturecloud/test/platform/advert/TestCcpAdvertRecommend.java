package com.culturecloud.test.platform.advert;

import com.culturecloud.model.request.advert.GetAdvertVO;
import com.culturecloud.test.HttpRequest;
import com.culturecloud.test.TestRestService;
import org.junit.Test;

public class TestCcpAdvertRecommend extends TestRestService{

	
	@Test
	public void pageAdvertRecommend(){
		
		GetAdvertVO request=new GetAdvertVO();
		
		request.setAdvertPostion(2);

		System.out.println(HttpRequest.sendPost(BASE_URL+"/advertRecommend/pageAdvertRecommend", request));
		
	}
}
