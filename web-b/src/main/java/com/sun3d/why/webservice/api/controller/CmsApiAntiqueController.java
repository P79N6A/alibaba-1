/*
@author lijing
@version 1.0 2015年8月4日 下午3:27:46
*/
package com.sun3d.why.webservice.api.controller;

import java.net.URLDecoder;

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
import com.sun3d.why.model.CmsAntique;
import com.sun3d.why.webservice.api.model.CmsApiData;
import com.sun3d.why.webservice.api.model.CmsApiMessage;
import com.sun3d.why.webservice.api.service.CmsApiAntiqueService;
import com.sun3d.why.webservice.api.util.CmsApiStatusConstant;
import com.sun3d.why.webservice.api.util.TimeCounter;
@RequestMapping("/api/antique")
@Controller
public class CmsApiAntiqueController {
private Logger logger = Logger.getLogger(CmsApiActivityRoomController.class);
	
	@Autowired
	private CmsApiAntiqueService cmsApiAntiqueService;
	
	@RequestMapping(value = "/add.do", method = RequestMethod.POST)
	@ResponseBody
	public String add(@RequestBody String json) {
		CmsApiData<CmsAntique> apiData=new CmsApiData<CmsAntique>();
		JSONObject jsonObject = new JSONObject(); //返回json数据
		try {
			TimeCounter.logTime("CmsApiAntiqueController", true, this.getClass());
			JSONObject data=JSON.parseObject(json);//解析数据为json
			String sysNo=data.getString("sysno");
			String token=data.getString("token");
			
			apiData.setSysno(sysNo);
			apiData.setToken(token);
			
			CmsAntique model=data.getObject("data", CmsAntique.class);//把data数据解析成对象
			apiData.setData(model);
			
			CmsApiMessage msg=this.cmsApiAntiqueService.save(apiData);
			
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
		finally{
			TimeCounter.logTime("CmsApiAntiqueController", false, this.getClass());
			
		}
		return jsonObject.toString(); 
		
	}
	
	@RequestMapping(value = "/update.do", method = RequestMethod.POST)
	@ResponseBody
	public String update(@RequestBody String json) {
		CmsApiData<CmsAntique> apiData=new CmsApiData<CmsAntique>();
		JSONObject jsonObject = new JSONObject(); //返回json数据
		try {
			
			JSONObject data=JSON.parseObject(json);//解析数据为json
			String sysNo=data.getString("sysno");
			String token=data.getString("token");
			
			apiData.setSysno(sysNo);
			apiData.setToken(token);
			
			CmsAntique model=data.getObject("data", CmsAntique.class);//把data数据解析成对象
			apiData.setData(model);
			
			CmsApiMessage msg=this.cmsApiAntiqueService.update(apiData);
			
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
	
	@RequestMapping(value = "/delete.do", method = RequestMethod.GET)
	@ResponseBody
	public String delete(HttpServletRequest request, HttpServletResponse response) {
		CmsApiData<CmsAntique> apiData=new CmsApiData<CmsAntique>();
		
		JSONObject jsonObject = new JSONObject(); //返回json数据
		
		String id = request.getParameter("id");
		String token = request.getParameter("token");
		String sysNo = request.getParameter("sysno");

		try {
			//token=URLDecoder.decode(token,"UTF-8");
			apiData.setId(id);
			apiData.setToken(token);
			apiData.setSysno(sysNo);
			CmsApiMessage msg=this.cmsApiAntiqueService.delete(apiData);
			jsonObject.put("status", msg.getStatus());
			jsonObject.put("msg", msg.getText());
			jsonObject.put("code", msg.getCode());
		} catch (Exception e) {
			String msg = "未知错误";
			jsonObject.put("status", false);
			jsonObject.put("msg", msg);
			jsonObject.put("code", CmsApiStatusConstant.ERROR);
			e.printStackTrace();
		}
		return jsonObject.toString();
	}
}

