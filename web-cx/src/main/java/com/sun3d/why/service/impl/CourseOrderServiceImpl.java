package com.sun3d.why.service.impl;

import com.sun3d.why.dao.CourseOrderMapper;
import com.sun3d.why.dao.SmsLogMapper;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.SmsLog;
import com.sun3d.why.model.SysDict;
import com.sun3d.why.model.SysUser;
import com.sun3d.why.model.extmodel.SmsConfig;
import com.sun3d.why.model.peopleTrain.Course;
import com.sun3d.why.model.peopleTrain.CourseOrder;
import com.sun3d.why.model.peopleTrain.CourseOrderTemp;
import com.sun3d.why.service.CourseOrderService;
import com.sun3d.why.service.CourseService;
import com.sun3d.why.service.SysDictService;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.Pagination;
import com.sun3d.why.util.SmsSend;
import com.sun3d.why.util.UUIDUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.atomic.AtomicInteger;

@Service
@Transactional
public class CourseOrderServiceImpl implements CourseOrderService {

	public static String DEFAULT_FORMAT = "yyyy-MM-dd HH:mm:ss";

	@Autowired
	private CourseOrderMapper courseOrderMapper;
	@Autowired
	private CourseService courseService;
	@Autowired
	private SysDictService sysDictService;
	@Autowired
	private SmsConfig config;

	@Autowired
	SmsSend smsSend;
	private static ExecutorService service = Executors.newFixedThreadPool(10);
    @Autowired
	SmsLogMapper smsLogMapper;
	@Override
	public String checkCourseOrder(String[] courseId, String[] courseType, String[] courseTitle, String userId) {
		SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
		String str = null;
		String firstDay = this.getYearFirst();
		String lastDay = this.getYearLast();
		SysDict dic1 = sysDictService.querySysDictByDictName("三天短训", "STDX");
		SysDict dic2 = sysDictService.querySysDictByDictName("专题讲座", "ZTJZ");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("courserType", dic1.getDictId());
		map.put("userId", userId);
		map.put("firstDay", firstDay);
		map.put("lastDay", lastDay);
		int shortOrder = this.queryCourseOrderCount(map);
		map.put("courserType", dic2.getDictId());
		int lecOrder = this.queryCourseOrderCount(map);
		int sc = 0;
		int lc = 0;
		for (String ct : courseType) {
			if (dic1.getDictId().equals(ct)) {
				sc++;
			} else if (dic2.getDictId().equals(ct)) {
				lc++;
			}
		}
		if (shortOrder >= 1 && sc > 0) {
			str = "对不起，本年内您已经选报1次短训类课程了";
			return str;
		}
		if ((lecOrder == 6 && lc > 0) || (lecOrder + lc > 6 && lc > 0)) {
			str = "对不起，本年内您已经超过6次选报讲座类课程,请重新选择！";
			return str;
		}
		for (int i = 0; i < courseId.length; i++) {
			Map<String, Object> m1 = new HashMap<String, Object>();
			Map<String, Object> m2 = new HashMap<String, Object>();
			m1.put("courseId", courseId[i]);
			m1.put("userId", userId);
			m2.put("courseId", courseId[i]);
			int c = this.queryCourseOrderCount(m1);
			if (c > 0) {
				str = "【" + courseTitle[i] + "】,您已经报过了，请重新选择";
				return str;
			}
			Course course = courseService.queryCourseByCourseId(courseId[i]);
			int orderCount = this.queryCourseOrderCount(m2);
			if (course == null || (course.getCourseState() != null && course.getCourseState() == 2)) {
				str = "【" + courseTitle[i] + "】已下架，请重新选择";
				return str;
			}
			Integer count = course.getPeopleNumber() == null ? 0 : course.getPeopleNumber();
			if (count <= orderCount) {
				str = "【" + courseTitle[i] + "】名额已满，请重新选择";
				return str;
			}
			String startTime = course.getCourseStartTime();
			Date start = null;
			try {
				start = f.parse(startTime);
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
//			Calendar cal = Calendar.getInstance(); 
//			cal.setTime(start);
//			cal.add(Calendar.DATE,+3);
//			cal.add(Calendar.DATE,+3);
//			Date limitDate = cal.getTime();
			Date curr = new Date();
		if(curr.getTime()>=start.getTime()){
			str="【"+courseTitle[i]+"】已错过报名时间，请重新选择";
			return str;
		}
		
	}
	return str;
	}

	public String getYearFirst() {
		SimpleDateFormat sdf = new SimpleDateFormat(DEFAULT_FORMAT);
		Calendar currCal = Calendar.getInstance();
		int currentYear = currCal.get(Calendar.YEAR);
		Calendar calendar = Calendar.getInstance();
		calendar.clear();
		calendar.set(Calendar.YEAR, currentYear);
		Date currYearFirst = calendar.getTime();
		return sdf.format(currYearFirst);
	}

	public String getYearLast() {
		SimpleDateFormat sdf = new SimpleDateFormat(DEFAULT_FORMAT);
		Calendar currCal = Calendar.getInstance();
		int currentYear = currCal.get(Calendar.YEAR);
		Calendar calendar = Calendar.getInstance();
		calendar.clear();
		calendar.set(Calendar.YEAR, currentYear);
		calendar.roll(Calendar.DAY_OF_YEAR, -1);
		Date currYearFirst = calendar.getTime();
		return sdf.format(currYearFirst);
	}

	@Override
	public int queryCourseOrderCount(Map<String, Object> map) {
		return courseOrderMapper.queryCourseOrderCount(map);
	}

	public void courseOrder(CourseOrderTemp temp) {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss:SSS");
		String[] courseIds = temp.getCourseId();
		for (int i = 0; i < courseIds.length; i++) {
			CourseOrder order = new CourseOrder();
			order.setOrderId(UUIDUtils.createUUId());
			order.setCourseId(courseIds[i]);
			order.setUserId(temp.getUserId());
			order.setOrderStatus(1);
			order.setMessageState(1);
			order.setAttendState(1);
			order.setAllSmsState(1);
			order.setCreateTime(dateFormat.format(new Date().getTime()));
			courseOrderMapper.addCourseOrder(order);
		}
	}

	@Override
	public void addCourseOrder(CourseOrder courseOrder) {
		courseOrderMapper.addCourseOrder(courseOrder);
	}

	@Override
	public List<CourseOrder> queryCourseOrderByUserId(Map<String, Object> map) {
		return courseOrderMapper.queryCourseOrderByUserId(map);
	}

	@Override
	public int queryCourseOrderCountByUserId(Map<String, Object> map) {
		return courseOrderMapper.queryCourseOrderCountByUserId(map);
	}

	@Override
	public List<CourseOrder> queryUserOrderList(String userId, Pagination page) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		// 网页分页
		if (page != null && page.getFirstResult() != null && page.getRows() != null) {
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
			page.setTotal(queryCourseOrderCountByUserId(map));
		}
		return queryCourseOrderByUserId(map);
	}

	@Override
	public List<CourseOrder> queryCourseOrderByCondition(String searchKey, CourseOrder courseOrder, Pagination page,
			SysUser sysUser) {
		Map<String, Object> map = new HashMap<String, Object>();
		// 权限验证
		if (sysUser != null && StringUtils.isNotBlank(sysUser.getUserCounty())
				&& ((sysUser.getUserCounty()).indexOf("44") == -1 && (sysUser.getUserCounty()).indexOf("45") == -1)) {
			map.put("sysUserId", sysUser.getUserId());
		}
		if (StringUtils.isNotBlank(searchKey)) {
			map.put("searchKey", searchKey);
		}
		// 分页
		if (page != null && page.getFirstResult() != null && page.getRows() != null) {
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
			int total = courseOrderMapper.queryCourseOrderCountByCondition(map);
			page.setTotal(total);
		}

		return courseOrderMapper.queryCourseOrderByCondition(map);
	}

	@Override
	public List<CourseOrder> queryCourseViewByCondition(String courseId, Pagination page, SysUser sysUser,
			String searchKey, String status) {
		Map<String, Object> map = new HashMap<String, Object>();
		/*
		 * // 权限验证 if (sysUser != null &&
		 * StringUtils.isNotBlank(sysUser.getUserCounty())){
		 * map.put("sysUserId", sysUser.getUserId()); }
		 */
		if (StringUtils.isNotBlank(courseId)) {
			map.put("courseId", courseId);
		}
		if (StringUtils.isNotBlank(searchKey)) {
			map.put("searchKey", searchKey);
		}
		if (StringUtils.isNotBlank(status)) {
			map.put("status", status);
		}
		// 分页
		if (page != null && page.getFirstResult() != null && page.getRows() != null) {
			map.put("firstResult", page.getFirstResult());
			map.put("rows", page.getRows());
			int total = courseOrderMapper.queryCourseOrderCountByCondition(map);
			page.setTotal(total);
		}

		return courseOrderMapper.queryCourseOrderByCondition(map);
	}

	@Override
	public CourseOrder queryCourseOrderByorderId(String orderId) {
		Map<String, Object> map = new HashMap<String, Object>();
		if (StringUtils.isNotBlank(orderId)) {
			map.put("orderId", orderId);
		}
		return courseOrderMapper.queryCourseOrderByorderId(map);
	}

	@Override
	public int deleteOrder(CourseOrder courseOrder, String state, SysUser sysUser) {
		if (StringUtils.isNotBlank(state)) {
			courseOrder.setOrderStatus(Integer.valueOf(state));

		}
		courseOrder.setUpdateUser(sysUser.getUserAccount());
		courseOrder.setUpdateTime(new Date());
		return courseOrderMapper.updateOrder(courseOrder);
	}

	@Override
	public int editAttendState(CourseOrder courseOrder, String state) {
		if (StringUtils.isNotBlank(state)) {
			courseOrder.setAttendState(Integer.valueOf(state));

		}
		// 如果是讲座类课程则增加4个学时，如果三天讲座类课程则增加24个学时
		if (StringUtils.isNotBlank(state) && !"1".equals(state)) {
			if ("ZTJZ".equals(courseOrder.getTypeCode())) {
				courseOrder.setClassTimes(4);
			} else if ("STDX".equals(courseOrder.getTypeCode())) {
				courseOrder.setClassTimes(24);
			}
		}

		return courseOrderMapper.updateOrder(courseOrder);
	}

	@Override
	public List<CourseOrder> queryCourseOrderExport(SysUser sysUser, String searchKey) {
		Map<String, Object> map = new HashMap<String, Object>();
		// 权限验证
		if (sysUser != null && StringUtils.isNotBlank(sysUser.getUserCounty())
				&& ((sysUser.getUserCounty()).indexOf("44") == -1 && (sysUser.getUserCounty()).indexOf("45") == -1)) {
			map.put("sysUserId", sysUser.getUserId());
		}
		if (StringUtils.isNotBlank(searchKey)) {
			map.put("searchKey", searchKey);
		}
		return courseOrderMapper.queryCourseOrderByCondition(map);
	}

	@Override
	public List<CourseOrder> queryExportByCourseIdExcel(String courseId, SysUser sysUser, String searchKey) {
		Map<String, Object> map = new HashMap<String, Object>();
		/*
		 * if(StringUtils.isNotBlank(sysUser.getUserId())){ map.put("sysUserId",
		 * sysUser.getUserId()); }
		 */
		if (StringUtils.isNotBlank(searchKey)) {
			map.put("searchKey", searchKey);
		}
		if (StringUtils.isNotBlank(courseId)) {
			map.put("courseId", courseId);
		}

		return courseOrderMapper.queryCourseOrderByCondition(map);
	}

	@Override
	public String sendMessage(String orderId, final String state) {
		String str = null;
		final CourseOrder courseOrder = this.queryCourseOrderByorderId(orderId);
		if (courseOrder == null) {
			str = "订单不存在";
			return str;
		}
		final String mobile = courseOrder.getUserMobileNo();
		if (StringUtils.isBlank(mobile)) {
			str = "手机号不存在";
			return str;
		}
		final String content = "恭喜您，您所报的【" + courseOrder.getCourseTitle() + "】课程，已经审核通过，培训时间："
				+ courseOrder.getStartTime() + " 至  " + courseOrder.getEndTime() + " " + courseOrder.getTrainTime()
				+ "，培训地点：" + courseOrder.getTrainAddress() + "，请准时参加。";
		Runnable runnable = new Runnable() {
			@Override
			public void run() {
				SmsSend sms = new SmsSend();
				try {
					courseOrder.setMessageState(Integer.valueOf(state));
					courseOrder.setOrderStatus(2);
					courseOrderMapper.updateOrder(courseOrder);
				      String result=	sms.sendSmsMessage(config.getSmsUrl(), config.getuId(), config.getPwd(), mobile, content);
					  SmsLog record= new SmsLog();
	                    record.setId(UUIDUtils.createUUId());
	                    record.setMark("singleSend:couorseId"+courseOrder.getCourseId());
	                    record.setSendtime(new Date());
	                    record.setPhonenumber(mobile);
	                    record.setResult(result);
						smsLogMapper.insert(record);			
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		};
		Thread thread = new Thread(runnable);
		thread.start();
		return null;
	}

	public String sendMessagesAll(String orderId, final String state) {
		SmsSend sms = new SmsSend();
		String str = null;
		if (StringUtils.isNotBlank(orderId)) {
			String[] orderIds = orderId.split(",");
			for (String oid : orderIds) {
				str = sendMessageForAll(oid, state);
			}

			// 采用线程池发送短信 start
			AtomicInteger ai = new AtomicInteger(0);
			List<Future<Integer>> list = new ArrayList<>();

			for (final String oid : orderIds) {
				str = sendMessageForAll(oid, state);
				Future<Integer> future = service.submit(new Callable<Integer>() {
					@Override
					public Integer call() throws Exception {
						final CourseOrder courseOrder = queryCourseOrderByorderId(oid);
						if (courseOrder == null) {
							return 0;
						}
						final String mobile = courseOrder.getUserMobileNo();
						if (StringUtils.isBlank(mobile)) {
							return 0;
						}
						final Integer allState = state == null ? 2 : Integer.valueOf(state);
						String content = "";
						if (StringUtils.isNotBlank(courseOrder.getCoursePhoneNum())) {
							content = "友情提醒，您所报的【" + courseOrder.getCourseTitle() + "】课程，培训时间："
									+ courseOrder.getStartTime() + " 至  " + courseOrder.getEndTime() + " "
									+ courseOrder.getTrainTime() + "，培训地点：" + courseOrder.getTrainAddress() + "，联系方式："
									+ courseOrder.getCoursePhoneNum() + "，请准时参加。";
						} else {
							content = "友情提醒，您所报的【" + courseOrder.getCourseTitle() + "】课程，培训时间："
									+ courseOrder.getStartTime() + " 至  " + courseOrder.getEndTime() + " "
									+ courseOrder.getTrainTime() + "，培训地点：" + courseOrder.getTrainAddress() + "，请准时参加。";
						}
						final String c = content;
						courseOrder.setAllSmsState(allState);
						courseOrderMapper.updateOrder(courseOrder);
						String result = smsSend.sendSmsMessage(config.getSmsUrl(), config.getuId(), config.getPwd(),
								mobile, c);
						SmsLog smsLog= new SmsLog();
						smsLog.setId(UUIDUtils.createUUId());
						smsLog.setPhonenumber(mobile);
						smsLog.setResult(result);
						smsLog.setSendtime(new Date());
						smsLog.setMark("batchSend:couorseId"+courseOrder.getCourseId());
						smsLogMapper.insert(smsLog);
						
						if (!"100".equals(result)) {
							//记录失败记录
							System.out.println("#######################    失败           ####################################");
							return 0;
						} else {
							System.out.println("#######################    成功           ####################################");
							return 1;
						}
					}
				});
				list.add(future);

			}

			// 采用线程池发送短信 start

		}
		return str;
	}

//	public String sendMessageForAll(String orderId, String allState) {
//		String str = null;
//		final CourseOrder courseOrder = this.queryCourseOrderByorderId(orderId);
//		if (courseOrder == null) {
//			str = "订单不存在";
//			return str;
//		}
//		final String mobile = courseOrder.getUserMobileNo();
//		if (StringUtils.isBlank(mobile)) {
//			str = "手机号不存在";
//			return str;
//		}
//		final Integer state = allState == null ? 2 : Integer.valueOf(allState);
//		String content = "";
//		if (StringUtils.isNotBlank(courseOrder.getCoursePhoneNum())) {
//			content = "友情提醒，您所报的【" + courseOrder.getCourseTitle() + "】课程，培训时间：" + courseOrder.getStartTime() + " 至  "
//					+ courseOrder.getEndTime() + " " + courseOrder.getTrainTime() + "，培训地点："
//					+ courseOrder.getTrainAddress() + "，联系方式：" + courseOrder.getCoursePhoneNum() + "，请准时参加。";
//		} else {
//			content = "友情提醒，您所报的【" + courseOrder.getCourseTitle() + "】课程，培训时间：" + courseOrder.getStartTime() + " 至  "
//					+ courseOrder.getEndTime() + " " + courseOrder.getTrainTime() + "，培训地点："
//					+ courseOrder.getTrainAddress() + "，请准时参加。";
//		}
//		final String c = content;
//		Runnable runnable = new Runnable() {
//			@Override
//			public void run() {
//				SmsSend sms = new SmsSend();
//				try {
//					courseOrder.setAllSmsState(state);
//					courseOrderMapper.updateOrder(courseOrder);
//					sms.sendSmsMessage(config.getSmsUrl(), config.getuId(), config.getPwd(), mobile, c);
//				} catch (Exception e) {
//					e.printStackTrace();
//				}
//			}
//		};
//		Thread thread = new Thread(runnable);
//		thread.start();
//		return null;
//	}

	@Override
	public String sendMessageForCancel(String orderId, final String state) {
		String str = null;
		final CourseOrder courseOrder = this.queryCourseOrderByorderId(orderId);
		if (courseOrder == null) {
			str = "订单不存在";
			return str;
		}
		final String mobile = courseOrder.getUserMobileNo();
		if (StringUtils.isBlank(mobile)) {
			str = "手机号不存在";
			return str;
		}
		final String content = "您所报的【" + courseOrder.getCourseTitle() + "】课程已取消，如有疑问请联系管理员。";
		Runnable runnable = new Runnable() {
			@Override
			public void run() {
				SmsSend sms = new SmsSend();
				try {
					courseOrder.setMessageState(Integer.valueOf(state));
					courseOrder.setOrderStatus(1);
					courseOrderMapper.updateOrder(courseOrder);
					String result = sms.sendSmsMessage(config.getSmsUrl(), config.getuId(), config.getPwd(), mobile, content);
                    SmsLog record= new SmsLog();
                    record.setId(UUIDUtils.createUUId());
                    record.setMark("singleSend");
                    record.setSendtime(new Date());
                    record.setPhonenumber(mobile);
                    record.setResult(result);
                    record.setMark("singleSend:couorseId"+courseOrder.getCourseId());
					smsLogMapper.insert(record);					
					
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		};
		Thread thread = new Thread(runnable);
		thread.start();
		return null;
	}

	@Override
	public String checkOrder(String courseId, String userId) {
		String str = null;
		String firstDay = this.getYearFirst();
		String lastDay = this.getYearLast();
		SysDict dic1 = sysDictService.querySysDictByDictName("三天短训", "STDX");
		SysDict dic2 = sysDictService.querySysDictByDictName("专题讲座", "ZTJZ");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("courserType", dic1.getDictId());
		map.put("userId", userId);
		map.put("firstDay", firstDay);
		map.put("lastDay", lastDay);
		int shortOrder = this.queryCourseOrderCount(map);
		map.put("courserType", dic2.getDictId());
		int lecOrder = this.queryCourseOrderCount(map);
		Course course = courseService.queryCourseByCourseId(courseId);
		if (dic1.getDictId().equals(course.getCourseType())) {
			if (shortOrder >= 1) {
				str = "对不起，本年内该用户已经选报1次短训类课程了";
				return str;
			}
		} else if (dic2.getDictId().equals(course.getCourseType())) {
			if ((lecOrder >= 6)) {
				str = "对不起，本年内该用户已经超过6次选报讲座类课程了";
				return str;
			}
		}
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("courseId", courseId);
		map1.put("userId", userId);
		int c = this.queryCourseOrderCount(map1);
		if (c > 0) {
			str = "用户该课程已报过，请重新选择";
			return str;
		}

		// int orderCount = this.queryCourseOrderCount(map);
		if (course == null || (course.getCourseState() != null && course.getCourseState() == 2)) {
			str = "该课程已下架，请重新选择";
			return str;
		}
		
		//课程开始当天不能报名
	    String startStr=	course.getCourseStartTime();
		Date cur= new Date();
		SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
		Date startDate=null;
		try {
			  startDate = f.parse(startStr);
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		if (cur.getTime() >= startDate.getTime()) {
			str = "已过了报名日期";
			return str;
		}
		
//		if(cur.getTime())
			 
		 
			
		
		
		
		
		/*
		 * Integer count =
		 * course.getPeopleNumber()==null?0:course.getPeopleNumber();
		 * if(count<=orderCount){ str="该课程名额已满，请重新选择"; return str; }
		 */

		return str;

	}

	public int updateOrder(CourseOrder courseOrder) {
		return courseOrderMapper.updateOrder(courseOrder);
	}

	public String cancelOrder(CourseOrder courseOrder, CmsTerminalUser terminalUser) {
		String startTime = courseOrder.getStartTime();
		if (StringUtils.isNotBlank(startTime)) {
			SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
			try {
				Date start = f.parse(startTime);
				Calendar cal = Calendar.getInstance();
				cal.setTime(start);
				cal.add(Calendar.DATE, -3);
				Date limitDate = cal.getTime();
				Date curr = new Date();
				if (curr.getTime() >= limitDate.getTime()) {
					return "上课前3天之前，该课程不能取消";
				}
				courseOrder.setOrderStatus(3);
				courseOrder.setUpdateUser(terminalUser.getUserName());
				courseOrder.setUpdateTime(new Date());

				int count = this.updateOrder(courseOrder);
				if (count > 0) {
					return Constant.RESULT_STR_SUCCESS;
				} else {
					return Constant.RESULT_STR_FAILURE;
				}
			} catch (ParseException e) {
				e.printStackTrace();
				return "error";
			}
		}
		return "error";
	}

	@Override
	public String sendMessageForAll(String orderId, String allState) {
		// TODO Auto-generated method stub
		return null;
	}

	 

}
