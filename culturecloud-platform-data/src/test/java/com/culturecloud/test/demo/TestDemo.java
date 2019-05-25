package com.culturecloud.test.demo;

import org.junit.BeforeClass;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.culturecloud.bean.BaseRequest;
import com.culturecloud.redis.RedisDAO;
import com.culturecloud.test.HttpRequest;
import com.culturecloud.test.TestRestService;

public class TestDemo extends TestRestService{

	
	private static RedisDAO redisDAO;
	
	
	
	@BeforeClass
	public static void setUpBeforeClass(){
		try {
			ApplicationContext cxt = new ClassPathXmlApplicationContext("spring.xml");
			redisDAO = (RedisDAO)cxt.getBean("redisDao");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Test
	public void getDemo()
	{
		BaseRequest request=new BaseRequest();
		//request.setSource("PC");
		System.out.println(HttpRequest.sendPost(BASE_URL+"/demo/getDemo", request));
	}
	
	@Test
	public void getDemoCache()
	{
		BaseRequest request=new BaseRequest();
		//request.setSource("PC");
		System.out.println(HttpRequest.sendPost(BASE_URL+"/cachedemo/getDemo", request));
	}
	
	
	
	
	
	@Test
	public void saveRedis()
	{
		try {
			
//			redisDAO.getData("");
			System.out.println("reslut: " + redisDAO.getData("ACCESS_TOKEN"));
			
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("=======================出错啦！========================");
		}
	}
	
	
}
