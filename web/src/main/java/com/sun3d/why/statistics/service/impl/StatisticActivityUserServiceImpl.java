package com.sun3d.why.statistics.service.impl;

import com.sun3d.why.dao.ActivityUserStatisticsMapper;
import com.sun3d.why.dao.CmsTerminalUserMapper;
import com.sun3d.why.model.ActivityUserStatistics;
import com.sun3d.why.model.CmsCollect;
import com.sun3d.why.model.CmsStatistics;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.statistics.service.StatisticActivityUserService;
import com.sun3d.why.statistics.service.StatisticService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.TimeStatistic;
import com.sun3d.why.util.TimeUtil;
import com.sun3d.why.util.UUIDUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
/**
 * 管理活动明细数据统计
 */
@Service
@Transactional
public class StatisticActivityUserServiceImpl implements StatisticActivityUserService {
	@Autowired
	private ActivityUserStatisticsMapper activityUserStatisticsMapper;
	@Autowired
	private CmsTerminalUserMapper userMapper;
	@Autowired
	private StatisticService statisticService;

	@Override
	public int queryActivityStatisticsByType(String queryType) throws ParseException {
		int flag=0;
		List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM");
		Calendar cal = Calendar.getInstance();
		int year;
		year = cal.get(Calendar.YEAR);
		if (queryType.equals("week")) {
			List<ActivityUserStatistics> data = activityUserStatisticsMapper.queryActivityUserStatisticsByWeekDate(sdf.format(TimeStatistic.getCurrentWeekDayStartTime()),sdf.format(TimeStatistic.getCurrentWeekDayEndTime()));
			//统计表中添加一周的数据
			cmsStatisticsList=getWeekStatistics(data);
			if(cmsStatisticsList!=null && cmsStatisticsList.size()>0) {
				for (CmsStatistics cmsStatisticsTotal : cmsStatisticsList) {
					int count = statisticService.cmsStatisticCountById(cmsStatisticsTotal.getsId());
					cmsStatisticsTotal.setsType(Constant.type2);
					cmsStatisticsTotal.setCreateTime(new Timestamp(System.currentTimeMillis()));
					cmsStatisticsTotal.setUpdateTime(new Timestamp(System.currentTimeMillis()));
					if (count > 0) {
					flag = statisticService.editCmsStatisticByCondition(cmsStatisticsTotal);
					  } else {
					 flag = statisticService.addCmsStatisticByCondition(cmsStatisticsTotal);
					}
				}
			}
		} else if (queryType.equals("month")) {
			List<ActivityUserStatistics> data = activityUserStatisticsMapper.queryActivityUserStatisticsByMonthDate(fmt.format(TimeStatistic.getLastDate(new Date())), fmt.format(new Date()));
			//统计表中添加月数据
			cmsStatisticsList=getMonthStatistics(data);
			if(cmsStatisticsList!=null && cmsStatisticsList.size()>0){
				for(CmsStatistics cmsStatisticsTotal :cmsStatisticsList){
					int count = statisticService.cmsStatisticCountById(cmsStatisticsTotal.getsId());
					cmsStatisticsTotal.setUpdateTime(new Timestamp(System.currentTimeMillis()));
					cmsStatisticsTotal.setCreateTime(new Timestamp(System.currentTimeMillis()));
					if(count>0){
						cmsStatisticsTotal.setsType(Constant.type2);
						flag=statisticService.editCmsStatisticByCondition(cmsStatisticsTotal);
					}else {
						flag = statisticService.addCmsStatisticByCondition(cmsStatisticsTotal);
					}
				}
			}
		}
		else if(queryType.equals("oneQuarter")){
			//第一季度 当前年份
			String startOneMonthDate;
			String endOneMonthDate;
			startOneMonthDate = year + "-" + "01-01";
			endOneMonthDate = year + "-" + "03-31";
		//	startDate = fmt.parse(startOneMonthDate);
		//	endDate = fmt.parse(endOneMonthDate);
			List<ActivityUserStatistics> data = activityUserStatisticsMapper.queryActivityUserStatisticsByQuarterDate(startOneMonthDate, endOneMonthDate);
			//统计表中添加上第一季度的数据
			cmsStatisticsList=getOneQuarterStatistics(data);
			if(cmsStatisticsList!=null && cmsStatisticsList.size()>0){
				for(CmsStatistics cmsStatisticsTotal :cmsStatisticsList){
					int count = statisticService.cmsStatisticCountById(cmsStatisticsTotal.getsId());
					cmsStatisticsTotal.setCreateTime(new Timestamp(System.currentTimeMillis()));
					cmsStatisticsTotal.setUpdateTime(new Timestamp(System.currentTimeMillis()));
					cmsStatisticsTotal.setsType(Constant.type2);
					if(count>0){
						flag=statisticService.editCmsStatisticByCondition(cmsStatisticsTotal);
					}else {
						flag = statisticService.addCmsStatisticByCondition(cmsStatisticsTotal);
					}
				}
			}
		}
		else if(queryType.equals("twoQuarter")){
			String startSecondMonthDate;
			String endSecondMonthDate;
			startSecondMonthDate = year + "-" + "04-01";
			endSecondMonthDate = year + "-" + "06-31";
		//	startDate = fmt.parse(startSecondMonthDate);
			//endDate = fmt.parse(endSecondMonthDate);
			List<ActivityUserStatistics> data = activityUserStatisticsMapper.queryActivityUserStatisticsByQuarterDate(startSecondMonthDate, endSecondMonthDate);
			//统计表中添加上第二季度的数据
			cmsStatisticsList=getTwoQuarterStatistics(data);
			if(cmsStatisticsList!=null && cmsStatisticsList.size()>0){
				for(CmsStatistics cmsStatisticsTotal :cmsStatisticsList){
					int count = statisticService.cmsStatisticCountById(cmsStatisticsTotal.getsId());
					cmsStatisticsTotal.setCreateTime(new Timestamp(System.currentTimeMillis()));
					cmsStatisticsTotal.setUpdateTime(new Timestamp(System.currentTimeMillis()));
					cmsStatisticsTotal.setsType(Constant.type2);
					if(count>0){
						flag=statisticService.editCmsStatisticByCondition(cmsStatisticsTotal);
					}else {
						flag = statisticService.addCmsStatisticByCondition(cmsStatisticsTotal);
					}
				}
			}
		}
		else if(queryType.equals("thirdQuarter")){
			//第三季度
			String startThirdMonthDate;
			String endThirdMonthDate;
			startThirdMonthDate = year + "-" + "07-01";
			endThirdMonthDate = year + "-" + "09-31";
		//	startDate = fmt.parse(startThirdMonthDate);
		//	endDate = fmt.parse(endThirdMonthDate);
			List<ActivityUserStatistics> data = activityUserStatisticsMapper.queryActivityUserStatisticsByQuarterDate(startThirdMonthDate, endThirdMonthDate);
			//统计表添加第三季度数据
			cmsStatisticsList=getThirdQuarterStatistics(data);
			if(cmsStatisticsList!=null &&cmsStatisticsList.size()>0){
				for(CmsStatistics cmsStatisticsTotal :cmsStatisticsList){
					int count = statisticService.cmsStatisticCountById(cmsStatisticsTotal.getsId());
					cmsStatisticsTotal.setsType(Constant.type2);
					cmsStatisticsTotal.setCreateTime(new Timestamp(System.currentTimeMillis()));
					cmsStatisticsTotal.setUpdateTime(new Timestamp(System.currentTimeMillis()));
					if(count>0){
						flag=statisticService.editCmsStatisticByCondition(cmsStatisticsTotal);
					} else {
						flag = statisticService.addCmsStatisticByCondition(cmsStatisticsTotal);
					}
				}
			}
		}
		else if(queryType.equals("fourQuarter")){
			//第四季度
			String startFourMonthDate=year + "-" +"10-01";
			String endFourMonthDate=year+"-"+"12-31";
			//startDate=fmt.parse(startFourMonthDate);
			//endDate = fmt.parse(endFourMonthDate);
			List<ActivityUserStatistics> data = activityUserStatisticsMapper.queryActivityUserStatisticsByQuarterDate(startFourMonthDate, endFourMonthDate);
			//统计表中添加第四季度数据
			cmsStatisticsList=getFourQuarterStatistics(data);
			if(cmsStatisticsList!=null && cmsStatisticsList.size()>0){
				for(CmsStatistics cmsStatisticsTotal :cmsStatisticsList){
					int count = statisticService.cmsStatisticCountById(cmsStatisticsTotal.getsId());
					cmsStatisticsTotal.setsType(Constant.type2);
					cmsStatisticsTotal.setCreateTime(new Timestamp(System.currentTimeMillis()));
					cmsStatisticsTotal.setUpdateTime(new Timestamp(System.currentTimeMillis()));
					if(count>0){
						flag=statisticService.editCmsStatisticByCondition(cmsStatisticsTotal);
					}else {
						flag = statisticService.addCmsStatisticByCondition(cmsStatisticsTotal);
					}
				}
			}
		}
		else  if(queryType.equals("year")){
			String startYearDate=TimeStatistic.formatDate(TimeStatistic.getCurrYearFirst());
			String endYearDate=TimeStatistic.formatDate(TimeStatistic.getCurrYearLast());
			List<ActivityUserStatistics> data = activityUserStatisticsMapper.queryActivityUserStatisticsByQuarterDate(startYearDate,endYearDate);
			//统计表添加年数据
			cmsStatisticsList=getYearStatistic(data);
			if(cmsStatisticsList!=null && cmsStatisticsList.size()>0){
				for(CmsStatistics cmsStatisticsTotal :cmsStatisticsList){
					int count = statisticService.cmsStatisticCountById(cmsStatisticsTotal.getsId());
					cmsStatisticsTotal.setsType(Constant.type2);
					cmsStatisticsTotal.setCreateTime(new Timestamp(System.currentTimeMillis()));
					cmsStatisticsTotal.setUpdateTime(new Timestamp(System.currentTimeMillis()));
					if(count>0){
						flag=statisticService.editCmsStatisticByCondition(cmsStatisticsTotal);
					}else {
						flag = statisticService.addCmsStatisticByCondition(cmsStatisticsTotal);
					}
				}
			}
		}
		return flag;
	}

	@Override
	public int  addActivityUserStatistics(ActivityUserStatistics activityUserStatistics) {
		if(activityUserStatistics!=null){
		    return  activityUserStatisticsMapper.addActivityUserStatistics(activityUserStatistics);
		}else {
			return  0;
		}
	}
	@Override
	public void deleteCmsCollectActivity(CmsCollect cmsCollect) {
		Map<String,Object> map=new HashMap<String, Object>();

	}
	/**
	 * 查询活动用户关系数据
	 * @param activityId    活动id
	 * @param operateType  操作类型
	 * @param remortIP       游客ip
	 * @param userId         用户id，游客id
	 * @param status         用户类型  1.用户 2.游客
	 * @return 是否存在数据
	 */
	@Override
	public int activityUserCountByCondition(String activityId, Integer operateType, String remortIP, String userId, Integer status) throws ParseException {
		Map<String, Object> map = new HashMap<String, Object>();
		if (operateType!=null) {
			map.put("operateType", operateType);
		}
		if(StringUtils.isNotBlank(activityId)){
			map.put("activityId",activityId);
		}
		if(StringUtils.isNotBlank(userId)){
			map.put("userId", userId);
		}
		if(StringUtils.isNotBlank(remortIP)){
			map.put("ip",remortIP);
		}
		map.put("startDate", TimeUtil.getTimesmorning());
		map.put("endDate",TimeUtil.getTimesnight());
		//用户查询 1.游客   2.用户
		map.put("status",status);
		return activityUserStatisticsMapper.queryActivityUserCountByCondition(map);
	}

	/**
	 * app添加用户收藏活动信息
	 * @param activityUserStatistics 用户活动统计信息
	 * @param userId 用户id
	 */
	@Override
	public int addAppActivityUserStatistics(ActivityUserStatistics activityUserStatistics, String userId) {
		activityUserStatistics.setId(UUIDUtils.createUUId());
		CmsTerminalUser terminalUser=userMapper.queryTerminalUserById(userId);
		if(terminalUser!=null){
			activityUserStatistics.setStatus(Constant.STATIS2);
			activityUserStatistics.setUserId(userId);;
			activityUserStatistics.setCreateUser(terminalUser.getUserNickName());
			activityUserStatistics.setUpdateUser(terminalUser.getUserNickName());
			activityUserStatistics.setCreateTime(new Timestamp(System.currentTimeMillis()));
			activityUserStatistics.setUpdateTime(new Timestamp(System.currentTimeMillis()));
			return activityUserStatisticsMapper.addActivityUserStatistics(activityUserStatistics);
		}else {
			return  0;
		}
	}

	/**
	 * app删除用户活动统计数据
	 * @param userId 用户id
	 * @param activityId 活动id
	 * @param typeActivity 活动类型 1.浏览次数 2.被赞次数 3.收藏次数4.分享次数
	 */
	@Override
	public int deleteActivityUser(ActivityUserStatistics activityUserStatistics) {
		return activityUserStatisticsMapper.deleteActivityUser(activityUserStatistics);
	}

	//统计表中添加一周的数据
	private List<CmsStatistics> getWeekStatistics(List<ActivityUserStatistics> data) {
		Set<String> set = new HashSet<String>();
		Map<String, Object> map = new HashMap<String, Object>();
		List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
		for (ActivityUserStatistics statistics : data) {
			if (statistics != null) {
				//1.浏览次数 2.被赞次数 3.收藏次数 4.分享次数
				if (statistics.getOperateType() == 1) {
					map.put(statistics.getActivityId() + "weekBrowseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 2) {
					map.put(statistics.getActivityId() + "weekPraiseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 3) {
					map.put(statistics.getActivityId() + "weekCollectCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 4) {
					map.put(statistics.getActivityId() + "weekShareCount", statistics.getOperateCount());
				}
				set.add(statistics.getActivityId());
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
	//统计表中添加月数据
	private List<CmsStatistics> getMonthStatistics(List<ActivityUserStatistics> data) {
		Set<String> set = new HashSet<String>();
		Map<String, Object> map = new HashMap<String, Object>();
		List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
		for (ActivityUserStatistics statistics : data) {
			if (statistics != null) {
				//1.浏览次数 2.被赞次数 3.收藏次数 4.分享次数
				if (statistics.getOperateType() == 1) {
					map.put(statistics.getActivityId() + "monthBrowseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 2) {
					map.put(statistics.getActivityId() + "monthPraiseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 3) {
					map.put(statistics.getActivityId() + "monthCollectCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 4) {
					map.put(statistics.getActivityId() + "monthShareCount", statistics.getOperateCount());
				}
				set.add(statistics.getActivityId());
			}
		}
		for (String info : set) {
			CmsStatistics cmsStatistics = new CmsStatistics();
			cmsStatistics.setsId(info);
			cmsStatistics.setMonthBrowseCount((Integer) map.get(info + "monthBrowseCount"));
			cmsStatistics.setMonthPraiseCount((Integer) map.get(info + "monthPraiseCount"));
			cmsStatistics.setMonthCollectCount((Integer) map.get(info + "monthCollectCount"));
			cmsStatistics.setMonthShareCount((Integer) map.get(info + "monthShareCount"));
			cmsStatisticsList.add(cmsStatistics);
		}
		return  cmsStatisticsList;
	}
	//统计表中添加上第一季度的数据
	private List<CmsStatistics> getOneQuarterStatistics(List<ActivityUserStatistics> data) {
		Set<String> set = new HashSet<String>();
		Map<String, Object> map = new HashMap<String, Object>();
		List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
		for (ActivityUserStatistics statistics : data) {
			if (statistics != null) {
				//1.浏览次数 2.被赞次数 3.收藏次数 4.分享次数
				if (statistics.getOperateType() == 1) {
					map.put(statistics.getActivityId() + "oquarterBrowseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 2) {
					map.put(statistics.getActivityId() + "oquarterPraiseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 3) {
					map.put(statistics.getActivityId() + "oquarterCollectCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 4) {
					map.put(statistics.getActivityId() + "oquarterShareCount", statistics.getOperateCount());
				}
				set.add(statistics.getActivityId());
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
	//统计表中添加上第二季度的数据
	private List<CmsStatistics> getTwoQuarterStatistics(List<ActivityUserStatistics> data) {
		Set<String> set = new HashSet<String>();
		Map<String, Object> map = new HashMap<String, Object>();
		List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
		for (ActivityUserStatistics statistics : data) {
			if (statistics != null) {
				//1.浏览次数 2.被赞次数 3.收藏次数 4.分享次数
				if (statistics.getOperateType() == 1) {
					map.put(statistics.getActivityId() + "SquarterBrowseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 2) {
					map.put(statistics.getActivityId() + "SquarterPraiseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 3) {
					map.put(statistics.getActivityId() + "SquarterCollectCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 4) {
					map.put(statistics.getActivityId() + "SquarterShareCount", statistics.getOperateCount());
				}
				set.add(statistics.getActivityId());
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
		return cmsStatisticsList;
	}
	//统计表中添加上第三季度的数据
	private List<CmsStatistics> getThirdQuarterStatistics(List<ActivityUserStatistics> data) {
		Set<String> set = new HashSet<String>();
		Map<String, Object> map = new HashMap<String, Object>();
		List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
		for (ActivityUserStatistics statistics : data) {
			if (statistics != null) {
				//1.浏览次数 2.被赞次数 3.收藏次数 4.分享次数
				if (statistics.getOperateType() == 1) {
					map.put(statistics.getActivityId() + "TquarterBrowseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 2) {
					map.put(statistics.getActivityId() + "TquarterPraiseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 3) {
					map.put(statistics.getActivityId() + "TquarterCollectCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 4) {
					map.put(statistics.getActivityId() + "TquarterShareCount", statistics.getOperateCount());
				}
				set.add(statistics.getActivityId());
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
	//统计表中添加上第四季度的数据
	private List<CmsStatistics> getFourQuarterStatistics(List<ActivityUserStatistics> data) {
		Set<String> set = new HashSet<String>();
		Map<String, Object> map = new HashMap<String, Object>();
		List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
		for (ActivityUserStatistics statistics : data) {
			if (statistics != null) {
				//1.浏览次数 2.被赞次数 3.收藏次数 4.分享次数
				if (statistics.getOperateType() == 1) {
					map.put(statistics.getActivityId() + "FquarterBrowseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 2) {
					map.put(statistics.getActivityId() + "FquarterPraiseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 3) {
					map.put(statistics.getActivityId() + "FquarterCollectCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 4) {
					map.put(statistics.getActivityId() + "FquarterShareCount", statistics.getOperateCount());
				}
				set.add(statistics.getActivityId());
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
	//统计表中添加年数据
	private List<CmsStatistics> getYearStatistic(List<ActivityUserStatistics> data) {
		Set<String> set = new HashSet<String>();
		Map<String, Object> map = new HashMap<String, Object>();
		List<CmsStatistics> cmsStatisticsList = new ArrayList<CmsStatistics>();
		for (ActivityUserStatistics statistics : data) {
			if (statistics != null) {
				//1.浏览次数 2.被赞次数 3.收藏次数 4.分享次数
				if (statistics.getOperateType() == 1) {
					map.put(statistics.getActivityId() + "yearBrowseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 2) {
					map.put(statistics.getActivityId() + "yearPraiseCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 3) {
					map.put(statistics.getActivityId() + "yearCollectCount", statistics.getOperateCount());
				} else if (statistics.getOperateType() == 4) {
					map.put(statistics.getActivityId() + "yearShareCount", statistics.getOperateCount());
				}
				set.add(statistics.getActivityId());
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
