package com.sun3d.why.service.impl;

import java.text.DateFormat;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sun3d.why.dao.UserIntegralMapper;
import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.CmsActivityEvent;
import com.sun3d.why.model.CmsActivityOrder;
import com.sun3d.why.model.CmsActivitySeat;
import com.sun3d.why.model.CmsAdvert;
import com.sun3d.why.model.CmsTag;
import com.sun3d.why.model.CmsVenue;
import com.sun3d.why.model.ManagementInformation;
import com.sun3d.why.model.UserIntegral;
import com.sun3d.why.model.extmodel.BookActivitySeatInfo;
import com.sun3d.why.model.extmodel.BookTicketConfig;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.redis.RedisDAO;
import com.sun3d.why.service.CacheConstant;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.CmsActivityEventService;
import com.sun3d.why.service.CmsActivityOrderService;
import com.sun3d.why.service.CmsActivityService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.DateUtils;
import com.sun3d.why.util.RandomUtils;
import com.sun3d.why.util.redis.ListTranscoder;
import com.sun3d.why.webservice.api.service.CmsApiActivityOrderService;

import redis.clients.jedis.HostAndPort;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisSentinelPool;
import redis.clients.jedis.Transaction;

@Service
@Transactional
public class CacheServiceImpl implements CacheConstant, CacheService {

	// @Autowired
	// protected JedisPoolConfig jedisPoolConfig;
	/*
	 * @Autowired protected RedisConfig redisConfig;
	 */
	@Autowired
	private BookTicketConfig bookTicketConfig;
	@Autowired
	private CmsActivityOrderService cmsActivityOrderService;
	@Autowired
	private CmsActivityService cmsActivityService;
	@Autowired
	private CmsApiActivityOrderService cmsApiActivityOrderService;
	@Autowired
	private UserIntegralMapper userIntegralMapper;
	@Autowired
	private CmsActivityEventService cmsActivityEventService;
	
	@Autowired
	private RedisDAO<String> redisDAO;
	@Autowired
	private StaticServer staticServer;

	private Logger logger = Logger.getLogger(CacheServiceImpl.class);

	/**
	 * 得到需要生成的场次信息 如 2015-10-17 08:00-09:00 2015-10-17 13:00-15:00 2015-10-18
	 * 08:00-09:00 2015-10-19 13:00-15:00 这类信息
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
			// 比较两个日期相隔多少天
			while (activityStartTime.compareTo(activityEndTime) <= 0) {
				ca.setTime(activityStartTime);
				ca.add(Calendar.DATE, 1);
				activityStartTime = ca.getTime();
				// 得到年月日
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
		
		try {
			
			String key = CacheConstant.ACTIVITY_TICKET_COUNT + activityId + "_" + eventDateTime;
			return redisDAO.getData(key) == null ? 0 : Integer.parseInt(redisDAO.getData(key));
		} catch (Exception ex) {
			logger.error("getSeatCountByActivityIdAndTime 错误！", ex);
			ex.printStackTrace();
			return 0;
		} finally {
			
		}
	}

	/**
	 * 设置内存中座位数量的默认值
	 */
	@Override
	public String setSeatCount(String activityId, String value, Date endDate, List<String> eventInfo) throws Exception {
		
		try {
			
			if (eventInfo != null && eventInfo.size() > 0) {
				for (String eventDateTime : eventInfo) {
					String countValue = new String(value);
					String key = (CacheConstant.ACTIVITY_TICKET_COUNT + activityId + "_" + eventDateTime);
					
					if (endDate != null) {
						Date now = new Date();
						Calendar calendar = Calendar.getInstance();
						calendar.setTime(endDate);
						calendar.add(Calendar.HOUR_OF_DAY, 24);
						Date expireDate = calendar.getTime();
						long lifeDate = (expireDate.getTime() - now.getTime()) / 1000;
						
						redisDAO.save(key, countValue, lifeDate);
					}
					else
						redisDAO.save(key, countValue);
				}
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			return ex.toString();
		} finally {
		
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
	
		try {
			
			String key = CacheConstant.ACTIVITY_TICKET_COUNT + activityId + "_" + eventDateTime;
			
			if (endDate != null) {
				// 设置过期时间
				Date now = new Date();
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(endDate);
				calendar.add(Calendar.HOUR_OF_DAY, 24);
				Date expireDate = calendar.getTime();
				long lifeDate = (expireDate.getTime() - now.getTime()) / 1000;
				redisDAO.save(key, value, (int) lifeDate);
			}else
				redisDAO.save(key, value);
			
		} catch (Exception ex) {
			ex.printStackTrace();
			return ex.toString();
		} finally {
		
		}
		return Constant.RESULT_STR_SUCCESS;
	}

	public void saveActivityRoomToQueues(String key, String value) {
		try {
			long count = redisDAO.saveSet(key, value);
			
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			
		}
	}

	

	

	@Override
	public String getValueByKey(String key) {
		
		try {
			return redisDAO.getData(key);
		} catch (Exception e) {
			logger.info("getValueByKey error {}", e);
			e.printStackTrace();
			return e.toString();
		} finally {
			
		}

		// return null;
	}

	@Override
	public String setResultValue(String key, String value) {
		
		try {
			
			redisDAO.save(key, value);
			
			return "success";
		} catch (Exception e) {
			logger.info("setResultValue error {}", e);
			e.printStackTrace();
			return e.toString();
		} finally {
			
		}
		// return null;
	}

	@Override
	public String deleteValueByKey(String key) {
		
		try {
			
			redisDAO.delete(key);
			
			return "success";
		} catch (Exception e) {
			logger.info("setResultValue error {}", e);
			e.printStackTrace();
			return e.toString();
		} finally {
			
		}
	}

	/**
	 * 根据活动id 和场次信息得到活动座位信息
	 *
	 * @return
	 */
	@Override
	public List<CmsActivitySeat> getSeatInfoByIdAndTime(String activityId, String eventTime) {
		try {
			byte[] bytes = redisDAO.getData(activityId.getBytes());
			
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
		
		}
	}
	
	 public Integer getSeatCount(String activityId, String eventDateTime) {
	        try {
	            String key = CacheConstant.ACTIVITY_TICKET_COUNT + activityId + "_" + eventDateTime;
	            
	            String value = redisDAO.getData(key);
	            if (value != null) {
	                return Integer.parseInt(value);
	            } else {
	                return 0;
	            }
	        } catch (Exception ex) {
	            ex.printStackTrace();
	            return 0;
	        } finally {
	            
	        }
	    }

	// 判断所选座位能否被取消预定
	@Override
	public String checkSeatStatusByCancel(BookActivitySeatInfo seatInfo, String[] seatIds, Integer cancelCount,
			String userId) {
		
		try {
			String activityId = seatInfo.getActivityId();
			// 判断活动时间已经过期 或已经结束
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
						// 不在规定时间内 不能进行订票
						return "活动已经开始或结束,不能取消订单";
					}
				}
				seatInfo.setEventDateTime(cmsActivityEvent.getEventDateTime());
			} catch (Exception ex) {
				ex.printStackTrace();
				logger.error("ex {}", ex);
			}
			
			if (seatIds != null && seatIds.length > 0) {
				if (seatIds == null || seatIds.length == 0) {
					return "seatEmpty";
				}
				String msg = "";
				Map seatMap = new LinkedHashMap();
				seatMap = (Map) ListTranscoder.deserialize(redisDAO.getData(activityId.getBytes()));
				
				if (seatMap != null && seatMap.size() > 0) {
					if (seatMap.containsKey(seatInfo.getEventDateTime())) {
						Map<String, CmsActivitySeat> oneEventMap = (Map<String, CmsActivitySeat>) seatMap
								.get(seatInfo.getEventDateTime());
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
		
		}
		return Constant.RESULT_STR_SUCCESS;
	}
	
	
	// 判断所选座位能否被预定
	@Override
	public String checkActivitySeatStatus(BookActivitySeatInfo seatInfo, String[] seatIds, Integer bookCount,
			String userId) {
		
		try {
			// //已经购买到的票数
			if (bookCount == null) {
				bookCount = seatIds.length;
			}
			if (bookCount == 0) {
				bookCount = seatIds.length;
			}
			String activityId = seatInfo.getActivityId();
			// 判断活动时间已经过期 或已经结束
			CmsActivity cmsActivity = cmsActivityService.queryFrontActivityByActivityId(activityId);
			if (cmsActivity != null) {
				if (cmsActivity.getActivityState() != 6 || cmsActivity.getActivityIsDel() != 1) {
					return "该活动未发布或已经删除，不能预定";
				}
			} else {
				return "该活动不存在";
			}
			// 判断是否是子区县的活动
			if (StringUtils.isNotBlank(cmsActivity.getSysNo()) && StringUtils.isNotBlank(cmsActivity.getSysId())) {
				String str = cmsApiActivityOrderService.checkActivitySeatStatus(seatInfo.getActivityId(), seatIds,
						bookCount, userId);
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
			// 判断用户是否填写了手机号码
			if (StringUtils.isBlank(seatInfo.getPhone())) {
				return "手机号码不能为空";
			}

			// 积分判断
			if (StringUtils.isNotBlank(userId) && StringUtils.isNotBlank(seatInfo.getCostTotalCredit())) {
				UserIntegral userIntegral = userIntegralMapper.selectUserIntegralByUserId(userId);
				if (userIntegral != null) {
					if (Integer.parseInt(seatInfo.getCostTotalCredit()) > userIntegral.getIntegralNow()) {
						return "该用户的积分不够抵扣该活动";
					}
				} else {
					if (Integer.parseInt(seatInfo.getCostTotalCredit()) > 0) {
						return "该用户的积分不够抵扣该活动";
					}
				}
			}

			if (cmsActivity.getTicketSettings().equals("N")) {
				int userTickets = cmsActivityOrderService.queryOrderCountByUser(orderMap);
				if (userTickets > 0 && cmsActivity.getTicketNumber() != null
						&& userTickets + 1 > cmsActivity.getTicketNumber()) {
					return "moreLimit";
				}
				// 为移动接口添加的判断
				if (cmsActivity.getTicketCount() != null && bookCount > cmsActivity.getTicketCount()) {
					return "moreLimitCount";
				}
			} else {
				int userTicketCount = cmsActivityOrderService.queryOrderTicketCountByUser(orderMap);
				// 最大的购买票数
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
						// 不在规定时间内 不能进行订票
						return "overtime";
					}
				}
			} catch (Exception ex) {
				ex.printStackTrace();
				logger.error("ex {}", ex);
			}
			
			if (seatIds != null && seatIds.length > 0) {
				Map map = new HashMap();
				if (seatIds == null || seatIds.length == 0) {
					return "seatEmpty";
				}
				String msg = "";
				Map seatMap = new LinkedHashMap();
				seatMap = (Map) ListTranscoder.deserialize(redisDAO.getData(activityId.getBytes()));
				if (seatMap != null && seatMap.size() > 0) {
					if (seatMap.containsKey(seatInfo.getEventDateTime())) {
						Map<String, CmsActivitySeat> oneEventMap = (Map<String, CmsActivitySeat>) seatMap
								.get(seatInfo.getEventDateTime());
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
		
		}
		return Constant.RESULT_STR_SUCCESS;
	}

	@Override
	public String genOrderNumber() {
		// JedisSentinelPool sentinelPool = null;
		// Jedis jedis = null;
		try {
			// sentinelPool = getJedisSentinelPool();
			// jedis = sentinelPool.getResource();
			//
			/// * if (StringUtils.isNotBlank(redisConfig.getPassword())) {
			// jedis.auth(redisConfig.getPassword());
			// }*/
			// if (!jedis.isConnected()) {
			// jedis.connect();
			// }
			// String key = RandomUtils.genOrderNumberRedisKey();
			// Long value = jedis.incr(key);
			// int expireSeconds = DateUtils.getOrderNumberExpireSeconds();
			// jedis.expire(key, expireSeconds);
			// if (value.intValue() >= Constant.MAX_ORDER_SUFFIX) {
			// throw new RuntimeException("Order number overflow!");
			// }
			// String orderSuffix = RandomUtils.digitsFormat(value, 6);
			// String orderPrefix = RandomUtils.genOrderNumberPrefix();
			long value = new Random().nextInt(99999);
			NumberFormat numberFormat = NumberFormat.getIntegerInstance();
			numberFormat.setGroupingUsed(false);
			numberFormat.setMaximumIntegerDigits(6);
			numberFormat.setMinimumIntegerDigits(6);
			Date current = new Date();
			SimpleDateFormat orderPrefixFormat = new SimpleDateFormat("yyMMdd");
			String orderSuffix = numberFormat.format(value);
			String orderPrefix = orderPrefixFormat.format(current);
			return orderPrefix + orderSuffix;

		} catch (Exception e) {
			logger.info("genOrderNumber error" + e);
		}
		return null;

	}

	@Override
	public String genUserNumber() {
		try {
			
			String key = RandomUtils.genUserNumberRedisKey();
			Long value = redisDAO.incr(key);
			int expireSeconds = DateUtils.getUserNumberExpireSeconds();
			redisDAO.expire(key, expireSeconds);
			if (value.intValue() >= Constant.MAX_USER_SUFFIX) {
				throw new RuntimeException("User number overflow!");
			}
			String userSuffix = RandomUtils.digitsFormat(value, 6);
			String userPrefix = RandomUtils.genUserNumberPrefix();
			return Constant.USER_ID_PREFIX + userPrefix + userSuffix + RandomStringUtils.random(2, false, true);

		} catch (Exception e) {
			logger.info("genUserNumber error" + e);
		} finally {
			
		}
		return null;
	}

	public String saveQueueName(String key, String value) {
		
		try {
			
			long count = redisDAO.saveSet(key, value);
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
			
		}
	}

	public Iterator queryQueueName(String key) {
		
		try {
				Set set = redisDAO.getDataSet(key);
				Iterator iterator = set.iterator();
				return iterator;
			
		} catch (Exception ex) {
			ex.printStackTrace();
			return null;
		} finally {
			
		}
	}

	/*****************************
	 * ------------活动室预定第二种处理方式-------------------
	 **********************/
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
		
		try {
			
			String msg = "";
			List<String> list = (List<String>) ListTranscoder.deserialize(redisDAO.getData((roomPrefix + roomId).getBytes()));
			if (list != null && list.size() > 0) {
				// 如果Redis中存在活动室预定ID，则预定成功并直接从列表中移除代表已被预定
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

			// 更新Redis中活动室已预定列表
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(new Date());
			// 设置过期时间为当前时间之后的24小时
			calendar.add(Calendar.HOUR_OF_DAY, 24);
			// 将活动室预定信息放入Redis
			setRoomBookList(roomId, list, calendar.getTime());
		} catch (Exception ex) {
			return ex.toString();
		} finally {
			try {
			
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
		
		try {
			
			// 将列表放入Redis中
			redisDAO.save((roomPrefix + key).getBytes(), ListTranscoder.serialize(list));
			// 设置过期时间
			Date now = new Date();
			long lifeDate = (expireDate.getTime() - now.getTime()) / 1000;
			redisDAO.expire((roomPrefix + key).getBytes(), (int) lifeDate);
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			
		}
	}

	/**
	 * **************************------------活动室预定第二种处理方式-------------------****
	 * *****************
	 */

	// 缓存广告
	public void setAdvertList(String key, List<CmsAdvert> list, Date expireDate) {
		// SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		// String roomPrefix = sdf.format(new Date()) + "_";
		
		try {
			
			// 将列表放入Redis中
			redisDAO.save(key.getBytes(), ListTranscoder.serialize(list));
			// 设置过期时间
			Date now = new Date();
			long lifeDate = (expireDate.getTime() - now.getTime()) / 1000;
			redisDAO.expire(key.getBytes(), (int) lifeDate);
		} catch (Exception ex) {
			ex.printStackTrace();

		} finally {
			
		}
	}

	@Override
	public List<CmsAdvert> getAdvert(String siteId) {
		try {
			byte[] bytes = redisDAO.getData(siteId.getBytes());
			
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
		}
	}

	// 缓存标签
	public void setTagList(String key, List<CmsTag> list, Date expireDate) {
		// SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		// String roomPrefix = sdf.format(new Date()) + "_";
		try {
			// 将列表放入Redis中
			redisDAO.save(key.getBytes(), ListTranscoder.serialize(list));
			// 设置过期时间
			Date now = new Date();
			long lifeDate = (expireDate.getTime() - now.getTime()) / 1000;
			redisDAO.expire(key.getBytes(), (int) lifeDate);
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
		}
	}

	public List<CmsTag> getTagList(String tagType) {
		try {
			
			byte[] bytes = redisDAO.getData(tagType.getBytes());
			List<CmsTag> list = new ArrayList<CmsTag>();
			if (bytes != null) {
				list = (List<CmsTag>) ListTranscoder.deserialize(bytes);
			}
			return list;
		} catch (Exception e) {
			logger.info("getTagList error {}", e);
			e.printStackTrace();
			return null;
		} finally {
			
		}
	}

	/**
	 * 查询首页热点推荐或最新活动
	 *
	 * @return
	 */
	public List<CmsActivity> queryActivityList(String activityListKey) {
		try {
			byte[] bytes = redisDAO.getData(activityListKey.getBytes());
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
			
		}
	}

	/**
	 * 将首页热点推荐或最新活动放至内存中
	 *
	 * @param
	 * @param cmsActivities
	 */
	public String setActivityList(String activityListKey, List<CmsActivity> cmsActivities) {
		
		try {
		
			redisDAO.save(activityListKey.getBytes(), ListTranscoder.serialize(cmsActivities));
			return Constant.RESULT_STR_SUCCESS;
		} catch (Exception e) {
			logger.info("setActivityList error {}", e);
			e.printStackTrace();
			return e.toString();
		} finally {
			
		}
	}

	@Override
	public void setLikeActivityList(String key, List<CmsActivity> dataList, Date expireDate) {
		// SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		// String roomPrefix = sdf.format(new Date()) + "_";
	
		try {
			
			// 将列表放入Redis中
			redisDAO.save(key.getBytes(), ListTranscoder.serialize(dataList));
			// 设置过期时间
			Date now = new Date();
			long lifeDate = (expireDate.getTime() - now.getTime()) / 1000;
			redisDAO.expire(key.getBytes(), (int) lifeDate);
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			
		}

	}

	@Override
	public List<CmsActivity> getLikeActivityList(String code) {
		
		try {
			
			byte[] bytes = redisDAO.getData(code.getBytes());
			List<CmsActivity> list = new ArrayList<CmsActivity>();
			if (bytes != null) {
				list = (List<CmsActivity>) ListTranscoder.deserialize(bytes);
			}
			return list;
		} catch (Exception e) {
			logger.info("getLikeActivityList error {}", e);
			e.printStackTrace();
			return new ArrayList<CmsActivity>();
		} finally {
			

		}
	}

	/**
	 * 根绝Redis中的KEY值更新场馆首页列表
	 *
	 * @param venueIndexKey
	 * @return
	 */
	@Override
	public boolean updateVenueIndex(String venueIndexKey, List<CmsVenue> venueList) {
	
		try {
			
			// 将列表放入Redis中
			redisDAO.save(venueIndexKey.getBytes(), ListTranscoder.serialize(venueList));

			// 设置过期时间
			Date now = new Date();
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(now);
			calendar.add(Calendar.HOUR_OF_DAY, 24);
			Date expireDate = calendar.getTime();
			long lifeDate = (expireDate.getTime() - now.getTime()) / 1000;
			redisDAO.expire(venueIndexKey.getBytes(), (int) lifeDate);
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			
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
		try {
			byte[] bytes = redisDAO.getData(venueIndexKey.getBytes());
			List<CmsVenue> list = new ArrayList<CmsVenue>();
			if (bytes != null) {
				list = (List<CmsVenue>) ListTranscoder.deserialize(bytes);
			}
			return list;
		} catch (Exception e) {
			logger.info("getVenueIndexList error {}", e);
			e.printStackTrace();
			return new ArrayList<CmsVenue>();
		} finally {
			
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
		try {
			
			// 将列表放入Redis中
			redisDAO.save(venueIndexTotalKey, total.toString());

			// 设置过期时间
			Date now = new Date();
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(now);
			calendar.add(Calendar.HOUR_OF_DAY, 24);
			Date expireDate = calendar.getTime();
			long lifeDate = (expireDate.getTime() - now.getTime()) / 1000;
			redisDAO.expire(venueIndexTotalKey.getBytes(), (int) lifeDate);
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			
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
		
		Integer total = 0;
		try {
			
			String strTotal = redisDAO.getData(venueIndexTotalKey);
			if (StringUtils.isNotBlank(strTotal)) {
				total = Integer.parseInt(strTotal);
			}
		} catch (Exception e) {
			logger.info("getVenueIndexTotal error {}", e);
			e.printStackTrace();
		} finally {
			
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
		Integer total = 0;
		try {
			redisDAO.save(sId, "Y");
		} catch (Exception e) {
			logger.info("saveBookActivitySid error {}", e);
			e.printStackTrace();
		} finally {
			
		}
		return Constant.RESULT_STR_SUCCESS;
	}

	/**
	 * 添加新的bookId至Redis或删除Redis中指定的bookId
	 *
	 * @param roomId
	 *            活动室ID
	 * @param bookId
	 *            预订ID
	 * @param addFlag
	 *            添加标记
	 * @return
	 */
	@Override
	public String changeBookIdInRedis(String roomId, String bookId, boolean addFlag) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		String roomPrefix = sdf.format(new Date()) + "_";
		try {
			String msg = "";
			List<String> list = (List<String>) ListTranscoder.deserialize(redisDAO.getData((roomPrefix + roomId).getBytes()));
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

			// 更新Redis中活动室已预定列表
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(new Date());
			// 设置过期时间为当前时间之后的24小时
			calendar.add(Calendar.HOUR_OF_DAY, 24);
			// 将活动室预定信息放入Redis
			setRoomBookList(roomId, list, calendar.getTime());
		} catch (Exception ex) {
			return ex.toString();
		} finally {
			
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
		try {
			redisDAO.save(bytesKey, valueKey);
			if (endDate != null) {
				// 设置过期时间
				Date now = new Date();
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(endDate);
				Date expireDate = calendar.getTime();
				long lifeDate = (expireDate.getTime() - now.getTime()) / 1000;
				redisDAO.expire(bytesKey, (int) lifeDate);
			}

		} catch (Exception ex) {
			return ex.toString();
		} finally {
			
		}
		return Constant.RESULT_STR_SUCCESS;
	}

	/**
	 * 往内存中添加数据
	 *
	 * @return
	 */
	public String setValueToRedis(String key, String value, Date endDate) {
		try {
			
			redisDAO.save(key, value);
			if (endDate != null) {
				// 设置过期时间
				Date now = new Date();
				/*
				 * Calendar calendar = Calendar.getInstance();
				 * calendar.setTime(endDate); Date expireDate =
				 * calendar.getTime();
				 */
				long lifeDate = (endDate.getTime() - now.getTime()) / 1000;
				redisDAO.expire(key, (int) lifeDate);
			}

		} catch (Exception ex) {
			return ex.toString();
		} finally {
			
		}
		return Constant.RESULT_STR_SUCCESS;
	}

	
	// 登录错误次数
	@Override
	public void setLoginErr(String key, String value) {
		
//		key = CacheConstant.LOGIN_ERROR + key;
//		try {
//			
//			String _thisValue = redisDAO.getData(key);
//			Date now = new Date();
//			Calendar calendar = Calendar.getInstance();
//			calendar.setTime(now);
//			calendar.add(Calendar.DATE, 30);
//			Date expireDate = calendar.getTime();
//			long lifeDate = (expireDate.getTime() - now.getTime()) / 1000;
//			if (StringUtils.isBlank(_thisValue)) {
//				redisDAO.save(key, value);
//				redisDAO.expire(key, (int) lifeDate);
//			} else {
//				redisDAO.save(key, String.valueOf(Integer.parseInt(_thisValue) + 1), "XX", "EX", redisDAO.ttl(key));
//			}
//			
//		} catch (Exception e) {
//			logger.info("setLoginErr error {}", e);
//		} finally {
//			
//		}
	}


	@Override
	public void saveList(String key, List dataList, Date expireDate) {
		
		try {
			
			// 将列表放入Redis中
			redisDAO.save(key.getBytes(), ListTranscoder.serialize(dataList));
			// 设置过期时间
			Date now = new Date();
			long lifeDate = (expireDate.getTime() - now.getTime()) / 1000;
			redisDAO.expire(key.getBytes(), (int) lifeDate);
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			
		}

	}

	@Override
	public List getList(String code) {
		try {
			
			byte[] bytes = redisDAO.getData(code.getBytes());
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
		try {
			
			// 将列表放入Redis中
			redisDAO.save(key.getBytes(), ListTranscoder.serialize(information));
			// 设置过期时间
			Date now = new Date();
			long lifeDate = (endDate.getTime() - now.getTime()) / 1000;
			redisDAO.expire(key.getBytes(), (int) lifeDate);
		} catch (Exception ex) {
			ex.printStackTrace();
		} finally {
			
		}

	}

	@Override
	public ManagementInformation getInfo(String code) {
		try {
			ManagementInformation info = new ManagementInformation();
			byte[] bytes = redisDAO.getData(code.getBytes());
			if (bytes != null) {
				info = (ManagementInformation) ListTranscoder.deserialize(bytes);
			}
			return info;
		} catch (Exception e) {
			logger.info("getInfo error {}", e);
			e.printStackTrace();
			return null;
		} finally {
			

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
				if (jedis != null) {
					jedis.close();
				}

				if (sentinelPool != null) {
					sentinelPool.destroy();
				}
			} catch (Exception e) {
				logger.error("isExistKey 关闭redis连接失败！", e);
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
}
