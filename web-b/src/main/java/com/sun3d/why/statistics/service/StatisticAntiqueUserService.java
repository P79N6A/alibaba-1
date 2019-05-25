package com.sun3d.why.statistics.service;

import com.sun3d.why.model.AntiqueUserStatistics;
import com.sun3d.why.model.CmsStatistics;

import java.text.ParseException;
import java.util.List;

/**
 * Created by Administrator on 2015/5/7.
 * 藏品明细表管理
 */
public interface StatisticAntiqueUserService {
    //根据时间进行藏品用户表进行统计
    List<CmsStatistics> queryAntiqueStatisticsByType(String queryType) throws ParseException;


 //   void insertSelective(AntiqueUserStatistics antiqueUserStatistics);

  //  int countByExample(AntiqueUserStatisticsExample example);

    int deleteAntiqueUser(AntiqueUserStatistics antiqueUserStatistics);

    /**
     * 查询藏品用户数据
     * @param antiqueId  藏品id
     * @param operateType  操作类型
     * @param remortIp   页面ip
     * @param userId    用户id
     * @param status   用户查询 1.游客   2.用户
     * @return
     */
    int antiqueUserCountByCondition(String antiqueId, Integer operateType, String remortIp, String userId, Integer status) throws ParseException;

    /**
     * 添加藏品用户信息数据
     * @param antiqueUserStatistics
     */
    int addAntiqueUserStatistics(AntiqueUserStatistics antiqueUserStatistics);
}
