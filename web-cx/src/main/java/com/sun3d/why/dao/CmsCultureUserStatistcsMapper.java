package com.sun3d.why.dao;
import com.sun3d.why.model.CmsCultureUserStatistcs;

import java.util.Date;
import java.util.List;
import java.util.Map;

public interface CmsCultureUserStatistcsMapper {



    /**
     * app用户收藏非遗
     * @param cultureUserStatistcs
     * @return
     */
    int addCultureUserStatistics(CmsCultureUserStatistcs cultureUserStatistcs);
    /**
     * app取消用户收藏非遗
     * @param cultureUserStatistcs
     * @return
     */
    int deleteCultureUser(CmsCultureUserStatistcs cultureUserStatistcs);

    /**
     * 查询非遗是否有数据
     * @param map
     * @return
     */
    int cultureUserByCount(Map<String, Object> map);

    /**
     * 查询本周非遗数据
     * @param startDate
     * @param endDate
     * @return
     */
    List<CmsCultureUserStatistcs> queryCultureUserStatisticsByWeekDate(Date startDate, Date endDate);
}