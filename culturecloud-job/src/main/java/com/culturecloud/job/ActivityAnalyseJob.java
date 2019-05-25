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
//import com.culturecloud.model.bean.analyse.SysActivityPromote;
//import com.culturecloud.model.bean.analyse.SysParamsConfig;
//import com.culturecloud.service.BaseService;
//import com.culturecloud.service.SysLogUtil;
//import com.culturecloud.utils.DateUtils;
//import com.culturecloud.utils.StringUtils;
//
//@Component("activityAnalyseJob")
//public class ActivityAnalyseJob {
//
//	@Resource
//	private BaseService baseService;
//	
//	public void activityAnalyse() throws Exception{
//		
//		System.out.println("统计各个活动详情页job-------start-------");
//		
//		List<SysParamsConfig> startDates = baseService.find(SysParamsConfig.class, " where business_id='activityModel'");
//		if (startDates != null && startDates.size() > 0) {
//			
//			String startDate = startDates.get(0).getConfigValue();
//			Date date = getDateByStr(startDate);
//			Date nextDate = DateUtils.addDays(date, 1);
//			String nextDateStr = getDateStr(nextDate);
//			
//			List<SystemLogVO> list = SysLogUtil.SysLogToSysLogList(startDate);
//			
//			Map map = new HashMap();
//			
//			for(int i=0;i<list.size();i++)
//			{
//
//				if(list.get(i).getMethodName()!=null&&(list.get(i).getMethodName().equals("activityWcDetail")||list.get(i).getMethodName().equals("cmsActivityAppDetail")))
//				{
//					
//					String param=list.get(i).getParams();
//					String[] params=param.split(",");
//					for(int j=0;j<params.length;j++)
//					{
//						if(params[j]!=null&&params[j].toString().indexOf("activityId")!=-1)
//						{
//							String activityId=params[j].toString().substring(11,43);
//							if(map.containsKey(activityId))
//							{
//								int num=(int) map.get(activityId)+1;
//								map.remove(activityId);
//								map.put(activityId, num);
//							}
//							else
//							{
//								map.put(activityId, 1);
//							}
//						}
//					}
//
//				}
//				
//			}
//			if(map!=null&&map.size()>0)
//			{
//				Set<Map.Entry<String, String>> set = map.entrySet();
//
//				for (Map.Entry entry : set) {
//					 SysActivityPromote o=new SysActivityPromote();
//					 o.setId(StringUtils.getUUID());
//					 o.setLogTime(date);
//					 o.setActivityId(entry.getKey().toString());
//					 o.setVisitNum(Integer.valueOf(entry.getValue().toString()));
//					 baseService.create(o);
//				}
//			}
//			
//			SysParamsConfig config = new SysParamsConfig();
//			config.setBusinessId(startDates.get(0).getBusinessId());
//			config.setConfigDescription(startDates.get(0).getConfigDescription());
//			config.setConfigName(startDates.get(0).getConfigName());
//			config.setConfigValue(nextDateStr);
//			baseService.update(config, " where business_id='activityModel' ");
//			
//		}
//		
//		System.out.println("统计各个活动详情页job-------end-------");
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
