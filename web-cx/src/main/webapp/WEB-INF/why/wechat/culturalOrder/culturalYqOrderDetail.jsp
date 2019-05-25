<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

	<head>
		<title>文化点单</title>
		<%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css">
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/fsStyle.css" />

		<style type="text/css">
			.whlmBanner .swiper-pagination-fraction{
				font-size: 22px;color: #ffffff;
			}
			.whlmBanner .swiper-pagination-current{
				color: #e63917;
			}
		</style>
		<script type="text/javascript">
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
	            	var culturalOrderIconUrl = '${order.culturalOrderImg}';
	                wx.onMenuShareAppMessage({
	                    title: "我在佛山文化云邀请了“${order.culturalOrderName}”，你也来邀请吧！",
	                    desc: '欢迎进入佛山文化云·文化点单',
	                    imgUrl: culturalOrderIconUrl,
	                    success: function () { 
	                    	shareIntegral();
	                    }
	                });
	                wx.onMenuShareTimeline({
	                    title: "我在佛山文化云邀请了“${order.culturalOrderName}”，你也来邀请吧！",
	                    imgUrl: culturalOrderIconUrl,
	                    success: function () { 
	                    	shareIntegral();
	                    }
	                });
	                wx.onMenuShareQQ({
	                	title: "我在佛山文化云邀请了“${order.culturalOrderName}”，你也来邀请吧！",
	                	desc: '欢迎进入佛山文化云·文化点单',
	                    imgUrl: culturalOrderIconUrl,
	                    success: function () { 
	                    	shareIntegral();
	                    }
	                });
	                wx.onMenuShareWeibo({
	                	title: "我在佛山文化云邀请了“${order.culturalOrderName}”，你也来邀请吧！",
	                	desc: '欢迎进入佛山文化云·文化点单',
	                    imgUrl: culturalOrderIconUrl,
	                    success: function () { 
	                    	shareIntegral();
	                    }
	                });
	                wx.onMenuShareQZone({
	                	title: "我在佛山文化云邀请了“${order.culturalOrderName}”，你也来邀请吧！",
	                	desc: '欢迎进入佛山文化云·文化点单',
	                    imgUrl: culturalOrderIconUrl,
	                    success: function () { 
	                    	shareIntegral();
	                    }
	                });
	            });
		 }
		
		var culturalOrderId = '${order.culturalOrderId}';
		
		$(function () {
			 loadComment();//评论列表
			 formatStyle("orderMemo");
			 var userCollect = '${order.userCollect}';
			 if(userCollect > 0){
				 $(".footmenu-button3").addClass("footmenu-button3-ck");
			}
			 
			//收藏
	        $(".footer").on("click", '.footmenu-button3', function () {
	            if (userId == null || userId == '') {
	            	publicLogin('${basePath}wechatCulturalOrder/culturalCyOrderIndex.do');
	                return;
	            }
	
	            if ($(this).hasClass("footmenu-button3-ck")) {
	                $.post("${path}/wechat/wcDelCollect.do", {
	                	relateId: culturalOrderId,
	                    userId: userId,
	                    type:30
	                }, function (data) {
	                    if (data.status == 0) {
	                        $(".footmenu-button3").removeClass("footmenu-button3-ck");
	                        dialogAlert("收藏提示", "已取消收藏！");
	                    }
	                }, "json");
	            } else {
	                $.post("${path}/wechat/wcCollect.do", {
	                	relateId: culturalOrderId,
	                    userId: userId,
	                    type:30
	                }, function (data) {
	                    if (data.status == 0) {
	                        $(".footmenu-button3").addClass("footmenu-button3-ck");
	                        dialogAlert("收藏提示", "收藏成功！");
	                    }
	                }, "json");
	            }
	        });
			
	        $(".footmenu-button4").click(function() {
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
			});
		});
		
		    //添加评论
	        function addComment() {
	            if (userId == null || userId == '') {
	            	publicLogin('${basePath}wechatCulturalOrder/culturalCyOrderIndex.do');
	            } else {
	                var status = '${sessionScope.terminalUser.commentStatus}';
	                if (status == 2) {
	                    dialogAlert("评论提示", "您的账户已被禁止评论，没有评论权限");
	                } else {
	                	window.location.href = "${path}/wechat/preAddWcComment.do?moldId="+culturalOrderId+"&type=30&culturalOrderLargeType=${culturalOrderLargeType}";
	                }
	            }
	        }

	        //评论列表
	        function loadComment() {
	            var data = {
	                moldId: culturalOrderId,
	                type: 30,
	                pageIndex: 0,
	                pageNum: 10
	            };
	            $.post("${path}/wechat/weChatComment.do", data, function (data) {
	                if (data.status == 0) {
	                	if(data.data.length>0){
	                		$("#commentLi").show();
	                		$("#commentToatl").html(data.pageTotal);
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
	        
	        //我要报名
	        function preOrder() {
	            if (userId == null || userId == '') {
	            	publicLogin('${basePath}wechatCulturalOrder/culturalCyOrderIndex.do');
	                return;
	            }else{
	            	window.location.href ='${path}/wechatCulturalOrder/culturalOrderApplyIndex.do?culturalOrderId=${order.culturalOrderId}&culturalOrderLargeType=${culturalOrderLargeType}&userId='+userId;
	            }
	        }
	        
	        //富文本格式修改
	        function formatStyle(id) {
	            var $cont = $("#" + id);
	            $cont.find("img").each(function () {
	                var $this = $(this);
	                $this.css({"max-width": "710px"});
	            });
	            $cont.find("p,font").each(function () {
	                var $this = $(this);
	                $this.css({
	                    "font-size": "24px",
	                    "line-height": "44px",
	                    "color": "#7C7C7C",
	                    "font-family": "Microsoft YaHei"
	                });
	            });
	            $cont.find("span").each(function () {
	                var $this = $(this);
	                $this.css({
	                	"font-size": "24px",
	                    "line-height": "44px",
	                    "font-family": "Microsoft YaHei"
	                });
	            });
	            $cont.find("a").each(function () {
	                var $this = $(this);
	                $this.css({
	                	"text-decoration": "underline",
	                	"color": "#7C7C7C"
	                });
	            });
	            var str = $cont.html();
	            str.replace(/<span>/g, "").replace(/<\/span>/g, "");
	            $cont.html(str);
	        }
	        
	        //图片预览
	        function previewImage(url,urls) {
	            wx.previewImage({
	                current: url, // 当前显示图片的http链接
	                urls: urls.substring(0, urls.length - 1).split(",")	 // 需要预览的图片http链接列表
	            });
	        }
		</script>
	</head>

<body style="background-color: #f3f3f3;">
	<div class="fsMain">

		<div class="swiper-container whlmBanner" style="float:none">
			<div class="swiper-wrapper">
				<a href="#" class="swiper-slide"><img src="${order.culturalOrderImg}" width="750px" height="260px"></a>
			</div>
		</div>
		
		<div class="dhshWrap">
			<div class="dhshInfo">
				<h1 class="tit">${order.culturalOrderName}</h1>
				<p>服务类型：${order.culturalOrderTypeName}</p>
				<p>服务对象：<c:if test="${order.culturalOrderDemandLimit == 1}">个人</c:if><c:if test="${order.culturalOrderDemandLimit == 2}">机构</c:if></p>
				<p>服务日期：${order.startDateStr} 至 ${order.endDateStr}</p>
				<p>联系电话：${order.culturalOrderLinkman}</p>
				<p>联系人：${order.culturalOrderLinkno}</p>
			</div>
			<div class="sortInfo">
				<h2 class="infoTit">详 情</h2>
				<div class="sortDetail" id="orderMemo">
					${order.culturalOrderServiceDetail}
				</div>				
			</div>
			<div class="active-detail" style="margin-bottom:102px;">
				<ul>
					<li id="commentLi" style="display: none;">
						<div style="margin-bottom: 0px;" class="active-border">
							<div class="active-detail-p7">
								<p class="border-bottom" style=" font-size: 28px;color: #333333;">共<span style="color: #fcaf5b;" id="commentToatl">0</span>条评论</p>
								<ul id ="comment"></ul>
							</div>
						</div>
					</li>
				</ul>
			</div>
		</div>
		
		<div class="footer">
			<div class="active-footmenu">
				<ul style="float: left;">
					<li class="active-footmenu-border">
						<div class="footmenu-button1" onclick="addComment();"><p>评论</p></div>
					</li>
					<li class="active-footmenu-border">
						<div class="footmenu-button3"></div>
					</li>
					<li style="padding-right: 13px;">
						<div class="footmenu-button4"></div>
					</li>
					<div style="clear: both;"></div>
				</ul>
				<div class="footmenu-button5" id="orderButton" style="width:438px;">
					<button type='button' onclick='preOrder();'>我要邀请</button>
				</div>
				<div style="clear: both;"></div>
			</div>
		</div>
	</div>
	<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index:10;">
		<img src="${path}/STATIC/wxStatic/image/fx-bg.png" style="width: 100%;height: 100%;" />
	</div>
</body>

</html>