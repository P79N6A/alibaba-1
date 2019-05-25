package com.sun3d.why.job;

import com.sun3d.why.controller.SysModuleController;
import com.sun3d.why.model.CmsStatistics;
import com.sun3d.why.statistics.service.StatisticAntiqueUserService;
import com.sun3d.why.statistics.service.StatisticService;
import com.sun3d.why.util.Constant;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.sql.Timestamp;
import java.util.List;

/**
 *藏品明细表
 */
@Component("antiqueTaskJob")
public class AntiqueTaskJob {
	/**
	 * 导入log4j日志管理，记录错误信息
	 */
	private Logger logger = Logger.getLogger(SysModuleController.class
			.getName());
	/**
	 * 活动关系表，注解自动注入
	 */
	@Autowired
	private StatisticAntiqueUserService statisticAntiqueUserService;
	/**
	 * 模块管理service层对象，注解自动注入
	 */
	@Autowired
	private StatisticService statisticService;


//	@Autowired
//	private HttpSession session;

	public void antiqueTaskJob() throws Exception {
		List<CmsStatistics> cmsStatisticsList;
		cmsStatisticsList=statisticAntiqueUserService.queryAntiqueStatisticsByType(Constant.Week_TaskJob);
		int flag=0;
		try {
			for(CmsStatistics cmsStatisticsTotal :cmsStatisticsList){
//                 查询表中是否有数据
				int count = statisticService.cmsStatisticCountById(cmsStatisticsTotal.getsId());
				// 统计类型 1：场馆 2：活动 3：藏品 4.团体游客
				cmsStatisticsTotal.setsType(Constant.type3);
				cmsStatisticsTotal.setCreateTime(new Timestamp(System.currentTimeMillis()));
				cmsStatisticsTotal.setUpdateTime(new Timestamp(System.currentTimeMillis()));
//				SysUser sysUser=(SysUser) session.getAttribute("user");
//				if(sysUser!=null&&sysUser.getUserCreateUser()!=null) {
//					cmsStatisticsTotal.setCreateUser(sysUser.getUserCreateUser());
//				}
//				if(sysUser!=null&&sysUser.getUserUpdateUser()!=null){
//					cmsStatisticsTotal.setUpdateUser(sysUser.getUserUpdateUser());
//				}
			//	cmsStatisticsTotal.setCreateUser("admin");
			//	cmsStatisticsTotal.setUpdateUser("admin");
				//默认为系统管理员
				if(count>0){
					flag=statisticService.editCmsStatisticByCondition(cmsStatisticsTotal);
				}else {
					flag = statisticService.addCmsStatisticByCondition(cmsStatisticsTotal);
				}
			}
		}catch (Exception e){
			flag = 0;
			logger.error("周藏品数据统计错误", e);
		}
		cmsStatisticsList=statisticAntiqueUserService.queryAntiqueStatisticsByType(Constant.Month_TaskJob);
		try {
			for(CmsStatistics cmsStatisticsTotal :cmsStatisticsList){
//                 查询表中是否有数据
				int count = statisticService.cmsStatisticCountById(cmsStatisticsTotal.getsId());
				// 统计类型 1：场馆 2：活动 3：藏品 4.团体游客
				cmsStatisticsTotal.setsType(Constant.type3);
				if(count>0){
					flag=statisticService.editCmsStatisticByCondition(cmsStatisticsTotal);
				}else {
					flag = statisticService.addCmsStatisticByCondition(cmsStatisticsTotal);
				}
			}
		}catch (Exception e){
			flag = 0;
			logger.error("月藏品数据统计错误", e);
		}
		cmsStatisticsList=statisticAntiqueUserService.queryAntiqueStatisticsByType(Constant.OneQuarter_TaskJob);
		try {
			for(CmsStatistics cmsStatisticsTotal :cmsStatisticsList){
//                 查询表中是否有数据
				int count = statisticService.cmsStatisticCountById(cmsStatisticsTotal.getsId());
				// 统计类型 1：场馆 2：活动 3：藏品 4.团体游客
				cmsStatisticsTotal.setsType(Constant.type3);
				if(count>0){
					flag=statisticService.editCmsStatisticByCondition(cmsStatisticsTotal);
				}else {
					flag = statisticService.addCmsStatisticByCondition(cmsStatisticsTotal);
				}
			}
		}catch (Exception e){
			flag = 0;
			logger.error("第一季度藏品数据统计错误", e);
		}
		cmsStatisticsList=statisticAntiqueUserService.queryAntiqueStatisticsByType(Constant.TwoQuarter_TaskJob);
		try {
			for(CmsStatistics cmsStatisticsTotal :cmsStatisticsList){
//                 查询表中是否有数据
				int count = statisticService.cmsStatisticCountById(cmsStatisticsTotal.getsId());
				// 统计类型 1：场馆 2：活动 3：藏品 4.团体游客
				cmsStatisticsTotal.setsType(Constant.type3);
				if(count>0){
					flag=statisticService.editCmsStatisticByCondition(cmsStatisticsTotal);
				}else {
					flag = statisticService.addCmsStatisticByCondition(cmsStatisticsTotal);
				}
			}
		}catch (Exception e){
			flag = 0;
			logger.error("第二季度藏品数据统计错误", e);
		}
		cmsStatisticsList=statisticAntiqueUserService.queryAntiqueStatisticsByType(Constant.ThirdQuarter_TaskJob);
		try {
			for(CmsStatistics cmsStatisticsTotal :cmsStatisticsList){
//                 查询表中是否有数据
				int count = statisticService.cmsStatisticCountById(cmsStatisticsTotal.getsId());
				// 统计类型 1：场馆 2：活动 3：藏品 4.团体游客
				cmsStatisticsTotal.setsType(Constant.type3);
				if(count>0){
					flag=statisticService.editCmsStatisticByCondition(cmsStatisticsTotal);
				}else {
					flag = statisticService.addCmsStatisticByCondition(cmsStatisticsTotal);
				}
			}
		}catch (Exception e){
			flag = 0;
			logger.error("第三季度藏品数据统计错误", e);
		}
		cmsStatisticsList=statisticAntiqueUserService.queryAntiqueStatisticsByType(Constant.FourQuarter_TaskJob);
		try {
			for(CmsStatistics cmsStatisticsTotal :cmsStatisticsList){
//                 查询表中是否有数据
				int count = statisticService.cmsStatisticCountById(cmsStatisticsTotal.getsId());
				// 统计类型 1：场馆 2：活动 3：藏品 4.团体游客
				cmsStatisticsTotal.setsType(Constant.type3);
				if(count>0){
					flag=statisticService.editCmsStatisticByCondition(cmsStatisticsTotal);
				}else {
					flag = statisticService.addCmsStatisticByCondition(cmsStatisticsTotal);
				}
			}
		}catch (Exception e){
			flag = 0;
			logger.error("第四季度藏品数据统计错误", e);
		}
		cmsStatisticsList=statisticAntiqueUserService.queryAntiqueStatisticsByType(Constant.Year_TaskJob);
		try {
			for(CmsStatistics cmsStatisticsTotal :cmsStatisticsList){
//                 查询表中是否有数据
				int count = statisticService.cmsStatisticCountById(cmsStatisticsTotal.getsId());
				// 统计类型 1：场馆 2：活动 3：藏品 4.团体游客
				cmsStatisticsTotal.setsType(Constant.type3);
				if(count>0){
					flag=statisticService.editCmsStatisticByCondition(cmsStatisticsTotal);
				}else {
					flag = statisticService.addCmsStatisticByCondition(cmsStatisticsTotal);
				}
			}
		}catch (Exception e){
			flag = 0;
			logger.error("年藏品数据统计错误", e);
		}
	}
}
