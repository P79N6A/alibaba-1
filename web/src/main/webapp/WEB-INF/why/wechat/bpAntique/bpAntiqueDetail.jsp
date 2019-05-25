<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/normalize.css"/>

		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/hsStyle.css"/>
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/swiper-3.3.1.min.css"/>
		<%--<link rel="stylesheet" href="${path}/STATIC/wechat/css/bpColorCtrl.css" />--%>
		<script type="text/javascript" src="${path}/STATIC/wechat/js/jquery-2.1.4.min.js"></script>
		<script type="text/javascript" src="${path}/STATIC/wechat/js/swiper-3.3.1.jquery.min.js"></script>
		<title>安康文化云</title>
		<style>
			.swiper-pagination-bullet{
				width: 12px;height: 12px;border: 1px solid #fff;
				background-color: #000;opacity: .5;
			}
			.swiper-pagination-bullet-active{
				background-color: #fff;
				opacity: 1;
			}
		</style>
		<script type="text/javascript">
		var phoneWidth = parseInt(window.screen.width);
		var phoneScale = phoneWidth / 750;
		var ua = navigator.userAgent; //浏览器类型
		if(/Android (\d+\.\d+)/.test(ua)) { //判断是否是安卓系统
			var version = parseFloat(RegExp.$1); //安卓系统的版本号
			if(version > 2.3) {
				document.write('<meta name="viewport" content="width=750, minimum-scale = ' + phoneScale + ', maximum-scale = ' + (phoneScale) + ', target-densitydpi=device-dpi">');
			} else {
				document.write('<meta name="viewport" content="width=750, target-densitydpi=device-dpi">');
			}
		} else {
			document.write('<meta name="viewport" content="width=750, user-scalable=no, target-densitydpi=device-dpi">');
		}
		 if (is_weixin()) {
	            wx.config({
	                debug: false,
	                appId: '${sign.appId}',
	                timestamp: '${sign.timestamp}',
	                nonceStr: '${sign.nonceStr}',
	                signature: '${sign.signature}',
	                jsApiList: ['previewImage','onMenuShareAppMessage','onMenuShareTimeline','onMenuShareQQ','onMenuShareWeibo','onMenuShareQZone']
	            });
	          //微信分享
	            wx.ready(function () {
	            	var antiqueImgUrl = '${bpAntique.antiqueImgUrl}'.split(',')[0];
	                wx.onMenuShareAppMessage({
	                    title: "我在安康文化云发现了一个非常棒的文物-[${bpAntique.antiqueName}]",
	                    desc: '汇聚佛山最全文化文物',
	                    imgUrl: antiqueImgUrl,
	                    success: function () { 
	                    	shareIntegral();
	                    }
	                });
	                wx.onMenuShareTimeline({
	                    title: "我在安康文化云发现了一个非常棒的文物-[${bpAntique.antiqueName}]",
	                    imgUrl: antiqueImgUrl,
	                    success: function () { 
	                    	shareIntegral();
	                    }
	                });
	                wx.onMenuShareQQ({
	                	title: "我在安康文化云发现了一个非常棒的文物-[${bpAntique.antiqueName}]",
	                	desc: '汇聚佛山最全文化文物',
	                    imgUrl: antiqueImgUrl,
	                    success: function () { 
	                    	shareIntegral();
	                    }
	                });
	                wx.onMenuShareWeibo({
	                	title: "我在安康文化云发现了一个非常棒的文物-[${bpAntique.antiqueName}]",
	                	desc: '汇聚佛山最全文化文物',
	                    imgUrl: antiqueImgUrl,
	                    success: function () { 
	                    	shareIntegral();
	                    }
	                });
	                wx.onMenuShareQZone({
	                	title: "我在安康文化云发现了一个非常棒的文物-[${bpAntique.antiqueName}]",
	                	desc: '汇聚佛山最全文化文物',
	                    imgUrl: antiqueImgUrl,
	                    success: function () { 
	                    	shareIntegral();
	                    }
	                });
	            });
		 }
		
		//页面参数
			var commentIndex=0;
			var pageNum=8;
			var userId = '${sessionScope.terminalUser.userId}';
			var antiqueId = '${bpAntique.antiqueId }';
			//点赞（我想去）
	        function addWantGo(relateId,wantgoType) {
	            if (userId == null || userId == '') {
	              	//判断登陆
	            	window.location.href="${path}/muser/login.do?type=${path}/wechatBpAntique/preAntiqueDetail.do?antiqueId="+relateId;
	            }else{
	            	$.post("${path}/wechatUser/addUserWantgo.do", {
	            		relateId: relateId,
	                    userId: userId,
	                    type: wantgoType
	                }, function (data) {
	                    if (data.status == 0) {
	                    	$("#bpLove").attr("class","bpLove on");
	                    } else if (data.status == 14111) {
	                        $.post("${path}/wechatUser/deleteUserWantgo.do", {
	                        	relateId: relateId,
	                            userId: userId
	                        }, function (data) {
	                            if (data.status == 0) {
	                            	$("#bpLove").attr("class","bpLove");
	                            }
	                        }, "json");
	                    }
	                }, "json");
	            }
	        }
			
	      //添加评论
	        function addComment() {
	            if (userId == null || userId == '') {
	            	//判断登陆
	            	window.location.href="${path}/muser/login.do?type=${path}/wechatBpAntique/preAntiqueDetail.do?antiqueId="+relateId;
	            } else {
	            	var status = '${sessionScope.terminalUser.commentStatus}';
	                if (status == 2) {
	                    dialogAlert("评论提示", "您的账户已被禁止评论，没有评论权限");
	                } else {
	                    window.location.href = "${path}/wechat/preAddWcComment.do?moldId=" + antiqueId + "&type=21";
	                }
	            }
	        }
			
	      //评论列表
	        function loadComment(pageIndex,pageNum) {
	            var data = {
	                moldId: antiqueId,
	                type: 21,
	                pageIndex:pageIndex,
	                pageNum:pageNum
	            };
	            $.post("${path}/wechat/weChatComment.do", data, function (data) {
	            	if (data.status == 0) {
	                	if(data.data.length>0){
	                		$("#commentLi").show();
	                	}
	                    $.each(data.data, function (i, dom) {
	                        var commentImgUrlHtml = "";
	                        if (dom.commentImgUrl.length != 0) {
	                            var commentImgUrls = dom.commentImgUrl.substring(0, dom.commentImgUrl.length - 1).split(",");
	                            $.each(commentImgUrls, function (i, commentImgUrl) {
	                                var smallCommentImgUrl = getIndexImgUrl(commentImgUrl, "_150_150");
	                                commentImgUrlHtml += "<li><img src='" + smallCommentImgUrl + "' onclick='previewImage(\"" + commentImgUrl + "\",\""+dom.commentImgUrl+"\");'></li>"
	                            });
	                        }
	                        var userHeadImgUrl = '';
	                        if (dom.userHeadImgUrl.indexOf("http") == -1) {
	                            userHeadImgUrl = '../STATIC/wx/image/sh_user_header_icon.png';
	                        } else if (dom.userHeadImgUrl.indexOf("/front/") != -1) {
	                            userHeadImgUrl = getIndexImgUrl(dom.userHeadImgUrl, "_300_300");
	                        } else {
	                            userHeadImgUrl = dom.userHeadImgUrl;
	                        }
	                        $("#antiqueComment").append("<li>" +
															"<div class='p7-user-list'>" +
																"<div class='p7-user'>" +
																	"<img src='" + userHeadImgUrl + "' width='65' height='65' onerror='imgNoFind();'/>" +
																	"<div class='p7-user-name'>" +
																		"<p class='user-name'>"+dom.commentUserNickName+"</p>" +
																		"<p class='user-time'>"+dom.commentTime.replace("-",".").replace("-",".")+"</p>" +
																	"</div>" +
																	"<div style='clear: both;'></div>" +
																"</div>" +
																"<div class='p7-say'>" +
																	"<p>" + dom.commentRemark + "</p>" +
																"</div>" +
																"<div class='p7-user-list-img commentImgUrlHtml'><ul>" + commentImgUrlHtml + "</ul></div>" +
															"</div>" +
														"</li>");
	                    });
	                    imgStyleFormat('commentImgHtml','commentImgUrlHtml');
	                }
	            }, "json");
	      }
		    
		//滑屏分页
		$(window).on("scroll", function () {
		    var scrollTop = $(document).scrollTop();
		    var pageHeight = $(document).height();
		    var winHeight = $(window).height();
		    if (scrollTop >= (pageHeight - winHeight)) {
		    	commentIndex += pageNum;
           		var index = commentIndex;
		   		setTimeout(function () { 
		   			loadComment(index,pageNum);
		   		},1000);
		    }
		});
		    
		</script>
		<script>
		$(function () {
            loadComment(commentIndex,pageNum);		//评论
		});
			$(document).ready(function() {
				var mySwiper3 = new Swiper('.swiper-container3', {
					freeMode: false,
					autoplay: 3000,
					loop: true,
					pagination: '.swiper-pagination'
				});
				//分享
				$("#share").click(function() {
					if (!is_weixin()&&!(/wenhuayun/.test(ua))) {
						dialogAlert('系统提示', '请用微信浏览器打开分享！');
					}else{
						$("html,body").addClass("bg-notouch");
						$(".background-fx").css("display", "block")
					}
				});
				$(".background-fx").click(function() {
					$("html,body").removeClass("bg-notouch");
					$(".background-fx").css("display", "none")
				})
			})
		</script>
	</head>

	<body>
		<div class="main">
			<div class="header">
			</div>
			<input id ="userId" value="${sessionScope.terminalUser.userId }" type="hidden"/>
			<input id ="antiqueId" value="${bpAntique.antiqueId }" type="hidden"/>
			<input id ="userIsWant" value="${bpAntique.userIsWant }" type="hidden"/>
			<a href="${path}/wechat/index.do" class="home_lm"><img src="${path}/STATIC/wechat/image/home.png"></a>
			<div class="content" style="padding-bottom: 0;">
				<div class="active-top-bor" style="position: relative;overflow:hidden;">
					<div class="swiper-container3 swiper-container-horizontal">
						<div id="indexBannerList" class="swiper-wrapper">
						<c:set value="${ fn:split(bpAntique.antiqueImgUrl, ',') }" var="imgUrls" />
						<c:forEach items="${imgUrls}" var="imgUrl">
							<div class="swiper-slide"><img src="${imgUrl}" width="750" height="475"></div>
						</c:forEach>
						</div>
						<div id="swiperPage" class="swiper-pagination"></div>
						
					</div>
				</div>
				<div class="bpshpDetailName">
					<p class="bpshpTittle">${bpAntique.antiqueName}</p>
					<div class="bpshpTag"><span>${bpAntique.antiqueDynasty}</span><span>${bpAntique.antiqueType}</span></div>
				</div>
				<div class="active-detail">
					<ul>
						<li>
							<div class="active-border active-tab">
								<div class="active-detail-p1 active-detail-p1-hide">
									<div class="active-detail-p1-show">
										<h1 class="border-bottom">&emsp;详情</h1>
										<p>${bpAntique.antiqueRemark}</p>
									</div>
								</div>
								<!-- <div class="active-detail-p1-arrowdown"></div> -->
							</div>
						</li>
						<li id="commentLi" style="display: none;">
							<div style="margin-bottom: 0px;" class="active-border">
								<div class="active-detail-p7 commentImgHtml">
									<p class="border-bottom">共<span style="color: #fcaf5b;">${bpAntique.commentCount }</span>条评论</p>
									<ul id="antiqueComment">
									
									</ul>
								</div>
							</div>
						</li>
					</ul>
				</div>
			</div>
			<div class="bpFoot">
				<div class="bpRwczDetailFoot clearfix">
					<div class="bpPinglun" onclick="addComment()">
						<span>评论</span>
					</div>
					<div class="bpLove" onclick="addWantGo('${bpAntique.antiqueId}',21)" id="bpLove">
						<span>点赞</span>
					</div>
					<div class="bpShare" id="share">
						<span>分享</span>
					</div>
				</div>
			</div>
		</div>
	<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 105%;display: none;z-index: 100;">
		<img src="${path}/STATIC/wechat/image/commonShare.png" style="width: 100%;height: 100%;" />
	</div>
	</body>
<script>
$(function(){
	var userIsWant = $("#userIsWant").val();
	if(userIsWant > 0){
		$("#bpLove").attr("class","bpLove on");	
		}
})
</script>
</html>