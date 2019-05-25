//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.sun3d.why.service;

import com.sun3d.why.model.*;
import com.sun3d.why.model.extmodel.AreaData;
import com.sun3d.why.model.league.CmsMemberBO;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.PaginationApp;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface CmsVenueService {

	/**
	 * 查询场馆所有的区域信息
	 * @return 场馆区域信息列表
	 */
	List<AreaData> queryVenueAllArea();


	/**
	 * 查询场馆所有的类型信息
	 * @return 场馆类型信息列表
	 */
	List<AreaData> queryVenueAllType(String venueArea);

	/**
	 *  根据场馆区域id和场馆类型查询场馆名称
	 * @param areaId  区域id
	 * @param type  场馆类型
	 * @param sysUser 用户对象
	 * @return 场馆信息
	 */
	List<AreaData> queryVenueNameByAreaAndType(String areaId,String type, SysUser sysUser);

	int deleteVenueById(String var1);

	/**
	 * 根据场馆ID查询场馆信息
	 * @param venueId
	 * @return
	 */
	CmsVenue queryVenueById(String venueId);

	int updateStateByVenueIds(String venueId,String userId);

	int returnVenueByIds(String venueId,String sysNo);

	List<Map<String, Object>> selectByExampleForList(HashMap<String, Object> var1);


	/**
	 * 场馆列表
	 * @param venue
	 * @param page
	 * @param pageApp
	 * @return 场馆对象列表
	 */
	List<CmsVenue> queryVenueByCondition(CmsVenue venue, Pagination page, PaginationApp pageApp, String userDeptPath);

	/**
	 * 前端场馆列表查询
	 * @param venue
	 * @param page
	 * @return 场馆对象列表
	 */
	List<CmsVenue> queryFrontCmsVenueByCondition(CmsVenue venue, Pagination page);


	/**
	 * 场馆列表
	 * @param venue
	 * @param page
	 * @return 场馆对象列表
	 */
	List<CmsVenue> queryVenueByConditionSort(CmsVenue venue, Pagination page);


	/**
	 * 前端场馆列表
	 * @param var1
	 * @param var2
	 * @return 场馆对象集合
	 */
	List<CmsVenue> queryFrontVenueByCondition(CmsVenue var1, Pagination var2);

	Integer queryFrontVenueCountByCondition(Map<String, Object> var1);

	List<CmsVenue> queryFrontVenueByCondition(Map<String, Object> map);

	/**
	 *
	 * 前台场馆详情显示相关场馆推荐
	 * @param cmsVenue
	 * @param page
	 * @return
	 */
	List<CmsVenue> queryCmsVenue(CmsVenue cmsVenue, Pagination page);


	/**
	 * 前端2.0场馆收藏列表
	 * @param user 会员对象
	 * @param venueName 场馆名称
	 * @return 场馆对象集合
	 */
	List<CmsVenue> queryCollectVenue(CmsTerminalUser user, Pagination page, String venueName);

	/**
	 * 前端2.0场馆收藏个数
	 * @param map
	 * @return
	 */
	int queryCollectVenueCount(Map<String, Object> map);

	/**
	 * 前台场馆详情显示推荐馆藏
	 * @param cmsAntique
	 * @param page
	 * @return
	 */
	List<CmsAntique> queryCmsAntique(CmsAntique cmsAntique, Pagination page);

	/**
	 * 场馆条数
	 * @param var1
	 * @return int 条数
	 */
	int queryVenueCountByCondition(Map<String, Object> var1);

	/**
	 * 前端详情内容属于什么类型的场馆(余进兵)
	 * @param venue
	 * @param page 分页
	 * @return
	 */
	List<CmsVenue> queryFrontActivityByCondition(CmsVenue venue,Pagination page);

	/**
	 * 添加场馆
	 * @param venue
	 * @return
	 */
	int addVenue(CmsVenue venue);

	/**
	 * 根据id更新场馆
	 * @param venue
	 * @return
	 */
	int editVenueById(CmsVenue venue);

	/**
	 * 根据id更新场馆
	 * @param venue
	 * @return
	 */
	int editVenueByVenueId(CmsVenue venue);

	/**
	 *  新增和修改场馆时的业务逻辑
	 * @param venue
	 * @return success:成功 failure:失败  repeat:重复
	 */
	int saveVenue(CmsVenue venue, SysUser sysUser);

	/**
	 *
	 * @param user
	 * @param venueId
	 * @param userDeptPath
	 * @param userId
	 * @return success:成功 failure:失败
	 */
	String saveAssignManager(SysUser user,String venueId, String userDeptPath, String userId);

	/**
	 * 得到小时(0-23的数字)
	 * @return
	 */
	String venueHours();

	/**
	 * 得到分钟(0，15，30，45的数字)
	 * @return
	 */
	String venueMin();


	/**
	 * 带条件查询符合的统计数据[平台内容统计--场馆统计]
	 * @param cmsVenue
	 * @return
	 */
	List<CmsVenue> queryVenueStatistic(CmsVenue cmsVenue);






	
	/**
	 * 根据子系统的id查询场所信息
	 * @param sysId 子系统ID
	 * @return
	 */
	public CmsVenue queryVenueByKey(String sysId);

	/**
	 * 后端3.0场馆评论管理列表
	 * @param venue
	 * @param page
	 * @return 场馆对象集合
	 */
	List<CmsVenue> queryVenueCommentByCondition(CmsVenue venue,Pagination page, String userDeptPath);

	/**
	 * 后端3.0场馆评论管理 所属区县
	 * @param venue
	 * @return 场馆对象集合
	 */
	List<CmsVenue> queryVenueCommentExitArea(CmsVenue venue,String userDeptPath);


	/**
	 * 
	 * @Description: 查询场馆下有效活动的总数
	 * @author yanghui 
	 * @Created 2015-10-19
	 * @return
	 */
	int queryVenueOfActivityCountByVenueId(Map<String, Object> map);


	SysDept saveDept(CmsVenue venue, SysUser sysUser);

	/**
	 * 根据部门ID查询场馆信息
	 * @param venueDeptId
	 * @return
	 */
	CmsVenue queryVenueByVenueDeptId(String venueDeptId);

	/**
	 * 根据场馆名称得到场馆的id
	 * @param venueName
	 * @return
	 */
	public CmsVenue queryVenueByVenueName(String venueName);


	/**
	 * 场馆推荐
	 * @param venue
	 * @param page
	 * @param pageApp
	 * @return 场馆对象列表
	 */
	List<CmsVenue> queryRecommendVenueByConditionList(CmsVenue venue, Pagination page, PaginationApp pageApp, String userDeptPath);

	/**
	 * 文化云3.1前端首页推荐场馆
	 * @param venue
	 * @param page
	 * @return
	 */
	List<CmsVenue> queryRecommendVenue(CmsVenue venue, Pagination page);

	/**
	 * 前端页面显示关联的场馆
	 * @param record 活动室查询条件
	 * @param excludeFlag 是否排除自己的标记
	 * @return
	 */
	public List<CmsVenue> queryRelatedVenue(CmsVenue record,boolean excludeFlag);

	/**
	 * 前端页面显示关联的场馆数量
	 * @param record 活动室查询条件
	 * @param excludeFlag 是否排除自己的标记
	 * @return
	 */
	public int queryRelatedVenueCount(CmsVenue record,boolean excludeFlag);

	public int canleRecommendVenue(String id);


	String queryVenueScore(String venueId);
	
	List<CmsVenue> queryVenueByAreaName(String areaName);


	List<CmsVenue> pcnewVenue(int i);

	List<CmsVenue> queryVenueUnion(String member,Integer count);

	List<CmsVenue> queryVenueByMember(CmsMemberBO bo);
}
