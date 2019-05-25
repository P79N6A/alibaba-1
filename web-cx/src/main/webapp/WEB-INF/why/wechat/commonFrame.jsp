<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@page import="java.util.*" %>
<%
    String path = request.getContextPath();
    request.setAttribute("path", path);
    String basePath = request.getScheme() + "://"
            + request.getServerName()
            + path + "/";
    request.setAttribute("basePath", basePath);
    String requestURI = request.getRequestURI();
    request.setAttribute("requestURI", requestURI);
    String error = request.getParameter("error");
    request.setAttribute("error", error);
%>
<%@include file="/WEB-INF/why/wechat/wechat_statistics.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="format-detection" content="telephone=no"/>
<meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no"/>
<meta name="apple-mobile-web-app-capable" content="yes"/>
<meta name="apple-mobile-web-app-status-bar-style" content="black"/>

<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/normalize.css?v=20170223">
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/common.css">
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/colorCtrl.css">
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/ui-dialog.css"/>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-dialog.css"/>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/swiper-3.3.1.min.css">

<script type="text/javascript" src="${path}/STATIC/wechat/js/jquery-2.1.4.min.js"></script>
<script src="${path}/STATIC/js/common.js"></script>
<script type="text/javascript" src="${path}/STATIC/wechat/js/dialog-min.js"></script>
<script type="text/javascript" src="${path}/STATIC/wechat/js/wechat-util.js"></script>
<script type="text/javascript" src="${path}/STATIC/wechat/js/map-transform.js"></script>
<script type="text/javascript" src="${path}/STATIC/wechat/js/jweixin-1.2.0.js"></script>
<script type="text/javascript" src="${path}/STATIC/wechat/js/swiper-3.3.1.jquery.min.js"></script>
<%-- <script src="${path}/STATIC/js/avalon.js"></script> --%>
<script type="text/javascript" src="${path}/stat/stat.js"></script>
<!--移动端版本兼容 -->
<script type="text/javascript">
    (function () {
        var phoneWidth = parseInt(window.screen.width);
        var phoneScale = phoneWidth / 750;
        var ua = navigator.userAgent;            //浏览器类型
        if (/Android (\d+\.\d+)/.test(ua)) {      //判断是否是安卓系统
            var version = parseFloat(RegExp.$1); //安卓系统的版本号
            if (version > 2.3) {
                document.write('<meta name="viewport" content="width=750, minimum-scale = ' + phoneScale + ', maximum-scale = ' + phoneScale + ', target-densitydpi=device-dpi">');
            } else {
                document.write('<meta name="viewport" content="width=750, target-densitydpi=device-dpi">');
            }
        } else {
            document.write('<meta name="viewport" content="width=750, user-scalable=no, target-densitydpi=device-dpi">');
        }
    }());
</script>

<script type="text/javascript">
	var error = '${error}';
	var userId = '${sessionScope.terminalUser.userId}';
	if(!userId){
		userId = '${userId}';
	}
	var ua = navigator.userAgent.toLowerCase();
	//APP分享文案
	var appShareTitle = '';
	var appShareDesc = '';
	var appShareImgUrl = '';
	var appShareLink = '';
	
	//swiper初始参数：图片预览（不可缩放）
	var springSwiperFlag = 0;  // 全局变量，如果swiper初始化过一次，以后就不用初始化了
	var outSwiper = null;      //swiper

	$(function () {
		if(error=="loginFail"){
			dialogAlert('登录失败', '请重试或通过其他方式登录！');
		}
		
		downLoadApp();		//下载APP弹出框
		
		/* setTimeout(function(){
			$("iframe").each(function(){
				if($(this).attr("id")!="spaceIframe"){
					$(this).remove();		//清除垃圾广告iframe
				}
			})
		},2000);  */
		
	});

	//H5判断登录状态(未登录跳转登录)
	function publicLogin(url){
		//再次获取id，以免APP返回不刷新页面
		getAppUserId();
		
		if (!userId) {
			if (/wenhuayun/.test(ua)) {		//APP端
           		if(!window.injs){	//判断是否存在方法
       				dialogAlert('系统提示', '登录之后才能操作！');
       				return;
       			}else{
       				injs.accessAppPage(10);	//app跳转登录
       				return;
       			}
        	}else{
        		if('${callback}' && '${sourceCode}'){
           			if('${requestURI}'.indexOf('wechat/activity/activityDetail.jsp')!=-1){
	    				location.href = '${callback}muser/outLogin.do?type=${basePath}wechatActivity/preActivityDetail.do?activityId=${activityId}';
	    			}else if('${requestURI}'.indexOf('wechat/venue/venue_detail.jsp')!=-1){
	    				location.href = '${callback}muser/outLogin.do?type=${basePath}wechatVenue/venueDetailIndex.do?venueId=${venueId}';
	    			}else if('${requestURI}'.indexOf('wechat/room/roomDetail.jsp')!=-1){
	    				location.href = '${callback}muser/outLogin.do?type=${basePath}wechatRoom/preRoomDetail.do?roomId=${roomId}';
	    			}else if('${requestURI}'.indexOf('wechat/bpChuanzhou/chuanzhouDetail.jsp')!=-1){
	    				location.href = '${callback}muser/outLogin.do?type=${basePath}wechatChuanzhou/chuanzhouDetail.do?infoId=${bpInfo.beipiaoinfoId}';
	    			}else{
               			location.href = '${callback}muser/login.do';
               		}
           		}else{
           			window.parent.window.location.href = '${path}/muser/login.do?type=' + url;
           		}
        	}
        }
	}
	
	//设置H5title或APPtitle
	setTitle();
	
	//app获取用户Id
	getAppUserId();
	
	//跳转到活动详情页
    function toActDetail(activityId){
    	if (/wenhuayun/.test(ua)) {		//APP端
    		if (window.injs) {	//判断是否存在方法
				injs.accessAppPage(1,activityId);
			}else{
				location.href = "com.wenhuayun.app://activitydetail?activityId=" + activityId;
			}
    	}else{		//H5
    		if('${sourceCode}'){
    			window.parent.location.href = "${path}/wechatActivity/preActivityDetail.do?activityId="+activityId+"&userId="+userId+"&callback=${callback}&sourceCode=${sourceCode}";
    		}else{
    			window.parent.location.href = "../wechatActivity/preActivityDetail.do?activityId=" + activityId;
    		}
    	}
    }
    
    //跳转到场馆详情页
    function toVenueDetail(venueId){
    	if (/wenhuayun/.test(ua)) {		//APP端
    		if (window.injs) {	//判断是否存在方法
				injs.accessAppPage(2,venueId);
			}else{
				location.href = "com.wenhuayun.app://venuedetail?venueId=" + venueId;
			}
    	}else{		//H5
    		if('${sourceCode}'){
    			window.parent.location.href = "${path}/wechatVenue/venueDetailIndex.do?venueId="+venueId+"&userId="+userId+"&callback=${callback}&sourceCode=${sourceCode}";
    		}else{
    			window.parent.location.href = "../wechatVenue/venueDetailIndex.do?venueId=" + venueId;
    		}
    	}
    }
    
    //跳转个人中心
	function toUserCenter(){
		if (/wenhuayun/.test(ua)) {		//APP端
			if (window.injs) {	//判断是否存在方法
				injs.accessAppPage(6,'');
			}else{
				location.href = 'com.wenhuayun.app://usercenter';
			}
    	}else{		//H5
    		if('${sourceCode}'){
    			location.href = "${callback}wechatUser/preTerminalUser.do";
    		}else{
    			location.href = "../wechatUser/preTerminalUser.do";
    		}
    	}
	}
    
    //跳转到文化云首页
    function toWhyIndex(){
    	if (/wenhuayun/.test(ua)) {		//APP端
    		if (window.injs) {	//判断是否存在方法
                injs.accessAppPage(14,0);
    		}
    	}else{		//H5
    		if('${sourceCode}'){
    			location.href = "${callback}wechat/index.do";
    		}else{
    			window.parent.location.href = "../wechat/index.do";
    		}
    	}
    }
	
</script>