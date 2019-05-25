package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.culturecloud.model.bean.brandact.CmsActivityBrand;

public interface CmsActivityBrandMapper {
	
	//查询记录数
	int queryActivityBrandCount(Map<String,Object> map);
	
	//查询活动列表信息
	List<CmsActivityBrand> queryActivityBrand(Map<String,Object> map);
	
	//编辑下架上架，逻辑删除 
	int updateActivityBrandFalgById(Map<String,Object> map);
	
	//根据id查询活动列表
	CmsActivityBrand selectByPrimaryKey(String id);
	
	//新增活动
	int insertSelective(CmsActivityBrand record);
	
	//编辑具体的活动信息
	int updateActivityBrandById(CmsActivityBrand record);
	
	//获取最大orderIndex
	int selectMaxOrderIndex();
	
}