/*
@author lijing
@version 1.0 2015年8月3日 下午1:37:52
根据HmacMD5生成密钥，供第三方系统使用
*/
package com.sun3d.why.webservice.api.token;

import javax.crypto.KeyGenerator;
import javax.crypto.Mac;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;


public class SHAKey {
	private static String src="sun3d why token";
	public static String generate(){
		String oauth="";
		try{
			KeyGenerator keyGenerator=KeyGenerator.getInstance("HmacMD5");
			SecretKey secretKey=keyGenerator.generateKey();
			byte[] key=secretKey.getEncoded();
			SecretKey restoreSecretKey=new SecretKeySpec(key,"HmacMD5");
			Mac mac=Mac.getInstance(restoreSecretKey.getAlgorithm());
			mac.init(restoreSecretKey);
		 	byte[] bytes=mac.doFinal(src.getBytes());
		 	oauth =Base64.encodeBytes(bytes);
		}catch(Exception e){

		}
		
		return oauth;
	}
	
	public static void decode(){
		
	}
}

