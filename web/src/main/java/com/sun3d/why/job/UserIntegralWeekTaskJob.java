package com.sun3d.why.job;

import java.util.HashSet;
import java.util.Set;

import javax.annotation.Resource;

import org.apache.commons.collections.CollectionUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.sun3d.why.enumeration.redis.IntegralRedisKeyEnum;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.redis.RedisDAO;
import com.sun3d.why.redis.vo.UserIntergralRedisVO;
import com.sun3d.why.service.UserIntegralDetailService;
import com.sun3d.why.util.redis.ListTranscoder;



/**
 * 用户每周积分 统计即时任务
 * @author zhangshun
 *
 */
@Component("userIntegralWeekTaskJob")
public class UserIntegralWeekTaskJob {
	
	private Logger logger = Logger.getLogger(this.getClass());

    @Autowired
	private StaticServer staticServer;
    
    @Autowired
    private UserIntegralDetailService userIntegralDetailService;
    
	@Autowired
	private RedisDAO<String> redisDAO;
	
	public UserIntegralWeekTaskJob() {
		logger.info("********用户每周积分统计创建初始化************");
	}
	
	/**
	 * 初始化方法 
	 */
	public void init() {
		
	}
	
	/**
	 * 销毁方法
	 */
	public void destroy(){
		
		
	}
	
	public void userIntegralWeekTask(){
		
		try{
			
			logger.info("********每周登录积分定时器执行任务************");
			
			String lastWeedEndDate=IntegralRedisKeyEnum.getLastWeekEnd();
			
			// 上周登录 userId set 集合
			String weekLoginKey=IntegralRedisKeyEnum.getWeekLoginSetKey(lastWeedEndDate);
			
			// 上周登录useI的集合
			Set<String> weekLoginSet=redisDAO.getDataSet(weekLoginKey);
			
			if(!weekLoginSet.isEmpty())
			{
				for (String userId : weekLoginSet) {
					
					// 用户积分记录 缓存 key
					String userIntegralModelKey=IntegralRedisKeyEnum.getUserIntegralModelKey(userId, lastWeedEndDate);
					
					byte[] bytes=userIntegralModelKey.getBytes();
					
					// 获取积分缓存对象
					UserIntergralRedisVO userIntergralRedisVO=(UserIntergralRedisVO) ListTranscoder.deserialize(	redisDAO.getData(bytes));
					
					if(userIntergralRedisVO!=null)
					{
						// 上周登录次数
						int weekLoginNum=userIntergralRedisVO.getAccessDateSet().size();
						
						// 连续登录三次奖励积分
						if(weekLoginNum>=3)
						{
							userIntegralDetailService.weekOpenAddIntegral(userId,lastWeedEndDate);
							
							logger.info("********上周连续登录奖励"+" 日期:"+lastWeedEndDate+" 奖励用户id:"+userId+"************");
						}
						
						//jedis.del(bytes);
						redisDAO.delete(bytes);
					}
				}
			}
			
			logger.info("********上周连续登录奖励执行完毕,删除上周登录集合"+weekLoginKey+"************");
			//jedis.del(weekLoginKey);
			
			redisDAO.delete(weekLoginKey);
		}catch(Exception e){
			
			logger.error("******每周登录积分处理定时器错误******", e);
			e.printStackTrace();
			
		}finally {
			
		}
		
		
		
	}
	
	
	
	
	

}
