package com.culturecloud.dao.association;

import com.culturecloud.model.bean.association.CcpAssociationFlower;

public interface CcpAssociationFlowerMapper {
	
	
	/**
	 * 查询用户某社团今日是否浇过花
	 * 
	 * @param associationFlower
	 * @return
	 */
	public Integer countUserAssociationTodayFlower(CcpAssociationFlower associationFlower);
	
	/**
	 * 插入
	 * 
	 * @param associationFlower
	 * @return
	 */
	public Integer insert(CcpAssociationFlower associationFlower);
	
}