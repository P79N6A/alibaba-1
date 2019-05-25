package com.culturecloud.model.response.heritage;

import java.lang.reflect.InvocationTargetException;

import org.apache.commons.beanutils.PropertyUtils;

import com.culturecloud.model.bean.heritage.CcpHeritage;

public class CcpHeritageResVO extends CcpHeritage{
	
	private static final long serialVersionUID = -1643788207612210975L;
	
	private String heritageImg;
	
	private Integer heritageIsWant;		//是否点赞
	
	private Integer heritageWantCount;		//点赞数
	
	public CcpHeritageResVO() {
		
	}
	
	public CcpHeritageResVO(CcpHeritage ccpHeritage) {
		try {
			PropertyUtils.copyProperties(this, ccpHeritage);
		} catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
			e.printStackTrace();
		}
	}

	public String getHeritageImg() {
		return heritageImg;
	}

	public void setHeritageImg(String heritageImg) {
		this.heritageImg = heritageImg;
	}

	public Integer getHeritageIsWant() {
		return heritageIsWant;
	}

	public void setHeritageIsWant(Integer heritageIsWant) {
		this.heritageIsWant = heritageIsWant;
	}

	public Integer getHeritageWantCount() {
		return heritageWantCount;
	}

	public void setHeritageWantCount(Integer heritageWantCount) {
		this.heritageWantCount = heritageWantCount;
	}

}