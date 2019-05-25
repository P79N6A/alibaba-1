/*
@author lijing
@version 1.0 2015年8月3日 下午6:37:43
*/
package com.sun3d.why.webservice.api.util;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.alibaba.fastjson.JSONObject;
import org.apache.commons.lang3.StringUtils;
import com.sun3d.why.webservice.api.model.CmsApiMessage;
import com.sun3d.why.webservice.api.token.TokenHelper;

public class CmsApiUtil {
	//校验系统数据，校验系统编号，token是否有效
	public static CmsApiMessage checkToken(String sysNo,String token){

		System.out.println("token-------------------->>>>>>>----------------"+token);
		CmsApiMessage msg=new CmsApiMessage();
		if(StringUtils.isBlank(sysNo)){
			msg.setStatus(false);
			msg.setCode(CmsApiStatusConstant.SYSNO_ERROR);
			msg.setText("系统编号不能为空");
			return msg;
		}
		
		if(StringUtils.isBlank(token)){
			msg.setStatus(false);
			msg.setCode(CmsApiStatusConstant.TOKEN_ERROR);
			msg.setText("token为空");
			return msg;
		}
		
		String userName=TokenHelper.getUserName(token);
		if(StringUtils.isBlank(userName)){
			msg.setStatus(false);
			msg.setCode(CmsApiStatusConstant.USER_ERROR);
			msg.setText("用户姓名不能为空");
			return msg;
		}
		
		boolean bool=TokenHelper.valid(token);
		if(bool==false){
			msg.setStatus(false);
			msg.setCode(CmsApiStatusConstant.TOKEN_ERROR);
			msg.setText("token验证不成功");
			return msg;
		}
		msg.setStatus(true);
		msg.setCode(CmsApiStatusConstant.SUCCESS);
		msg.setText("token成功!");
		return msg;
	}
	
	public static boolean checkInteger(){
		return false;
	}
	
	public static boolean checkEnable(JSONObject json,String key){
		if(json.containsKey(key)){
			Object obj=json.getString(key);
			if(obj!=null){
				if(obj instanceof Integer){
					Integer value=(Integer) obj;
					if(value==1 || value==2) return true;
				}
				else if(obj instanceof String){
					String value=obj.toString();
					if("1".equals(value) || "2".equals(value)) return true;
				}
				
			}
		}
		return false;
	}
	
	public static String getTags(String tags){
		StringBuffer sbInfo=new StringBuffer();
		sbInfo.append(tags);
		if(StringUtils.isNotBlank(tags)){
			int charLen=tags.length()-1;
			if(tags.charAt(charLen)!=','){
				sbInfo.append(",");
			}
			
		}
		return sbInfo.toString();
	}
	
	public static boolean isDate(String dateTime){
		 DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		 try {
			Date dt=df.parse(dateTime);
			return true;
		} catch (ParseException e) {
			e.printStackTrace();
		}
		 
		return false;
	}
	
	public static String checkRoomDays(String roomDays){
		if(StringUtils.isNotBlank(roomDays)){
			  String[] allRoomDayArr = roomDays.split("\\*");
			  if(allRoomDayArr.length!=7){
				  return "*字符隔开的不是七天";
			  }
			  /*for (int i = 0; i < allRoomDayArr.length; i++) {
				  String allTimePeriodStr = allRoomDayArr[i];
				  if(StringUtils.isBlank(allTimePeriodStr)){
					  return i+" 开馆时间为空";
				  }
				  
				  String[] allTimePeriodArr =  StringUtils.split(allTimePeriodStr,",");
				  if(allTimePeriodArr.length<5){
					  return i+" 开馆时间段落小于5";
				  }
			  }*/
               
		}
		return "";
	}
	
	public static String getRoomDays(String roomDays){
		StringBuffer bufRoomDays=new StringBuffer();
		if(StringUtils.isNotBlank(roomDays)){
			  String[] allRoomDayArr = roomDays.split("\\*");
			  
			  for (int i = 0; i < allRoomDayArr.length; i++) {
				  String allTimePeriodStr = allRoomDayArr[i];
				  //第二行自动增加*
				  if(i>0){
					  bufRoomDays.append("*");
				  }
				  if(StringUtils.isBlank(allTimePeriodStr)){//时间段为空则增加
					  bufRoomDays.append(getRoomWeekDays());
				  }
				  else{
					  String[] allTimePeriodArr = allTimePeriodStr.split(",");
					  int timePerLen=allTimePeriodArr.length;
					  
					  //判断开馆时间是否小于5条，如果小于5条，则用OFF取代
					  if(timePerLen<5){
						  bufRoomDays.append(allTimePeriodStr);
						  for(int z=timePerLen;z<5;z++){
							  bufRoomDays.append(",OFF");
						  }
					  }
					  else{
						  bufRoomDays.append(allTimePeriodStr);
					  }
				  }
				  
			  }
		}
		return bufRoomDays.toString();
	}
	
	public static String getRoomWeekDays(){
		return "OFF,OFF,OFF,OFF,OFF";
	}
	
}

