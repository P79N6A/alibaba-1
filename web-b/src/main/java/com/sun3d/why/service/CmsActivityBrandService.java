package com.sun3d.why.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import com.culturecloud.model.bean.brandact.CmsActivityBrand;
import com.sun3d.why.util.Pagination;

public interface CmsActivityBrandService {
	
	//查询活动列表
	List<CmsActivityBrand> queryActivityBrand(CmsActivityBrand actBrand, Pagination page);
	
	//保存新增活动
	Map<String, Object> saveActivityBrand(CmsActivityBrand actBrand);
	

	//更新上架下架和逻辑删除
	Map<String, Object> updateActivityBrandFlagById(String id,int actFlag,HttpSession session);
	
	
	//根据id查询活动列表
	CmsActivityBrand selectByPrimaryKey(String id);
	
	
	//活动的上下移动
	public String cmsActivityBrandOrder(CmsActivityBrand cmsActivityBrand,Integer flag, Pagination page);
}
