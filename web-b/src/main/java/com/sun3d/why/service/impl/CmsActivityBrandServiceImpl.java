package com.sun3d.why.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.annotation.Transactional;
import org.apache.commons.lang3.StringUtils;

import com.culturecloud.model.bean.brandact.CmsActivityBrand;
import com.sun3d.why.dao.CmsActivityBrandMapper;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.CmsActivityBrandService;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
@Service
@Transactional
public class CmsActivityBrandServiceImpl implements CmsActivityBrandService {

	@Autowired
	private CmsActivityBrandMapper  cmsActivityBrandMapper;
	@Override
	public List<CmsActivityBrand> queryActivityBrand(CmsActivityBrand actBrand, Pagination page) {
		Map<String, Object> map = new HashMap<String, Object>();
				
		//活动名称
		if(!StringUtils.isEmpty(actBrand.getActName())){
			map.put("actName", "%"+actBrand.getActName()+"%");
		}
		
		//活动内容
		if(!StringUtils.isEmpty(actBrand.getActText())){
			map.put("actText", "%"+actBrand.getActText()+"%");
		}
		
		//活动类型
		if(actBrand.getActType()!=null){
			map.put("actType", actBrand.getActType());
		}
		
		//活动状态（是否下架）
		if(actBrand.getActFlag()!=null){
			map.put("actFlag", actBrand.getActFlag());
		}
		
		if(page!=null){
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
			int total = this.cmsActivityBrandMapper.queryActivityBrandCount(map);
			// 设置分页的总条数来获取总页数
			page.setTotal(total);
		}
		
		return cmsActivityBrandMapper.queryActivityBrand(map);
	}

	
	
	
	
	
	
	//新增大活动、编辑大活动
	@Override
	public Map<String, Object> saveActivityBrand(CmsActivityBrand actBrand) {
		Map<String, Object> map = new HashMap<String, Object>();
		String id = UUIDUtils.createUUId();
		int rs = -1;
		if(StringUtils.isBlank(actBrand.getId())){
				actBrand.setId(id);
				Date time = new Date();
				actBrand.setCreateTime(time);
				actBrand.setUpdateTime(time);
				actBrand.setActFlag(2);
				int orderIndex = cmsActivityBrandMapper.selectMaxOrderIndex();
				actBrand.setOrderIndex(orderIndex);
				rs = cmsActivityBrandMapper.insertSelective(actBrand);
		}else{
			rs = cmsActivityBrandMapper.updateActivityBrandById(actBrand);
		}
		if(rs > 0){
			map.put("msg", "success");
			return map;
		}else{
			map.put("msg", "error");
		}
		return map;
	}

	
	
	
	
	
	//更新操作（上架下架和顺序和逻辑删除）
	@Override
	public Map<String, Object> updateActivityBrandFlagById(String id,int actFlag,HttpSession session) {
		Map<String, Object> map = new HashMap<String, Object>();
		if(!StringUtils.isEmpty(id)){
			map.put("id", id);
		}
		
		SysUser user = (SysUser) session.getAttribute("user");
		String name = user.getUserId();
		if(!StringUtils.isEmpty(name)){
			map.put("operator", name);
		}
		//下架状态
		if(actFlag==2){
			//上架
			map.put("actFlag", 1);
		}else if(actFlag==1){
			//下架
			map.put("actFlag", 2);
		}else{
			map.put("actFlag", 0);
		}
		//更新时间
		map.put("updateTime", new Date());
		
		
		int rs = cmsActivityBrandMapper.updateActivityBrandFalgById(map);
		if(rs > 0){
			map.put("status", "ok");
			map.put("msg", "成功！");
			return map;
		}else{
			map.put("status", "error");
			map.put("msg", "刷票失败！");
		}
		return map;
	}

	
	



	@Override
	public CmsActivityBrand selectByPrimaryKey(String id) {
		return cmsActivityBrandMapper.selectByPrimaryKey(id);
	}
	
	
	
	
	
	//更新操作（上架下架和顺序和逻辑删除）
	@Override
	public String cmsActivityBrandOrder(CmsActivityBrand actBrand,Integer flag, Pagination page) {
		Map<String, Object> map = new HashMap<String, Object>();
		if(!StringUtils.isEmpty(actBrand.getId())){
			map.put("id", actBrand.getId());
		}else{
			return "error";
		}
		if(flag!=null){
			map.put("flag", flag);
		}else{
			return "error";
		}
		int rs = -1;
		//活动名称
		if(!StringUtils.isEmpty(actBrand.getActName())){
			map.put("actName", "%"+actBrand.getActName()+"%");
		}
		
		//活动内容
		if(!StringUtils.isEmpty(actBrand.getActText())){
			map.put("actText", "%"+actBrand.getActText()+"%");
		}
		
		//活动类型
		if(actBrand.getActType()!=null){
			map.put("actType", actBrand.getActType());
		}
		
		//活动状态（是否下架）
		if(actBrand.getActFlag()!=null){
			map.put("actFlag", actBrand.getActFlag());
		}
		if(page!=null){
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
		}
		List<CmsActivityBrand> list = cmsActivityBrandMapper.queryActivityBrand(map);
		if(list!=null && list.size()>0){
			
			for(int i = 0;i<list.size();i++){
				if(actBrand.getId().equals(list.get(i).getId())){				
					CmsActivityBrand cmsActivity = new CmsActivityBrand();
					
					//表示下移操作
					if(flag==0){
						//当前移动的对象
						CmsActivityBrand cmsActivityBrand1 = list.get(i);
						//下一个对象
						CmsActivityBrand cmsActivityBrand2 = list.get(i+1);
						
						int orderIndexNow = cmsActivityBrand1.getOrderIndex();
						//日期
						cmsActivity.setUpdateTime(new Date());
						//当前对象的id
						cmsActivity.setId(cmsActivityBrand1.getId());
						//设置为下一个对象的order_index
						cmsActivity.setOrderIndex(cmsActivityBrand2.getOrderIndex());
						
						rs = cmsActivityBrandMapper.updateActivityBrandById(cmsActivity);
						if(rs>0){
							//更新交换的对象
							cmsActivity.setId(cmsActivityBrand2.getId());
							cmsActivity.setOrderIndex(orderIndexNow);
							rs = cmsActivityBrandMapper.updateActivityBrandById(cmsActivity);
						}
					}else{
						//上移orderIndex要和前一个对换
						//当前移动的对象
						CmsActivityBrand cmsActivityBrand1 = list.get(i);
						//前一个对象
						CmsActivityBrand cmsActivityBrand2 = list.get(i-1);
						
						int orderIndexNow = cmsActivityBrand1.getOrderIndex();
						//日期
						cmsActivity.setUpdateTime(new Date());
						cmsActivity.setId(cmsActivityBrand1.getId());
						//设置为下一个对象的order_index
						cmsActivity.setOrderIndex(cmsActivityBrand2.getOrderIndex());
						rs = cmsActivityBrandMapper.updateActivityBrandById(cmsActivity);
						if(rs>0){
							//更新交换的对象
							cmsActivity.setId(cmsActivityBrand2.getId());
							cmsActivity.setOrderIndex(orderIndexNow);
							rs = cmsActivityBrandMapper.updateActivityBrandById(cmsActivity);
						}
					}
				}
			}
		}
		if(rs>0){
			return "success";
		}else{
			return "error";
		}
	}
}
