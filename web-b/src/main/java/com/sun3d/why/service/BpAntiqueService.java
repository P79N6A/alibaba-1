package com.sun3d.why.service;

import java.util.List;

import com.sun3d.why.model.BpAntique;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

public interface BpAntiqueService {
	
	/**
	 * 增加一条文化文物
	 * @param record 文化文物
	 * @param sysUser 系统用户
	 * @return
	 */
	int addBpAntique(BpAntique record, SysUser sysUser);
	/**
	 * 根据分页信息以及用户信息文物列表查询
	 * @param page
	 * @param record
	 * @param sysUser
	 * @return
	 */
	List<BpAntique> queryBpAntiqueByCondition(Pagination page, BpAntique record, SysUser sysUser);
	/**
	 * 根据id查询一条文物信息
	 * @param antiqueId
	 * @return
	 */
	BpAntique queryBpAntiqueById(String antiqueId);
	/**
	 * 根据id逻辑删除文物
	 * @param antiqueId
	 * @param sysUser
	 * @return
	 */
	int deleteBpAntique(String antiqueId,SysUser sysUser);
	/**
	 * 根据id上架/下架文物
	 * @param antiqueId
	 * @param sysUser
	 * @return
	 */
	int removeBpAntique(String antiqueId,String antiqueIsDel, SysUser sysUser);
	/**
	 * 修改文物信息
	 * @param record
	 * @param sysUser
	 * @return
	 */
	int editbpAntique(BpAntique record, SysUser sysUser);

}
