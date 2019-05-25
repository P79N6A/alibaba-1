package com.sun3d.why.webservice.api.token;

import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.interfaces.RSAPrivateKey;
import java.security.interfaces.RSAPublicKey;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;

import javax.crypto.Cipher;

/*
@author lijing
@version 1.0 2015年8月3日 上午10:15:52
密钥采用RSA加密做非对称加密，我们提供公钥给第三方系统，文化云保留私钥解密

*/
public class RSAKeySecret {
	private static String src="sun3d why token";
	
	private final PrivateKey privateKey;
	private final PublicKey publicKey;
	
	public RSAKeySecret(PrivateKey privateKey,PublicKey publicKey){
		this.privateKey=privateKey;
		this.publicKey=publicKey;
	}
	
	
	public static PublicKey createPublicKey(byte[] publicKey){
		return null;
	}
	public static String generateKey(){
		String key="";
		try{
			//初始化密码，并把
			KeyPairGenerator keyPairGenerator=KeyPairGenerator.getInstance("RSA");
			keyPairGenerator.initialize(512);
			KeyPair keyPair=keyPairGenerator.generateKeyPair();
			RSAPublicKey rsaPublicKey=(RSAPublicKey) keyPair.getPublic();
			RSAPrivateKey rsaPrivateKey=(RSAPrivateKey) keyPair.getPrivate();

			
			//私钥加密，公钥解密 -加密
			PKCS8EncodedKeySpec pkcs8EnocodedKeySpec=new PKCS8EncodedKeySpec(rsaPrivateKey.getEncoded());
			KeyFactory keyFactory=KeyFactory.getInstance("RSA");
			PrivateKey privateKey=keyFactory.generatePrivate(pkcs8EnocodedKeySpec);
			Cipher cipher=Cipher.getInstance("RSA");
			cipher.init(Cipher.ENCRYPT_MODE,privateKey);
			byte[] result=cipher.doFinal(src.getBytes());

			
			//私钥加密，公钥解密-解密
			X509EncodedKeySpec x509EncodedKeySpec=new X509EncodedKeySpec(rsaPublicKey.getEncoded());
			keyFactory=KeyFactory.getInstance("RSA");
			PublicKey publicKey=keyFactory.generatePublic(x509EncodedKeySpec);
			cipher=Cipher.getInstance("RSA");
			cipher.init(Cipher.DECRYPT_MODE, publicKey);
			result=cipher.doFinal(result);

			
		}catch(Exception e){
			e.printStackTrace();

		}
		return null;
	}
}

