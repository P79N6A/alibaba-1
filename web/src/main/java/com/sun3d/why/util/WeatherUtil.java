package com.sun3d.why.util;

import java.io.InputStream;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.io.IOUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

@Controller
@RequestMapping("weatherUtil")
public class WeatherUtil {

	private static Map<String, Object> weatherMap = new HashMap<>();

	private static String oldDate = "";

	@RequestMapping("getWeatherData")
	@ResponseBody
	public Map<String, Object> getWeather(String city) {
		Map<String, Object> resultMap = new HashMap<>();
		{
			try {
				SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
				String nowDate = formatter.format(new Date());
				if (oldDate == null || !nowDate.equals(oldDate)) {
					// String url =
					// "http://api.map.baidu.com/telematics/v3/weather?location=%E4%B8%B4%E6%B1%BE&output=json&ak=GLoy5WmNrkT3Z2sDyNgrd7yiF18OtWEj";
					oldDate = nowDate;
					city = URLEncoder.encode(city, "utf-8");
					String url = "https://www.sojson.com/open/api/weather/json.shtml?city=" + city;

					URL url2 = new URL(url);
					URLConnection openConnection = url2.openConnection();
					InputStream input = openConnection.getInputStream();
					String reString = IOUtils.toString(input, "utf-8");
					// res = Tools.uncompress(res);
					// System.out.println(res);
					// String res = CallUtils.callUrl3(url, null);

					JSONObject jobj = JSONObject.parseObject(reString);
					JSONObject weatherobj = (JSONObject) jobj.get("data");
					JSONObject weatherjson = (JSONObject) ((JSONArray) weatherobj.get("forecast")).get(0);
					String weather = (String) weatherjson.get("type");
					String temperature = ((String) weatherjson.get("low")).substring(3) + "~"
							+ ((String) weatherjson.get("high")).substring(3);
					// String uptemp= "";
					// String img = (String) weatherjson.get("dayPictureUrl");
					// String img2 = (String)
					// weatherjson.get("nightPictureUrl");
					weatherMap.put("weather", weather);
					weatherMap.put("temperature", temperature);
					weatherMap.put("ctime", nowDate);

					resultMap.put("status", 200);
					resultMap.put("data", weatherMap);
				}

			} catch (Exception e) {
				resultMap.put("status", 500);
				return resultMap;
			}
			resultMap.put("status", 200);
			resultMap.put("data", weatherMap);
			return resultMap;
		}
	}
}
