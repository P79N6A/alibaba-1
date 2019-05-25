package com.sun3d.why.util;

import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.activation.DataHandler;
import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.util.ByteArrayDataSource;
import javax.servlet.http.HttpServletRequest;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.Date;
import java.util.Properties;


/**
 * Created by qiuweiwei on 2015/5/8.
 */
@Component
public class MailUtil {
    // 邮箱服务器
    private static String host = "smtp.163.com";
    // 这个是你的邮箱用户名
    private static String username = "qiuweiwei1234@163.com";
    // 你的邮箱密码
    private static String password = "qww19891110";

    private static String mail_head_name = "this is head of this mail";

    private static String mail_head_value = "this is head of this mail";

    //private static String mail_to = "qiuww@sun3d.com";

    private static String mail_from = "qiuweiwei1234@163.com";

    // 邮件标题
    private static String mail_subject = "文化云";

    private static String mail_body = "this is the mail_body of this test mail";

    private static String personalName = "文化云服务器";

    public MailUtil() {

    }

    /**
     * 此段代码用来发送普通电子邮件
     */
    public static boolean send(String email,String id) throws Exception {

        try {
            //URLDecoder.decode("url","UTF-8");
            Properties props = new Properties(); // 获取系统环境
            Authenticator auth = new Email_Autherticator(); // 进行邮件服务器用户认证
            props.put("mail.smtp.host", host);
            props.put("mail.smtp.auth", "true");
            Session session = Session.getDefaultInstance(props, auth);
            // 设置session,和邮件服务器进行通讯。
            MimeMessage message = new MimeMessage(session);
            //message.setContent("foobar, "application/x-foobar"); // 设置邮件格式
            message.setSubject(mail_subject); // 设置邮件主题
           // message.setText("您好，您的文化云账户已经注册成功，请点击http://localhost:8080/updateTerminalUserDisable.do?userId=" + URLEncoder.encode(id, "UTF-8") + "激活帐号！"); // 设置邮件正文
            message.setHeader(mail_head_name, mail_head_value); // 设置邮件标题
            message.setSentDate(new Date()); // 设置邮件发送日期
            Address address = new InternetAddress(mail_from, personalName);
            message.setFrom(address); // 设置邮件发送者的地址
            Address toAddress = new InternetAddress(email); // 设置邮件接收方的地址
            message.addRecipient(Message.RecipientType.TO, toAddress);
            StringBuffer sb = new StringBuffer();
            sb.append("<HTML>");
            sb.append("<HEAD>");
            sb.append("<TITLE>");
            sb.append("</TITLE>");
            sb.append("</HEAD>");
            sb.append("<BODY>");
            HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
            String basePath = request.getScheme() + "://"
                    + request.getServerName() + ":" + request.getServerPort()+ "/";
            sb.append("<H1>您好，您的文化云账户已经注册成功，请<a href="+basePath+"updateTerminalUserDisable.do?userId="
                    + URLEncoder.encode(id, "UTF-8")+"><span style='color: red'>点此激活</span></a></H1>");
            sb.append("</BODY>");
            sb.append("</HTML>");
            message.setDataHandler(new DataHandler(
                    new ByteArrayDataSource(sb.toString(), "text/html")));
            Transport.send(message); // 发送邮件

            return true;
        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        }
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

                /*public static void main(String[] args)
        {
               Test sendmail = new Test();
                try
                {
                       sendmail.send();

                   } catch (Exception ex)
                {

                   }
            }*/

}
