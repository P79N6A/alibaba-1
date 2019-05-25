//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.sun3d.why.service;

import com.sun3d.why.model.CmsVenueSeat;

import java.util.List;
import java.util.Map;

public interface CmsVenueSeatService {

	/**
	 * 根据场馆座位ID查询单条座位信息
	 * @param venueSeatId
	 * @return
	 */
	CmsVenueSeat queryVenueSeatById(String venueSeatId);

	/**
	 * 根据分页信息、带条件查询场馆座位数据信息
	 * @param CmsVenueSeat
	 * @return
	 */
	List<CmsVenueSeat> queryCmsVenueSeatByCondition(CmsVenueSeat CmsVenueSeat);

	/**
	 * 场馆座位条数
	 * @param map
	 * @return int 条数
	 */
	int queryCmsVenueSeatCountByCondition(Map<String, Object> map);

	/**
	 * 添加场馆座位信息
	 * @param cmsVenueSeat
	 * @return
	 */
	int addVenueSeat(CmsVenueSeat cmsVenueSeat);

	/**
	 * 更新场馆座位信息
	 * @param cmsVenueSeat
	 * @return
	 */
	int editVenueSeat(CmsVenueSeat cmsVenueSeat);

	/**
	 * 根据场馆座位状态查询特定的座位列表
	 * @param venueId
	 * @param venueStatus
	 * @return
	 */
	List<CmsVenueSeat> queryVenueSeatByStatus(String venueId,Integer venueStatus);

	/**
	 * 根据条件删除座位信息
	 * @param cmsVenueSeat
	 * @return
	 */
	int deleteVenueSeat(CmsVenueSeat cmsVenueSeat);
}
