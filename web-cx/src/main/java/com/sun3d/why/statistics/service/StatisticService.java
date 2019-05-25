package com.sun3d.why.statistics.service;

import com.sun3d.why.model.CmsStatistics;

public interface StatisticService {
	/**
     * 新增一条统计信息表记录，
     *
     * @param cmsStatistics 统计对象
     * @return int 执行结果 1：成功 0：失败
     */
public	int addCmsStatisticByCondition(CmsStatistics cmsStatistics);

/**
 * 更新统计表中的记录
 * @param cmsStatistics
 * @return  data
 */
public int editCmsStatisticByCondition(CmsStatistics cmsStatistics);
	/**
	 * 查询表中是否有数据
	 * @param sId
	 * @return
	 */
	int cmsStatisticCountById(String sId);

//	int updateByPrimaryKeySelective(CmsStatistics cmsStatistics1);
	/**
	 * 根据统计表对象查询统计表中的记录
	 * @param sId
	 * @return
	 */
	CmsStatistics selectByPrimaryKey(String sId);

	/**
	 * 前端2.0 根据id和type查询收藏量和浏览量
	 * @param sId
	 * @param sType
	 * @return 统计表对象
	 */
	CmsStatistics queryStatistics(String sId,int sType);
}
