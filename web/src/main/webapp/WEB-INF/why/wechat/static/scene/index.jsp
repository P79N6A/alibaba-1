<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·我在现场</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<%@include file="/WEB-INF/why/common/aliImageFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css?v=01061228"/>
	
	<script>
		var noControl = 0;	//1：不可操作
		var venueId = '${venueId}';
		var startIndex = 0;		//页数
	
		if (userId == null || userId == '') {
    		//判断登陆
        	publicLogin("${basePath}wechatStatic/sceneIndex.do");
    	}
		
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '安康文化云·互动赢积分，分享活动现场 展现艺术生活';
	    	appShareDesc = '将你真实感受到的精彩活动现场分享给更多人，精彩就会远远大于你的感受';
	    	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon2.jpg';
	    	
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
				jsApiList: ['previewImage','onMenuShareAppMessage','onMenuShareTimeline','onMenuShareQQ','onMenuShareWeibo','onMenuShareQZone']
			});
			wx.ready(function () {
				wx.onMenuShareAppMessage({
					title: "安康文化云·互动赢积分，分享活动现场 展现艺术生活",
					desc: '将你真实感受到的精彩活动现场分享给更多人，精彩就会远远大于你的感受',
					link: '${basePath}wechatStatic/sceneIndex.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon2.jpg'
				});
				wx.onMenuShareTimeline({
					title: "安康文化云·互动赢积分，分享活动现场 展现艺术生活",
					imgUrl: '${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon2.jpg',
					link: '${basePath}wechatStatic/sceneIndex.do'
				});
				wx.onMenuShareQQ({
					title: "安康文化云·互动赢积分，分享活动现场 展现艺术生活",
					desc: '将你真实感受到的精彩活动现场分享给更多人，精彩就会远远大于你的感受',
					imgUrl: '${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon2.jpg'
				});
				wx.onMenuShareWeibo({
					title: "安康文化云·互动赢积分，分享活动现场 展现艺术生活",
					desc: '将你真实感受到的精彩活动现场分享给更多人，精彩就会远远大于你的感受',
					imgUrl: '${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon2.jpg'
				});
				wx.onMenuShareQZone({
					title: "安康文化云·互动赢积分，分享活动现场 展现艺术生活",
					desc: '将你真实感受到的精彩活动现场分享给更多人，精彩就会远远大于你的感受',
					imgUrl: '${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon2.jpg'
				});
			});
		}
		
		$(function () {
			
			aliUploadImg('sceneImgWebupload', getSceneUrls, 1, true, 'H5');
			
			//swiper初始化div
		    initSwiper();
			
			//场馆标签
			if(venueId){
				$("#venueTagUl li").each(function(){
					if($(this).attr("venueId") == venueId){
						$(this).addClass("current");
					}
				});
			}else{
				$("#venueTagUl li:eq(0)").addClass("current");
			}
			
			loadMyImg();
			loadSceneImg(0,20);
			
			navFixed($(".kjmbNav"),'touchmove',240);
		    navFixed($(".kjmbNav"),'scroll',240);
		    
		    //上传选择场馆标签
		    $('.syhouLable_p li').bind('click', function () {
		        $(this).parent().find('li').removeClass('current');
		        $(this).addClass('current');
		        $("#venueId").val($(this).attr("venueId"));
		    });
		    
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
		
		//上传回调
        function getSceneUrls(up, file, info) {
        	var filePath = "http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info;
        	$("#userUploadImg").val(filePath);
        	$("#upPhoto").attr("src",filePath);
		}
		
		//查询自己上传照片
		function loadMyImg(){
			var data = {
            	userId: userId,
            	isMe: 1
            };
			$.post("${path}/wechatStatic/querySceneImgList.do",data, function (data) {
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
							                "<div class='icon' onclick='toMySceneImg()'></div>" +
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
						ImgObj.src = dom.sceneImgUrl+"@400w";
						ImgObj.onload = function(){
							if(ImgObj.width/ImgObj.height>310/280){
								var pLeft = (ImgObj.width*(280/ImgObj.height)-310)/2;
								$("img[sceneImgId=my"+dom.sceneImgId+"]").css({"height":"280px","position":"absolute","left":"-"+pLeft+"px"});
							}else{
								var pTop = (ImgObj.height*(310/ImgObj.width)-280)/2;
								$("img[sceneImgId=my"+dom.sceneImgId+"]").css({"width":"310px","position":"absolute","top":"-"+pTop+"px"});
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
							                                "<p>"+dom.sceneImgContent+"</p>" +
							                            "</div>" +
							                        "</div>" +
							                    "</div>" +
							                    "<div class='pic'>" +
							                        "<img sceneImgId='my"+dom.sceneImgId+"' src='"+dom.sceneImgUrl+"@400w' onclick='previewImg(\""+dom.sceneImgUrl+"\",\""+dom.sceneImgUrl+"\")'>" +
							                        "<div class='fu clearfix'>" +
							                            "<div class='f1' onclick='location.href=\"${path}/wechatStatic/sceneDetail.do?sceneImgId="+dom.sceneImgId+"\"'>去拉票</div>" +
							                            "<div class='f2 "+voteClass+"' onclick='sceneVote(\""+dom.sceneImgId+"\",this);'><span></span><v class='voteCount'>"+dom.voteCount+"</v></div>" +
							                        "</div>" +
							                    "</div>" +
							                 "</li>");
					});
				}
			},"json");
		}
		
		//最新照片
		function loadSceneImg(index, pagesize){
			var data = {
            	userId: userId,
            	sceneImgVenueId: venueId,
            	firstResult: index,
               	rows: pagesize
            };
			$.post("${path}/wechatStatic/querySceneImgList.do",data, function (data) {
				if(data.length<20){
        			$("#loadingSceneImgDiv").html("");
	        	}
				if(data.length>0){
					$.each(data, function (i, dom) {
						var userHeadImgHtml = getUserHeadImgHtml(dom.userHeadImgUrl);
						var ImgObj = new Image();
						ImgObj.src = dom.sceneImgUrl+"@400w";
						ImgObj.onload = function(){
							if(ImgObj.width/ImgObj.height>310/280){
								var pLeft = (ImgObj.width*(280/ImgObj.height)-310)/2;
								$("img[sceneImgId="+dom.sceneImgId+"]").css({"height":"280px","position":"absolute","left":"-"+pLeft+"px"});
							}else{
								var pTop = (ImgObj.height*(310/ImgObj.width)-280)/2;
								$("img[sceneImgId="+dom.sceneImgId+"]").css({"width":"310px","position":"absolute","top":"-"+pTop+"px"});
							}
						}
						var voteClass = "";
						if(dom.isVote == 1){
							voteClass = "current";
						}
						$("#sceneImgUl").append("<li>" +
								                "<div class='char'>" +
							                        "<div class='nc clearfix'>" +
							                            "<div class='t1'>"+userHeadImgHtml+"</div>" +
							                            "<div class='t2'>" +
							                                "<h6>"+dom.userName+"</h6>" +
							                                "<p>"+dom.sceneImgContent+"</p>" +
							                            "</div>" +
							                        "</div>" +
							                    "</div>" +
							                    "<div class='pic'>" +
							                        "<img sceneImgId='"+dom.sceneImgId+"' src='"+dom.sceneImgUrl+"@400w' onclick='previewImg(\""+dom.sceneImgUrl+"\",\""+dom.sceneImgUrl+"\")'>" +
							                        "<div class='fu clearfix'>" +
							                            "<div class='f1' onclick='location.href=\"${path}/wechatStatic/sceneDetail.do?sceneImgId="+dom.sceneImgId+"\"'>去拉票</div>" +
							                            "<div class='f2 "+voteClass+"' onclick='sceneVote(\""+dom.sceneImgId+"\",this);'><span></span><v class='voteCount'>"+dom.voteCount+"</v></div>" +
							                        "</div>" +
							                    "</div>" +
							                 "</li>");
					});
				}
			},"json");
		}
		
		//投票
		function sceneVote(sceneImgId,$this){
			if(noControl != 1){
				if (userId == null || userId == '') {
	        		//判断登陆
	            	publicLogin("${basePath}wechatStatic/sceneIndex.do");
	        	}else{
	        		$.post("${path}/wechatStatic/addSceneVote.do",{userId:userId,sceneImgId:sceneImgId}, function (data) {
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
		function toMySceneImg(){
			$('.syxyhide').hide();
			$('.sygerzx').show();
            
			$(".kjmbNav").css('position', 'static');
		}
		
		//即刻参与
		function toUpload(){
			if(noControl != 1){
				if (userId == null || userId == '') {
	        		//判断登陆
	            	publicLogin("${basePath}wechatStatic/sceneIndex.do");
	        	}else{
	        		$.post("${path}/wechatStatic/querySceneUser.do", {userId: userId}, function (data) {
	        			if(data.ccpSceneUser==null){
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
	        		        $("#sceneImgContent").val("");
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
				publicLogin("${basePath}wechatStatic/sceneIndex.do");
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
				$.post("${path}/wechatStatic/addSceneUser.do", data, function(data) {
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
				publicLogin("${basePath}wechatStatic/sceneIndex.do");
			}else{
				var userUploadImg = $("#userUploadImg").val();
				if(userUploadImg == ""){
			    	dialogAlert('系统提示', '请上传图片！');
			    	$("#uploadBtn").attr("onclick","userUploadImg();");
			        return false;
			    }
				var sceneImgVenueId = $("#venueId").val();
				if(sceneImgVenueId == ""){
			    	dialogAlert('系统提示', '请选择场馆！');
			    	$("#uploadBtn").attr("onclick","userUploadImg();");
			        return false;
			    }
				var sceneImgContent = $("#sceneImgContent").val();
				if(sceneImgContent == ""){
			    	dialogAlert('系统提示', '请输入内容！');
			    	$("#uploadBtn").attr("onclick","userUploadImg();");
			        return false;
			    }
				var data = {
					sceneImgUrl:userUploadImg,
					userId:userId,
					sceneImgContent:sceneImgContent,
					sceneImgVenueId:$("#venueId").val()
				}
				$.post("${path}/wechatStatic/addSceneImg.do",data, function (data) {
					if (data == "1") {
	    				dialogConfirm('系统提示', "提交成功，恭喜获得100文化云积分！",function(){
	    					location.href = '${path}/wechatStatic/sceneIndex.do'
	    				});
	    			}else if (data == "2") {
	    				dialogConfirm('系统提示', "提交成功，恭喜获得200文化云积分！",function(){
	    					location.href = '${path}/wechatStatic/sceneIndex.do'
	    				});
	    			}else if (data == "200") {
	    				dialogConfirm('系统提示', "提交成功！",function(){
	    					location.href = '${path}/wechatStatic/sceneIndex.do'
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
		
	  	//滑屏分页
        $(window).on("scroll", function () {
            var scrollTop = $(document).scrollTop();
            var pageHeight = $(document).height();
            var winHeight = $(window).height();
            if (scrollTop >= (pageHeight - winHeight - 20)) {
           		setTimeout(function () { 
      				startIndex += 20;
              		var index = startIndex;
              		loadSceneImg(index,20);
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
		.moxie-shim{width:100%!important;height:100%!important;}
	    .syhouLable_wc {width: 670px;margin: 0 auto;overflow: hidden;padding-top: 45px;padding-bottom:25px;}
	    .syhouLable {margin-right: -23px;}
	    .syhouLable li {float: left;background-color: #83affe;font-size: 26px;color: #fff;height: 40px;line-height: 40px;overflow: hidden;margin-right: 23px;margin-bottom: 23px;padding: 0 10px;
	        -webkit-border-radius: 6px;-moz-border-radius: 6px;-o-border-radius: 6px;border-radius: 6px;
	    }
	    .syhouLable li.current {background-color: #f35555;}
	    .roomage .personlable {margin-bottom: 25px;}
	</style>
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wxStatic/image/roomagekind/shareIcon2.jpg"/></div>
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
			<img src="${path}/STATIC/wxStatic/image/roomagekind/wzxchead.jpg" width="750" height="250">
			<ul class="lccshare clearfix">
				<li class="share-button"><a href="javascript:;">分享</a></li>
				<li class="keep-button"><a href="javascript:;">关注</a></li>
			</ul>
		</div>
		<div class="kjmbNav_wc">
			<ul class="kjmbNav clearfix">
				<li class="current"><a href="${path}/wechatStatic/sceneIndex.do">首页</a></li>
				<li><a href="${path}/wechatStatic/sceneRanking.do">排行榜</a></li>
				<li><a href="${path}/wechatStatic/sceneRule.do">活动规则</a></li>
				<li><a href="${awardUrl}">获奖名单</a></li>
			</ul>
		</div>
	    <!-- 首页 -->
	    <div class="syxyhide">
	    	<div class="syhouLable_wc">
	            <ul class="syhouLable clearfix" id="venueTagUl">
	                <li onclick="location.href='${path}/wechatStatic/sceneIndex.do'">全部</li>
	                <li onclick="location.href='${path}/wechatStatic/sceneIndex.do?venueId=561d99fbd51f44bba25b287843c8d023'" venueId="561d99fbd51f44bba25b287843c8d023">长宁文化艺术中心</li>
	                <li onclick="location.href='${path}/wechatStatic/sceneIndex.do?venueId=beefece0d02642a0b81509474049e49c'" venueId="beefece0d02642a0b81509474049e49c">东方艺术中心</li>
	                <li onclick="location.href='${path}/wechatStatic/sceneIndex.do?venueId=23dc8d7b046a40e2abf0ee398f5b85b4'" venueId="23dc8d7b046a40e2abf0ee398f5b85b4">三山会馆</li>
	                <li onclick="location.href='${path}/wechatStatic/sceneIndex.do?venueId=5e8739f0511b4caeb05c974273b83b96'" venueId="5e8739f0511b4caeb05c974273b83b96">上海市群众艺术馆</li>
	                <li onclick="location.href='${path}/wechatStatic/sceneIndex.do?venueId=2f579b2d7acd497f9ded78df0542d182'" venueId="2f579b2d7acd497f9ded78df0542d182">中华艺术宫</li>
	                <li onclick="location.href='${path}/wechatStatic/sceneIndex.do?venueId=05f6b63b4e5e4b2e95139099a8c08ce1'" venueId="05f6b63b4e5e4b2e95139099a8c08ce1">上海博物馆</li>
	                <li onclick="location.href='${path}/wechatStatic/sceneIndex.do?venueId=0'" venueId="0">其他</li>
	            </ul>
	        </div>
        	<div id="userInfo1" class="personlable" style="display: none;"></div>
	        <div class="syList jz700" style="padding:24px 0;">
	            <ul id="sceneImgUl" class="syListUl clearfix"></ul>
	            <div id="loadingSceneImgDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
	        </div>
	        <div class="roomjkcy" onclick="toUpload();"><a href="javascript:;">即 刻<br>参 与</a></div>
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
	        <div id="sceneImgWebupload" class="lccPhotoDiv" style="width: 580px;height: 510px;">
	        	<input type="hidden" id="userUploadImg"/>
	            <div class="upPhoto" style="width: 580px;height: 510px;background-color: #7c7c7c;">
	                <img id="upPhoto" src="${path}/STATIC/wxStatic/image/roomagekind/pic10.jpg" style="max-height: 510px;max-width: 580px;display: block;margin: auto;position: absolute;left:0;top:0;right:0;bottom:0; "/>
	            </div>
	            <div id="container" class="upPhoto" style="width: 580px;height: 510px;z-index: 100;"><div id="selectfiles2" style="width: 580px;height: 510px;" /></div></div>
	        	<!-- 自定义放置图片，隐藏原有图片容器 -->
	        	<ul id="ossfile2" style="display: none;"></ul>
	        </div>
	        <div class="syhouLable_wc">
	            <ul class="syhouLable clearfix syhouLable_p">
	                <li venueId="561d99fbd51f44bba25b287843c8d023">长宁文化艺术中心 </li>
	                <li venueId="beefece0d02642a0b81509474049e49c">东方艺术中心 </li>
	                <li venueId="23dc8d7b046a40e2abf0ee398f5b85b4">三山会馆 </li>
	                <li venueId="5e8739f0511b4caeb05c974273b83b96">上海市群众艺术馆 </li>
	                <li venueId="2f579b2d7acd497f9ded78df0542d182">中华艺术宫 </li>
	                <li venueId="05f6b63b4e5e4b2e95139099a8c08ce1">上海博物馆 </li>
	                <li venueId="0">其他 </li>
	            </ul>
	        </div>
	        <input type="hidden" id="venueId"/>
	        <textarea id="sceneImgContent" class="lcctxtarea" placeholder="请输入文字..." maxlength="100"></textarea>
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
</body>
</html>