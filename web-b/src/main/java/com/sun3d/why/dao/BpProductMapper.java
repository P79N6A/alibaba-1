package com.sun3d.why.dao;

import java.util.List;
import java.util.Map;

import com.sun3d.why.model.BpProduct;


public interface BpProductMapper {
	/**
	 * 增加一条商品
	 * @param record
	 * @return
	 */
	int addBpProduct(BpProduct record);

	/**
	 * 根据条件查询商品条数
	 * @param map
	 * @return
	 */
	int queryBpProductCountByCondition(Map<String, Object> map);
	/**
	 * 根据条件查询商品列表
	 * @param map
	 * @return 
	 */
	List<BpProduct> queryBpProductByCondition(Map<String, Object> map);

	/**
	 * 根据id改变商品状态
	 * @param map
	 * @return
	 */
	int updateProductStatusById(Map<String, Object> map);
	/**
	 * 根据id得到一条商品信息
	 * @param productId
	 * @return
	 */
	BpProduct queryBpProductById(String productId);
	/**
	 * 更新商品信息
	 * @param record
	 * @return
	 */
	int updateBpProduct(BpProduct record);
   

}