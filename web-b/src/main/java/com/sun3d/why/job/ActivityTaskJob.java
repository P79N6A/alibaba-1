package com.sun3d.why.job;

import com.sun3d.why.statistics.service.StatisticActivityUserService;
import com.sun3d.why.util.Constant;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
/**
 * 活动统计数据
 * type 统计类型 1.场馆 2：活动 3：藏品 4.团体游客 5.非遗
 */
@Component("activityTaskJob")
public class ActivityTaskJob {
	private Logger logger = Logger.getLogger(ActivityTaskJob.class.getName());
	@Autowired
	private StatisticActivityUserService statisticActivityUserService;

	public void activityTaskJob() throws Exception {
		int flag=0;
		try {
			//根据周进行活动用户关系统计
			flag = statisticActivityUserService.queryActivityStatisticsByType(Constant.Week_TaskJob);
		}catch (Exception e){
			flag = 0;
			logger.error("周活动数据统计错误", e);
		}
            //根据月进行活动统计
			try {
				flag=statisticActivityUserService.queryActivityStatisticsByType(Constant.Month_TaskJob);
		}catch (Exception e){
			flag = 0;
			logger.error("月活动数据统计错误", e);
		}
		//根据第一季度进行活动统计
		try {
			flag=statisticActivityUserService.queryActivityStatisticsByType(Constant.OneQuarter_TaskJob);
		}catch (Exception e){
			flag = 0;
			logger.error("第一季度活动数据统计错误", e);
		}
		//根据第二季度进行活动统计
		try {
			flag=statisticActivityUserService.queryActivityStatisticsByType(Constant.TwoQuarter_TaskJob);
		}catch (Exception e){
			flag = 0;
			logger.error("第二季度活动数据统计错误", e);
		}

		try {
			flag=statisticActivityUserService.queryActivityStatisticsByType(Constant.ThirdQuarter_TaskJob);
		}catch (Exception e){
			flag = 0;
			logger.error("第三季度活动数据统计错误", e);
		}

		try {
			flag=statisticActivityUserService.queryActivityStatisticsByType(Constant.FourQuarter_TaskJob);
		}catch (Exception e){
			flag = 0;
			logger.error("第四季度活动数据统计错误", e);
		}

		try {
			flag=statisticActivityUserService.queryActivityStatisticsByType(Constant.Year_TaskJob);
		}catch (Exception e){
			flag = 0;
			logger.error("年活动数据统计错误", e);
		}
	}
}
