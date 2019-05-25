/*
 * @Author:lijing
 * @Date:2015/08/03
 * token静态帮助类，可以根据token获取用户信息，也可以根据用户生成token
 * token主要由用户信息，密钥，过期时间组成
 * 
 * 
 * */
package com.sun3d.why.webservice.api.token;

public class TokenHelper {

	public static String getUserName(String accessToken){
		WhyToken token=new WhyToken(accessToken);
		String userName=token.getUser();
		return userName;
	}
	
	public static String generateToken(String userName){
		WhyToken token=new WhyToken();
		String accessToken=token.generate(userName).toString();
		return accessToken;
		
	}
	
	public static boolean valid(String accessToken){
		WhyToken token=new WhyToken(accessToken);
		boolean bool=token.isValid();
		return bool;
	}
	
	
}
