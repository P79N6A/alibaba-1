package com.sun3d.why.job;

import com.sun3d.why.controller.SysModuleController;
import com.sun3d.why.model.CmsStatistics;
import com.sun3d.why.statistics.service.StatisticService;
import com.sun3d.why.statistics.service.StatisticTermUserService;
import com.sun3d.why.util.Constant;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.sql.Timestamp;
import java.util.List;

/**
 *团体游客统计数据
 */
@Component("teamTaskJob")
public class TeamTaskJob {
	/**
	 * 导入log4j日志管理，记录错误信息
	 */
	private Logger logger = Logger.getLogger(SysModuleController.class
			.getName());
	/**
	 * 团体游客明细表，注解自动注入
	 */
	@Autowired
	private StatisticTermUserService statisticTermUserService;
	/**
	 * 模块管理service层对象，注解自动注入
	 */
	@Autowired
	private StatisticService statisticService;

//	@Autowired
//	private HttpSession session;

	public void teamTaskJob() throws Exception {
		List<CmsStatistics> cmsStatisticsList;

		cmsStatisticsList=statisticTermUserService.queryTeamStatisticsByType(Constant.Week_TaskJob);
		int flag=0;
		try {
			for(CmsStatistics cmsStatisticsTotal :cmsStatisticsList){
//                 查询表中是否有数据
				int count = statisticService.cmsStatisticCountById(cmsStatisticsTotal.getsId());
				// 统计类型 1：场馆 2：活动 3：藏品 4.团体
				cmsStatisticsTotal.setsType(Constant.type4);
				cmsStatisticsTotal.setCreateTime(new Timestamp(System.currentTimeMillis()));
				cmsStatisticsTotal.setUpdateTime(new Timestamp(System.currentTimeMillis()));
//				SysUser sysUser=(SysUser) session.getAttribute("user");
//				if(sysUser!=null&&sysUser.getUserCreateUser()!=null) {
//					cmsStatisticsTotal.setCreateUser(sysUser.getUserCreateUser());
//				}
//				if(sysUser!=null&&sysUser.getUserUpdateUser()!=null){
//					cmsStatisticsTotal.setUpdateUser(sysUser.getUserUpdateUser());
//				}
				//不可从session中获取用户、默认为系统管理员进行统计
				//cmsStatisticsTotal.setCreateUser("admin");
				//cmsStatisticsTotal.setUpdateUser("admin");
				if(count>0){
					flag=statisticService.editCmsStatisticByCondition(cmsStatisticsTotal);
				}else {
					flag = statisticService.addCmsStatisticByCondition(cmsStatisticsTotal);
				}
			}
		}catch (Exception e){
			flag = 0;
			logger.error("周团体游客数据统计错误", e);
		}
		cmsStatisticsList=statisticTermUserService.queryTeamStatisticsByType(Constant.Month_TaskJob);
		try {
			for(CmsStatistics cmsStatisticsTotal :cmsStatisticsList){
//                 查询表中是否有数据
				int count = statisticService.cmsStatisticCountById(cmsStatisticsTotal.getsId());
				// 统计类型 1：场馆 2：活动 3：藏品 4.团体
				cmsStatisticsTotal.setsType(Constant.type4);
				if(count>0){
					flag=statisticService.editCmsStatisticByCondition(cmsStatisticsTotal);
				}else {
					flag = statisticService.addCmsStatisticByCondition(cmsStatisticsTotal);
				}
			}
		}catch (Exception e){
			flag = 0;
			logger.error("月团体游客数据统计错误", e);
		}
		cmsStatisticsList=statisticTermUserService.queryTeamStatisticsByType(Constant.OneQuarter_TaskJob);
		try {
			for(CmsStatistics cmsStatisticsTotal :cmsStatisticsList){
//                 查询表中是否有数据
				int count = statisticService.cmsStatisticCountById(cmsStatisticsTotal.getsId());
				//统计类型 1：场馆 2：活动 3：藏品 4.团体游客
				cmsStatisticsTotal.setsType(Constant.type4);
				if(count>0){
					flag=statisticService.editCmsStatisticByCondition(cmsStatisticsTotal);
				}else {
					flag = statisticService.addCmsStatisticByCondition(cmsStatisticsTotal);
				}
			}
		}catch (Exception e){
			flag = 0;
			logger.error("第一季度活动数据统计错误", e);
		}
		cmsStatisticsList=statisticTermUserService.queryTeamStatisticsByType(Constant.TwoQuarter_TaskJob);
		try {
			for(CmsStatistics cmsStatisticsTotal :cmsStatisticsList){
//                 查询表中是否有数据
				int count = statisticService.cmsStatisticCountById(cmsStatisticsTotal.getsId());
				// 统计类型 1：场馆 2：活动 3：藏品 4.团体
				cmsStatisticsTotal.setsType(Constant.type4);
				if(count>0){
					flag=statisticService.editCmsStatisticByCondition(cmsStatisticsTotal);
				}else {
					flag = statisticService.addCmsStatisticByCondition(cmsStatisticsTotal);
				}
			}
		}catch (Exception e){
			flag = 0;
			logger.error("第二季度团体游客数据统计错误", e);
		}
		cmsStatisticsList=statisticTermUserService.queryTeamStatisticsByType(Constant.ThirdQuarter_TaskJob);
		try {
			for(CmsStatistics cmsStatisticsTotal :cmsStatisticsList){
//                 查询表中是否有数据
				int count = statisticService.cmsStatisticCountById(cmsStatisticsTotal.getsId());
				// 统计类型 1：场馆 2：活动 3：藏品 4.团体
				cmsStatisticsTotal.setsType(Constant.type4);
				if(count>0){
					flag=statisticService.editCmsStatisticByCondition(cmsStatisticsTotal);
				}else {
					flag = statisticService.addCmsStatisticByCondition(cmsStatisticsTotal);
				}
			}
		}catch (Exception e){
			flag = 0;
			logger.error("第三季度团体游客数据统计错误", e);
		}
		cmsStatisticsList=statisticTermUserService.queryTeamStatisticsByType(Constant.FourQuarter_TaskJob);
		try {
			for(CmsStatistics cmsStatisticsTotal :cmsStatisticsList){
//                 查询表中是否有数据
				int count = statisticService.cmsStatisticCountById(cmsStatisticsTotal.getsId());
				// 统计类型 1：场馆 2：活动 3：藏品 4.团体
				cmsStatisticsTotal.setsType(Constant.type4);
				if(count>0){
					flag=statisticService.editCmsStatisticByCondition(cmsStatisticsTotal);
				}else {
					flag = statisticService.addCmsStatisticByCondition(cmsStatisticsTotal);
				}
			}
		}catch (Exception e){
			flag = 0;
			logger.error("第四季度团体游客数据统计错误", e);
		}
		cmsStatisticsList=statisticTermUserService.queryTeamStatisticsByType(Constant.Year_TaskJob);
		try {
			for(CmsStatistics cmsStatisticsTotal :cmsStatisticsList){
//                 查询表中是否有数据
				int count = statisticService.cmsStatisticCountById(cmsStatisticsTotal.getsId());
				// 统计类型 1：场馆 2：活动 3：藏品 4.团体
				cmsStatisticsTotal.setsType(Constant.type4);
				if(count>0){
					flag=statisticService.editCmsStatisticByCondition(cmsStatisticsTotal);
				}else {
					flag = statisticService.addCmsStatisticByCondition(cmsStatisticsTotal);
				}
			}
		}catch (Exception e){
			flag = 0;
			logger.error("年团体游客数据统计错误", e);
		}
	}
}
