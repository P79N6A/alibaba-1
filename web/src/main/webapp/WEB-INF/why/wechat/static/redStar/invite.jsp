<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>

	<head>
		<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
		<!--红星style-->
		<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-redstar.css">
		<!--大转盘js-->
		<script type="text/javascript" src="${path}/STATIC/wxStatic/js/jquery.rotate.min.js"></script>
		<script type="text/javascript" src="${path}/STATIC/wechat/js/webuploader/webuploader.min.js"></script>
		<script type="text/javascript" src="${path}/STATIC/wechat/js/webuploader/upload-redstar.js"></script>
		<script src="${path}/STATIC/js/common.js"></script>
		<title></title>
		
		<style>
			html,
			body,
			.redstarMain {
				height: 100%;
			}
			
			.changeImgBtn1 input,
			.changeImgBtn1 label {
				display: none;
			}
		</style>
		<script>
		
		 var title= '同志，请你接过我的革命旗帜，领取属于你的革命锦囊！';
		 var desc='纪念长征胜利80周年，点亮红星，五千只革命锦囊等你来拿！';
		 var imgUrl='${basePath}/STATIC/wxStatic/image/redStar/share_150.png';
		 
		//分享是否隐藏
	   	 if(window.injs){
	    	//分享文案
	    	appShareTitle = title;
	    	appShareDesc =desc;
	    	appShareImgUrl = imgUrl;
	    	
			injs.setAppShareButtonStatus(true);
			injs.changeNavTitle('红星照耀中国'); 
			
		 }else{
			$(document).attr("title",'红星照耀中国');
		}
		
		
			$(function() {
				var toUserId=$("#toUserId").val();
				
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
							title: title,
							desc: desc,
							imgUrl: imgUrl,
							link: '${basePath}wechatRedStar/inviteFriend.do?toUserId='+toUserId
						});
						wx.onMenuShareTimeline({
							title: title,
							imgUrl: imgUrl,
							link: '${basePath}wechatRedStar/inviteFriend.do?toUserId='+toUserId
						});
						wx.onMenuShareQQ({
							title: title,
							desc: desc,
							imgUrl: imgUrl,
							link: '${basePath}/wechatRedStar/inviteFriend.do?toUserId='+toUserId
						});
						wx.onMenuShareWeibo({
							title: title,
							desc: desc,
							imgUrl: imgUrl,
							link: '${basePath}/wechatRedStar/inviteFriend.do?toUserId='+toUserId
						});
						wx.onMenuShareQZone({
							title: title,
							desc: desc,
							imgUrl: imgUrl,
							link: '${basePath}/wechatRedStar/inviteFriend.do?toUserId='+toUserId
						});
					});
				}
				 
				 if (userId == null || userId == '') {
						publicLogin("${basePath}wechatRedStar/inviteFriend.do?toUserId="+toUserId);
			     }
				 
				if(toUserId){
					$.post("${path}/wechatUser/queryTerminalUserById.do", {userId: toUserId}, function (data) {
						 if (data.status == 0) {
							 var user = data.data[0];
							   $(".userName").html(user.userName);
						 }
	           	 	}, "json");
					 
					 $.post("${path}/wechatRedStar/getUserTestInfo.do", {userId: toUserId}, function (data) {
	            		 if (data.status == 1) {
	            			var dom = data.data;
	           			 	var userHeadImg = '';
		           			if(dom.shareSuccessImg.length>0){
		                         if(dom.shareSuccessImg.indexOf("http") == -1){
		                        	 dom.shareSuccessImg = getImgUrl(dom.shareSuccessImg);
		                         }
		                    }
		                    if (dom.shareSuccessImg.indexOf("http") == -1) {
		                           userHeadImg = "../STATIC/wx/image/sh_user_header_icon.png";
		                    } else if (dom.shareSuccessImg.indexOf("/front/") != -1) {
		                    	   userHeadImg = getIndexImgUrl(dom.shareSuccessImg, "_300_300");
		                    } else {
		                       	   userHeadImg = dom.shareSuccessImg;
		                    }
							$(".upImg").attr("src",userHeadImg);
							$(".upImg").attr("onerror","imgNoFind();");
	            		 }
	 	            	
	            	 }, "json");
				 }
				
				if(userId==toUserId){
					 $("#me").show();
				 }
				 else
					 $("#other").show();
				 
				// 助力
				$(".backIndex").click(function() {
					window.location.href = 'index.do';
				});
				//分享
				$(".share-button").click(function() {
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
				
				//关注
				$(".keep-button").on("touchstart", function() {
					$('.div-share').show();
					$("body,html").addClass("bg-notouch")
				})
				
			});
		</script>
		
	</head>

	<body>
	<input type="hidden" id="shareSuccessImg" value="1">
	<input type="hidden" id="toUserId" name="toUserId" value="${toUserId}">
	<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
			<img src="${path}/STATIC/wechat/image/commonShare.png" style="width: 100%;height: 100%;" />
		</div>
		<div class="div-share" >
			<div class="share-bg"></div>
			<div class="share">
				<img src="${path}/STATIC/wechat/image/wx-er2.png" />
				<p style="margin-top: 310px;">扫一扫&nbsp;关注文化云</p>
				<p>更多精彩活动、场馆等你发现</p>
				<button type="button" onclick="$('.div-share').hide();$('body,html').removeClass('bg-notouch')">关闭</button>
			</div>
		</div>
		<!--邀请同志挑战-->
		<div  id="me"  class="redstarMain helpBg" style="display: none;">
			<!--首页分享，WHY，关注按钮-->
			<div class="redstarBtnList">
				<div class="redstarKepp keep-button">
					<img src="${path}/STATIC/wxStatic/image/redStar/btn_keep.png" />
				</div>
				<div class="redstarShare share-button">
					<img src="${path}/STATIC/wxStatic/image/redStar/btn_share.png" />
				</div>
				<div style="clear: both;"></div>
			</div>
			<!--banner-->
			<div class="indexTtImg">
				<img src="${path}/STATIC/wxStatic/image/redStar/index_tt.png" />
			</div>
			<div class="redHelp">
				<img src="${path}/STATIC/wxStatic/image/redStar/head1.png" />
				<div class="changeImgBtn1">
					<img src="${path}/STATIC/wxStatic/image/redStar/upImg.png" />
				</div>
				<div class="headImgDiv"><img class="upImg" height="200" width="200" src=""></div>
				<div class="redHelpGet share-button">
					<img src="${path}/STATIC/wxStatic/image/redStar/yaoqingtongzhitiaozhan.png" />
				</div>
			</div>
		</div>
		<!--不点不是中国人-->
		<div id="other" class="redstarMain helpBg" style="display: none;">
			<!--首页分享，WHY，关注按钮-->
			<div class="redstarBtnList">
				<div class="redstarKepp keep-button">
					<img src="${path}/STATIC/wxStatic/image/redStar/btn_keep.png" />
				</div>
				<div class="redstarShare share-button">
					<img src="${path}/STATIC/wxStatic/image/redStar/btn_share.png" />
				</div>
				<div style="clear: both;"></div>
			</div>
			<!--banner-->
			<div class="indexTtImg">
				<img src="${path}/STATIC/wxStatic/image/redStar/index_tt.png" />
			</div>
			<div class="redHelp">
				<img src="${path}/STATIC/wxStatic/image/redStar/head2.png" />
				<div class="changeImgBtn1">
					<img src="${path}/STATIC/wxStatic/image/redStar/upImg.png" />
				</div>
				<div class="headImgDiv"><img class="upImg" height="200" width="200" src=""></div>
				<div class="redHelpFont">你的朋友<span class="userName"></span>请你接过他的 革命胜利旗帜！</div>
				<div class="redHelpGet backIndex" style="bottom: 50px;">
					<img src="${path}/STATIC/wxStatic/image/redStar/bdbszgr.png" />
				</div>
			</div>
		</div>
	</body>

</html>