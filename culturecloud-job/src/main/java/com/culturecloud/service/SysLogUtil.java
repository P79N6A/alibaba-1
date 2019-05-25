package com.culturecloud.service;

import java.io.StringReader;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

import com.culturecloud.bean.SystemLogVO;
import com.culturecloud.util.PpsConfig;
import com.sdicons.json.mapper.JSONMapper;
import com.sdicons.json.model.JSONValue;
import com.sdicons.json.parser.JSONParser;

public class SysLogUtil {

	private static String readPath=PpsConfig.getString("read.path");
	
	
	public static List<SystemLogVO> SysLogToSysLogList(String startDate, int num) {

		try {

			String[] dates = startDate.split("-");
			String content;
			if (num >= 0) {
				content = new String(Files.readAllBytes(Paths.get(readPath + "/" + dates[0] + "/" + dates[1] + "/"
						+ dates[1] + "-" + dates[2] + "-" + num + ".log")), "UTF-8");
			} else {
				content = new String(
						Files.readAllBytes(Paths.get(
								readPath + "/" + dates[0] + "/" + dates[1] + "/" + dates[1] + "-" + dates[2] + ".log")),
						"UTF-8");
			}

			String[] aa = content.split("\\|\\*\\|");
			List<SystemLogVO> list = new ArrayList<SystemLogVO>();

			for (int i = 0; i < aa.length;i++) {
				//System.out.println("i=="+i);
				String result=aa[i].toString();
				//if(aa[i].toString().indexOf("recommendActivity")!=-1)
				//{
//					System.out.println(aa[i].toString());
//					System.out.println("response="+result.indexOf("response"));
//					System.out.println("systemTemplate="+result.indexOf("systemTemplate"));
//					result=result.substring(0, Integer.valueOf(result.indexOf("response")+13))+result.substring(46346, result.length());
					//continue;//activityDetail
				//}
				if(aa[i].toString().indexOf("\"methodName\" : \"activityDetail\"")!=-1)
				{
					//System.out.println(aa[i].toString());
					//System.out.println("response="+result.indexOf("response"));
					//System.out.println("systemTemplate="+result.indexOf("systemTemplate"));
					result=result.substring(0, Integer.valueOf(result.indexOf("response")+13))+result.substring(Integer.valueOf(result.indexOf("systemTemplate")-7), result.length());
					//System.out.println("result====="+result);
				}
				JSONParser parser1 = new JSONParser(new StringReader(result));
				JSONValue jsonValue1 = parser1.nextValue();
				SystemLogVO sch;
				sch = (SystemLogVO) JSONMapper.toJava(jsonValue1, SystemLogVO.class);
				list.add(sch);
				
			}
			return list;
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		

		return null;

	}
	
	
	

	
}
