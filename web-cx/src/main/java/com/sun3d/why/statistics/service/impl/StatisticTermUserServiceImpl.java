package com.sun3d.why.statistics.service.impl;

import com.sun3d.why.dao.CmsTeamUserStatisticsMapper;
import com.sun3d.why.dao.CmsTerminalUserMapper;
import com.sun3d.why.model.CmsCollect;
import com.sun3d.why.model.CmsStatistics;
import com.sun3d.why.model.CmsTeamUserStatistics;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.statistics.service.StatisticTermUserService;
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
 * 团体游客明细数据统计
 * author wangkun
 */
@Service
@Transactional
public class StatisticTermUserServiceImpl implements StatisticTermUserService {
	/**
	 * 自动注入数据操作层dao实例
	 */
	@Autowired
	private CmsTeamUserStatisticsMapper cmsTeamUserStatisticsMapper;
	@Autowired
	private CmsTerminalUserMapper userMapper;
	@Override
	public List<CmsStatistics> queryTeamStatisticsByType(String queryType) throws ParseException {
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
			List<CmsTeamUserStatistics> data = cmsTeamUserStatisticsMapper.queryTeamUserStatisticsByWeekDate(startDate, endDate);
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
			List<CmsTeamUserStatistics> data = cmsTeamUserStatisticsMapper.queryTeamUserStatisticsByMonthDate(startDate, endDate);
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
			List<CmsTeamUserStatistics> data = cmsTeamUserStatisticsMapper.queryTeamUserStatisticsByQuarterDate(startDate, endDate);
			cmsStatisticsList=getOneQuarterStatistics(data);
		}
		else if(queryType.equals("twoQuarter")){
			String startSecondMonthDate;
			String endSecondMonthDate;
			startSecondMonthDate = year + "-" + "04-01";
			endSecondMonthDate = year + "-" + "06-31";
			startDate = fmt.parse(startSecondMonthDate);
			endDate = fmt.parse(endSecondMonthDate);
			List<CmsTeamUserStatistics> data = cmsTeamUserStatisticsMapper.queryTeamUserStatisticsByQuarterDate(startDate, endDate);
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
			List<CmsTeamUserStatistics> data = cmsTeamUserStatisticsMapper.queryTeamUserStatisticsByQuarterDate(startDate, endDate);
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
			List<CmsTeamUserStatistics> data = cmsTeamUserStatisticsMapper.queryTeamUserStatisticsByQuarterDate(startDate, endDate);
			cmsStatisticsList=getFourQuarterStatistics(data);
		}
		else  if(queryType.equals("year")){
			String startYearDate;
			String endYearDate;
			startYearDate=year+"-"+"01-01";
			endYearDate=year+"-"+"12-31";
			startDate=fmt.parse(startYearDate);
			endDate = fmt.parse(endYearDate);
			List<CmsTeamUserStatistics> data = cmsTeamUserStatisticsMapper.queryTeamUserStatisticsByQuarterDate(startDate, endDate);
			cmsStatisticsList=getYearStatistics(data);
		}
		return cmsStatisticsList;
	}



	/*@Override
	public List<CmsTeamUserStatistics> selectByExample(CmsTeamUserStatisticsExample example) {
		return cmsTeamUserStatisticsMapper.selectByExample(example);
	}*/
	@Override
	public void deleteTermUser(CmsCollect cmsCollect) {

	}
	/*@Override
	public void deleteTermUser(CmsCollect cmsCollect) {

		CmsTeamUserStatisticsExample example = new CmsTeamUserStatisticsExample();
		CmsTeamUserStatisticsExample.Criteria criteria = example.createCriteria();
		criteria.andUserIdEqualTo(cmsCollect.getUserId());
		criteria.andTuserIdEqualTo(cmsCollect.getRelateId());
		//代表收藏
		criteria.andOperateTypeEqualTo(3);
		cmsTeamUserStatisticsMapper.deleteByExample(example);
	}*/

	/**
	 * 查询团队用户数据
	 * @param tuserId  团队id
	 * @param operateType  操作类型
	 * @param remortIp   页面ip
	 * @param userId   用户id
	 * @param status    用户查询 1.游客   2.用户
	 * @return
	 */
	@Override
	public int termUserCountByCondition(String tuserId, Integer operateType, String remortIp, String userId, Integer status) throws ParseException {

		Map<String, Object> map = new HashMap<String, Object>();
		if (operateType!=null) {
			map.put("operateType", operateType);
		}
		if(StringUtils.isNotBlank(tuserId)){
			map.put("tuserId",tuserId);
		}
		if(StringUtils.isNotBlank(userId)){
			map.put("userId", userId);
		}
		if(StringUtils.isNotBlank(remortIp)){
			map.put("ip",remortIp);
		}
		map.put("startDate", TimeUtil.getTimesmorning());
		map.put("endDate",TimeUtil.getTimesnight());
		//用户查询 1.游客   2.用户
		map.put("status",status);

		return cmsTeamUserStatisticsMapper.queryTermUserCountByCondition(map);
	}

	/**
	 * 添加团队用户数据
	 * @param cmsTeamUserStatistics 团体用户
	 */
	@Override
	public int addTermUserStatistics(CmsTeamUserStatistics cmsTeamUserStatistics) {
		if(cmsTeamUserStatistics!=null){
			return  cmsTeamUserStatisticsMapper.addTermUserStatistics(cmsTeamUserStatistics);
		}else {
			return 0;
		}
	}

	/**
	 * app添加团体收藏
	 * @param teamUserStatistics
	 * @param userId
	 */
	@Override
	public int addAppTeamUserStatistics(CmsTeamUserStatistics teamUserStatistics, String userId) {
		teamUserStatistics.setId(UUIDUtils.createUUId());
		CmsTerminalUser terminalUser=userMapper.queryTerminalUserById(userId);
		if(terminalUser!=null) {
			teamUserStatistics.setUserId(userId);
			teamUserStatistics.setStatus(Constant.STATIS2);
			teamUserStatistics.setCreateUser(terminalUser.getUserName());
			teamUserStatistics.setUpdateUser(terminalUser.getUserName());
			teamUserStatistics.setCreateTime(new Timestamp(System.currentTimeMillis()));
			teamUserStatistics.setUpdateTime(new Timestamp(System.currentTimeMillis()));
			return cmsTeamUserStatisticsMapper.addTermUserStatistics(teamUserStatistics);
		}else {
			return 0;
		}
	}

	@Override
	public int deleteTeamUser(CmsTeamUserStatistics teamUserStatistics) {
		return cmsTeamUserStatisticsMapper.deleteTeamUser(teamUserStatistics);
	}

	private List<CmsStatistics> getWeekStatistics(List<CmsTeamUserStatistics> data) {
		Set<String> set = new HashSet<String>();
		Map<String, Object> map = new HashMap<String, Object>();
		List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
		for (CmsTeamUserStatistics statistics : data) {
			if (statistics != null) {
				//1.浏览次数 2.被赞次数 3.收藏次数 4.分享次数
				if (statistics.getOperateType() == 1) {
					map.put(statistics.getTuserId() + "weekBrowseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 2) {
					map.put(statistics.getTuserId()  + "weekPraiseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 3) {
					map.put(statistics.getTuserId() + "weekCollectCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 4) {
					map.put(statistics.getTuserId() + "weekShareCount", statistics.getOperateCount());
				}
				set.add(statistics.getTuserId());
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
	private List<CmsStatistics> getMonthStatistics(List<CmsTeamUserStatistics> data) {
		Set<String> set = new HashSet<String>();
		Map<String, Object> map = new HashMap<String, Object>();
		List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
		for (CmsTeamUserStatistics statistics : data) {
			if (statistics != null) {
				//1.浏览次数 2.被赞次数 3.收藏次数 4.分享次数
				if (statistics.getOperateType() == 1) {
					map.put(statistics.getTuserId() + "monthBrowseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 2) {
					map.put(statistics.getTuserId() + "monthPraiseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 3) {
					map.put(statistics.getTuserId() + "monthCollectCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 4) {
					map.put(statistics.getTuserId() + "monthShareCount", statistics.getOperateCount());
				}
				set.add(statistics.getTuserId());
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
	private List<CmsStatistics> getOneQuarterStatistics(List<CmsTeamUserStatistics> data) {
		Set<String> set = new HashSet<String>();
		Map<String, Object> map = new HashMap<String, Object>();
		List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
		for (CmsTeamUserStatistics statistics : data) {
			if (statistics != null) {
				//1.浏览次数 2.被赞次数 3.收藏次数 4.分享次数
				if (statistics.getOperateType() == 1) {
					map.put(statistics.getTuserId() + "oquarterBrowseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 2) {
					map.put(statistics.getTuserId() + "oquarterPraiseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 3) {
					map.put(statistics.getTuserId() + "oquarterCollectCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 4) {
					map.put(statistics.getTuserId() + "oquarterShareCount", statistics.getOperateCount());
				}
				set.add(statistics.getTuserId());
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
	private List<CmsStatistics> getTwoQuarterStatistics(List<CmsTeamUserStatistics> data) {
		Set<String> set = new HashSet<String>();
		Map<String, Object> map = new HashMap<String, Object>();
		List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
		for (CmsTeamUserStatistics statistics : data) {
			if (statistics != null) {
				//1.浏览次数 2.被赞次数 3.收藏次数 4.分享次数
				if (statistics.getOperateType() == 1) {
					map.put(statistics.getTuserId() + "SquarterBrowseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 2) {
					map.put(statistics.getTuserId() + "SquarterPraiseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 3) {
					map.put(statistics.getTuserId() + "SquarterCollectCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 4) {
					map.put(statistics.getTuserId() + "SquarterShareCount", statistics.getOperateCount());
				}
				set.add(statistics.getTuserId());
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
	private List<CmsStatistics> getThirdQuarterStatistics(List<CmsTeamUserStatistics> data) {
		Set<String> set = new HashSet<String>();
		Map<String, Object> map = new HashMap<String, Object>();
		List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
		for (CmsTeamUserStatistics statistics : data) {
			if (statistics != null) {
				//1.浏览次数 2.被赞次数 3.收藏次数 4.分享次数
				if (statistics.getOperateType() == 1) {
					map.put(statistics.getTuserId() + "TquarterBrowseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 2) {
					map.put(statistics.getTuserId() + "TquarterPraiseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 3) {
					map.put(statistics.getTuserId() + "TquarterCollectCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 4) {
					map.put(statistics.getTuserId() + "TquarterShareCount", statistics.getOperateCount());
				}
				set.add(statistics.getTuserId());
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
	private List<CmsStatistics> getFourQuarterStatistics(List<CmsTeamUserStatistics> data) {
		Set<String> set = new HashSet<String>();
		Map<String, Object> map = new HashMap<String, Object>();
		List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
		for (CmsTeamUserStatistics statistics : data) {
			if (statistics != null) {
				//1.浏览次数 2.被赞次数 3.收藏次数 4.分享次数
				if (statistics.getOperateType() == 1) {
					map.put(statistics.getTuserId() + "FquarterBrowseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 2) {
					map.put(statistics.getTuserId() + "FquarterPraiseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 3) {
					map.put(statistics.getTuserId() + "FquarterCollectCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 4) {
					map.put(statistics.getTuserId() + "FquarterShareCount", statistics.getOperateCount());
				}
				set.add(statistics.getTuserId());
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
	private List<CmsStatistics> getYearStatistics(List<CmsTeamUserStatistics> data) {
		Set<String> set = new HashSet<String>();
		Map<String, Object> map = new HashMap<String, Object>();
		List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
		for (CmsTeamUserStatistics statistics : data) {
			if (statistics != null) {
				//1.浏览次数 2.被赞次数 3.收藏次数 4.分享次数
				if (statistics.getOperateType() == 1) {
					map.put(statistics.getTuserId() + "yearBrowseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 2) {
					map.put(statistics.getTuserId() + "yearPraiseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 3) {
					map.put(statistics.getTuserId() + "yearCollectCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 4) {
					map.put(statistics.getTuserId() + "yearShareCount", statistics.getOperateCount());
				}
				set.add(statistics.getTuserId());
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
