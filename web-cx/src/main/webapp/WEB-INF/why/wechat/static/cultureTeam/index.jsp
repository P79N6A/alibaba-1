<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
<title>浦东百强团队评选活动</title>
<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series-2.css">
<script type="text/javascript">
var tab = '${tab}';
var noVote = '${noVote}';	//1：不可投票
var showRanking = '${showRanking}';		//1：显示排名
var cultureTeamType = '${cultureTeamType}'; //节目分类
var startIndex = 0;		//页数
var p=0;

 if (userId == null || userId == '') {
	//判断登陆
	publicLogin("${basePath}wechatStatic/cultureTeamIndex.do");
}

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

// 弹窗的打开和关闭
function popUps(windowEle, action, callback) {
    // windowEle:弹窗元素；action表示行为，可以是show或者hide；callback回调函数；
    if(action == 'show') {
        $('.hundredDoorFc').show();
        windowEle.show();
        $('.hundredDoorFc').on('touchmove', function () {
            return false;
        });
    } else {
        $('.hundredDoorFc').hide();
        windowEle.hide();
    }
    if(callback) {
        callback();
    }
}

$(function(){
	
	if (tab == null || tab == '') {
		tab = 0;
	}
	
	loadCtList(0,20);
	
	menuChange(tab);
	
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

    // 关闭你弹窗
    $('.hundredDoor .close').bind('click', function () {
        popUps($(this).parents('.hundredDoor'),'hide');
    });
	
    // 规则弹窗
    $('.hundredmain .note a').bind('click', function () {
        $('.hundredRule').stop().fadeIn(50);
    });
    $('.hundredRule .guanbi').bind('click', function () {
        $('.hundredRule').stop().fadeOut(50);
    });

	
	 // 获取URL的search参数
	function getArgs() {
		var args = [];
		var s = location.search;
		var qs = s.length > 0 ? s.substring(1) : '';   //获取?user=Lee&age=100并去掉?   ,  得到  user=Lee&age=100
		var items = qs.split('&');         //["user=Lee", "age=100"]
		for(var i = 0; i < items.length; i++) {
			var item = items[i].split('=');
			args[item[0]] = parseInt(item[1]);
		}
		return args;
	}

	var urlSess = window.sessionStorage.getItem("touchName");//读取	 
    if(getArgs().guide == 1 || urlSess == '1') {
        $(".hundred_yindy").hide();
    } else {
        // 引导页上滑
        $(".hundred_yindy").bind('touchmove',function() {
            $(this).animate({
                top: "50px",
            }, 500).animate({
                top: "-3000px",
            }, 300, function () {
                $(this).hide();
            });
            window.sessionStorage.setItem("touchName", '1'); //存入
            return false;
        });
        
        //PC端分面页的点击事件
        $(".hundred_yindy").bind('click',function() {
            $(this).animate({
                top: "50px",
            }, 500).animate({
                top: "-3000px",
            }, 300, function () {
                $(this).hide();
            });
            window.sessionStorage.setItem("touchName", '1'); //存入
            // return false;
        });

    }
  //分享
	$(".fx").click(function() {
 	   if (!is_weixin()&&!(/wenhuayun/.test(ua))) {
 			dialogAlert('系统提示', '请用微信浏览器打开分享！');
 		}else{    
			 
			$("html,body").addClass("bg-notouch");
			$(".background-fx").css("display", "block");
			
	     }    
	})
	
    $("#lapiao").click(function() {
 	    if (!is_weixin()&&!(/wenhuayun/.test(ua))) {
 			dialogAlert('系统提示', '请用微信浏览器打开分享！');
 		}else{      
			 
			$("html,body").addClass("bg-notouch");
			$("#indexShareBg").css("display", "block");
			
	    }     
	})
	
	$(".background-fx").click(function() {
		$("html,body").removeClass("bg-notouch");
		$(".background-fx").css("display", "none")
	})
	
})

//加载剧评列表
var listBianhao = 0;
 function loadCtList(index, pagesize){
 	p=1;
 	 var data = {
 		    userId:userId,
 		    cultureTeamType:cultureTeamType,
 		    reviewType:6,
 			firstResult: index,
            rows: pagesize
         };
 	$.post("${path}/wechatStatic/queryCultureTeamlist.do",data, function (data) {
 		//记录第一页第一条数据ID，防止微信返回缓存问题
 		if(index == 0){
 			var ctData = window.sessionStorage.getItem("ctData"+cultureTeamType);
 			if(ctData){
 				if(ctData != data[0].cultureTeamId){
 					loadCtList(0,20);
 					return;
 				}
 			}else{
 				window.sessionStorage.setItem("ctData"+cultureTeamType,data[0].cultureTeamId);
 			}
 		}
 		$.each(data, function (i, dom) {
 			//判断用户是否投过票
 			var voteHtml = "";
 			if(dom.isVote == 1){
 				voteHtml = "active";
 			}
 			var voteCountHtml = "";
 			if(noVote == 1){
 				voteCountHtml = "<span style='font-size:24px;color:black;'>投票已结束</span>";
 			}else{
 				voteCountHtml = "<div class='piaos'>票 数：<em>"+dom.voteCount+"</em></div>";
 			} 
 			
 			var cultureTeamIntro=dom.cultureTeamIntro;
 			if(cultureTeamIntro.length>30){
 				cultureTeamIntro=cultureTeamIntro.substr(0,30)+"...";
 			}
 			
 		var cultureTeamFamily=dom.cultureTeamFamily;	
 	    //列表，以及列表数据的拼接
 	    listBianhao = listBianhao + 1;
 	    if(cultureTeamFamily){
 	    	var ImgObj = new Image();
 			ImgObj.src = dom.cultureTeamFamily.split(",")[0]+"@400w";
 			ImgObj.onload = function(){
 				if(ImgObj.width/ImgObj.height>336/243){
 					var pLeft = (ImgObj.width*(243/ImgObj.height)-336)/2;
 					$("img[cultureTeamId="+dom.cultureTeamId+"]").css({"height":"243px","position":"absolute","left":"-"+pLeft+"px"});
 				}else{
 					var pTop = (ImgObj.height*(336/ImgObj.width)-243)/2;
 					$("img[cultureTeamId="+dom.cultureTeamId+"]").css({"width":"336px","position":"absolute","top":"-"+pTop+"px"});
 				}
 			}
 	    	
 	    	$(".hundredListUl").append("<li>"+
 	   			"<div class='nc clearfix'>"+
 	   			   "<div class='pictit' onclick='window.location.href=\"http://www.wenhuayun.cn/wechatStatic/cultureTeamDetail.do?cultureTeamId="+dom.cultureTeamId+"\"'>"+
 	   			       "<div class='pic'>"+"<img cultureTeamId="+dom.cultureTeamId+" src='"+dom.cultureTeamFamily.split(",")[0]+"@400w'>"+"</div>"+
 	   			       "<div class='tit'>"+dom.cultureTeamName+"</div>"+
 	   			   "</div>"+
 	   			   "<div class='char'>"+
 	   			       "<p onclick='window.location.href=\"http://www.wenhuayun.cn/wechatStatic/cultureTeamDetail.do?cultureTeamId="+dom.cultureTeamId+"\"'>"+cultureTeamIntro+"<a class='xx' style='font-size:25px;' href='http://www.wenhuayun.cn/wechatStatic/cultureTeamDetail.do?cultureTeamId="+dom.cultureTeamId+"'>详情进入...</a>"+"</p>"+
 	   			       "<a class='diand' href='javascript:;'>"+dom.cultureTeamTown+"</a>"+	 
 	   			   	   "<div style='font-size:22px;color:#ccc;margin-top:17px;'>编号："+(listBianhao <= 9 ?'0'+ listBianhao:listBianhao)+"</div>"+
 	   			       "<div class='pt clearfix'>"+
 	   			            voteCountHtml+
 	   			           "<div class='toup "+voteHtml+"' onclick='dcVote(\""+dom.cultureTeamId+"\",this)'>投TA一票"+"<em class='one'>+1</em>"+"</div>"+
 	   			       "</div>"+
 	   			   "</div>"+
 	   			"</div>"+
 	   			"</li>");
 	    }else{
 	    	$(".hundredListUl").append("<li>"+
 	   			"<div class='nc clearfix'>"+
 	   			   "<div class='pictit' onclick='window.location.href=\"http://www.wenhuayun.cn/wechatStatic/cultureTeamDetail.do?cultureTeamId="+dom.cultureTeamId+"\"'>"+
 	   			       "<div class='pic'>"+"<img cultureTeamId="+dom.cultureTeamId+" src=''>"+"</div>"+
 	   			       "<div class='tit'>"+dom.cultureTeamName+"</div>"+
 	   			   "</div>"+
 	   			   "<div class='char'>"+
 	   			       "<p onclick='window.location.href=\"http://www.wenhuayun.cn/wechatStatic/cultureTeamDetail.do?cultureTeamId="+dom.cultureTeamId+"\"'>"+cultureTeamIntro+"<a class='xx' style='font-size:25px;' href='http://www.wenhuayun.cn/wechatStatic/cultureTeamDetail.do?cultureTeamId="+dom.cultureTeamId+"'>详情进入...</a>"+"</p>"+
 	   			       "<a class='diand' href='javascript:;'>"+dom.cultureTeamTown+"</a>"+
 	   			       "<div style='font-size:22px;color:#ccc;margin-top:17px;'>编号："+(listBianhao <= 9 ?'0'+ listBianhao:listBianhao)+"</div>"+
 	   			       "<div class='pt clearfix'>"+
 	   			            voteCountHtml+
 	   			           "<div class='toup "+voteHtml+"' onclick='dcVote(\""+dom.cultureTeamId+"\",this)'>投TA一票"+"<em class='one'>+1</em>"+"</div>"+
 	   			       "</div>"+
 	   			   "</div>"+
 	   			"</div>"+
 	   			"</li>");
 	    }
 		 }); 
 		
 		if(data.length<20){
 			$("#loadingVoteItemDiv").html("");
     	}else{
     		p=0;
     	}
 	},"json");
 }
 
 	
//投票
 function dcVote(cultureTeamId,$this){
 	  if(noVote != 1){  
 	 
 		 if (userId == null || userId == '') {
     		//判断登陆
         	publicLogin("${basePath}wechatStatic/cultureTeamIndex.do");
     	}else{  
     		$.post("${path}/wechatStatic/addVote.do",{userId:userId,cultureTeamId:cultureTeamId}, function (data) {
 				if(data == "100"){
 				    // 投TA一票
 				    	$($this).addClass('current');
 				    	var _shuzi = $($this).parent('.pt').find('.piaos em');
 				    	var num=_shuzi.html();
 				    	if(num=='' || num==undefined){
 				    		num=0;
 				    	}
 				    	_shuzi.html(parseInt(num) + 1);
 				    	/* popUps($('.hundredDoor_info'),'show'); *///可能以后要用(第一次投票的填信息窗口)
 				 }else if(data == "200"){
				    	$($this).addClass('current');
 				    	var _shuzi = $($this).parent('.pt').find('.piaos em');
 				    	var num=_shuzi.html();
 				    	if(num=='' || num==undefined){
 				    		num=0;
 				    	}
 				    	_shuzi.html(parseInt(num) + 1);
 				    	/* popUps($('.hundredDoor_success'),'show'); */
 				}else if(data == "repeat"){
 					 popUps($('.hundredDoor_nostart'),'show');
 				}else if(data == "500"){
 					dialogAlert('系统提示', '投票失败！');
 					
 				}
 			},"json");
     	 } 
 	}else{
 		popUps($('#dialog4'),'show');
 	}
  }
  
  
//添加用户名和手机号
 function saveInfo(){
 	var userMobile = $("#cellphone").val();
 	var userName=$("#userName").val();
 	var telReg = (/^1[34578]\d{9}$/);
 	var Reg  = /^[\s]*$/;
 	if(userMobile == ""){
     	dialogAlert('系统提示', '请输入手机号码！');
         return false;
     }else if(!userMobile.match(telReg)){
     	dialogAlert('系统提示', '请正确填写手机号码！');
         return false;
     }
 	if(userName.match(Reg)){
 		dialogAlert('系统提示', '请输入姓名！');
        return false;
 	}
 	var data = {
 		userId:userId,
 		userTelephone:userMobile,
 		userNickName:userName
 	}
 	
 	if (userId == null || userId == '') {
 		//判断登陆
     	publicLogin("${basePath}wechatStatic/cultureTeamIndex.do");
 	}else{
 		$.post("${path}/terminalUser/editTerminalUser.do", data, function(data) {
 			if (data == "success") {
 				var cultureTeamId=$("#cultureTeamId").val();
 				 $.post("${path}/wechatStatic/insertUserMessage.do",{userId:userId,cellphone:userMobile,userName:userName,cultureTeamId:cultureTeamId},function(){
 					  if(data == "success"){
 						 popUps($('.hundredDoor_info'),'hide',function () {
							  popUps($('.hundredDoor_success'),'show');
						  });
 					  }else{
 						  dialogAlert('系统提示', '保存失败！');
 					  }
 				 })
 			}else {
 				dialogAlert('系统提示', "提交失败")
 			}
 		},"json");
 	}
 }
  
	
//进页面菜单显示
 function menuChange(num) {
 	$('.delivetit li').eq(num).addClass('current');
 }	
	
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
                  		loadCtList(index,20);
           			}
           		},800);
            }
        });   

</script>
</head>

<body>
<!-- 分享的图片 -->
 <div id="indexShareBg" class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
		<img src="${path}/STATIC/wechat/image/commonShare.png" style="width: 100%;height: 100%;" />
 </div>
<div class="hundred_yindy">
    <img class="bg" src="${path}/STATIC/wxStatic/image/hundred/bg.jpg">
    <div style="width: 100%;height: 231px;background: url(${path}/STATIC/wxStatic/image/hundred/icon25.png) no-repeat center;position: absolute;left: 0;bottom: 0;"></div>
    <div class="jiant"></div>
    <img class="wz" src="${path}/STATIC/wxStatic/image/hundred/icon23.png">
    <div class="logo"></div>
    <!-- <div class="fx"></div> -->
</div>

<div class="hundredmain">
	<div class="ban"><img src="${path}/STATIC/wxStatic/image/hundred/ban.jpg"><div class="fx"></div></div>
	<div class="note">
		<div class="jz690"><img src="${path}/STATIC/wxStatic/image/hundred/icon2.png">本次活动共计217支团队参赛，其中：舞蹈45支，音乐52支，戏剧41支，曲艺7支，美书影26支，综合46支。<a href="javascript:;">查询活动规则&nbsp;&gt;&gt;</a></div>
	</div>
	<div class="hunqieh">
		<a class="current" href="${path }/wechatStatic/cultureTeamIndex.do?guide=1&tab=1"><img src="${path}/STATIC/wxStatic/image/hundred/icon3.png">投票页</a>
		<a href="${path }/wechatStatic/cultureTeamRanking.do"><img src="${path}/STATIC/wxStatic/image/hundred/icon4.png">人气榜</a>
	</div>
	<div class="hunTitle">
	<input type="hidden" id="cultureTeamId" name="cultureTeamId"/> 
	<c:choose>
	  <c:when test="${tab=='1'}">
	    <a class="current" href="${path }/wechatStatic/cultureTeamIndex.do?tab=1&guide=1">舞蹈</a>
		<a href="${path }/wechatStatic/cultureTeamIndex.do?tab=2&guide=1">音乐</a>
		<a href="${path }/wechatStatic/cultureTeamIndex.do?tab=3&guide=1">戏剧</a>
		<a href="${path }/wechatStatic/cultureTeamIndex.do?tab=6&guide=1">曲艺</a>
		<a href="${path }/wechatStatic/cultureTeamIndex.do?tab=4&guide=1">美书影</a>
		<a href="${path }/wechatStatic/cultureTeamIndex.do?tab=5&guide=1">综合</a>
	  </c:when>
	  <c:when test="${tab=='2'}">
	    <a href="${path }/wechatStatic/cultureTeamIndex.do?tab=1&guide=1">舞蹈</a>
		<a class="current" href="${path }/wechatStatic/cultureTeamIndex.do?tab=2&guide=1">音乐</a>
		<a href="${path }/wechatStatic/cultureTeamIndex.do?tab=3&guide=1">戏剧</a>
		<a href="${path }/wechatStatic/cultureTeamIndex.do?tab=6&guide=1">曲艺</a>
		<a href="${path }/wechatStatic/cultureTeamIndex.do?tab=4&guide=1">美书影</a>
		<a href="${path }/wechatStatic/cultureTeamIndex.do?tab=5&guide=1">综合</a>
	  </c:when>
	  <c:when test="${tab=='3'}">
	    <a href="${path }/wechatStatic/cultureTeamIndex.do?tab=1&guide=1">舞蹈</a>
		<a href="${path }/wechatStatic/cultureTeamIndex.do?tab=2&guide=1">音乐</a>
		<a class="current" href="${path }/wechatStatic/cultureTeamIndex.do?tab=3&guide=1">戏剧</a>
		<a href="${path }/wechatStatic/cultureTeamIndex.do?tab=6&guide=1">曲艺</a>
		<a href="${path }/wechatStatic/cultureTeamIndex.do?tab=4&guide=1">美书影</a>
		<a href="${path }/wechatStatic/cultureTeamIndex.do?tab=5&guide=1">综合</a>
	  </c:when>
	  <c:when test="${tab=='4'}">
	    <a href="${path }/wechatStatic/cultureTeamIndex.do?tab=1&guide=1">舞蹈</a>
		<a href="${path }/wechatStatic/cultureTeamIndex.do?tab=2&guide=1">音乐</a>
		<a href="${path }/wechatStatic/cultureTeamIndex.do?tab=3&guide=1">戏剧</a>
		<a href="${path }/wechatStatic/cultureTeamIndex.do?tab=6&guide=1">曲艺</a>
		<a class="current" href="${path }/wechatStatic/cultureTeamIndex.do?tab=4&guide=1">美书影</a>
		<a href="${path }/wechatStatic/cultureTeamIndex.do?tab=5&guide=1">综合</a>
	  </c:when>
	  <c:when test="${tab=='5'}">
	    <a href="${path }/wechatStatic/cultureTeamIndex.do?tab=1&guide=1">舞蹈</a>
		<a href="${path }/wechatStatic/cultureTeamIndex.do?tab=2&guide=1">音乐</a>
		<a href="${path }/wechatStatic/cultureTeamIndex.do?tab=3&guide=1">戏剧</a>
		<a href="${path }/wechatStatic/cultureTeamIndex.do?tab=6&guide=1">曲艺</a>
		<a href="${path }/wechatStatic/cultureTeamIndex.do?tab=4&guide=1">美书影</a>
		<a class="current" href="${path }/wechatStatic/cultureTeamIndex.do?tab=5&guide=1">综合</a>
	  </c:when>
	  <c:when test="${tab=='6'}">
	    <a href="${path }/wechatStatic/cultureTeamIndex.do?tab=1&guide=1">舞蹈</a>
		<a href="${path }/wechatStatic/cultureTeamIndex.do?tab=2&guide=1">音乐</a>
		<a href="${path }/wechatStatic/cultureTeamIndex.do?tab=3&guide=1">戏剧</a>
		<a class="current"  href="${path }/wechatStatic/cultureTeamIndex.do?tab=6&guide=1">曲艺</a>
		<a href="${path }/wechatStatic/cultureTeamIndex.do?tab=4&guide=1">美书影</a>
		<a href="${path }/wechatStatic/cultureTeamIndex.do?tab=5&guide=1">综合</a>
	  </c:when>	 
	  <c:otherwise>
	    <a class="current" href="${path }/wechatStatic/cultureTeamIndex.do?tab=1&guide=1">舞蹈</a>
		<a href="${path }/wechatStatic/cultureTeamIndex.do?tab=2&guide=1">音乐</a>
		<a href="${path }/wechatStatic/cultureTeamIndex.do?tab=3&guide=1">戏剧</a>
		<a href="${path }/wechatStatic/cultureTeamIndex.do?tab=6&guide=1">曲艺</a>
		<a href="${path }/wechatStatic/cultureTeamIndex.do?tab=4&guide=1">美书影</a>
		<a href="${path }/wechatStatic/cultureTeamIndex.do?tab=5&guide=1">综合</a>
	  
	  </c:otherwise>	  
	</c:choose>
	</div>
	<ul class="hundredListUl"></ul>
	<div id="loadingVoteItemDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
	<div class="hunfoot">
		<p>主办单位：浦东新区文化艺术指导中心</p>
		<p>此活动最终解释权归浦东新区文化艺术指导中心所有</p>
	</div>
</div>

<!-- 弹窗 -->
<div class="hundredDoorFc" style="display:none;">
    <!-- 投票成功 -->
    <div class="hundredDoor hundredDoor_success" style="display:none;">
        <div class="tit">恭喜您，投票成功！</div>
        <div class="cha close"></div>
        <div class="btnDiv">
            <a class="close" href="javascript:;">看看其他作品</a>
            <a class="huang" href="javascript:;" id="lapiao">赶紧帮TA拉票</a>
        </div>
    </div>
    <!-- 一天只能投一票 -->
    <div class="hundredDoor hundredDoor_nostart" style="display:none;">
        <div class="cont">一个用户每天只能对同一团队投一票</div>
        <div class="cha close"></div>
        <div class="btnDiv">
            <a class="close" href="javascript:;">我知道了</a>
        </div>
    </div>
    <!-- 填写信息弹窗 -->
    <div class="hundredDoor hundredDoor_info" style="display:none;">
        <div class="infotit">请留下您的个人资料</div>
        <table class="infoTable">
            <tr>
                <td class="td1">姓 名</td>
                <td class="td2"><input class="txt" type="text" name="userName" id="userName"></td>
            </tr>
            <tr>
                <td class="td1">手机号</td>
                <td class="td2"><input class="txt" type="text" name="cellphone" id="cellphone"></td>
            </tr>
        </table>
        <div class="infoCont">
            <p>1、为保证投票的公正性，防止恶意刷票，用户首次投票需要登记手机号码</p>
            <p>2、每个用户每天对同一个团队只能投一票</p>
            <p>此规则的最终解释权归上海市群众艺术馆和文化云所有</p>
        </div>
        <div class="btnDiv">
            <a class="close" href="javascript:;">关 闭</a>
            <a class="huang" href="javascript:;" onclick="saveInfo();">提 交</a>
        </div>
    </div>
    <div class="hundredDoor" style="display:none;" id="dialog4">
        <div class="tit">投票已结束</div>
        <div class="cha close"></div>
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