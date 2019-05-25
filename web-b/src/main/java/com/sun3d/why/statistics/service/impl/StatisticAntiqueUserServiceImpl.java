package com.sun3d.why.statistics.service.impl;

import com.sun3d.why.dao.AntiqueUserStatisticsMapper;
import com.sun3d.why.model.AntiqueUserStatistics;
import com.sun3d.why.model.CmsStatistics;
import com.sun3d.why.statistics.service.StatisticAntiqueUserService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
public class StatisticAntiqueUserServiceImpl implements StatisticAntiqueUserService {
	/**
	 * 自动注入数据操作层dao实例
	 */
	@Autowired
	private AntiqueUserStatisticsMapper antiqueUserStatisticsMapper;

	@Override
	public List<CmsStatistics> queryAntiqueStatisticsByType(String queryType) throws ParseException {
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
			List<AntiqueUserStatistics> data = antiqueUserStatisticsMapper.queryAntiqueUserStatisticsByWeekDate(startDate, endDate);
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
			List<AntiqueUserStatistics> data = antiqueUserStatisticsMapper.queryAntiqueUserStatisticsByMonthDate(startDate, endDate);
		   //统计一个月数据
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
			List<AntiqueUserStatistics> data = antiqueUserStatisticsMapper.queryAntiqueUserStatisticsByQuarterDate(startDate, endDate);
			cmsStatisticsList=getOneQuarterStatistics(data);
		}
		else if(queryType.equals("twoQuarter")){
			String startSecondMonthDate;
			String endSecondMonthDate;
			startSecondMonthDate = year + "-" + "04-01";
			endSecondMonthDate = year + "-" + "06-31";
			startDate = fmt.parse(startSecondMonthDate);
			endDate = fmt.parse(endSecondMonthDate);
			List<AntiqueUserStatistics> data = antiqueUserStatisticsMapper.queryAntiqueUserStatisticsByQuarterDate(startDate, endDate);
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
			List<AntiqueUserStatistics> data = antiqueUserStatisticsMapper.queryAntiqueUserStatisticsByQuarterDate(startDate, endDate);
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
			List<AntiqueUserStatistics> data = antiqueUserStatisticsMapper.queryAntiqueUserStatisticsByQuarterDate(startDate, endDate);
			cmsStatisticsList=getFourQuarterStatistics(data);
		}
		else  if(queryType.equals("year")){
			String startYearDate;
			String endYearDate;
			startYearDate=year+"-"+"01-01";
			endYearDate=year+"-"+"12-31";
			startDate=fmt.parse(startYearDate);
			endDate = fmt.parse(endYearDate);
			List<AntiqueUserStatistics> data = antiqueUserStatisticsMapper.queryAntiqueUserStatisticsByQuarterDate(startDate, endDate);
			cmsStatisticsList=getYearQuarterStatistics(data);
		}
		return cmsStatisticsList;
	}




	//这里需要重构
	@Override
	public int deleteAntiqueUser(AntiqueUserStatistics antiqueUserStatistics) {
		return antiqueUserStatisticsMapper.deleteAntiqueUser(antiqueUserStatistics);
	}



/*	@Override
	public void deleteAntique(CmsCollect cmsCollect) {
		AntiqueUserStatisticsExample example = new AntiqueUserStatisticsExample();
		AntiqueUserStatisticsExample.Criteria criteria = example.createCriteria();
		criteria.andUserIdEqualTo(cmsCollect.getUserId());
		criteria.andAntiqueIdEqualTo(cmsCollect.getRelateId());
		//代表收藏
		criteria.andOperateTypeEqualTo(3);
		antiqueUserStatisticsMapper.deleteByExample(example);
	}*/

	/**
	 * 查询藏品用户信息数据
	 * @param antiqueId  藏品id
	 * @param operateType  操作类型
	 * @param remortIp   页面ip
	 * @param userId    用户id
	 * @param status   用户查询 1.游客   2.用户
	 * @return
	 */
	@Override
	public int antiqueUserCountByCondition(String antiqueId, Integer operateType, String remortIp, String userId, Integer status) throws ParseException {
		Map<String, Object> map = new HashMap<String, Object>();
		if (operateType!=null) {
			map.put("operateType", operateType);
		}
		if(StringUtils.isNotBlank(antiqueId)){
			map.put("antiqueId",antiqueId);
		}
		if(StringUtils.isNotBlank(userId)){
			map.put("userId", userId);
		}
		if(StringUtils.isNotBlank(remortIp)){
			map.put("ip",remortIp);
		}
		Date date=new Date();
		SimpleDateFormat format=new SimpleDateFormat("yyyy-MM-dd");
		String date2=format.format(date);
		String startDate=date2+" 00:00:00 ";
		String endDate=date2+" 23:59:59 ";
		format.applyPattern("yyyy-MM-dd HH:mm:ss");
		Date startDate1=format.parse(startDate);
		Date endDate1=format.parse(endDate);
		map.put("startDate",startDate1);
		map.put("endDate",endDate1);
		//用户查询 1.游客   2.用户
		map.put("status",status);

		return antiqueUserStatisticsMapper.queryAntiqueUserCountByCondition(map);
	}

	@Override
	public int addAntiqueUserStatistics(AntiqueUserStatistics antiqueUserStatistics) {
		if(antiqueUserStatistics!=null){
	       return antiqueUserStatisticsMapper.addAntiqueUserStatistics(antiqueUserStatistics);
		}else {
			return 0;
		}

	}

	private List<CmsStatistics> getWeekStatistics(List<AntiqueUserStatistics> data) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
		Set<String> set = new HashSet<String>();
		for (AntiqueUserStatistics statistics : data) {
			if (statistics != null) {
				//1.浏览次数 2.被赞次数 3.收藏次数 4.分享次数
				if (statistics.getOperateType() == 1) {
					map.put(statistics.getAntiqueId() + "weekBrowseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 2) {
					map.put(statistics.getAntiqueId()  + "weekPraiseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 3) {
					map.put(statistics.getAntiqueId() + "weekCollectCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 4) {
					map.put(statistics.getAntiqueId() + "weekShareCount", statistics.getOperateCount());
				}
				set.add(statistics.getAntiqueId());
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
		return cmsStatisticsList;
	}
	private List<CmsStatistics> getMonthStatistics(List<AntiqueUserStatistics> data) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
		Set<String> set = new HashSet<String>();
		for (AntiqueUserStatistics statistics : data) {
			if (statistics != null) {
				//1.浏览次数 2.被赞次数 3.收藏次数 4.分享次数
				if (statistics.getOperateType() == 1) {
					map.put(statistics.getAntiqueId() + "monthBrowseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 2) {
					map.put(statistics.getAntiqueId() + "monthPraiseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 3) {
					map.put(statistics.getAntiqueId() + "monthCollectCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 4) {
					map.put(statistics.getAntiqueId() + "monthShareCount", statistics.getOperateCount());
				}
				set.add(statistics.getAntiqueId());
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
		return  cmsStatisticsList;
	}
	private List<CmsStatistics> getOneQuarterStatistics(List<AntiqueUserStatistics> data) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
		Set<String> set = new HashSet<String>();
		for (AntiqueUserStatistics statistics : data) {
			if (statistics != null) {
				//1.浏览次数 2.被赞次数 3.收藏次数 4.分享次数
				if (statistics.getOperateType() == 1) {
					map.put(statistics.getAntiqueId() + "oquarterBrowseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 2) {
					map.put(statistics.getAntiqueId() + "oquarterPraiseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 3) {
					map.put(statistics.getAntiqueId() + "oquarterCollectCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 4) {
					map.put(statistics.getAntiqueId() + "oquarterShareCount", statistics.getOperateCount());
				}
				set.add(statistics.getAntiqueId());
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
	private List<CmsStatistics> getTwoQuarterStatistics(List<AntiqueUserStatistics> data) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
		Set<String> set = new HashSet<String>();
		for (AntiqueUserStatistics statistics : data) {
			if (statistics != null) {
				//1.浏览次数 2.被赞次数 3.收藏次数 4.分享次数
				if (statistics.getOperateType() == 1) {
					map.put(statistics.getAntiqueId() + "SquarterBrowseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 2) {
					map.put(statistics.getAntiqueId() + "SquarterPraiseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 3) {
					map.put(statistics.getAntiqueId() + "SquarterCollectCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 4) {
					map.put(statistics.getAntiqueId() + "SquarterShareCount", statistics.getOperateCount());
				}
				set.add(statistics.getAntiqueId());
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

	private List<CmsStatistics> getThirdQuarterStatistics(List<AntiqueUserStatistics> data) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
		Set<String> set = new HashSet<String>();
		for (AntiqueUserStatistics statistics : data) {
			if (statistics != null) {
				//1.浏览次数 2.被赞次数 3.收藏次数 4.分享次数
				if (statistics.getOperateType() == 1) {
					map.put(statistics.getAntiqueId() + "TquarterBrowseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 2) {
					map.put(statistics.getAntiqueId() + "TquarterPraiseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 3) {
					map.put(statistics.getAntiqueId() + "TquarterCollectCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 4) {
					map.put(statistics.getAntiqueId() + "TquarterShareCount", statistics.getOperateCount());
				}
				set.add(statistics.getAntiqueId());
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
		return cmsStatisticsList;
	}
	private List<CmsStatistics> getFourQuarterStatistics(List<AntiqueUserStatistics> data) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
		Set<String> set = new HashSet<String>();
		for (AntiqueUserStatistics statistics : data) {
			if (statistics != null) {
				//1.浏览次数 2.被赞次数 3.收藏次数 4.分享次数
				if (statistics.getOperateType() == 1) {
					map.put(statistics.getAntiqueId() + "FquarterBrowseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 2) {
					map.put(statistics.getAntiqueId() + "FquarterPraiseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 3) {
					map.put(statistics.getAntiqueId() + "FquarterCollectCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 4) {
					map.put(statistics.getAntiqueId() + "FquarterShareCount", statistics.getOperateCount());
				}
				set.add(statistics.getAntiqueId());
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
		return cmsStatisticsList;
	}
	private List<CmsStatistics> getYearQuarterStatistics(List<AntiqueUserStatistics> data) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
		Set<String> set = new HashSet<String>();
		for (AntiqueUserStatistics statistics : data) {
			if (statistics != null) {
				//1.浏览次数 2.被赞次数 3.收藏次数 4.分享次数
				if (statistics.getOperateType() == 1) {
					map.put(statistics.getAntiqueId() + "yearBrowseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 2) {
					map.put(statistics.getAntiqueId() + "yearPraiseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 3) {
					map.put(statistics.getAntiqueId() + "yearCollectCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 4) {
					map.put(statistics.getAntiqueId() + "yearShareCount", statistics.getOperateCount());
				}
				set.add(statistics.getAntiqueId());
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
