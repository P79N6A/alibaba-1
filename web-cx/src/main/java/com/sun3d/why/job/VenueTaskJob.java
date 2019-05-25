package com.sun3d.why.job;

import com.sun3d.why.controller.SysModuleController;
import com.sun3d.why.model.CmsStatistics;
import com.sun3d.why.statistics.service.StatisticService;
import com.sun3d.why.statistics.service.StatisticVenueUserService;
import com.sun3d.why.util.Constant;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpSession;
import java.sql.Timestamp;
import java.util.List;

/**
 *馆藏统计数据
 */
@Component("venueTaskJob")
public class VenueTaskJob {
	/**
	 * 导入log4j日志管理，记录错误信息
	 */
	private Logger logger = Logger.getLogger(SysModuleController.class
			.getName());
	/**
	 * 馆藏关系表，注解自动注入
	 */
	@Autowired
	private StatisticVenueUserService statisticVenueUserService;
	/**
	 * 模块管理service层对象，注解自动注入
	 */
	@Autowired
	private StatisticService statisticService;

	@Autowired
	private HttpSession session;

	public void venueTaskJob() throws Exception {
		List<CmsStatistics> cmsStatisticsList;
		//根据周进行馆藏统计
		// selectVenueUser
		cmsStatisticsList=statisticVenueUserService.queryVenueStatisticsByType(Constant.Week_TaskJob);
		int flag=0;
		try {
			for(CmsStatistics cmsStatisticsTotal :cmsStatisticsList){
//                 查询表中是否有数据
				int count = statisticService.cmsStatisticCountById(cmsStatisticsTotal.getsId());
				cmsStatisticsTotal.setsType(Constant.type1);
				cmsStatisticsTotal.setCreateTime(new Timestamp(System.currentTimeMillis()));
				cmsStatisticsTotal.setUpdateTime(new Timestamp(System.currentTimeMillis()));
				/*SysUser sysUser=(SysUser) session.getAttribute("user");
				if(sysUser!=null&&sysUser.getUserCreateUser()!=null) {
					cmsStatisticsTotal.setCreateUser(sysUser.getUserCreateUser());
				}
				if(sysUser!=null&&sysUser.getUserUpdateUser()!=null){
					cmsStatisticsTotal.setUpdateUser(sysUser.getUserUpdateUser());
				}*/
				if(count>0){
					 //表中存在馆藏数据
					flag=statisticService.editCmsStatisticByCondition(cmsStatisticsTotal);
				}else {
					//表中不存在数据
					flag = statisticService.addCmsStatisticByCondition(cmsStatisticsTotal);
				}
			}
		}catch (Exception e){
			flag = 0;
			logger.error("场馆数据统计错误", e);
		}
		//根据月进行馆藏统计
		cmsStatisticsList=statisticVenueUserService.queryVenueStatisticsByType(Constant.Month_TaskJob);
		try {
			for(CmsStatistics cmsStatisticsTotal :cmsStatisticsList){
//                 查询表中是否有数据
				int count = statisticService.cmsStatisticCountById(cmsStatisticsTotal.getsId());
				// 统计类型 1：场馆 2：活动 3：藏品 4.团体游客
				cmsStatisticsTotal.setsType(Constant.type1);
				if(count>0){
					flag=statisticService.editCmsStatisticByCondition(cmsStatisticsTotal);
				}else {
					flag = statisticService.addCmsStatisticByCondition(cmsStatisticsTotal);
				}
			}
		}catch (Exception e){
			flag = 0;
			logger.error("月场馆数据统计错误", e);
		}
		cmsStatisticsList=statisticVenueUserService.queryVenueStatisticsByType(Constant.OneQuarter_TaskJob);
		try {
			for(CmsStatistics cmsStatisticsTotal :cmsStatisticsList){
//                 查询表中是否有数据
				int count = statisticService.cmsStatisticCountById(cmsStatisticsTotal.getsId());
				// 统计类型 1：场馆 2：活动 3：藏品 4.团体游客
				cmsStatisticsTotal.setsType(Constant.type1);
				if(count>0){

					flag=statisticService.editCmsStatisticByCondition(cmsStatisticsTotal);
				}else {
					flag = statisticService.addCmsStatisticByCondition(cmsStatisticsTotal);
				}
			}
		}catch (Exception e){
			flag = 0;
			logger.error("第一季度场馆数据统计错误", e);
		}
		cmsStatisticsList=statisticVenueUserService.queryVenueStatisticsByType(Constant.TwoQuarter_TaskJob);
		try {
			for(CmsStatistics cmsStatisticsTotal :cmsStatisticsList){
//                 查询表中是否有数据
				int count = statisticService.cmsStatisticCountById(cmsStatisticsTotal.getsId());
				// 统计类型 1：场馆 2：活动 3：藏品 4.团体游客
				cmsStatisticsTotal.setsType(Constant.type1);
				if(count>0){
					flag=statisticService.editCmsStatisticByCondition(cmsStatisticsTotal);
				}else {
					flag = statisticService.addCmsStatisticByCondition(cmsStatisticsTotal);
				}
			}
		}catch (Exception e){
			flag = 0;
			logger.error("第二季度场馆数据统计错误", e);
		}
		cmsStatisticsList=statisticVenueUserService.queryVenueStatisticsByType(Constant.ThirdQuarter_TaskJob);
		try {
			for(CmsStatistics cmsStatisticsTotal :cmsStatisticsList){
//                 查询表中是否有数据
				int count = statisticService.cmsStatisticCountById(cmsStatisticsTotal.getsId());
				// 统计类型 1：场馆 2：活动 3：藏品 4.团体游客
				cmsStatisticsTotal.setsType(Constant.type1);
				if(count>0){
					flag=statisticService.editCmsStatisticByCondition(cmsStatisticsTotal);
				}else {
					flag = statisticService.addCmsStatisticByCondition(cmsStatisticsTotal);
				}
			}
		}catch (Exception e){
			flag = 0;
			logger.error("第三季度场馆数据统计错误", e);
		}
		cmsStatisticsList=statisticVenueUserService.queryVenueStatisticsByType(Constant.FourQuarter_TaskJob);
		try {
			for(CmsStatistics cmsStatisticsTotal :cmsStatisticsList){
//                 查询表中是否有数据
				int count = statisticService.cmsStatisticCountById(cmsStatisticsTotal.getsId());
				// 统计类型 1：场馆 2：活动 3：藏品 4.团体游客
				cmsStatisticsTotal.setsType(Constant.type1);
				if(count>0){
					flag=statisticService.editCmsStatisticByCondition(cmsStatisticsTotal);
				}else {
					flag = statisticService.addCmsStatisticByCondition(cmsStatisticsTotal);
				}
			}
		}catch (Exception e){
			flag = 0;
			logger.error("第四季度场馆数据统计错误", e);
		}
		cmsStatisticsList=statisticVenueUserService.queryVenueStatisticsByType(Constant.Year_TaskJob);
		try {
			for(CmsStatistics cmsStatisticsTotal :cmsStatisticsList){
//                 查询表中是否有数据
				int count = statisticService.cmsStatisticCountById(cmsStatisticsTotal.getsId());
				// 统计类型 1：场馆 2：活动 3：藏品 4.团体游客
				cmsStatisticsTotal.setsType(Constant.type1);
				if(count>0){
					flag=statisticService.editCmsStatisticByCondition(cmsStatisticsTotal);
				}else {
					flag = statisticService.addCmsStatisticByCondition(cmsStatisticsTotal);
				}
			}
		}catch (Exception e){
			flag = 0;
			logger.error("年场馆数据统计错误", e);
		}
	}
}
