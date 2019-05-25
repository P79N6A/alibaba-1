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
 function getHeadImgUrl(userHeadImgUrl){
		
		//头像
		var userHeadImgHtml = '';
		if(userHeadImgUrl){
	        if(userHeadImgUrl.indexOf("http") == -1){
	        	userHeadImgUrl = getImgUrl(userHeadImgUrl);
	        }
	        if (userHeadImgUrl.indexOf("http")==-1) {
	        	userHeadImgHtml = '../STATIC/wx/image/sh_user_header_icon.png'
	        } else if (userHeadImgUrl.indexOf("/front/") != -1) {
	            var imgUrl = getIndexImgUrl(userHeadImgUrl, "_300_300");
	            userHeadImgHtml =  imgUrl ;
	        } else {
	        	userHeadImgHtml =  userHeadImgUrl ;
	        }
	    }else{
	    	userHeadImgHtml = "../STATIC/wx/image/sh_user_header_icon.png";
	    }
		
		return userHeadImgHtml;
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
	 
	 var userHeadImgUrl=$("#userHeadMy").attr("data");
		
		$("#userHeadMy").attr("src",getHeadImgUrl(userHeadImgUrl))
});
 </script>
 
 </head>
 
 <body>
 
   <div class="tradKnowWap">
        <div class="head"></div>
        <div class="tabWcBg complete">
            <div class="personal clearfix">
            
            <img class="photo" id="userHeadMy" data="${userHeadImgUrl }" src=""/>
										
                <div class="top"><i class="name">${userName }</i>恭喜您完成了</div>
                
                <c:choose>
                	<c:when test="${stageNumber==1 }">
                	 <div class="bottom">第一阶段 戏曲精粹的挑战</div>
                	</c:when>
                	<c:when test="${stageNumber==2 }">
                	 <div class="bottom">第二阶段 诗词经典的挑战</div>
                	</c:when>
                	<c:when test="${stageNumber==3 }">
                	 <div class="bottom">第三阶段 人文民俗的挑战</div>
                	</c:when>
                </c:choose>
               
            </div>
            <p>本次答题共用时：<b>${answerTime }</b></p>
            <p>答对：<b>${answer.answerRightNumber }题</b></p>
            <p>本次得分：<b>${answer.answerRightNumber }分</b></p>
            <p>历史最高分：<b>${ stageRanking.answerRightNumber }分</b></p>
            <p>您本阶段的得分在${groupName }排名：<b>第${ stageRanking.rowno}名</b></p>
            <p>当前总分：<b>${ sumRanking.answerRightNumber }分</b></p>
            <p>您的总分在${groupName }排名：<b>第${ sumRanking.rowno }名</b></p>
        </div>
        <div class="Anniu"> 
             <a href="${path }/wechatStatic/cultureContestIndex.do"> <img src="${path}/STATIC/wxStatic/image/tradKnow/icon17.png"></a>
           <a href="${path }/wechatStatic/cultureContestQuestions.do"><img src="${path}/STATIC/wxStatic/image/tradKnow/icon6.png"></a>
           <a href="${path }/wechatStatic/cultureContestRanking.do?userId=${sessionScope.terminalUser.userId}"><img src="${path}/STATIC/wxStatic/image/tradKnow/icon18.png"></a>
        </div>
    </div>
 
 </body>
 
 </html>