package com.culturecloud.test.platform.live;

import java.util.Date;

import org.junit.Test;

import com.culturecloud.bean.BaseRequest;
import com.culturecloud.model.request.common.SysUserDetailVO;
import com.culturecloud.model.request.live.CcpLiveActivityDetailVO;
import com.culturecloud.model.request.live.CcpLiveActivityPageVO;
import com.culturecloud.model.request.live.CcpLiveMessagePageVO;
import com.culturecloud.model.request.live.CcpLiveUserDetailVO;
import com.culturecloud.model.request.live.CcpLiveUserImgPageVO;
import com.culturecloud.model.request.live.LiveVersionNoCheckVO;
import com.culturecloud.model.request.live.SaveCcpLiveActivityVO;
import com.culturecloud.model.request.live.SaveCcpLiveMessageVO;
import com.culturecloud.model.request.live.SaveLiveUserVO;
import com.culturecloud.model.request.live.UpdateCcpLiveActivityVO;
import com.culturecloud.model.request.live.UpdateCcpLiveMessageVO;
import com.culturecloud.test.HttpRequest;
import com.culturecloud.test.TestRestService;

public class TestCcpLive extends TestRestService {
	
	@Test
	public void createLiveActivity(){
		
		
		SaveCcpLiveActivityVO vo=new SaveCcpLiveActivityVO();
		
		vo.setLiveStartTime(new Date());
		vo.setLiveCoverImg("http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161110172731MHD6D0ez6WjOekQbu0lP4VWqtiBxha.jpg");
	
		vo.setLiveCreateUser("1");
		vo.setLiveTitle("是短发是范德萨发");
		vo.setLiveType(1);
		
		System.out.println(HttpRequest.sendPost(BASE_URL + "/liveActivity/create", vo));
	}
	
	@Test
	public void toLiveActivityDetail(){
		
		CcpLiveActivityDetailVO vo=new CcpLiveActivityDetailVO();
		
		vo.setLiveActivityId("2e637c46cc8f4f53b88bb7d8fe87d201");
		
		System.out.println(HttpRequest.sendPost(BASE_URL + "/liveActivity/toDetail", vo));
	}
	
	@Test
	public void updateLiveActivity(){
		
		
		UpdateCcpLiveActivityVO vo=new UpdateCcpLiveActivityVO();
		
	
		vo.setLiveActivityId("30626e8e71124edc90a0cd5c8896e41e");
		vo.setLiveTopText("zzzzzzzzzzzzzzzz");
		
		System.out.println(HttpRequest.sendPost(BASE_URL + "/liveActivity/update", vo));
	}
	
	@Test
	public void createLiveMessage(){
		
		SaveCcpLiveMessageVO vo=new SaveCcpLiveMessageVO();
		
		vo.setMessageActivity("7b3ff659237849ce98de128e2ba8d3ea");
		vo.setMessageContent("萨达萨达22222");
		vo.setMessageCreateUser("1");
		vo.setMessageImg("http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161021161951LFaDrysmM43LHbwbCasEXDJneu5hZo.jpg");
		vo.setMessageIsInteraction(0);

		System.out.println(HttpRequest.sendPost(BASE_URL + "/live/createMessage", vo));
		
	}
	
	@Test
	public void updateLiveMessage(){
		
		UpdateCcpLiveMessageVO vo=new UpdateCcpLiveMessageVO();
		
		vo.setMessageId("5cf964e132594512b88f28778f1006b4");
		
		vo.setMessageIsRecommend(1);
		
		System.out.println(HttpRequest.sendPost(BASE_URL + "/live/updateMessage", vo));
	}
	
	@Test 
	public void getLiveActivityList(){
		
		
		CcpLiveActivityPageVO vo =new CcpLiveActivityPageVO();
		
		vo.setLiveCreateUser("1");
		
		vo.setLiveStatus(0);
		
		vo.setLiveType(1);
		
		System.out.println(HttpRequest.sendPost(BASE_URL + "/liveActivity/liveActivityList", vo));
	}
	

	@Test
	public void getLiveMessageList() {

		CcpLiveMessagePageVO vo = new CcpLiveMessagePageVO();
		
		vo.setMessageActivity("1");
		
		
		System.out.println(HttpRequest.sendPost(BASE_URL + "/live/liveMessageList", vo));

	}
	
	@Test
	public void saveLiveUserInfo(){
		
		SaveLiveUserVO vo=new SaveLiveUserVO();
		
		vo.setUserId("77cc40f512544844bdf0f243151ae2c8");
		vo.setLiveUserId("e4683b0469fc443c8b01c4cc00744b16");
		vo.setLiveActivity("1");
		
		System.out.println(HttpRequest.sendPost(BASE_URL + "/live/saveLiveUserInfo", vo));
	}
	
	@Test
	public void getliveUserImgList(){
		
		CcpLiveUserImgPageVO vo=new CcpLiveUserImgPageVO();
		
		vo.setUserId("77cc40f512544844bdf0f243151ae2c8");
		vo.setLiveActivity("1");
		
		System.out.println(HttpRequest.sendPost(BASE_URL + "/live/liveUserImgList", vo));
	}
	
	@Test
	public void getliveUserDetail(){
		
		CcpLiveUserDetailVO vo=new CcpLiveUserDetailVO();
		
		vo.setLiveUserId("e4683b0469fc443c8b01c4cc00744b16");
		
		vo.setLiveActivity("1");
		
		System.out.println(HttpRequest.sendPost(BASE_URL + "/live/liveUserDetail", vo));
		
	}
	
	@Test
	public void getwatermarkList(){
		BaseRequest request =new BaseRequest();
		
		System.out.println(HttpRequest.sendPost(BASE_URL + "/liveActivity/watermarkList", request));
		
	}
	
	@Test
	public void backgroundMusicList(){
		BaseRequest request =new BaseRequest();
		
		System.out.println(HttpRequest.sendPost(BASE_URL + "/liveActivity/backgroundMusicList", request));
		
	}
	
	@Test
	public void userLiveTotalInfo(){
		
		SysUserDetailVO request =new SysUserDetailVO();
		request.setUserId("1");
		
		
		System.out.println(HttpRequest.sendPost(BASE_URL + "/liveActivity/userLiveTotalInfo", request));
		
		
	}
	
	@Test 
	public void getLiveActivityHotList(){
		
		BaseRequest request =new BaseRequest();
		
		System.out.println(HttpRequest.sendPost(BASE_URL + "/liveActivity/liveActivityHotList", request));
	}
	
	@Test
	public void versionNoCheck(){
		
		LiveVersionNoCheckVO request=new LiveVersionNoCheckVO();
		
		request.setMobileType(1);
		request.setVersionNo("0.8.0");
		
		System.out.println(HttpRequest.sendPost(BASE_URL + "/live/versionNoCheck", request));
	}
}
