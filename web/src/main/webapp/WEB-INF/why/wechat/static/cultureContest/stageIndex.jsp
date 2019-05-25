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

 if (userId == null || userId == '') {
		//判断登陆
	 publicLogin('${basePath}wechatStatic/cultureContestIndex.do');
}
 
 /*点击开始答题*/
 function beginning(){
     
		var stageNumber=$("#stageNumber").val();
		
		window.location.href='${basePath}wechatStatic/cultureContestTest.do?userId='+userId+"&stageNumber="+stageNumber;
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
    <div class="tradKnowWap step${stageNumber}">
        <div class="head"></div>
         <%@include file="head.jsp"%>
        <div class="content">
          <a href="${path }/wechatStatic/cultureContestRule.do"><img src="${path}/STATIC/wxStatic/image/tradKnow/icon7.png" class="role"></a>
          <a href="${path }/wechatStatic/cultureContestQuestions.do"><img src="${path}/STATIC/wxStatic/image/tradKnow/icon9.png" class="check"></a>
          <a href="${path }/wechatStatic/cultureContestRanking.do?userId=${userId}"><img src="${path}/STATIC/wxStatic/image/tradKnow/icon22.png" class="ranking"></a>
           
            <input type="hidden" value="${ stageNumber}" id="stageNumber"/>
            <div class="info">
                <span>剩余答题机会${testChance }次</span><span>历史最佳成绩${bestRightNumber }分</span>
            </div>
            <c:choose>
            	<c:when test="${ testChance >0}">
            		 <img src="${path}/STATIC/wxStatic/image/tradKnow/icon10.png" onclick="beginning()">
            	</c:when> 
            	<c:otherwise>
            		 <img src="${path}/STATIC/wxStatic/image/tradKnow/icon21.png">
            	</c:otherwise>
            </c:choose>
            <div class="note">特别注意：每个用户每阶段只有3次答题机会，一旦点击开始答题，即扣除一次答题机会，中途退出/返回均视为提前交卷，请保证设备、网络使用通畅，集中精力答题喔~</div>
        </div> 
    </div>

</body>


</html>

