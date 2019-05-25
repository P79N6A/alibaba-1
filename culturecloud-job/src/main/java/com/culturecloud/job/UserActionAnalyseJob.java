//package com.culturecloud.job;
//
//import java.text.ParseException;
//import java.text.SimpleDateFormat;
//import java.util.Date;
//import java.util.HashMap;
//import java.util.List;
//import java.util.Map;
//import java.util.Set;
//
//import javax.annotation.Resource;
//
//import org.springframework.stereotype.Component;
//
//import com.culturecloud.bean.SystemLogVO;
//import com.culturecloud.model.bean.activity.CmsActivity;
//import com.culturecloud.model.bean.analyse.SysActivityPromote;
//import com.culturecloud.model.bean.analyse.SysParamsConfig;
//import com.culturecloud.model.bean.analyse.SysUserAnalyse;
//import com.culturecloud.service.BaseService;
//import com.culturecloud.service.SysLogUtil;
//import com.culturecloud.utils.DateUtils;
//import com.culturecloud.utils.StringUtils;
//
//@Component("userActionAnalyseJob")
//public class UserActionAnalyseJob {
//
//	@Resource
//	private BaseService baseService;
//	
//	public void userActionAnalyse() throws Exception{
//		
//		System.out.println("用户行为记录job-------start-------");
//		
//		List<SysParamsConfig> startDates = baseService.find(SysParamsConfig.class, " where business_id='userAnalyse'");
//		if (startDates != null && startDates.size() > 0) {
//			
//			String startDate = startDates.get(0).getConfigValue();
//			Date date = getDateByStr(startDate);
//			Date nextDate = DateUtils.addDays(date, 1);
//			String nextDateStr = getDateStr(nextDate);
//			
//			List<SystemLogVO> list = SysLogUtil.SysLogToSysLogList(startDate);
//			
////			Map map = new HashMap();
////			
////			int visitNum=0;
////			int collectNum=0;
//			
//			for(int i=0;i<list.size();i++)
//			{
//				
//				//记录活动浏览次数、计算分数
//				if(list.get(i).getMethodName()!=null&&(list.get(i).getMethodName().equals("activityWcDetail")||list.get(i).getMethodName().equals("cmsActivityAppDetail")))
//				{
//					String param=list.get(i).getParams();
//					String[] params=param.split(",");
//					for(int j=0;j<params.length;j++)
//					{
//						
//						if(params[j]!=null&&params[j].toString().indexOf("activityId")!=-1)
//						{
//							String activityId=params[j].toString().substring(11,43);
//							String userId=list.get(i).getUserId();
//							if(userId!=null)
//							{
//								List<CmsActivity> activitys=baseService.find(CmsActivity.class, " where activity_id='"+activityId+"'");
//								if(activitys!=null&&activitys.size()>0)
//								{
//									String activityType=activitys.get(0).getActivityType();//活动类型Id
//									List<SysUserAnalyse> userAnalyses=baseService.find(SysUserAnalyse.class, " where user_id='"+userId+"' and tag_id='"+activityType+"'");
//									if(userAnalyses!=null&&userAnalyses.size()>0)
//									{
//										SysUserAnalyse o=userAnalyses.get(0);
//										o.setVisitScore(userAnalyses.get(0).getVisitScore()+1);
//										baseService.update(o, " where user_id='"+userId+"' and tag_id='"+activityType+"'");
//									}
//									else
//									{
//										SysUserAnalyse o=new SysUserAnalyse();
//										o.setUserId(userId);
//										o.setTagId(activityType);
//										o.setCollectScore(0);
//										o.setOrderScore(0);
//										o.setVisitScore(1);
//										baseService.create(o);
//									}
//								}
//							}
//						}
//					}
//				}
//				
//				//记录活动收藏次数、计算分数
//				if(list.get(i).getMethodName()!=null&&(list.get(i).getMethodName().equals("wcCollectActivity")||list.get(i).getMethodName().equals("appCollectActivity")))
//				{
//					String param=list.get(i).getParams();
//					String[] params=param.split(",");
//					for(int j=0;j<params.length;j++)
//					{
//						
//						if(params[j]!=null&&params[j].toString().indexOf("activityId")!=-1)
//						{
//							String activityId=params[j].toString().substring(11,43);
//							String userId=list.get(i).getUserId();
//							if(userId!=null)
//							{
//								List<CmsActivity> activitys=baseService.find(CmsActivity.class, " where activity_id='"+activityId+"'");
//								if(activitys!=null&&activitys.size()>0)
//								{
//									String activityType=activitys.get(0).getActivityType();//活动类型Id
//									List<SysUserAnalyse> userAnalyses=baseService.find(SysUserAnalyse.class, " where user_id='"+userId+"' and tag_id='"+activityType+"'");
//									if(userAnalyses!=null&&userAnalyses.size()>0)
//									{
//										SysUserAnalyse o=userAnalyses.get(0);
//										o.setCollectScore(userAnalyses.get(0).getCollectScore()+2);
//										baseService.update(o, " where user_id='"+userId+"' and tag_id='"+activityType+"'");
//									}
//									else
//									{
//										SysUserAnalyse o=new SysUserAnalyse();
//										o.setUserId(userId);
//										o.setTagId(activityType);
//										o.setCollectScore(2);
//										o.setOrderScore(0);
//										o.setVisitScore(0);
//										baseService.create(o);
//									}
//								}
//							}
//						}
//					}
//				}
//				
//				
//				
//			}
//			
//			
//			SysParamsConfig config = new SysParamsConfig();
//			config.setBusinessId(startDates.get(0).getBusinessId());
//			config.setConfigDescription(startDates.get(0).getConfigDescription());
//			config.setConfigName(startDates.get(0).getConfigName());
//			config.setConfigValue(nextDateStr);
//			baseService.update(config, " where business_id='userAnalyse' ");
//			
//		}
//		
//		System.out.println("用户行为记录job-------end-------");
//		
//	}
//	
//	public  Date getDateByStr(String dateStr) {
//		try {
//			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
//			return formatter.parse(dateStr);
//		} catch (ParseException e) {
//			
//			return null;
//		}
//	}
//	
//	public  String getDateStr(Date date) {
//		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
//		return formatter.format(date);
//	}
//}
