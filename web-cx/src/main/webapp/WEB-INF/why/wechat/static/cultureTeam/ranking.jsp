<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>浦东百强团队评选活动</title>
<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series-2.css">
<script type="text/javascript">
var tab = '${tab}';
var cultureTeamType = '${cultureTeamType}'; //节目分类
var startIndex = 0;		//页数

//分享是否隐藏
if(window.injs){
	//分享文案
	appShareTitle = '您的文化生活您做主，快来给您喜欢的文化团队点赞';
	appShareDesc = '2017浦东新区“百强文化团队”线上大众投票！';
	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/hundred/shareIcon.png';
	
	injs.setAppShareButtonStatus(true);
}

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
	wx.ready(function () {
		wx.onMenuShareAppMessage({
			title: "您的文化生活您做主，快来给您喜欢的文化团队点赞",
			desc: '2017浦东新区“百强文化团队”线上大众投票！',
			link: '${basePath}wechatStatic/cultureTeamIndex.do?tab='+tab+'&t='+new Date().getTime(),
			imgUrl: '${basePath}/STATIC/wxStatic/image/hundred/shareIcon.png'
		});
		wx.onMenuShareTimeline({
			title: "您的文化生活您做主，快来给您喜欢的文化团队点赞",
			imgUrl: '${basePath}/STATIC/wxStatic/image/hundred/shareIcon.png',
			link: '${basePath}wechatStatic/cultureTeamIndex.do?tab='+tab+'&t='+new Date().getTime()
		});
		wx.onMenuShareQQ({
			title: "您的文化生活您做主，快来给您喜欢的文化团队点赞",
			desc: '2017浦东新区“百强文化团队”线上大众投票！',
			imgUrl: '${basePath}/STATIC/wxStatic/image/hundred/shareIcon.png'
		});
		wx.onMenuShareWeibo({
			title: "您的文化生活您做主，快来给您喜欢的文化团队点赞",
			desc: '2017浦东新区“百强文化团队”线上大众投票！',
			imgUrl: '${basePath}/STATIC/wxStatic/image/hundred/shareIcon.png'
		});
		wx.onMenuShareQZone({
			title: "您的文化生活您做主，快来给您喜欢的文化团队点赞",
			desc: '2017浦东新区“百强文化团队”线上大众投票！',
			imgUrl: '${basePath}/STATIC/wxStatic/image/hundred/shareIcon.png'
		});
	});
}


$(function(){
	
	// 导航固定
    function navFixed(ele, type, topH) {
        $(document).on(type, function() {
            if($(document).scrollTop() > topH) {
                ele.css('position', 'fixed');
            } else {
                ele.css('position', 'static');
            }
        });
    }
	
	
	loadRankingList(0,20);
	
	//分享
	$(".fx").click(function() {
	 	 if (!is_weixin()&&!(/wenhuayun/.test(ua))) {
	 			dialogAlert('系统提示', '请用微信浏览器打开分享！');
	 		}else{   
				  
				$("html,body").addClass("bg-notouch");
				$(".background-fx").css("display", "block");
				
		     } 
		})
		$(".background-fx").click(function() {
			$("html,body").removeClass("bg-notouch");
			$(".background-fx").css("display", "none")
		})
		
		 // 规则弹窗
	    $('.hundredmain .note a').bind('click', function () {
	        $('.hundredRule').stop().fadeIn(50);
	    });
	    $('.hundredRule .guanbi').bind('click', function () {
	        $('.hundredRule').stop().fadeOut(50);
	    });
		
	
	})
	
	
var p=0;
	//滑屏分页
 $(window).on("scroll", function () {
            var scrollTop = $(document).scrollTop();
            var pageHeight = $(document).height();
            var winHeight = $(window).height();
            if (scrollTop >= (pageHeight - winHeight - 10)) {
           		setTimeout(function () { 
           			if(p==0){
           				startIndex += 20;
                  		var index = startIndex;
                  		loadRankingList(index,20);
           			}
           		},800);
            }
        });   
	
//加载剧评列表
var paim = 1;
 function loadRankingList(index, pagesize){
 	p=1;
 	 var data = {
 		    userId:userId,
 		    cultureTeamType:cultureTeamType,
 		    reviewType:7,
 			firstResult: index,
            rows: pagesize
         };
 	$.post("${path}/wechatStatic/queryCultureTeamlist.do",data, function (data) {
 		//记录第一页第一条数据ID，防止微信返回缓存问题
 		if(index == 0){
 			var ctRankingData = window.sessionStorage.getItem("ctRankingData"+cultureTeamType);
 			if(ctRankingData){
 				if(ctRankingData != data[0].cultureTeamId){
 					loadRankingList(0,20);
 					return;
 				}
 			}else{
 				window.sessionStorage.setItem("ctRankingData"+cultureTeamType,data[0].cultureTeamId);
 			}
 		}
 		
 		if(data.length<20){
 			$("#loadingVoteItemDiv").html("");
     	}else{
 			p=0;
 		}
 		
 		$.each(data, function (i, dom) {
 			var cultureTeamFamily=dom.cultureTeamFamily;
 			if(cultureTeamFamily){
 				//对图片进行处理
 	 			var ImgObj = new Image();
 	 			ImgObj.src = dom.cultureTeamFamily.split(",")[0]+"@400w";
 	 			ImgObj.onload = function(){
 	 				if(ImgObj.width/ImgObj.height>345/485){
 	 					var pLeft = (ImgObj.width*(155/ImgObj.height)-215)/2;
 	 					$("img[cultureTeamId="+dom.cultureTeamId+"]").css({"height":"155px","position":"absolute","left":"-"+pLeft+"px"});
 	 				}else{
 	 					var pTop = (ImgObj.height*(215/ImgObj.width)-155)/2;
 	 					$("img[cultureTeamId="+dom.cultureTeamId+"]").css({"width":"215px","position":"absolute","top":"-"+pTop+"px"});
 	 				}
 	 			}
 				
 				$(".hundredPopUl").append("<li class='clearfix'>" +
 						"<div class='pic' onclick='window.location.href=\"http://www.wenhuayun.cn/wechatStatic/cultureTeamDetail.do?cultureTeamId="+dom.cultureTeamId+"\"'>"+"<img cultureTeamId="+dom.cultureTeamId+" src='"+dom.cultureTeamFamily.split(",")[0]+"@400w' width='215' height='155'>"+"</div>"+
 						"<div class='char' onclick='window.location.href=\"http://www.wenhuayun.cn/wechatStatic/cultureTeamDetail.do?cultureTeamId="+dom.cultureTeamId+"\"'>"+
 						   "<div class='w1'>"+dom.cultureTeamName+"</div>"+
 						   "<div class='w2'>"+dom.cultureTeamTown+"</div>"+
 						"</div>"+
 						"<div class='paim'>"+
 						    "<div class='mc'>"+(paim++)+"</div>"+
 						"</div>"+
 						"<div class='xian'>"+
 						    "<div class='shu'>"+dom.voteCount+"票</div>"+
 						"</div>"+
 						/*  "<div class='xian'>"+
					        "<div class='shu'>×票</div>"+
					    "</div>"+  */
 					"</li>");
 			}else{
 				
 				$(".hundredPopUl").append("<li class='clearfix'>" +
 						"<div class='pic' onclick='window.location.href=\"http://www.wenhuayun.cn/wechatStatic/cultureTeamDetail.do?cultureTeamId="+dom.cultureTeamId+"\"'>"+"<img cultureTeamId="+dom.cultureTeamId+" src='' width='215' height='155'>"+"</div>"+
 						"<div class='char' onclick='window.location.href=\"http://www.wenhuayun.cn/wechatStatic/cultureTeamDetail.do?cultureTeamId="+dom.cultureTeamId+"\"'>"+
 						   "<div class='w1'>"+dom.cultureTeamName+"</div>"+
 						   "<div class='w2'>"+dom.cultureTeamTown+"</div>"+
 						"</div>"+
 						"<div class='paim'>"+
 						    "<div class='mc'>"+(paim++)+"</div>"+
 						"</div>"+
 						"<div class='xian'>"+
 						    "<div class='shu'>"+dom.voteCount+"票</div>"+
 						"</div>"+
 						/* "<div class='xian'>"+
						    "<div class='shu'>×票</div>"+
						"</div>"+  */
 					"</li>");
 			}
 		});
 	},"json");
 }	

</script>
</head>

<body>
<!-- 分享的图片 -->
 <div id="indexShareBg" class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
		<img src="${path}/STATIC/wechat/image/commonShare.png" style="width: 100%;height: 100%;" />
 </div>
<div class="hundredmain">
	<div class="ban"><img src="${path}/STATIC/wxStatic/image/hundred/ban.jpg"><div class="fx"></div></div>
	<div class="note">
		<div class="jz690"><img src="${path}/STATIC/wxStatic/image/hundred/icon2.png">本次活动共计217支团队参赛，其中：舞蹈45支，音乐52支，戏剧41支，曲艺7支，美书影26支，综合46支。<a href="#">查询活动规则&nbsp;&gt;&gt;</a></div>
	</div>
	<div class="hunqieh">
		<a href="${path }/wechatStatic/cultureTeamIndex.do?guide=1&tab=1"><img src="${path}/STATIC/wxStatic/image/hundred/icon3.png">投票页</a>
		<a class="current" href="${path }/wechatStatic/cultureTeamRanking.do"><img src="${path}/STATIC/wxStatic/image/hundred/icon4.png">人气榜</a>
	</div>
	<div class="hunTitle">
		<c:choose>
	  <c:when test="${tab=='1'}">
	    <a class="current" href="${path }/wechatStatic/cultureTeamRanking.do?tab=1&guide=1">舞蹈</a>
		<a href="${path }/wechatStatic/cultureTeamRanking.do?tab=2&guide=1">音乐</a>
		<a href="${path }/wechatStatic/cultureTeamRanking.do?tab=3&guide=1">戏剧</a>
		<a href="${path }/wechatStatic/cultureTeamRanking.do?tab=6&guide=1">曲艺</a>
		<a href="${path }/wechatStatic/cultureTeamRanking.do?tab=4&guide=1">美书影</a>
		<a href="${path }/wechatStatic/cultureTeamRanking.do?tab=5&guide=1">综合</a>
	  </c:when>
	  <c:when test="${tab=='2'}">
	    <a href="${path }/wechatStatic/cultureTeamRanking.do?tab=1&guide=1">舞蹈</a>
		<a class="current" href="${path }/wechatStatic/cultureTeamRanking.do?tab=2&guide=1">音乐</a>
		<a href="${path }/wechatStatic/cultureTeamRanking.do?tab=3&guide=1">戏剧</a>
		<a href="${path }/wechatStatic/cultureTeamRanking.do?tab=6&guide=1">曲艺</a>
		<a href="${path }/wechatStatic/cultureTeamRanking.do?tab=4&guide=1">美书影</a>
		<a href="${path }/wechatStatic/cultureTeamRanking.do?tab=5&guide=1">综合</a>
	  </c:when>
	  <c:when test="${tab=='3'}">
	    <a href="${path }/wechatStatic/cultureTeamRanking.do?tab=1&guide=1">舞蹈</a>
		<a href="${path }/wechatStatic/cultureTeamRanking.do?tab=2&guide=1">音乐</a>
		<a class="current" href="${path }/wechatStatic/cultureTeamRanking.do?tab=3&guide=1">戏剧</a>
		<a href="${path }/wechatStatic/cultureTeamRanking.do?tab=6&guide=1">曲艺</a>
		<a href="${path }/wechatStatic/cultureTeamRanking.do?tab=4&guide=1">美书影</a>
		<a href="${path }/wechatStatic/cultureTeamRanking.do?tab=5&guide=1">综合</a>
	  </c:when>
	  <c:when test="${tab=='4'}">
	    <a href="${path }/wechatStatic/cultureTeamRanking.do?tab=1&guide=1">舞蹈</a>
		<a href="${path }/wechatStatic/cultureTeamRanking.do?tab=2&guide=1">音乐</a>
		<a href="${path }/wechatStatic/cultureTeamRanking.do?tab=3&guide=1">戏剧</a>
		<a href="${path }/wechatStatic/cultureTeamRanking.do?tab=6&guide=1">曲艺</a>
		<a class="current" href="${path }/wechatStatic/cultureTeamRanking.do?tab=4&guide=1">美书影</a>
		<a href="${path }/wechatStatic/cultureTeamRanking.do?tab=5&guide=1">综合</a>
	  </c:when>
	  <c:when test="${tab=='5'}">
	    <a href="${path }/wechatStatic/cultureTeamRanking.do?tab=1&guide=1">舞蹈</a>
		<a href="${path }/wechatStatic/cultureTeamRanking.do?tab=2&guide=1">音乐</a>
		<a href="${path }/wechatStatic/cultureTeamRanking.do?tab=3&guide=1">戏剧</a>
		<a href="${path }/wechatStatic/cultureTeamRanking.do?tab=6&guide=1">曲艺</a>
		<a href="${path }/wechatStatic/cultureTeamRanking.do?tab=4&guide=1">美书影</a>
		<a class="current" href="${path }/wechatStatic/cultureTeamRanking.do?tab=5&guide=1">综合</a>
	  </c:when>
	  <c:when test="${tab=='6'}">
	    <a href="${path }/wechatStatic/cultureTeamRanking.do?tab=1&guide=1">舞蹈</a>
		<a href="${path }/wechatStatic/cultureTeamRanking.do?tab=2&guide=1">音乐</a>
		<a href="${path }/wechatStatic/cultureTeamRanking.do?tab=3&guide=1">戏剧</a>
		<a class="current"  href="${path }/wechatStatic/cultureTeamRanking.do?tab=6&guide=1">曲艺</a>
		<a href="${path }/wechatStatic/cultureTeamRanking.do?tab=4&guide=1">美书影</a>
		<a href="${path }/wechatStatic/cultureTeamRanking.do?tab=5&guide=1">综合</a>
	  </c:when>	 
	  <c:otherwise>
	    <a class="current" href="${path }/wechatStatic/cultureTeamRanking.do?tab=1&guide=1">舞蹈</a>
		<a href="${path }/wechatStatic/cultureTeamRanking.do?tab=2&guide=1">音乐</a>
		<a href="${path }/wechatStatic/cultureTeamRanking.do?tab=3&guide=1">戏剧</a>
		<a href="${path }/wechatStatic/cultureTeamRanking.do?tab=6&guide=1">曲艺</a>
		<a href="${path }/wechatStatic/cultureTeamRanking.do?tab=4&guide=1">美书影</a>
		<a href="${path }/wechatStatic/cultureTeamRanking.do?tab=5&guide=1">综合</a>
	  
	  </c:otherwise>	  
	</c:choose>
	</div>
	<ul class="hundredPopUl"></ul>
	<div id="loadingVoteItemDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
	<div class="hunfoot">
		<p>主办单位：浦东新区文化艺术指导中心</p>
		<p>此活动最终解释权归浦东新区文化艺术指导中心所有</p>
	</div>
</div>

<!-- 活动规则查询 -->
<div class="hundredRule">
    <div class="nc">
        <div class="tit"><img src="${path}/STATIC/wxStatic/image/hundred/icon29.png">&nbsp;&nbsp;&nbsp;&nbsp;活动规则&nbsp;&nbsp;&nbsp;&nbsp;<img src="${path}/STATIC/wxStatic/image/hundred/icon29.png"></div>
        <div class="neirong">
            <div class="cont">
                <div class="biao">活动简介</div>
                <p>此活动是浦东新区百强优秀团队评选的市民投票环节。</p>
            </div>
            <div class="cont">
                <div class="biao">百姓投票日期</div>
                <p>2017年03月01日9:00——03月10日17:00</p>
            </div>
            <div class="cont">
                <div class="biao">评选方式</div>
                <p>1）由百姓投票、浦东各街镇文化中心和相关企事业单位负责人参评、专家评审三部分组成。</p>
                <p>2）市民通过“文化云—2017浦东新区百强文化团队评选活动-大众投票通道”进行投票，投票数占总得分的30%。</p>
                <p>3）大赛将评出包含舞蹈、音乐、戏剧、曲艺、美书影、综合在内的100强团队。</p>
            </div>
            <div class="cont">
                <div class="biao">投票方式</div>
                <p>1）每个用户（同一ID）每天对同一团队只能投一票；</p>
                <p>2）用户可以在人气榜中查看实时排名。</p>
            </div>
            <div class="cont">
                <div class="biao">排序方式</div>
                <p>本次投票活动首页的团队排序以拼音首字母顺序依次排序。</p>
            </div>
            <div class="cont">
                <p>本活动禁止任何手段的恶意刷票或作弊行为，一经发现，取消活动资格。</p>
                <p>此规则最终解释权归上海市浦东新区文化艺术指导中心所有！</p>
            </div>
        </div>
    </div>
    <div class="guanbi">我知道了</div>
</div>
</body>
</html>