package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.BpProduct;
import com.sun3d.why.model.BpProductOrder;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

public interface BpProductService {
	/**
	 * 发布一条商品
	 * @param record
	 * @param sysUser
	 * @return
	 */
	int addBpProduct(BpProduct record, SysUser sysUser);
	/**
	 * 根据条件分页查询商品列表
	 * @param page
	 * @param record
	 * @param sysUser
	 * @param createStartTime 开始时间
	 * @param createEndTime	截止时间
	 * @return
	 */
	List<BpProduct> queryBpProductByCondition(Pagination page, BpProduct record, SysUser sysUser,String createStartTime,String createEndTime);
	/**
	 * 将商品状态更新为删除
	 * @param productId
	 * @param sysUser
	 * @return
	 */
	int deleteBpProduct(String productId, SysUser sysUser);
	/**
	 * 上下架商品
	 * @param productId
	 * @param productStatus
	 * @param sysUser
	 * @return
	 */
	int removeBpProduct(String productId, String productStatus, SysUser sysUser);
	/**
	 * 根据id查询一条商品信息
	 * @param productId
	 * @return
	 */
	BpProduct queryBpProductById(String productId);
	/**
	 * 修改商品信息
	 * @param record
	 * @param sysUser
	 * @return
	 */
	int editbpProduct(BpProduct record, SysUser sysUser);
	/**
	 * 查询商品预约信息
	 * @param productId
	 * @return
	 */
	List<BpProductOrder> queryOrderByProductId(Pagination page,String productId);

}
