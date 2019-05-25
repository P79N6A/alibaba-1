package com.sun3d.why.controller.wechat;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.culturecloud.model.request.activity.ActivityOrderVO;
import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.CmsSuperOrderUser;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.model.extmodel.StaticServer;
import com.sun3d.why.service.CmsActivityService;
import com.sun3d.why.service.CmsSuperOrderActivityService;
import com.sun3d.why.service.CmsSuperOrderUserService;
import com.sun3d.why.util.CallUtils;
import com.sun3d.why.util.Constant;
import com.sun3d.why.util.JSONResponse;
import com.sun3d.why.util.PaginationApp;
import com.sun3d.why.util.SmsUtil;
import com.sun3d.why.util.UUIDUtils;
import com.sun3d.why.webservice.api.util.HttpResponseText;
import com.sun3d.why.webservice.service.ActivityAppService;

@RequestMapping("/wechatSuperOrder")
@Controller
public class WechatSuperOrderController {
    private Logger logger = LoggerFactory.getLogger(WechatSuperOrderController.class);

    @Autowired
    private HttpSession session;
    @Autowired
    private StaticServer staticServer;
    @Autowired
    private CmsActivityService cmsActivityService;
    @Autowired
    private ActivityAppService activityAppService;
    @Autowired
    private CmsSuperOrderUserService cmsSuperOrderUserService;
    @Autowired
    private CmsSuperOrderActivityService cmsSuperOrderActivityService;
    @Autowired
	private SmsUtil SmsUtil;
    /**
     * 超级账号登录页面
     * @param type
     * @param request
     * @return
     */
    @RequestMapping(value = "/login")
    public String login(HttpServletRequest request,String type) {
        request.setAttribute("type", type);
        return "wechat/superOrder/login";
    }
    
    /**
	 * 发送验证码
	 * @param userMobileNo
	 * @throws IOException
	 */
	@RequestMapping("/sendCode")
	public String sendCode(HttpServletResponse response, String userMobileNo, Integer type) throws IOException {
		String json = "";
		try {
			if(type == 1){	//登录
				CmsSuperOrderUser cmsSuperOrderUser = cmsSuperOrderUserService.querySuperOrderUserByUserMobileNo(userMobileNo);
				if(cmsSuperOrderUser == null) {
					json = JSONResponse.toAppResultFormat(500, "手机号错误");
				}else {
					json = cmsSuperOrderUserService.sendCode(cmsSuperOrderUser,userMobileNo);
				}
			}else if(type == 2){	//预订
				String code = SmsUtil.getValidateCode();
		    	
		    	Map<String,Object> smsParams = new HashMap<>();
		        smsParams.put("code",code);
		        smsParams.put("product",Constant.PRODUCT);
		        SmsUtil.sendActivityCode(userMobileNo, smsParams);
		        
		        json = JSONResponse.toAppResultFormat(200, code);
			}
		} catch (Exception e) {
			json = JSONResponse.toAppResultFormat(500, e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().print(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
	}
	
	/**
     * 超级账号登录
     * @param userMobileNo
	 * @throws IOException 
     */
    @RequestMapping(value = "/superOrderUserLogin")
    public String superOrderUserLogin(HttpServletResponse response, String userMobileNo,String loginCode) throws IOException {
    	String json = "";
		try {
			CmsSuperOrderUser cmsSuperOrderUser = cmsSuperOrderUserService.querySuperOrderUserByUserMobileNo(userMobileNo);
			if(cmsSuperOrderUser == null) {
				json = JSONResponse.toAppResultFormat(500, "手机号错误");
			}else {
				if(cmsSuperOrderUser.getLoginCode().equals(loginCode)){
					session.setAttribute("superOrderUser", cmsSuperOrderUser);
					json = JSONResponse.toAppResultFormat(200, "登陆成功");
				}else{
					json = JSONResponse.toAppResultFormat(500, "验证码错误");
				}
			}
		} catch (Exception e) {
			json = JSONResponse.toAppResultFormat(500, e.getMessage());
		}
		response.setContentType("text/html;charset=UTF-8");
		response.getWriter().print(json);
		response.getWriter().flush();
		response.getWriter().close();
		return null;
    }
    
    /**
     * 超级账号活动列表页
     * @param type
     * @param request
     * @return
     */
    @RequestMapping(value = "/preActivityList")
    public String preActivityList(HttpServletRequest request) {
        return "wechat/superOrder/activityList";
    }
    
    /**
     * 超级账号获取活动列表
     * @param pageApp
     * @param searchKey
     * @return
     * @throws IOException 
     */
    @RequestMapping(value = "/getActivityList")
    public String getActivityList(HttpServletRequest request,HttpServletResponse response,PaginationApp pageApp, String searchKey, String userId) throws IOException {
    	String json = "";
        try {
            json = cmsSuperOrderActivityService.getActivityList(pageApp,searchKey,userId);
        } catch (Exception e) {
			json = JSONResponse.toAppResultFormat(500, e.getMessage());
		}
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
    /**
     * 超级账号订单列表页
     * @param type
     * @param request
     * @return
     */
    @RequestMapping(value = "/preActivityOrderList")
    public String preActivityOrderList(HttpServletRequest request) {
        return "wechat/superOrder/activityOrderList";
    }
    
    /**
     * 超级账号获取活动订单列表
     * @param pageApp
     * @param searchKey
     * @return
     * @throws IOException 
     */
    @RequestMapping(value = "/getActivityOrderList")
    public String getActivityOrderList(HttpServletRequest request,HttpServletResponse response,PaginationApp pageApp, String userId) throws IOException {
    	String json = "";
        try {
            json = cmsSuperOrderActivityService.getActivityOrderList(pageApp,userId);
        } catch (Exception e) {
			json = JSONResponse.toAppResultFormat(500, e.getMessage());
		}
        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(json);
        response.getWriter().flush();
        response.getWriter().close();
        return null;
    }
    
    /**
     * 超级账号活动预定
     * @param activityId
     * @param request
     * @return
     */
    @RequestMapping(value = "/preActivityOrder")
    public ModelAndView preActivityOrder(String activityId, HttpServletRequest request) {
        ModelAndView model = new ModelAndView();
        request.setAttribute("activityId", activityId);
        request.setAttribute("currentDate", new Date().getTime());
        model.setViewName("wechat/superOrder/activityOrder");
        return model;
    }

    /**
     * 超级账号选座界面
     * @return
     */
    @RequestMapping(value = "/wcOrderSeat")
    public String wcOrderSeat(String activityId, String activityEventimes, String userName, String userIdCard, String userPhone,String count, HttpServletRequest request) {
        request.setAttribute("activityId", activityId);
        request.setAttribute("activityEventimes", activityEventimes);
        request.setAttribute("userName", userName);
        request.setAttribute("userIdCard", userIdCard);
        request.setAttribute("userPhone", userPhone);
        request.setAttribute("count", count);
        return "wechat/superOrder/activityOrderSeat";
    }
    
    /**
     * 超级账号活动预定(选完座位)
     * @return
     */
    @RequestMapping(value = "/finishSeat")
    public String finishSeat(String activityId, String activityEventimes, String[] seatId, String[] seatValue, String userName, String userIdCard, String userPhone, HttpServletRequest request) {
        request.setAttribute("activityId", activityId);
        request.setAttribute("activityEventimes", activityEventimes);
        String seats = "";
        if (seatId != null) {
            for (int i = 0; i < seatId.length; i++) {
                if ("".equals(seats)) {
                    seats += seatId[i];
                    continue;
                }
                seats += "," + seatId[i];
            }
        }
        request.setAttribute("seats", seats);
        String seatValues = "";
        if (seatValue != null) {
            for (int i = 0; i < seatValue.length; i++) {
                if ("".equals(seatValues)) {
                    seatValues += seatValue[i];
                    continue;
                }
                seatValues += "," + seatValue[i];
            }
        }
        request.setAttribute("seatValues", seatValues);
        request.setAttribute("userName", userName);
        request.setAttribute("userIdCard", userIdCard);
        request.setAttribute("userPhone", userPhone);
        request.setAttribute("currentDate", new Date().getTime());
        return "wechat/superOrder/activityOrder";
    }
    
    /**
     * 超级账号进入提交订单
     * @param activityId        活动id
     * @param userId            用户id
     * @param bookCount         订购张数
     * @param orderMobileNum    预定电话
     * @param orderName         姓名
     * @param orderIdentityCard 身份证
     * @param orderPrice        票价
     * @param activityEventIds  活动场次id
     * @param activityEventimes 活动具体时间
     * @param costTotalCredit   参与此活动消耗的总积分数
     * @return 14101 活动或用户id缺失
     * @throws Exception
     */
    @RequestMapping(value = "/wcActivityOrder")
    public String wcActivityOrder(HttpServletRequest request, HttpServletResponse response, String activityId, String userId, String activityEventIds,
                                  String bookCount, final String orderMobileNum, String orderPrice, String activityEventimes, String orderName, String orderIdentityCard, String costTotalCredit) throws Exception {
        String seatId = request.getParameter("seatIds");
        String seatValues = request.getParameter("seatValues");
        ActivityOrderVO vo = new ActivityOrderVO();
        vo.setActivityId(activityId);
        vo.setEventId(activityEventIds);
        vo.setUserId(userId);
        vo.setOrderPrice(BigDecimal.valueOf(Integer.valueOf(orderPrice)));
        vo.setOrderName(orderName);
        vo.setOrderIdentityCard(orderIdentityCard);
        vo.setOrderPhoneNo(orderMobileNum);
        vo.setCostTotalCredit(costTotalCredit);
        vo.setOrderSummary(seatValues);
        vo.setSeatIds(seatId);
        vo.setOrderVotes(Integer.valueOf(bookCount));
        vo.setActivityOrderId(UUIDUtils.createUUId());
        
        //积分验证
        final CmsActivity cmsActivity=cmsActivityService.queryFrontActivityByActivityId(activityId);
        HttpResponseText res = CallUtils.callUrlHttpPost(staticServer.getPlatformDataUrl() + "superOrder/add", vo);
		if (res.getHttpCode() == 500) {
			JSONObject jsonObject = new JSONObject();
            jsonObject.put("status", 500);
            jsonObject.put("data", "超时");
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().print(jsonObject.toString());
            response.getWriter().flush();
            response.getWriter().close();
        } else {
        	JSONObject jsonObject = JSON.parseObject(res.getData());
        	
            response.getWriter().write(res.getData());
            response.getWriter().flush();
            response.getWriter().close();
            if(jsonObject.get("data")!=null){
                String result = JSON.parseObject(jsonObject.get("data").toString(), String.class);
                if (result.length() == 10) {
					final Map<String,Object> map = new HashMap<String,Object>();
					String activityName = "";
					String time = "";
					if (cmsActivity.getSingleEvent() == 1) {
						String[] eventDateTime = activityEventimes.split(" ");
						String[] strdata = cmsActivity.getActivityStartTime().split("-");
						String[] enddata = cmsActivity.getActivityEndTime().split("-");
						if (cmsActivity.getActivityStartTime().equals(cmsActivity.getActivityEndTime())) {
							activityName = strdata[1] + "月" + strdata[2] + "日" + cmsActivity.getActivityName();
							time = cmsActivity.getActivityStartTime() + " " + eventDateTime[1];
						} else {
							activityName = strdata[1] + "月" + strdata[2] + "日——" + enddata[1] + "月"
									+ enddata[2] + "日" + cmsActivity.getActivityName();
							time = cmsActivity.getActivityStartTime() + "——"
									+ cmsActivity.getActivityEndTime() + " " + eventDateTime[1];
						}
					}else{
						String[] eventDateTime = activityEventimes.split(" ");
						String[] data = eventDateTime[0].split("-");
						activityName = data[1] + "月" + data[2] + "日" + cmsActivity.getActivityName();
						time = activityEventimes;
					}
					
					if (cmsActivity.getActivitySmsType() == null || cmsActivity.getActivitySmsType() == 0) {	//默认、取票码入场
						map.put("userName", orderName);
						map.put("activityName", activityName);
						map.put("time", time);
						map.put("ticketCount", bookCount);
						map.put("ticketNum", "(" + result + ")");
						map.put("ticketCode", result);
					}else if(cmsActivity.getActivitySmsType() == 1 || cmsActivity.getActivitySmsType() == 2){	//纸质票入场、入场凭证入场
						map.put("username", orderName);
						map.put("activityName", activityName);
						map.put("time", time);
						map.put("num", bookCount);
						map.put("yzcode", result);
					}
						
					Runnable runnable = new Runnable() {
						@Override
						public void run() {
							if (cmsActivity.getActivitySmsType() == null || cmsActivity.getActivitySmsType() == 0) {
								SmsUtil.sendActivityOrderSms(orderMobileNum, map);
							}else if(cmsActivity.getActivitySmsType() == 1){
								SmsUtil.sendActivityOrderSms2(orderMobileNum, map);
							}else if(cmsActivity.getActivitySmsType() == 2){
								SmsUtil.sendActivityOrderSms3(orderMobileNum, map);
							}
						}
					};
					Thread thread = new Thread(runnable);
					thread.start();
				}
            }
        }
        return null;
    }
}
