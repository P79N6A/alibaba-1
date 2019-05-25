<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·微笔记大赛</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '市民文化节--云叔喊你来写读书笔记 赢丰富好礼';
	    	appShareDesc = '阅读中的真善美•我的阅读笔记线上“微笔记”征集大赛火热进行中';
	    	appShareImgUrl = '${basePath}/STATIC/wx/image/share_120.png';
	    	appShareLink = '${basePath}/wechatStatic/micronote.do';
	    	
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
					title: "市民文化节--云叔喊你来写读书笔记 赢丰富好礼",
					desc: '阅读中的真善美•我的阅读笔记线上“微笔记”征集大赛火热进行中',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
					link: '${basePath}wechatStatic/micronote.do'
				});
				wx.onMenuShareTimeline({
					title: "阅读中的真善美•我的阅读笔记线上“微笔记”征集大赛火热进行中",
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
					link: '${basePath}wechatStatic/micronote.do'
				});
				wx.onMenuShareQQ({
					title: "市民文化节--云叔喊你来写读书笔记 赢丰富好礼",
					desc: '阅读中的真善美•我的阅读笔记线上“微笔记”征集大赛火热进行中',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
					link: '${basePath}/wechatStatic/micronote.do'
				});
				wx.onMenuShareWeibo({
					title: "市民文化节--云叔喊你来写读书笔记 赢丰富好礼",
					desc: '阅读中的真善美•我的阅读笔记线上“微笔记”征集大赛火热进行中',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
					link: '${basePath}/wechatStatic/micronote.do'
				});
				wx.onMenuShareQZone({
					title: "市民文化节--云叔喊你来写读书笔记 赢丰富好礼",
					desc: '阅读中的真善美•我的阅读笔记线上“微笔记”征集大赛火热进行中',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
					link: '${basePath}/wechatStatic/micronote.do'
				});
			});
		}
		
		$(function () {
			if (userId != null && userId != '') {
				loadSelfDate();
			}
			
			loadDate();
			
			//规则
			$(".zsm-rule").click(function(){
				$(".zsm-hdgz-pop").show()
			})
			$(".zsm-hdgz-pop").click(function(){
				$(this).hide()
			})
			
		});
		
		//加载自己的排名
		function loadSelfDate(){
			$.post("${path}/wechatStatic/getMicronoteByCondition.do",{userId:userId}, function (data) {
				if (data.status == 1) {
					var dom = data.data;
					//头像
        			var userHeadImgHtml = '';
            		var userHeadImgUrl = dom.userHeadImgUrl;
        			if(userHeadImgUrl){
                        if(userHeadImgUrl.indexOf("http") == -1){
                        	userHeadImgUrl = getImgUrl(userHeadImgUrl);
                        }
                        if (userHeadImgUrl.indexOf("http")==-1) {
                        	userHeadImgHtml = "<img src='../STATIC/wx/image/sh_user_header_icon.png'/>";
                        } else if (userHeadImgUrl.indexOf("/front/") != -1) {
                            var imgUrl = getIndexImgUrl(userHeadImgUrl, "_300_300");
                            userHeadImgHtml = "<img src='" + imgUrl + "' onerror='imgNoFind();'/>";
                        } else {
                        	userHeadImgHtml = "<img src='" + userHeadImgUrl + "' onerror='imgNoFind();'/>";
                        }
                    }else{
                    	userHeadImgHtml = "<img src='../STATIC/wx/image/sh_user_header_icon.png'/>";
                    }
        			$("#noteRankingUl").prepend("<li id='"+dom.noteId+"'>" +
						        					"<div class='zsm-me'>" +
						        						"<div class='zsm-meNum'>"+dom.ranking+"</div>" +
						    							"<div class='zsm-meImg DImg'>"+userHeadImgHtml+"</div>" +
						    							"<div class='zsm-meNmae'>" +
						    								"<p class='zsm-meP1 DName'>"+dom.notePublisherName+"</p>" +
						    								"<p class='zsm-meP2 DTitle'>"+dom.noteTitle+"</p>" +
						    								"<input type='hidden' class='noteContent' value='"+dom.noteContent+"'/>" +
						    							"</div>" +
						    							"<div class='zsm-kNum'>" +
						    								"<img src='${path}/STATIC/wxStatic/image/zsm/thing.png' />" +
						    								"<p>"+dom.voteCount+"</p>" +
						    							"</div>" +
						    						"</div>" +
						    					"</li>");
					
					//详情
        			$("#noteRankingUl li").click(function() {
        				$("#detailImg").attr("src",$(this).find(".DImg img").attr("src"));
        				$("#detailUser").text($(this).find(".DName").text());
        				$("#detailTitle").text($(this).find(".DTitle").text());
        				$("#detailContent").text($(this).find(".noteContent").val());
        				$(".zsm-detailPop").show();
        			})
        			$(".zsm-closebtn").click(function() {
        				$(".zsm-detailPop").hide();
        			})
				}
			}, "json");
		}
		
		//加载列表
		function loadDate(){
    		$.post("${path}/wechatStatic/getMicronoteRankingList.do", function (data) {
    			if (data.status == 1) {
                	$.each(data.data, function (i, dom) {
                		//头像
            			var userHeadImgHtml = '';
                		var userHeadImgUrl = dom.userHeadImgUrl;
            			if(userHeadImgUrl){
                            if(userHeadImgUrl.indexOf("http") == -1){
                            	userHeadImgUrl = getImgUrl(userHeadImgUrl);
                            }
                            if (userHeadImgUrl.indexOf("http")==-1) {
                            	userHeadImgHtml = "<img src='../STATIC/wx/image/sh_user_header_icon.png'/>";
                            } else if (userHeadImgUrl.indexOf("/front/") != -1) {
                                var imgUrl = getIndexImgUrl(userHeadImgUrl, "_300_300");
                                userHeadImgHtml = "<img src='" + imgUrl + "' onerror='imgNoFind();'/>";
                            } else {
                            	userHeadImgHtml = "<img src='" + userHeadImgUrl + "' onerror='imgNoFind();'/>";
                            }
                        }else{
                        	userHeadImgHtml = "<img src='../STATIC/wx/image/sh_user_header_icon.png'/>";
                        }
            			var rankingHtml = '';
            			if(i==0){
            				rankingHtml = "<div class='zsm-first'>1</div>";
            			}else if(i==1){
            				rankingHtml = "<div class='zsm-secend'>2</div>";
            			}else if(i==2){
            				rankingHtml = "<div class='zsm-third'>3</div>";
            			}else{
            				rankingHtml = "<div class='zsm-def'>"+(i+1)+"</div>";
            			}
                		$("#noteRankingUl").append("<li id='"+dom.noteId+"'>" +
							        					"<div class='zsm-oth'>" +
							        						rankingHtml+
							    							"<div class='zsm-othImg DImg'>"+userHeadImgHtml+"</div>" +
							    							"<div class='zsm-othNmae'>" +
							    								"<p class='zsm-othP1 DName'>"+dom.notePublisherName+"</p>" +
							    								"<p class='zsm-othP2 DTitle'>"+dom.noteTitle+"</p>" +
							    								"<input type='hidden' class='noteContent' value='"+dom.noteContent+"'/>" +
							    							"</div>" +
							    							"<div class='zsm-kNum'>" +
							    								"<img src='${path}/STATIC/wxStatic/image/zsm/thing.png' />" +
							    								"<p>"+dom.voteCount+"</p>" +
							    							"</div>" +
							    						"</div>" +
							    					"</li>");
                	});
                	
        			//详情
        			$("#noteRankingUl li").click(function() {
        				$("#detailImg").attr("src",$(this).find(".DImg img").attr("src"));
        				$("#detailUser").text($(this).find(".DName").text());
        				$("#detailTitle").text($(this).find(".DTitle").text());
        				$("#detailContent").text($(this).find(".noteContent").val());
        				$(".zsm-detailPop").show();
        			})
        			$(".zsm-closebtn").click(function() {
        				$(".zsm-detailPop").hide();
        			})
    			}
    		}, "json");
		}
		
	</script>
	
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wx/image/share_120.png"/></div>
	<div class="zsm-main">
		<div class="zsm-top">
			<img src="${path}/STATIC/wxStatic/image/zsm/banner.jpg" />
			<div class="zsm-rule">
				<img src="${path}/STATIC/wxStatic/image/zsm/actrule.png" />
			</div>
		</div>
		<div class="zsm-content">
			<div class="zsm-ranking"><img src="${path}/STATIC/wxStatic/image/zsm/cup.png" />
				<p>查看排名</p>
			</div>
			<div class="zsm-rankingList">
				<ul id="noteRankingUl"></ul>
			</div>
		</div>
	</div>
	<!-- 详情框 -->
	<div class="zsm-detailPop">
		<div class="noteRole">
			<div class="zsm-closebtn">
				<img src="${path}/STATIC/wxStatic/image/zsm/closebtn.png" />
			</div>
			<div class="zsm-proj">
				<div class="zsm-proj-img">
					<img id="detailImg" src="" />
				</div>
				<p id="detailUser"></p>
				<div style="clear: both;"></div>
			</div>
			<p class="zsm-detail-title" id="detailTitle"></p>
			<div class="noteRoleDetail">
				<p class="zsm-ps" id="detailContent"></p>
			</div>
		</div>
	</div>
	<!-- 规则框 -->
	<div class="zsm-hdgz-pop">
		<div class="noteRole">
			<div class="noteRoleFont">
				<%@include file="/WEB-INF/why/wechat/static/micronote/micronoteRule.jsp"%>
			</div>
		</div>
	</div>
</body>
</html>