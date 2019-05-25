package com.sun3d.why.service.impl;

import com.sun3d.why.dao.UserIntegralMapper;
import com.sun3d.why.model.*;
import com.sun3d.why.model.extmodel.BookActivitySeatInfo;
import com.sun3d.why.model.extmodel.BookTicketConfig;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.*;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.DateUtils;
import com.sun3d.why.util.RandomUtils;
import com.sun3d.why.util.redis.ListTranscoder;
import com.sun3d.why.webservice.api.service.CmsApiActivityOrderService;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import redis.clients.jedis.HostAndPort;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisSentinelPool;
import redis.clients.jedis.Transaction;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.*;

@Service
@Transactional
public class CacheServiceImpl implements CacheConstant, CacheService {

    //    @Autowired
//    protected JedisPoolConfig jedisPoolConfig;
/*    @Autowired
    protected RedisConfig redisConfig;*/
    @Autowired
    private BookTicketConfig bookTicketConfig;
    @Autowired
    private CmsActivityOrderService cmsActivityOrderService;
    @Autowired
    private CmsActivityService cmsActivityService;
    @Autowired
    private StaticServer staticServer;
    @Autowired
    private CmsApiActivityOrderService cmsApiActivityOrderService;
    @Autowired
    private UserIntegralMapper userIntegralMapper;
    @Autowired
    private CmsActivityEventService cmsActivityEventService;

    private Logger logger = Logger.getLogger(CacheServiceImpl.class);

    /**
     * 得到需要生成的场次信息
     * 如 2015-10-17 08:00-09:00
     * 2015-10-17 13:00-15:00
     * 2015-10-18 08:00-09:00
     * 2015-10-19 13:00-15:00 这类信息
     *
     * @param cmsActivity
     * @param eventTimes
     * @return
     */
    public List<String> getEventTimeList(CmsActivity cmsActivity, List<String> eventTimes) {
        try {
            String cmsActivityStartTime = cmsActivity.getActivityStartTime();
            String cmsActivityEndTime = cmsActivity.getActivityEndTime();
            DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
            Date activityStartTime = df.parse(cmsActivityStartTime);
            Date activityEndTime = df.parse(cmsActivityEndTime);
            Calendar ca = Calendar.getInstance();
            List<String> dayList = new ArrayList<String>();
            //比较两个日期相隔多少天
            while (activityStartTime.compareTo(activityEndTime) <= 0) {
                ca.setTime(activityStartTime);
                ca.add(ca.DATE, 1);
                activityStartTime = ca.getTime();
                //得到年月日
                String dateInfo = df.format(activityStartTime);
                dayList.add(dateInfo);
            }
            List<String> dateInfoList = new ArrayList<String>();
            if (eventTimes != null && eventTimes.size() > 0) {
                if (dayList != null && dayList.size() > 0) {
                    for (String dayInfo : dayList) {
                        for (String eventTime : eventTimes) {
                            String dateInfo = dayInfo + " " + eventTime;
                            dateInfoList.add(dayInfo);
                        }
                    }
                }
                return dateInfoList;
            } else {
                return null;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            return null;
        }
    }

    /**
     * 根据活动id 和 活动场次时间查询剩余可预定的余票
     */
    public Integer getSeatCountByActivityIdAndTime(String activityId, String eventDateTime) {
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            String key = CacheConstant.ACTIVITY_TICKET_COUNT + activityId + "_" + eventDateTime;
            return jedis.get(key) == null ? 0 : Integer.parseInt(jedis.get(key));
        } catch (Exception ex) {
        	logger.error("getSeatCountByActivityIdAndTime 错误！", ex);
            ex.printStackTrace();
            return 0;
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("getSeatCountByActivityIdAndTime 关闭redis连接失败！", e);
            	e.printStackTrace();
            }
        }
    }


    /**
     * 设置活动内存中座位的默认值
     */
    public String setActivitySeat(String key, List<CmsActivitySeat> list, Date endDate, CmsActivity cmsActivity, List<String> timeInfo) {
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            byte[] bytes = key.getBytes();
/*            List<String> timeInfo = getEventTimeList(cmsActivity, eventTimes);*/
            Map dateMap = new HashMap();
            if (timeInfo != null) {
                //将所有的场次放入相同的座位模板
                for (String eventTime : timeInfo) {
                    Map<String, CmsActivitySeat> seatMap = new LinkedHashMap<String, CmsActivitySeat>();
                    for (CmsActivitySeat activitySeat : list) {
                        CmsActivitySeat cmsActivitySeat = new CmsActivitySeat();
                        cmsActivitySeat.setActivityId(activitySeat.getActivityId());
                        cmsActivitySeat.setActivitySeatId(activitySeat.getActivitySeatId());
                        cmsActivitySeat.setSeatStatus(activitySeat.getSeatStatus());
                        cmsActivitySeat.setSeatArea(activitySeat.getSeatArea());
                        cmsActivitySeat.setSeatCode(activitySeat.getSeatCode());
                        cmsActivitySeat.setSeatColumn(activitySeat.getSeatColumn());
                        cmsActivitySeat.setSeatIsSold(activitySeat.getSeatIsSold());
                        cmsActivitySeat.setSeatRow(activitySeat.getSeatRow());
                        cmsActivitySeat.setSeatPrice(activitySeat.getSeatPrice());
                        cmsActivitySeat.setSeatId(activitySeat.getSeatId());
                        cmsActivitySeat.setSeatVal(activitySeat.getSeatVal());
                        seatMap.put(activitySeat.getSeatCode(), cmsActivitySeat);
                    }
                    dateMap.put(eventTime, seatMap);
                }
            }

            //jedis.set(bytes ,ListTranscoder.serialize(list));
            jedis.set(bytes, ListTranscoder.serialize(dateMap));
            //List list2  = getSeatInfoByActivityId(key);
            logger.info("key value :" + key.getBytes().toString());
            if (endDate != null) {
                Date now = new Date();
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(endDate);
                calendar.add(Calendar.HOUR_OF_DAY, 24);
                Date expireDate = calendar.getTime();
                long lifeDate = (expireDate.getTime() - now.getTime()) / 1000;
                jedis.expire(key.getBytes(), (int) lifeDate);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            return ex.toString();
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("setActivitySeat 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
        return Constant.RESULT_STR_SUCCESS;
    }


    /**
     * 根据活动id  和场次 获得可以预定的数量
     *
     * @param activityId
     * @param eventDateTime
     * @return
     */
    public Integer getSeatCount(String activityId, String eventDateTime) {
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            String key = CacheConstant.ACTIVITY_TICKET_COUNT + activityId + "_" + eventDateTime;
            String value = jedis.get(key);
            if (value != null) {
                return Integer.parseInt(value);
            } else {
                return 0;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            return 0;
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("getSeatCount 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
    }

    /**
     * 设置内存中座位数量的默认值
     */
    @Override
    public String setSeatCount(String activityId, String value, Date endDate, List<String> eventInfo) throws Exception {
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            if (eventInfo != null && eventInfo.size() > 0) {
                for (String eventDateTime : eventInfo) {
                    String countValue = new String(value);
                    String key = (CacheConstant.ACTIVITY_TICKET_COUNT + activityId + "_" + eventDateTime);
                    jedis.set(key, countValue);
                    if (endDate != null) {
                        Date now = new Date();
                        Calendar calendar = Calendar.getInstance();
                        calendar.setTime(endDate);
                        calendar.add(Calendar.HOUR_OF_DAY, 24);
                        Date expireDate = calendar.getTime();
                        long lifeDate = (expireDate.getTime() - now.getTime()) / 1000;
                        jedis.expire(key, (int) lifeDate);
                    }
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            return ex.toString();
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("setSeatCount 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
        return Constant.RESULT_STR_SUCCESS;
    }


    /**
     * 根据活动id和时间场次 修改剩余票数
     *
     * @param activityId
     * @param eventDateTime
     * @param value
     * @return
     */
    public String updateSeatCountByIdAndTime(String activityId, Date endDate, String eventDateTime, String value) {
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            String key = CacheConstant.ACTIVITY_TICKET_COUNT + activityId + "_" + eventDateTime;
            jedis.set(key, value);
            if (endDate != null) {
                //设置过期时间
                Date now = new Date();
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(endDate);
                calendar.add(Calendar.HOUR_OF_DAY, 24);
                Date expireDate = calendar.getTime();
                long lifeDate = (expireDate.getTime() - now.getTime()) / 1000;
                jedis.expire(key, (int) lifeDate);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            return ex.toString();
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("updateSeatCountByIdAndTime 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
        return Constant.RESULT_STR_SUCCESS;
    }

    public void saveActivityRoomToQueues(String key, String value) {
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            long count = jedis.sadd(key, value);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("saveActivityRoomToQueues 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
    }

    public String addActivityTicketCount(String activityId, Integer backCount, Date endDate, String eventDateTime) {
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            try {
                jedis.watch(CacheConstant.ACTIVITY_TICKET_COUNT + activityId + "_" + eventDateTime);
                Transaction tx = jedis.multi();
                tx.incrBy(CacheConstant.ACTIVITY_TICKET_COUNT + activityId + "_" + eventDateTime, backCount);
                tx.exec();
            } catch (Exception e) {
                e.printStackTrace();
                jedis.watch(CacheConstant.ACTIVITY_TICKET_COUNT + activityId + "_" + eventDateTime);
                Transaction tx = jedis.multi();
                tx.incrBy(CacheConstant.ACTIVITY_TICKET_COUNT + activityId + "_" + eventDateTime, backCount);
                tx.exec();
            }
            if (endDate != null) {
                Date now = new Date();
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(endDate);
                calendar.add(Calendar.HOUR_OF_DAY, 24);
                Date expireDate = calendar.getTime();
                long lifeDate = (expireDate.getTime() - now.getTime()) / 1000;
                jedis.expire(CacheConstant.ACTIVITY_TICKET_COUNT + activityId + "_" + eventDateTime, (int) lifeDate);
            }
            return Constant.RESULT_STR_SUCCESS;
        } catch (Exception ex) {
            ex.printStackTrace();
            return Constant.RESULT_STR_FAILURE;
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
                e.printStackTrace();
                logger.error("addActivityTicketCount 关闭redis连接失败！", e);
            }
        }
    }

    /**
     * 取消订单修改座位状态
     *
     * @param activityId
     * @param seatInfos
     * @return
     */
    public String cancelOrder(String activityId, CmsActivityOrder cmsActivityOrder, CmsActivityEvent cmsActivityEvent, String seatInfos, Integer backCount, Date endDate, String type) {
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            //
            if ("Y".equals(type)) {
                byte[] bytes = jedis.get(activityId.getBytes());
                Map allMap = new LinkedHashMap();
                Map<String, CmsActivitySeat> seatMap = new LinkedHashMap<String, CmsActivitySeat>();
                allMap = (Map) ListTranscoder.deserialize(bytes);
                String[] seatInfo = seatInfos.split(",");
                List<CmsActivitySeat> activitySeatList = new ArrayList<CmsActivitySeat>();
                if (allMap != null && allMap.size() > 0) {
                    seatMap = (Map<String, CmsActivitySeat>) allMap.get(cmsActivityEvent.getEventDateTime());
                    if (seatMap != null && seatMap.size() > 0) {
                        for (String seatCode : seatInfo) {
                            CmsActivitySeat cmsActivitySeat = seatMap.get(seatCode);
                            if (cmsActivitySeat != null && cmsActivitySeat.getSeatStatus() == 2) {
                                cmsActivitySeat.setSeatStatus(1);
                                cmsActivitySeat.setSeatIsSold(1);
                                seatMap.put(seatCode, cmsActivitySeat);
                            } else {
                                return "error";
                            }
                        }
                    } else {
                        return "error";
                    }
                } else {
                    return "error";
                }
                allMap.put(cmsActivityEvent.getEventDateTime(), seatMap);
                jedis.set(activityId.getBytes(), ListTranscoder.serialize(allMap));
            }
            addActivityTicketCount(activityId, backCount, endDate, cmsActivityEvent.getEventDateTime());
            return Constant.RESULT_STR_SUCCESS;
        } catch (Exception ex) {
            ex.printStackTrace();
            return ex.toString();
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("cancelOrder 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
    }

    @Override
    public String getValueByKey(String key) {
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }

            return jedis.get(key);
        } catch (Exception e) {
            logger.info("getValueByKey error {}", e);
            e.printStackTrace();
            return e.toString();
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("getValueByKey	 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }

        // return  null;
    }


    @Override
    public String setResultValue(String key, String value) {
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            jedis.set(key, value);
            if (jedis != null) {
                jedis.disconnect();
                // pool.returnResource(jedis);
            }
            return "success";
        } catch (Exception e) {
            logger.info("setResultValue error {}", e);
            e.printStackTrace();
            return e.toString();
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	
            	logger.error("setResultValue 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
        // return  null;
    }

    @Override
    public String deleteValueByKey(String key) {
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            if (jedis.exists(key))
                jedis.del(key);
            return "success";
        } catch (Exception e) {
            logger.info("setResultValue error {}", e);
            e.printStackTrace();
            return e.toString();
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("deleteValueByKey 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
    }

    public String subtractTicketCountById(String activityId, String eventDateTime, Integer bookCount) {
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            try {
                jedis.watch(CacheConstant.ACTIVITY_TICKET_COUNT + activityId + "_" + eventDateTime);
                String count = jedis.get(CacheConstant.ACTIVITY_TICKET_COUNT + activityId + "_" + eventDateTime) == null ? "0" : jedis.get(CacheConstant.ACTIVITY_TICKET_COUNT + activityId + "_" + eventDateTime);
                if (Integer.valueOf(count) <= 0) {
                    jedis.unwatch();
                    return "余票不够";
                }
                Transaction tx = jedis.multi();
                tx.decrBy(CacheConstant.ACTIVITY_TICKET_COUNT + activityId + "_" + eventDateTime, bookCount);
                tx.exec();
            } catch (Exception e) {
                e.printStackTrace();
                jedis.watch(CacheConstant.ACTIVITY_TICKET_COUNT + activityId + "_" + eventDateTime);
                String count = jedis.get(CacheConstant.ACTIVITY_TICKET_COUNT + activityId + "_" + eventDateTime) == null ? "0" : jedis.get(CacheConstant.ACTIVITY_TICKET_COUNT + activityId + "_" + eventDateTime);
                if (Integer.valueOf(count) <= 0) {
                    jedis.unwatch();
                    return "余票不够";
                }
                Transaction tx = jedis.multi();
                tx.decrBy(CacheConstant.ACTIVITY_TICKET_COUNT + activityId + "_" + eventDateTime, bookCount);
                tx.exec();
            }


            return "success";
        } catch (Exception e) {
            logger.info("subtractTicketCountById error {}", e);
            e.printStackTrace();
            return e.toString();
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("subtractTicketCountById 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
    }

    public void deleteSetComment(String key, String value) {
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            jedis.srem(key, value);

        } catch (Exception e) {
            logger.info("setResultValue error {}", e);
            e.printStackTrace();
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("deleteSetComment 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
    }

    @Override
    public List<CmsActivitySeat> getSeatInfoByActivityId(String activityId) {
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            byte[] bytes = jedis.get(activityId.getBytes());
            List<CmsActivitySeat> list = new ArrayList<CmsActivitySeat>();
            Map<String, CmsActivitySeat> map = new LinkedHashMap<String, CmsActivitySeat>();

            if (bytes != null) {
                //list = (List<CmsActivitySeat>)ListTranscoder.deserialize(bytes);
                map = (Map<String, CmsActivitySeat>) ListTranscoder.deserialize(bytes);
                if (map != null && map.size() > 0) {
                    for (Map.Entry<String, CmsActivitySeat> entry : map.entrySet()) {
                        list.add(entry.getValue());
                    }
                }
            }
            return list;
        } catch (Exception e) {
            logger.info("setResultValue error {}", e);
            e.printStackTrace();
            return null;
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("getSeatInfoByActivityId 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
    }


    /**
     * 根据活动id 得到 座位信息的map
     *
     * @param activityId
     * @return
     */
    @Override
    public Map getSeatEventMapById(String activityId) {
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            byte[] bytes = jedis.get(activityId.getBytes());
            List<CmsActivitySeat> list = new ArrayList<CmsActivitySeat>();
            Map<String, String> map = new LinkedHashMap<String, String>();
            if (bytes != null) {
                map = (Map<String, String>) ListTranscoder.deserialize(bytes);
            }
            return map;
        } catch (Exception e) {
            logger.info("setResultValue error {}", e);
            e.printStackTrace();
            return null;
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("getSeatEventMapById 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
    }

    /**
     * 根据活动id  和场次信息得到活动座位信息
     *
     * @return
     */
    @Override
    public List<CmsActivitySeat> getSeatInfoByIdAndTime(String activityId, String eventTime) {
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            byte[] bytes = jedis.get(activityId.getBytes());
            List<CmsActivitySeat> list = new ArrayList<CmsActivitySeat>();
            Map map = new LinkedHashMap();
            Map<String, CmsActivitySeat> seatMap = new LinkedHashMap<String, CmsActivitySeat>();
            if (bytes != null) {
                map = (Map<String, String>) ListTranscoder.deserialize(bytes);
                if (map != null && map.size() > 0) {
                    if (StringUtils.isNotBlank(eventTime)) {
                        if (map.containsKey(eventTime)) {
                            seatMap = (Map<String, CmsActivitySeat>) map.get(eventTime);
                            for (Map.Entry<String, CmsActivitySeat> entry : seatMap.entrySet()) {
                                list.add(entry.getValue());
                            }
                        }
                    }
                }
            }
            return list;
        } catch (Exception e) {
            logger.info("setResultValue error {}", e);
            e.printStackTrace();
            return null;
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("getSeatInfoByIdAndTime 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
    }


    //判断所选座位能否被取消预定
    @Override
    public String checkSeatStatusByCancel(BookActivitySeatInfo seatInfo, String[] seatIds, Integer cancelCount, String userId) {
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        try {
            String activityId = seatInfo.getActivityId();
            //判断活动时间已经过期 或已经结束
            CmsActivity cmsActivity = cmsActivityService.queryFrontActivityByActivityId(activityId);
            if (cmsActivity != null) {
                if (cmsActivity.getActivityState() != 6 || cmsActivity.getActivityIsDel() != 1) {
                    return "该活动未发布或已经删除，不能预定";
                }
            } else {
                return "该活动不存在";
            }
            CmsActivityEvent cmsActivityEvent = cmsActivityEventService.queryByEventId(seatInfo.getEventId());
            try {
                DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(new Date());
                if (cmsActivityEvent == null) {
                    return "该场次不存在";
                }
                if (cmsActivityEvent.getEventDateTime() != null) {
                    if (df.parse(cmsActivityEvent.getEventDateTime()).before(calendar.getTime())) {
                        //不在规定时间内 不能进行订票
                        return "活动已经开始或结束,不能取消订单";
                    }
                }
                seatInfo.setEventDateTime(cmsActivityEvent.getEventDateTime());
            } catch (Exception ex) {
                ex.printStackTrace();
                logger.error("ex {}", ex);
            }
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            if (seatIds != null && seatIds.length > 0) {
                if (seatIds == null || seatIds.length == 0) {
                    return "seatEmpty";
                }
                String msg = "";
                Map seatMap = new LinkedHashMap();
                seatMap = (Map) ListTranscoder.deserialize(jedis.get(activityId.getBytes()));
                if (seatMap != null && seatMap.size() > 0) {
                    if (seatMap.containsKey(seatInfo.getEventDateTime())) {
                        Map<String, CmsActivitySeat> oneEventMap = (Map<String, CmsActivitySeat>) seatMap.get(seatInfo.getEventDateTime());
                        if (oneEventMap != null && oneEventMap.size() > 0) {
                            for (String code : seatIds) {
                                CmsActivitySeat activitySeat = oneEventMap.get(code);
                                if (activitySeat != null && activitySeat.getSeatStatus() == 1) {
                                    msg += activitySeat.getSeatRow() + "排" + activitySeat.getSeatColumn() + "列,";
                                } else if (activitySeat == null) {
                                    msg += "无效座位";
                                }
                            }
                            if (!"".equals(msg)) {
                                return "对不起，您选择的座位:" + msg.substring(0, msg.length() - 1) + " 已经被取消,不能重复取消";
                            }
                        } else {
                            return "无该场次信息的座位";
                        }
                    } else {
                        return "请选择正确的场次";
                    }
                } else {
                    return "system error";
                }
                if (!"".equals(msg)) {
                    return msg;
                }
            } else {
                Integer totalCount = getSeatCount(activityId, cmsActivityEvent.getEventDateTime());
                if (totalCount < 0) {
                    return "errorCount";
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            logger.error("ex {}", ex);
            return ex.toString();
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("checkSeatStatusByCancel 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
        return Constant.RESULT_STR_SUCCESS;
    }


    //判断所选座位能否被预定
    @Override
    public String checkActivitySeatStatus(BookActivitySeatInfo seatInfo, String[] seatIds, Integer bookCount, String userId) {
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        try {
//            //已经购买到的票数
            if (bookCount==null) {
                bookCount=seatIds.length;
            }
            if (bookCount==0) {
                bookCount=seatIds.length;
            }
            String activityId = seatInfo.getActivityId();
            //判断活动时间已经过期 或已经结束
            CmsActivity cmsActivity = cmsActivityService.queryFrontActivityByActivityId(activityId);
            if (cmsActivity != null) {
                if (cmsActivity.getActivityState() != 6 || cmsActivity.getActivityIsDel() != 1) {
                    return "该活动未发布或已经删除，不能预定";
                }
            } else {
                return "该活动不存在";
            }
            //判断是否是子区县的活动
            if (StringUtils.isNotBlank(cmsActivity.getSysNo()) && StringUtils.isNotBlank(cmsActivity.getSysId())) {
                String str = cmsApiActivityOrderService.checkActivitySeatStatus(seatInfo.getActivityId(), seatIds, bookCount, userId);
                if (Constant.RESULT_STR_SUCCESS.equals(str)) {
                    return Constant.RESULT_STR_SUCCESS;
                } else {
                    return str;
                }
            }



            Map orderMap = new HashMap();
            orderMap.put("activityId", seatInfo.getActivityId());
            if (StringUtils.isNotBlank(seatInfo.getEventId())) {
                orderMap.put("eventId", seatInfo.getEventId());
            }
            if (bookTicketConfig.getCheckConfig() == 2) {
                orderMap.put("orderPhoneNo", seatInfo.getPhone());
            } else {
                orderMap.put("userId", userId);
            }
            //判断用户是否填写了手机号码
            if (StringUtils.isBlank(seatInfo.getPhone())) {
                return "手机号码不能为空";
            }

            //积分判断
            if (StringUtils.isNotBlank(userId)&&StringUtils.isNotBlank(seatInfo.getCostTotalCredit())) {
            	UserIntegral userIntegral=userIntegralMapper.selectUserIntegralByUserId(userId);
            	if(userIntegral!=null){
            		if(Integer.parseInt((String) seatInfo.getCostTotalCredit())>userIntegral.getIntegralNow()){
            			return "该用户的积分不够抵扣该活动";
            		}
            	}else{
            		if(Integer.parseInt((String) seatInfo.getCostTotalCredit())>0){
            			return "该用户的积分不够抵扣该活动";
            		} 
            	}
            }
            
            if (cmsActivity.getTicketSettings().equals("N")) {
                int userTickets = cmsActivityOrderService.queryOrderCountByUser(orderMap);
                if (userTickets > 0 && cmsActivity.getTicketNumber() != null && userTickets + 1 > cmsActivity.getTicketNumber()) {
                    return "moreLimit";
                }
                //为移动接口添加的判断
                if (cmsActivity.getTicketCount() != null && bookCount > cmsActivity.getTicketCount()) {
                    return "moreLimitCount";
                }
            } else {
                int userTicketCount = cmsActivityOrderService.queryOrderTicketCountByUser(orderMap);
                //最大的购买票数
                int maxBookCount = bookTicketConfig.getMaxBookTicketCount();
                if (seatIds != null && seatIds.length > 0) {
                    if ((userTicketCount + seatIds.length) > maxBookCount) {
                        return "more";
                    }
                } else {
                    if ((userTicketCount + bookCount) > maxBookCount) {
                        return "more";
                    }
                }
            }
            CmsActivityEvent cmsActivityEvent = cmsActivityEventService.queryByEventId(seatInfo.getEventId());
            try {
                DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(new Date());
                if (cmsActivityEvent == null) {
                    return "该场次不存在";
                }
                if (cmsActivityEvent.getEventDateTime() != null) {
                    if (df.parse(cmsActivityEvent.getEventDateTime()).before(calendar.getTime())) {
                        //不在规定时间内 不能进行订票
                        return "overtime";
                    }
                }
            } catch (Exception ex) {
                ex.printStackTrace();
                logger.error("ex {}", ex);
            }
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            if (seatIds != null && seatIds.length > 0) {
                Map map = new HashMap();
                if (seatIds == null || seatIds.length == 0) {
                    return "seatEmpty";
                }
                String msg = "";
                Map seatMap = new LinkedHashMap();
                seatMap = (Map) ListTranscoder.deserialize(jedis.get(activityId.getBytes()));
                if (seatMap != null && seatMap.size() > 0) {
                    if (seatMap.containsKey(seatInfo.getEventDateTime())) {
                        Map<String, CmsActivitySeat> oneEventMap = (Map<String, CmsActivitySeat>) seatMap.get(seatInfo.getEventDateTime());
                        if (oneEventMap != null && oneEventMap.size() > 0) {
                            for (String code : seatIds) {
                                CmsActivitySeat activitySeat = oneEventMap.get(code);
                                if (activitySeat != null && activitySeat.getSeatStatus() != 1) {
                                    msg += activitySeat.getSeatRow() + "排" + activitySeat.getSeatColumn() + "列,";
                                } else if (activitySeat == null) {
                                    msg += "无效座位";
                                }
                            }
                            //
                            if (!"".equals(msg)) {
                                return "对不起，您选择的座位:" + msg.substring(0, msg.length() - 1) + " 已经被占用";
                            }
                        } else {
                            return "无该场次信息的座位";
                        }
                    } else {
                        return "请选择正确的场次";
                    }
                } else {
                    return "system error";
                }
                if (!"".equals(msg)) {
                    return msg;
                }
            } else {
                Integer totalCount = getSeatCount(activityId, cmsActivityEvent.getEventDateTime());
                if (bookCount <= 0) {
                    return "errorCount";
                }
                if (totalCount < bookCount) {
                    return "overCount";
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            logger.error("ex {}", ex);
            return ex.toString();
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("checkActivitySeatStatus 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
        return Constant.RESULT_STR_SUCCESS;
    }


    /**
     * 修改活动座位状态 并生成订单信息
     *
     * @param activitySeatInfo
     * @return
     */
    @Override
    public String updateSeatStatus(BookActivitySeatInfo activitySeatInfo) {
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            String msg = "";
            Map seatMap = new HashMap();
            Map<String, CmsActivitySeat> oneEventMap = new LinkedHashMap<String, CmsActivitySeat>();
            seatMap = (Map) ListTranscoder.deserialize(jedis.get(activitySeatInfo.getActivityId().getBytes()));
            if (seatMap != null && seatMap.size() > 0) {
                oneEventMap = (Map<String, CmsActivitySeat>) seatMap.get(activitySeatInfo.getEventDateTime());
                if (oneEventMap != null && oneEventMap.size() > 0) {
                    for (String code : activitySeatInfo.getSeatIds()) {
                        CmsActivitySeat activitySeat = oneEventMap.get(code);
                        if (activitySeat != null && activitySeat.getSeatStatus() != 1) {
                            msg += activitySeat.getSeatRow() + "排" + activitySeat.getSeatColumn() + "列已经被占用;";
                        } else if (activitySeat == null) {
                            msg += "错误座位";
                        } else {
                            activitySeat.setSeatStatus(2);
                            oneEventMap.put(code, activitySeat);
                        }
                    }
                }
            } else {
                return "system error";
            }
            if (!"".equals(msg)) {
                return msg;
            }
            seatMap.put(activitySeatInfo.getEventDateTime(), oneEventMap);
            jedis.set(activitySeatInfo.getActivityId().getBytes(), ListTranscoder.serialize(seatMap));
            subtractTicketCountById(activitySeatInfo.getActivityId(), activitySeatInfo.getEventDateTime(), activitySeatInfo.getSeatIds().length);
        } catch (Exception ex) {
            ex.printStackTrace();
            return ex.toString();
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("updateSeatStatus 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
        return Constant.RESULT_STR_SUCCESS;
    }

    @Override
    public String genOrderNumber() {
//        JedisSentinelPool sentinelPool = null;
//        Jedis jedis = null;
        try {
//            sentinelPool = getJedisSentinelPool();
//            jedis = sentinelPool.getResource();

/*            if (StringUtils.isNotBlank(redisConfig.getPassword())) {
                jedis.auth(redisConfig.getPassword());
            }*/
//            if (!jedis.isConnected()) {
//                jedis.connect();
//            }
//            String key = RandomUtils.genOrderNumberRedisKey();
            long value = new Random().nextInt(99999);
//            int expireSeconds = DateUtils.getOrderNumberExpireSeconds();
//            jedis.expire(key, expireSeconds);
//            if (value.intValue() >= Constant.MAX_ORDER_SUFFIX) {
//                throw new RuntimeException("Order number overflow!");
//            }
            String orderSuffix = RandomUtils.digitsFormat(value, 6);
            String orderPrefix = RandomUtils.genOrderNumberPrefix();
            return orderPrefix + orderSuffix;

        } catch (Exception e) {
            logger.info("genOrderNumber error" + e);
        } finally {
//            try {
//            	if(jedis!=null){
//    				jedis.close();
//    			}
//
//    			if(sentinelPool!=null){
//    				   sentinelPool.destroy();
//    			}
//            } catch (Exception e) {
//            	logger.error("genOrderNumber 关闭redis连接失败！", e);
//                e.printStackTrace();
//            }
        }
        return null;

    }

    @Override
    public String genUserNumber() {
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();

/*            if (StringUtils.isNotBlank(redisConfig.getPassword())) {
                jedis.auth(redisConfig.getPassword());
            }*/
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            String key = RandomUtils.genUserNumberRedisKey();
            Long value = jedis.incr(key);
            int expireSeconds = DateUtils.getUserNumberExpireSeconds();
            jedis.expire(key, expireSeconds);
            if (value.intValue() >= Constant.MAX_USER_SUFFIX) {
                throw new RuntimeException("User number overflow!");
            }
            String userSuffix = RandomUtils.digitsFormat(value, 6);
            String userPrefix = RandomUtils.genUserNumberPrefix();
            return Constant.USER_ID_PREFIX + userPrefix + userSuffix + RandomStringUtils.random(2, false, true);

        } catch (Exception e) {
            logger.info("genUserNumber error" + e);
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("genUserNumber 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
        return null;
    }

    /**
     * 将活动室要预定的场次信息放入Redis内存中
     *
     * @param key  日期加上活动室Id
     * @param list
     */
    @Override
    public void setRoomBookNum(String key, List<CmsRoomBook> list, Date expireDate) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String roomPrefix = sdf.format(new Date()) + "_";
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            //将列表放入Redis中
            jedis.set((roomPrefix + key).getBytes(), ListTranscoder.serialize(list));
            //设置过期时间
            Date now = new Date();
            long lifeDate = (expireDate.getTime() - now.getTime()) / 1000;
            jedis.expire((roomPrefix + key).getBytes(), (int) lifeDate);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("setRoomBookNum 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
    }

    /**
     * 判断某个活动室特定的场次是否已经被预定
     *
     * @param roomId
     * @param bookId
     * @return
     */
    @Override
    public String checkRoomBookStatus(String roomId, String bookId) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String roomPrefix = sdf.format(new Date()) + "_";
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();

            if (!jedis.isConnected()) {
                jedis.connect();
            }
            String msg = "";
            List<CmsRoomBook> list = (List<CmsRoomBook>) ListTranscoder.deserialize(jedis.get((roomPrefix + roomId).getBytes()));

            if (list != null) {
                for (CmsRoomBook roomBook : list) {
                    String tmpBookId = roomBook.getBookId();
                    int bookStatus = roomBook.getBookStatus();
                    //一旦找到对应的预定信息且状态为不可预定，则直接跳出循环
                    if (tmpBookId.equals(bookId)) {
                        //如果活动室已经被预定，则直接返回方法
                        //如果活动室没有被预定，则直接跳出循环
                        if (bookStatus != 1) {
                            msg += "活动室当前场次已被预定!";
                            return msg;
                        } else {
                            break;
                        }
                    }
                }
            } else {
                msg = "服务器数据异常,预定失败!";
                return msg;
            }

        } catch (Exception ex) {
            return ex.toString();
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("checkRoomBookStatus 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
        return Constant.RESULT_STR_SUCCESS;
    }

    /**
     * 更新已预定活动室场次的状态
     *
     * @param cmsRoomBook
     * @return
     */
    @Override
    public String updateRoomBookStatus(CmsRoomBook cmsRoomBook) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String roomPrefix = sdf.format(new Date()) + "_";
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();

            if (!jedis.isConnected()) {
                jedis.connect();
            }
            String msg = "";
            List<CmsRoomBook> list = (List<CmsRoomBook>) ListTranscoder.deserialize(jedis.get((roomPrefix + cmsRoomBook.getRoomId()).getBytes()));
            List<CmsRoomBook> rsList = new ArrayList<CmsRoomBook>();
            if (list != null) {
                for (CmsRoomBook tmpCmsRoomBook : list) {
                    String bookId = tmpCmsRoomBook.getBookId();
                    int bookStatus = tmpCmsRoomBook.getBookStatus();
                    if (cmsRoomBook.getBookId().equals(bookId)) {
                        if (bookStatus != 1) {
                            msg += "活动室当前场次已被预定!";
                        } else {
                            tmpCmsRoomBook.setBookStatus(2);
                        }
                    }
                    rsList.add(tmpCmsRoomBook);
                }
            } else {
                msg = "服务器数据异常,预定失败!";
            }
            if (!"".equals(msg)) {
                return msg;
            }

            Calendar calendar = Calendar.getInstance();
            calendar.setTime(new Date());
            //设置过期时间为当前时间之后的24小时
            calendar.add(Calendar.HOUR_OF_DAY, 24);
            //将活动室预定信息放入Redis
            setRoomBookNum(cmsRoomBook.getRoomId(), rsList, calendar.getTime());
        } catch (Exception ex) {
            ex.printStackTrace();
            return ex.toString();
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("updateRoomBookStatus 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
        return Constant.RESULT_STR_SUCCESS;
    }

    /**
     * 取消活动室预定
     *
     * @param cmsRoomBook
     * @return
     */
    @Override
    public String cancelRoomBook(CmsRoomBook cmsRoomBook) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String roomPrefix = sdf.format(new Date()) + "_";
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();

            if (!jedis.isConnected()) {
                jedis.connect();
            }
            String msg = "";

            if (cmsRoomBook != null) {
                String roomId = cmsRoomBook.getRoomId();
                String bookId = cmsRoomBook.getBookId();
                //从Redis中获取活动室预定ID
                List<String> list = (List<String>) ListTranscoder.deserialize(jedis.get((roomPrefix + roomId).getBytes()));
                if (list != null) {
                    //如果Redis中存在活动室预定ID，则预定成功并直接从列表中移除代表已被预定
                    if (list.contains(bookId)) {
                        msg = "活动室当前场次没有被预定!";
                    }
                } else {
                    msg = "服务器数据异常,预定失败!";
                }
                if (!"".equals(msg)) {
                    return msg;
                }
                //取消订单成功，将活动室预定ID放入List中
                list.add(bookId);
                //更新Redis中活动室预定列表
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(new Date());
                //设置过期时间为当前时间之后的24小时
                calendar.add(Calendar.HOUR_OF_DAY, 24);
                //将活动室预定信息放入Redis
                setRoomBookList(roomId, list, calendar.getTime());
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            return ex.toString();
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("cancelRoomBook 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
        return Constant.RESULT_STR_SUCCESS;
    }


    public String saveQueueName(String key, String value) {
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            long count = jedis.sadd(key, value);
            if (count > 0) {
                return Constant.RESULT_STR_SUCCESS;
            } else {
                return Constant.RESULT_STR_FAILURE;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            this.logger.error("saveQueueName error {}", ex);
            return ex.toString();
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("saveQueueName 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
    }

    public Iterator queryQueueName(String key) {
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        try {
            sentinelPool = getJedisSentinelPool();
            if (sentinelPool != null) {
                jedis = sentinelPool.getResource();
                if (!jedis.isConnected()) {
                    jedis.connect();
                }
                Set set = jedis.smembers(key);
                Iterator iterator = set.iterator();
                return iterator;
            } else {
                logger.error("queryQueueName sentinelPool 错误 ,为空");
                return null;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            return null;
        } finally {
        	 try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
        	 } catch (Exception e) {
             	logger.error("queryQueueName 关闭redis连接失败！", e);
                 e.printStackTrace();
             }
        }
    }


    /*****************************------------活动室预定第二种处理方式-------------------**********************/
    /**
     * 预定场馆活动室--第二种处理方式
     *
     * @param roomId
     * @param bookId
     * @return
     */
    @Override
    public String bookVenueRoom(String roomId, String bookId) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String roomPrefix = sdf.format(new Date()) + "_";
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();

            if (!jedis.isConnected()) {
                jedis.connect();
            }
            String msg = "";
            List<String> list = (List<String>) ListTranscoder.deserialize(jedis.get((roomPrefix + roomId).getBytes()));
            if (list != null && list.size() > 0) {
                //如果Redis中存在活动室预定ID，则预定成功并直接从列表中移除代表已被预定
                if (list.contains(bookId)) {
                    list.remove(bookId);
                } else {
                    msg = "occupied";
                }
            } else {
                msg = "server data error";
            }
            if (!"".equals(msg)) {
                return msg;
            }

            //更新Redis中活动室已预定列表
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(new Date());
            //设置过期时间为当前时间之后的24小时
            calendar.add(Calendar.HOUR_OF_DAY, 24);
            //将活动室预定信息放入Redis
            setRoomBookList(roomId, list, calendar.getTime());
        } catch (Exception ex) {
            return ex.toString();
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("bookVenueRoom 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
        return Constant.RESULT_STR_SUCCESS;
    }

    /**
     * 将活动室要预定的场次信息放入Redis内存中
     *
     * @param key
     * @param list
     */
    public void setRoomBookList(String key, List<String> list, Date expireDate) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String roomPrefix = sdf.format(new Date()) + "_";
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            //将列表放入Redis中
            jedis.set((roomPrefix + key).getBytes(), ListTranscoder.serialize(list));
            //设置过期时间
            Date now = new Date();
            long lifeDate = (expireDate.getTime() - now.getTime()) / 1000;
            jedis.expire((roomPrefix + key).getBytes(), (int) lifeDate);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("setRoomBookList 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
    }

    /**
     * **************************------------活动室预定第二种处理方式-------------------*********************
     */


    //缓存广告
    public void setAdvertList(String key, List<CmsAdvert> list, Date expireDate) {
        //SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        //String roomPrefix = sdf.format(new Date()) + "_";
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            //将列表放入Redis中
            jedis.set(key.getBytes(), ListTranscoder.serialize(list));
            //设置过期时间
            Date now = new Date();
            long lifeDate = (expireDate.getTime() - now.getTime()) / 1000;
            jedis.expire(key.getBytes(), (int) lifeDate);
        } catch (Exception ex) {
            ex.printStackTrace();

        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("setAdvertList 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
    }


    @Override
    public List<CmsAdvert> getAdvert(String siteId) {
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            byte[] bytes = jedis.get(siteId.getBytes());
            List<CmsAdvert> list = new ArrayList<CmsAdvert>();

            if (bytes != null) {
                list = (List<CmsAdvert>) ListTranscoder.deserialize(bytes);

            }
            return list;
        } catch (Exception e) {
            logger.info("setResultValue error {}", e);
            e.printStackTrace();
            return null;
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("getAdvert 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
    }


    //缓存标签
    public void setTagList(String key, List<CmsTag> list, Date expireDate) {
        //SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        //String roomPrefix = sdf.format(new Date()) + "_";
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            //将列表放入Redis中
            jedis.set(key.getBytes(), ListTranscoder.serialize(list));
            //设置过期时间
            Date now = new Date();
            long lifeDate = (expireDate.getTime() - now.getTime()) / 1000;
            jedis.expire(key.getBytes(), (int) lifeDate);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("setTagList 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
    }

    public List<CmsTag> getTagList(String tagType) {
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            byte[] bytes = jedis.get(tagType.getBytes());
            List<CmsTag> list = new ArrayList<CmsTag>();
            if (bytes != null) {
                list = (List<CmsTag>) ListTranscoder.deserialize(bytes);
            }
            return list;
        } catch (Exception e) {
            logger.info("setResultValue error {}", e);
            e.printStackTrace();
            return null;
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("getTagList 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
    }


    /**
     * 查询首页热点推荐或最新活动
     *
     * @return
     */
    public List<CmsActivity> queryActivityList(String activityListKey) {
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            byte[] bytes = jedis.get(activityListKey.getBytes());
            List<CmsActivity> list = new ArrayList<CmsActivity>();
            if (bytes != null) {
                list = (List<CmsActivity>) ListTranscoder.deserialize(bytes);
            }
            return list;
        } catch (Exception e) {
            logger.info("setResultValue error {}", e);
            e.printStackTrace();
            return null;
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("getTagList 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
    }

    /**
     * 将首页热点推荐或最新活动放至内存中
     *
     * @param
     * @param cmsActivities
     */
    public String setActivityList(String activityListKey, List<CmsActivity> cmsActivities) {
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            jedis.set(activityListKey.getBytes(), ListTranscoder.serialize(cmsActivities));
            return Constant.RESULT_STR_SUCCESS;
        } catch (Exception e) {
            logger.info("setResultValue error {}", e);
            e.printStackTrace();
            return e.toString();
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("setActivityList 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
    }

    @Override
    public void setLikeActivityList(String key, List<CmsActivity> dataList, Date expireDate) {
        //SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        //String roomPrefix = sdf.format(new Date()) + "_";
        Jedis jedis = null;
        JedisSentinelPool sentinelPool = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            //将列表放入Redis中
            jedis.set(key.getBytes(), ListTranscoder.serialize(dataList));
            //设置过期时间
            Date now = new Date();
            long lifeDate = (expireDate.getTime() - now.getTime()) / 1000;
            jedis.expire(key.getBytes(), (int) lifeDate);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("setLikeActivityList 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }

    }

    @Override
    public List<CmsActivity> getLikeActivityList(String code) {
        Jedis jedis = null;
        JedisSentinelPool sentinelPool = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            byte[] bytes = jedis.get(code.getBytes());
            List<CmsActivity> list = new ArrayList<CmsActivity>();
            if (bytes != null) {
                list = (List<CmsActivity>) ListTranscoder.deserialize(bytes);
            }
            return list;
        } catch (Exception e) {
            logger.info("setResultValue error {}", e);
            e.printStackTrace();
            return new ArrayList<CmsActivity>();
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("getLikeActivityList 关闭redis连接失败！", e);
                e.printStackTrace();
            }

        }
    }


    /**
     * 获取jedis连接池
     *
     * @return jedis连接池
     */
    public JedisSentinelPool getJedisSentinelPool() {
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

    /**
     * 根绝Redis中的KEY值更新场馆首页列表
     *
     * @param venueIndexKey
     * @return
     */
    @Override
    public boolean updateVenueIndex(String venueIndexKey, List<CmsVenue> venueList) {
        Jedis jedis = null;
        JedisSentinelPool sentinelPool = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            //将列表放入Redis中
            jedis.set(venueIndexKey.getBytes(), ListTranscoder.serialize(venueList));

            //设置过期时间
            Date now = new Date();
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(now);
            calendar.add(Calendar.HOUR_OF_DAY, 24);
            Date expireDate = calendar.getTime();
            long lifeDate = (expireDate.getTime() - now.getTime()) / 1000;
            jedis.expire(venueIndexKey.getBytes(), (int) lifeDate);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("updateVenueIndex 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
        return false;
    }

    /**
     * 根据Redis中的KEY值获取场馆首页列表
     *
     * @param venueIndexKey
     * @return
     */
    @Override
    public List<CmsVenue> getVenueIndexList(String venueIndexKey) {
        Jedis jedis = null;
        JedisSentinelPool sentinelPool = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            byte[] bytes = jedis.get(venueIndexKey.getBytes());
            List<CmsVenue> list = new ArrayList<CmsVenue>();
            if (bytes != null) {
                list = (List<CmsVenue>) ListTranscoder.deserialize(bytes);
            }
            return list;
        } catch (Exception e) {
            logger.info("setResultValue error {}", e);
            e.printStackTrace();
            return new ArrayList<CmsVenue>();
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("getVenueIndexList 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
    }

    /**
     * 存储首页场馆总数
     *
     * @param venueIndexTotalKey
     * @param total
     * @return
     */
    @Override
    public boolean setVenueIndexTotal(String venueIndexTotalKey, Integer total) {
        Jedis jedis = null;
        JedisSentinelPool sentinelPool = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            //将列表放入Redis中
            jedis.set(venueIndexTotalKey, total.toString());

            //设置过期时间
            Date now = new Date();
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(now);
            calendar.add(Calendar.HOUR_OF_DAY, 24);
            Date expireDate = calendar.getTime();
            long lifeDate = (expireDate.getTime() - now.getTime()) / 1000;
            jedis.expire(venueIndexTotalKey.getBytes(), (int) lifeDate);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("setVenueIndexTotal 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
        return false;
    }

    /**
     * 获取首页场馆总数
     *
     * @param venueIndexTotalKey
     * @return
     */
    @Override
    public Integer getVenueIndexTotal(String venueIndexTotalKey) {
        Jedis jedis = null;
        JedisSentinelPool sentinelPool = null;
        Integer total = 0;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            String strTotal = jedis.get(venueIndexTotalKey);
            if (StringUtils.isNotBlank(strTotal)) {
                total = Integer.parseInt(strTotal);
            }
        } catch (Exception e) {
            logger.info("setResultValue error {}", e);
            e.printStackTrace();
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("getVenueIndexTotal 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
        return total;
    }

    /**
     * 保存订票请求是否超时
     *
     * @param sId
     * @return
     */
    public String saveBookActivitySid(String sId) {
        Jedis jedis = null;
        JedisSentinelPool sentinelPool = null;
        Integer total = 0;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            jedis.set(sId, "Y");
        } catch (Exception e) {
            logger.info("setResultValue error {}", e);
            e.printStackTrace();
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("saveBookActivitySid 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
        return Constant.RESULT_STR_SUCCESS;
    }


    /**
     * 添加新的bookId至Redis或删除Redis中指定的bookId
     *
     * @param roomId  活动室ID
     * @param bookId  预订ID
     * @param addFlag 添加标记
     * @return
     */
    @Override
    public String changeBookIdInRedis(String roomId, String bookId, boolean addFlag) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String roomPrefix = sdf.format(new Date()) + "_";
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();

            if (!jedis.isConnected()) {
                jedis.connect();
            }
            String msg = "";
            List<String> list = (List<String>) ListTranscoder.deserialize(jedis.get((roomPrefix + roomId).getBytes()));
            if (list != null && list.size() > 0) {

                if (addFlag) {
                    if (!list.contains(bookId)) {
                        list.add(bookId);
                    }
                } else {
                    if (list.contains(bookId)) {
                        list.remove(bookId);
                    }
                }
            }

            //更新Redis中活动室已预定列表
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(new Date());
            //设置过期时间为当前时间之后的24小时
            calendar.add(Calendar.HOUR_OF_DAY, 24);
            //将活动室预定信息放入Redis
            setRoomBookList(roomId, list, calendar.getTime());
        } catch (Exception ex) {
            return ex.toString();
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("changeBookIdInRedis 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
        return Constant.RESULT_STR_SUCCESS;
    }


    /**
     * 往内存中添加数据
     *
     * @return
     */
    @Override
    public String setValueToRedis(byte[] bytesKey, byte[] valueKey, Date endDate) {
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();

            if (!jedis.isConnected()) {
                jedis.connect();
            }
            jedis.set(bytesKey, valueKey);
            if (endDate != null) {
                //设置过期时间
                Date now = new Date();
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(endDate);
                Date expireDate = calendar.getTime();
                long lifeDate = (expireDate.getTime() - now.getTime()) / 1000;
                jedis.expire(bytesKey, (int) lifeDate);
            }

        } catch (Exception ex) {
            return ex.toString();
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("setValueToRedis 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
        return Constant.RESULT_STR_SUCCESS;
    }


    /**
     * 往内存中添加数据
     *
     * @return
     */
    public String setValueToRedis(String key, String value, Date endDate) {
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();

            if (!jedis.isConnected()) {
                jedis.connect();
            }
            jedis.set(key, value);
            if (endDate != null) {
                //设置过期时间
                Date now = new Date();
/*                Calendar calendar = Calendar.getInstance();
                calendar.setTime(endDate);
                Date expireDate = calendar.getTime();*/
                long lifeDate = (endDate.getTime() - now.getTime()) / 1000;
                jedis.expire(key, (int) lifeDate);
            }

        } catch (Exception ex) {
            return ex.toString();
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("setValueToRedis 关闭redis连接失败！", e);
                e.printStackTrace();
            }
        }
        return Constant.RESULT_STR_SUCCESS;
    }

    @Override
    public boolean setSendSmsInfo(String dataKey, Object dataList) {
        Jedis jedis = null;
        JedisSentinelPool sentinelPool = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }

            if (jedis.exists(dataKey.getBytes())) {
                return true;
            }

            Date now = new Date();
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(now);
            calendar.add(Calendar.DATE, 30);
            Date expireDate = calendar.getTime();
            long lifeDate = (expireDate.getTime() - now.getTime()) / 1000;
            //jedis.expire(dataKey.getBytes(), (int) lifeDate);
            //将列表放入Redis中
            jedis.set(dataKey.getBytes(), ListTranscoder.serialize(dataList), "NX".getBytes(), "EX".getBytes(), lifeDate);

        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	
            	logger.error("setSendSmsInfo 关闭redis连接失败！", e);
            	e.printStackTrace();
            }
        }
        return false;
    }

    @Override
    public List<Map<String, Object>> getSendSmsInfo(String dataKey) {
        Jedis jedis = null;
        JedisSentinelPool sentinelPool = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            byte[] bytes = jedis.get(dataKey.getBytes());

            List<Map<String, Object>> list = new ArrayList<>();
            if (bytes != null) {
                list = (List<Map<String, Object>>) ListTranscoder.deserialize(bytes);
            }
            return list;
        } catch (Exception e) {
            logger.info("getSendSmsInfo error {}", e);
            e.printStackTrace();
            return new ArrayList<>();
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	
            	logger.error("getSendSmsInfo 关闭redis连接失败！", e);
            	e.printStackTrace();
            }
        }
    }

    //登录错误次数
    @Override
    public void setLoginErr(String key, String value) {
        JedisSentinelPool sentinelPool = null;
        Jedis jedis = null;
        key = CacheConstant.LOGIN_ERROR + key;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            String _thisValue = jedis.get(key);
            Date now = new Date();
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(now);
            calendar.add(Calendar.DATE, 30);
            Date expireDate = calendar.getTime();
            long lifeDate = (expireDate.getTime() - now.getTime()) / 1000;
            if (StringUtils.isBlank(_thisValue)) {
                jedis.set(key, value);
                jedis.expire(key, (int) lifeDate);
            } else {
                jedis.set(key, String.valueOf(Integer.parseInt(_thisValue) + 1), "XX", "EX", jedis.ttl(key));
            }
            if (jedis != null) {
                jedis.disconnect();
            }
        } catch (Exception e) {
            logger.info("setResultValue error {}", e);
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("setLoginErr 关闭redis连接失败！", e);
            	e.printStackTrace();
            }
        }
    }

    @Override
    public boolean isExistKey(String dataKey) {
        Jedis jedis = null;
        JedisSentinelPool sentinelPool = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            if (jedis.exists(dataKey)) {
                return true;
            }
            return false;
        } catch (Exception e) {
            logger.info("isExistKey Exception", e);
            e.printStackTrace();
            return false;
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("isExistKey 关闭redis连接失败！", e);
            	e.printStackTrace();
            }
        }
    }

    @Override
    public void saveList(String key, List dataList, Date expireDate) {
        Jedis jedis = null;
        JedisSentinelPool sentinelPool = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            //将列表放入Redis中
            jedis.set(key.getBytes(), ListTranscoder.serialize(dataList));
            //设置过期时间
            Date now = new Date();
            long lifeDate = (expireDate.getTime() - now.getTime()) / 1000;
            jedis.expire(key.getBytes(), (int) lifeDate);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("saveList 关闭redis连接失败！", e);
            	e.printStackTrace();
            }
        }

    }


    @Override
    public List getList(String code) {
        Jedis jedis = null;
        JedisSentinelPool sentinelPool = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            byte[] bytes = jedis.get(code.getBytes());
            List list = new ArrayList();
            if (bytes != null) {
                list = (List) ListTranscoder.deserialize(bytes);
            }
            return list;
        } catch (Exception e) {
            logger.info("getList error {}", e);
            e.printStackTrace();
            return new ArrayList();
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("getList 关闭redis连接失败！", e);
            	e.printStackTrace();
            }

        }
    }

    /**
     * 将常用资讯存到redis
     *
     * @param key
     * @param information
     * @param endDate
     * @return
     */
    public void addInfo(String key, ManagementInformation information, Date endDate) {
        Jedis jedis = null;
        JedisSentinelPool sentinelPool = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            //将列表放入Redis中
            jedis.set(key.getBytes(), ListTranscoder.serialize(information));
            //设置过期时间
            Date now = new Date();
            long lifeDate = (endDate.getTime() - now.getTime()) / 1000;
            jedis.expire(key.getBytes(), (int) lifeDate);
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
             	logger.error("addInfo 关闭redis连接失败！", e);
            	e.printStackTrace();
            }
        }

    }


    @Override
    public ManagementInformation getInfo(String code) {
        Jedis jedis = null;
        JedisSentinelPool sentinelPool = null;
        try {
            sentinelPool = getJedisSentinelPool();
            jedis = sentinelPool.getResource();
            if (!jedis.isConnected()) {
                jedis.connect();
            }
            ManagementInformation info = new ManagementInformation();
            byte[] bytes = jedis.get(code.getBytes());
            if (bytes != null) {
                info = (ManagementInformation) ListTranscoder.deserialize(bytes);
            }
            return info;
        } catch (Exception e) {
            logger.info("setResultValue error {}", e);
            e.printStackTrace();
            return null;
        } finally {
            try {
            	if(jedis!=null){
    				jedis.close();
    			}
    			
    			if(sentinelPool!=null){
    				   sentinelPool.destroy();
    			}
            } catch (Exception e) {
            	logger.error("getInfo 关闭redis连接失败！", e);
            	e.printStackTrace();
            }

        }
    }
}
