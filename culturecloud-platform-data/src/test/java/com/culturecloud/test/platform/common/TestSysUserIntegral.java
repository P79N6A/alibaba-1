package com.culturecloud.test.platform.common;

import org.junit.Test;

import com.culturecloud.bean.BaseRequest;
import com.culturecloud.test.HttpRequest;
import com.culturecloud.test.TestRestService;

public class TestSysUserIntegral extends TestRestService {

	@Test
	public void add(){
		
		BaseRequest request=new BaseRequest();
		
		System.out.println(HttpRequest.sendPost(BASE_URL+"/integral/add", request));
		
	}
}
