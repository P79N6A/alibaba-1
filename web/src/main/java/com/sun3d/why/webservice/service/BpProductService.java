package com.sun3d.why.webservice.service;

import java.util.List;

import com.sun3d.why.model.BpProduct;
import com.sun3d.why.model.BpProductOrder;
import com.sun3d.why.util.PaginationApp;

public interface BpProductService {
	/**
	 * 查询商城列表
	 * @param productModule
	 * @param pageApp
	 * @return
	 */
	List<BpProduct> queryBpProductList(String productModule, PaginationApp pageApp);
	/**
	 * 根据id得到商品详情
	 * @param productId
	 * @param userId
	 * @return
	 */
	BpProduct queryBpProductById(String productId, String userId);
	/**
	 * 添加一条商品预定信息
	 * @param record
	 * @return
	 */
	int addBpProductOrder(BpProductOrder record);


}
