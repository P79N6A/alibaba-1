package com.culturecloud.mail;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.mail.Address;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.util.ByteArrayDataSource;

import org.springframework.stereotype.Component;

import com.culturecloud.model.bean.common.SysBussinessErrorLog;
import com.culturecloud.util.PpsConfig;


/**
 * 邮箱监控 错误邮件
 * 
 * @author zhangshun
 *
 */
@Component
public class OrderCheckMail {

	    // 邮箱服务器
	    private static String host = "smtp.exmail.qq.com";
	    // 这个是你的邮箱用户名
	    private static String username = "whyerror@sun3d.com";
	    // 你的邮箱密码
	    private static String password = "Zcx50783090";

	    private static String mail_head_name = "this is head of this mail";

	    private static String mail_head_value = "this is head of this mail";

	    //private static String mail_to = "qiuww@sun3d.com";

	    private static String mail_from = "whyerror@sun3d.com";

	    // 邮件标题
	    private static String mail_subject = "订单数据监控错误信息";

	    private static String mail_body = "this is the mail_body of this test mail";

	    private static String personalName = "文化云服务器";
	    
	    private static InternetAddress[] addresses;

	    public OrderCheckMail() throws AddressException {

	    	 String[] arr = PpsConfig.getString("orderCheckMail").split(",");  
	            int receiverCount = arr.length;  
	            if (receiverCount > 0) {  
	            	addresses=new InternetAddress[receiverCount];  
	                for (int i = 0; i < receiverCount; i++) {  
	                	addresses[i] = new InternetAddress(arr[i]);  
	                }  
	            }
	    }

	    /**
	     * 此段代码用来发送普通电子邮件
	     */
	    public static boolean send(List<SysBussinessErrorLog> errorLogList,String date,String rows) throws Exception {

	            //URLDecoder.decode("url","UTF-8");
	            Properties props = new Properties(); // 获取系统环境
	            Authenticator auth = new Email_Autherticator(); // 进行邮件服务器用户认证
	            props.put("mail.smtp.host", host);
	            props.put("mail.smtp.auth", "true");
	            Session session = Session.getDefaultInstance(props, auth);
	            // 设置session,和邮件服务器进行通讯。
	            MimeMessage message = new MimeMessage(session);
	            //message.setContent("foobar, "application/x-foobar"); // 设置邮件格式
	            
	            SimpleDateFormat sdf = new SimpleDateFormat("YYYY-MM-dd HH:mm:ss");
	            
	            message.setSubject(sdf.format(new Date())+" "+mail_subject); // 设置邮件主题
	           // message.setText("您好，您的文化云账户已经注册成功，请点击http://localhost:8080/updateTerminalUserDisable.do?userId=" + URLEncoder.encode(id, "UTF-8") + "激活帐号！"); // 设置邮件正文
	            message.setHeader(mail_head_name, mail_head_value); // 设置邮件标题
	            message.setSentDate(new Date()); // 设置邮件发送日期
	            Address address = new InternetAddress(mail_from, personalName);
	            message.setFrom(address); // 设置邮件发送者的地址
	            message.addRecipients(Message.RecipientType.TO, addresses);  // 设置邮件接收方的地址
	            StringBuffer sb = new StringBuffer();
	            sb.append("<HTML>");
	            sb.append("<HEAD>");
	            sb.append("<TITLE>");
	            sb.append("</TITLE>");
	            sb.append("</HEAD>");
	            sb.append("<BODY>");
	            sb.append("<p>查询订单开始时间："+date+"  查询行数："+rows+" </p>");
	            
	            for (SysBussinessErrorLog sysBussinessErrorLog : errorLogList) {
					
	            	   sb.append("<p>订单id:"+sysBussinessErrorLog.getBussinessKeyId()+"</p><p  style='color:red;'>错误信息："+sysBussinessErrorLog.getErrorDescription()+"</p>");
	            	   sb.append("<br>");
	            }
	         
	            sb.append("</BODY>");
	            sb.append("</HTML>");
	            message.setDataHandler(new DataHandler(
	                    new ByteArrayDataSource(sb.toString(), "text/html")));
	            Transport.send(message); // 发送邮件

	            return true;
	       
	    }

	    /**
	     * 用来进行服务器对用户的认证
	     */
	    public static class Email_Autherticator extends Authenticator {
	        public Email_Autherticator() {
	            super();
	        }

	        public Email_Autherticator(String user, String pwd) {
	            super();
	            username = user;
	            password = pwd;
	        }

	        public  PasswordAuthentication getPasswordAuthentication() {
	            return new PasswordAuthentication(username, password);
	        }
	    }
}
