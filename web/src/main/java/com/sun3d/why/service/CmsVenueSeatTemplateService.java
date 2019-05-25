//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.sun3d.why.service;

import com.sun3d.why.model.CmsVenueSeatTemplate;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

import java.util.List;

public interface CmsVenueSeatTemplateService {

	/**
	 * 根据模板ID删除对应的场馆座位模板记录
	 * @param templateId 模板ID
	 * @return
	 */
	int deleteVenueSeatTemplateById(String templateId);

	/**
	 * 添加场馆座位模板记录
	 * @param record 场馆座位模板信息
	 * @return
	 */
	int addCmsVenueSeatTemplate(CmsVenueSeatTemplate record);

	/**
	 * 根据场馆座位模板ID查询单条场馆座位模板记录
	 * @param templateId 场馆模板ID
	 * @return
	 */
	CmsVenueSeatTemplate queryVenueSeatTemplateById(String templateId);

	/**
	 * 编辑场馆座位模板记录
	 * @param record 场馆座位模板信息
	 * @return
	 */
	int editCmsVenueSeatTemplate(CmsVenueSeatTemplate record);

	/**
	 * 将场馆座位模板对象作为条件查询符合条件的所有场馆座位模板
	 * @param cmsVenueSeatTemplate 场馆模板信息
	 * @return
	 */
	List<CmsVenueSeatTemplate> queryVenueSeatTemplateByCondition(CmsVenueSeatTemplate cmsVenueSeatTemplate,Pagination page);

	/**
	 * 将场馆座位模板对象作为条件查询符合条件的所有场馆座位模板总记录数
	 * @param cmsVenueSeatTemplate 场馆模板信息
	 * @return
	 */
	int queryVenueSeatTemplateCountByCondition(CmsVenueSeatTemplate cmsVenueSeatTemplate);

	/**
	 * 保存场馆座位模板信息并保存场馆模板座位数据
	 * @param cmsVenueSeatTemplate 场馆模板信息
	 * @param sysUser 操作用户信息
	 * @param seatIds 场馆座位状态与Code组成的字符串
	 * @return
	 */
	boolean addVenueSeatTemplate(final CmsVenueSeatTemplate cmsVenueSeatTemplate,final SysUser sysUser,final String seatIds);




	/**
	 * 保存场馆座位模板信息并保存场馆模板座位数据
	 * @param cmsVenueSeatTemplate 场馆模板信息
	 * @param sysUser 操作用户信息
	 * @param seatIds 场馆座位状态与Code组成的字符串
	 * @return
	 */
	boolean addVenueSeatTemplate2(CmsVenueSeatTemplate cmsVenueSeatTemplate,SysUser sysUser,String seatIds);


	/**
	 * 编辑场馆座位模板信息并保存场馆模板座位数据
	 * @param cmsVenueSeatTemplate 场馆模板信息
	 * @param sysUser 操作用户信息
	 * @param seatIds 场馆座位状态与Code组成的字符串
	 * @return
	 */
	boolean editVenueSeatTemplate(final CmsVenueSeatTemplate cmsVenueSeatTemplate,final SysUser sysUser,final String seatIds);
}
