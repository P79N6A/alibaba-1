package com.sun3d.why.service;


import com.sun3d.why.model.AppAdvertRecommend;
import com.sun3d.why.model.AppAdvertRecommendRfer;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.util.Pagination;

import java.util.List;

public interface AppAdvertRecommendService {
    /**
     * 保存活动信息
     * 验证活动名称不能重复
     *
     * @param appadvertrecommend 广告对象
     * @return failure 失败,success 成功 ,repeat 活动名称重复
     */
    String addAdvert(AppAdvertRecommend appadvertrecommend, SysUser user);
    /**
     * 根据团队会员sql语句示例来更新符合的数据，不包涵团队描述字段
     *
     * @param record AppAdvertRecommend 广告信息
     * @param page Pagination 分页信息
     * @return List<CmsAdvert> 广告信息列表
     */
    List<AppAdvertRecommend> queryCmsAdvertByCondition(AppAdvertRecommend record, Pagination page);
    /**
     * 根据团队会员主键id查询模块信息
     *
     * @param tuserId String 团队会员主键id
     * @return CmsAdvert 广告信息
     */
    AppAdvertRecommend selectAdvertById(String tuserId);
    /**
     * 根据团队会员sql语句示例来更新符合的数据，不包涵团队描述字段
     *
     * @param record AppAdvertRecommendRfer 广告信息
     * @return List<CmsAdvert> 广告信息列表
     */
    List<AppAdvertRecommendRfer> queryAdvertRecommendRferCondition(AppAdvertRecommendRfer record);
    /**
     * 根据团队会员主键id查询模块信息
     *
     * @param tuserId String 团队会员主键id
     * @return CmsAdvert 广告信息
     */
    String deletedvertById(String tuserId);
}
