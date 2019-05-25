package com.sun3d.why.service;

import com.sun3d.why.model.BpInfo;
import com.sun3d.why.model.SysDict;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

import java.util.List;

public interface BpInfoService {

	/**
	 * 根据部门id查找部门名称
	 * 
	 * @param userDeptId
	 * @return
	 */
	String findDeptNameById(String userDeptId);

	/**
	 * 发布人文洪山+更新人文洪山
	 * 
	 * @param bpInfo
	 *            资讯对象
	 * @param sysUser
	 *            登录角色
	 * @return 返回结果
	 */
	String addInfo(BpInfo bpInfo, SysUser sysUser);

	BpInfo queryAll();

	/**
	 * 人文洪山列表+条件查询
	 * 
	 * @param bpInfo
	 * @param page
	 * @return
	 */
	List<BpInfo> queryInfoListByCondition(BpInfo bpInfo, Pagination page,String userDeptPath);

	/**
	 * 根据状态判断上架下架，改变状态
	 * 
	 * @param infoId
	 * @param infoStatus
	 * @param loginUser
	 */
	void changInfoStatus(String infoId, String infoStatus, SysUser loginUser);

	/**
	 * 根据id删除资讯——设置状态为2
	 * 
	 * @param infoId
	 * @param loginUser
	 */
	void delInfo(String infoId, SysUser loginUser);

	/**
	 * 查询出所有未被使用的推荐编号(每个模块推荐数量不同)
	 * 
	 * @param infoId
	 * @return
	 */
	List<String> queryInfoNumber(String infoId);

	/**
	 * 资讯推荐
	 * 
	 * @param infoId
	 * @param infoNumber
	 * @param loginUser
	 */
	void recommendInfo(String infoId, String infoNumber, SysUser loginUser);

	/**
	 * 取消资讯推荐
	 * 
	 * @param infoId
	 * @param loginUser
	 */
	void delRecommendInfo(String infoId, SysUser loginUser);

	/**
	 * 编辑前的数据回显，根据id查找对象
	 * 
	 * @param infoId
	 * @return
	 */
	BpInfo selectInfoById(String infoId);

	/**
	 * 根据tagId在数据字典中查找字标签列表
	 * 
	 * @param tagId
	 * @return
	 */
	List<SysDict> queryChildTagByInfoTag(String tagId);

	/**
	 * 根据编码查找字典以及其一级子标签
	 * 
	 * @param code
	 * @return
	 */
	List<SysDict> queryByCode(String code);

}
