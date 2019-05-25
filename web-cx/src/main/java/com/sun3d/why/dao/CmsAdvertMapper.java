package com.sun3d.why.dao;

import com.sun3d.why.model.CmsAdvert;
import com.sun3d.why.util.Pagination;

import java.util.List;
import java.util.Map;

public interface CmsAdvertMapper {
    /**
     * 根据广告sql语句示例条件查询符合的信息总数，一般分页功能的时候需要用到该方法
     *
     * @param map 带查询条件的map集合
     * @return int 查询结果总数
     */
    int queryCmsAdvertCountByCondition(Map<String,Object> map);

    /**
     * 新增一条广告信息记录，该方法需要填入全部属性
     *
     * @param record CmsAdvert 广告模型
     * @return int 执行结果 1：成功 0：失败
     */
    int addCmsAdvert(CmsAdvert record);

    /**
     * 根据广告sql语句示例来更新符合的数据，不包涵团队描述字段
     *
     * @param map Map 带条件查询map集合
     * @return List<CmsAdvert> 广告模型集合
     */
    List<CmsAdvert> queryCmsAdvertByCondition(Map<String,Object> map);

    /**
     * 根据广告主键id查询模块信息
     *
     * @param advertId String 广告主键id
     * @return CmsAdvert 广告模型
     */
    CmsAdvert queryCmsAdvertById(String advertId);

    /**
     * 根据广告主键id来更新模块信息，不判断是否字段为空，更新所有字段
     *
     * @param record CmsAdvert 模块模型
     * @return int 执行结果 1：成功 0：失败
     */
    int editCmsAdvert(CmsAdvert record);

    /**
     *  根据广告中的站点、栏目以及版位查找最大的顺序
     * @param cmsAdvert
     * @return
     */
    Integer queryMaxAdvertPosSort(CmsAdvert cmsAdvert);

    /**
     * 根据站点名称以及栏目名称查询对应的广告信息列表
     * @param map
     * @return
     */
    List<CmsAdvert> queryAdvertByName(Map<String,Object> map);

    /**
     * 查询条数
     * @param map
     * @return
     */
    int queryAdvertPositionCount(Map<String,Object> map);

    /**
     * 根据站点名称以及栏目名称查询对应的广告信息列表
     * @param
     * @param map
     * @return
     */
    List<CmsAdvert> queryAdvertBySite( Map<String , Object> map);

    /**
     * 通过传递过来的站点和插入的位置,搜索并判断是否还正常写入
     * @param map
     * @return
     */
    List<CmsAdvert> queryAdvertSitePosition(Map<String , Object> map);

    /**
     * app获取轮播图无限制张数
     * @return
     */
    List<CmsAdvert> queryAppAdvertBySite(int type);

    //重新上线时看当前位置是否有已存在数据
    int queryExistSort(CmsAdvert advert);


    /**
     * 查询热点推荐列表
     *
     *
     * @param map
     * @return List<CmsAdvert> 广告信息列表
     */
    List<CmsAdvert> queryRecommendCmsAdvertByList(Map<String,Object> map);

    /**
     * 根据广告主键id来更新模块信息，不判断是否字段为空，更新所有字段
     *
     * @param record CmsAdvert 模块模型
     * @return int 执行结果 1：成功 0：失败
     */
    int editRecommendCmsAdvert(CmsAdvert record);

    /**
     *  app端轮播图List
     *
     * @param map Map 带条件查询map集合
     * @return List<CmsAdvert> 广告模型集合
     */
    List<CmsAdvert> appRecommendadvertlist(Map<String,Object> map);

    /**
     * 文化云3.1前端首页热点推荐
     * @param map
     * @return
     */
    List<CmsAdvert> queryHotelRecommendAdvert(Map<String, Object> map);


    /**
     * 根据广告sql语句示例条件查询符合的信息总数，一般分页功能的时候需要用到该方法
     *
     * @param map 带查询条件的map集合
     * @return int 查询热点推荐结果总数
     */
    int queryRecommendCmsAdvertCountByCondition(Map<String,Object> map);
}