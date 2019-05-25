<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>文化广场</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
	
	<script>
		var startIndex = 0;		//页数
	
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '文化云广场-汇聚全中国文化最新动态';
	    	appShareDesc = '文化动态尽在掌握  文艺活动一网打尽 文化大师百家讲坛';
	    	appShareImgUrl = '${basePath}/STATIC/wx/image/share_120.png';
	    	
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
					title: "文化云广场-汇聚全中国文化最新动态",
					desc: '文化动态尽在掌握  文艺活动一网打尽 文化大师百家讲坛',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
				wx.onMenuShareTimeline({
					title: "文化云广场-汇聚全中国文化最新动态",
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
				wx.onMenuShareQQ({
					title: "文化云广场-汇聚全中国文化最新动态",
					desc: '文化动态尽在掌握  文艺活动一网打尽 文化大师百家讲坛',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
				wx.onMenuShareWeibo({
					title: "文化云广场-汇聚全中国文化最新动态",
					desc: '文化动态尽在掌握  文艺活动一网打尽 文化大师百家讲坛',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
				wx.onMenuShareQZone({
					title: "文化云广场-汇聚全中国文化最新动态",
					desc: '文化动态尽在掌握  文艺活动一网打尽 文化大师百家讲坛',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
			});
		}
		
		$(function () {
			if (!/wenhuayun/.test(ua)) {		//APP端
				$(".newMenuBTN").show();
			}
			
			loadData(0,20);
			
			//底部菜单
        	if (!browser.versions.android) {		//非安卓(安卓不识别touchend)
        		$(document).on("touchmove", function() {
    				$(".footer").hide()
    			}).on("touchend", function() {
    				$(".footer").show()
    			})
        	}
			$(".newMenuBTN").click(function() {
				$(".newMenuList").animate({
					"bottom": "0px"
				})
			})
			$(".newMenuCloseBTN>img").click(function() {
				var height = $(".newMenuList").width();
				$(".newMenuList").animate({
					"bottom": "-"+height+"px"
				})
			})
			//回到顶部按钮显示
			$(window).scroll(function() {
				var screenheight = $(window).height() * 2
				if ($(document).scrollTop() > screenheight) {
					$(".totop").show()
				} else {
					$(".totop").hide()
				}
			})
		});
		
		//首页活动加载
        function loadData(index, pagesize) {
       		$.post("${path}/wechatStatic/getCultureSquareList.do",{firstResult:index,rows:pagesize,userId:userId}, function (data) {
       			if(data.length<20){
        			$("#loadingDiv").html("");
        		}
       			$.each(data, function (i, dom) {
       				var commentType;
       				var wantgoType;
       				var subjectNameHtml = "";
       				var imgUrlHtml;
       				var onclickHtml = "";
       				var infoHtml = "";
       				var descHtml = "";
       				if(dom.type == 1){	//活动
       					commentType = 2;
       					wantgoType = 2;
       					imgUrlHtml = getImgHtml(dom.squareId,getIndexImgUrl(getImgUrl(dom.ext0), "_750_500"),dom.type);
       					infoHtml = "<p class='quareActInfoName'>"+dom.ext1+"</p>";
       					var time = dom.ext3.split("-");
       					if(time[0] == time[1]){
       						descHtml = "<p class='quareActInfoPlace'>"+time[0]+"&nbsp;|&nbsp;"+dom.ext2+"</p>";
       					}else{
       						descHtml = "<p class='quareActInfoPlace'>"+dom.ext3+"&nbsp;|&nbsp;"+dom.ext2+"</p>";
       					}
       					onclickHtml = "toActDetail(\""+dom.outId+"\")";
       				}else if(dom.type == 2){	//专题活动(城市名片、我在现场、文化新年、行走故事)
       					commentType = 4;
       					wantgoType = 7;
       					imgUrlHtml = getImgHtml(dom.squareId,dom.ext0,dom.type);
       					infoHtml = "<p class='quareActInfoName'>"+dom.ext1+"</p>";
       					if(dom.ext2 == 1){	//城市名片
       						subjectNameHtml = "<div class='squareActTitle'><p>丈量上海·城市名片</p></div>";
       						onclickHtml = "toDetailPage(\"${basePath}/wechatFunction/cityDetail.do?cityImgId="+dom.outId+"\")";
       					}else if(dom.ext2 == 2){		//我在现场
       						subjectNameHtml = "<div class='squareActTitle'><p>文化直播·我在现场</p></div>";
       						onclickHtml = "toDetailPage(\"${basePath}/wechatStatic/sceneDetail.do?sceneImgId="+dom.outId+"\")";
       					}else if(dom.ext2 == 3){		//文化新年
       						subjectNameHtml = "<div class='squareActTitle'><p>文化新年</p></div>";
       						onclickHtml = "toDetailPage(\"${basePath}/wechatStatic/nyDetail.do?nyImgId="+dom.outId+"\")";
       					}else if(dom.ext2 == 4){		//行走故事
       						subjectNameHtml = "<div class='squareActTitle'><p>我们的行走故事</p></div>";
       						onclickHtml = "toDetailPage(\"${basePath}/wechatStatic/walkDetail.do?walkImgId="+dom.outId+"\")";
       					}
       				}else if(dom.type == 3){	//通知
       					commentType = 9;
       					wantgoType = 8;
       					imgUrlHtml = getImgHtml(dom.squareId,dom.ext0,dom.type);
       					subjectNameHtml = "<div class='squareActTitle'><p>"+dom.ext1+"</p></div>";
       					onclickHtml = "toDetailPage(\""+dom.ext3+"\")";
       					infoHtml = "<p class='quareActInfoName'>"+dom.ext2+"</p>";
       				}else if(dom.type == 6){		//图文直播
       					commentType = 10;
       					wantgoType = 9;
       					imgUrlHtml = getImgHtml(dom.squareId,dom.ext0,dom.type);
       					subjectNameHtml = "<div class='squareActTitle'><p>"+dom.ext1+"</p></div>";
       					onclickHtml = "toDetailPage(\"${basePath}/wechatLive/liveActivity.do?liveActivityId="+dom.outId+"\")";
       					infoHtml = "<p class='quareActInfoName'>"+dom.ext2+"</p>";
       				}
       				
       				//头像
       				var headUrlHtml = "";
       				if(dom.headUrl){
       					headUrlHtml = "<div class='squareTitleImg'>"+getUserHeadImgHtml(dom.headUrl)+"</div>";
       				}
       				//评论
       				var commentHtml = "";
       				$.each(dom.commentList, function (j, dom2) {
       					commentHtml += "<li>" +
											"<label>"+dom2.commentUserName+"：</label>" +
											"<span>"+dom2.commentRemark+"</span>" +
									   "</li>";
       				});
       				var commentStyle = "";
       				if(dom.commentList.length==0){
       					commentStyle = "style='display:none;'"
       				}
       				//点赞
       				var isWantHtml = "<img src='${path}/STATIC/wxStatic/image/square/brvOff.png' />";
       				if(dom.userIsWant > 0){
       					isWantHtml = "<img src='${path}/STATIC/wxStatic/image/square/brvOn.png' />";
       				}
       				//置顶
       				var topClass = (dom.top == 1?'squareOnTop':'');
          			$("#activityUl").append("<li class='"+topClass+"' style='line-height: 44px;'>" +
						       					"<div class='squareActPush'>" +
						    						"<div class='squareTitle'>" +
						    							headUrlHtml +
						    							"<div class='squareTitleFont'>" +
						    								"<p class='squareTFP1'>"+dom.userName+"</p>" +
						    								"<p class='squareTFP2'><span>"+formatTimeStr(dom.publishTime)+"</span>"+dom.contextDec+"</p>" +
						    							"</div>" +
						    							"<div style='clear: both;'></div>" +
						    						"</div>" +
						    						subjectNameHtml +
						    						"<div class='quareActImg' onclick='"+onclickHtml+"'>"+imgUrlHtml+"</div>" +
						    						"<div class='quareActInfo'>" +
						    							infoHtml + descHtml +
						    						"</div>" +
						    						"<div class='squareUserDeed'>" +
						    							"<div class='squareUserText'>" +
						    								"<img src='${path}/STATIC/wxStatic/image/square/write.png' />" +
						    								"<span>"+dom.commentCount+"</span>" +
						    							"</div>" +
						    							"<div class='squareUserLove' onclick='addWantGo(\""+dom.outId+"\","+wantgoType+",$(this));'>" +
						    								isWantHtml +
						    								"<span>"+dom.wantCount+"</span>" +
						    							"</div>" +
						    							"<div style='clear: both;'></div>" +
						    						"</div>" +
						    						"<div class='squareInput'>" +
						    							"<input type='text' />" +
						    							"<div class='squareSendBtn' onclick='addComment(\""+dom.outId+"\","+commentType+",$(this))'>发布</div>" +
						    							"<div style='clear: both;'></div>" +
						    						"</div>" +
						    						"<div class='squareCommentList' "+commentStyle+">" +
						    							"<div class='squareArrow'></div>" +
						    							"<ul>"+commentHtml+"</ul>" +
						    						"</div>" +
						    					"</div>" +
						    				"</li>");
       			});
       			
       			$(".squareUserText").click(function(e) {
       				if (userId == null || userId == '') {
       	              	//判断登陆
       	            	publicLogin("${basePath}wechatStatic/cultureSquare.do",1);
       	            }else{
       	            	$(this).parent().next(".squareInput").toggle();
        				$(this).parent().next(".squareInput").find('input').val("");
        				$(this).parent().next(".squareInput").find('input').focus();
       	            }
    			})
       		}, "json");
		}
		
      	//列表图片
		function getImgHtml(imgId,imgUrl,type){
			var imgUrls = imgUrl.split(";");
			var imgType = 1;	//1张图
			if(imgUrls.length > 1 && imgUrls.length <= 3){	//2、3张图
				imgType = 2;
			}else if(imgUrls.length > 3){	//大于3张图
				imgType = 3;
			}
			var imgHtml = "<div class='clearfix pictrue_"+imgType+"'>";
			$.each(imgUrls, function (i, dom) {
				var imgWidth = 720;
				var imgHeigth = 480;
				if(imgType == 2){
					imgWidth = 230;
					imgHeigth = 185;
				}else if(imgType == 3){
					if(i == 0){
						imgWidth = 468;
						imgHeigth = 379;
					}else{
						imgWidth = 240;
						imgHeigth = 185;
					}
				}
				if(type != 1){	//非活动图片
					dom = dom+"@700w";
				}
				var ImgObj = new Image();
				ImgObj.src = dom;
				ImgObj.onload = function(){
					if(imgType == 1 && (ImgObj.width/ImgObj.height)<1.6 && (ImgObj.width/ImgObj.height)>0.4){	//不作处理
						if(ImgObj.width/ImgObj.height<1){
							$("img[imgId="+imgId+i+"]").css("height","720px");
						}else{
							$("img[imgId="+imgId+i+"]").css("width","720px");
						}
					}else{
						if(imgType == 1){	//1张图时按宽高比做不同处理
							if(ImgObj.width/ImgObj.height<1){
								cityImgWidth = 480;
								cityImgHeigth = 720;
							}else{
								cityImgWidth = 720;
								cityImgHeigth = 480;
							}
							$("img[imgId="+imgId+i+"]").parent(".item").css({"height":cityImgHeigth+"px","width":cityImgWidth+"px"});
						}
						if(ImgObj.width/ImgObj.height>imgWidth/imgHeigth){
							var pLeft = (ImgObj.width*(imgHeigth/ImgObj.height)-imgWidth)/2;
							$("img[imgId="+imgId+i+"]").css({"height":imgHeigth+"px","position":"absolute","left":"-"+pLeft+"px"});
						}else{
							var pTop = (ImgObj.height*(imgWidth/ImgObj.width)-imgHeigth)/2;
							$("img[imgId="+imgId+i+"]").css({"width":imgWidth+"px","position":"absolute","top":"-"+pTop+"px"});
						}
					}
				}
				if(imgType == 3 && i > 1){
					imgHtml += "<div class='item'><img imgId='"+imgId+i+"' src='"+dom+"'><div class='outstrip'>+"+eval(imgUrls.length-2)+"</div></div>";
					return false;
				}else{
					imgHtml += "<div class='item'><img imgId='"+imgId+i+"' src='"+dom+"'></div>";
				}
			});
			imgHtml += "</div>"
			return imgHtml;
		}
		
      	//跳转到详情页
        function toDetailPage(url){
      		if(url){
      			if (window.injs) {		//APP端
            		injs.accessDetailPageByApp(url);
            	}else{
            		location.href = url;
            	}
      		}
        }
      	
      	//点赞（我想去）
        function addWantGo(relateId,wantgoType,$this) {
            if (userId == null || userId == '') {
              	//判断登陆
            	publicLogin("${basePath}wechatStatic/cultureSquare.do",1);
            }else{
            	$.post("${path}/wechatUser/addUserWantgo.do", {
            		relateId: relateId,
                    userId: userId,
                    type: wantgoType
                }, function (data) {
                    if (data.status == 0) {
                        var wantCount = $this.find("span").text();
                        $this.find("span").text(eval(wantCount)+1);
                        $this.find("img").attr('src', '${path}/STATIC/wxStatic/image/square/brvOn.png');
                    } else if (data.status == 14111) {
                        $.post("${path}/wechatUser/deleteUserWantgo.do", {
                        	relateId: relateId,
                            userId: userId
                        }, function (data) {
                            if (data.status == 0) {
                                var wantCount = $this.find("span").text();
                                $this.find("span").text(eval(wantCount)-1);
                                $this.find("img").attr('src', '${path}/STATIC/wxStatic/image/square/brvOff.png');
                            }
                        }, "json");
                    }
                }, "json");
            }
        }
      	
      	//添加评论
        function addComment(commentRkId,commentType,$this) {
            if (userId == null || userId == '') {
            	//判断登陆
            	publicLogin("${basePath}wechatStatic/cultureSquare.do",1);
            } else {
            	var commentRemark = $this.parent().find("input").val();
        		if(commentRemark.trim()==""){
        			dialogAlert('评论提示', '评论内容不能为空！');
        			return;
        		}
        		if(commentRemark.length<4){
        			dialogAlert('评论提示', '评论内容不能少于4个字！');
        			return;
        		}
        		
        		data = {
    					commentUserId:userId,
    					commentRemark:commentRemark,
    					commentType:commentType,
    					commentRkId:commentRkId
    			};
        		$.post("${path}/wechat/addComment.do",data, function(data) {
        			if(data.status==0){
        				loadComment(commentRkId,commentType,$this);
        				$this.parent().prev(".squareUserDeed").find(".squareUserText").click();
        			}else{
        				dialogAlert('评论提示', data.data);
        			}
        		},"json");
            }
        }
      	
      	//评论列表
        function loadComment(commentRkId,commentType,$this) {
            var data = {
                moldId: commentRkId,
                type: commentType,
                pageIndex: 0,
                pageNum: 5
            };
            $.post("${path}/wechat/weChatComment.do", data, function (data) {
                if (data.status == 0) {
                	$this.parent().next(".squareCommentList").find("ul").html("");
                	var commentHtml = "";
                	$.each(data.data, function (i, dom) {
                		$this.parent().next(".squareCommentList").show();
       					commentHtml += "<li>" +
											"<label>"+dom.commentUserNickName+"：</label>" +
											"<span>"+dom.commentRemark+"</span>" +
									   "</li>";
       				});
                	$this.parent().next(".squareCommentList").find("ul").html(commentHtml);
                }
            }, "json");
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
		
      	//滑屏分页
        $(window).on("scroll", function () {
            var scrollTop = $(document).scrollTop();
            var pageHeight = $(document).height();
            var winHeight = $(window).height();
            if (scrollTop >= (pageHeight - winHeight - 10)) {
           		startIndex += 20;
           		var index = startIndex;
           		setTimeout(function () { 
   					loadData(index, 20);
           		},200);
            }
        });
	</script>
	
	<style>
		body {background-color: #f2f2f2;}
	</style>
</head>

<body>
	<div class="squareMain">
		<%-- <div class="squareBanner">
			<img src="${path}/STATIC/wxStatic/image/square/banner.jpg" />
		</div>
		<div class="squareMenu">
			<div class="squareMenuBtn">
				<img src="${path}/STATIC/wxStatic/image/square/1.jpg" />
			</div>
			<div class="squareMenuBtn">
				<img src="${path}/STATIC/wxStatic/image/square/2.jpg" />
			</div>
			<div class="squareMenuBtn">
				<img src="${path}/STATIC/wxStatic/image/square/3.jpg" />
			</div>
			<div class="squareMenuBtn">
				<img src="${path}/STATIC/wxStatic/image/square/4.jpg" />
			</div>
			<div class="squareMenuBtn">
				<img src="${path}/STATIC/wxStatic/image/square/5.jpg" />
			</div>
			<div class="squareMenuBtn">
				<img src="${path}/STATIC/wxStatic/image/square/6.jpg" />
			</div>
			<div style="clear: both;"></div>
		</div> --%>
		<div class="squareActList">
			<ul id="activityUl"></ul>
			<div id="loadingDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
		</div>
			<%@include file="/WEB-INF/why/wechat/footerMenuList.jsp" %>
	</div>
</body>
</html>