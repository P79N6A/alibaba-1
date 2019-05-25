package com.culturecloud.test.platform.pay;

import org.junit.Test;

import com.culturecloud.model.request.pay.PayOrderReqVO;
import com.culturecloud.test.HttpRequest;
import com.culturecloud.test.TestRestService;

public class TestPayOrder extends TestRestService{

	@Test
	public void wxPrePay()
	{
		PayOrderReqVO req=new PayOrderReqVO();
		req.setOrderId("0006a7f7e0764706af25aa8957722a31");
		req.setOpenId("oVEW6s9u56P8oLQck8-oAKq84o68");
		System.out.println(HttpRequest.sendPost(BASE_URL + "/pay/wxprepay", req));
	}
}
