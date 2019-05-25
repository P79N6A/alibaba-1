import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;

public class CreateMenu {
	
	/**
	  * @Description: 创建菜单
	  * @param @param menuStr json格式的菜单字符串
	  * @param @param accessToken
	  * @return void  
	  * @throws
	  */
	public static void createMenu(String menuStr, String accessToken) {
		StringBuffer bufferRes = new StringBuffer();
		try {
			URL realUrl = new URL("https://api.weixin.qq.com/cgi-bin/menu/create?access_token=" + accessToken);
			HttpURLConnection conn = (HttpURLConnection) realUrl.openConnection();
			// 连接超时
			conn.setConnectTimeout(25000);
			// 读取超时 --服务器响应比较慢,增大时间
			conn.setReadTimeout(25000);
			HttpURLConnection.setFollowRedirects(true);
			// 请求方式
			conn.setRequestMethod("GET");
			conn.setDoOutput(true);
			conn.setDoInput(true);
			conn.connect();
			// 获取URLConnection对象对应的输出流
			OutputStreamWriter out = new OutputStreamWriter(conn.getOutputStream());
			// 发送请求参数
			// out.write(URLEncoder.encode(menuStr,"UTF-8"));
			out.write(menuStr);
			out.flush();
			out.close();
			InputStream in = conn.getInputStream();
			BufferedReader read = new BufferedReader(new InputStreamReader(in, "UTF-8"));
			String valueString = null;
			while ((valueString = read.readLine()) != null) {
				bufferRes.append(valueString);
			}
			System.out.println(bufferRes.toString());
			in.close();
			if (conn != null) {
				// 关闭连接
				conn.disconnect();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public static void main(String[] args) {
		String accessToken = "7DlXCDszup5nav0V1yGgYMBB3KjKvbL7cXSdRRiPb5JBChy0BBTl4ROYx_AU3cVqguet9e9MVuv5XMKK9sUlYzxglS4PuS4VNjrE5vC_C30H2Ju6pVlNYx4bwX6Bf9S6WIDiABAQCX";
				
		String menuStr = "{\"button\":["
								+ "{\"name\":\"我\",\"sub_button\":["
									+ "{\"type\":\"view\",\"name\":\"我的订单\",\"url\":\"http://china.wenhuayun.cn/muser/login.do?type=http://m.wenhuayun.cn/wechatUser/preTerminalUser.do\"},"
									+ "{\"type\":\"view\",\"name\":\"忘记取票码\",\"url\":\"http://m.wenhuayun.cn/wechatActivity/userOrderLogin.do\"},"
									+ "{\"type\":\"view\",\"name\":\"认识文化云\",\"url\":\"http://m.wenhuayun.cn/wechatUser/preCulture.do\"},"
									+ "{\"type\":\"view\",\"name\":\"媒体矩阵\",\"url\":\"http://m.wenhuayun.cn/wechatStatic/media.do\"},"
									+ "{\"type\":\"view\",\"name\":\"万人培训\",\"url\":\"http://wrpx.wenhuayun.cn/wrpxFrontUser/login.do\"}]},"
								+ "{\"name\":\"活动·场馆\",\"type\":\"view\",\"url\":\"http://china.wenhuayun.cn/wxUser/silentInvoke.do?type=http://m.wenhuayun.cn/wechat/index.do\"},"
								+ "{\"name\":\"最热·最新\",\"sub_button\":["
									+ "{\"type\":\"view\",\"name\":\"有奖答题\",\"url\":\"http://china.wenhuayun.cn/wxUser/silentInvoke.do?type=http://m.wenhuayun.cn/wechatStatic/contestList.do\"},"
									+ "{\"type\":\"view\",\"name\":\"每日诗品\",\"url\":\"http://china.wenhuayun.cn/wxUser/silentInvoke.do?type=http://m.wenhuayun.cn/wechatStatic/poemIndex.do\"},"
									+ "{\"type\":\"view\",\"name\":\"暑期兴趣班🔥\",\"url\":\"http://ct.wenhuayun.cn/template/activityTopicDetail.do?topicid=90\"},"
									+ "{\"type\":\"view\",\"name\":\"文化大赛\",\"url\":\"http://china.wenhuayun.cn/wxUser/silentInvoke.do?type=http://m.wenhuayun.cn/wechatStatic/cultureContestIndex.do\"},"
									+ "{\"type\":\"view\",\"name\":\"重大活动\",\"url\":\"http://china.wenhuayun.cn/wxUser/silentInvoke.do?type=http://m.wenhuayun.cn/wechatStatic/brandAct.do\"}]}"
							+ "]}";
		
		System.out.println(menuStr);
		createMenu(menuStr, accessToken);
	}
}
