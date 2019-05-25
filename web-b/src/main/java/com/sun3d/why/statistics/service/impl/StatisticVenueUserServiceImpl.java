package com.sun3d.why.statistics.service.impl;

import com.sun3d.why.dao.CmsTerminalUserMapper;
import com.sun3d.why.dao.VenueUserStatisticsMapper;
import com.sun3d.why.model.CmsCollect;
import com.sun3d.why.model.CmsStatistics;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.VenueUserStatistics;
import com.sun3d.why.statistics.service.StatisticVenueUserService;
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
 * 模块服务层实现类
 * 事务管理层
 * 需要用到事务的功能都在此编写
 * 管理场馆明细数据统计
 * author wangkun
 */
@Service
@Transactional
public class StatisticVenueUserServiceImpl implements StatisticVenueUserService {
	/**
	 * 自动注入数据操作层dao实例
	 */
	@Autowired
	private VenueUserStatisticsMapper venueUserStatisticsMapper;
	@Autowired
	private CmsTerminalUserMapper userMapper;
	@Override
	public List<CmsStatistics> queryVenueStatisticsByType(String queryType) throws ParseException {
		Map<String, Object> map = new HashMap<String, Object>();
		List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
		Date startDate = null;
		Date endDate = null;
		DateFormat fmt = new SimpleDateFormat("yyyy-MM");
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
			List<VenueUserStatistics> data = venueUserStatisticsMapper.queryVenueUserStatisticsByWeekDate(startDate, endDate);
            //统计表中添加一周的数据
			cmsStatisticsList=getWeekStatistics(data);
		} else if (queryType.equals("month")) {
			//根据月进行统计
			String startMonthDate;
			String endMonthDate;
			int month = cal.get(Calendar.MONTH); // 上个月月份
			int month2 = cal.get(Calendar.MONTH) + 1;//当前月份
			startMonthDate = year + "-" + (month < 10 ? "0" + month : month);
			endMonthDate = year + "-" + (month2 < 10 ? "0" + month2 : month2);
			startDate = fmt.parse(startMonthDate);
			endDate = fmt.parse(endMonthDate);
			List<VenueUserStatistics> data = venueUserStatisticsMapper.queryVenueUserStatisticsByMonthDate();
			//统计表中添加一个月的数据
			cmsStatisticsList=getMonthStatistics(data);
		}
		else if(queryType.equals("oneQuarter")){
			//第一季度 当前年份
			String startOneMonthDate;
			String endOneMonthDate;
			startOneMonthDate = year + "-" + "01-01";
			endOneMonthDate = year + "-" + "03-31";
			startDate = fmt.parse(startOneMonthDate);
			endDate = fmt.parse(endOneMonthDate);
			List<VenueUserStatistics> data = venueUserStatisticsMapper.queryVenueUserStatisticsByQuarterDate(startDate, endDate);
		   //统计表中添加第一季度的数据
			cmsStatisticsList=getOneQuarterStatistics(data);
		}
		else if(queryType.equals("twoQuarter")){
			String startSecondMonthDate;
			String endSecondMonthDate;
			startSecondMonthDate = year + "-" + "04-01";
			endSecondMonthDate = year + "-" + "06-31";
			startDate = fmt.parse(startSecondMonthDate);
			endDate = fmt.parse(endSecondMonthDate);
			List<VenueUserStatistics> data = venueUserStatisticsMapper.queryVenueUserStatisticsByQuarterDate(startDate, endDate);
			cmsStatisticsList=getTwoQuarterStatistics(data);
		}
		else if(queryType.equals("thirdQuarter")){
			//第三季度
			String startThirdMonthDate;
			String endThirdMonthDate;
			startThirdMonthDate = year + "-" + "07-01";
			endThirdMonthDate = year + "-" + "09-31";
			startDate = fmt.parse(startThirdMonthDate);
			endDate = fmt.parse(endThirdMonthDate);
			List<VenueUserStatistics> data = venueUserStatisticsMapper.queryVenueUserStatisticsByQuarterDate(startDate, endDate);
			cmsStatisticsList=getThirdQuarterStatistics(data);
		}
		else if(queryType.equals("fourQuarter")){
			//第四季度
			String startFourMonthDate;
			String endFourMonthDate;
			startFourMonthDate=year + "-" +"10-01";
			endFourMonthDate=year+"-"+"12-31";
			startDate=fmt.parse(startFourMonthDate);
			endDate = fmt.parse(endFourMonthDate);
			List<VenueUserStatistics> data = venueUserStatisticsMapper.queryVenueUserStatisticsByQuarterDate(startDate, endDate);
			cmsStatisticsList=getFourQuarterStatistics(data);
		}
		else  if(queryType.equals("year")){
			String startYearDate;
			String endYearDate;
			startYearDate=year+"-"+"01-01";
			endYearDate=year+"-"+"12-31";
			startDate=fmt.parse(startYearDate);
			endDate = fmt.parse(endYearDate);
			List<VenueUserStatistics> data = venueUserStatisticsMapper.queryVenueUserStatisticsByQuarterDate(startDate, endDate);
			cmsStatisticsList=getYearStatistics(data);
		}
		return cmsStatisticsList;
	}




	@Override
	public void deleteVenue(CmsCollect cmsCollect) {

	}


	@Override
	public int addVenueUserStatistics(VenueUserStatistics venueUserStatistics) {
		if (venueUserStatistics != null) {
	     	return venueUserStatisticsMapper.addVenueUserStatistics(venueUserStatistics);
		} else {
			return 0;
		}
	}

	/**
	 * app用户收藏展馆信息
	 * @param venueUserStatistics 用户展馆对象
	 * @param userId 用户id
	 */
	@Override
	public int addAppVenueUserStatistics(VenueUserStatistics venueUserStatistics, String userId) {
			venueUserStatistics.setId(UUIDUtils.createUUId());
			CmsTerminalUser terminalUser=userMapper.queryTerminalUserById(userId);
		    if(terminalUser!=null){
				venueUserStatistics.setUserId(userId);
				venueUserStatistics.setStatus(Constant.STATIS2);
				venueUserStatistics.setCreateUser(terminalUser.getUserNickName());
				venueUserStatistics.setUpdateUser(terminalUser.getUserNickName());
				venueUserStatistics.setCreateTime(new Timestamp(System.currentTimeMillis()));
				venueUserStatistics.setUpdateTime(new Timestamp(System.currentTimeMillis()));
				return  venueUserStatisticsMapper.addVenueUserStatistics(venueUserStatistics);
			}else{
                return 0;
			}
	}

	@Override
	public int deleteVenueUser(VenueUserStatistics venueUserStatistics) {
		return venueUserStatisticsMapper.deleteVenueUser(venueUserStatistics);
	}


	/**
	 * 根据条件查询场馆用户信息
	 * @param venueId   场馆id
	 * @param operateType  操作类型 1.浏览次数 2.被赞次数 3.收藏次数4.分享次数
	 * @param remortIp  页面ip
	 * @param userId  用户id
	 * @param status 用户类型 1.会员 2.游客
	 * @return
	 */
	@Override
	public int venueUserCountByCondition(String venueId, Integer operateType, String remortIp, String userId, Integer status) throws ParseException {
		Map<String, Object> map = new HashMap<String, Object>();
       if(StringUtils.isNotBlank(venueId)){
		   map.put("venueId",venueId);
	   }
       if(operateType!=null){
		   map.put("operateType",operateType);
	   }
		if(StringUtils.isNotBlank(userId)){
			map.put("userId", userId);
		}
		if(StringUtils.isNotBlank(remortIp)){
			map.put("ip",remortIp);
		}
		map.put("startDate", TimeUtil.getTimesmorning());
		map.put("endDate",TimeUtil.getTimesnight());
		map.put("status",status);
		return venueUserStatisticsMapper.queryVenueUserCountByCondition(map);
	}
	//添加一周的数据统计
	private List<CmsStatistics> getWeekStatistics(List<VenueUserStatistics> data) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
		Set<String> set = new HashSet<String>();
		for (VenueUserStatistics statistics : data) {
			if (statistics != null) {
				//1.浏览次数 2.被赞次数 3.收藏次数 4.分享次数
				if (statistics.getOperateType() == 1) {
					map.put(statistics.getVenueId() + "weekBrowseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 2) {
					map.put(statistics.getVenueId()  + "weekPraiseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 3) {
					map.put(statistics.getVenueId() + "weekCollectCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 4) {
					map.put(statistics.getVenueId() + "weekShareCount", statistics.getOperateCount());
				}
				set.add(statistics.getVenueId());
			}
		}
		for (String info : set) {
			CmsStatistics cmsStatistics = new CmsStatistics();
			cmsStatistics.setsId(info);
			cmsStatistics.setWeekBrowseCount((Integer) map.get(info + "weekBrowseCount"));
			cmsStatistics.setWeekPraiseCount((Integer) map.get(info + "weekPraiseCount"));
			cmsStatistics.setWeekCollectCount((Integer) map.get(info + "weekCollectCount"));
			cmsStatistics.setWeekShareCount((Integer) map.get(info + "weekShareCount"));
			cmsStatisticsList.add(cmsStatistics);
		}
		return  cmsStatisticsList;
	}
//统计添加一个月数据
	private List<CmsStatistics> getMonthStatistics(List<VenueUserStatistics> data) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
		Set<String> set = new HashSet<String>();
		for (VenueUserStatistics statistics : data) {
			if (statistics != null) {
				//1.浏览次数 2.被赞次数 3.收藏次数 4.分享次数
				if (statistics.getOperateType() == 1) {
					map.put(statistics.getVenueId() + "monthBrowseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 2) {
					map.put(statistics.getVenueId() + "monthPraiseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 3) {
					map.put(statistics.getVenueId() + "monthCollectCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 4) {
					map.put(statistics.getVenueId() + "monthShareCount", statistics.getOperateCount());
				}
				set.add(statistics.getVenueId());
			}
		}
		for (String info : set) {
			CmsStatistics cmsStatistics = new CmsStatistics();
			cmsStatistics.setsId(info);
			cmsStatistics.setOquarterBrowseCount((Integer) map.get(info + "monthBrowseCount"));
			cmsStatistics.setOquarterPraiseCount((Integer) map.get(info + "monthPraiseCount"));
			cmsStatistics.setOquarterCollectCount((Integer) map.get(info + "monthCollectCount"));
			cmsStatistics.setOquarterShareCount((Integer) map.get(info + "monthShareCount"));
			cmsStatisticsList.add(cmsStatistics);
		}
		return cmsStatisticsList;
	}
	//统计添加第一季度数据
	private List<CmsStatistics> getOneQuarterStatistics(List<VenueUserStatistics> data) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
		Set<String> set = new HashSet<String>();
		for (VenueUserStatistics statistics : data) {
			if (statistics != null) {
				//1.浏览次数 2.被赞次数 3.收藏次数 4.分享次数
				if (statistics.getOperateType() == 1) {
					map.put(statistics.getVenueId() + "oquarterBrowseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 2) {
					map.put(statistics.getVenueId() + "oquarterPraiseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 3) {
					map.put(statistics.getVenueId() + "oquarterCollectCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 4) {
					map.put(statistics.getVenueId() + "oquarterShareCount", statistics.getOperateCount());
				}
				set.add(statistics.getVenueId());
			}
		}
		for (String info : set) {
			CmsStatistics cmsStatistics = new CmsStatistics();
			cmsStatistics.setsId(info);
			cmsStatistics.setOquarterBrowseCount((Integer) map.get(info + "oquarterBrowseCount"));
			cmsStatistics.setOquarterPraiseCount((Integer) map.get(info + "oquarterPraiseCount"));
			cmsStatistics.setOquarterCollectCount((Integer) map.get(info + "oquarterCollectCount"));
			cmsStatistics.setOquarterShareCount((Integer) map.get(info + "oquarterShareCount"));
			cmsStatisticsList.add(cmsStatistics);
		}
          return  cmsStatisticsList;
	}
	//统计添加第二季度数据
	private List<CmsStatistics> getTwoQuarterStatistics(List<VenueUserStatistics> data) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
		Set<String> set = new HashSet<String>();
		for (VenueUserStatistics statistics : data) {
			if (statistics != null) {
				//1.浏览次数 2.被赞次数 3.收藏次数 4.分享次数
				if (statistics.getOperateType() == 1) {
					map.put(statistics.getVenueId() + "SquarterBrowseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 2) {
					map.put(statistics.getVenueId() + "SquarterPraiseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 3) {
					map.put(statistics.getVenueId() + "SquarterCollectCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 4) {
					map.put(statistics.getVenueId() + "SquarterShareCount", statistics.getOperateCount());
				}
				set.add(statistics.getVenueId());
			}
		}
		for (String info : set) {
			CmsStatistics cmsStatistics = new CmsStatistics();
			cmsStatistics.setsId(info);
			cmsStatistics.setSquarterBrowseCount((Integer) map.get(info + "SquarterBrowseCount"));
			cmsStatistics.setSquarterPraiseCount((Integer) map.get(info + "SquarterPraiseCount"));
			cmsStatistics.setSquarterCollectCount((Integer) map.get(info + "SquarterCollectCount"));
			cmsStatistics.setSquarterShareCount((Integer) map.get(info + "SquarterShareCount"));
			cmsStatisticsList.add(cmsStatistics);
		}
		return  cmsStatisticsList;
	}
	//统计添加第三季度数据
	private List<CmsStatistics> getThirdQuarterStatistics(List<VenueUserStatistics> data) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
		Set<String> set = new HashSet<String>();
		for (VenueUserStatistics statistics : data) {
			if (statistics != null) {
				//1.浏览次数 2.被赞次数 3.收藏次数 4.分享次数
				if (statistics.getOperateType() == 1) {
					map.put(statistics.getVenueId() + "TquarterBrowseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 2) {
					map.put(statistics.getVenueId() + "TquarterPraiseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 3) {
					map.put(statistics.getVenueId() + "TquarterCollectCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 4) {
					map.put(statistics.getVenueId() + "TquarterShareCount", statistics.getOperateCount());
				}
				set.add(statistics.getVenueId());
			}
		}
		for (String info : set) {
			CmsStatistics cmsStatistics = new CmsStatistics();
			cmsStatistics.setsId(info);
			cmsStatistics.setTquarterBrowseCount((Integer) map.get(info + "TquarterBrowseCount"));
			cmsStatistics.setTquarterPraiseCount((Integer) map.get(info + "TquarterPraiseCount"));
			cmsStatistics.setTquarterCollectCount((Integer) map.get(info + "TquarterCollectCount"));
			cmsStatistics.setTquarterShareCount((Integer) map.get(info + "TquarterShareCount"));
			cmsStatisticsList.add(cmsStatistics);
		}
       return  cmsStatisticsList;
	}
	//统计添加第四季度数据
	private List<CmsStatistics> getFourQuarterStatistics(List<VenueUserStatistics> data) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
		Set<String> set = new HashSet<String>();
		for (VenueUserStatistics statistics : data) {
			if (statistics != null) {
				//1.浏览次数 2.被赞次数 3.收藏次数 4.分享次数
				if (statistics.getOperateType() == 1) {
					map.put(statistics.getVenueId() + "FquarterBrowseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 2) {
					map.put(statistics.getVenueId() + "FquarterPraiseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 3) {
					map.put(statistics.getVenueId() + "FquarterCollectCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 4) {
					map.put(statistics.getVenueId() + "FquarterShareCount", statistics.getOperateCount());
				}
				set.add(statistics.getVenueId());
			}
		}
		for (String info : set) {
			CmsStatistics cmsStatistics = new CmsStatistics();
			cmsStatistics.setsId(info);
			cmsStatistics.setFquarterBrowseCount((Integer) map.get(info + "FquarterBrowseCount"));
			cmsStatistics.setFquarterPraiseCount((Integer) map.get(info + "FquarterPraiseCount"));
			cmsStatistics.setFquarterCollectCount((Integer) map.get(info + "FquarterCollectCount"));
			cmsStatistics.setFquarterShareCount((Integer) map.get(info + "FquarterShareCount"));
			cmsStatisticsList.add(cmsStatistics);
		}
		return  cmsStatisticsList;
	}
	private List<CmsStatistics> getYearStatistics(List<VenueUserStatistics> data) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
		Set<String> set = new HashSet<String>();
		for (VenueUserStatistics statistics : data) {
			if (statistics != null) {
				//1.浏览次数 2.被赞次数 3.收藏次数 4.分享次数
				if (statistics.getOperateType() == 1) {
					map.put(statistics.getVenueId() + "yearBrowseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 2) {
					map.put(statistics.getVenueId() + "yearPraiseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 3) {
					map.put(statistics.getVenueId() + "yearCollectCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 4) {
					map.put(statistics.getVenueId() + "yearShareCount", statistics.getOperateCount());
				}
				set.add(statistics.getVenueId());
			}
		}
		for (String info : set) {
			CmsStatistics cmsStatistics = new CmsStatistics();
			cmsStatistics.setsId(info);
			cmsStatistics.setYearBrowseCount((Integer) map.get(info + "yearBrowseCount"));
			cmsStatistics.setYearPraiseCount((Integer) map.get(info + "yearPraiseCount"));
			cmsStatistics.setYearCollectCount((Integer) map.get(info + "yearCollectCount"));
			cmsStatistics.setYearShareCount((Integer) map.get(info + "yearShareCount"));
			cmsStatisticsList.add(cmsStatistics);
		}
	   return  cmsStatisticsList;
	}
}
