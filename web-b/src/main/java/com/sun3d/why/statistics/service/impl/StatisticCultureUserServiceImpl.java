package com.sun3d.why.statistics.service.impl;

import com.sun3d.why.dao.CmsCultureUserStatistcsMapper;
import com.sun3d.why.dao.CmsTerminalUserMapper;
import com.sun3d.why.model.CmsCultureUserStatistcs;
import com.sun3d.why.model.CmsStatistics;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.statistics.service.StatisticCultureUserService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.TimeUtil;
import com.sun3d.why.util.UUIDUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * Created by Administrator on 2015/8/15.
 */
@Service
@Transactional
public class StatisticCultureUserServiceImpl implements StatisticCultureUserService {
    @Autowired
    private CmsTerminalUserMapper userMapper;
    @Autowired
    private CmsCultureUserStatistcsMapper cmsCultureUserStatistcsMapper;
    /**
     * app添加非遗用户收藏
     * @param teamUserStatistics
     * @param userId
     */
    @Override
    public int addAppCultureUserStatistics(CmsCultureUserStatistcs cultureUserStatistcs, String userId) {
        cultureUserStatistcs.setId(UUIDUtils.createUUId());
        CmsTerminalUser terminalUser=userMapper.queryTerminalUserById(userId);
        if(terminalUser!=null) {
            cultureUserStatistcs.setUserId(userId);
            cultureUserStatistcs.setStatus(Constant.STATIS2);
            cultureUserStatistcs.setCreateUser(terminalUser.getUserName());
            cultureUserStatistcs.setUpdateUser(terminalUser.getUserName());
            cultureUserStatistcs.setCreateTime(new Timestamp(System.currentTimeMillis()));
            cultureUserStatistcs.setUpdateTime(new Timestamp(System.currentTimeMillis()));
            return cmsCultureUserStatistcsMapper.addCultureUserStatistics(cultureUserStatistcs);
        }else {
            return 0;
        }
    }

    @Override
    public int deleteCultureUser(CmsCultureUserStatistcs cultureUserStatistcs) {
        return cmsCultureUserStatistcsMapper.deleteCultureUser(cultureUserStatistcs);
    }

    @Override
    public int addCultureUserStatistics(CmsCultureUserStatistcs cultureUserStatistcs) {
        return cmsCultureUserStatistcsMapper.addCultureUserStatistics(cultureUserStatistcs);
    }

    /**
     * 查询用户非遗中是否有数据
     * @param id 非遗id
     * @param operateType 操作类型
     * @param ipAddress ip地址
     * @param userId 用户id
     * @param status 用户类型
     * @return
     */
    @Override
    public int cultureUserByCount(String id, Integer operateType, String ipAddress, String userId, Integer status) {
        Map<String, Object> map = new HashMap<String, Object>();
        if (operateType!=null) {
            map.put("operateType", operateType);
        }
        if(id!=null && StringUtils.isNotBlank(id)){
            map.put("cultureId",id);
        }
        if(userId!=null && StringUtils.isNotBlank(userId)){
            map.put("userId", userId);
        }
        if(StringUtils.isNotBlank(ipAddress)){
            map.put("ip",ipAddress);
        }
        map.put("startDate", TimeUtil.getTimesmorning());
        map.put("endDate",TimeUtil.getTimesnight());
        //用户查询 1.游客   2.用户
        map.put("status",status);
        return cmsCultureUserStatistcsMapper.cultureUserByCount(map);
    }

    @Override
    public List<CmsStatistics> queryCultureStatisticsByType(String queryType) throws ParseException {
        List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
        Date startDate = null;
        Date endDate = null;
      //  DateFormat fmt = new SimpleDateFormat("yyyy-MM");
        Calendar cal = Calendar.getInstance();
        int year;
        year = cal.get(Calendar.YEAR);
        if (queryType.equals("week")) {
            // 得到本周第一天
            int date = cal.get(Calendar.DAY_OF_WEEK);
            if (date == 1) {
                endDate = cal.getTime();
                cal.add(Calendar.DAY_OF_WEEK, -6);
                startDate = cal.getTime();
            } else {
                cal.set(Calendar.DAY_OF_WEEK, Calendar.MONDAY);
                startDate = cal.getTime();
                cal.add(Calendar.DAY_OF_WEEK, 6);
                endDate = cal.getTime();
            }
            List<CmsCultureUserStatistcs> data = cmsCultureUserStatistcsMapper.queryCultureUserStatisticsByWeekDate(startDate, endDate);
            //统计表中添加一周的数据
            cmsStatisticsList=getWeekStatistics(data);
        } else if (queryType.equals("month")) {
            DateFormat fmt = new SimpleDateFormat("yyyy-MM");
            //根据月进行统计
            String startMonthDate;
            String endMonthDate;
            int month = cal.get(Calendar.MONTH); // 上个月月份
            int month2 = cal.get(Calendar.MONTH) + 1;//当前月份
            startMonthDate = year + "-" + (month < 10 ? "0" + month : month);
            endMonthDate = year + "-" + (month2 < 10 ? "0" + month2 : month2);
            startDate = fmt.parse(startMonthDate);
            endDate = fmt.parse(endMonthDate);
            List<CmsCultureUserStatistcs> data = cmsCultureUserStatistcsMapper.queryCultureUserStatisticsByWeekDate(startDate, endDate);
            //统计表中添加月数据
            cmsStatisticsList=getMonthStatistics(data);
        }
        else if(queryType.equals("oneQuarter")){
            DateFormat fmt = new SimpleDateFormat("yyyy-MM-dd");
            //第一季度 当前年份
            String startOneMonthDate;
            String endOneMonthDate;
            startOneMonthDate = year + "-" + "01-01";
            endOneMonthDate = year + "-" + "03-31";
            startDate = fmt.parse(startOneMonthDate);
            endDate = fmt.parse(endOneMonthDate);
            List<CmsCultureUserStatistcs> data =  cmsCultureUserStatistcsMapper.queryCultureUserStatisticsByWeekDate(startDate, endDate);
            //统计表中添加上第一季度的数据
            cmsStatisticsList=getOneQuarterStatistics(data);
        }
        else if(queryType.equals("twoQuarter")){
            DateFormat fmt = new SimpleDateFormat("yyyy-MM-dd");
            String startSecondMonthDate;
            String endSecondMonthDate;
            startSecondMonthDate = year + "-" + "04-01";
            endSecondMonthDate = year + "-" + "06-31";
            startDate = fmt.parse(startSecondMonthDate);
            endDate = fmt.parse(endSecondMonthDate);
            List<CmsCultureUserStatistcs> data = cmsCultureUserStatistcsMapper.queryCultureUserStatisticsByWeekDate(startDate, endDate);
            //统计表中添加上第二季度的数据
            cmsStatisticsList=getTwoQuarterStatistics(data);
        }
        else if(queryType.equals("thirdQuarter")){
            DateFormat fmt = new SimpleDateFormat("yyyy-MM-dd");
            //第三季度
            String startThirdMonthDate;
            String endThirdMonthDate;
            startThirdMonthDate = year + "-" + "07-01";
            endThirdMonthDate = year + "-" + "09-31";
            startDate = fmt.parse(startThirdMonthDate);
            endDate = fmt.parse(endThirdMonthDate);
            List<CmsCultureUserStatistcs> data =cmsCultureUserStatistcsMapper.queryCultureUserStatisticsByWeekDate(startDate, endDate);
            //统计表添加第三季度数据
            cmsStatisticsList=getThirdQuarterStatistics(data);
        }
        else if(queryType.equals("fourQuarter")){
            DateFormat fmt = new SimpleDateFormat("yyyy-MM-dd");
            //第四季度
            String startFourMonthDate;
            String endFourMonthDate;
            startFourMonthDate=year + "-" +"10-01";
            endFourMonthDate=year+"-"+"12-31";
            startDate=fmt.parse(startFourMonthDate);
            endDate = fmt.parse(endFourMonthDate);
            List<CmsCultureUserStatistcs> data =cmsCultureUserStatistcsMapper.queryCultureUserStatisticsByWeekDate(startDate, endDate);
            //统计表中添加第四季度数据
            cmsStatisticsList=getFourQuarterStatistics(data);
        }
        else  if(queryType.equals("year")){
            DateFormat fmt = new SimpleDateFormat("yyyy-MM-dd");
            String startYearDate;
            String endYearDate;
            startYearDate=year+"-"+"01-01";
            endYearDate=year+"-"+"12-31";
            startDate=fmt.parse(startYearDate);
            endDate = fmt.parse(endYearDate);
            List<CmsCultureUserStatistcs> data =cmsCultureUserStatistcsMapper.queryCultureUserStatisticsByWeekDate(startDate, endDate);
            //统计表添加年数据
            cmsStatisticsList=getYearStatistic(data);
        }
        return cmsStatisticsList;
    }


    //统计表中添加一周的数据
    private List<CmsStatistics> getWeekStatistics(List<CmsCultureUserStatistcs> data) {
        Set<String> set = new HashSet<String>();
        Map<String, Object> map = new HashMap<String, Object>();
        List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
        for (CmsCultureUserStatistcs statistics : data) {
                //1.浏览次数 2.被赞次数 3.收藏次数 4.分享次数
                if (statistics.getOperateType() == 1) {
                    map.put(statistics.getCultureId() + "weekBrowseCount", statistics.getOperateCount());
                } else if (statistics.getOperateType() == 2) {
                    map.put(statistics.getCultureId() + "weekPraiseCount", statistics.getOperateCount());
                } else if (statistics.getOperateType() == 3) {
                    map.put(statistics.getCultureId() + "weekCollectCount", statistics.getOperateCount());
                } else if (statistics.getOperateType() == 4) {
                    map.put(statistics.getCultureId() + "weekShareCount", statistics.getOperateCount());
                }
                set.add(statistics.getCultureId());
        }
        for (String info : set) {
            CmsStatistics cmsStatistics = new CmsStatistics();
            cmsStatistics.setsId(info);
            if(map.get(info + "weekBrowseCount")!=null){
                cmsStatistics.setWeekBrowseCount((Integer) map.get(info + "weekBrowseCount"));
            }
            if( map.get(info + "weekPraiseCount")!=null){
                cmsStatistics.setWeekPraiseCount((Integer) map.get(info + "weekPraiseCount"));
            }
            if(map.get(info + "weekCollectCount")!=null){
                cmsStatistics.setWeekCollectCount((Integer) map.get(info + "weekCollectCount"));
            }
            if(map.get(info + "weekShareCount")!=null) {
                cmsStatistics.setWeekShareCount((Integer) map.get(info + "weekShareCount"));
            }
            cmsStatisticsList.add(cmsStatistics);
        }
          return  cmsStatisticsList;
    }
    //统计表中添加月数据
    private List<CmsStatistics> getMonthStatistics( List<CmsCultureUserStatistcs> data) {
        Set<String> set = new HashSet<String>();
        Map<String, Object> map = new HashMap<String, Object>();
        List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
        for (CmsCultureUserStatistcs statistics : data) {
            if (statistics != null) {
                //1.浏览次数 2.被赞次数 3.收藏次数 4.分享次数
                if (statistics.getOperateType() == 1) {
                    map.put(statistics.getCultureId() + "monthBrowseCount", statistics.getOperateCount());
                } else if (statistics.getOperateType() == 2) {
                    map.put(statistics.getCultureId() + "monthPraiseCount", statistics.getOperateCount());
                } else if (statistics.getOperateType() == 3) {
                    map.put(statistics.getCultureId() + "monthCollectCount", statistics.getOperateCount());
                } else if (statistics.getOperateType() == 4) {
                    map.put(statistics.getCultureId() + "monthShareCount", statistics.getOperateCount());
                }
                set.add(statistics.getCultureId());
            }
        }
        for (String info : set) {
            CmsStatistics cmsStatistics = new CmsStatistics();
            cmsStatistics.setsId(info);
            if(map.get(info + "monthBrowseCount")!=null){
                cmsStatistics.setMonthBrowseCount((Integer) map.get(info + "monthBrowseCount"));
            }
            if( map.get(info + "monthPraiseCount")!=null){
                cmsStatistics.setMonthPraiseCount((Integer) map.get(info + "monthPraiseCount"));
            }
            if(map.get(info + "monthCollectCount")!=null){
                cmsStatistics.setMonthCollectCount((Integer) map.get(info + "monthCollectCount"));
            }
            if(map.get(info + "monthShareCount")!=null){
                cmsStatistics.setMonthShareCount((Integer) map.get(info + "monthShareCount"));
            }
            cmsStatisticsList.add(cmsStatistics);
        }
        return  cmsStatisticsList;
    }
    //统计表中添加上第一季度的数据
    private List<CmsStatistics> getOneQuarterStatistics( List<CmsCultureUserStatistcs>  data) {
        Set<String> set = new HashSet<String>();
        Map<String, Object> map = new HashMap<String, Object>();
        List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
        for (CmsCultureUserStatistcs statistics : data) {
            if (statistics != null) {
                //1.浏览次数 2.被赞次数 3.收藏次数 4.分享次数
                if (statistics.getOperateType() == 1) {
                    map.put(statistics.getCultureId() + "oquarterBrowseCount", statistics.getOperateCount());
                } else if (statistics.getOperateType() == 2) {
                    map.put(statistics.getCultureId() + "oquarterPraiseCount", statistics.getOperateCount());
                } else if (statistics.getOperateType() == 3) {
                    map.put(statistics.getCultureId() + "oquarterCollectCount", statistics.getOperateCount());
                } else if (statistics.getOperateType() == 4) {
                    map.put(statistics.getCultureId() + "oquarterShareCount", statistics.getOperateCount());
                }
                set.add(statistics.getCultureId());
            }
        }
        for (String info : set) {
            CmsStatistics cmsStatistics = new CmsStatistics();
            cmsStatistics.setsId(info);
            if(map.get(info + "oquarterBrowseCount")!=null){
                cmsStatistics.setOquarterBrowseCount((Integer) map.get(info + "oquarterBrowseCount"));
            }
            if( map.get(info + "oquarterPraiseCount")!=null){
                cmsStatistics.setOquarterPraiseCount((Integer) map.get(info + "oquarterPraiseCount"));
            }
            if(map.get(info + "oquarterCollectCount")!=null){
                cmsStatistics.setOquarterCollectCount((Integer) map.get(info + "oquarterCollectCount"));
            }
            if(map.get(info + "oquarterShareCount")!=null){
                cmsStatistics.setOquarterShareCount((Integer) map.get(info + "oquarterShareCount"));
            }
            cmsStatisticsList.add(cmsStatistics);
        }
        return  cmsStatisticsList;
    }
    //统计表中添加上第二季度的数据
    private List<CmsStatistics> getTwoQuarterStatistics( List<CmsCultureUserStatistcs>  data) {
        Set<String> set = new HashSet<String>();
        Map<String, Object> map = new HashMap<String, Object>();
        List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
        for (CmsCultureUserStatistcs statistics : data) {
            if (statistics != null) {
                //1.浏览次数 2.被赞次数 3.收藏次数 4.分享次数
                if (statistics.getOperateType() == 1) {
                    map.put(statistics.getCultureId() + "SquarterBrowseCount", statistics.getOperateCount());
                } else if (statistics.getOperateType() == 2) {
                    map.put(statistics.getCultureId() + "SquarterPraiseCount", statistics.getOperateCount());
                } else if (statistics.getOperateType() == 3) {
                    map.put(statistics.getCultureId() + "SquarterCollectCount", statistics.getOperateCount());
                } else if (statistics.getOperateType() == 4) {
                    map.put(statistics.getCultureId() + "SquarterShareCount", statistics.getOperateCount());
                }
                set.add(statistics.getCultureId());
            }
        }
        for (String info : set) {
            CmsStatistics cmsStatistics = new CmsStatistics();
            cmsStatistics.setsId(info);
            if(map.get(info + "SquarterBrowseCount")!=null){
                cmsStatistics.setSquarterBrowseCount((Integer) map.get(info + "SquarterBrowseCount"));
            }
            if( map.get(info + "SquarterPraiseCount")!=null){
                cmsStatistics.setSquarterPraiseCount((Integer) map.get(info + "SquarterPraiseCount"));
            }
            if(map.get(info + "SquarterCollectCount")!=null){
                cmsStatistics.setSquarterCollectCount((Integer) map.get(info + "SquarterCollectCount"));
            }
            if(map.get(info + "SquarterShareCount")!=null) {
                cmsStatistics.setSquarterShareCount((Integer) map.get(info + "SquarterShareCount"));
            }
            cmsStatisticsList.add(cmsStatistics);
        }
        return cmsStatisticsList;
    }
    //统计表中添加上第三季度的数据
    private List<CmsStatistics> getThirdQuarterStatistics( List<CmsCultureUserStatistcs> data) {
        Set<String> set = new HashSet<String>();
        Map<String, Object> map = new HashMap<String, Object>();
        List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
        for (CmsCultureUserStatistcs statistics : data) {
            if (statistics != null) {
                //1.浏览次数 2.被赞次数 3.收藏次数 4.分享次数
                if (statistics.getOperateType() == 1) {
                    map.put(statistics.getCultureId() + "TquarterBrowseCount", statistics.getOperateCount());
                } else if (statistics.getOperateType() == 2) {
                    map.put(statistics.getCultureId() + "TquarterPraiseCount", statistics.getOperateCount());
                } else if (statistics.getOperateType() == 3) {
                    map.put(statistics.getCultureId() + "TquarterCollectCount", statistics.getOperateCount());
                } else if (statistics.getOperateType() == 4) {
                    map.put(statistics.getCultureId() + "TquarterShareCount", statistics.getOperateCount());
                }
                set.add(statistics.getCultureId());
            }
        }
        for (String info : set) {
            CmsStatistics cmsStatistics = new CmsStatistics();
            cmsStatistics.setsId(info);

            if(map.get(info + "TquarterBrowseCount")!=null){
                cmsStatistics.setTquarterBrowseCount((Integer) map.get(info + "TquarterBrowseCount"));
            }
            if( map.get(info + "TquarterPraiseCount")!=null){
                cmsStatistics.setTquarterPraiseCount((Integer) map.get(info + "TquarterPraiseCount"));
            }
            if(map.get(info + "TquarterCollectCount")!=null){
                cmsStatistics.setTquarterCollectCount((Integer) map.get(info + "TquarterCollectCount"));
            }
            if(map.get(info + "TquarterShareCount")!=null) {
                cmsStatistics.setTquarterShareCount((Integer) map.get(info + "TquarterShareCount"));
            }
            cmsStatisticsList.add(cmsStatistics);
        }
        return  cmsStatisticsList;
    }
    //统计表中添加上第四季度的数据
    private List<CmsStatistics> getFourQuarterStatistics( List<CmsCultureUserStatistcs> data) {
        Set<String> set = new HashSet<String>();
        Map<String, Object> map = new HashMap<String, Object>();
        List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
        for (CmsCultureUserStatistcs statistics : data) {
            if (statistics != null) {
                //1.浏览次数 2.被赞次数 3.收藏次数 4.分享次数
                if (statistics.getOperateType() == 1) {
                    map.put(statistics.getCultureId() + "FquarterBrowseCount", statistics.getOperateCount());
                } else if (statistics.getOperateType() == 2) {
                    map.put(statistics.getCultureId() + "FquarterPraiseCount", statistics.getOperateCount());
                } else if (statistics.getOperateType() == 3) {
                    map.put(statistics.getCultureId() + "FquarterCollectCount", statistics.getOperateCount());
                } else if (statistics.getOperateType() == 4) {
                    map.put(statistics.getCultureId() + "FquarterShareCount", statistics.getOperateCount());
                }
                set.add(statistics.getCultureId());
            }
        }
        for (String info : set) {
            CmsStatistics cmsStatistics = new CmsStatistics();
            cmsStatistics.setsId(info);
            if(map.get(info + "FquarterBrowseCount")!=null){
                cmsStatistics.setFquarterBrowseCount((Integer) map.get(info + "FquarterBrowseCount"));
            }
            if( map.get(info + "FquarterPraiseCount")!=null){
                cmsStatistics.setFquarterPraiseCount((Integer) map.get(info + "FquarterPraiseCount"));
            }
            if(map.get(info + "FquarterCollectCount")!=null){
                cmsStatistics.setTquarterCollectCount((Integer) map.get(info + "FquarterCollectCount"));
            }
            if(map.get(info + "FquarterShareCount")!=null) {
                cmsStatistics.setTquarterShareCount((Integer) map.get(info + "FquarterShareCount"));
            }

            cmsStatisticsList.add(cmsStatistics);
        }
        return  cmsStatisticsList;
    }
    //统计表中添加年数据
    private List<CmsStatistics> getYearStatistic(List<CmsCultureUserStatistcs> data) {
        Set<String> set = new HashSet<String>();
        Map<String, Object> map = new HashMap<String, Object>();
        List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
        for (CmsCultureUserStatistcs statistics : data) {
            if (statistics != null) {
                //1.浏览次数 2.被赞次数 3.收藏次数 4.分享次数
                if (statistics.getOperateType() == 1) {
                    map.put(statistics.getCultureId() + "yearBrowseCount", statistics.getOperateCount());
                } else if (statistics.getOperateType() == 2) {
                    map.put(statistics.getCultureId() + "yearPraiseCount", statistics.getOperateCount());
                } else if (statistics.getOperateType() == 3) {
                    map.put(statistics.getCultureId() + "yearCollectCount", statistics.getOperateCount());
                } else if (statistics.getOperateType() == 4) {
                    map.put(statistics.getCultureId() + "yearShareCount", statistics.getOperateCount());
                }
                set.add(statistics.getCultureId());
            }
        }
        for (String info : set) {
            CmsStatistics cmsStatistics = new CmsStatistics();
            cmsStatistics.setsId(info);
            if(map.get(info + "yearBrowseCount")!=null){
                cmsStatistics.setYearBrowseCount((Integer) map.get(info + "yearBrowseCount"));
            }
            if( map.get(info + "yearPraiseCount")!=null){
                cmsStatistics.setYearPraiseCount((Integer) map.get(info + "yearPraiseCount"));
            }
            if(map.get(info + "yearCollectCount")!=null){
                cmsStatistics.setYearCollectCount((Integer) map.get(info + "yearCollectCount"));
            }
            if(map.get(info + "yearShareCount")!=null) {
                cmsStatistics.setYearShareCount((Integer) map.get(info + "yearShareCount"));
            }
            cmsStatisticsList.add(cmsStatistics);
        }
        return  cmsStatisticsList;
    }


}
