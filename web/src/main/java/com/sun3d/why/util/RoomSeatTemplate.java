package com.sun3d.why.util;
import com.sun3d.why.model.CmsRoomOrder;
import com.sun3d.why.model.extmodel.BasePath;
import com.sun3d.why.model.extmodel.StaticServer;
import java.text.SimpleDateFormat;
import java.util.Date;
/**
 * 取票机活动室座位模板
 */
public class RoomSeatTemplate {
    public static String toRoomSeatTemplate(CmsRoomOrder cmsRoomOrder,StaticServer staticServer,BasePath basePath) throws Exception {
             StringBuffer sb = new StringBuffer();
        sb.append(" <div class='ticket-print' style='width: 320px;'><div style='padding: 40px 20px 20px;'><div style='height: 32px;'>");
        StringBuffer img = new StringBuffer();
        img.append(Constant.TICKET_LOGO);
        sb.append("<div style='float: left;'><img src="+img.toString()+" alt='' height='30' width='111'/></div>");
        sb.append("<div style='float: left; border-left: solid 5px #080808; padding-left: 5px; margin:1px 0 1px 10px; height: 30px;'>");
        sb.append("<h1 style='line-height: 2px; font-size: 12pt;'>活动室预约</h1><p style='line-height: 6px; font-size: 7pt; font-family: Arial;'>ActivityRoom Appointment</p></div></div>");
             sb.append("<h2 style='line-height: 20px; font-size: 12pt; margin-top: 18px;'>"+cmsRoomOrder.getVenueName()+""+cmsRoomOrder.getRoomName()+"</h2>");
             sb.append("<p style='line-height: 18px; font-size: 10pt;'>地点："+cmsRoomOrder.getVenueAddress() +"</p>");
             //拼接活动室时间段与具体时间点
             StringBuffer sbTime=new StringBuffer();
             sbTime.append(cmsRoomOrder.getCurDates()+" ");
             sbTime.append(cmsRoomOrder.getOpenPeriod());
             sb.append("<p style='line-height: 18px; font-size: 10pt;'>时间："+sbTime.toString() +"</p>");
             sb.append("<p style='line-height: 18px; font-size: 10pt;'>团体："+cmsRoomOrder.getTuserTeamName()+"</p>");
             sb.append("<div style='width: 100%; height: 92px; padding: 6px 0; position: relative;'>");
             sb.append("<p style='line-height: 7px; font-size: 8pt; padding-top: 56px;'>票类：网络票</p>");
             sb.append("<p style='line-height: 7px; font-size: 8pt; padding-top: 2px;'>取票时间："+DateUtils.parseDateToLongString(new Date())+"</p>");
            //封装二维码路径生成二维码图片
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
        StringBuffer validete = new StringBuffer();
        validete.append(basePath.getBasePath());
        validete.append(sdf.format(new Date()));
        validete.append("/");
          if (cmsRoomOrder.getValidCode() != null && org.apache.commons.lang3.StringUtils.isNotBlank(cmsRoomOrder.getValidCode())) {
            validete.append(cmsRoomOrder.getValidCode());
             validete.append(".jpg");
           }
              QRCode.create_image(cmsRoomOrder.getValidCode(), validete.toString());
            StringBuffer stringBuffer = new StringBuffer();
            stringBuffer.append(staticServer.getStaticServerUrl());
            stringBuffer.append(sdf.format(new Date()));
            stringBuffer.append("/");
            stringBuffer.append(cmsRoomOrder.getValidCode());
            stringBuffer.append(".jpg");
            sb.append("<img src="+stringBuffer.toString()+" width='92' height='92' style='position: absolute; bottom: 0; right: 30px;'/>");
            sb.append("</div></div>");
            sb.append("<div style='height: 18px; line-height: 18px; text-align: center; font-size: 10px; padding: 26px 0 15px; border-bottom: solid 1px #d3d3d4;'>更多精彩内容请访问：http://www.wenhuayun.cn</div></div>");
            return  JSONResponse.toAppResultFormat(0,sb.toString());
    }
}
