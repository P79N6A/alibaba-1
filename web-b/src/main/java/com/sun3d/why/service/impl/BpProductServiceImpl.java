package com.sun3d.why.service.impl;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.BpProductMapper;
import com.sun3d.why.dao.BpProductOrderMapper;
import com.sun3d.why.model.BpProduct;
import com.sun3d.why.model.BpProductOrder;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.service.BpProductService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.UUIDUtils;
@Service
@Transactional
public class BpProductServiceImpl implements BpProductService {
	@Autowired
	private BpProductMapper bpProductMapper;
	@Autowired
	private BpProductOrderMapper bpProductOrderMapper;
	//log4j日志
    private Logger logger = Logger.getLogger(BpProductServiceImpl.class);
    
	@Override
	public int addBpProduct(BpProduct record, SysUser sysUser) {
		int count = 0;
        try {
            //添加商品时，默认赋值
            record.setProductId(UUIDUtils.createUUId());
            record.setProductStatus(Constant.NORMAL);
            record.setProductCreateTime(new Date());
            record.setProductUpdateTime(new Date());
            record.setProductCreateUser(sysUser.getUserId());
            record.setProductUpdateUser(sysUser.getUserId());
            count = bpProductMapper.addBpProduct(record);
        } catch (Exception e) {
            logger.error("添加商品信息出错!",e);
        }
        return count;
	}

	@Override
	public List<BpProduct> queryBpProductByCondition(Pagination page, BpProduct record, SysUser sysUser,String createStartTime,String createEndTime) {
		Map<String,Object> map = new HashMap<String, Object>();
        List<BpProduct> list = null;
        if(StringUtils.isNotBlank(record.getSearchKey())){
            map.put("searchKey", record.getSearchKey());
        }   
        if(StringUtils.isNotBlank(createStartTime)){
            map.put("createStartTime", createStartTime);
        } 
        if(StringUtils.isNotBlank(createEndTime)){
            map.put("createEndTime", createEndTime);
        } 
        try {
	        int total = bpProductMapper.queryBpProductCountByCondition(map);
	        //设置分页的总条数来获取总页数
	        page.setTotal(total);
	        page.setRows(page.getRows());
	        map.put("firstResult",page.getFirstResult());
	        map.put("rows",page.getRows());
	        list = bpProductMapper.queryBpProductByCondition(map);
        } catch (Exception e) {
            logger.error("查询商品信息出错!",e);
        }
		return list;
	}

	@Override
	public int deleteBpProduct(String productId, SysUser sysUser) {
		int count = 0;
        Map<String,Object> map = new HashMap<String, Object>();
        try {
        	map.put("productId",productId);
        	map.put("productStatus",Constant.DELETE);//productStatus字段设为2代表删除
            map.put("userId",sysUser.getUserId());
            map.put("updateTime",new Date());
            count = bpProductMapper.updateProductStatusById(map);
        } catch (Exception e) {
            logger.error("逻辑删除商品信息出错!",e);
        }
        return count;
	}

	@Override
	public int removeBpProduct(String productId, String productStatus, SysUser sysUser) {
		int count = 0;
        Map<String,Object> map = new HashMap<String, Object>();
        try {
        	map.put("productId",productId);
        	map.put("productStatus",Integer.valueOf(productStatus));
            map.put("userId",sysUser.getUserId());
            map.put("updateTime",new Date());
            count = bpProductMapper.updateProductStatusById(map);
        } catch (Exception e) {
            logger.error("上/下架商品出错!",e);
        }
        return count;
	}

	@Override
	public BpProduct queryBpProductById(String productId) {
		return bpProductMapper.queryBpProductById(productId);
	}

	@Override
	public int editbpProduct(BpProduct record, SysUser sysUser) {
		int count = 0;
        try {
        	 record.setProductUpdateTime(new Date());
        	 record.setProductUpdateUser(sysUser.getUserId());
        	 count = bpProductMapper.updateBpProduct(record);
        } catch (Exception e) {
            logger.error("修改商品信息出错!",e);
        }
        return count;
	}

	@Override
	public List<BpProductOrder> queryOrderByProductId(Pagination page,String productId) {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("productId", productId);
		int total = bpProductOrderMapper.queryOrderCountByProductId(map);
		page.setTotal(total);
        page.setRows(page.getRows());
        map.put("firstResult",page.getFirstResult());
        map.put("rows",page.getRows());		
		return bpProductOrderMapper.queryOrderByProductId(map);
	}

}
