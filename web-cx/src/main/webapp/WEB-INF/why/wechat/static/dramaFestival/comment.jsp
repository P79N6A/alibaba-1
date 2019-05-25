<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>佛山文化云·上海当代戏剧节</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css?v=20161021"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		var noControl = '${noControl}'; //1：不可操作
		var dramaId = '${dramaId}';
	
		if (userId == null || userId == '') {
    		//判断登陆
        	publicLogin("${basePath}wechatStatic/dramaFestival.do");
    	}
		
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
        	appShareTitle = '上海当代戏剧节·看完好戏不来说一说？';
        	appShareDesc = '上海艺术节之艺术天空特别策划，全天12小时演出不间断，快来和我一起共享艺术盛宴';
        	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/dramaImg/shareIcon.jpg';
        	appShareLink = '${basePath}/wechatStatic/dramaFestival.do';
        	
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
					title: "佛山文化云·上海当代戏剧节·看完好戏不来说一说？",
					desc: '观戏剧，写剧评，分享属于你的“戏如人生”，赢取戏剧节限量礼品。',
					link: '${basePath}wechatStatic/dramaFestival.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/dramaImg/shareIcon.jpg'
				});
				wx.onMenuShareTimeline({
					title: "佛山文化云·上海当代戏剧节·看完好戏不来说一说？",
					imgUrl: '${basePath}/STATIC/wxStatic/image/dramaImg/shareIcon.jpg',
					link: '${basePath}wechatStatic/dramaFestival.do'
				});
				wx.onMenuShareQQ({
					title: "佛山文化云·上海当代戏剧节·看完好戏不来说一说？",
					desc: '观戏剧，写剧评，分享属于你的“戏如人生”，赢取戏剧节限量礼品。',
					link: '${basePath}/wechatStatic/dramaFestival.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/dramaImg/shareIcon.jpg'
				});
				wx.onMenuShareWeibo({
					title: "佛山文化云·上海当代戏剧节·看完好戏不来说一说？",
					desc: '观戏剧，写剧评，分享属于你的“戏如人生”，赢取戏剧节限量礼品。',
					link: '${basePath}/wechatStatic/dramaFestival.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/dramaImg/shareIcon.jpg'
				});
				wx.onMenuShareQZone({
					title: "佛山文化云·上海当代戏剧节·看完好戏不来说一说？",
					desc: '观戏剧，写剧评，分享属于你的“戏如人生”，赢取戏剧节限量礼品。',
					link: '${basePath}/wechatStatic/dramaFestival.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/dramaImg/shareIcon.jpg'
				});
			});
		}
		
		$(function () {
			$.post("${path}/wechatStatic/queryCcpDramalist.do",{userId:userId,dramaId:dramaId}, function (data) {
				if(data.length>0){
					var dom = data[0];
					$("#dramaName").html(dom.dramaName);
				}
			}, "json");
			
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
		
		//提交
		function saveComment(){
			if(noControl != 1){
				var dramaCommentRemark = $("#dramaCommentRemark").val();
				if(dramaCommentRemark == ""){
			    	dialogAlert('系统提示', '请输入剧评！');
			        return false;
			    }else if(dramaCommentRemark.length<20 || dramaCommentRemark.length>500){
			    	dialogAlert('系统提示', '剧评字数为20-500字！');
			        return false;
			    }
				$.post("${path}/wechatStatic/addDramaComment.do", {userId: userId,dramaCommentRemark: dramaCommentRemark,dramaId:dramaId},function (data) {
	                if (data == "200") {
	                	dialogConfirm('系统提示', '提交成功！', function(){
	                		location.href = '${path}/wechatStatic/dramaFestival.do';
	                	});
	                }else{
	                	dialogAlert('系统提示', '提交失败，请稍后再试！');
	                }
	            }, "json");
			}else{
				dialogAlert('系统提示', '活动已结束！');
			}
		}
	</script>
	<style>
		html,body{
			height: 100%;
			background-color: #eeeeee;
		}
	</style>
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
						<div class="dramaMenuOn">参演节目</div>
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
		<div style="padding: 25px;background-color: #eeeeee;">
			<div style="background-color: #fff;padding: 20px;">
				<div class="dramaRule" style="padding-bottom: 30px;border-bottom: 1px solid #262626;">
					<p style="text-align: center;font-size: 34px;color: #262626;font-weight: bold;">请为《<span id="dramaName"></span>》</p>
					<p style="text-align: center;font-size: 30px;line-height: 10px;">#&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;#</p>
					<p style="text-align: center;font-size: 30px;">写下您的剧评</p>
				</div>
				<div style="margin-top: 50px;">
					<textarea id="dramaCommentRemark" class="dramaTrxt" placeholder="剧评字数为20-500字" style="" maxlength="500"></textarea>
				</div>
				<div class="dramaSubmitBtn" onclick="saveComment();">提&emsp;交</div>
			</div>
		</div>
	</div>
</body>
</html>