<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page language="java" pageEncoding="UTF-8" %>
<%
    String path = request.getContextPath();
    request.setAttribute("path", path);
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>

<%
    StringBuilder back = new StringBuilder();
  back.append("http://59.252.48.6");
//    back.append("http://124.205.89.158:28080/sso");
    back.append("/");
    back.append("v2?openid.mode=checkid_setup");
    back.append("&openid.return_to=" + URLEncoder.encode("http://www.wenhuayun.cn/ssowhy/ssoclient?", "utf-8"));
    back.append("return_url=" + URLDecoder.decode("http://www.wenhuayun.cn", "utf-8"));
    back.append("&openid.ex.client_id=ed0cfd7d-a069-4253-9705-b8fddbaa20a3");
    back.append("&ReturnUrl=%2findex.aspx?PortalCode=temp");
    response.sendRedirect(back.toString());
%>


