<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·微笔记大赛</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		var startIndex = 0;		//页数
		var isEnd = '${isEnd}';		//是否能参与（1：已结束）
		var isVote = '${isVote}';	//是否能投票（1：已结束）
	
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
			loadData(0,20);
			
			//规则
			$(".zsm-rule").click(function(){
				$('html').css({"overflow": "hidden"});
				$('body').css({"overflow": "hidden"});

				$(".zsm-hdgz-pop").show();
			})
			$(".zsm-hdgz-pop").click(function(){
				$('html').css({"overflow": "auto"});
				$('body').css({"overflow": "auto"});

				$(this).hide()
			})
			
		});
		
		//加载列表
		function loadData(index, pagesize){
			var data = {
                	userId: userId,
                	resultFirst: index,
                	resultSize: pagesize
                };
    		$.post("${path}/wechatStatic/getMicronoteList.do",data, function (data) {
    			if (data.status == 1) {
    				if(data.data.list.length<20){
               			if(data.data.list.length==0&&index==0){
               				$("#loadingDiv").html("<span class='noLoadingSpan'>没有找到合适的结果，换个试试看吧~</span>");
               			}else{
               				$("#loadingDiv").html("");
               			}
   	        		}
    				//还没有人参赛时显示参赛按钮
    				if(data.data.list.length==0){
            			$("#addNote").show();
            			
            			//我要参赛按钮
            			if (!browser.versions.android) {		//非安卓(安卓不识别touchend)
	            			$(document).on("touchmove", function() {
	            				$(".joinMatch").hide()
	            			}).on("touchend", function() {
	            				$(".joinMatch").show()
	            			})
            			}
            		}
                	$.each(data.data.list, function (i, dom) {
                		//显示我要参赛按钮(因为createUser被占用，所以用updateUser)
                		if(i==0&&userId.length>0&&userId!=dom.updateUser){
                			$("#addNote").show();
                			
                			//我要参赛按钮
                			if (!browser.versions.android) {		//非安卓(安卓不识别touchend)
	                			$(document).on("touchmove", function() {
	                				$(".joinMatch").hide()
	                			}).on("touchend", function() {
	                				$(".joinMatch").show()
	                			})
                			}
                		}else if(userId == null || userId == ''){
                			$("#addNote").show();
                			
                			//我要参赛按钮
                			if (!browser.versions.android) {		//非安卓(安卓不识别touchend)
	                			$(document).on("touchmove", function() {
	                				$(".joinMatch").hide()
	                			}).on("touchend", function() {
	                				$(".joinMatch").show()
	                			})
                			}
                		}
                		
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
            			var voteHtml = '';
            			if(dom.noteIsVote==0){
            				voteHtml = "<div class='zsm-cell1'><div><p><img class='userThing' src='${path}/STATIC/wxStatic/image/zsm/thing.png' /><span>"+dom.voteCount+"</span></p></div></div>";
            			}else{
            				voteHtml = "<div class='zsm-cell0'><div><p><img class='userThing' src='${path}/STATIC/wxStatic/image/zsm/thing-on.png' /><span style='color:#999'>"+dom.voteCount+"</span></p></div></div>";
            			}
            			var noteContent = '';
            			if(dom.noteContent.length>42){
            				noteContent = dom.noteContent.substring(0,42)+"...";
            			}else{
            				noteContent = dom.noteContent
            			}
                		$("#noteListUl").append("<li id='"+dom.noteId+"'>" +
                									"<div class='zsm-info'>" +
							        					"<div class='zsm-proj'>" +
							    							"<div class='zsm-proj-img'>"+userHeadImgHtml+"</div>" +
							    							"<p>"+dom.notePublisherName+"</p>" +
							    							"<div style='clear: both;'></div>" +
							    							"<div class='zsm-proj-tag'><p>"+("00"+dom.noteNum).substr(-3)+"</p></div>" +
							    						"</div>" +
							    						"<div class='zsm-detail'>" +
							    							"<p class='zsm-title'>"+dom.noteTitle+"</p>" +
							    							"<p class='zsm-ps'>"+noteContent+"</p>" +
							    							"<input type='hidden' value='"+dom.noteContent+"' />" +
							    						"</div>" +
							    					"</div>" +
						    						"<div class='zsm-btn'>" +
						    							voteHtml+
						    							"<div class='zsm-cell2'>去拉票</div>" +
						    						"</div>" +
						    					"</li>");
                	});
                	
                	//投票
        			$(".zsm-cell1").on("touchstart", function(event) {
        				event.preventDefault();
        				if(isVote == 1){
        					dialogAlert('系统提示', '活动结束，已不能投票！');
        				}else{
        					if (userId == null || userId == '') {
            	        		//判断登陆
            	            	publicLogin("${basePath}wechatStatic/toMicronoteList.do");
            	        	}else{
            	        		$this = $(this);
            					var noteId = $this.parents("li").attr("id");
            					$.post("${path}/wechatStatic/voteMicronote.do",{noteId:noteId,userId:userId}, function (data) {
            						if (data.status == 1) {
            							var voteCount = $this.find("p").text();
            							$this.find("span").text(eval(voteCount)+1);
            							$this.off("touchstart");
            							$this.find(".userThing").attr("src", "${path}/STATIC/wxStatic/image/zsm/thing-on.png")
            							$this.find("span").css("color", "#999")
            							$this.append(
            								"<span class='cellAddOne' style='position:absolute;left:32px;top:4px;color:red;text-align: center;font-size: 26px;width: 180px;'><img src='${path}/STATIC/wxStatic/image/zsm/thing.png'/>+1,积分+1</span>"
            							)
            							$(".cellAddOne").animate({
            								"top": "-100px"
            							}).fadeOut(function() {
            								$(this).remove()
            							})
            						}
            					}, "json");
            	        	}
        				}
        			})

        			//详情
        			$(".zsm-info").click(function() {
        				$('html').css({"overflow": "hidden"});
        				$('body').css({"overflow": "hidden"});
        				
        				$("#detailImg").attr("src",$(this).find(".zsm-proj-img img").attr("src"));
        				$("#detailUser").text($(this).find(".zsm-proj>p").text());
        				$("#detailTitle").text($(this).find(".zsm-title").text());
        				$("#detailContent").text($(this).find("input").val());
        				$(".zsm-detailPop").show();
        			})
        			$(".zsm-closebtn").click(function() {
        				$('html').css({"overflow": "auto"});
        				$('body').css({"overflow": "auto"});

        				$(".zsm-detailPop").hide();
        			})
        			
        			//拉票
        			$(".zsm-cell2").click(function() {
        				var noteId = $(this).parents("li").attr("id");
        				location.href = '${path}/wechatStatic/toMicronoteShare.do?noteId='+noteId;
        			})
    			}
    		}, "json");
		}
		
		//我要参赛
		function addNote(){
			if(isEnd == 1){
				dialogAlert('系统提示', '活动已结束！');
			}else{
				if (userId == null || userId == '') {
	        		//判断登陆
	            	publicLogin("${basePath}wechatStatic/toMicronoteApply.do");
	        	}else{
	        		location.href='${path}/wechatStatic/toMicronoteApply.do';
	        	}
			}
		}
		
		//滑屏分页
        $(window).on("scroll", function () {
            var scrollTop = $(document).scrollTop();
            var pageHeight = $(document).height();
            var winHeight = $(window).height();
            if (scrollTop >= (pageHeight - winHeight - 40)) {
           		startIndex += 20;
           		var index = startIndex;
           		setTimeout(function () { 
   					loadData(index, 20);
           		},800);
            }
        });
		
	</script>
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wx/image/share_120.png"/></div>
	<div class="zsm-main">
		<div class="zsm-top">
			<img src="${path}/STATIC/wxStatic/image/zsm/banner.jpg" />
			<img style="margin-top: 20px;" src="${path}/STATIC/wxStatic/image/zsm/banner2.jpg" onclick="location.href='${path}/information/preInfo.do?informationId=83165260a6d6427b8a975da0f326bd35'"/>
			<div class="zsm-viewranking" onclick="location.href='${path}/wechatStatic/toMicronoteRanking.do'">
				<img src="${path}/STATIC/wxStatic/image/zsm/viewranking.png" />
			</div>
			<div class="zsm-rule">
				<img src="${path}/STATIC/wxStatic/image/zsm/actrule.png" />
			</div>
		</div>
		<div class="zsm-content">
			<img style="margin: 20px 0px;" src="${path}/STATIC/wxStatic/image/zsm/cszp.png" />
			<div class="zsmList">
				<ul id="noteListUl"></ul>
			</div>
			<div id="loadingDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
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
		<div id="addNote" class="joinMatch" onclick="addNote();" style="display: none;">
			<img src="${path}/STATIC/wxStatic/image/zsm/joinmatch.png" />
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