//package com.culturecloud.job;
//
//import java.text.ParseException;
//import java.text.SimpleDateFormat;
//import java.util.Date;
//import java.util.List;
//
//import javax.annotation.Resource;
//
//import org.springframework.stereotype.Component;
//
//import com.culturecloud.bean.SystemLogVO;
//import com.culturecloud.model.bean.analyse.SysParamsConfig;
//import com.culturecloud.model.bean.analyse.SysVisitSum;
//import com.culturecloud.service.BaseService;
//import com.culturecloud.service.SysLogUtil;
//import com.culturecloud.util.PpsConfig;
//import com.culturecloud.utils.DateUtils;
//import com.culturecloud.utils.StringUtils;
//
//@Component("userAnalyseJob")
//public class UserAnalyseJob {
//
//	@Resource
//	private BaseService baseService;
//	
//	//private static String readPath=PpsConfig.getString("read.path");
//	
//	
//	
//	public void visitRecords(){
//
//		System.out.println("访问记录job-------start-------");
//		
//		List<SysParamsConfig> startDates = baseService.find(SysParamsConfig.class, " where business_id='writeLog'");
//		if (startDates != null && startDates.size() > 0) {
//			int num;
////			while(num>-1)
////			{
//				String startDate = startDates.get(0).getConfigValue();
//				
//				String[] dates=startDate.split("-");
//				Date date =null;
//				
//				
//				if(dates.length==3)
//				{
//					num =-1;
//					date = getDateByStr(startDate);
//				}
//				else
//				{
//					String[] dates1=startDate.split("-");
//					date = getDateByStr(dates1[0]+"-"+dates1[1]+"-"+dates1[2]);
//					num = Integer.valueOf(dates[3]);
//				}
//				
//				
//				
//				
//				Date nextDate = DateUtils.addDays(date, 1);
//				
//
//				int h5Num = 0;
//				int iosNum = 0;
//				int androidNum = 0;
//
//				List<SystemLogVO> list;
//				try {
//					list = SysLogUtil.SysLogToSysLogList(startDate,num);
//					for (int i = 0; i < list.size(); i++) {
//						if (list.get(i).getSystemTemplate() != null && list.get(i).getSystemTemplate().equals("h5")&&
//								!list.get(i).getMethodName().equals("appWillStartActivityCount")) {
//							h5Num++;
//						}
//
//						if (list.get(i).getSystemTemplate() != null && list.get(i).getSystemTemplate().equals("iphone")&&
//								!list.get(i).getMethodName().equals("appWillStartActivityCount")) {
//							iosNum++;
//						}
//
//						if (list.get(i).getSystemTemplate() != null && list.get(i).getSystemTemplate().equals("android")&&
//								!list.get(i).getMethodName().equals("appWillStartActivityCount")) {
//							androidNum++;
//						}
//					}
//
//					List<SysVisitSum> lists=baseService.find(SysVisitSum.class," where log_time='"+getDateStr(date)+" 00:00:000'");
//					if(lists.size()>0)
//					{
//						SysVisitSum o =lists.get(0);
//						o.setAndroidNum(Integer.valueOf(lists.get(0).getAndroidNum())+androidNum);
//						o.setH5Num(Integer.valueOf(lists.get(0).getH5Num())+h5Num);
//						o.setIosNum(Integer.valueOf(lists.get(0).getIosNum())+iosNum);
//						o.setAllnum(Integer.valueOf(lists.get(0).getAllnum())+list.size());
//						o.setLogTime(date);
//						baseService.update(o, " where id='"+lists.get(0).getId()+"'");
//					}
//					else
//					{
//						SysVisitSum o = new SysVisitSum();
//						o.setId(StringUtils.getUUID());
//						o.setAndroidNum(androidNum);
//						o.setAllnum(list.size());
//						o.setH5Num(h5Num);
//						o.setIosNum(iosNum);
//						o.setLogTime(date);
//						baseService.create(o);
//					}
//
//					SysParamsConfig config = new SysParamsConfig();
//					config.setBusinessId(startDates.get(0).getBusinessId());
//					config.setConfigDescription(startDates.get(0).getConfigDescription());
//					config.setConfigName(startDates.get(0).getConfigName());	
//					config.setConfigValue(getDateStr(date)+"-"+(num+1));
//					baseService.update(config, " where business_id='writeLog' ");
//					
//				} catch (Exception e) {
//					// TODO Auto-generated catch block
//					String nextDateStr = getDateStr(nextDate);
//					SysParamsConfig config = new SysParamsConfig();
//					config.setBusinessId(startDates.get(0).getBusinessId());
//					config.setConfigDescription(startDates.get(0).getConfigDescription());
//					config.setConfigName(startDates.get(0).getConfigName());
//					config.setConfigValue(nextDateStr);
//					baseService.update(config, " where business_id='writeLog' ");
//					//e.printStackTrace();
//				}
//
//			}
//			
//			
//			
//			
//			
//			
//			
////		}
//		System.out.println("访问记录job-------end-------");
//	}
//	
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
//
//	
//}
