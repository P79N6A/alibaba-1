<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
		<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/normalize.css"/>

		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/hsStyle.css"/>
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/swiper-3.3.1.min.css"/>
		<%--<link rel="stylesheet" href="${path}/STATIC/wechat/css/bpColorCtrl.css" />--%>
		<script type="text/javascript" src="${path}/STATIC/wechat/js/jquery-2.1.4.min.js"></script>
		<script type="text/javascript" src="${path}/STATIC/wechat/js/swiper-3.3.1.jquery.min.js"></script>
	
		<title>佛山文化云</title>
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
	            	var productIconUrl = '${bpProduct.productIconUrl}';
	                wx.onMenuShareAppMessage({
	                    title: "我在佛山文化云发现了一个非常棒的商品-[${bpProduct.productName}]",
	                    desc: '汇聚佛山最全文化商品',
	                    imgUrl: productIconUrl,
	                    success: function () { 
	                    	shareIntegral();
	                    }
	                });
	                wx.onMenuShareTimeline({
	                    title: "我在佛山文化云发现了一个非常棒的商品-[${bpProduct.productName}]",
	                    imgUrl: productIconUrl,
	                    success: function () { 
	                    	shareIntegral();
	                    }
	                });
	                wx.onMenuShareQQ({
	                	title: "我在佛山文化云发现了一个非常棒的商品-[${bpProduct.productName}]",
	                	desc: '汇聚佛山最全文化商品',
	                    imgUrl: productIconUrl,
	                    success: function () { 
	                    	shareIntegral();
	                    }
	                });
	                wx.onMenuShareWeibo({
	                	title: "我在佛山文化云发现了一个非常棒的商品-[${bpProduct.productName}]",
	                	desc: '汇聚佛山最全文化商品',
	                    imgUrl: productIconUrl,
	                    success: function () { 
	                    	shareIntegral();
	                    }
	                });
	                wx.onMenuShareQZone({
	                	title: "我在佛山文化云发现了一个非常棒的商品-[${bpProduct.productName}]",
	                	desc: '汇聚佛山最全文化商品',
	                    imgUrl: productIconUrl,
	                    success: function () { 
	                    	shareIntegral();
	                    }
	                });
	            });
		 }
			var commentIndex=0;
			var pageNum=8;
			var userId = '${sessionScope.terminalUser.userId}';
			var productId = '${bpProduct.productId }';
			//点赞（我想去）
	        function addWantGo(relateId,wantgoType) {
	            if (userId == null || userId == '') {
	              	//判断登陆
	              	window.location.href="${path}/muser/login.do?type=${path}/wechatBpProduct/preProductDetail.do?productId="+productId;
	            }else{
	            	$.post("${path}/wechatUser/addUserWantgo.do", {
	            		relateId: relateId,
	                    userId: userId,
	                    type: wantgoType
	                }, function (data) {
	                    if (data.status == 0) {
	                    	$("#bpLove").addClass('shop_act');
	                    } else if (data.status == 14111) {
	                        $.post("${path}/wechatUser/deleteUserWantgo.do", {
	                        	relateId: relateId,
	                            userId: userId
	                        }, function (data) {
	                            if (data.status == 0) {
	                            	$("#bpLove").removeClass('shop_act');
	                            }
	                        }, "json");
	                    }
	                }, "json");
	            }
	        }
	      //收藏
	        function addCollect() {
	            if (userId == null || userId == '') {
	              	window.location.href="${path}/muser/login.do?type=${path}/wechatBpProduct/preProductDetail.do?productId="+productId;
	                return;
	            }

	            if ($("#collect").hasClass("shop_act")) {
	                $.post("${path}/wechat/wcDelCollect.do", {
	                    relateId: productId,
	                    userId: userId,
	                    type: 22
	                }, function (data) {
	                  if(data.status == 0){
	                        $("#collect").removeClass('shop_act');
	                        dialogAlert("收藏提示", "已取消收藏！");
	                    }
	                }, "json");
	            } else {
	                $.post("${path}/wechat/wcCollect.do", {
	                    relateId: productId,
	                    userId: userId,
	                    type: 22
	                }, function (data) {
	                    if (data.status == 0) {
	                        $("#collect").addClass('shop_act');
	                        dialogAlert("收藏提示", "收藏成功！");
	                    }
	                }, "json");
	            }
	        }
	      //添加评论
	        function addComment() {
	            if (userId == null || userId == '') {
	            	//判断登陆
	              	window.location.href="${path}/muser/login.do?type=${path}/wechatBpProduct/preProductDetail.do?productId="+productId;
	            } else {
	            	var status = '${sessionScope.terminalUser.commentStatus}';
	                if (status == 2) {
	                    dialogAlert("评论提示", "您的账户已被禁止评论，没有评论权限");
	                } else {
	                    window.location.href = "${path}/wechat/preAddWcComment.do?moldId=" + productId + "&type=22";
	                }
	            }
	        }
	      //评论列表
	        function loadComment(pageIndex,pageNum) {
	            var data = {
	                moldId: productId,
	                type: 22,
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
	                        $("#productComment").append("<li>" +
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
		//字数提示
	    function font_siz() {
	        var num = $(".textarea").val().length;
	        $(".h .size b").html(num);
	    }	
		</script>
		<script>
		$(document).ready(function() {
			var mySwiper3 = new Swiper('.swiper-container3', {
				freeMode: false,
				autoplay: 3000,
				loop: true,
				pagination: '.swiper-pagination'
			});
		});

			$(document).ready(function() {
				loadComment(commentIndex,pageNum);		//评论
				$(".footmenu-button5 button").click(function(){
					/* $(".fill_wrap").show(); */
					 $(".fill_wrap").show().click(function(){
						$(this).hide();
					}); 
				});
				$(".fill").click(function(e){
					window.event? window.event.cancelBubble = true : e.stopPropagation();
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
				
				 $("#btnSubmit").click(function () {
					if (userId ==null || userId == '') {
						alert("id不存在");
							if(productId)
				           		 publicLogin("${path}/wechatBpProduct/preProductDetail.do?productId="+productId);
							else
								 publicLogin("${path}/wechatBpProduct/preProductDetail.do");
				            return ;
				        } 
		             var userName=$("#userName").val();
		             var userTel=$("#userTel").val();
		             var orderRemark=$("#orderRemark").val();
		             var formData= $("#addOrderForm").serializeArray();
		             if(userName.trim()==""){
		    	        	dialogAlert('系统提示', '联系人为必填项！');
		    	            return;
		    	        }
					 
					 if(userName.length>50){
		    	        	dialogAlert('系统提示', '联系人长度不能大于50！');
		    	            return;
		    	        }
					 var isMobile=/^(?:13\d|15\d|18\d|17\d)\d{5}(\d{3}|\*{3})$/; //手机号码验证规则
					 
					 if(!isMobile.test(userTel)){
		    	        	dialogAlert('系统提示', '手机号格式不正确！');
		    	            return;
		    	        }
					 $.post("${path}/wechatBpProduct/submitOrder.do?productId="+productId,formData, function(data) {
			    			if(data!=null && data=='success'){
			    				dialogConfirm('提示', "预约成功！", function () {
		                          	location.href = "${path}/wechatBpProduct/preProductDetail.do?productId="+productId;
		                        });	
			    			}else{
			    				dialogAlert('提示', "预约失败！");
			    			}
			    		});
		            });
			});
		</script>
	</head>

	<body>
		<div class="main">
			<div class="header">
			</div>
			<input id ="userId" value="${sessionScope.terminalUser.userId }" type="hidden"/>
			<input id ="productId" value="${bpProduct.productId }" type="hidden"/>
			<input id ="userIsWant" value="${bpProduct.userIsWant }" type="hidden"/>
			<a href="${path}/wechat/index.do" class="home_lm"><img src="${path}/STATIC/wechat/image/home.png"></a>
			<div class="content" style="padding-bottom: 0;">
				<!-- 图片集 -->
				<c:if test="${bpProduct.productShowtype==1 }">
					<c:set value="${fn:split(bpProduct.productImages,',')}" var="urls" />
					<c:if test="${not fn:contains(bpProduct.productImages,',')}">
						<div class="active-top-bor">
							<img class="masking-down" src="${bpProduct.productImages}" width="750" height="475">
							<span class="number">1图</span>
						</div>
					</c:if>
					<c:if test="${fn:contains(bpProduct.productImages,',')}">
						<div class="active-top-bor" style="position: relative;overflow:hidden;">
							<div class="swiper-container3 swiper-container-horizontal">
								<div id="indexBannerList" class="swiper-wrapper">
									<c:forEach items="${urls}" var="url">
										<div class="swiper-slide">
											<img src="${url}" width="750" height="475">
										</div>
									</c:forEach>
								</div>
							</div>
						<span class="number">${fn:length(urls)}图</span>
					</div>
					</c:if>
				</c:if>
				
				<c:if test="${bpProduct.productShowtype==2 }">
					<!-- 视频 -->
					<video id="video" src="${bpProduct.productVideo}" style="object-fit:fill;width: 750px;height: 475px;" controls webkit-playsinline="true" playsinline="true" x-webkit-airplay="allow" x5-video-player-type="h5" x5-video-player-fullscreen="true" x5-video-orientation="portraint">      
					</video>
				</c:if>
				<div class="bpshpDetailName">
					<p class="bpwwTittle">${bpProduct.productName}</p>
				</div>
				<div class="active-detail">
					<ul>
						<li>
							<div class="active-border active-tab">
								<div class="active-detail-p1 active-detail-p1-hide">
									<div class="active-detail-p1-show">
										<h1 class="border-bottom">&emsp;详情</h1>
										<p>${bpProduct.productRemark}</p>
									</div>
								</div>
								<!-- <div class="active-detail-p1-arrowdown"></div> -->
							</div>
						</li>
						<li id="commentLi" style="display: none;">
							<div style="margin-bottom: 0px;" class="active-border">
								<div class="active-detail-p7">
									<p class="border-bottom">共<span style="color: #fcaf5b;">${bpProduct.commentCount }</span>条评论</p>
									<ul id="productComment">
										
									</ul>
								</div>
							</div>
						</li>
					</ul>
				</div>
			</div>
			<div class="bpFoot">
				<div class="shop-footmenu clearfix">
					<ul class="fleftBtnHH clearfix">
						<li class="pl">
							<div class="btnAn footmenu-button1" onclick="addComment()"><p class="plwz">评论</p><em></em></div>
						</li>
						<li onclick="addWantGo('${bpProduct.productId}',22)" id="bpLove"><div class="btnAn footmenu-button2"></div><em></em></li>
						<li onclick="addCollect()" id="collect"><div class="btnAn footmenu-button3"></div><em></em></li>
						<li><div class="btnAn footmenu-button4" id="share"></div></li>
					</ul>
					<div class="footmenu-button5 clearfix"><button type="button">预订申请</button></div>
				</div>
			</div>
		</div>
	
	<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 105%;display: none;z-index: 100;">
		<img src="${path}/STATIC/wechat/image/commonShare.png" style="width: 100%;height: 100%;" />
	</div>
	<div class="fill_wrap" style="display: none;">
	  <form method="post" id="addOrderForm">
        <div class="lm_wrap">
			<h2>预订申请</h2>
	        <div class="fill">
	            <div class="information clearfix">
	                <i>联 系 人</i>
	                <input type="text" id="userName" name="userName">
	            </div>
	            <div class="information clearfix">
	                <i>手 机 号</i>
	                <input type="text" id="userTel" name="userTel">
	            </div>
	            <div class="information clearfix h">
	                <p class="tit">备<em class="w54"></em>注</p>
	                <textarea  oninput="font_siz()" class="textarea" id="orderRemark" name="orderRemark" maxlength="150"></textarea>
	                <span class="size"><b>0</b>/150</span>
	            </div>
	            <!-- <a id="btnPublish" class="btn">提&nbsp;&nbsp;交</a> -->
	            <input id="btnSubmit" class="btn" type="button" value="提  交"/>
	        </div>
        </div>
        </form>
    </div>
	</body>
<script type="text/javascript">
$(function(){
	var userIsWant = $("#userIsWant").val();
	if(userIsWant > 0){
		$("#bpLove").addClass('shop_act');
		}
	var isCollect = ${bpProduct.isCollect};
	if(isCollect > 0){
		$("#collect").addClass('shop_act');
		}	
})
</script>
</html>