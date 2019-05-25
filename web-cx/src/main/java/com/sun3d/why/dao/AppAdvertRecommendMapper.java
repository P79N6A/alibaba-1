package com.sun3d.why.dao;

import com.sun3d.why.model.AppAdvertRecommend;
import java.util.List;
import java.util.Map;

import java.util.List;
import java.util.Map;

public interface AppAdvertRecommendMapper {
    int deleteByPrimaryKey(String advertId);

    /**
     * 根据传入的map查询活动列表信息
     * @param map  查询条件
     * @return 活动列表信息
     */
    List<AppAdvertRecommend> selectAdvertIndex(Map<String, Object> map);
    /**
     * 根据广告sql语句示例条件查询符合的信息总数，一般分页功能的时候需要用到该方法
     *
     * @param map 带查询条件的map集合
     * @return int 查询结果总数
     */
    int selectAdvertCount(Map<String,Object> map);


    /**
     * 根据广告主键id查询模块信息
     *
     * @param advertId String 广告主键id
     * @return CmsAdvert 广告模型
     */
    AppAdvertRecommend selectAdvertById(String advertId);
    /**
     * 根据广告主键id来更新模块信息，不判断是否字段为空，更新所有字段
     *
     * @param record CmsAdvert 模块模型
     * @return int 执行结果 1：成功 0：失败
     */
    int editAdvert(AppAdvertRecommend record);
    /**
     * 新增一条广告信息记录，该方法需要填入全部属性
     *
     * @param record CmsAdvert 广告模型
     * @return int 执行结果 1：成功 0：失败
     */
    int addAdvert(AppAdvertRecommend record);

    /**
     * why3.5 app查询广告位列表
     * @param map
     * @return
     */
    List<AppAdvertRecommend> queryAppAdvertRecommendList(Map<String, Object> map);
}