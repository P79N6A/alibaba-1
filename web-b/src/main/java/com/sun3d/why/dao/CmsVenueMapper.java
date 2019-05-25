//
// Source code recreated from a .class file by IntelliJ IDEA
// (powered by Fernflower decompiler)
//

package com.sun3d.why.dao;

import com.sun3d.why.model.CmsVenue;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface CmsVenueMapper {
    //查询场馆所有的区域信息
	List<CmsVenue> queryVenueAllArea(Map map);

	int deleteVenueById(String var1);

	CmsVenue queryVenueById(String venueId);

	int updateStateByVenueIds(CmsVenue var1);

	int returnVenue(CmsVenue cmsVenue);

	List<Map<String, Object>> selectByExampleForList(HashMap<String, Object> var1);

	/*List<CmsVenue> queryBestWelcomeVenue(CmsVenueExample var1);*/

	/*int countBestWelcomeVenue(CmsVenueExample var1);*/


   //前台获取场馆数据
	List<CmsVenue> queryFrontVenueByCondition(Map<String, Object> var1);

	Integer queryFrontVenueCountByCondition(Map<String, Object> var1);
    //前台场馆显示详情时获取推荐场馆
	List<CmsVenue> queryCmsVenue(Map<String, Object> map);

	/**
	 * 前端2.0场馆收藏列表
	 * @param map
	 * @return 场馆对象集合
	 */
	List<CmsVenue> queryCollectVenue(Map<String, Object> map);

	/**
	 * 前端2.0场馆收藏个数
	 * @param map
	 * @return
	 */
	int queryCollectVenueCount(Map<String, Object> map);

	/**
	 * 场馆列表查询
	 * @param map
	 * @return 场馆对象集合
	 */
	List<CmsVenue> queryVenueByCondition(Map<String, Object> map);

	/**
	 * 场馆分页总条数
	 * @param map
	 * @return 条数
	 */
	int queryVenueCountByCondition(Map<String, Object> map);

	/**
	 * 前端场馆列表查询
	 * @param map
	 * @return 场馆对象集合
	 */
	List<CmsVenue> queryFrontCmsVenueByCondition(Map<String, Object> map);

	/**
	 * 前端场馆分页总条数
	 * @param map
	 * @return 条数
	 */
	int queryFrontCmsVenueCountByCondition(Map<String, Object> map);

	/**
	 * 前端详情内容属于什么类型的场馆(余进兵)
	 * @param map
	 * @return
	 */
	List<CmsVenue> queryFrontActivityByCondition(Map<String, Object> map);

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
	 * 按名称查询个数
	 * @param map
	 * @return
	 */
	int queryVenueCountByMap(Map<String, Object> map);

	List<Map> queryAllVenueByArea(Map map);


	/**
	 * 带条件查询符合的统计数据[平台内容统计--活动室统计]
	 * @param cmsVenue
	 * @return
	 */
	List<CmsVenue> queryVenueStatistic(CmsVenue cmsVenue);

	/**
	 * app根据条件筛选最近或最新展馆
	 * @param map
	 * @return
	 */
	List<CmsVenue> queryAppVenueListByCondition(Map<String, Object> map);

	/**
	 * app根据条件筛选展馆
	 * @param map
	 * @return
	 */
	List<CmsVenue> queryAppHotVenueListByCondition(Map<String, Object> map);

	/**
	 * app获取最近或最新筛选条数
	 * @param map
	 * @return
	 */
	int queryAppCountByCondition(Map<String, Object> map);

	/**
	 * app获取最热筛选条数
	 * @param map
	 * @return
	 */
	int queryAppHotCountByCondition(Map<String, Object> map);

	/**
	 * 后端3.0场馆评论管理列表
	 * @param map
	 * @return 场馆对象集合
	 */
	List<CmsVenue> queryVenueCommentByCondition(Map<String, Object> map);

	/**
	 * 后端3.0场馆评论管理条数
	 * @param map
	 * @return 条数
	 */
	int queryVenueCommentCountByCondition(Map<String, Object> map);


	List<CmsVenue> queryAppVenueAppByNum(Map<String, Object> map);

	/**
	 * app根据展馆id查询展馆信息
	 * @param venueId
	 * @return
	 */
	CmsVenue queryAppVenueById(String venueId);

	/**
	 *
	 * @Description:查询该场馆下有效的活动列表总数
	 * @author yanghui
	 * @Created 2015-10-19
	 * @param map
	 * @return
	 */
	int queryVenueOfActivityCountByVenueId(Map<String, Object> map);

	/**
	 * app查询活动列表数
	 * @param map
	 * @return
	 */
	int queryVenueAppByPageCount(Map<String, Object> map);

	/**
	 * app根据展馆id查询展馆详情
	 * @param map
	 * @return
	 */
	CmsVenue queryAppVenueDetailById(Map<String, Object> map);
	/**
	 * 
	 * @Description: 根据部门ID查询场馆
	 * @author yanghui 
	 * @Created 2015-11-2
	 * @param deptId
	 * @return
	 */
	CmsVenue queryVenueByVenueDeptId(String deptId);

	/**
	 * app根据活动室预定id获取展馆id
	 * @param bookId
	 * @return
	 */
	String queryVenueByBookId(String bookId);

	/**
	 * 根据场馆名称得到场馆的id
	 * @param venueName
	 * @return
	 */
	public CmsVenue queryVenueByVenueName(String venueName);


	/**
	 * 场馆列表查询按照置顶时间降序排序
	 * @param map
	 * @return 场馆对象集合
	 */
	List<CmsVenue> queryRecommendVenueByConditionList(Map<String, Object> map);

	/**
	 * 文化云3.1前端首页推荐场馆
	 * @param map
	 * @return
	 */
	List<CmsVenue> queryRecommendVenue(Map<String, Object> map);

	/**
	 * 前端页面显示关联的场馆
	 * @param map
	 * @return
	 */
	public List<CmsVenue> queryRelatedVenue(Map<String,Object> map);

	/**
	 * 前端页面显示关联的场馆数量
	 * @param map
	 * @return
	 */
	public int queryRelatedVenueCount(Map<String,Object> map);


	/**
	 * 场馆分页总条数
	 * @param map
	 * @return 条数
	 */
	int queryRecommendVenueCountByCondition(Map<String, Object> map);


	/**
	 * 取消或置顶场馆
	 * @param venueId
	 * @return
	 */
	 int canleRecommendVenue(String venueId);

	 String queryVenueScore(String venueId);

	/**
	 * why3.5 app根据条件筛选场馆
	 * @param map
	 * @return
	 */
	List<CmsVenue> queryAppVenueList(Map<String, Object> map);

	/**
	 * why3.5 app根据展馆id查询展馆详情
	 * @param map
	 * @return
	 */
	CmsVenue queryAppCmsVenueDetailById(Map<String, Object> map);

	/**
	 * why3.5 app根据条件筛选场馆(搜索功能)
	 * @param map
	 * @return
	 */
	List<CmsVenue> queryAppCmsVenueList(Map<String, Object> map);

	/**
	 * why3.5 app根据条件筛选场馆个数(搜索功能)
	 * @param map
	 * @return
	 */
	int queryAppCmsVenueListCount(Map<String, Object> map);

	/**
	 * why3.5 根据场馆id获取最新活动名称(为场馆列表服务)
	 * @param venueId
	 * @return
	 */
	String queryAppActivityNameByVenueId(String venueId);


	/**
	 * 关联场馆列表查询
	 * @param map
	 * @return 场馆对象集合
	 */
	List<CmsVenue> queryRelateVenueByCondition(Map<String, Object> map);

	List<CmsVenue> queryVenueByConditionFromCulturalOrder(CmsVenue venue);
}
