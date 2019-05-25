package com.sun3d.why.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;


/**
 * @version 1.0
 * @auther ly
 * Date: 15-4-23
 * Time: 下午2:03
 */
@Component
public class SmsSend {
  
	@Value(value = "${smsUrl}")
	private String smsUrl;
	@Value(value = "${uId}")
	private String uId;
	@Value(value = "${pwd}")
	private String pwd;


    /**
     * @param mobile  手机号码
     * @param content 发送内容
     * @return 状态:
     * 100 发送成功
     * 101 验证失败
     * 102 短信不足
     * 103 操作失败
     * 104 非法字符
     * 105 内容过多
     * 106 号码过多
     * 107 频率过快
     * 108 号码内容空
     * 109 账号冻结
     * 110 禁止频繁单条发送
     * 111 系统暂定发送
     * 112 号码不正确
     * 120 系统升级
     * @throws IOException
     */
   public String sendSmsMessage(String smsUrl,String uid,String pwd,String mobile, String content) throws Exception {



        // 创建StringBuffer对象用来操作字符串
        StringBuffer sb = new StringBuffer(smsUrl);

        // 向StringBuffer追加用户名
        sb.append("ac=send&uid="+uid);

        // 向StringBuffer追加密码（密码采用MD5 32位 小写）
        sb.append("&pwd="+pwd);

        // 向StringBuffer追加手机号码
        sb.append("&mobile="+mobile);

        // 向StringBuffer追加消息内容转URL标准码
        sb.append("&content=" + URLEncoder.encode(content,"UTF-8"));

        sb.append("&encode=utf8");


        // 创建url对象
        URL url = new URL(sb.toString());

        // 打开url连接
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();

        // 设置url请求方式 ‘get’ 或者 ‘post’
        connection.setRequestMethod("POST");

        // 发送
        BufferedReader in = new BufferedReader(new InputStreamReader(url.openStream()));

        // 返回发送结果
        return in.readLine();

    }
   public String sendSmsMessage(String mobile, String content)
			throws Exception {

		// 创建StringBuffer对象用来操作字符串
		StringBuffer sb = new StringBuffer(this.smsUrl);

		// 向StringBuffer追加用户名
		sb.append("ac=send&uid=" + this.uId);

		// 向StringBuffer追加密码（密码采用MD5 32位 小写）
		sb.append("&pwd=" + this.pwd);

		// 向StringBuffer追加手机号码
		sb.append("&mobile=" + mobile);

		// 向StringBuffer追加消息内容转URL标准码
		sb.append("&content=" + URLEncoder.encode(content, "UTF-8"));

		sb.append("&encode=utf8");

		// 创建url对象
		URL url = new URL(sb.toString());

		// 打开url连接
		HttpURLConnection connection = (HttpURLConnection) url.openConnection();

		// 设置url请求方式 ‘get’ 或者 ‘post’
		connection.setRequestMethod("POST");

		// 发送
		BufferedReader in = new BufferedReader(new InputStreamReader(url.openStream()));

		// 返回发送结果
		return in.readLine();

	}

    public static void main(String[] args) {
        try {
            SmsSend smsSend = new SmsSend();
          //  String code = smsSend.sendSmsMessage("http://api.cnsms.cn/?","104077","ee4e68f6600ed0e4d43c8ab38ffe5c1a","15601919631","测试");
          //  System.out.println("短信发送返回码："+code);
        }catch (Exception ex){
            ex.printStackTrace();
        }
    }
}
