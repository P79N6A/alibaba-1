package com.culturecloud.test.platform.venue;

import java.util.List;

import org.junit.Test;

import com.culturecloud.model.request.venue.SearchVenueVO;
import com.culturecloud.model.response.venue.CmsVenueVO;
import com.culturecloud.test.HttpRequest;
import com.culturecloud.test.TestRestService;

public class TestCmsVenue  extends TestRestService{

	@Test
	public void searchVenue(){
		
		SearchVenueVO request=new SearchVenueVO();
		
		String keyword="文化活动中心";
		
		request.setKeyword(keyword);
		
		System.out.println(HttpRequest.sendPost(BASE_URL+"/venue/searchVenue", request));
	}
	
}
