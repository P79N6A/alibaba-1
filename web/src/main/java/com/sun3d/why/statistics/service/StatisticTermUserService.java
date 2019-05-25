package com.sun3d.why.statistics.service;

import com.sun3d.why.model.CmsCollect;
import com.sun3d.why.model.CmsStatistics;
import com.sun3d.why.model.CmsTeamUserStatistics;

import java.text.ParseException;
import java.util.List;

/**
 * Created by Administrator on 2015/5/8.
 * 团体游客明细表
 */
public interface StatisticTermUserService {

  //  int countByExample(CmsTeamUserStatisticsExample example);

  //  void insertSelective(CmsTeamUserStatistics cmsTeamUserStatistics);
 //根据时间类型查询团体游客关系数据
    public   List<CmsStatistics> queryTeamStatisticsByType(String queryType) throws ParseException;

 //   List<CmsTeamUserStatistics> selectByExample(CmsTeamUserStatisticsExample example);

    public void deleteTermUser(CmsCollect cmsCollect);

    /**
     * 查询团队用户数据
     * @param tuserId  团队id
     * @param operateType  操作类型
     * @param remortIp   页面ip
     * @param userId   用户id
     * @param status    用户查询 1.游客   2.用户
     * @return
     */
    int termUserCountByCondition(String tuserId, Integer operateType, String remortIp, String userId, Integer status) throws ParseException;

    /**
     * 添加团体用户数据
     * @param cmsTeamUserStatistics 团体用户对象
     */
    int addTermUserStatistics(CmsTeamUserStatistics cmsTeamUserStatistics);

    /**
     * app添加团体收藏
     * @param teamUserStatistics
     * @param userId
     */
    int addAppTeamUserStatistics(CmsTeamUserStatistics teamUserStatistics, String userId);

    /**
     * app取消收藏团体
     * @param teamUserStatistics
     * @return
     */
    int deleteTeamUser(CmsTeamUserStatistics teamUserStatistics);


}
