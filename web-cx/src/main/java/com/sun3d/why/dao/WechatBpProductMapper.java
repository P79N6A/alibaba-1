package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.BpProduct;


public interface WechatBpProductMapper {

	int queryBpProductListCount(Map<String, Object> map);

	List<BpProduct> queryBpProductList(Map<String, Object> map);

	BpProduct queryBpProductById(Map<String, Object> map);


}
