package com.sun3d.why.util;
import com.sun3d.why.model.CmsActivityOrder;
import com.sun3d.why.model.extmodel.BasePath;
import com.sun3d.why.model.extmodel.StaticServer;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
/**
 * 取票机活动座位模板
 */
public class ActivitySeatTemplate {
    public static String toActivitySeatTemplate( CmsActivityOrder cmsActivityOrder,String seat,int index,StaticServer staticServer,BasePath basePath) throws Exception {
        String[] seats =seat.split(",");
        StringBuffer sb = new StringBuffer();
        
        Date date=new Date();
        
    	DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        
        String forDate=df.format(date);
        
        for (int i = 0; i < seats.length; i++) {
        	
        	sb.append("<div style='width: 300px;padding-bottom:30px;'>"+
        			"<img src='/why/STATIC/image/logo-print.jpg' width='270' />"+
        	"<div style='height: 25px;'>"+
        	"<div style='width: 8px;height: 20px;background-color: #000;float: left;'></div>"+
			"<div style='float: left;margin-left: 10px;width: 220px;'>"+
				"<p style='vertical-align: top;font-size: 18px;margin:0;line-height:22px'>"+cmsActivityOrder.getActivityName()+"</p>"+
			"</div>"+
			"<div style='clear: both;'></div>"+
			"</div>"+
			"<div style='font-size: 12px;padding-bottom:30px;'>");
        	
        	sb.append("<ul style='list-style: none;margin:0 0 0 20px;padding:0;'>"+
			"<li style='margin:16px 0 0 0;'>"+
				"<label style='float: left;margin:0;'>时间：</label>"+
				"<p style='float: left;margin:0;width:220px;'>"+cmsActivityOrder.getEventDateTime()+"</p>"+
				"<div style='clear: both;'></div>"+
			"</li> "+
			"<li style='margin:18px 0 0 0;'>"+
				"<label style='float: left;margin:0;'>地点：</label>"+
				"<p style='float: left;width: 160px;margin:0;'>"+cmsActivityOrder.getActivityAddress()+"</p>"+
				"<div style='clear: both;'></div>"+
			"</li>");
        	
        	 StringBuffer seatSB = new StringBuffer();
        	 
        	 seatSB.append(	"<li  style='margin:22px 0 0 0;'>"+
				"<label style='float: left;margin:0;'>票务：</label>"+
				"<p style='float: left;margin: 0 7px 0 0;font-size:14px;'>");
        	
        	 //在线选座 截取座位重新编辑成几排几座
            if (!seats[i].equals("") && org.apache.commons.lang3.StringUtils.isNotBlank(seats[i]) && seats[i].contains("_")) {
                String[] activitySeat = seats[i].split("_");
                seatSB.append(activitySeat[0] + "排");
                seatSB.append(activitySeat[1] + "座");
                seatSB.append(",");
            }
            //自由入座 编辑座位信息
            else {
                seatSB.append("自由入座("+(index+1)+")");
                seatSB.append(",");
            }
            
            sb.append(seatSB.substring(0, seatSB.length() - 1)+"</p>"+
    				"<div style='clear: both;'></div>"+
        			"</li>");
            
            String orderValidateCode=cmsActivityOrder.getOrderValidateCode();
            
            String formatOrderValidateCode="";
            
            int length=orderValidateCode.length();
            
            for (int j = 0; j < length; j++) {
				
              	if(j%4==0){
              		
              		if(j+4>length-1)
              			formatOrderValidateCode+=orderValidateCode.substring(j);
              		else
              		formatOrderValidateCode+=orderValidateCode.substring(j, j+4)+" ";
    			}
        	}	
            
			sb.append("<li style='margin:20px 0 0 0;'>"+
						"<label style='float: left;'>取票码：</label>"+
						"<p style='float: left;width: 150px;'>"+formatOrderValidateCode+"</p>"+
						"<div style='clear: both;'></div>"+
					"</li>"+
					
					"<li style='margin:10px 0 0 0;'>"+
						"<img src='/why/STATIC/image/print-qr-code.jpg' style='float: left;width: 100px;' />"+
						"<div style='float: left;vertical-align: bottom;'>"+
							"<p style='line-height: 16px;font-size: 12px;margin: 65px 0 0 0;'>【扫一扫】</p>"+
							"<p style='line-height: 16px;font-size: 12px;margin:0;'>更多精彩活动免费预订</p>"+
						"</div>"+
						"<div style='clear: both;'></div>"+
					"</li>"+
					"<li style='border-top:2px dashed #262626;margin:22px 0 0 0;height:20px;'>"+
						"<div style='float:right;width:130px;'>【自行撕下无效】</div>"+
						"<div style='clear:both;'></div>"+
					"</li>"+
					"<li style='margin:20px 0 0 0;'>"+
						"<label style='float: left;'>取票码：</label>"+
						"<p style='float: left;width: 150px;'>"+formatOrderValidateCode+"</p>"+
						"<div style='clear: both;'></div>"+
					"</li>"+
					"<li style='margin:20px 0 0 0;'>"+
						"<label style='float: left;'>取票时间：</label>"+
						"<p style='float: left;width: 150px;'>"+forDate+"</p>"+
						"<div style='clear: both;'></div>"+
					"</li>"+
				"</ul>"+
			"</div>"+
		"</div>");
        	
        }
           return  JSONResponse.toAppResultFormat(0,sb.toString());
    }
}
