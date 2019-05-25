<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head lang="en">
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <!-- <title>我的消息</title> -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/reset-mc.css" />
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/mc-mobile.css" />
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
    <script type="text/javascript" src="${path}/STATIC/wx/js/mc-mobile.js"></script>

    <script type="text/javascript">
        var userId = '${sessionScope.terminalUser.userId}';

        $(function(){
            $.post("${path}/wechatUser/userWebchatMessage.do",{userId:userId}, function(data) {
                $("#userMessageDiv").html("");
                $.each(data.data,function(i,dom){
                    $("#userMessageDiv").append("<li class='clearfix' onclick='clickActivityNotice(\""+dom.userMessageId+"\")'>" +
                    "<a class='title'>"+dom.messageType+"</a>" +
                    "<p>"+dom.messageContent+"</p>" +
                    "</li>");
                });
            },"json");
        });

        function clickActivityNotice(userMessageId){
            window.location.href="${path}/wechatUser/preMobileMessageDetail.do?userMessageId="+userMessageId;
        }
    </script>
</head>

<body>
	<div class="index-top">
		<span class="index-top-5">
			<img src="${path}/STATIC/wechat/image/arrow1.png"  onclick="history.go(-1);"/>
		</span>
	    <span class="index-top-2">我的消息</span>
    </div>
    <div class="common_container">
         <div class="list_container">
           <ul class="message_lists" id="userMessageDiv"></ul>
         </div>
    </div>
</body>
</html>