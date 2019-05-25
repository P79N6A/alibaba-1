package com.sun3d.why.job;

import com.sun3d.why.model.CmsStatistics;
import com.sun3d.why.statistics.service.StatisticCultureUserService;
import com.sun3d.why.statistics.service.StatisticService;
import com.sun3d.why.util.Constant;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.sql.Timestamp;
import java.util.List;

/**
 * 非遗统计数据
 */
@Component("cultureTaskJob")
public class CultureTaskJob {
	private Logger logger = Logger.getLogger(CultureTaskJob.class
			.getName());
	@Autowired
	private StatisticService statisticService;
	@Autowired
	private StatisticCultureUserService statisticCultureUserService;

	public void cultureTaskJob() throws Exception {
		List<CmsStatistics> cmsStatisticsList;
		//根据周进行活动用户关系统计
		cmsStatisticsList=statisticCultureUserService.queryCultureStatisticsByType(Constant.Week_TaskJob);
		int flag=0;
		try {
			for(CmsStatistics cmsStatisticsTotal :cmsStatisticsList){
//                 查询非遗统计表中是否存在数据
				int count = statisticService.cmsStatisticCountById(cmsStatisticsTotal.getsId());
				// 统计类型 1：场馆 2：活动 3：藏品 4.团体 5.非遗
				cmsStatisticsTotal.setsType(Constant.type5);
				cmsStatisticsTotal.setCreateTime(new Timestamp(System.currentTimeMillis()));
				cmsStatisticsTotal.setUpdateTime(new Timestamp(System.currentTimeMillis()));
				//cmsStatisticsTotal.setCreateUser(loginUserUtil.getUser().getUserCreateUser());
				//cmsStatisticsTotal.setUpdateUser(loginUserUtil.getUser().getUserUpdateUser());
				if(count>0){
					//非遗统计表中存在数据
					flag=statisticService.editCmsStatisticByCondition(cmsStatisticsTotal);
				} else {
					//非遗统计表中不存在数据
					flag = statisticService.addCmsStatisticByCondition(cmsStatisticsTotal);
				}
			}
		}catch (Exception e){
			flag = 0;
			logger.error("周非遗数据统计错误", e);
		}
       //根据月进行非遗统计
			cmsStatisticsList=statisticCultureUserService.queryCultureStatisticsByType(Constant.Month_TaskJob);
			try {
			for(CmsStatistics cmsStatisticsTotal :cmsStatisticsList){

              // 查询表中是否有数据
				int count = statisticService.cmsStatisticCountById(cmsStatisticsTotal.getsId());
				cmsStatisticsTotal.setsType(Constant.type5);
				//非遗统计表存在数据
				if(count>0){
					flag=statisticService.editCmsStatisticByCondition(cmsStatisticsTotal);
				}else {
					//非遗统计表中不存在数据
					flag = statisticService.addCmsStatisticByCondition(cmsStatisticsTotal);
				}
			}
		}catch (Exception e){
			flag = 0;
			logger.error("月非遗数据统计错误", e);
		}
		//根据第一季度进行非遗统计
		cmsStatisticsList=statisticCultureUserService.queryCultureStatisticsByType(Constant.OneQuarter_TaskJob);
		try {
			for(CmsStatistics cmsStatisticsTotal :cmsStatisticsList){
//                 查询表中是否有数据
				int count = statisticService.cmsStatisticCountById(cmsStatisticsTotal.getsId());
				cmsStatisticsTotal.setsType(Constant.type5);

				//非遗统计表存在数据
				if(count>0){
					flag=statisticService.editCmsStatisticByCondition(cmsStatisticsTotal);
				}else {
					//非遗统计表中不存在数据
					flag = statisticService.addCmsStatisticByCondition(cmsStatisticsTotal);
				}
			}
		}catch (Exception e){
			flag = 0;
			logger.error("第一季度非遗数据统计错误", e);
		}
		//根据第二季度进行非遗统计
		cmsStatisticsList=statisticCultureUserService.queryCultureStatisticsByType(Constant.TwoQuarter_TaskJob);
		try {
			for(CmsStatistics cmsStatisticsTotal :cmsStatisticsList){
//                 查询表中是否有数据
				int count = statisticService.cmsStatisticCountById(cmsStatisticsTotal.getsId());
				cmsStatisticsTotal.setsType(Constant.type5);
				//非遗统计表存在数据
				if(count>0){
					flag=statisticService.editCmsStatisticByCondition(cmsStatisticsTotal);
				}else {
					//非遗统计表中不存在数据
					flag = statisticService.addCmsStatisticByCondition(cmsStatisticsTotal);
				}
			}
		}catch (Exception e){
			flag = 0;
			logger.error("第二季度非遗数据统计错误", e);
		}
		cmsStatisticsList=statisticCultureUserService.queryCultureStatisticsByType(Constant.ThirdQuarter_TaskJob);
		try {
			for(CmsStatistics cmsStatisticsTotal :cmsStatisticsList){
//                 查询表中是否有数据
				int count = statisticService.cmsStatisticCountById(cmsStatisticsTotal.getsId());
				cmsStatisticsTotal.setsType(Constant.type5);
				//非遗统计表存在数据
				if(count>0){
					flag=statisticService.editCmsStatisticByCondition(cmsStatisticsTotal);
				} else {
					//非遗统计表中不存在数据
					flag = statisticService.addCmsStatisticByCondition(cmsStatisticsTotal);
				}
			}
		}catch (Exception e){
			flag = 0;
			logger.error("第三季度非遗数据统计错误", e);
		}
		cmsStatisticsList=statisticCultureUserService.queryCultureStatisticsByType(Constant.FourQuarter_TaskJob);
		try {
			for(CmsStatistics cmsStatisticsTotal :cmsStatisticsList){
//                 查询表中是否有数据
				int count = statisticService.cmsStatisticCountById(cmsStatisticsTotal.getsId());
				cmsStatisticsTotal.setsType(Constant.type5);
				if(count>0){
					//非遗统计表存在数据
					flag=statisticService.editCmsStatisticByCondition(cmsStatisticsTotal);
				}else {
					//非遗统计表中不存在数据
					flag = statisticService.addCmsStatisticByCondition(cmsStatisticsTotal);
				}
			}
		}catch (Exception e){
			flag = 0;
			logger.error("第四季度非遗数据统计错误", e);
		}
		//
		cmsStatisticsList=statisticCultureUserService.queryCultureStatisticsByType(Constant.Year_TaskJob);
		try {
			for(CmsStatistics cmsStatisticsTotal :cmsStatisticsList){
//                 查询表中是否有数据
				int count = statisticService.cmsStatisticCountById(cmsStatisticsTotal.getsId());
				cmsStatisticsTotal.setsType(Constant.type5);
				if(count>0){
					//非遗统计表存在数据
					flag=statisticService.editCmsStatisticByCondition(cmsStatisticsTotal);
				}else {
					//非遗统计表中不存在数据
					flag = statisticService.addCmsStatisticByCondition(cmsStatisticsTotal);
				}
			}
		}catch (Exception e){
			flag = 0;
			logger.error("年非遗数据统计错误", e);
		}
	}
	}


