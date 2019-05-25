<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>中华优秀传统文化知识大赛</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series-2.css?v=20170511"/>
	<script src="${path}/STATIC/js/common.js"></script>
<style type="text/css">
html,body {height: 100%;}
</style>
<script type="text/javascript">

if (is_weixin()) {
	if (userId == null || userId == '') {
		//判断登陆
		publicLogin('${basePath}wechatStatic/cultureContestIndex.do');
	}	
}


function contestEnter(stageNumber){
	
	if (userId == null || userId == '') {
		//判断登陆
		publicLogin('${basePath}wechatStatic/cultureContestIndex.do');
	}else
		window.location.href='${basePath}wechatStatic/cultureContestEnter.do?userId='+userId+"&stageNumber="+stageNumber;
}

$(function() {
	if(window.screen.width > 750){
		//PC
		$("img").each(function(){
			
			
			var src=$(this).attr("src");
			
			src=src.replace('/tradKnow/','/tradKnowPc/')
			
			$(this).attr("src",src);
		});
	}
});
</script>

</head>

<body>
  <div class="tradKnowWap">
      <%@include file="head.jsp"%>
        <div class="tabWcBg">
            <div class="charwen">
                <img src="${path}/STATIC/wxStatic/image/tradKnow/char1.png">
                <img src="${path}/STATIC/wxStatic/image/tradKnow/char2.png">
            </div>
            <ul class="tabUl">
            	<c:choose>
            		<c:when test="${end==true  }">
            		
            		</c:when>
            		<c:when test="${stage1==true }">
            			 <li class="active" onclick="contestEnter('1');"><span></span></li>
            		</c:when>
            		<c:otherwise>
            			 <li><span></span></li>
            		</c:otherwise>
            	</c:choose>
            
               
                <li><span></span></li>
                <li><span></span></li>
            </ul>
        </div>
        <div class="tradAnniu">
            <a href="${path }/wechatStatic/cultureContestRule.do"><img src="${path}/STATIC/wxStatic/image/tradKnow/icon5.png"></a>
            <a href="${path }/wechatStatic/cultureContestQuestions.do"><img src="${path}/STATIC/wxStatic/image/tradKnow/icon6.png"></a>
        </div>
    </div>
</body>
</html>