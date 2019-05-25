<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·乡土文化大展现场直播</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css?v=20161021"/>
	<script type="text/javascript" src="${path}/STATIC/wechat/js/webuploader/webuploader.min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/wechat/js/webuploader/upload-live.js"></script>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		var liveType = 3;	//直播类别
		var tagNum = 0;	//当前所在标签
		var startIndex = 0;		//页数
		var startIndex2 = 0;		//页数(互动专区)
		var userRealName = '';		//用于判断用户是否填写过个人信息
		var liveUserId = '';	//用户更新用户数据
	
		if (userId == null || userId == '') {
			//判断登陆
	    	publicLogin('${basePath}wechatStatic/liveText.do');
		}
	
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
        	appShareTitle = '现场直播 | 精彩跨界演出邀您探访海派文化脉络';
        	appShareDesc = '海上寻源，揭晓市民眼中的100个上海乡土文化符号，颁奖典礼正在直播...';
        	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/live/shareIcon3.jpg';
        	
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
					title: "现场直播 | 精彩跨界演出邀您探访海派文化脉络",
					desc: '海上寻源，揭晓市民眼中的100个上海乡土文化符号，颁奖典礼正在直播...',
					link: '${basePath}wechatStatic/liveText.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/live/shareIcon3.jpg'
				});
				wx.onMenuShareTimeline({
					title: "现场直播 | 精彩跨界演出邀您探访海派文化脉络",
					imgUrl: '${basePath}/STATIC/wxStatic/image/live/shareIcon3.jpg',
					link: '${basePath}wechatStatic/liveText.do'
				});
				wx.onMenuShareQQ({
					title: "现场直播 | 精彩跨界演出邀您探访海派文化脉络",
					desc: '海上寻源，揭晓市民眼中的100个上海乡土文化符号，颁奖典礼正在直播...',
					imgUrl: '${basePath}/STATIC/wxStatic/image/live/shareIcon3.jpg'
				});
				wx.onMenuShareWeibo({
					title: "现场直播 | 精彩跨界演出邀您探访海派文化脉络",
					desc: '海上寻源，揭晓市民眼中的100个上海乡土文化符号，颁奖典礼正在直播...',
					imgUrl: '${basePath}/STATIC/wxStatic/image/live/shareIcon3.jpg'
				});
				wx.onMenuShareQZone({
					title: "现场直播 | 精彩跨界演出邀您探访海派文化脉络",
					desc: '海上寻源，揭晓市民眼中的100个上海乡土文化符号，颁奖典礼正在直播...',
					imgUrl: '${basePath}/STATIC/wxStatic/image/live/shareIcon3.jpg'
				});
			});
		}
		
		$(function () {
			loadUserInfo();
			loadLiveTopMessage();
			loadLiveMessage(0,20);
			
			//循环直播
			setInterval(
				function(){
					startIndex = 0;
					$("#liveMessageUl").html("");
					loadLiveMessage(0,20);
				}
			,1000*30);
			
			//顶部菜单fixed
			$(document).scroll(function() {
				if($(document).scrollTop() >= 250) {
					$(".zhibo .zbNav").css("position", "fixed")
				} else if($(document).scrollTop() < 250) {
					$(".zhibo .zbNav").css("position", "relative")
				}
			});

			//标签切换
			$('.zhibo .zbNav li').bind('click', function() {
				$('.zhibo .zbNav li').removeClass('current');
				$(this).addClass('current');

				$('.zhibo .zbcont_wc').show();
				$('.zhibo .joinAct').hide();
				$('.zhibo .bcTakePhoto').hide();

				$('.zhibo .zbcont_wc .zbcont').hide();
				$('.zhibo .zbcont_wc .zbcont').eq($(this).index()).show();
				
				//重新判断tab标签位置
				if($(document).scrollTop() >= 250) {
					$(".zhibo .zbNav").css("position", "fixed")
				} else if($(document).scrollTop() < 250) {
					$(".zhibo .zbNav").css("position", "relative")
				}
				
				if($(this).index()==1){	//互动专区
					tagNum = 1;
					startIndex2 = 0;	
					$("#userImgListUl").html("");
					loadUserImgList(0,20);
				}else{	//图文直播
					tagNum = 0;
				}
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
		
		//保存用户初始信息
		function loadUserInfo(){
			$.post("${path}/wechatStatic/saveLiveUserInfo.do",{userId:userId,liveActivity:liveType}, function (data) {
    			if (data.status == 1) {
    				userRealName = data.data.userRealName!=null?data.data.userRealName:'';
    				liveUserId = data.data.liveUserId;
    				if(data.data.userIsLike == 1){
    					$('.zhibo .dibu .db_1 div').addClass('current');
    				}else{
    					$('.zhibo .dibu .db_1 div').attr("onclick","userLike();");
    				}
    				$("#likeSum").text(data.data.isLikeSum);
    				
    				// 点击我在也现场按钮 --> 我也在现场页面
    				$('.zhibo .dibu .db_2').bind('click', function() {
    					if(data.data.userUploadImg){
    						location.href='${path}/wechatStatic/liveShare.do?liveUserId='+data.data.liveUserId;
        				}else{
        					if(userRealName.length>0){
        						$('.zhibo .zbcont_wc').hide();
        						$('.zhibo .joinAct').hide();
        						$('.zhibo .bcTakePhoto').show();
        					}else{
        						$('.zhibo .zbcont_wc').hide();
        						$('.zhibo .joinAct').show();
        						$('.zhibo .bcTakePhoto').hide();
        					}
        				}
    				});
    			}else{
    				dialogAlert('系统提示', data.msg.errmsg);
    			}
    		},"json");
		}
		
		//加载直播
		function loadLiveMessage(index, pagesize){
			var data = {
				messageActivity: liveType,
				messageIsTop:0,
               	resultFirst: index,
               	resultSize: pagesize
            };
			$.post("${path}/wechatStatic/getLiveMessageList.do",data, function (data) {
				if (data.status == 1) {
					if(data.data.list.length<20){
               			$("#loadingLiveMessageDiv").html("");
   	        		}
					$.each(data.data.list, function (i, dom) {
						var messageImgHtml = "";
						if(dom.messageImg){
							var messageImg = dom.messageImg.split(",");
							$.each(messageImg, function (j, imgDom) {
								messageImgHtml += "<p><img src='"+imgDom+"'></p>";
							});
						}
						$("#liveMessageUl").append("<li class='clearfix'>" +
											"<div class='pic'><img src='${path}/STATIC/wechat/image/whylogo.jpg' width='74' height='7'></div>" +
											"<div class='char'>" +
												"<div class='w1'>云叔在现场</div>" +
												"<div class='w2'>"+formatTimestamp(dom.messageCreateTime/1000).substring(11,16)+"</div>" +
												"<p>"+dom.messageContent+"</p>" +
												messageImgHtml +
											"</div>" +
									  "</li>");
					});
				}
			},"json");
		}
		
		//加载用户图片列表
		function loadUserImgList(index, pagesize){
			var data = {
				liveActivity:liveType,
				userId: userId,
               	resultFirst: index,
               	resultSize: pagesize
            };
			$.post("${path}/wechatStatic/getLiveUserImgList.do",data, function (data) {
				if (data.status == 1) {
					if(data.data.list.length<20){
               			$("#loadingUserImgListDiv").html("");
   	        		}
					$.each(data.data.list, function (i, dom) {
						var isMeHtml = "";
						if(userId == dom.userId){
							isMeHtml = "<a class='wdxc' href='javascript:;'>我的现场</a>";
						}
						var userHeadImgHtml = '';
						if(dom.userHeadImgUrl){
			                if(dom.userHeadImgUrl.indexOf("http") == -1){
			                	dom.userHeadImgUrl = getImgUrl(dom.userHeadImgUrl);
			                }
			            }else{
			            	dom.userHeadImgUrl = '';
			            }
						if (dom.userHeadImgUrl.indexOf("http") == -1) {
			            	userHeadImgHtml = "<img src='../STATIC/wx/image/sh_user_header_icon.png' width='74' height='74'/>";
			            } else if (dom.userHeadImgUrl.indexOf("/front/") != -1) {
			                var imgUrl = getIndexImgUrl(dom.userHeadImgUrl, "_300_300");
			                userHeadImgHtml = "<img src='" + imgUrl + "' onerror='imgNoFind();' width='74' height='74'/>";
			            } else {
			            	userHeadImgHtml = "<img src='" + dom.userHeadImgUrl + "' onerror='imgNoFind();' width='74' height='74'/>";
			            }
						var ImgObj = new Image();
						ImgObj.src = dom.userUploadImg;
						ImgObj.onload = function(){
    						if(ImgObj.width/ImgObj.height>345/257){
    							$("img[imgId="+dom.liveUserId+"]").css("height","257px");
    						}else{
    							$("img[imgId="+dom.liveUserId+"]").css("width","345px");
    						}
						}
						$("#userImgListUl").append("<li>" +
														"<div class='pic' onclick='showPreview(\""+dom.userUploadImg+"@700w\");'><img imgId='"+dom.liveUserId+"' src='"+dom.userUploadImg+"@300w'>"+isMeHtml+"</div>" +
														"<div class='char clearfix'>" +
															"<div class='d1'>"+userHeadImgHtml+"</div>" +
															"<div class='d2'>"+dom.userName+"</div>" +
															"<div class='d3'>" +
																"<a href='${path}/wechatStatic/liveShare.do?liveUserId="+dom.liveUserId+"'>分享</a>" +
															"</div>" +
														"</div>" +
													"</li>");
					});
				}
			},"json");
		}
		
		//加载活动预告
		function loadLiveTopMessage(){
			var data = {
				messageActivity: liveType,
				messageIsTop:1
            };
			$.post("${path}/wechatStatic/getLiveMessageList.do",data, function (data) {
				if (data.status == 1) {
					if(data.data.list.length>0){
						var dom = data.data.list[0];
						$("#liveTopMessage").html(formatTimestamp(dom.messageCreateTime/1000).substring(11,16)+"  "+dom.messageContent);
					}
				}
			},"json");
		}
		
		//点赞
		function userLike(){
			$('.zhibo .dibu .db_1 div').attr("onclick","");
			if (userId == null || userId == '') {
				//判断登陆
		    	publicLogin('${basePath}wechatStatic/liveText.do');
			}else{
				$.post("${path}/wechatStatic/saveLiveUserInfo.do",{userId:userId,liveActivity:liveType,userIsLike:1,liveUserId:liveUserId}, function (data) {
	    			if (data.status == 1) {
	    				var likeSum = $("#likeSum").text();
	    				$("#likeSum").text(eval(likeSum)+1);
	    				$('.zhibo .dibu .db_1 div').addClass('current');
	    			}else{
	    				$('.zhibo .dibu .db_1 div').attr("onclick","userLike();");
	    				dialogAlert('系统提示', "点赞失败！");
	    			}
	    		},"json");
			}
		}
		
		//保存用户
		function userInfo(){
			if (userId == null || userId == '') {
				//判断登陆
		    	publicLogin('${basePath}wechatStatic/liveText.do');
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
					liveActivity:liveType,
					userRealName:userName,
					userTelephone:userMobile,
					userId:userId,
					liveUserId:liveUserId
				}
				$.post("${path}/wechatStatic/saveLiveUserInfo.do",data, function (data) {
	    			if (data.status == 1) {
    					$('.zhibo .zbcont_wc').hide();
	    				$('.zhibo .joinAct').hide();
	    				$('.zhibo .bcTakePhoto').show();
	    			}else{
	    				dialogAlert('系统提示', "提交失败！");
	    			}
	    		},"json");
			}
		}
		
		//保存用户上传图片
		function userUploadImg(){
			if (userId == null || userId == '') {
				//判断登陆
		    	publicLogin('${basePath}wechatStatic/liveText.do');
			}else{
				var userUploadImg = $("#userUploadImg").val();
				if(userUploadImg == ""){
			    	dialogAlert('系统提示', '请上传图片！');
			        return false;
			    }
				var data = {
					liveActivity:liveType,
					userUploadImg:userUploadImg,
					userId:userId,
					liveUserId:liveUserId
				}
				$.post("${path}/wechatStatic/saveLiveUserInfo.do",data, function (data) {
	    			if (data.status == 1) {
	    				dialogConfirm('系统提示', "提交成功！",function(){
	    					//显示互动专区
	    					$('.zhibo .zbNav li').removeClass('current');
	    					$('.zhibo .zbNav li').eq(1).addClass('current');
	    					$('.zhibo .zbcont_wc .zbcont').hide();
	    					$('.zhibo .zbcont_wc .zbcont').eq(1).show();
	    					
	    					startIndex2 = 0;	
	    					$("#userImgListUl").html("");
	    					loadUserImgList(0,20);
	    					
	    					$('.zhibo .zbcont_wc').show();
		    				$('.zhibo .joinAct').hide();
		    				$('.zhibo .bcTakePhoto').hide();
	    				});
	    			}else{
	    				dialogAlert('系统提示', "提交失败！");
	    			}
	    		},"json");
			}
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
           			if(tagNum==0){
           				startIndex += 20;
                   		var index = startIndex;
           				loadLiveMessage(index,20);
           			}else if(tagNum==1){
           				startIndex2 += 20;
                   		var index = startIndex2;
           				loadUserImgList(index,20);
           			}
           		},800);
            }
        });
	</script>
	
	<style>
		html,body {
			font-family: arial, \5FAE\8F6F\96C5\9ED1, \9ED1\4F53, \5b8b\4f53, sans-serif;
			-webkit-text-size-adjust: none;
		}
		img {
			vertical-align: middle;
		}
		.webuploader-element-invisible {
			display: none;
		}
		.bcUpPhoto>div:nth-last-child(2) {
			width: 700px;
			height: 600px;
		}
	</style>
	
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wxStatic/image/live/shareIcon3.jpg"/></div>
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
	<div class="zhibo">
		<div class="zbban">
			<img src="${path}/STATIC/wxStatic/image/live/ban3.jpg" width="750" height="250">
			<ul class="lccshare clearfix">
				<li>
					<a class="share-button" href="javascript:;">分享</a>
				</li>
				<li>
					<a class="keep-button" href="javascript:;">关注</a>
				</li>
			</ul>
		</div>
		<div style="width:100%;height:90px;display: none;">
			<ul class="zbNav clearfix">
				<li class="current">
					<a href="javascript:;">图文直播</a>
				</li>
				<li>
					<a href="javascript:;">互动专区</a>
				</li>
			</ul>
		</div>

		<div class="zbcont_wc">
			<div class="zbcont twzb" style="display:block;">
				<div class="tgtit"><img src="${path}/STATIC/wxStatic/image/live/icon2.png">活动预告：<span id="liveTopMessage"></span></div>
				<ul class="jz700" id="liveMessageUl"></ul>
				<div id="loadingLiveMessageDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
			</div>
			<div class="zbcont hdzq">
				<ul class="clearfix" id="userImgListUl"></ul>
				<div id="loadingUserImgListDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
			</div>
			<div class="dibu_wc" style="display: none;">
				<div class="dibu clearfix">
					<div class="db_1"><div></div><span id="likeSum">0</span></div>
					<div class="db_2">我也在现场</div>
				</div>
			</div>
		</div>

		<!-- 我也在现场 -->
		<div class="joinAct">
			<p style="text-align: center;font-size: 32px;">#&nbsp;我也在现场&nbsp;#</p>
			<p style="text-align: center;font-size: 24px;margin-top: 20px;color:#808080;">留下你的现场图片<br>即可前往文化云服务台领取精美礼品一份</p>
			<div class="userInfoInput">
				<div class="bcUserName">
					<span class="inputTitle">姓名</span><input id="userName" type="text" class="inputText" maxlength="20">
				</div>
				<div class="bcUserPhone">
					<span class="inputTitle">手机</span><input id="userMobile" type="text" class="inputText" maxlength="20">
				</div>
				<p style="width: 580px;margin: auto;font-size: 18px;margin-top: 30px;">
					活动规则：<br> 1. 发布现场照片，即可至活动现场文化云服务台领取精美礼品一份。<br> 2. 每个用户仅限参加一次，重复参加无效。<br> 3. 礼品仅限前500名，先到先得，领完即止。<br> 4. 仅限2016年10月23日“艺游嬉梦”特别活动现场当日领奖，逾期无效。
				</p>
				<div class="nextBtn" onclick="userInfo();">下一步</div>
			</div>
		</div>

		<!-- 上传照片 -->
		<div class="bcTakePhoto">
			<div class="bcUpPhotoDiv">
				<input type="hidden" id="userUploadImg"/>
				<div class="bcUpPhoto uploadClass" style="width: 700px;height: 600px;background-color: #7c7c7c;">
					<img id="upPhoto" src="${path}/STATIC/wxStatic/image/beautyCity/upPhoto.png" style="max-height: 600px;max-width: 700px;display: block;margin: auto;position: absolute;left:0;top:0;right:0;bottom:0; "/>
				</div>
			</div>
			<div class="bcSubmit" onclick="userUploadImg();">提&nbsp;交</div>
		</div>
		
		<!--点击放大图片-->
		<div class="imgPreview" style="display: none;">
			<img src="" />
		</div>
	</div>
</body>
</html>