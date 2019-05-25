package com.sun3d.why.statistics.service;

import com.sun3d.why.model.CmsCultureUserStatistcs;
import com.sun3d.why.model.CmsStatistics;

import java.text.ParseException;
import java.util.List;

/**
 * Created by Administrator on 2015/8/15.
 */
public interface StatisticCultureUserService {
    /**
     * app用户收藏非遗
     * @param cultureUserStatistcs
     * @param userId
     * @return
     */
    int addAppCultureUserStatistics(CmsCultureUserStatistcs cultureUserStatistcs, String userId);

    /**
     * app取消用户收藏非遗
     * @param cultureUserStatistcs
     * @return
     */
    int deleteCultureUser(CmsCultureUserStatistcs cultureUserStatistcs);

    int addCultureUserStatistics(CmsCultureUserStatistcs cultureUserStatistcs);

    /**
     * 查询非遗用户是否有数据
     * @param id 非遗id
     * @param operateType 操作类型
     * @param ipAddress ip地址
     * @param userId 用户id
     * @param status 用户类型
     * @return
     */
    int cultureUserByCount(String id, Integer operateType, String ipAddress, String userId, Integer status);

    /**
     * 查询非遗
     * @param queryType
     * @return
     */
    List<CmsStatistics> queryCultureStatisticsByType(String queryType) throws ParseException;
}
