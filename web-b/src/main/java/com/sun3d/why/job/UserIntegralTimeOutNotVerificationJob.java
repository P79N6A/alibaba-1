package com.sun3d.why.job;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.apache.commons.collections.CollectionUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.sun3d.why.model.CmsActivityOrder;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CmsActivityOrderService;
import com.sun3d.why.service.UserIntegralDetailService;

import redis.clients.jedis.HostAndPort;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisSentinelPool;

/**
 * 未核销订单扣除积分定时器
 * 
 * @author zhangshun
 *
 */
@Component("userIntegralTimeOutNotVerificationJob")
public class UserIntegralTimeOutNotVerificationJob {
	
	private Logger logger = Logger.getLogger(this.getClass());
  
    @Autowired
    private UserIntegralDetailService userIntegralDetailService;
    
    @Autowired
    private CmsActivityOrderService cmsActivityOrderService;
	
    public UserIntegralTimeOutNotVerificationJob(){
    	
    	logger.info("********未核销定时器创建初始化************");
    }
	
	public void userIntegralTimeOutNotVerification(){
		
		try {
			
			logger.info("********未核销订单扣除积分定时器执行任务************");
			
			int dayAgo=4;
		
			// 查询4天前没有核销的订单
			List<CmsActivityOrder> activityOrderList=cmsActivityOrderService.queryTimeOutNotVerificationOrder(dayAgo);
	
			if(!activityOrderList.isEmpty()){
				
				
				for (CmsActivityOrder cmsActivityOrder : activityOrderList) {
					
					String userId=cmsActivityOrder.getUserId();
					String userName=cmsActivityOrder.getUserName();
					String activityId=cmsActivityOrder.getActivityId();
					Integer deductionCredit=cmsActivityOrder.getDeductionCredit();
					String orderId=cmsActivityOrder.getActivityOrderId();
					String orderNumer=cmsActivityOrder.getOrderNumber();
					
					int result=userIntegralDetailService.timeOutNotVerificationAddIntegral(userId, userName, activityId, deductionCredit, orderId, orderNumer);
					
					if(result>0)
						logger.info("********未核销订单扣除积分："+"订单ID"+orderId+" 订单号："+orderNumer+" 活动ID："+activityId+" 用户名："+userName+"用户id："+userId+"************");
				}
			}
			
			logger.info("********未核销订单扣除积分定时器处理完毕！************");
		
		} catch (Exception e) {
			
			logger.error("********未核销订单扣除积分定时器执行任务失败！************",e);
			
			e.printStackTrace();
		}
		
	}
	
	
}
