//package com.culturecloud.utils;
////package com.zh.utils;
//
//import java.io.BufferedReader;
//import java.io.FileNotFoundException;
//import java.io.InputStreamReader;
//import java.net.URL;
//import java.net.URLConnection;
//import java.util.Collection;
//import java.util.List;
//import java.util.Map;
//
//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
//
///**
// * 邮件工具类
// * 
// * @see 发送邮件的工具类 需要自己实例化
// * @version 1.0
// * @author gaoyr
// */
//public class MailSender {
//
//	/**
//	 * 发送邮件
//	 * 
//	 * @param subject
//	 *            邮件主题
//	 * @param msg
//	 *            邮件内容
//	 * @param to
//	 *            发送地址
//	 * 
//	 * @return boolean 是否发送成功
//	 */
//	public boolean send(String subject, String msg, String... to) {
//		try {
//			SimpleEmail email = getSimpleEmail();
//
//			for (String t : to) {
//				email.addTo(t, t, charset);
//			}
//
//			email.setSubject(subject);
//			email.setMsg(msg);
//			email.send();
//			return true;
//		} catch (EmailException e) {
//			LOGGER.error("发送邮件失败", e);
//			return false;
//		}
//	}
//	
//	/**
//	 * 发送邮件
//	 * 
//	 * @param subject
//	 *            邮件主题
//	 * @param msg
//	 *            邮件内容
//	 * @param attachment
//	 *            附件内容
//	 * @param to
//	 *            发送地址
//	 * @return boolean 是否发送成功
//	 */
//	public boolean send(String subject, String msg, EmailAttachment attachment, String... to) {
//		return send(subject, msg, new EmailAttachment[] { attachment }, to);
//	}
//
//	/**
//	 * 发送邮件
//	 * 
//	 * @param subject
//	 *            邮件主题
//	 * @param msg
//	 *            邮件内容
//	 * @param attachments
//	 *            附件内容
//	 * @param to
//	 *            发送地址
//	 * @return boolean 是否发送成功
//	 */
//	public boolean send(String subject, String msg, EmailAttachment[] attachments, String... to) {
//		try {
//			MultiPartEmail email = getMultiPartEmail();
//
//			for (String t : to) {
//				email.addTo(t, t, charset);
//			}
//			for (EmailAttachment attachment : attachments) {
//				email.attach(attachment).setCharset(charset);
//			}
//			email.setSubject(subject);
//			email.setMsg(msg);
//			email.send();
//			return true;
//		} catch (Exception e) {
//			LOGGER.error("发送邮件失败", e);
//			return false;
//		}
//	}
//
//	/**
//	 * 发送HTML邮件
//	 * 
//	 * @param subject
//	 *            邮件主题
//	 * @param msg
//	 *            邮件内容
//	 * @param to
//	 *            发送地址
//	 * 
//	 * @return boolean 是否发送成功
//	 */
//	public boolean sendHTML(String subject, String msg, String... to) {
//		try {
//			HtmlEmail email = getHTMLEmail(msg);
//
//			for (String t : to) {
//				email.addTo(t, t, charset);
//			}
//
//			email.setSubject(subject);
//			email.setMsg(msg);
//			email.send();
//
//			return true;
//		} catch (EmailException e) {
//			LOGGER.error("发送邮件失败", e);
//			return false;
//		}
//	}
//
//	/**
//	 * 发送邮件
//	 * 
//	 * @param subject
//	 *            邮件主题
//	 * @param msg
//	 *            邮件内容
//	 * @param attachment
//	 *            附件内容
//	 * @param to
//	 *            发送地址
//	 * @return boolean 是否发送成功
//	 */
//	public boolean sendHTML(String subject, String msg, EmailAttachment attachment, String... to) {
//		return sendHTML(subject, msg, new EmailAttachment[] { attachment }, to);
//	}
//
//	/**
//	 * 发送邮件
//	 * 
//	 * @param subject
//	 *            邮件主题
//	 * @param msg
//	 *            邮件内容
//	 * @param attachments
//	 *            附件内容
//	 * @param to
//	 *            发送地址
//	 * @return boolean 是否发送成功
//	 */
//	public boolean sendHTML(String subject, String msg, EmailAttachment[] attachments, String... to) {
//		try {
//			HtmlEmail email = getHTMLEmail(msg);
//
//			for (String t : to) {
//				email.addTo(t, t, charset);
//			}
//			for (EmailAttachment attachment : attachments) {
//				email.attach(attachment).setCharset(charset);
//			}
//			email.setSubject(subject);
//			email.setMsg(msg);
//			email.send();
//			return true;
//		} catch (Exception e) {
//			LOGGER.error("发送邮件失败", e);
//			return false;
//		}
//	}
//
//	/**
//	 * 发送邮件
//	 * 
//	 * @param subject
//	 *            邮件主题
//	 * @param msg
//	 *            邮件内容
//	 * @param to
//	 *            发送地址
//	 * @param cc
//	 * 			    抄送地址
//	 * 
//	 * @return boolean 是否发送成功
//	 */
//	public boolean sendHTML(String subject, String msg, Collection<String> to, Collection<String> cc) {
//		try {
//			SimpleEmail email = getSimpleEmail();
//			email.setTo(to);
//			email.setCc(cc);
//			email.setSubject(subject);
//			email.setMsg(msg);
//			email.send();
//			return true;
//		} catch (EmailException e) {
//			LOGGER.error("发送邮件失败", e);
//			return false;
//		}
//	}
//
//	/**
//	 * 获取邮件附件
//	 * 
//	 * @param name
//	 *            附件名称
//	 * @param description
//	 *            附件描述
//	 * @param path
//	 *            附件本地地址
//	 * 
//	 * @return 邮件附件对象
//	 * @throws FileNotFoundException
//	 *             找不到指定的文件
//	 */
//	public EmailAttachment getEmailAttachment(String name, String description, String path) throws FileNotFoundException {
//		EmailAttachment attachment = new EmailAttachment();
//
//		attachment.setPath(FileUtils.getAbsolutePath(path));
//		attachment.setDisposition(EmailAttachment.ATTACHMENT);
//		attachment.setDescription(description);
//		attachment.setName(name);
//
//		return attachment;
//	}
//
//	/**
//	 * 填充邮件对象的必要属性
//	 * 
//	 * @param email
//	 *            邮件对象
//	 * @throws EmailException
//	 *             邮件对象异常
//	 */
//	private void fillEmail(Email email) throws EmailException {
//		email.setFrom(from);
//		email.setCharset(charset);
//		email.setAuthentication(user, password);
//		email.setHostName(hostName);
//		email.setSSL(isSSL);
//		email.setSmtpPort(port);
//	}
//
//	/**
//	 * 获得文本邮件对象
//	 * 
//	 * @return org.apache.commons.mail.SimpleEmail 邮件对象
//	 */
//	private SimpleEmail getSimpleEmail() {
//		SimpleEmail email = new SimpleEmail();
//		try {
//			fillEmail(email);
//
//			return email;
//		} catch (EmailException e) {
//			throw new RuntimeException(e);
//		}
//	}
//
//	/**
//	 * 获得多部分消息邮件对象
//	 * 
//	 * @return org.apache.commons.mail.MultiPartEmail 多部分消息邮件对象
//	 */
//	private MultiPartEmail getMultiPartEmail() {
//		MultiPartEmail email = new MultiPartEmail();
//		try {
//			fillEmail(email);
//
//			return email;
//		} catch (EmailException e) {
//			throw new RuntimeException(e);
//		}
//	}
//
//	/**
//	 * 获得HTML邮件对象
//	 * 
//	 * @param html
//	 *            邮件正文
//	 * @return {@link HtmlEmail}
//	 */
//	private HtmlEmail getHTMLEmail(String html) {
//		HtmlEmail email = new HtmlEmail();
//
//		try {
//			fillEmail(email);
//
//			email.setHtmlMsg(html);
//		} catch (EmailException e) {
//			throw new RuntimeException(e);
//		}
//
//		return email;
//	}
//
//	/**
//	 * 默认构造器
//	 */
//	public MailSender() {
//	}
//
//	// 常量属性
//	/** 日志对象 */
//	private static final Logger LOGGER = LoggerFactory.getLogger(MailSender.class);
//
//	/** 默认是否使用SSL */
//	public static final boolean DEFAULT_IS_SSL = false;
//
//	/** 默认邮件服务器端口 */
//	public static final int DEFAULT_PORT = 25;
//
//	/** 默认字符集 */
//	public static final String DEFAULT_CHARSET = "UTF-8";
//
//	// 对象属性
//
//	/** 邮箱服务器地址 */
//	private String hostName;
//
//	/** 发送者 */
//	private String from;
//
//	/** 发送者用户名 */
//	private String user;
//
//	/** 发送者密码 */
//	private String password;
//
//	/** 字符集 */
//	private String charset = DEFAULT_CHARSET;
//
//	/** 是否为HTTPS */
//	private boolean isSSL = DEFAULT_IS_SSL;
//
//	/** 邮件服务器端口 */
//	private Integer port = DEFAULT_PORT;
//
//	public String getHostName() {
//		return hostName;
//	}
//
//	public void setHostName(String hostName) {
//		this.hostName = hostName;
//	}
//
//	public String getFrom() {
//		return from;
//	}
//
//	public void setFrom(String from) {
//		this.from = from;
//	}
//
//	public String getUser() {
//		return user;
//	}
//
//	public void setUser(String user) {
//		this.user = user;
//	}
//
//	public String getPassword() {
//		return password;
//	}
//
//	public void setPassword(String password) {
//		this.password = password;
//	}
//
//	public String getCharset() {
//		return charset;
//	}
//
//	public void setCharset(String charset) {
//		this.charset = charset;
//	}
//
//	public boolean isSSL() {
//		return isSSL;
//	}
//
//	public void setSSL(boolean isSSL) {
//		this.isSSL = isSSL;
//	}
//
//	static {
//		System.setProperty("mail.mime.encodefilename", "true");
//	}
//	public static void main(String[] args) {
//		MailSender mail = new MailSender();
//		mail.from ="gaoyinrui@163.com";
//		mail.user="gaoyinrui@163.com";
//		mail.password="";
//		mail.hostName="smtp.163.com";
//		mail.port = 25;
//		boolean b = mail.sendHTML("111", MailSender.sendGet("http://www.sanxiantech.com/?r=comproduct/show&pid=1029", null), "gaoyinrui@sanxiantech.com");
//		System.out.println(b);
//	}
//	 public static String sendGet(String url, String param) {
//	        String result = "";
//	        BufferedReader in = null;
//	        try {
//	            String urlNameString = url + "?" + param;
//	            URL realUrl = new URL(urlNameString);
//	            // 打开和URL之间的连接
//	            URLConnection connection = realUrl.openConnection();
//	            // 设置通用的请求属性
//	            connection.setRequestProperty("accept", "*/*");
//	            connection.setRequestProperty("connection", "Keep-Alive");
//	            connection.setRequestProperty("user-agent",
//	                    "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1;SV1)");
//	            // 建立实际的连接
//	            connection.connect();
//	            // 获取所有响应头字段
//	            Map<String, List<String>> map = connection.getHeaderFields();
//	            // 遍历所有的响应头字段
//	            for (String key : map.keySet()) {
//	                System.out.println(key + "--->" + map.get(key));
//	            }
//	            // 定义 BufferedReader输入流来读取URL的响应
//	            in = new BufferedReader(new InputStreamReader(
//	                    connection.getInputStream()));
//	            String line;
//	            while ((line = in.readLine()) != null) {
//	                result += line;
//	            }
//	        } catch (Exception e) {
//	            System.out.println("发送GET请求出现异常！" + e);
//	            e.printStackTrace();
//	        }
//	        // 使用finally块来关闭输入流
//	        finally {
//	            try {
//	                if (in != null) {
//	                    in.close();
//	                }
//	            } catch (Exception e2) {
//	                e2.printStackTrace();
//	            }
//	        }
//	        System.out.println(result);
//	        return result;
//	    }	
//}
