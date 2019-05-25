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
import com.sun3d.why.model.CmsActivityRoom;
import com.sun3d.why.webservice.api.model.CmsApiData;
import com.sun3d.why.webservice.api.model.CmsApiMessage;
import com.sun3d.why.webservice.api.service.CmsApiActivityRoomService;
import com.sun3d.why.webservice.api.util.CmsApiStatusConstant;
import com.sun3d.why.webservice.api.util.TimeCounter;

@RequestMapping("/api/activityroom")
@Controller
public class CmsApiActivityRoomController {
	private Logger logger = Logger.getLogger(CmsApiActivityRoomController.class);

	@Autowired
	private CmsApiActivityRoomService cmsApiActivityRoomService;

	@RequestMapping(value = "/add.do", method = RequestMethod.POST)
	@ResponseBody
	public String add(@RequestBody String json) {
		CmsApiData<CmsActivityRoom> apiData = new CmsApiData<CmsActivityRoom>();
		JSONObject jsonObject = new JSONObject(); // 返回json数据
		try {
			TimeCounter.logTime("CmsApiActivityRoomController", true, this.getClass());
			JSONObject data = JSON.parseObject(json);// 解析数据为json
			String sysNo = data.getString("sysno");
			String token = data.getString("token");
			apiData.setSysno(sysNo);
			apiData.setToken(token);
			if (data.containsKey("data")) {
				JSONObject jsonData = data.getJSONObject("data");
				if (jsonData.containsKey("roomDays")) {
					String roomDays = jsonData.getString("roomDays");
					apiData.setOtherData(roomDays);
				}

			}

			CmsActivityRoom model = data.getObject("data", CmsActivityRoom.class);// 把data数据解析成对象
			apiData.setData(model);

			CmsApiMessage msg = this.cmsApiActivityRoomService.save(apiData);

			jsonObject.put("status", msg.getStatus());
			jsonObject.put("msg", msg.getText());
			jsonObject.put("code", msg.getCode());
		} catch (JSONException je) {
			String msg = "数据传输的格式不是JSON格式，请确认系统格式";
			jsonObject.put("status", false);
			jsonObject.put("msg", msg);
			jsonObject.put("code", CmsApiStatusConstant.ERROR);
			logger.error(msg);
		} catch (Exception e) {
			e.printStackTrace();
			String msg = "未知错误";
			jsonObject.put("status", false);
			jsonObject.put("msg", msg);
			jsonObject.put("code", CmsApiStatusConstant.ERROR);
			logger.error(msg);
		}
		finally{
			TimeCounter.logTime("CmsApiActivityRoomController", false, this.getClass());
		}
		return jsonObject.toString();

	}

	@RequestMapping(value = "/update.do", method = RequestMethod.POST)
	@ResponseBody
	public String update(@RequestBody String json) {
		JSONObject jsonObject = new JSONObject(); // 返回json数据

		CmsApiData<CmsActivityRoom> apiData = new CmsApiData<CmsActivityRoom>();
		try {

			JSONObject data = JSON.parseObject(json);// 解析数据为json
			String sysNo = data.getString("sysno");
			String token = data.getString("token");
			apiData.setSysno(sysNo);
			apiData.setToken(token);
			if (data.containsKey("data")) {
				JSONObject jsonData = data.getJSONObject("data");
				if (jsonData.containsKey("roomDays")) {
					String roomDays = jsonData.getString("roomDays");
					apiData.setOtherData(roomDays);
				}

			}

			CmsActivityRoom model = data.getObject("data", CmsActivityRoom.class);// 把data数据解析成对象
			apiData.setData(model);

			CmsApiMessage msg = this.cmsApiActivityRoomService.update(apiData);

			jsonObject.put("status", msg.getStatus());
			jsonObject.put("msg", msg.getText());
			jsonObject.put("code", msg.getCode());
		} catch (JSONException je) {
			String msg = "数据传输的格式不是JSON格式，请确认系统格式";
			jsonObject.put("status", false);
			jsonObject.put("msg", msg);
			jsonObject.put("code", CmsApiStatusConstant.ERROR);
			logger.error(msg);
		} catch (Exception e) {
			e.printStackTrace();
			String msg = "未知错误";
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
		CmsApiData<CmsActivityRoom> apiData = new CmsApiData<CmsActivityRoom>();

		String id = request.getParameter("id");
		String token = request.getParameter("token");
		String sysNo = request.getParameter("sysno");

		JSONObject jsonObject = new JSONObject(); // 返回json数据
		try {
			//token=URLDecoder.decode(token,"UTF-8");
			apiData.setId(id);
			apiData.setToken(token);
			apiData.setSysno(sysNo);
			CmsApiMessage msg=this.cmsApiActivityRoomService.delete(apiData);
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
