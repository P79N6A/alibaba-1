package com.sun3d.why.service;

import com.sun3d.why.model.CmsAdvert;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

import java.util.List;
import java.util.Map;

/**
 * <p>
 * 团队用户管理服务层service接口
 * <p/>
 * Created by cj on 2015/4/23.
 */
public interface CmsAdvertService {
    /**
     * 根据团队会员sql语句示例条件查询符合的信息总数，一般分页功能的时候需要用到该方法
     *
     * @param map Map 带查询条件的map集合
     * @return int 查询结果总数
     */
    int queryCmsAdvertCountByCondition(Map<String,Object> map);

    /**
     * 根据团队会员sql语句示例来更新符合的数据，不包涵团队描述字段
     *
     * @param record CmsAdvert 广告信息
     * @param page Pagination 分页信息
     * @return List<CmsAdvert> 广告信息列表
     */
    List<CmsAdvert> queryCmsAdvertByCondition(CmsAdvert record,Pagination page);

    /**
     * 根据团队会员主键id查询模块信息
     *
     * @param tuserId String 团队会员主键id
     * @return CmsAdvert 广告信息
     */
    CmsAdvert queryCmsAdvertById(String tuserId);

    /**
     * 新增一条团队会员信息记录，该方法需要填入全部属性
     *
     * @param record CmsAdvert 团队会员模型
     * @param sysUser SysUser 用户信息
     * @return int 执行结果 1：成功 0：失败
     */
    int addCmsAdvert(CmsAdvert record,SysUser sysUser);

    /**
     * 根据团队会员主键id来更新模块信息，更新所有属性字段，包涵团队会延缓描述
     *
     * @param record CmsAdvert 模块模型
     * @param sysUser SysUser 用户信息
     * @return int 执行结果 1：成功 0：失败
     */
    int editCmsAdvert(CmsAdvert record,SysUser sysUser);

    /**
     * 根据团队会员主键id来更新模块信息，更新所有属性字段，包涵团队会延缓描述
     *
     * @param record CmsAdvert 模块模型
     * @param sysUser SysUser 用户信息
     * @return int 执行结果 1：成功 0：失败
     */
    int deleteCmsAdvert(CmsAdvert record,SysUser sysUser);

    /**
     *  根据广告中的站点、栏目以及版位查找最大的顺序
     * @param cmsAdvert 广告信息
     * @return 最大版位
     */
    Integer queryMaxAdvertPosSort(CmsAdvert cmsAdvert);

    /**
     * 根据站点名称以及栏目名称查询对应的广告信息列表
     * @param siteName 网站名称
     * @param columnName 栏目名称
     * @return 广告列表
     */
    List<CmsAdvert> queryAdvertByName(String siteName,String columnName);

    /**
     * 根据站点名称以及栏目名称查询对应的广告信息列表
     *
     * @param siteId 区县id
     * @return 广告列表
     */
    List<CmsAdvert> queryAdvertBySite(String siteId, String displayPositions);

    /**
     *  通过传递过来的信息获取 版位图片的顺序
     * @param record
     * @return
     */
    List<CmsAdvert> queryAdvertSitePosition(CmsAdvert record);


    String  recoveryCmsAdvert(String id,SysUser sysUser);
    String deleteCmsAdvert(String id,SysUser sysUser);

    int queryExistSort(CmsAdvert advert);



    /**
     * 查询热点推荐列表
     *
     * @param record CmsAdvert 广告信息
     * @param page Pagination 分页信息
     * @return List<CmsAdvert> 广告信息列表
     */
    List<CmsAdvert> queryRecommendCmsAdvertByList(CmsAdvert record,Pagination page);


    public int addRecommendCmsAdvert(CmsAdvert record,SysUser sysUser);

    public int editRecommendCmsAdvert(CmsAdvert record,SysUser sysUser);

    /**
     * app端轮播图管理Lis
     *
     * @param record CmsAdvert 广告信息
     * @param page Pagination 分页信息
     * @return List<CmsAdvert> 广告信息列表
     */
    List<CmsAdvert> appRecommendadvertlist(CmsAdvert record,Pagination page);

    /**
     * 文化云3.1前端首页热点推荐
     * @param page
     * @return
     */
    List<CmsAdvert> queryHotelRecommendAdvert(Pagination page);


    /**
     * 根据团队会员sql语句示例条件查询符合的信息总数，一般分页功能的时候需要用到该方法
     *
     * @param map Map 带查询条件的map集合
     * @return int 查询热点推荐结果总数
     */
    int queryRecommendCmsAdvertCountByCondition(Map<String,Object> map);
}
