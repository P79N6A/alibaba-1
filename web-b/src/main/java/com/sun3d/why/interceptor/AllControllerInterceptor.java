package com.sun3d.why.interceptor;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.sun3d.why.enumeration.redis.IntegralRedisKeyEnum;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.redis.vo.UserIntergralRedisVO;
import com.sun3d.why.service.UserIntegralDetailService;
import com.sun3d.why.util.redis.ListTranscoder;

import redis.clients.jedis.HostAndPort;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisSentinelPool;

/**
 * 所有业务处理请求拦截器
 * @author zhangshun
 *
 */
@Component("allControllerInterceptor")
public class AllControllerInterceptor  implements HandlerInterceptor{
	
    private Logger logger = Logger.getLogger(this.getClass());

    @Autowired
	private StaticServer staticServer;
    
    @Autowired
    private UserIntegralDetailService userIntegralDetailService;
	
	/**
	 * 初始化方法 
	 */
	public void init() {
		
		logger.info("AllControllerInterceptor 拦截器初始化！");
	}
	
	/**
	 * 销毁方法
	 */
	public void destroy(){

	}
	
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		
		JedisSentinelPool sentinelPool = null;
		Jedis jedis = null;
		
		try {
			
			String userId="";
			
			String u1=request.getParameter("userId");
			
			if(StringUtils.isNotBlank(u1))
			{
				userId=u1;
			}
			else
			{
				userId = (String) request.getAttribute("userId");
			}
			
		
		if(StringUtils.isBlank(userId))
		{
			CmsTerminalUser terminalUser = (CmsTerminalUser) request.getSession().getAttribute("terminalUser");
			
			if(terminalUser!=null&&StringUtils.isNotBlank(terminalUser.getUserId()))
				userId=terminalUser.getUserId();
		}
	
		
		if(StringUtils.isNotBlank(userId))
		{
			
				sentinelPool = getJedisSentinelPool();
	            jedis = sentinelPool.getResource();
	            if (!jedis.isConnected()) {
	                jedis.connect();
	            }
				
				// 本周结束日期
				String weekEndDate=IntegralRedisKeyEnum.getEndOfThisWeek();
				
				// 本周登录 userId set 集合
				String weekLoginKey=IntegralRedisKeyEnum.getWeekLoginSetKey(weekEndDate);
				
				// 判断本周登陆集合里是否存在 userID
				if(!jedis.sismember(weekLoginKey, userId))
				{
					// 集合中插入useID
					jedis.sadd(weekLoginKey, userId); 
				}
				
				// 用户积分记录 缓存 key
				String userIntegralModelKey=IntegralRedisKeyEnum.getUserIntegralModelKey(userId, weekEndDate);
				
				byte[] bytes=userIntegralModelKey.getBytes();
				
				// 获取积分缓存对象
				UserIntergralRedisVO userIntergralRedisVO=(UserIntergralRedisVO) ListTranscoder.deserialize(	jedis.get(bytes));
				
				if(userIntergralRedisVO==null)
					userIntergralRedisVO=new UserIntergralRedisVO();
				
				// 今日日期
				String today=IntegralRedisKeyEnum.getToday();
				
				Set<String> accessDateSet=userIntergralRedisVO.getAccessDateSet();
				
				// 判断今天是否登录过
				if(!accessDateSet.contains(today))
				{
					// 插入积分信息
					int result=userIntegralDetailService.everyDayOpenAddIntegral(userId);
					
						if(result>0)
						{
							accessDateSet.add(today);
							
							jedis.set(bytes, ListTranscoder.serialize(userIntergralRedisVO));
							
						}
					}
					
						
				}
				
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			
			try {
				if(jedis!=null){
					jedis.close();
				}
				
				if(sentinelPool!=null){
					   sentinelPool.destroy();
				}
			} catch (Exception e2) {
			}
		}
		
		return true;
	}
	
	
	 /**
     * 获取jedis连接池
     *
     * @return jedis连接池
     */
    private JedisSentinelPool getJedisSentinelPool() {
        try {
            String poolRedis[] = staticServer.getSentinelPool().split(";");
            if (poolRedis == null || poolRedis.length == 0) {
                return null;
            }
            Set sentinels = new HashSet();
            for (int i = 0; i < poolRedis.length; i++) {
                if (poolRedis[i] != null && poolRedis[i].length() > 0) {
                    String redisInfo[] = poolRedis[i].split(":");
                    sentinels.add(new HostAndPort(redisInfo[0], Integer.parseInt(redisInfo[1])).toString());
                }
            }
            if (CollectionUtils.isNotEmpty(sentinels)) {
                return new JedisSentinelPool("mymaster", sentinels);
            }

        } catch (Exception e) {
            logger.info("getJedisSentinelPool error ", e);
            e.printStackTrace();
        }
        return null;
    }

	
	

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView modelAndView) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		// TODO Auto-generated method stub
		
	}

}
