<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head lang="en">
  <%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <!-- <title>实况直击</title> -->
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/reset-mc.css?v=20160313" />
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/mc-mobile.css?v=201603130000" />
  <script type="text/javascript" src="${path}/STATIC/wx/js/mc-mobile.js"></script>
  <script type="text/javascript" src="${path}/STATIC/js/common.js"></script>
  
  <script type="text/javascript">
	var newsImgUrl = getImgUrl('${data.newsImgUrl}');
	var newsTitle = '${data.newsTitle}';
	var newsDesc = '${data.newsDesc}';
	newsDesc = newsDesc.length>20?newsDesc.substring(0,19)+"...":newsDesc;
	$(function () {
		wx.config({
            debug: false,
            appId: '${sign.appId}',
            timestamp: '${sign.timestamp}',
            nonceStr: '${sign.nonceStr}',
            signature: '${sign.signature}',
            jsApiList: ['onMenuShareAppMessage','onMenuShareTimeline','onMenuShareQQ','onMenuShareWeibo','onMenuShareQZone']
        });
        wx.ready(function () {
            wx.onMenuShareAppMessage({
                title: newsTitle,
                imgUrl: newsImgUrl,
                desc: newsDesc,
                success: function () { 
                	dialogAlert('系统提示', '分享成功！');
                }
            });
            wx.onMenuShareTimeline({
                title: newsTitle,
                imgUrl: newsImgUrl,
                success: function () { 
                	dialogAlert('系统提示', '分享成功！');
                }
            });
            wx.onMenuShareQQ({
            	title: newsTitle,
                imgUrl: newsImgUrl,
                desc: newsDesc
            });
            wx.onMenuShareWeibo({
            	title: newsTitle,
                imgUrl: newsImgUrl,
                desc: newsDesc
            });
            wx.onMenuShareQZone({
            	title: newsTitle,
                imgUrl: newsImgUrl,
                desc: newsDesc
            });
        });
	});
/*        $(function(){
            var reqFrom ='${reqFrom}';
            if(reqFrom){
                window.localStorage.setItem("reqFrom",reqFrom);
            }
        });*/
        //后退
/*        function myBack(){
            var reqFrom = window.localStorage.getItem("reqFrom");
            if(reqFrom){
                if(reqFrom=="android"){
                    injs.onAndroidBack();
                }else if(reqFrom=="ios"){
                    document.location.href="objc://runOnIosBack";
                }
            }else{
                window.history.go(-1);
            }
        }*/
        //分享
/*        function myShare(){
            var reqFrom = window.localStorage.getItem("reqFrom");
            var _thisUrl = '${basePath}'+"frontNews/detail.do?dataId="+'${data.newsId}';
            var imgUrl = getImgUrl('${data.newsImgUrl}');
            var title = '${data.newsTitle}';
            var obj = {
            };
            obj.title=title;
            obj.imgUrl=imgUrl;
            obj.pageUrl=_thisUrl;
            //console.log(JSON.stringify(obj));
            if(reqFrom){
                if(reqFrom=="android"){
                    injs.onAndroidShare(_thisUrl);
                }else if(reqFrom=="ios"){
                    document.location.href="objc://runOnIosShare:/"+JSON.stringify(obj);
                }
            }else{
                //alert("微信分享");
            }
        }*/
  </script>
</head>
<body>
<!--head start-->
<%--<c:if test="${empty reqFrom}">
    <div id="vote_head" class="clearfix">
      <a href="javascript:;" class="l_arrow fl" onclick="myBack()">
          <img src="${path}/STATIC/wx/image/ZM_return_white.png" width="25" height="42">
      </a>
      <span class="fl">实况直击</span>
    </div>
</c:if>--%>
<!--head end-->
<div class="M-watch-detail">
  <div class="M-detail-note clearfix">
    <div class="note-tit">
      <h2>${data.newsTitle}</h2>
      <p><span>${data.newsReportUser}</span><fmt:formatDate value="${data.newsReportTime}" pattern="yyyy-MM-dd" /></p>
      <a class="link" href="javascript:;">${data.dictName}</a>
    </div>
    <div class="note-cont">${data.newsContent}</div>
  </div>
</div>
</body>
</html>