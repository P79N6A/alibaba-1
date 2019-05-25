package com.culturecloud.model.response.association;

import java.lang.reflect.InvocationTargetException;
import java.util.List;

import org.apache.commons.beanutils.PropertyUtils;

import com.culturecloud.model.bean.association.CcpAssociation;

public class CcpAssociationDetailVO extends CcpAssociation{
	
	private static final long serialVersionUID = 7298123808593002250L;

	// 浇花数
	private Integer flowerCount;

	// 粉丝数
	private Integer fansCount;
	
	// 今日是否浇花 0 否 1是
	private Integer todayIsFlower=0;
	
	// 是否关注 0 否 1是
	private Integer isFollow=0;
	
	public CcpAssociationDetailVO(CcpAssociation association) {

		try {
			PropertyUtils.copyProperties(this, association);
		} catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
			e.printStackTrace();
		}
	}
	
	public Integer getFlowerCount() {
		return flowerCount;
	}

	public void setFlowerCount(Integer flowerCount) {
		this.flowerCount = flowerCount;
	}

	public Integer getFansCount() {
		return fansCount;
	}

	public void setFansCount(Integer fansCount) {
		this.fansCount = fansCount;
	}

	public Integer getTodayIsFlower() {
		return todayIsFlower;
	}

	public void setTodayIsFlower(Integer todayIsFlower) {
		this.todayIsFlower = todayIsFlower;
	}

	public Integer getIsFollow() {
		return isFollow;
	}

	public void setIsFollow(Integer isFollow) {
		this.isFollow = isFollow;
	}

}