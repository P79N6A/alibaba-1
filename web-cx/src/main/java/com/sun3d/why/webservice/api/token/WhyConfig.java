/*
@author lijing
@version 1.0 2015年8月3日 下午2:06:59
*/
package com.sun3d.why.webservice.api.token;
import com.sun3d.why.model.extmodel.TokenInfo;
import com.sun3d.why.util.SpringContextUtil;
import org.springframework.context.ApplicationContext;

public class WhyConfig {
	public String ltpaSecret;
	public String tokenDomain;
	public String dominohost;
	public int tokenExpiration;

	
	public WhyConfig(){
		ApplicationContext context = SpringContextUtil.getContext();
		TokenInfo tokenInfo = (TokenInfo) context.getBean("tokenInfo");
		this.ltpaSecret="E7rorsru3q5QV7rUmullrA==";
		this.tokenDomain="*.sun3d.com";
		this.tokenExpiration=60*(tokenInfo.getTokenTime());

	}
	
}

