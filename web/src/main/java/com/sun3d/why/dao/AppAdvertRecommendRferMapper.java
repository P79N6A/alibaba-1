package com.sun3d.why.dao;

import com.sun3d.why.model.AppAdvertRecommendRfer;

import java.util.List;
import java.util.Map;

public interface AppAdvertRecommendRferMapper {

    int insertSelective(AppAdvertRecommendRfer record);
    /**
     * 根据广告主键id来更新模块信息，不判断是否字段为空，更新所有字段
     *
     * @param record CmsAdvert 模块模型
     * @return int 执行结果 1：成功 0：失败
     */
    int editAdvertRfer(AppAdvertRecommendRfer record);
    /**
     * 新增一条广告信息记录，该方法需要填入全部属性
     *
     * @param record CmsAdvert 广告模型
     * @return int 执行结果 1：成功 0：失败
     */
    int addAdvertRfer(AppAdvertRecommendRfer record);
    /**
     * 根据传入的map查询活动列表信息
     * @return 活动列表信息
     */
    List<AppAdvertRecommendRfer> selectAdvertIndex(String advertReferId);
   int  delete(String advertReferId);
}