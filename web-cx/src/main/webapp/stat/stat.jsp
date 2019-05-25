<%@page contentType="text/html; charset=utf-8" %>
<%@page import="java.net.URLDecoder"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.util.Properties"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="java.util.regex.Matcher"%>
<%@page import="java.awt.*"%>
<%@page import="java.awt.image.BufferedImage"%>
<%@page import="javax.imageio.*"%>
<%@page import="javax.imageio.ImageIO"%>
<%@page import="java.util.Enumeration" %>
<%@page import="com.alibaba.druid.pool.DruidDataSource"%>
<%@page import="com.alibaba.druid.pool.DruidDataSourceFactory"%>
<%@page import="com.alibaba.druid.pool.DruidPooledConnection"%>
<%@page import="com.sun3d.why.model.CmsTerminalUser"%>

<%
	DruidDataSource dds = (DruidDataSource) application.getAttribute("g_stat_datasource");
	if(dds == null)
	{

		dds = getDataSource(dds,application.getRealPath("/"));
		if(dds != null)
		{
			application.setAttribute("g_stat_datasource",dds);
		}
	}


//response.setHeader("Content-Type","text/javascript");
	response.setContentType("image/gif");
	response.setHeader("Pragma","No-cache");
	response.setHeader("Cache-Control","no-cache");
	response.setDateHeader("Expires", 0);



	out.clear();
	out = pageContext.pushBody();
	BufferedImage image = new BufferedImage(1, 1, BufferedImage.TYPE_INT_RGB);
	ImageIO.write(image, "GIF", response.getOutputStream());

%>


<%!

	public static HashMap<String,String>getUrlKeyAndType(String url)
	{

		final HashMap<String,String> paramMap =  new HashMap<String,String>();
		paramMap.put("www.wenhuayun.cn/activity/list.html","activityList");
		paramMap.put("www.wenhuayun.cn/frontActivity/activityList.do.*","activityList");

		paramMap.put("www.wenhuayun.cn/frontVenue/venueList.do.*","venueList");
		paramMap.put("www.wenhuayun.cn/venue/list.html","venueList");

		paramMap.put("www.wenhuayun.cn/activity/([^/]*)/detail.html","frontActivityDetail");
		paramMap.put("www.wenhuayun.cn/frontActivity/frontActivityDetail.do.*activityId=([^&]*).*","frontActivityDetail");

		paramMap.put("www.wenhuayun.cn/venue/([^/]*)/detail.html","venueDetail");
		paramMap.put("www.wenhuayun.cn/frontVenue/venueDetail.do.*venueId=([^&]*).*","venueDetail");
		paramMap.put("hs.hb.wenhuayun.cn/","mindex");

		//http://www.wenhuayun.cn/activity/7fc8e9ef52e54791af998d3ecd43938e/detail.html
		//http://www.wenhuayun.cn/activity/list.html

		//http://www.wenhuayun.cn/venue/09bd400132cf49a2a16e469bd6a94534/detail.html
		//http://www.wenhuayun.cn/venue/list.html


		HashMap<String,String> retmap =  new HashMap<String,String>();
		String type = paramMap.get(url);
		if(type != null)
		{
			retmap.put("type",type);
		}
		else
		{
			Iterator iter = paramMap.entrySet().iterator();
			while (iter.hasNext())
			{
				Map.Entry entry = (Map.Entry) iter.next();
				String key = (String)entry.getKey();
				Pattern pattern = Pattern.compile(key);
				Matcher matcher = pattern.matcher(url);
				if (matcher.find())
				{
					String val = (String)entry.getValue();
					retmap.put("stype", val);
					if(matcher.groupCount() > 0)
						retmap.put("skey", matcher.group(1));
					else
						retmap.put("skey", "");
				}
				//String val = entry.getValue();
			}
		}



		return retmap;
	}


	public static void execSql(DruidDataSource dds,String sql)
	{
		if(dds == null)
		{
			return;
		}
		synchronized(dds)
		{
			DruidPooledConnection dpc = null;
			Statement stmt = null;



			try {

				dpc = dds.getConnection();
				stmt = dpc.createStatement();
				stmt.executeUpdate(sql);

			} catch (Exception e)
			{
				e.printStackTrace();
			} finally {

				try { if (stmt != null) stmt.close(); } catch(Exception e) { }
				try { if (dpc != null) dpc.close(); } catch(Exception e) { }
			}
		}

	}

	public static synchronized DruidDataSource getDataSource(DruidDataSource dds,String filepath)
	{
		if(dds != null)
		{
			return dds;
		}

		try
		{
			Properties properties =  new Properties();
			properties.load(new FileInputStream(filepath+"/WEB-INF/classes/stat_db.properties"));
			dds = (DruidDataSource) DruidDataSourceFactory.createDataSource(properties);
			return dds;

		} catch (Exception e)
		{
			e.printStackTrace();
		}
		return null;

	}


	public static String trans2db(String strValue)
	{
		if(strValue == null || strValue.trim().length() == 0)
			return "";
		String strRet = strValue.replaceAll("\"", "'").replaceAll("%", "");
		strRet = strValue.replaceAll("'", "''").replaceAll("%", "");
		return strRet;
	}

	public static String transNullString(String str)
	{
		if(str == null || str.length() == 0 || str.equalsIgnoreCase("null"))
			return "";
		else
			return str;

	}

	public static String transNullString(String str,String replacer)
	{
		if(transNullString(str).isEmpty())
		{
			return replacer;
		}
		return str;

	}

	public static String iso2utf8(String s)
	{
		try
		{
			if(s != null)
			{
				byte abyte0[] = s.getBytes("iso-8859-1");
				return new String(abyte0, "UTF8");
			}
		}
		catch(Exception ex) {
		}
		return s;
	}

	public static String iso2gb(String s)
	{
		try
		{
			if(s != null)
			{
				byte abyte0[] = s.getBytes("iso-8859-1");
				return new String(abyte0, "GBK");
			}
		}
		catch(Exception ex) {
		}
		return s;
	}





	public static String URLEncode(String uriString) throws Exception
	{
		try
		{

			String str = URLDecoder.decode(uriString, "iso-8859-1");
			String rule = "^(?:[\\x00-\\x7f]|[\\xe0-\\xef][\\x80-\\xbf]{2})+$";

			//System.out.println(str.getBytes());
			if(str.matches(rule))
			{// is utf-8
				return iso2utf8(uriString);
			}
			else
				return iso2gb(uriString);
		}
		catch(Exception ex)
		{
			return "";
		}

	}

%>


<%

	if(dds != null)
	{

		String host =  "";
		String strSite = "";
		String strType = "";
		String strMobile = "";
		String strIP = "";
		String strMapNo = "";
		String strFrom = "";
		String localurl = "";
		String platform = "";
		String userid = null;




		try
		{
			Object obj = session.getAttribute("terminalUser");
			if(obj != null)
			{
				
				if(obj.getClass().getName().equals("com.sun3d.why.model.CmsTerminalUser"))
				{
							CmsTerminalUser user = (CmsTerminalUser)obj;
							userid = user.getUserId();
				}
			}

			if(userid == null || userid.length()==0)
			{
				userid = transNullString(request.getParameter("userid"),"-1");
			}


			strType = transNullString(request.getParameter("stype"));
			localurl  = transNullString(request.getParameter("localurl")).replaceAll("~","&").replaceAll("http://","");

			host = trans2db(transNullString(request.getHeader("Referer")));

			strSite = transNullString(request.getParameter("site"));

			strMobile = transNullString(request.getParameter("mobile"));
			strFrom = transNullString(request.getParameter("sfrom"));
			platform = transNullString(request.getParameter("platform"));

			if(strFrom.getBytes("UTF-8").length>20)
			{

				strFrom = "";
			}
			strIP = request.getRemoteAddr();

		/* String realIP = request.getHeader("x-forwarded-for");
		System.out.println(realIP+"------"); */
			Enumeration enum1 = request.getHeaderNames();
			while(enum1.hasMoreElements())
			{
				String name = (String)enum1.nextElement();

				if(name.equals("x-real-ip"))
				{
					String value = request.getHeader(name);
					if(value != null && value.length() > 0)
					{
						strIP = value;
					}
					break;
				}

				//System.out.println(name + "=" + value);
			}



			strMapNo = transNullString(request.getParameter("smapno"));
			if(strMapNo.isEmpty())
			{
				strMapNo = transNullString(request.getParameter("mapno"),"21");
			}


		}
		catch(Exception ex)
		{

			//System.out.println("host="+host);
			System.out.println("Error:"+ex.toString());
		}
		try
		{
			int m = Integer.parseInt(strMapNo);
		}
		catch(Exception ex)
		{
			strMapNo = "21";
		}

		String lowHost = host.toLowerCase();
		String agent =  transNullString(request.getHeader("User-Agent"));
		if(strSite.equalsIgnoreCase("edm"))
		{//edmref
			//System.out.println("edmstrIP="+strIP);
			String strKey = iso2gb(transNullString(request.getParameter("skey1")));
			//String userid = transNullString(request.getParameter("userid"),"-1");
			String mail = transNullString(request.getParameter("mail"));
			String sql = "INSERT INTO stat_edm(city,stype,skey1,userid,email,ip,stime,agent) VALUES("+strMapNo+",'"+strType+"','"+strKey+"','"+userid+"','"+mail+"','"+strIP+"',now(),'"+agent+"')";
			//out.println(sql);
			execSql(dds,sql);
			return;

		}
		//System.out.println("+++++++++++"+localurl+"++++++++++++");
		//System.out.println("+++++++++++"+request.getParameter("platform")+"++++++++++++");
		if(lowHost.indexOf("wenhuayun.cn") == -1 && lowHost.length()>0)
		{//安全检查，是否从主网站过来
			return;
		}

		//http://www.why.cn/stat/stat.jsp?smapno=21&userid=&sfrom=&GUID=20160428120448WIPVFHPPRONHSO9E&ostype=Macintosh&mobile=&ref=&r=0.598350616870448
		String strInsertSql = null;
		//String strRef = URLEncode(transNullString(request.getParameter("ref"))).replaceAll("~","&").replaceAll("!!","#").replaceAll("http://","").replaceAll("https://","");
		String GUID = transNullString(request.getParameter("GUID"),"-1");
		//String userid = transNullString(request.getParameter("userid"),"-1");
		//CmsTerminalUser obj = session.getAttribute("terminalUser");
		//if(obj != null)
		{
			//	userid = obj.userId;
		}
		String ostype = transNullString(request.getParameter("ostype"),"");
		String ref = transNullString(request.getParameter("ref"),"");



		String lat = transNullString(request.getParameter("lat"),"-1");
		String lont = transNullString(request.getParameter("lont"),"-1");
		String strKey1 = trans2db(iso2gb(transNullString(request.getParameter("skey1")))).replaceAll("[\n\r\t 	]", "");
		String strKey2 = trans2db(iso2gb(transNullString(request.getParameter("skey2")))).replaceAll("[\n\r\t 	]", "");
		String strKey3 = trans2db(iso2gb(transNullString(request.getParameter("skey3")))).replaceAll("[\n\r\t 	]", "");
		String strKey4 = trans2db(iso2gb(transNullString(request.getParameter("skey4")))).replaceAll("[\n\r\t 	]", "");
		if(strType.equals("list") || strType.equals("detail"))
		{
			HashMap<String,String> map  = getUrlKeyAndType(localurl);
			if(map != null)
			{
				strType = map.get("stype");
				strKey1 = map.get("skey");
			}
		}
		strInsertSql = "INSERT INTO stat_why (city,ip,userid,stype,skey1,skey2,guid,referer,localurl,stime,agent,ostype,platform,lat,lont,skey3,skey4)  VALUES('"+strMapNo+"','"+strIP+"','"+userid+"','"+strType+"','"+strKey1+"','"+strKey2+"','"+GUID+"','"+ref+"','"+localurl+"',now(),'"+agent+"','"+ostype+"','"+platform+"','"+lat+"','"+lont+"','"+strKey3+"','"+strKey4+"')";



		try
		{
			execSql(dds,strInsertSql);

		}
		catch(Exception ex)
		{

			System.out.println(ex.toString());
		}
	}

%>


