<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%
    String path = request.getContextPath();
    request.setAttribute("path", path);
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
    request.setAttribute("basePath", basePath);
%>
<!doctype html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title>万人培训-我的报名</title>
<meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">

<link rel="stylesheet" type="text/css" href="${path}/STATIC/train/weChat/css/mobiscroll.custom-2.4.4.min.css">
<link rel="stylesheet" type="text/css" href="${path}/STATIC/train/weChat/css/css.css">
<link rel="stylesheet" type="text/css" href="${path}/STATIC/train/weChat/css/ui-dialog.css"/>
<script type="text/javascript" src="${path}/STATIC/train/weChat/js/jquery-min.js"></script>
<script type="text/javascript" src="${path}/STATIC/train/weChat/js/common.js"></script>
<script type="text/javascript" src="${path}/STATIC/train/weChat/js/mobiscroll.custom-2.17.0.min.js"></script>

<!-- dialog start -->
<script type="text/javascript" src="${path}/STATIC/train/weChat/js/dialog-min.js"></script>
<script type="text/javascript">
    $(function() {
        $(".mysignup").on("click", "li .cancel", function () {
            var that = $(this);
            var orderId = $(this).parent().parent().attr("data-orderNum");
            dialogConfirm("取消报名", "您确定要取消报名吗？", removeParent);
            function removeParent() {
            	 $.post("${path}/train/cancelUserCourseOrder.do",{'orderId':orderId},function(data){
            		 if(data=='success'){
            			 that.parents("li").fadeOut(function(){
         					that.parents("li").remove();
         				});
                 	}else if(data=='error'){
                 		dialogAlert("提示","操作失败");
                 	}else{
                 		dialogAlert("提示",data);
                 	} 
                 	
            	 })
                
            }
        });
    });
</script>
<!-- dialog end -->
<!--移动端版本兼容 -->
<script type="text/javascript">
	var phoneWidth =  parseInt(window.screen.width);
	var phoneScale = phoneWidth/750;
	var ua = navigator.userAgent;            //浏览器类型
	if (/Android (\d+\.\d+)/.test(ua)){      //判断是否是安卓系统
		var version = parseFloat(RegExp.$1); //安卓系统的版本号
		if(version>2.3){
			document.write('<meta name="viewport" content="width=750, minimum-scale = '+phoneScale+', maximum-scale = '+phoneScale+', target-densitydpi=device-dpi">');
		}else{
			document.write('<meta name="viewport" content="width=750, target-densitydpi=device-dpi">');
		}
	} else {
		document.write('<meta name="viewport" content="width=750, user-scalable=no, target-densitydpi=device-dpi">');
	}
	
</script>
<!--移动端版本兼容 end -->
    <script type="text/javascript" src="${path}/STATIC/train/weChat/js/iscroll.js"></script>
    <script type="text/javascript" src="${path}/STATIC/train/weChat/js/scrollLoadData.js"></script>
</head>
<body>
  <div class="header">
    <a href="javascript:history.go(-1);" class="pre"></a>
    <span>文化云</span>
  </div>
  <div id="wrapper">
    <div id="scroller">
     <div class="tilClass">
       <div class="boxT"><p><span>我的报名</span></p></div>
     </div>
     <div class="selCon">
       <ul class="mysignup clearfix" id="like-list">
            <c:if test="${not empty courseOrderList}" >
         <li class="borderRadiu5">
           <div class="top clearfix">
             <p class="done"><span>报名成功</span><i></i></p>
             <h2>电影影像技术的现状与未来</h2>
             <a href="javascript:void(0);" class="cancel">取消报名</a>
           </div>
           <div class="detail">
             <p class="title">【培训时间】</p>
             <p class="info">2016-06-15 至 2016-06-17 上午9:00-12:00 下午13:30-16:30</p>
             <p class="title">【培训地点】</p>
             <p class="info">上海交通大学 （华山路1954号）教三楼301教室</p>
             <i class="time">报名时间： 2016-05-20 09:52:30</i>  
           </div>
         </li>
         </c:if>
       </ul>
       <div id="pullUp">
           <span class="pullUpIcon"></span><span class="pullUpLabel">上拉加载更多...</span>
       </div>
     </div>
   </div>
  </div>   
</body>
</html>






























































































