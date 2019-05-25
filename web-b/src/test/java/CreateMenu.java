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
	
//	private final static SimpleDateFormat dateFormat = new SimpleDateFormat("HH:mm");

	public static void main(String[] args) {
		System.out.println(0.05+0.01);
	}
}
