<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·上海当代戏剧节</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css?v=20161021"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		var noControl = '${noControl}'; //1：不可操作
		var startIndex = 0;		//页数
		var dramaId = '${dramaId}';
		var tab = '${tab}';
		
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
        	appShareTitle = '上海当代戏剧节·看完好戏不来说一说？';
        	appShareDesc = '上海艺术节之艺术天空特别策划，全天12小时演出不间断，快来和我一起共享艺术盛宴';
        	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/dramaImg/shareIcon.jpg';
        	appShareLink = '${basePath}/wechatStatic/toDramaDetail.do?dramaId='+dramaId;
        	
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
					title: "安康文化云·上海当代戏剧节·看完好戏不来说一说？",
					desc: '观戏剧，写剧评，分享属于你的“戏如人生”，赢取戏剧节限量礼品。',
					link: '${basePath}wechatStatic/toDramaDetail.do?dramaId='+dramaId,
					imgUrl: '${basePath}/STATIC/wxStatic/image/dramaImg/shareIcon.jpg'
				});
				wx.onMenuShareTimeline({
					title: "安康文化云·上海当代戏剧节·看完好戏不来说一说？",
					imgUrl: '${basePath}/STATIC/wxStatic/image/dramaImg/shareIcon.jpg',
					link: '${basePath}wechatStatic/toDramaDetail.do?dramaId='+dramaId
				});
				wx.onMenuShareQQ({
					title: "安康文化云·上海当代戏剧节·看完好戏不来说一说？",
					desc: '观戏剧，写剧评，分享属于你的“戏如人生”，赢取戏剧节限量礼品。',
					link: '${basePath}/wechatStatic/toDramaDetail.do?dramaId='+dramaId,
					imgUrl: '${basePath}/STATIC/wxStatic/image/dramaImg/shareIcon.jpg'
				});
				wx.onMenuShareWeibo({
					title: "安康文化云·上海当代戏剧节·看完好戏不来说一说？",
					desc: '观戏剧，写剧评，分享属于你的“戏如人生”，赢取戏剧节限量礼品。',
					link: '${basePath}/wechatStatic/toDramaDetail.do?dramaId='+dramaId,
					imgUrl: '${basePath}/STATIC/wxStatic/image/dramaImg/shareIcon.jpg'
				});
				wx.onMenuShareQZone({
					title: "安康文化云·上海当代戏剧节·看完好戏不来说一说？",
					desc: '观戏剧，写剧评，分享属于你的“戏如人生”，赢取戏剧节限量礼品。',
					link: '${basePath}/wechatStatic/toDramaDetail.do?dramaId='+dramaId,
					imgUrl: '${basePath}/STATIC/wxStatic/image/dramaImg/shareIcon.jpg'
				});
			});
		}
		
		$(function () {
			if (tab == null || tab == '') {
				tab = 0;
			}
			
			menuChange(tab);
			
			$.post("${path}/wechatStatic/queryCcpDramalist.do",{userId:userId,sort:2,dramaId:dramaId}, function (data) {
				if(data.length>0){
					var dom = data[0];
					var timeHtml = "";
					$.each(dom.dramaTime.split(","), function (i, time) {
						var periodHtml = "";
						$.each(time.split(".")[1].split("?"), function (j, period) {
							periodHtml += "<div class='dramaTimeTag2'>"+period+"</div>";
						});
						timeHtml += "<li>" +
										"<div style='margin-top: 13px;'>" +
											"<div class='dramaTimeTag1'>"+time.split(".")[0]+"</div>" +
											periodHtml +
											"<div style='clear: both;'></div>" +
										"</div>" +
									"</li>";
					});
					$("#dramaDetail").html("<div style='width: 320px;height: 435px;float: left;'>" +
												"<img src='"+dom.dramaImg+"@300w' width='320' height='435' />" +
											"</div>" +
											"<div class='dramaTime'>" +
												"<p class='dramaTimeTitle'>"+dom.dramaName+"</p>" +
												"<div class='dramaTimePl'>"+dom.dramaTag+"</div>" +
												"<div style='clear: both;'></div>" +
												"<p class='dramaActTime'>演出时间：</p>" +
												"<ul>"+timeHtml+"</ul>" +
												"<p class='dramaActTime'>演出地点：</p>" +
												"<div style='margin-top: 10px;height: 80px;overflow: hidden;'>" +
													"<p style='font-size: 24px;color: #262626;line-height: 40px;'>"+dom.dramaAddress+"</p>" +
												"</div>" +
											"</div>" +
											"<div style='clear: both;'></div>");
					$("#dramaIntro").html(dom.dramaIntro);
					$("#voteCount").html(dom.voteCount);
					if(dom.isVote == 1){
   						$("#dramaVote").find("img").attr("src","${path}/STATIC/wxStatic/image/dramaImg/loveOn.png");
   						$("#dramaVote").attr("onclick","dialogAlert('系统提示', '今日已投票！');");
   					}else{
   						$("#dramaVote").attr("onclick","dramaVote();");
   					}
				}
    		},"json");
			
			loadDramaCommentList(0,10);
			
			//菜单顶部固定
			$(document).on('touchmove', function() {
				if($(document).scrollTop() > 240) {
					$(".dramaMenuList").css('position', 'fixed')
				} else {
					$(".dramaMenuList").css('position', 'relative')
				}
			})
			$(document).on('scroll', function() {
				if($(document).scrollTop() > 240) {
					$(".dramaMenuList").css('position', 'fixed')
				} else{
					$(".dramaMenuList").css('position', 'relative')
				}
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
		
		//加载剧评列表
		function loadDramaCommentList(index, pagesize){
			var data = {
					dramaId: dramaId,
					firstResult: index,
	               	rows: pagesize
	            };
			$.post("${path}/wechatStatic/queryCcpDramaCommentlist.do",data, function (data) {
				if(data.length<10){
           			if(data.length==0&&index==0){
           				$("#loadingDramaCommentDiv").html("");
        				$("#dramaCommentUl").html("<li style='width: 730px;height: 201px;font-size: 36px;text-align: center;line-height: 201px;'>暂无影评</li>");
        			}else{
        				$("#loadingDramaCommentDiv").html("");
        			}
	        	}
				$.each(data, function (i, dom) {
					var userHeadImgHtml = '';
					if(dom.userHeadImgUrl){
		                if(dom.userHeadImgUrl.indexOf("http") == -1){
		                	dom.userHeadImgUrl = getImgUrl(dom.userHeadImgUrl);
		                }
		            }else{
		            	dom.userHeadImgUrl = '';
		            }
					if (dom.userHeadImgUrl.indexOf("http") == -1) {
		            	userHeadImgHtml = "<img src='../STATIC/wx/image/sh_user_header_icon.png'/>";
		            } else if (dom.userHeadImgUrl.indexOf("/front/") != -1) {
		                var imgUrl = getIndexImgUrl(dom.userHeadImgUrl, "_300_300");
		                userHeadImgHtml = "<img src='" + imgUrl + "' onerror='imgNoFind();'/>";
		            } else {
		            	userHeadImgHtml = "<img src='" + dom.userHeadImgUrl + "' onerror='imgNoFind();'/>";
		            }
					$("#dramaCommentUl").append("<li>" +
													"<div class='dramaUser'>" +
														"<div class='dramaUserImg'>"+userHeadImgHtml+"</div>" +
														"<div class='dramaUserDetail'>" +
															"<div class='dramaUserInfo'>" +
																"<div class='dramaUserName'>" +
																	"<p>"+dom.userName+"</p>" +
																	"<p>"+formatTimeStr(dom.createTime)+"</p>" +
																"</div>" +
																"<div style='clear: both;'></div>" +
															"</div>" +
															"<div class='dramaUserComent'>" +
																"<p>"+dom.dramaCommentRemark+"</p>" +
															"</div>" +
														"</div>" +
														"<div style='clear: both;'></div>" +
													"</div>" +
												"</li>");
				});
			},"json");
		}
		
		//投票
		function dramaVote(){
			if(noControl != 1){
				if (userId == null || userId == '') {
	        		//判断登陆
	            	publicLogin("${basePath}wechatStatic/toDramaDetail.do?dramaId="+dramaId);
	        	}else{
	        		$.post("${path}/wechatStatic/addDramaVote.do",{userId:userId,dramaId:dramaId}, function (data) {
	    				if(data == "200"){
	    					var voteCount = $("#voteCount").text();
	    					$("#voteCount").text(eval(voteCount)+1);
	    					$("#dramaVote").find("img").attr("src", "${path}/STATIC/wxStatic/image/dramaImg/loveOn.png");
	    				}else if(data == "repeat"){
	    					dialogAlert('系统提示', '今日已投票！');
	    				}else if(data == "500"){
	    					dialogAlert('系统提示', '投票失败！');
	    				}
	    			},"json");
	        	}
			}else{
				dialogAlert('系统提示', '活动已结束！');
			}
		}
		
		//评论
		function toComment(){
			if(noControl != 1){
				if (userId == null || userId == '') {
	        		//判断登陆
					publicLogin("${basePath}wechatStatic/toDramaDetail.do?dramaId="+dramaId);
	        	}else{
	        		$.post("${path}/wechatStatic/queryCcpDramaUserName.do",{userId:userId}, function (data) {
	        			if(data.length>0){
	        				location.href = '${path}/wechatStatic/toDramaComment.do?dramaId='+dramaId;
	        			}else{
	        				location.href = '${path}/wechatStatic/toDramaUser.do?dramaId='+dramaId;
	        			}
	        		},"json");
	        	}
			}else{
				dialogAlert('系统提示', '活动已结束！');
			}
		}
		
		//进页面菜单显示
		function menuChange(num) {
			$(".dramaMenuList>ul>li>div").removeClass('dramaMenuOn')
			$(".dramaMenuList>ul>li>div").eq(num).addClass('dramaMenuOn')
			$(".dramaContent>ul>li").hide()
			$(".dramaContent>ul>li").eq(num).show()
		}
		
		//日期泛型
		function formatTime(date) {
			//获取到的年月日事件
			var date_get_year = parseInt(date.split('-')[0])
			var date_get_mon = parseInt(date.split('-')[1])
			var date_get_day = parseInt(date.split(' ')[0].split('-')[2])
			var data_get_time = date.split(' ')[1].split(':')
				//当前的年月日时间
			var myDate = new Date()
			var date_now = myDate.toLocaleDateString().split('/')
			var data_now_year = myDate.getFullYear();
			var data_now_mon = myDate.getMonth() + 1;
			var data_now_day = myDate.getDate();

			if(date_get_year == data_now_year && date_get_mon == data_now_mon && date_get_day == data_now_day) {
				if(parseInt(data_get_time[0]) < myDate.getHours()) {
					return myDate.getHours() - parseInt(data_get_time[0]) + '小时前';
				} else {
					return date.split(' ')[1]
				}
			} else {
				return date.split(' ')[0]
			}
		}
		
		//滑屏分页
        $(window).on("scroll", function () {
            var scrollTop = $(document).scrollTop();
            var pageHeight = $(document).height();
            var winHeight = $(window).height();
            if (scrollTop >= (pageHeight - winHeight - 80)) {
           		setTimeout(function () { 
      				startIndex += 10;
              		var index = startIndex;
              		loadDramaCommentList(index,10);
           		},800);
            }
        });
	</script>
	
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wxStatic/image/dramaImg/shareIcon.jpg"/></div>
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
	<div class="dramaMain">
		<img class="keep-button" src="${path}/STATIC/wxStatic/image/hongkouAct/hkshare.png" style="position: absolute;right: 30px;top: 30px;" />
		<img class="share-button" src="${path}/STATIC/wxStatic/image/hongkouAct/hkkeep.png" style="position: absolute;right: 120px;top: 30px;" />
		<div>
			<img src="${path}/STATIC/wxStatic/image/dramaImg/banner.jpg" />
		</div>
		<div class="dramaMenu">
			<div class="dramaMenuList">
				<ul>
					<li onclick="location.href='${path}/wechatStatic/dramaFestival.do'">
						<div>参演节目</div>
					</li>
					<li onclick="location.href='${path}/wechatStatic/dramaFestival.do?tab=1'">
						<div>精彩剧评</div>
					</li>
					<li onclick="location.href='${path}/wechatStatic/dramaFestival.do?tab=2'">
						<div>活动规则</div>
					</li>
					<li onclick="location.href='${path}/wechatStatic/dramaFestival.do?tab=3'">
						<div>排行榜</div>
					</li>
					<div style="clear: both;"></div>
				</ul>
			</div>
		</div>
		<div class="dramaContent">
			<div id="dramaDetail" style="padding: 20px;border-bottom: 10px solid #E1E1E1;"></div>
			<div style="border-bottom: 10px solid #E1E1E1;">
				<div class="dramaTitleDiv">
					<p>简介</p>
				</div>
				<div id="dramaIntro" class="dramaBriefing"></div>
			</div>
			<div>
				<div class="dramaTitleDiv">
					<p>影评</p>
				</div>
				<div style="padding: 0 0 95px 20px;">
					<ul id="dramaCommentUl"></ul>
					<div id="loadingDramaCommentDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
				</div>
			</div>
			<div class="dramaBtoMenu">
				<div class="dbmL">
					<div id="dramaVote" class="dbmLR">
						<div>
							<img src="${path}/STATIC/wxStatic/image/dramaImg/dlove.png" width="24" height="21" />
							<p id="voteCount" style="font-size: 18px;text-align: center;color: #666;"></p>
						</div>
						<div><p>投一票</p></div>
						<div style="clear: both;"></div>
					</div>
					<div class="dbmLL share-button">
						<img src="${path}/STATIC/wxStatic/image/dramaImg/share.png" />
						<p>分享</p>
					</div>
					<div style="clear: both;"></div>
				</div>
				<div class="dbmR" onclick="toComment();">写影评</div>
				<div style="clear: both;"></div>
			</div>
		</div>
	</div>
</body>
</html>