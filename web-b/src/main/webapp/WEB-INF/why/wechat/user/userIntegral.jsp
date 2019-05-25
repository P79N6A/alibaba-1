<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta charset="utf-8"/>
<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
<!-- <title>用户积分</title> -->
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
		
<script>
	
	$(function(){
			//判断是否是微信浏览器打开
	        if (is_weixin()) {
	
	            //通过config接口注入权限验证配置
	            wx.config({
	                debug: false,
	                appId: '${sign.appId}',
	                timestamp: '${sign.timestamp}',
	                nonceStr: '${sign.nonceStr}',
	                signature: '${sign.signature}',
	                jsApiList: ['onMenuShareAppMessage','onMenuShareTimeline','onMenuShareQQ','onMenuShareWeibo','onMenuShareQZone']
	            });
	        }
			
	        var startIndex = 0;		//页数
			
			var userId=$("#userId").val();
			
			loadData(startIndex, 20,userId);
			
			   //滑屏分页
	        $(window).on("scroll", function () {
	            var scrollTop = $(document).scrollTop();
	            var pageHeight = $(document).height();
	            var winHeight = $(window).height();
	            if (scrollTop >= (pageHeight - winHeight - 100)) {
	           		startIndex += 20;
	           		var index = startIndex;
	           		setTimeout(function () { 
	   					loadData(index, 20,userId);
	           		},1000);
	            }
	        });
	});
	
	
	  function loadData(index, pagesize,userId) {
		  $.post("${path}/wechatUser/userIntegralDetail.do",{pageIndex:index,pageNum:pagesize,userId:userId}, function (data) {
		  
			if(data.status==1)
			{
				var userIntegralDetails=data.data.userIntegralDetails;
				if(userIntegralDetails.length<20){
	      			if(userIntegralDetails.length==0&&index==0){
	      				$("#loadingDiv").html("<span class='noLoadingSpan' style='padding-left:210px;'>您尚未有过积分信息~</span>");
	      			}else{
	      				$("#loadingDiv").html("");
	      			}
	      		}
				$.each(userIntegralDetails, function (i, dom) {
				
				var score="";
				
				var changeType=dom.changeType;
				
				if(changeType==0)
				{
					score="<p class='fs30 cd58185'>+"+dom.integralChange+"</p>";
				}
				else 
					score="<p class='fs30 c262626'>-"+dom.integralChange+"</p>";
					
				var li="<li>"+
						"<div class='border-bottom padding-bottom20 padding-left30'>"+
						"<div class='f-left w50-pc'>"+
							"<p class='fs30'>"+dom.name+"</p>"+
							"<p class='fs26 c808080'>"+dom.description+"</p>"+
						"</div>"+
						"<div class='f-right w170'>"+score+
							"<p class='fs26 c808080'>"+dom.date+"</p>"+
						"</div>"+
						"<div style='clear: both;'></div>"+
					"</div>"+
				"</li>";
      				
				$(".my-point-list ul").append(li);
      			});
			}
			  
		  }, "json")
	  };
	  
	  
	  function userIntegralAll()
	  {
		  window.location.href="${path}/wechatUser/userIntegralAll.do";
	  }
	
</script>
</head>
<body>
		<div class="main">
			<input type="hidden" id="userId" value="${userId }"/>
			<div class="header">
				<div class="index-top">
					<span class="index-top-5">
						<img src="${path}/STATIC/wechat/image/arrow1.png"  onclick="history.go(-1);"/>
					</span>
					<span class="index-top-2">我的积分</span>
				</div>
			</div>
			<div class="content padding-bottom0 margin-top100">
				<div class="my-point bg7279a0 cfff">
					<p class="fs30 my-point-num">您有<span class="fs50 margin-left10 margin-right10">${integralNow }</span>积分</p>
					<p class="my-point-rule fs26" onclick="location.href='${path}/wechatUser/preIntegralRule.do'">积分规则</p>
				</div>
				<div class="my-point-list fs30">
					<ul>
						<li class="margin-bottom5" onclick="userIntegralAll();">
							<div class="my-point-title padding-left30">
								<p>最近30天积分明细</p>
								<span>更多明细</span>
								<div style="clear: both;"></div>
							</div>
						</li>
						
					</ul>
				</div>
			</div>
			<div id="loadingDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
			<div class="footer">

			</div>
		</div>

</body>

	
</html>