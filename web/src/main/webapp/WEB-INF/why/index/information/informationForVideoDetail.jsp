<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@page import="com.sun3d.why.model.CmsTerminalUser"%>
<%@ page language="java" pageEncoding="UTF-8" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
    request.setAttribute("path", path);
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
    request.setAttribute("basePath", basePath);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>${info.informationTitle}_${module.informationModuleName}</title>
	<link rel="stylesheet" href="${path}/STATIC/css/owl.carousel.min.css">
    <link rel="stylesheet" href="${path}/STATIC/css/owl.theme.default.min.css">
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/bpNormalize.css">
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/hsCulture.css">
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture-user.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/ui-dialog.css"/>
	<script type="text/javascript" src="${path}/STATIC/js/frontBp/jquery.min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/frontBp/jquery.SuperSlide.2.1.1.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/frontBp/owl.carousel.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/frontBp/culture.js"></script>
	<script type="text/javascript" src="${path}/STATIC/js/frontBp/qiehuan.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/base.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/common.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/jquery.alerts.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/jquery.uploadify-3.1.min.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/ckplayer/ckplayer.js" charset="utf-8"></script>
    <!-- 评论 
    <script type="text/javascript" src="${path}/STATIC/js/comment.js"></script>-->
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <!-- 举报弹窗 -->
    <script type="text/javascript" src="${path}/STATIC/js/dialog/lib/sea.js"></script>
    <!--页面大部分js都放到这个jsp里面了,放js文件发现总是有些对象引用不到，所以出此下策-->
    <%@include file="detailJs.jsp" %>
    <style type="">
    .bdshare-button-style0-16{
    padding-left:0 !important;}
    	.bdshare-button-style0-16 a, .bdshare-button-style0-16 .bds_more {
		    float: none !important;
		    margin:  0 !important;
		}
    </style>
    <!--移动端版本兼容 end -->
</head>
<body>
<div class="header">
	<%@include file="../header.jsp" %>
</div>
<input id ="userId" value="${sessionScope.terminalUser.userId }" type="hidden"/>
<input id ="infoId" value="${info.informationId}" type="hidden"/>
<div class="lm_main clearfix">
    <p class="lm-breadcrumbs">您所在的位置：
        <a href="${path}/zxInformation/zbfrontindex.do?module=${module.informationModuleId}"><span>${module.informationModuleName}</span></a>
        <span>${bpTagInfo.beipiaoinfoTag }</span>
    </p>
    <!-- 详情 -->
    <div class="left">
        <p class="name">${info.informationTitle }</p>
        <div class="time clearfix" id = "detailDiv">
            <fmt:formatDate value="${info.informationUpdateTime}" pattern="yyyy-MM-dd HH:mm"/>
            <div class="state">
                <span class="zan_lm" onclick="addWantGo('${info.informationId }',20,'$(this)')">${info.wantCount}</span>
                <span class="bdsharebuttonbox" >
					 <a class="share_lm" data-cmd="more">分享</a>
				 </span>
                <!--分享代码 start-->
                <script>
                    window._bd_share_config = {
                        "common": {
                            "bdSnsKey": {},
                            "bdText": "",
                            "bdMini": "2",
                            "bdMiniList": false,
                            "bdPic": "",
                            "bdStyle": "0",
                            "bdSize": "16"
                        },
                        "share": {}
                    };
                    with(document) 0[(getElementsByTagName('head')[0] || body).appendChild(createElement('script')).src = 'http://bdimg.share.baidu.com/static/api/js/share.js?v=89860593.js?cdnversion=' + ~(-new Date() / 36e5)];
                </script>
                <!--分享代码 end-->
            </div>
        </div>

        <!-- 详情介绍 -->
        <div class="detail">
            <h3>视频缩略图</h3>
            <div >
                <img style="margin:20px 0;max-width:100%;width:auto;height:auto" style="" src="${info.videoIconUrl}"/>
            </div>
            <h3>详情</h3>

            <div>
                ${info.informationContent}
            </div>
            <div class="bottom clearfix">
                <span class="worn_lm">举报</span>
            </div>
        </div>
    </div>
    <!--更多和评论模块因为多个jsp用到而且都一样的，就抽出去了，省的看着乱-->
    <%@include file="moreAndComments.jsp" %>
    <%@include file="/WEB-INF/why/index/footer.jsp" %>
</body>
</html>