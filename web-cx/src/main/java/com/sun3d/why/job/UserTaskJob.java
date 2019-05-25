package com.sun3d.why.job;

import com.sun3d.why.model.CmsUserLoginStatistics;
import com.sun3d.why.model.CmsUserOrderStatistics;
import com.sun3d.why.model.CmsUserStatistics;
import com.sun3d.why.statistics.service.CmsUserLoginStatisticsService;
import com.sun3d.why.statistics.service.CmsUserOrderStatisticsService;
import com.sun3d.why.statistics.service.CmsUserStatisticsService;
import com.sun3d.why.util.UUIDUtils;
import org.apache.commons.collections.CollectionUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.text.DateFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 *馆藏统计数据
 */
@Component("userTaskJob")
public class UserTaskJob {
	/**
	 * 导入log4j日志管理，记录错误信息
	 */
	private Logger logger = Logger.getLogger(UserTaskJob.class.getName());

	@Autowired
	private CmsUserStatisticsService userStatisticsService;

	@Autowired
	private CmsUserLoginStatisticsService userLoginStatisticsService;

	@Autowired
	private CmsUserOrderStatisticsService userOrderStatisticsService;

	public void userTaskJob() {
		// 生成截至昨日数据统计
		userStatistics();
		// 文化云平台会员年龄统计
		userAgeStatistics();
		// 文化云平台会员性别统计
		userSexStatistics();
		// 文化云平台会员登陆渠道统计
		userLoginStatistics();
		// 文化云平台会员平均订票率统计
		userOrderStatistics();
	}

	/**
	 * 生成截至昨日数据统计
	 */
	private void userStatistics(){
		try{
			/*DateFormat format = new SimpleDateFormat("yyyy-MM-dd 00:00:00");
			Calendar cal = Calendar.getInstance();
			Date currentDate = format.parse(format.format(cal.getTime()));*/
			Date currentDate = new Date();
			// 1.删除会员总计数据
			userStatisticsService.deleteUserStatistics(1);
			// 2.查询数量
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("createTime", currentDate);
			int count = userStatisticsService.queryTerminalUserStatistics(map);
			// 3.添加会员总计
			CmsUserStatistics userStatistics = new CmsUserStatistics();
			userStatistics.setsId(UUIDUtils.createUUId());
			userStatistics.setsType(1);
			userStatistics.setsCategory(1);
			userStatistics.setsCount(count);
			userStatistics.setsTime(new Date());
			userStatisticsService.addUserStatistics(userStatistics);
		}catch (Exception e){
			logger.info("userStatistics error", e);
		}
	}

	/**
	 * 文化云平台会员年龄统计
	 */
	private void userAgeStatistics(){
		try{
			/*DateFormat format = new SimpleDateFormat("yyyy-MM-dd 00:00:00");
			Calendar cal = Calendar.getInstance();
			Date currentDate = format.parse(format.format(cal.getTime()));*/
			Date currentDate = new Date();
			// 1.删除会员年龄统计数据
			userStatisticsService.deleteUserStatistics(2);
			// 2.查询数量
			List<CmsUserStatistics> list = new ArrayList<CmsUserStatistics>();
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("createTime", currentDate);
			map.put("six", 1960);
			map.put("seven", 1970);
			map.put("eight", 1980);
			map.put("nine", 1990);
			map.put("zero", 2000);
			map.put("ten", 2010);
			List<CmsUserStatistics> userStatisticsList = userStatisticsService.queryTerminalUserAgeStatistics(map);
			if(CollectionUtils.isNotEmpty(userStatisticsList)){
				Map<Integer, Integer> mapList = new HashMap<Integer, Integer>();
				for (CmsUserStatistics cmsUserStatistics: userStatisticsList){
					mapList.put(cmsUserStatistics.getsCategory(), cmsUserStatistics.getsCount());
					cmsUserStatistics.setsId(UUIDUtils.createUUId());
					cmsUserStatistics.setsType(2);
					cmsUserStatistics.setsTime(new Date());
					list.add(cmsUserStatistics);
				}

				for(int i=1;i<7;i++){
					if(mapList.get(i+1) == null){
						CmsUserStatistics userStatistics = new CmsUserStatistics();
						userStatistics.setsId(UUIDUtils.createUUId());
						userStatistics.setsType(2);
						userStatistics.setsCategory(i + 1);
						userStatistics.setsCount(0);
						userStatistics.setsTime(new Date());
						list.add(userStatistics);
					}
				}
			}else{
				for(int i=1;i<7;i++){
					CmsUserStatistics userStatistics = new CmsUserStatistics();
					userStatistics.setsId(UUIDUtils.createUUId());
					userStatistics.setsType(2);
					userStatistics.setsCategory(i + 1);
					userStatistics.setsCount(0);
					userStatistics.setsTime(new Date());
					list.add(userStatistics);
				}
			}

			// 3. 添加会员年龄统计
			for(CmsUserStatistics cmsUserStatistics:list){
				userStatisticsService.addUserStatistics(cmsUserStatistics);
			}
		}catch (Exception e){
			logger.info("userAgeStatistics error", e);
		}
	}

	/**
	 * 文化云平台会员性别统计
	 */
	private void userSexStatistics(){
		try{
			/*DateFormat format = new SimpleDateFormat("yyyy-MM-dd 00:00:00");
			Calendar cal = Calendar.getInstance();
			Date currentDate = format.parse(format.format(cal.getTime()));*/
			Date currentDate = new Date();
			// 1.删除会员性别统计数据
			userStatisticsService.deleteUserStatistics(3);
			// 2.查询数量
			List<CmsUserStatistics> list = new ArrayList<CmsUserStatistics>();
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("createTime", currentDate);
			List<CmsUserStatistics> userStatisticsList = userStatisticsService.queryTerminalUserSexStatistics(map);
			if(CollectionUtils.isNotEmpty(userStatisticsList)){
				Map<Integer, Integer> mapList = new HashMap<Integer, Integer>();
				for(CmsUserStatistics cmsUserStatistics:userStatisticsList){
					mapList.put(cmsUserStatistics.getsCategory(), cmsUserStatistics.getsCount());
					cmsUserStatistics.setsId(UUIDUtils.createUUId());
					cmsUserStatistics.setsType(3);
					cmsUserStatistics.setsTime(new Date());
					list.add(cmsUserStatistics);
				}
				for(int i=8;i<10;i++){
					if(mapList.get(i) == null){
						CmsUserStatistics userStatistics = new CmsUserStatistics();
						userStatistics.setsId(UUIDUtils.createUUId());
						userStatistics.setsType(3);
						userStatistics.setsCategory(i);
						userStatistics.setsCount(0);
						userStatistics.setsTime(new Date());
						list.add(userStatistics);
					}
				}
			}else{
				for(int i=8;i<10;i++){
					CmsUserStatistics userStatistics = new CmsUserStatistics();
					userStatistics.setsId(UUIDUtils.createUUId());
					userStatistics.setsType(3);
					userStatistics.setsCategory(i);
					userStatistics.setsCount(0);
					userStatistics.setsTime(new Date());
					list.add(userStatistics);
				}

			}
			// 3. 添加会员性别统计
			for(CmsUserStatistics cmsUserStatistics:list){
				userStatisticsService.addUserStatistics(cmsUserStatistics);
			}
		}catch (Exception e){
			logger.info("userSexStatistics error", e);
		}
	}

	/**
	 * 文化云平台会员登陆渠道统计
	 */
	private void userLoginStatistics(){
		try{
			userLoginStatisticsService.deleteUserLoginStatistics();
			// j=1(周) j=2(月) j=3(季度) j=4(年)
			DateFormat format = new SimpleDateFormat("yyyy-MM-dd 00:00:00");
			for(int j=1;j<=4;j++){
				Calendar cal = Calendar.getInstance();
				/*Date endTime = format.parse(format.format(cal.getTime()));*/
				Date endTime = cal.getTime();
				Date startTime = null;
				if(j ==1){ // 周
					cal.add(Calendar.DATE, -7);
					startTime = format.parse(format.format(cal.getTime()));
				}else if(j == 2){ // 月
					cal.add(Calendar.MONTH, -1);
					startTime = format.parse(format.format(cal.getTime()));
				}else if(j == 3){ // 季度
					cal.add(Calendar.MONTH, -3);
					startTime = format.parse(format.format(cal.getTime()));
				}else if(j == 4){ // 年
					cal.add(Calendar.YEAR, -1);
					startTime = format.parse(format.format(cal.getTime()));
				}

				List<CmsUserLoginStatistics> list = new ArrayList<CmsUserLoginStatistics>();
				Map<String, Object> weekMap = new HashMap<String, Object>();
				weekMap.put("startTime", startTime);
				weekMap.put("endTime", endTime);
				List<CmsUserLoginStatistics> userLoginStatisticsList = userLoginStatisticsService.queryTerminalUserLoginTypeStatistics(weekMap);
				if(CollectionUtils.isNotEmpty(userLoginStatisticsList)){
					Map<Integer, Integer> mapList = new HashMap<Integer, Integer>();
					for(CmsUserLoginStatistics cmsUserLoginStatistics:userLoginStatisticsList){
						mapList.put(cmsUserLoginStatistics.getsCategory(), cmsUserLoginStatistics.getsCount());
						cmsUserLoginStatistics.setsId(UUIDUtils.createUUId());
						if(j ==1){ // 周
							cmsUserLoginStatistics.setsType(1);
						}else if(j == 2){ // 月
							cmsUserLoginStatistics.setsType(2);
						}else if(j == 3){ // 季度
							cmsUserLoginStatistics.setsType(3);
						}else if(j == 4){ // 年
							cmsUserLoginStatistics.setsType(4);
						}
						cmsUserLoginStatistics.setsTime(new Date());
						list.add(cmsUserLoginStatistics);
					}

					for(int i=0;i<2;i++){
						if(mapList.get(i+1) == null){
							CmsUserLoginStatistics userLoginStatistics = new CmsUserLoginStatistics();
							userLoginStatistics.setsId(UUIDUtils.createUUId());
							if(j ==1){ // 周
								userLoginStatistics.setsType(1);
							}else if(j == 2){ // 月
								userLoginStatistics.setsType(2);
							}else if(j == 3){ // 季度
								userLoginStatistics.setsType(3);
							}else if(j == 4){ // 年
								userLoginStatistics.setsType(4);
							}
							userLoginStatistics.setsCategory(i + 1);
							userLoginStatistics.setsCount(0);
							userLoginStatistics.setsTime(new Date());
							list.add(userLoginStatistics);
						}
					}
				}else{
					for(int s=0;s<2;s++){
						CmsUserLoginStatistics userLoginStatistics = new CmsUserLoginStatistics();
						userLoginStatistics.setsId(UUIDUtils.createUUId());
						if(j ==1){ // 周
							userLoginStatistics.setsType(1);
						}else if(j == 2){ // 月
							userLoginStatistics.setsType(2);
						}else if(j == 3){ // 季度
							userLoginStatistics.setsType(3);
						}else if(j == 4){ // 年
							userLoginStatistics.setsType(4);
						}
						userLoginStatistics.setsCategory(s+1);
						userLoginStatistics.setsCount(0);
						userLoginStatistics.setsTime(new Date());
						list.add(userLoginStatistics);
					}
				}

				for(CmsUserLoginStatistics cmsUserLoginStatistics:list){
					userLoginStatisticsService.addUserLoginStatistics(cmsUserLoginStatistics);
				}
			}
		}catch (Exception e){
			logger.info("userLoginStatistics error", e);
		}
	}

	/**
	 * 文化云平台会员平均订票率统计
	 */
	private void userOrderStatistics(){
		try{
			userOrderStatisticsService.deleteUserOrderStatistics();
			// j=1(周) j=2(月) j=3(季度) j=4(年)
			DateFormat format = new SimpleDateFormat("yyyy-MM-dd 00:00:00");
			for(int j=1;j<=4;j++){
				Calendar cal = Calendar.getInstance();
				//Date endTime = format.parse(format.format(cal.getTime()));
				Date endTime = cal.getTime();
				Date startTime = null;
				if(j ==1){ // 周
					cal.add(Calendar.DATE, -7);
					startTime = format.parse(format.format(cal.getTime()));
				}else if(j == 2){ // 月
					cal.add(Calendar.MONTH, -1);
					startTime = format.parse(format.format(cal.getTime()));
				}else if(j == 3){ // 季度
					cal.add(Calendar.MONTH, -3);
					startTime = format.parse(format.format(cal.getTime()));
				}else if(j == 4){ // 年
					cal.add(Calendar.YEAR, -1);
					startTime = format.parse(format.format(cal.getTime()));
				}
				long count = (endTime.getTime() - startTime.getTime())/1000/60/60/24/7;

				List<CmsUserOrderStatistics> list = new ArrayList<CmsUserOrderStatistics>();
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("startTime", startTime);
				map.put("endTime", endTime);
				List<CmsUserOrderStatistics> userOrderStatisticsList = userOrderStatisticsService.queryTerminalUserOrderStatistics(map);
				if(CollectionUtils.isNotEmpty(userOrderStatisticsList)){
					Map<Integer, Double> mapList = new HashMap<Integer, Double>();
					for(CmsUserOrderStatistics cmsUserOrderStatistics:userOrderStatisticsList){
						mapList.put(cmsUserOrderStatistics.getsCategory(), cmsUserOrderStatistics.getsCount());
						cmsUserOrderStatistics.setsId(UUIDUtils.createUUId());
						if(j ==1){ // 周
							cmsUserOrderStatistics.setsType(1);
						}else if(j == 2){ // 月
							cmsUserOrderStatistics.setsType(2);
						}else if(j == 3){ // 季度
							cmsUserOrderStatistics.setsType(3);
						}else if(j == 4){ // 年
							cmsUserOrderStatistics.setsType(4);
						}
						cmsUserOrderStatistics.setsTime(new Date());
						list.add(cmsUserOrderStatistics);
					}

					for(int i=0;i<3;i++){
						if(mapList.get(i+1) == null){
							CmsUserOrderStatistics userOrderStatistics = new CmsUserOrderStatistics();
							userOrderStatistics.setsId(UUIDUtils.createUUId());
							if(j ==1){ // 周
								userOrderStatistics.setsType(1);
							}else if(j == 2){ // 月
								userOrderStatistics.setsType(2);
							}else if(j == 3){ // 季度
								userOrderStatistics.setsType(3);
							}else if(j == 4){ // 年
								userOrderStatistics.setsType(4);
							}
							userOrderStatistics.setsCategory(i + 1);
							userOrderStatistics.setsCount(0d);
							userOrderStatistics.setsTime(new Date());
							list.add(userOrderStatistics);
						}
					}
				}else{
					for(int s=0;s<3;s++){
						CmsUserOrderStatistics userOrderStatistics = new CmsUserOrderStatistics();
						userOrderStatistics.setsId(UUIDUtils.createUUId());
						if(j ==1){ // 周
							userOrderStatistics.setsType(1);
						}else if(j == 2){ // 月
							userOrderStatistics.setsType(2);
						}else if(j == 3){ // 季度
							userOrderStatistics.setsType(3);
						}else if(j == 4){ // 年
							userOrderStatistics.setsType(4);
						}
						userOrderStatistics.setsCategory(s+1);
						userOrderStatistics.setsCount(0d);
						userOrderStatistics.setsTime(new Date());
						list.add(userOrderStatistics);
					}
				}

				for(CmsUserOrderStatistics cmsUserOrderStatistics:list){
					NumberFormat f = NumberFormat.getNumberInstance();
					f.setMaximumFractionDigits(2);
					cmsUserOrderStatistics.setsCount(Double.parseDouble(f.format(cmsUserOrderStatistics.getsCount()/count)));
					userOrderStatisticsService.addUserOrderStatistics(cmsUserOrderStatistics);
				}
			}
		}catch (Exception e){
			logger.info("userOrderStatistics error", e);
		}
	}
}
