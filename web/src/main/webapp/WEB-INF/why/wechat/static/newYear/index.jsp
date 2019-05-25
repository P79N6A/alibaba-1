<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·带你过最文化的新年</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script type="text/javascript" src="${path}/STATIC/wechat/js/webuploader/webuploader.min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/wechat/js/webuploader/upload-ny.js"></script>
	
	<script>
		$.ajaxSettings.async = false; 	//同步执行ajax
		var noControl = '${noControl}';	//1：不可操作
		var startIndex = 0;		//页数
	
		if (userId == null || userId == '') {
    		//判断登陆
        	publicLogin("${basePath}wechatStatic/nyIndex.do");
    	}
		
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '安康文化云·从圣诞到元宵 带你过最文化的新年！';
	    	appShareDesc = '精彩庆新年文化活动正在热订 新年红包文化福袋放送中！';
	    	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon.jpg';
	    	
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
					title: "安康文化云·从圣诞到元宵 带你过最文化的新年！",
					desc: '精彩庆新年文化活动正在热订 新年红包文化福袋放送中！',
					link: '${basePath}wechatStatic/nyIndex.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon.jpg'
				});
				wx.onMenuShareTimeline({
					title: "安康文化云·从圣诞到元宵 带你过最文化的新年！",
					imgUrl: '${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon.jpg',
					link: '${basePath}wechatStatic/nyIndex.do'
				});
				wx.onMenuShareQQ({
					title: "安康文化云·从圣诞到元宵 带你过最文化的新年！",
					desc: '精彩庆新年文化活动正在热订 新年红包文化福袋放送中！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon.jpg'
				});
				wx.onMenuShareWeibo({
					title: "安康文化云·从圣诞到元宵 带你过最文化的新年！",
					desc: '精彩庆新年文化活动正在热订 新年红包文化福袋放送中！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon.jpg'
				});
				wx.onMenuShareQZone({
					title: "安康文化云·从圣诞到元宵 带你过最文化的新年！",
					desc: '精彩庆新年文化活动正在热订 新年红包文化福袋放送中！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon.jpg'
				});
			});
		}
		
		$(function () {
			
			loadMyImg();
			loadSelectImg('e5b773f8c71a44babc134cbe4e2ce66e,b73c3859e7674ce99e67ad5bb6bcbc86');
			loadNyImg(0,20);
			
			navFixed($(".kjmbNav"),'touchmove',240);
		    navFixed($(".kjmbNav"),'scroll',240);
		    
		    //话题
		    $(".huti span").click(function(){
		    	var nyImgContent = $("#nyImgContent").val();
		    	$("#nyImgContent").val(nyImgContent+$(this).text());
		    });
		    
		  	//关闭图片预览
			$(".imgPreview,.imgPreview>img").click(function() {
				$(".imgPreview").fadeOut("fast");
			})
			
          	//分享
			$(".share-button").click(function() {
				if (!is_weixin()&&!(/wenhuayun/.test(ua))) {
					dialogAlert('系统提示', '请用微信浏览器打开分享！');
				}else{
					$("html,body").addClass("bg-notouch");
					$(".background-fx").css("display", "block")
				}
			})
			$(".background-fx").click(function() {
				$("html,body").removeClass("bg-notouch");
				$(".background-fx").css("display", "none")
			})
			//关注
			$(".keep-button").on("touchstart", function() {
				$('.div-share').show()
				$("body,html").addClass("bg-notouch")
			})
            
		});
		
		//查询自己上传照片
		function loadMyImg(){
			var data = {
            	userId: userId,
            	isMe: 1
            };
			$.post("${path}/wechatStatic/queryNyImgList.do",data, function (data) {
				if(data.length>0){
					$("#userInfo1").show();
					var user = data[0];
					var userHeadImgHtml = getUserHeadImgHtml(user.userHeadImgUrl);
					$("#userInfo1").html("<div class='jz700 clearfix'>" +
							                "<div class='pic'>"+userHeadImgHtml+"</div>" +
							                "<div class='char'>" +
							                    "<p style='margin-top: 12px;'>"+user.userName+"<span onclick='toUserCenter();'>个人中心</span></p>" +
							                    "<p>我已发布了"+data.length+"张照片</p>" +
							                "</div>" +
							                "<div class='icon' onclick='toMyNyImg()'></div>" +
							             "</div>");
					$("#userInfo2").html("<div class='jz700 clearfix'>" +
							                "<div class='pic'>"+userHeadImgHtml+"</div>" +
							                "<div class='char'>" +
							                    "<p style='margin-top: 12px;'>"+user.userName+"<span onclick='toUserCenter();'>个人中心</span></p>" +
							                    "<p>我已发布了"+data.length+"张照片</p>" +
							                "</div>" +
							             "</div>");
					$.each(data, function (i, dom) {
						var userHeadImgHtml = getUserHeadImgHtml(dom.userHeadImgUrl);
						var ImgObj = new Image();
						ImgObj.src = dom.nyImgUrl+"@400w";
						ImgObj.onload = function(){
							if(ImgObj.width/ImgObj.height>310/280){
								var pLeft = (ImgObj.width*(280/ImgObj.height)-310)/2;
								$("img[nyImgId=my"+dom.nyImgId+"]").css({"height":"280px","position":"absolute","left":"-"+pLeft+"px"});
							}else{
								var pTop = (ImgObj.height*(310/ImgObj.width)-280)/2;
								$("img[nyImgId=my"+dom.nyImgId+"]").css({"width":"310px","position":"absolute","top":"-"+pTop+"px"});
							}
						}
						var voteClass = "";
						if(dom.isVote == 1){
							voteClass = "current";
						}
						$("#myImgUl").append("<li>" +
								                "<div class='char'>" +
							                        "<div class='nc clearfix'>" +
							                            "<div class='t1'>"+userHeadImgHtml+"</div>" +
							                            "<div class='t2'>" +
							                                "<h6>"+dom.userName+"</h6>" +
							                                "<p>"+dom.nyImgContent+"</p>" +
							                            "</div>" +
							                        "</div>" +
							                    "</div>" +
							                    "<div class='pic'>" +
							                        "<img nyImgId='my"+dom.nyImgId+"' src='"+dom.nyImgUrl+"@400w' onclick='showPreview(\""+dom.nyImgUrl+"@700w\");'>" +
							                        "<div class='fu clearfix'>" +
							                            "<div class='f1' onclick='location.href=\"${path}/wechatStatic/nyDetail.do?nyImgId="+dom.nyImgId+"\"'>去拉票</div>" +
							                            "<div class='f2 "+voteClass+"' onclick='nyVote(\""+dom.nyImgId+"\",this);'><span></span><v class='voteCount'>"+dom.voteCount+"</v></div>" +
							                        "</div>" +
							                    "</div>" +
							                 "</li>");
					});
				}
			},"json");
		}
		
		//精选照片
		function loadSelectImg(nyImgIds){
			var data = {
            	userId: userId,
            	nyImgIds: nyImgIds
            };
			$.post("${path}/wechatStatic/querySelectNyImgList.do",data, function (data) {
				if(data.length>0){
					$.each(data, function (i, dom) {
						var userHeadImgHtml = getUserHeadImgHtml(dom.userHeadImgUrl);
						var ImgObj = new Image();
						ImgObj.src = dom.nyImgUrl+"@400w";
						ImgObj.onload = function(){
							if(ImgObj.width/ImgObj.height>310/280){
								var pLeft = (ImgObj.width*(280/ImgObj.height)-310)/2;
								$("img[nyImgId=select-"+dom.nyImgId+"]").css({"height":"280px","position":"absolute","left":"-"+pLeft+"px"});
							}else{
								var pTop = (ImgObj.height*(310/ImgObj.width)-280)/2;
								$("img[nyImgId=select-"+dom.nyImgId+"]").css({"width":"310px","position":"absolute","top":"-"+pTop+"px"});
							}
						}
						var voteClass = "";
						if(dom.isVote == 1){
							voteClass = "current";
						}
						$("#selectImgUl").append("<li>" +
								                "<div class='char'>" +
							                        "<div class='nc clearfix'>" +
							                            "<div class='t1'>"+userHeadImgHtml+"</div>" +
							                            "<div class='t2'>" +
							                                "<h6>"+dom.userName+"</h6>" +
							                                "<p>"+dom.nyImgContent+"</p>" +
							                            "</div>" +
							                        "</div>" +
							                    "</div>" +
							                    "<div class='pic'>" +
							                        "<img nyImgId='select-"+dom.nyImgId+"' src='"+dom.nyImgUrl+"@400w' onclick='showPreview(\""+dom.nyImgUrl+"@700w\");'>" +
							                        "<div class='fu clearfix'>" +
							                            "<div class='f1' onclick='location.href=\"${path}/wechatStatic/nyDetail.do?nyImgId="+dom.nyImgId+"\"'>去拉票</div>" +
							                            "<div class='f2 "+voteClass+"' onclick='nyVote(\""+dom.nyImgId+"\",this);'><span></span><v class='voteCount'>"+dom.voteCount+"</v></div>" +
							                        "</div>" +
							                    "</div>" +
							                 "</li>");
					});
				}
			},"json");
		}
		
		//最新照片
		function loadNyImg(index, pagesize){
			var data = {
            	userId: userId,
            	firstResult: index,
               	rows: pagesize
            };
			$.post("${path}/wechatStatic/queryNyImgList.do",data, function (data) {
				if(data.length<20){
        			$("#loadingNyImgDiv").html("");
	        	}
				if(data.length>0){
					$.each(data, function (i, dom) {
						var userHeadImgHtml = getUserHeadImgHtml(dom.userHeadImgUrl);
						var ImgObj = new Image();
						ImgObj.src = dom.nyImgUrl+"@400w";
						ImgObj.onload = function(){
							if(ImgObj.width/ImgObj.height>310/280){
								var pLeft = (ImgObj.width*(280/ImgObj.height)-310)/2;
								$("img[nyImgId="+dom.nyImgId+"]").css({"height":"280px","position":"absolute","left":"-"+pLeft+"px"});
							}else{
								var pTop = (ImgObj.height*(310/ImgObj.width)-280)/2;
								$("img[nyImgId="+dom.nyImgId+"]").css({"width":"310px","position":"absolute","top":"-"+pTop+"px"});
							}
						}
						var voteClass = "";
						if(dom.isVote == 1){
							voteClass = "current";
						}
						$("#nyImgUl").append("<li>" +
								                "<div class='char'>" +
							                        "<div class='nc clearfix'>" +
							                            "<div class='t1'>"+userHeadImgHtml+"</div>" +
							                            "<div class='t2'>" +
							                                "<h6>"+dom.userName+"</h6>" +
							                                "<p>"+dom.nyImgContent+"</p>" +
							                            "</div>" +
							                        "</div>" +
							                    "</div>" +
							                    "<div class='pic'>" +
							                        "<img nyImgId='"+dom.nyImgId+"' src='"+dom.nyImgUrl+"@400w' onclick='showPreview(\""+dom.nyImgUrl+"@700w\");'>" +
							                        "<div class='fu clearfix'>" +
							                            "<div class='f1' onclick='location.href=\"${path}/wechatStatic/nyDetail.do?nyImgId="+dom.nyImgId+"\"'>去拉票</div>" +
							                            "<div class='f2 "+voteClass+"' onclick='nyVote(\""+dom.nyImgId+"\",this);'><span></span><v class='voteCount'>"+dom.voteCount+"</v></div>" +
							                        "</div>" +
							                    "</div>" +
							                 "</li>");
					});
				}
			},"json");
		}
		
		//投票
		function nyVote(nyImgId,$this){
			if(noControl != 1){
				if (userId == null || userId == '') {
	        		//判断登陆
	            	publicLogin("${basePath}wechatStatic/nyIndex.do");
	        	}else{
	        		$.post("${path}/wechatStatic/addNyVote.do",{userId:userId,nyImgId:nyImgId}, function (data) {
	    				if(data == "200"){
	    					$($this).addClass('current');
	   						var count = $($this).find('.voteCount').text();
	   						$($this).find('.voteCount').text(eval(count) + 1);
	    				}else if(data == "repeat"){
	    					dialogAlert('系统提示', '一天只能投一票！');
	    				}else if(data == "500"){
	    					dialogAlert('系统提示', '投票失败！');
	    				}
	    			},"json");
	        	}
			}else{
				dialogAlert('系统提示', '活动已结束！');
			}
		}
		
		//跳转到我的图片
		function toMyNyImg(){
			$('.syxyhide').hide();
			$('.sygerzx').show();
            
			$(".kjmbNav").css('position', 'static');
		}
		
		//即刻参与
		function toUpload(){
			if(noControl != 1){
				if (userId == null || userId == '') {
	        		//判断登陆
	            	publicLogin("${basePath}wechatStatic/nyIndex.do");
	        	}else{
	        		$.post("${path}/wechatStatic/queryNyUser.do", {userId: userId}, function (data) {
	        			if(data.ccpNyUser==null){
	        				$.post("${path}/wechatUser/queryTerminalUserByUserId.do", {userId: userId}, function (data) {
	       						$("#userName").val(data.userNickName);
	               				$("#userMobile").val(data.userTelephone);
	               				// 首页
	               		        $('.syxyhide').hide();
	               		        // 留资页
	               		        $('.syliuzy').show();
	        				}, "json");
	        			}else{
	        				// 首页
	        		        $('.syxyhide').hide();
	        		     	// 上传照片
	        		        $('.lccscphoto').show();
	        		     	
	        		        $("#userUploadImg").val("");
	        		        $("#nyImgContent").val("");
	        		        $("#upPhoto").attr("src","${path}/STATIC/wxStatic/image/roomagekind/pic10.jpg");
	        			}
	        		}, "json");
	        	}
			}else{
				dialogAlert('系统提示', '活动已结束！');
			}
		}
		
		//保存用户
		function userInfo(){
			if (userId == null || userId == '') {
				//判断登陆
				publicLogin("${basePath}wechatStatic/nyIndex.do");
			}else{
				var userName = $("#userName").val();
				if(userName == ""){
			    	dialogAlert('系统提示', '请输入姓名！');
			        return false;
			    }
	    		var userMobile = $("#userMobile").val();
				var telReg = (/^1[34578]\d{9}$/);
				if(userMobile == ""){
			    	dialogAlert('系统提示', '请输入手机号码！');
			        return false;
			    }else if(!userMobile.match(telReg)){
			    	dialogAlert('系统提示', '请正确填写手机号码！');
			        return false;
			    }
				var data = {
					userId:userId,
					userName:userName,
					userMobile:userMobile
				}
				$.post("${path}/wechatStatic/addNyUser.do", data, function(data) {
					if (data == "200") {
						// 留资页
				        $('.syliuzy').hide();
				        // 上传照片
				        $('.lccscphoto').show();
					}else {
						dialogAlert('系统提示', "提交失败")
					}
				},"json");
			}
		}
		
		//保存用户上传图片
		function userUploadImg(){
			$("#uploadBtn").attr("onclick","");
			if (userId == null || userId == '') {
				//判断登陆
				publicLogin("${basePath}wechatStatic/nyIndex.do");
			}else{
				var userUploadImg = $("#userUploadImg").val();
				if(userUploadImg == ""){
			    	dialogAlert('系统提示', '请上传图片！');
			    	$("#uploadBtn").attr("onclick","userUploadImg();");
			        return false;
			    }
				var nyImgContent = $("#nyImgContent").val();
				if(nyImgContent == ""){
			    	dialogAlert('系统提示', '请输入内容！');
			    	$("#uploadBtn").attr("onclick","userUploadImg();");
			        return false;
			    }
				var data = {
					nyImgUrl:userUploadImg,
					userId:userId,
					nyImgContent:nyImgContent
				}
				$.post("${path}/wechatStatic/addNyImg.do",data, function (data) {
					if (data == "1") {
	    				dialogConfirm('系统提示', "提交成功，恭喜获得500文化云积分！",function(){
	    					location.href = '${path}/wechatStatic/nyIndex.do'
	    				});
	    			}else if (data == "200") {
	    				dialogConfirm('系统提示', "提交成功！",function(){
	    					location.href = '${path}/wechatStatic/nyIndex.do'
	    				});
	    			}else{
	    				dialogAlert('系统提示', "提交失败！");
	    				$("#uploadBtn").attr("onclick","userUploadImg();");
	    			}
	    		},"json");
			}
		}
		
		//头像
		function getUserHeadImgHtml(userHeadImgUrl){
			var userHeadImgHtml = '';
			if(userHeadImgUrl){
                if(userHeadImgUrl.indexOf("http") == -1){
                	userHeadImgUrl = getImgUrl(userHeadImgUrl);
                }
            }else{
            	userHeadImgUrl = '';
            }
			if (userHeadImgUrl.indexOf("http") == -1) {
            	userHeadImgHtml = "<img src='../STATIC/wx/image/sh_user_header_icon.png'/>";
            } else if (userHeadImgUrl.indexOf("/front/") != -1) {
                var imgUrl = getIndexImgUrl(userHeadImgUrl, "_300_300");
                userHeadImgHtml = "<img src='" + imgUrl + "' onerror='imgNoFind();'/>";
            } else {
            	userHeadImgHtml = "<img src='" + userHeadImgUrl + "' onerror='imgNoFind();'/>";
            }
			return userHeadImgHtml;
		}
		
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
		
	  	//预览大图
		function showPreview(url){
			$(".imgPreview img").attr("src",url);
			$(".imgPreview").fadeIn("fast");
		}
		
	  	//滑屏分页
        $(window).on("scroll", function () {
            var scrollTop = $(document).scrollTop();
            var pageHeight = $(document).height();
            var winHeight = $(window).height();
            if (scrollTop >= (pageHeight - winHeight - 20)) {
           		setTimeout(function () { 
      				startIndex += 20;
              		var index = startIndex;
              		loadNyImg(index,20);
           		},500);
            }
        });
	</script>
	
	<style>
		html,body {height: 100%;}
		.roomage {min-height: 100%;}
		.webuploader-element-invisible {
			display: none;
		}
		.upPhoto>div:nth-last-child(2) {
			width: 580px;
			height: 510px;
		}
		.roomage .lccscphoto .huti span{padding: 6px 10px;margin-left: 11px;}
	</style>
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon.jpg"/></div>
	<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
		<img src="${path}/STATIC/wechat/image/commonShare.png" style="width: 100%;height: 100%;" />
	</div>
	<div class="div-share">
		<div class="share-bg"></div>
		<div class="share">
			<img src="${path}/STATIC/wechat/image/wx-er2.png" />
			<p style="margin-top: 310px;">扫一扫&nbsp;关注文化云</p>
			<p>更多精彩活动、场馆等你发现</p>
			<button type="button" onclick="$('.div-share').hide();$('body,html').removeClass('bg-notouch')">关闭</button>
		</div>
	</div>
	
	<div class="roomage">
		<div class="lccbanner">
			<img src="${path}/STATIC/wxStatic/image/roomagekind/ban1.jpg" width="750" height="250">
			<ul class="lccshare clearfix">
				<li class="share-button"><a href="javascript:;">分享</a></li>
				<li class="keep-button"><a href="javascript:;">关注</a></li>
			</ul>
		</div>
		<div class="kjmbNav_wc">
			<ul class="kjmbNav clearfix">
				<li class="current"><a href="${path}/wechatStatic/nyIndex.do">首页</a></li>
				<li><a href="${path}/wechatStatic/nyRanking.do">排行榜</a></li>
				<li><a href="${path}/wechatStatic/nyRule.do">活动规则</a></li>
				<li><a href="${path}/wechatStatic/nyAward.do">中奖名单</a></li>
			</ul>
		</div>
	    <!-- 首页 -->
	    <div class="syxyhide">
	        <div class="sywenz jz700"><p>　　正月十五，正是一个中国年的华丽尾声。闹花灯的习俗始于西汉，兴盛于隋唐。这一天街头巷尾，红灯高挂，有宫灯、兽头灯、走马灯、花卉灯、鸟禽灯等等，吸引着观灯的群众。
童年拉过的兔子灯，少年见过的灯火阑珊处的那人，一家人闹过的热气蒸腾的花灯盛会，都是每一个中国人珍藏的记忆。晒晒身边关于闹元宵的一切，文化过新年最高潮的时刻到了！
	        </p></div>
        	<div id="userInfo1" class="personlable" style="display: none;"></div>
	        <div class="syList jz700">
	            <div class="sytitxian"><span>精　选</span></div>
	            
	            <ul id="selectImgUl" class="syListUl clearfix"></ul>
	            
	            <div class="sytitxian"><span>最　新</span></div>
	            <ul id="nyImgUl" class="syListUl clearfix"></ul>
	            <div id="loadingNyImgDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
	        </div>
	        <div class="roomjkcy" onclick="toUpload();"><a href="javascript:;">即 刻<br>参 与</a></div>
	        <a href="http://ct.wenhuayun.cn/template/activityTopicDetail.do?topicid=41" style="display:block;width:150px;height:166px;background:url(${path}/STATIC/wxStatic/image/roomagekind/hdzhc.png) no-repeat center;position: fixed;bottom:135px;right:10px;"></a>
	    </div>
	    <!-- 留资页 -->
	    <div class="roomcont jz700 syliuzy" style="display: none;">
	        <div class="jz645">
	            <div class="jinhaotit">
	                <div class="h1">#&nbsp;&nbsp;我要参赛&nbsp;&nbsp;#</div>
	                <div class="h2">请先填写参赛资料</div>
	            </div>
	            <div class="lccliuzy">
	                <div class="lccshuru">
	                    <span>姓名</span>
	                    <input class="txt" id="userName" type="text" maxlength="20">
	                </div>
	                <div class="lccshuru">
	                    <span>手机</span>
	                    <input class="txt" id="userMobile" type="text" maxlength="20">
	                </div>
	                <p>请正确填写个人信息，如您获得奖项，您提交的信息将作为领奖依据，一经提交不可修改。</p>
	                <div class="lccnextbu" onclick="userInfo();">下一步</div>
	            </div>
	        </div>
	    </div>
	    <!-- 上传照片 -->
	    <div class="lccscphoto jz700" style="display: none;">
	        <div class="lccPhotoDiv" style="width: 580px;height: 510px;">
	        	<input type="hidden" id="userUploadImg"/>
	            <div class="upPhoto uploadClass" style="width: 580px;height: 510px;background-color: #7c7c7c;">
	                <img id="upPhoto" src="${path}/STATIC/wxStatic/image/roomagekind/pic10.jpg" style="max-height: 510px;max-width: 580px;display: block;margin: auto;position: absolute;left:0;top:0;right:0;bottom:0; "/>
	            </div>
	        </div>
	        <div class="huti">
	            <span>#元宵节#</span>
	            <span>#闹花灯#</span>
	            <span>#习俗#</span>
	            <span>#兔子灯#</span>
	            <span>#吃汤圆#</span>
	        </div>
	        <textarea id="nyImgContent" class="lcctxtarea" placeholder="请输入文字..." maxlength="100"></textarea>
	        <div id="uploadBtn" class="lccnextbu" onclick="userUploadImg();">提 交</div>
	    </div>
	    <!-- 个人中心 -->
	    <div class="sygerzx" style="display: none;">
	        <div id="userInfo2" class="personlable"></div>
	        <div class="jz700" style="background-color:#fff;padding:24px 0;">
	            <ul id="myImgUl" class="syListUl clearfix"></ul>
	        </div>
	    </div>
	</div>
	<!--点击放大图片-->
	<div class="imgPreview" style="display: none;">
		<img src="" />
	</div>
</body>
</html>