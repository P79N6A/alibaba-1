package com.culturecloud.util;

import java.io.StringReader;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

import com.culturecloud.bean.SystemLogVO;
import com.sdicons.json.mapper.JSONMapper;
import com.sdicons.json.model.JSONValue;
import com.sdicons.json.parser.JSONParser;


public class ReadLargeTextWithNIO {


	
	public static void main(String[] args) throws Exception {
		String content = new String(Files.readAllBytes(Paths.get("d:\\07-19.log")), "UTF-8");
		String[] aa=content.split("\\|\\|");
		List<SystemLogVO> list=new ArrayList<SystemLogVO>();
		int num = 0;
		for(int i=0;i<aa.length;i++)
		{
			if(aa[i].toString().indexOf("activityId")!=-1)
			{
				if(aa[i].toString().indexOf("28d6081645c3411d8343087a3a3bd67c")!=-1)
				{
					num++;
				}
			}
			
			
			JSONParser parser1 = new JSONParser(new StringReader(aa[i].toString()));    
            JSONValue jsonValue1 = parser1.nextValue();  
            SystemLogVO sch = (SystemLogVO) JSONMapper.toJava(jsonValue1, SystemLogVO.class);
            list.add(sch);
		}
		System.out.println(list.size());
		System.out.println(list.get(123).getClassFullName());
		System.out.println("num==="+num);
	}
	
	
}
