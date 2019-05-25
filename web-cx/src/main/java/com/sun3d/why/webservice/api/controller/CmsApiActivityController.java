/*
 * @Author lijing
 * @date 2015/07/31
 * @des 增加对场所增加，删除，修改的API,系统统一POST数据到系统中
 * */
package com.sun3d.why.webservice.api.controller;

import java.io.PrintWriter;
import java.net.URLEncoder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.sun3d.why.util.Constant;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONException;
import com.alibaba.fastjson.JSONObject;
import com.sun3d.why.model.CmsActivity;
import com.sun3d.why.model.CmsActivityOrder;
import com.sun3d.why.model.CmsTerminalUser;
import com.sun3d.why.service.CacheConstant;
import com.sun3d.why.service.CacheService;
import com.sun3d.why.service.CmsActivityService;
import com.sun3d.why.webservice.api.model.CmsApiData;
import com.sun3d.why.webservice.api.model.CmsApiMessage;
import com.sun3d.why.webservice.api.service.CmsApiActivityOrderService;
import com.sun3d.why.webservice.api.service.CmsApiActivityService;
import com.sun3d.why.webservice.api.token.TokenHelper;
import com.sun3d.why.webservice.api.util.CmsApiOtherServer;
import com.sun3d.why.webservice.api.util.CmsApiStatusConstant;
import com.sun3d.why.webservice.api.util.TimeCounter;

@RequestMapping("/api/activity")
@Controller
public class CmsApiActivityController {
	private Logger logger = Logger.getLogger(getClass());
	
	@Autowired
	private CmsApiActivityService cmsApiActivityService;
	
	@Autowired
	private CmsApiActivityOrderService cmsApiActivityOrderService;
	
	@Autowired
	private CmsActivityService cmsActivityService;
	
	@Autowired
	private CacheService cacheService;
	 
	@RequestMapping(value = "/add.do", method = RequestMethod.POST)
	@ResponseBody
	public String add(@RequestBody String json) {

		System.out.println("==================json数据=================>"+json);
		System.out.println("==================json数据=================>"+json);
		CmsApiData<CmsActivity> apiData=new CmsApiData<CmsActivity>();
		JSONObject jsonObject = new JSONObject(); //返回json数据
		try {
			TimeCounter.logTime("CmsApiActivityController", true, this.getClass());
			JSONObject data=JSON.parseObject(json);//解析数据为json
			String sysNo=data.getString("sysno");
			String token=data.getString("token");
			
			apiData.setSysno(sysNo);
			apiData.setToken(token);
			
			CmsActivity model=data.getObject("data", CmsActivity.class);//把data数据解析成对象
			apiData.setData(model);
			
			CmsApiMessage msg=this.cmsApiActivityService.save(apiData);
			
			jsonObject.put("status", msg.getStatus());
			jsonObject.put("msg", msg.getText());
			jsonObject.put("code",msg.getCode());
		}catch(JSONException je){
			String msg="数据传输的格式不是JSON格式，请确认系统格式"+je.toString();
			jsonObject.put("status", false);
			jsonObject.put("msg", msg);
			jsonObject.put("code", CmsApiStatusConstant.ERROR);
			logger.error(msg);
		}catch (Exception e) {
			e.printStackTrace();
			String msg="未知错误"+e.toString();
			jsonObject.put("status", false);
			jsonObject.put("msg", msg);
			jsonObject.put("code", CmsApiStatusConstant.ERROR);
			logger.error(msg);
		}
		finally{
			TimeCounter.logTime("CmsApiActivityController", false, this.getClass());
		}
		return jsonObject.toString(); 
		
	}
	
	@RequestMapping(value = "/update.do", method = RequestMethod.POST)
	@ResponseBody
	public String update(@RequestBody String json) {

		System.out.println("==================json数据=================>"+json);
		System.out.println("==================json数据=================>"+json);
		CmsApiData<CmsActivity> apiData=new CmsApiData<CmsActivity>();
		JSONObject jsonObject = new JSONObject(); //返回json数据
		try {
			
			JSONObject data=JSON.parseObject(json);//解析数据为json
			String sysNo=data.getString("sysno");
			String token=data.getString("token");
			
			apiData.setSysno(sysNo);
			apiData.setToken(token);
			
			CmsActivity model=data.getObject("data", CmsActivity.class);//把data数据解析成对象
			apiData.setData(model);
			
			CmsApiMessage msg=this.cmsApiActivityService.update(apiData);
			
			jsonObject.put("status", msg.getStatus());
			jsonObject.put("msg", msg.getText());
			jsonObject.put("code",msg.getCode());
		}catch(JSONException je){
			String msg="数据传输的格式不是JSON格式，请确认系统格式";
			jsonObject.put("status", false);
			jsonObject.put("msg", msg);
			jsonObject.put("code", CmsApiStatusConstant.ERROR);
		}catch (Exception e) {
			e.printStackTrace();
			String msg="未知错误"+e.toString();
			jsonObject.put("status", false);
			jsonObject.put("msg", msg);
			jsonObject.put("code", CmsApiStatusConstant.ERROR);
			logger.error(msg);
		}
		return jsonObject.toString(); 
	}
	
	//子系统活动预定调用接口，系统首先生成本地预定记录，其次根据sysno查询子系统对应的预定地址，然后把userid,username,token，activityId传递给子系统
	@RequestMapping(value = "/frontActivityBook", method = RequestMethod.GET)
	@ResponseBody
	public String frontActivityBook(HttpServletRequest request ,HttpServletResponse response) {
		try {
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out=response.getWriter();
			String activityId=request.getParameter("activityId");
			if(StringUtils.isBlank(activityId)){
				
				out.println("<script>");
				out.println("alert('活动id不能为空')");
				out.println("</script>");
				return null;
				
			}
			else{
				HttpSession session = request.getSession();
				CmsTerminalUser user = (CmsTerminalUser) session.getAttribute("terminalUser");
				if(user==null){
					out.println("<script>");
					out.println("alert('请登录以后再预定')");
					out.println("</script>");
					return null;
				}
				
				//查询活动，判断活动的的外部系统的预定链接地址
				CmsActivity cmsActivity=this.cmsActivityService.queryCmsActivityByActivityId(activityId);
				if(cmsActivity==null){
					out.println("<script>");
					out.println("alert('活动不存在！')");
					out.println("</script>");
					return null;
				}
				String sysNo=cmsActivity.getSysNo();
				String sysId=cmsActivity.getSysId();
				
				StringBuffer url=new StringBuffer();
				if(StringUtils.isNotBlank(sysNo)){
					if("1".equals(sysNo)){
						url.append(CmsApiOtherServer.JIADING_ACTIVITY_ORDER);
					}
					else if("2".equals(sysNo)){
						url.append(CmsApiOtherServer.PUDONG_ACTIVITY_ORDER);
					}
					else if("3".equals(sysNo)){
						url.append(CmsApiOtherServer.JINAN_ACTIVITY_ORDER);
					}
					
					String userName=user.getUserName();
					String token=TokenHelper.generateToken(userName);
					
					url.append("?activityId=").append(activityId);
					url.append("?sysId=").append(sysId);
					url.append("&user=").append(userName);
					url.append("&userId=").append(user.getUserId());
					url.append("&token=").append(URLEncoder.encode(token,"UTF-8"));
					
					String ticketCount = cacheService.getValueByKey(CacheConstant.ACTIVITY_TICKET_COUNT + activityId);
					request.setAttribute("ticketCount", ticketCount);
					response.sendRedirect(url.toString()); 
				}
				
				return null;
			}
			
		
		}catch (Exception e) {
			e.printStackTrace();
			String msg="未知错误"+e.toString();
			logger.error(msg);
		}
		return "redirect:http://www.sohu.com";
	}
	
	
	@RequestMapping(value = "/saveActivityBook.do", method = RequestMethod.POST)
	@ResponseBody
	public String saveActivityBook(@RequestBody String json) {
		CmsApiData<CmsActivityOrder> apiData=new CmsApiData<CmsActivityOrder>();
		JSONObject jsonObject = new JSONObject(); //返回json数据
		try {
			
			JSONObject data=JSON.parseObject(json);//解析数据为json
			String sysNo=data.getString("sysno");
			String token=data.getString("token");
			
			apiData.setSysno(sysNo);
			apiData.setToken(token);
			
			if (data.containsKey("data")) {
				JSONObject jsonData = data.getJSONObject("data");
				if (jsonData.containsKey("seatInfo")) {
					String seatInfo = jsonData.getString("seatInfo");
					apiData.setOtherData(seatInfo);
				}
				if (jsonData.containsKey("bookCount")) {
					String bookCountStr = jsonData.getString("bookCount");
					Integer bookCount=Integer.valueOf(bookCountStr);
					CmsActivityOrder model=data.getObject("data", CmsActivityOrder.class);//把data数据解析成对象
					apiData.setData(model);
					CmsApiMessage msg=this.cmsApiActivityOrderService.save(apiData,bookCount);
					jsonObject.put("status", msg.getStatus());
					jsonObject.put("msg", msg.getText());
					jsonObject.put("code",msg.getCode());
				}
				else{
					String msg="预定数量不能为空";
					jsonObject.put("status", false);
					jsonObject.put("msg", msg);
					jsonObject.put("code", CmsApiStatusConstant.DATA_ERROR);
				}

			}
			
			
			
		}catch(JSONException je){
			String msg="数据传输的格式不是JSON格式，请确认系统格式";
			jsonObject.put("status", false);
			jsonObject.put("msg", msg);
			jsonObject.put("code", CmsApiStatusConstant.ERROR);
		}catch (Exception e) {
			e.printStackTrace();
			String msg="未知错误"+e.toString();
			jsonObject.put("status", false);
			jsonObject.put("msg", msg);
			jsonObject.put("code", CmsApiStatusConstant.ERROR);
			logger.error(msg);
		}
		return jsonObject.toString(); 
	}
	
	//@PathVariable String id,@PathVariable String token,
	@RequestMapping(value = "/delete.do", method = RequestMethod.GET)
	@ResponseBody
	public String delete(HttpServletRequest request ,HttpServletResponse response) {
		CmsApiData<CmsActivity> apiData=new CmsApiData<CmsActivity>();
		
		String id=request.getParameter("id");
		String token=request.getParameter("token");
		String sysNo=request.getParameter("sysno");
		
		JSONObject jsonObject = new JSONObject(); //返回json数据
		try {
			//token=URLDecoder.decode(token,"UTF-8");
			
			apiData.setId(id);
			apiData.setToken(token);
			apiData.setSysno(sysNo);
			CmsApiMessage msg=this.cmsApiActivityService.delete(apiData);
			jsonObject.put("status", msg.getStatus());
			jsonObject.put("msg", msg.getText());
			jsonObject.put("code",msg.getCode());
		} catch (Exception e) {
			String msg="未知错误"+e.toString();
			jsonObject.put("status", false);
			jsonObject.put("msg", msg);
			jsonObject.put("code", CmsApiStatusConstant.ERROR);
			e.printStackTrace();
		}
		
		return jsonObject.toString();
	}


	/**
	 * 将回收站的活动还原至草稿箱
	 */
	@RequestMapping(value = "/returnActivity.do", method = RequestMethod.GET)
	@ResponseBody
	public String  returnActivity(HttpServletRequest request ,HttpServletResponse response) {

		CmsApiData<CmsActivity> apiData=new CmsApiData<CmsActivity>();

		String activityId = request.getParameter("activityId");
		String token=request.getParameter("token");
		String sysNo=request.getParameter("sysno");
		JSONObject jsonObject = new JSONObject(); //返回json数据
		try {
			apiData.setId(activityId);
			apiData.setToken(token);
			apiData.setSysno(sysNo);
			CmsApiMessage msg=this.cmsApiActivityService.returnActivity(apiData);
			jsonObject.put("status", msg.getStatus());
			jsonObject.put("msg", msg.getText());
			jsonObject.put("code",msg.getCode());
		} catch (Exception e) {
			String msg="未知错误"+e.toString();
			jsonObject.put("status", false);
			jsonObject.put("msg", msg);
			jsonObject.put("code", CmsApiStatusConstant.ERROR);
			e.printStackTrace();
		}
		return jsonObject.toString();
	}





}
