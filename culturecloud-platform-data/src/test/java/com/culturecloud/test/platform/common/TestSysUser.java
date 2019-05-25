package com.culturecloud.test.platform.common;

import org.junit.Test;

import com.culturecloud.model.request.common.LoginSysUserVO;
import com.culturecloud.model.request.common.SysUserDetailVO;
import com.culturecloud.model.request.common.UpdateSysUserVO;
import com.culturecloud.model.request.live.CcpLiveActivityDetailVO;
import com.culturecloud.test.HttpRequest;
import com.culturecloud.test.TestRestService;

public class TestSysUser extends TestRestService{

	
	@Test
	public void toDetail(){
		
		SysUserDetailVO vo=new SysUserDetailVO();
		
		vo.setUserId("1");
		
		System.out.println(HttpRequest.sendPost(BASE_URL + "/sysUser/toDetail", vo));
	}
	
	
	@Test
	public void login(){
		
		LoginSysUserVO vo=new LoginSysUserVO();
		
		vo.setUserAccount("admin");
		vo.setUserPassword("whyadmin@ct");
		
		System.out.println(HttpRequest.sendPost(BASE_URL+"/sysUser/loginCheckUser", vo));
		
	}
	
	@Test
	public void updateSysUser(){
		
		UpdateSysUserVO vo=new UpdateSysUserVO();
		
		vo.setUserId("1");
		
		vo.setUserHeadImgUrl("http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20161110172731MHD6D0ez6WjOekQbu0lP4VWqtiBxha.jpg");
		
		System.out.println(HttpRequest.sendPost(BASE_URL+"/sysUser/updateSysUser", vo));
	}
}
