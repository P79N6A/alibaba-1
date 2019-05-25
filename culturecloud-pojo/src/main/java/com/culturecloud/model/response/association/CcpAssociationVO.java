package com.culturecloud.model.response.association;

import java.lang.reflect.InvocationTargetException;
import java.util.Date;
import java.util.List;

import org.apache.commons.beanutils.PropertyUtils;

import com.culturecloud.model.bean.association.CcpAssociation;

public class CcpAssociationVO extends CcpAssociation{
	
	private static final long serialVersionUID = 7298123808593002250L;

	private Integer flowerCount;
	
	private Integer activityCount;
	private Integer recruitStatus;
	public CcpAssociationVO(CcpAssociation association) {

		try {
			PropertyUtils.copyProperties(this, association);
		} catch (IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
			e.printStackTrace();
		}
		
		 // 创建时间
		Date createTime=this.getCreateTime();
		
		 if(createTime!=null)
		 {
			 this.setCreateTime(new Date(createTime.getTime()/1000));
		 }	
		 
		 Date updateTime=this.getUpdateTime();
		 
		 if(updateTime!=null)
		 {
			 this.setUpdateTime(new Date(updateTime.getTime()/1000));
		 }	
	}
	
	public Integer getFlowerCount() {
		return flowerCount;
	}

	public void setFlowerCount(Integer flowerCount) {
		this.flowerCount = flowerCount;
	}

	public Integer getActivityCount() {
		return activityCount;
	}

	public void setActivityCount(Integer activityCount) {
		this.activityCount = activityCount;
	}

	public Integer getRecruitStatus() {
		return recruitStatus;
	}

	public void setRecruitStatus(Integer recruitStatus) {
		this.recruitStatus = recruitStatus;
	}

}