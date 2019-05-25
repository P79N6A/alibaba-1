package com.culturecloud.test.platform.common;

import org.junit.Test;

import com.culturecloud.model.request.common.QueryRelateTagSubListVO;
import com.culturecloud.test.HttpRequest;
import com.culturecloud.test.TestRestService;

public class TestCmsTagSub extends TestRestService {
 
	@Test
	public void relateTagSubList(){
		
		String relateId="18361d385dbe450cb60beaeaa14eea36";

		QueryRelateTagSubListVO request=new QueryRelateTagSubListVO();
		
		request.setRelateId(relateId);
		
		System.out.println(HttpRequest.sendPost(BASE_URL+"/tagSub/relateTagSubList", request));
		
	}
}
