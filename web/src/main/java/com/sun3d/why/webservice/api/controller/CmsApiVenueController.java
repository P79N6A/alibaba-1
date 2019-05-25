/*
 * @Author lijing
 * @date 2015/07/31
 * @des 增加对场所增加，删除，修改的API,系统统一POST数据到系统中
 * */
package com.sun3d.why.webservice.api.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import com.sun3d.why.model.CmsVenue;
import com.sun3d.why.webservice.api.model.CmsApiData;
import com.sun3d.why.webservice.api.model.CmsApiMessage;
import com.sun3d.why.webservice.api.service.CmsApiVenueService;
import com.sun3d.why.webservice.api.util.CmsApiStatusConstant;
import com.sun3d.why.webservice.api.util.TimeCounter;

@RequestMapping("/api/venue")
@Controller
public class CmsApiVenueController {
	private Logger logger = Logger.getLogger(CmsApiVenueController.class);
	@Autowired
	private CmsApiVenueService cmsVenueApiService;
	
	@RequestMapping(value = "/add.do", method = RequestMethod.POST)
	@ResponseBody
	public String add(@RequestBody String json) {

		
		TimeCounter.logTime("CmsApiVenueController", true, this.getClass());
		
		CmsApiData<CmsVenue> apiData=new CmsApiData<CmsVenue>();
		JSONObject jsonObject = new JSONObject(); //返回json数据
		try {
			
			//json=URLDecoder.decode(json,"UTF-8");
			logger.info(json);
			JSONObject data=JSON.parseObject(json);//解析数据为json
			String sysNo=data.getString("sysno");
			String token=data.getString("token");
			apiData.setSysno(sysNo);
			apiData.setToken(token);
			
			
			CmsVenue model=data.getObject("data", CmsVenue.class);//把data数据解析成对象
			logger.info("xxx："+model);
			logger.info("_________>>>>>>>_______"+model.getVenueVoiceUrl()+"===========================>>>");
			//model.setVenueVoiceUrl("admin/45/201511/Audio/Audio2370f4ec81d140dba27551c4c6d8f07b.mp3");

			apiData.setData(model);
			
			CmsApiMessage msg=this.cmsVenueApiService.save(apiData);
			
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
			String msg="未知错误";
			jsonObject.put("status", false);
			jsonObject.put("msg", msg);
			jsonObject.put("code", CmsApiStatusConstant.ERROR);
			logger.error(msg);
		}
		TimeCounter.logTime("CmsApiVenueController", false, this.getClass());
		return jsonObject.toString(); 
		
	}
	
	@RequestMapping(value = "/update.do", method = RequestMethod.POST)
	@ResponseBody
	public String update(@RequestBody String json) {
		CmsApiData<CmsVenue> apiData=new CmsApiData<CmsVenue>();
		JSONObject jsonObject = new JSONObject(); //返回json数据
		try {
			
			JSONObject data=JSON.parseObject(json);//解析数据为json
			String sysNo=data.getString("sysno");
			String token=data.getString("token");
			
			apiData.setSysno(sysNo);
			apiData.setToken(token);
			
			CmsVenue model=data.getObject("data", CmsVenue.class);//把data数据解析成对象
			apiData.setData(model);
			
			CmsApiMessage msg=this.cmsVenueApiService.update(apiData);
			
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
			String msg="未知错误";
			jsonObject.put("status", false);
			jsonObject.put("msg", msg);
			jsonObject.put("code", CmsApiStatusConstant.ERROR);
			logger.error(msg);
		}
		return jsonObject.toString(); 
		
	}
	
	@RequestMapping(value = "/delete.do", method = RequestMethod.GET)
	@ResponseBody
	public String delete(HttpServletRequest request ,HttpServletResponse response) {
		CmsApiData<CmsVenue> apiData=new CmsApiData<CmsVenue>();
		JSONObject jsonObject = new JSONObject(); //返回json数据
		try {
			String id=request.getParameter("id");
			String token=request.getParameter("token");
			String sysNo=request.getParameter("sysno");
			
			//token=URLDecoder.decode(token,"UTF-8");
			apiData.setId(id);
			apiData.setToken(token);
			apiData.setSysno(sysNo);
			
			CmsApiMessage msg=this.cmsVenueApiService.delete(apiData);
			
			jsonObject.put("status", msg.getStatus());
			jsonObject.put("msg", msg.getText());
			jsonObject.put("code",msg.getCode());
		
		}catch (Exception e) {
			e.printStackTrace();
			String msg="未知错误:"+e.toString();
			jsonObject.put("status", false);
			jsonObject.put("msg", msg);
			jsonObject.put("code", CmsApiStatusConstant.ERROR);
			logger.error(msg);
		}
		return jsonObject.toString(); 
		
	}


	@RequestMapping(value = "/returnVenue.do", method = RequestMethod.GET)
	@ResponseBody
	public String returnVenue(HttpServletRequest request ,HttpServletResponse response) {
		CmsApiData<CmsVenue> apiData=new CmsApiData<CmsVenue>();
		JSONObject jsonObject = new JSONObject(); //返回json数据
		try {
			String id=request.getParameter("id");
			String token=request.getParameter("token");
			String sysNo=request.getParameter("sysno");

			apiData.setId(id);
			apiData.setToken(token);
			apiData.setSysno(sysNo);

			CmsApiMessage msg=this.cmsVenueApiService.returnVenue(apiData);

			jsonObject.put("status", msg.getStatus());
			jsonObject.put("msg", msg.getText());
			jsonObject.put("code",msg.getCode());

		}catch (Exception e) {
			e.printStackTrace();
			String msg="未知错误:"+e.toString();
			jsonObject.put("status", false);
			jsonObject.put("msg", msg);
			jsonObject.put("code", CmsApiStatusConstant.ERROR);
			logger.error(msg);
		}
		return jsonObject.toString();

	}
}
