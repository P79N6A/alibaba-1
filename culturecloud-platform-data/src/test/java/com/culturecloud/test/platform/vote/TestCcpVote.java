package com.culturecloud.test.platform.vote;

import org.junit.Test;

import com.culturecloud.model.request.vote.CcpVoteDetailVO;
import com.culturecloud.model.request.vote.QueryVoteItemListVO;
import com.culturecloud.model.request.vote.SaveUserTicketVO;
import com.culturecloud.test.HttpRequest;
import com.culturecloud.test.TestRestService;

public class TestCcpVote extends TestRestService{

	@Test
	public void voteDetail() {
		
		CcpVoteDetailVO request=new CcpVoteDetailVO();
		
		String voteId="dsdsds";
		
		request.setVoteId(voteId);
		
		System.out.println(HttpRequest.sendPost(BASE_URL+"/vote/voteDtatil", request));
		
	}
	
	@Test
	public void voteItemList(){
		
		QueryVoteItemListVO request=new QueryVoteItemListVO();
		
		String voteId="dsdsds";
		
		request.setVoteId(voteId);
		
		request.setSort(1);
		
		request.setUserId("sd");
		
		request.setVoteItemId("90f2d287a3a849e29f831bfc09e08af9");
		
		System.out.println(HttpRequest.sendPost(BASE_URL+"/vote/voteItemList", request));
	}
	
	@Test
	public void saveVoteTicket(){
		
		SaveUserTicketVO request=new SaveUserTicketVO();
		request.setUserId("sd");
		request.setVoteItemId("2820dcbe4ff74296b84c261a21a3defe");
		
		System.out.println(HttpRequest.sendPost(BASE_URL+"/vote/saveUserTicket", request));
	}
}

