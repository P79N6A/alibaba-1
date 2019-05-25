package com.sun3d.why.webservice.service.impl;

import com.sun3d.why.dao.BpProductOrderMapper;
import com.sun3d.why.dao.CmsCommentMapper;
import com.sun3d.why.dao.WechatBpProductMapper;
import com.sun3d.why.model.BpProduct;
import com.sun3d.why.model.BpProductOrder;
import com.sun3d.why.model.CmsComment;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.service.BpProductService;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class BpProductServiceImpl implements BpProductService {
	 //log4j日志
    private Logger logger = Logger.getLogger(BpProductServiceImpl.class);
	@Autowired
	private WechatBpProductMapper wechatBpProductMapper;
	@Autowired
    private CmsCommentMapper commentMapper;
	@Autowired
	private BpProductOrderMapper bpProductOrderMapper;
	
	@Override
	public List<BpProduct> queryBpProductList(String productModule,PaginationApp pageApp) {
		Map<String,Object> map = new HashMap<String, Object>();
		
		List<BpProduct> productList = new ArrayList<BpProduct>();
		
        map.put("productStatus", Constant.NORMAL);
        map.put("productModule", productModule);
        int count = wechatBpProductMapper.queryBpProductListCount(map);
        if(count==0){
        	return productList;
        }
        if (pageApp != null && pageApp.getFirstResult() != null && pageApp.getRows() != null) {
        	pageApp.setTotal(count);
            map.put("firstResult", pageApp.getFirstResult());
            map.put("rows", pageApp.getRows());
        }
        
        try {
	        productList = wechatBpProductMapper.queryBpProductList(map);
	       
        } catch (Exception e) {
            logger.error("查询文物信息出错!",e);
        }
        return productList;
	}

	@Override
	public BpProduct queryBpProductById(String productId, String userId) {
		Map<String,Object> map = new HashMap<String,Object>();
		if (productId != null && StringUtils.isNotBlank(productId)) {
            map.put("productId", productId);
        }
		if (userId != null && StringUtils.isNotBlank(userId)) {
            map.put("userId", userId);
        }
		BpProduct bpProduct = wechatBpProductMapper.queryBpProductById(map);
		map=new HashMap<String, Object>();
        map.put("commentRkId", bpProduct.getProductId());
        map.put("firstResult", 0);
        map.put("rows", 5);
        int count = commentMapper.queryCmsCommentCount(map);
        List<CmsComment> commentList= commentMapper.queryCommentByCondition(map);
        bpProduct.setCommentCount(count);
        bpProduct.setCommentList(commentList);
		return bpProduct;
	}

	@Override
	public int addBpProductOrder(BpProductOrder record) {
		record.setProductOrderId(UUIDUtils.createUUId());
		record.setOrderTime(new Date());
		int count = bpProductOrderMapper.insert(record);
		return count;
	}
	
}
