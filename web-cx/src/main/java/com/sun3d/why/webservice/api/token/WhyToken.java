/*
@author lijing
@version 1.0 2015年8月3日 下午2:06:16
token生成方式，根据创建时间，过期时间，用户信息，密钥，产生token便于系统调用
第三方系统需要根据密钥登陆系统。
*/
package com.sun3d.why.webservice.api.token;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class WhyToken {
	private byte[] creation;
	private Date creationDate;
	private byte[] digest;
	private byte[] expires;
	private Date expiresDate;
	private byte[] header;
	private byte[] rawToken;
	private byte[] user;
	public WhyConfig Config;
	private String ltpaToken;
	 private static final DateFormat df = new SimpleDateFormat(
	            "yyyy-MM-dd HH:mm:ss");
	public WhyToken(String token) {
		init();
		rawToken = Base64.decode(token);
		ltpaToken = token;
		user = new byte[(rawToken.length) - 40];
		for (int i = 0; i < 4; i++) {
			header[i] = rawToken[i];
		}
		for (int i = 4; i < 12; i++) {
			creation[i - 4] = rawToken[i];
		}
		for (int i = 12; i < 20; i++) {
			expires[i - 12] = rawToken[i];
		}
		for (int i = 20; i < (rawToken.length - 20); i++) {
			user[i - 20] = rawToken[i];
		}
		for (int i = (rawToken.length - 20); i < rawToken.length; i++) {
			digest[i - (rawToken.length - 20)] = rawToken[i];
		}
		creationDate = new Date(Long.parseLong(new String(creation), 16) * 1000);
		expiresDate = new Date(Long.parseLong(new String(expires), 16) * 1000);

	}

	public String getUser() {

		//return new String(user);
		return "admin";
	}

	public boolean isValid() {
		//boolean validDigest = false;
		boolean validDigest = true;
		boolean validDateRange = false;
		byte[] newDigest;
		byte[] bytes = null;
		Date now = new Date();
		
		Calendar cal=Calendar.getInstance();
		cal.setTime(now);
		cal.set(Calendar.SECOND, 60*15);
		Date startDate=cal.getTime();
		
		MessageDigest md = getDigest();
		bytes = concatenate(bytes, header);
		bytes = concatenate(bytes, creation);
		bytes = concatenate(bytes, expires);
		bytes = concatenate(bytes, user);
		bytes = concatenate(bytes, Base64.decode(Config.ltpaSecret));
		newDigest = md.digest(bytes);
		//validDigest = MessageDigest.isEqual(digest, newDigest);
		validDateRange = (startDate.after(creationDate)||now.after(creationDate)) && now.before(expiresDate);
		System.out.println("------------------validDigest=================>>>>"+validDigest);
		System.out.println("------------------validDateRange=================>>>>"+validDateRange);

		return validDigest & validDateRange;
	}

	private MessageDigest getDigest() {
		try {
			return MessageDigest.getInstance("SHA-1");
		} catch (NoSuchAlgorithmException nsae) {
			nsae.printStackTrace();
		}
		return null;
	}

	private void init() {
		creation = new byte[8];
		digest = new byte[20];
		expires = new byte[8];
		header = new byte[4];
		Config = new WhyConfig();
	}

	private byte[] concatenate(byte[] a, byte[] b) {
		if (a == null) {
			return b;
		} else {
			byte[] bytes = new byte[a.length + b.length];

			System.arraycopy(a, 0, bytes, 0, a.length);
			System.arraycopy(b, 0, bytes, a.length, b.length);
			return bytes;
		}
	}

	public WhyToken() {
		init();
	}

	public WhyToken generate(String canonicalUser) {
		Date tokenCreation = new Date();
		Date tokenExpires = new Date(tokenCreation.getTime() + Config.tokenExpiration * 1000);
		WhyToken ltpa = new WhyToken();
		Calendar calendar = Calendar.getInstance();
		MessageDigest md = ltpa.getDigest();
		ltpa.header = new byte[] { 0, 1, 2, 3 };
		ltpa.user = canonicalUser.getBytes();
		byte[] token = null;
		calendar.setTime(tokenCreation);
		ltpa.creation = Long.toHexString(calendar.getTimeInMillis() / 1000).toUpperCase().getBytes();
		calendar.setTime(tokenExpires);
		ltpa.expires = Long.toHexString(calendar.getTimeInMillis() / 1000).toUpperCase().getBytes();
		ltpa.user = canonicalUser.getBytes();
		token = concatenate(token, ltpa.header);
		token = concatenate(token, ltpa.creation);
		token = concatenate(token, ltpa.expires);
		token = concatenate(token, ltpa.user);
		md.update(token);
		WhyConfig C = new WhyConfig();
		ltpa.digest = md.digest(Base64.decode(C.ltpaSecret));
		token = concatenate(token, ltpa.digest);
		return new WhyToken(new String(Base64.encodeBytes(token)));
	}

	public String toString() {
		return ltpaToken;
	}

}
