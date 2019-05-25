<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/hsStyle.css" />
		<%--<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/bpColorCtrl.css">--%>
		<title>安康文化云</title>
		<script type="text/javascript">

            //分享是否隐藏
            if(window.injs){
                //分享文案
                appShareTitle = '我在安康文化云发现了一个非常棒的资讯-[${bpInfo.beipiaoinfoTitle}]';
                appShareDesc = '汇聚佛山最全文化资讯';
                appShareImgUrl = '${bpInfo.beipiaoinfoHomepage}';
                appShareLink = '${basePath}/wechatChuanzhou/chuanzhouDetail.do?infoId=${bpInfo.beipiaoinfoId }';
                injs.setAppShareButtonStatus(true);
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
	            	var beipiaoinfoHomepage = '${bpInfo.beipiaoinfoHomepage}';
	                wx.onMenuShareAppMessage({
	                    title: "我在安康文化云发现了一个非常棒的资讯-[${bpInfo.beipiaoinfoTitle}]",
	                    desc: '汇聚佛山最全文化资讯',
	                    imgUrl: beipiaoinfoHomepage,
	                    success: function () { 
	                    	shareIntegral();
	                    }
	                });
	                wx.onMenuShareTimeline({
	                    title: "我在安康文化云发现了一个非常棒的资讯-[${bpInfo.beipiaoinfoTitle}]",
	                    imgUrl: beipiaoinfoHomepage,
	                    success: function () { 
	                    	shareIntegral();
	                    }
	                });
	                wx.onMenuShareQQ({
	                	title: "我在安康文化云发现了一个非常棒的资讯-[${bpInfo.beipiaoinfoTitle}]",
	                	desc: '汇聚佛山最全文化资讯',
	                    imgUrl: beipiaoinfoHomepage,
	                    success: function () { 
	                    	shareIntegral();
	                    }
	                });
	                wx.onMenuShareWeibo({
	                	title: "我在安康文化云发现了一个非常棒的资讯-[${bpInfo.beipiaoinfoTitle}]",
	                	desc: '汇聚佛山最全文化资讯',
	                    imgUrl: beipiaoinfoHomepage,
	                    success: function () { 
	                    	shareIntegral();
	                    }
	                });
	                wx.onMenuShareQZone({
	                	title: "我在安康文化云发现了一个非常棒的资讯-[${bpInfo.beipiaoinfoTitle}]",
	                	desc: '汇聚佛山最全文化资讯',
	                    imgUrl: beipiaoinfoHomepage,
	                    success: function () { 
	                    	shareIntegral();
	                    }
	                });
	            });
		 }
			//页面参数
			var bpInfoId = '${bpInfo.beipiaoinfoId }';
			var commentIndex=0;
			var pageNum=5;
			
			$(function(){
			    if(userId){
                    var userIsWant ='${userIsWant}';
                    if(userIsWant > 0){
                        $("#bpLove").attr("class","bpLove on");
                    }
				}

				//页面首次载入时加载评论
				loadComment(commentIndex,pageNum);
				
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
			
			
			//点赞（我想去）
	       	function addWantGo(relateId,wantgoType,$this) {
	            if (userId == null || userId == '') {
	            	publicLogin('${basePath}wechatChuanzhou/chuanzhouDetail.do?infoId='+$("#infoId").val());
	                return;
	            }
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
			
			//添加评论
	        function addComment() {
	            if (userId == null || userId == '') {
	            	publicLogin('${basePath}wechatChuanzhou/chuanzhouDetail.do?infoId='+$("#infoId").val());
	            } else {
	                var status = '${sessionScope.terminalUser.commentStatus}';
	                if (status == 2) {
	                    dialogAlert("评论提示", "您的账户已被禁止评论，没有评论权限");
	                } else {
	                    window.location.href = "${path}/wechat/preAddWcComment.do?moldId=" + $("#infoId").val() + "&type=20&userId="+userId+"&callback=${callback}&sourceCode=${sourceCode}";
	                }
	            }
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
		
			//加载评论列表
	        function loadComment(pageIndex,pageNum) {
	            var data = {
	                moldId: bpInfoId,
	                type: 20,
	                pageIndex:pageIndex,
	                pageNum:pageNum
	            };
	            $.post("${path}/wechat/weChatComment.do", data, function (data) {
	            	if (data.status == 0) {
	                	if(data.data.length>0){
	                		$("#comment").show();
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
	                        $("#comment").append("<li>" +
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
		    
		    $(document).ready(function() {
				$(".bpLove").on('click', function() {
					$(this).toggleClass('on')
				});
				var mySwiper3 = new Swiper('.swiper-container3', {
					freeMode: false,
					autoplay: 3000,
					loop: true,
					pagination: '.swiper-pagination'
				});

			})
		</script>
	</head>

	<body>
		<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 105%;display: none;z-index: 100;">
			<img src="${path}/STATIC/wechat/image/commonShare.png" style="width: 100%;height: 100%;" />
		</div>
		<div class="main">
			<div class="header">
			<input type="hidden" value="${bpInfo.beipiaoinfoId }" id = "infoId"/>
			</div>
			<a href="javascript:void(0);" onclick="toWhyIndex()" class="home_lm"><img src="${path}/STATIC/wechat/image/home.png"></a>
			<div class="content" style="padding-bottom: 0;">
				<!-- 图片集 -->
				<c:if test="${bpInfo.beipiaoinfoShowtype==0 }">
					<c:set value="${fn:split(bpInfo.beipiaoinfoImages,';')}" var="urls" />
					<c:if test="${not fn:contains(bpInfo.beipiaoinfoImages,';')}">
						<div class="active-top-bor">
							<img class="masking-down" src="${bpInfo.beipiaoinfoImages}">
							<span class="number">1图</span>
						</div>
					</c:if>
					<c:if test="${fn:contains(bpInfo.beipiaoinfoImages,';')}">
						<div class="active-top-bor" style="position: relative;overflow:hidden;">
							<div class="swiper-container3 swiper-container-horizontal">
								<div id="indexBannerList" class="swiper-wrapper">
									<c:forEach items="${urls}" var="url">
										<div class="swiper-slide" style="width:750px;height:475px;">
											<img class="masking-down" src="${url}">
										</div>
									</c:forEach>
								</div>
							</div>
						<span class="number">${fn:length(urls)}图</span>
					</div>
					</c:if>
				</c:if>
				
				<c:if test="${bpInfo.beipiaoinfoShowtype==1 }">
					<!-- 视频 -->
					<video id="video" src="${bpInfo.beipiaoinfoVideo}" style="object-fit:fill;width: 750px;height: 475px;" controls webkit-playsinline="true" playsinline="true" x-webkit-airplay="allow" x5-video-player-type="h5" x5-video-player-fullscreen="true" x5-video-orientation="portraint"></video>
				</c:if>
				<div class="bpRwczDetailName">
					<p class="bpRwczTittle">${bpInfo.beipiaoinfoTitle }</p>
					<div class="clearfix bpRwczPlace">
						<label class="f-left"><fmt:formatDate value="${bpInfo.beipiaoinfoUpdateTime}" pattern="yyyy-MM-dd HH:mm"/></label>
						<span class="f-right">${bpInfo.currentTagName}</span>
					</div>
				</div>
				<div class="active-detail">
					<ul id ="commentUl">
						<li>
							<div class="active-border active-tab">
								<div class="active-detail-p1 active-detail-p1-hide">
									<div class="active-detail-p1-show">
										<h1 class="border-bottom">&emsp;详情</h1>
										<p>${bpInfo.beipiaoinfoContent }</p>
										<p>${bpInfo.beipiaoinfoDetails }</p>
									</div>
								</div>
								<div class="active-detail-p1-arrowdown"></div>
							</div>
						</li>
						<li>
							<div style="margin-bottom: 0px;" class="active-border">
								<div class="active-detail-p7">
									<p class="border-bottom">共<span style="color: #fcaf5b;">${commentCount }</span>条评论</p>
									<ul id ="comment">
										
									</ul>
								</div>
							</div>
						</li>
					</ul>
				</div>
			</div>
			<div class="bpFoot">
				<div class="bpRwczDetailFoot clearfix">
					<div class="bpPinglun" onclick="addComment('${bpInfo.beipiaoinfoId }',20,'$(this)')">
						<span>评论</span>
					</div>
					<div class="bpLove" onclick="addWantGo('${bpInfo.beipiaoinfoId }',20,'$(this)')" id="bpLove">
						<span>点赞</span>
					</div>
					<div class="bpShare" id ="share">
						<span>分享</span>
					</div>
				</div>
			</div>
		</div>
	</body>

</html>