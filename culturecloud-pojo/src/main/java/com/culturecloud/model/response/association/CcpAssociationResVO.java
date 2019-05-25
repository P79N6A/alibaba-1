package com.culturecloud.model.response.association;

import java.lang.reflect.InvocationTargetException;
import java.util.Date;

import org.apache.commons.beanutils.PropertyUtils;

import com.culturecloud.model.bean.association.CcpAssociationRes;

public class CcpAssociationResVO extends CcpAssociationRes {

	private static final long serialVersionUID = -4479909589992892651L;

	public CcpAssociationResVO(CcpAssociationRes res) {

		try {
			PropertyUtils.copyProperties(this, res);
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
}
