package com.culturecloud.job;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.Vector;

import javax.annotation.PostConstruct;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.culturecloud.coreutils.DateUtil;
import com.culturecloud.dao.activity.CmsActivityMapper;
import com.culturecloud.dao.activity.CmsActivityOrderMapper;
import com.culturecloud.dao.dto.activity.CmsActivityOrderDto;
import com.culturecloud.dao.dto.analyse.SysParamsConfigDto;
import com.culturecloud.mail.OrderCheckMail;
import com.culturecloud.model.bean.activity.CmsActivity;
import com.culturecloud.model.bean.activity.CmsActivityOrder;
import com.culturecloud.model.bean.analyse.SysParamsConfig;
import com.culturecloud.model.bean.common.SysBussinessErrorLog;
import com.culturecloud.service.local.analyse.SysParamsConfigService;
import com.culturecloud.service.local.common.SysBussinessErrorLogService;

/**
 * 订单数据检查
 * 
 * @author zhangshun
 *
 */
@Component("orderCheckTaskJob")
public class OrderCheckTaskJob {
	
	private Logger logger = Logger.getLogger(this.getClass());

	@Autowired
	private SysParamsConfigService sysParamsConfigService;
	@Autowired
	private SysBussinessErrorLogService sysBussinessErrorLogService;
	
	@Autowired
	private CmsActivityOrderMapper cmsActivityOrderMapper;
	
	@Autowired
	private CmsActivityMapper cmsActivityMapper;
	
	// 业务名称
	private static String BUSINESS_NAME="checkOrder";
	
	@PostConstruct
	public void init(){
		
	
		
	}
	
	// 监测订单数据
	public void orderCheck(){
		
		logger.info("********orderCheck检测订单数据定时器执行任务************");
		
	

		HashMap<String,String> paramConfigMap=this.getParamConfigMap();
		
		// 查询数据
		Map<String,Object>map=new HashMap<String,Object>();
		
		// 查询订单开始时间
		String date=paramConfigMap.get("date");
		
		String rows=paramConfigMap.get("rows");
		
		List<SysBussinessErrorLog> errorLogList=new ArrayList<>();

		// 查询日期为空
		if(StringUtils.isNotBlank(date)){
			
			// dateStr=DateUtils.getDateToString(new Date());
			map.put("date", date);
		}
		
		map.put("rows", Integer.valueOf(rows));
		
		// 查询订单列表
		List<CmsActivityOrderDto> orderList=cmsActivityOrderMapper.queryCheckOrderList(map);
		
		logger.info("********orderCheck检测订单数据 获取订单行数："+orderList.size()+"查询开始时间："+date+"************");
		
		Map<String,CmsActivity> cmsActivityHashMap=new HashMap<String,CmsActivity>();
			
		for (int i = 0; i < orderList.size(); i++) {
			
			CmsActivityOrder cmsActivityOrder=orderList.get(i);
			
			try {
			
			if(i== orderList.size()-1)
			{
				Date createTime=cmsActivityOrder.getOrderCreateTime();
				
				int result=this.updateTime(paramConfigMap,createTime);
				
			}
			
			String orderId=cmsActivityOrder.getActivityOrderId();
			
			String userId=cmsActivityOrder.getUserId();
			
			if(StringUtils.isBlank(userId))
			{
				errorLogList.add(this.createNewInstace(orderId, "订单中用户id为空    订单信息："+getOrderInfo(orderId)));
				continue;
			}
			
			// 活动ID
			String activityId=cmsActivityOrder.getActivityId();
			
			if(StringUtils.isBlank(activityId))
			{
				errorLogList.add(this.createNewInstace(orderId, "订单中活动id为空     订单信息："+getOrderInfo(orderId)));
				continue;
			}
			
			CmsActivity activity=null;
			
			if(cmsActivityHashMap.containsKey(activityId))
			{
				activity=cmsActivityHashMap.get(activityId);
			}
			else
			{
				activity=cmsActivityMapper.selectByPrimaryKey(activityId);
				if(activity==null)
				{
					errorLogList.add(this.createNewInstace(orderId, "订单中活动id对应数据不存在   活动id"+activityId));
					continue;
				}
				else
				{
					cmsActivityHashMap.put(activityId, activity);
				}
			}
			
			//参与此活动消耗的积分数
			/**Integer costCredit=activity.getCostCredit();
			
			// 订单消耗积分
			String costTotalCredit=cmsActivityOrder.getCostTotalCredit();
			
			if(costCredit==null)
			{
				if(StringUtils.isNotBlank(costTotalCredit))
				{
					try {
						Integer totalCredit=Integer.valueOf(costTotalCredit);
						
						if(totalCredit!=0)
						{
							errorLogList.add(this.createNewInstace(orderId, "订单中活动无需消耗积分"));
							continue;
						}
					} catch (NumberFormatException e) {
						
						errorLogList.add(this.createNewInstace(orderId, "订单消耗积分数据不正确"));
						continue;
					}
				}
			}
			else{
				try {
					Integer totalCredit=Integer.valueOf(costTotalCredit);
					
					int votes=cmsActivityOrder.getOrderVotes();
					
					if(costCredit.intValue()*votes!=totalCredit.intValue())
					{
						errorLogList.add(this.createNewInstace(orderId, "订单消耗积分与活动所需积分不一致"));
						continue;
					}
					
				} catch (NumberFormatException e) {
					
					errorLogList.add(this.createNewInstace(orderId, "订单消耗积分数据不正确"));
					continue;
				}
			}**/
			
			// 在线座位
			if ("Y".equals(activity.getActivitySalesOnline())) 
			{
				// 选作信息
				String orderSummary=cmsActivityOrder.getOrderSummary();
				
				if(StringUtils.isBlank(orderSummary))
				{
					errorLogList.add(this.createNewInstace(orderId, "订单无座位信息     订单信息："+getOrderInfo(orderId)));
					continue;
				}
				
				String seats[]=orderSummary.split(",");
				
				Set<String> seatSet=new HashSet<String>();
				
				for (int j = 0; j < seats.length; j++) {
					
					String seat=seats[j];
					
					if(StringUtils.isNotBlank(seat)){
						
						if(seatSet.contains(seat))
						{
							errorLogList.add(this.createNewInstace(orderId, "订单座位重复选择     订单信息："+getOrderInfo(orderId)));
							continue;
						}
						else
							seatSet.add(seat);
					}
					
				}
				
				
				Map<String,Object> searchRepeatSeatMap=new HashMap<String,Object>();
				
				searchRepeatSeatMap.put("orderId", orderId);
				
				searchRepeatSeatMap.put("orderSeat", cmsActivityOrder.getOrderSummary());
				
				searchRepeatSeatMap.put("activityId", activityId);
				
				String [] orderArry=cmsActivityOrderMapper.queryOrderRepeatSeat(searchRepeatSeatMap);
				
				if(orderArry!=null&&orderArry.length>0)
				{
					StringBuffer sb=new StringBuffer("订单座位重复预定");
					sb.append("<br>所属活动："+activity.getActivityName());
					
					for (String activityOrderId : orderArry) {
						
						sb.append("重复订单id:"+activityOrderId+"  "+getOrderInfo(activityOrderId));
					}
					
					errorLogList.add(this.createNewInstace(orderId, sb.toString()));
					continue;
				}
				
			}
			// 自由入座
			else {
				
			}

			} catch (Exception e) {
				
				e.printStackTrace();
				
				logger.info("********orderCheck处理业务出错！出错订单ID:"+cmsActivityOrder.getActivityOrderId()+" exception:"+e.getMessage()+"************");
				
				errorLogList.add(this.createNewInstace(cmsActivityOrder.getActivityOrderId(), "监测订单过程中系统报错 exception："+e.getMessage()));
				
				continue;
			}
		}
		
		sendMail(errorLogList,date,rows);
		
		logger.info("********orderCheck检测订单数据定时器执行结束************");
		
		
	}
	
	/**
	 * 获取订单信息
	 * 
	 * @param ActivityOrderId
	 * @return
	 */
	private String getOrderInfo(String activityOrderId){
		
		
		CmsActivityOrder order=cmsActivityOrderMapper.queryCmsActivityOrderById(activityOrderId);
		
		StringBuffer sb=new StringBuffer();
		sb.append("<br>");
		
		sb.append("订单号："+order.getOrderNumber()!=null?order.getOrderNumber():""+" 订单姓名："+order.getOrderName()!=null?order.getOrderName():""+" 订单手机："+order.getOrderPhoneNo()!=null?order.getOrderPhoneNo():"");
		sb.append(" 订票数："+order.getOrderVotes()!=null?order.getOrderVotes():"");
		
		Date orderCreateTime=order.getOrderCreateTime();
		
		sb.append(" 下单时间："+orderCreateTime!=null?new SimpleDateFormat(DateUtil.YY_MM_DD_HH_MM).format(orderCreateTime):"");
		
		return sb.toString();
	}
	
	/**
	 * 发送错误邮箱
	 * @param errorLogList
	 */
	private void sendMail(List<SysBussinessErrorLog> errorLogList,String date,String rows)
	{
		
		Collection<SysBussinessErrorLog> nuCon = new Vector<SysBussinessErrorLog>(); 
		
		nuCon.add(null);
		
		errorLogList.removeAll(nuCon);
		
		if(errorLogList.size()>0) 
		{
			logger.info("********orderCheck开始发送邮箱************");
			
			try {
				OrderCheckMail.send(errorLogList,date, rows);
				
				logger.info("********orderCheck开始发送邮箱成功！************");
			} catch (Exception e) {
				e.printStackTrace();
				
				logger.info("********orderCheck发送错误邮箱失败！exception:"+e.getMessage()+"************");
			}
		}
	}
	
	private HashMap<String,String> getParamConfigMap (){
		
		HashMap<String,String> paramConfigMap=new HashMap<String,String>();
		
		List<SysParamsConfigDto> params=sysParamsConfigService.queryParamsConfigByBusinessId(BUSINESS_NAME);
		
		for (SysParamsConfig sysParamsConfig : params) {
			
			String value=sysParamsConfig.getConfigValue();
			
			if(StringUtils.isBlank(value))
				value=null;
			
			paramConfigMap.put(sysParamsConfig.getConfigName(),value );
		}
		
		return paramConfigMap;
	}
	
	private int updateTime(HashMap<String,String> paramConfigMap,Date updateTime)
	{
		SimpleDateFormat sdf = new SimpleDateFormat("YYYY-MM-dd HH:mm:ss.SSS"); 
		
		String strDatetime =sdf.format(updateTime);
		
		SysParamsConfig config=new SysParamsConfig();
		config.setConfigName("date");
		config.setConfigValue(strDatetime);
		config.setBusinessId(BUSINESS_NAME);
		int result=sysParamsConfigService.updateSelective(config);
		
		if(result>0)
		{
			paramConfigMap.put("date", strDatetime);
			
			logger.info("********orderCheck检测完订单修改查询日期："+strDatetime+"************");
		}
		
		return result;
	}
	
	/**
	 * 保存错误日志
	 * @param bussinessKeyId
	 * @param errorDescription
	 * @return
	 */
	private SysBussinessErrorLog createNewInstace(String bussinessKeyId,String errorDescription){
		SysBussinessErrorLog log=sysBussinessErrorLogService.createNewInstace(bussinessKeyId, errorDescription, BUSINESS_NAME);
		return log;
	}
}
