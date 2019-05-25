package com.sun3d.why.util;
import com.sun3d.why.model.CmsActivityOrder;
import com.sun3d.why.model.extmodel.BasePath;
import com.sun3d.why.model.extmodel.StaticServer;
import java.text.SimpleDateFormat;
import java.util.Date;
/**
 * 取票机活动座位模板
 */
public class ActivitySeatTemplate {
    public static String toActivitySeatTemplate( CmsActivityOrder cmsActivityOrder,String seat,StaticServer staticServer,BasePath basePath) throws Exception {
        String[] seats =seat.split(",");
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < seats.length; i++) {
             sb.append(" <div class='ticket-print' style='width: 320px;'><div style='padding: 40px 20px 20px;'><div style='height: 32px;'>");
              StringBuffer img = new StringBuffer();
             img.append(Constant.TICKET_LOGO);
             sb.append("<div style='float: left;'><img src="+img.toString()+" alt='' height='30' width='111'/></div>");
             sb.append("<div style='float: left; border-left: solid 5px #080808; padding-left: 5px; margin:1px 0 1px 10px; height: 30px;'>");
             sb.append("<h1 style='line-height: 2px; font-size: 12pt;'>活动预约</h1><p style='line-height: 6px; font-size: 7pt; font-family: Arial;'>Activity Appointment</p></div></div>");
             sb.append("<h2 style='line-height: 20px; font-size: 12pt; margin-top: 18px;'>"+cmsActivityOrder.getActivityName()+"</h2>");
             sb.append("<p style='line-height: 18px; font-size: 10pt; '>地点："+cmsActivityOrder.getActivityAddress() +"</p>");
             sb.append("<p style='line-height: 18px; font-size: 10pt; '>时间："+cmsActivityOrder.getEventDateTime() +"</p>");
             StringBuffer seatSB = new StringBuffer();
            //在线选座 截取座位重新编辑成几排几座
            if (!seats[i].equals("") && org.apache.commons.lang3.StringUtils.isNotBlank(seats[i]) && seats[i].contains("_")) {
                String[] activitySeat = seats[i].split("_");
                seatSB.append(activitySeat[0] + "排");
                seatSB.append(activitySeat[1] + "座");
                seatSB.append(",");
            }
            //自由入座 编辑座位信息
            else {
                seatSB.append("自由入座");
                seatSB.append(",");
            }
             sb.append("<p style='line-height: 18px; font-size: 10pt;'>座位："+seatSB.substring(0, seatSB.length() - 1)+"</p>");
             sb.append("<div style='width: 100%; height: 92px; padding:3px 0; position: relative;'>");
             sb.append("<p style='line-height: 7px; font-size: 8pt; padding-top: 56px;'>票类：网络票</p>");
             sb.append("<p style='line-height: 7px; font-size: 8pt; padding-top: 2px;'>取票时间："+DateUtils.parseDateToLongString(new Date())+"</p>");
          //封装二维码路径生成二维码图片
            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
            StringBuffer validete = new StringBuffer();
            validete.append(basePath.getBasePath());
            validete.append(sdf.format(new Date()));
            validete.append("/");
            if (cmsActivityOrder.getOrderValidateCode() != null && org.apache.commons.lang3.StringUtils.isNotBlank(cmsActivityOrder.getOrderValidateCode())) {
                validete.append(cmsActivityOrder.getOrderValidateCode());
                validete.append(".jpg");
            }
            QRCode.create_image(cmsActivityOrder.getOrderValidateCode(), validete.toString());
            StringBuffer stringBuffer = new StringBuffer();
            stringBuffer.append(staticServer.getStaticServerUrl());
            stringBuffer.append(sdf.format(new Date()));
            stringBuffer.append("/");
            stringBuffer.append(cmsActivityOrder.getOrderValidateCode());
            stringBuffer.append(".jpg");
            sb.append("<img src="+stringBuffer.toString()+" width='92' height='92' style='position: absolute; bottom: 0; right: 30px;'/>");
            sb.append("</div></div>");
            sb.append("<div style='height: 18px; line-height: 18px; text-align: center; font-size: 10px; padding: 0px 0 15px; border-bottom: solid 1px #d3d3d4;'>更多精彩内容请访问：http://www.wenhuayun.cn</div></div>");
        }
           return  JSONResponse.toAppResultFormat(0,sb.toString());
    }
}
