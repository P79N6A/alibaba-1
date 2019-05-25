<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>市民文化节·我们的行走故事摄影大赛</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	
	<script>
		var walkType = 4;	//本次活动编号
	
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '市民文化节·“我们的行走故事”摄影作品正在征集';
	    	appShareDesc = '用一个镜头，一张照片，一段文字，讲述旅途中扣人心弦的人、景和事';
	    	appShareImgUrl = 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017323101459AcVBGKPrKi9FEFuAXEmrBnn0hfMSDD.jpg';
	    	
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
					title: "市民文化节·“我们的行走故事”摄影作品正在征集",
					desc: '用一个镜头，一张照片，一段文字，讲述旅途中扣人心弦的人、景和事',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017323101459AcVBGKPrKi9FEFuAXEmrBnn0hfMSDD.jpg'
				});
				wx.onMenuShareTimeline({
					title: "市民文化节·“我们的行走故事”摄影作品正在征集",
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017323101459AcVBGKPrKi9FEFuAXEmrBnn0hfMSDD.jpg'
				});
				wx.onMenuShareQQ({
					title: "市民文化节·“我们的行走故事”摄影作品正在征集",
					desc: '用一个镜头，一张照片，一段文字，讲述旅途中扣人心弦的人、景和事',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017323101459AcVBGKPrKi9FEFuAXEmrBnn0hfMSDD.jpg'
				});
				wx.onMenuShareWeibo({
					title: "市民文化节·“我们的行走故事”摄影作品正在征集",
					desc: '用一个镜头，一张照片，一段文字，讲述旅途中扣人心弦的人、景和事',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017323101459AcVBGKPrKi9FEFuAXEmrBnn0hfMSDD.jpg'
				});
				wx.onMenuShareQZone({
					title: "市民文化节·“我们的行走故事”摄影作品正在征集",
					desc: '用一个镜头，一张照片，一段文字，讲述旅途中扣人心弦的人、景和事',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017323101459AcVBGKPrKi9FEFuAXEmrBnn0hfMSDD.jpg'
				});
			});
		}
		
		$(function () {
			navFixed($(".kjmbNav"),'touchmove',240);
		    navFixed($(".kjmbNav"),'scroll',240);
		    
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
		
		// 导航固定
	    function navFixed(ele, type, topH) {
	        $(document).on(type, function() {
	            if($(document).scrollTop() > topH) {
	                ele.css('position', 'fixed');
	            } else {
	                ele.css('position', 'static');
	            }
	        });
	    }
		
	</script>
	
	<style>
		html,body {height: 100%;}
		.roomage {min-height: 100%;}
		.kjmbNav li {width: 130px;padding-left: 60px;padding-right: 60px;}
	</style>
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017323101459AcVBGKPrKi9FEFuAXEmrBnn0hfMSDD.jpg"/></div>
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
	<div class="roomage">
		<div class="lccbanner">
			<img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20173241350114xTaBebccFZGcBmOZEqGTsc0uLWREb.jpg" width="750" height="250">
			<ul class="lccshare clearfix">
				<li class="share-button"><a href="javascript:;">分享</a></li>
				<li class="keep-button"><a href="javascript:;">关注</a></li>
			</ul>
		</div>
		<div class="kjmbNav_wc">
			<ul class="kjmbNav clearfix">
				<li><a href="${path}/wechatStatic/walkIndex.do">首页</a></li>
				<li class="current"><a href="${path}/wechatStatic/walkRule.do">活动规则</a></li>
				<li><a href="${path}/wechatStatic/walkRanking.do">排行榜</a></li>
			</ul>
		</div>
		<div class="roomcont jz700 roomguize_wc">
	        <div class="roomguize">
	            <div class="jz645">
	                <div class="jinhaotit">
	                    <div class="h1">#&nbsp;&nbsp;参与方式&nbsp;&nbsp;#</div>
	                </div>
	                <ol>
	                    <li>即日起至2017年7月31日截止，通过安康文化云（包含APP、微网站及微信公众号）进入大赛报名页面，填写报名资料并提交参赛作品。（包括摄影作品及作品背后的故事文字描述）
	                        <div class="juh">
	                            <p style="margin-bottom:10px;">* 成功参与立享600积分，您可以多次上传作品，但是积分只赠送一次。</p>
	                            <p style="margin-bottom:10px;">* 组照或单幅照片均可。组照需包含同一主题且相互关联的9张以内照片。</p>
	                            <p style="margin-bottom:10px;">* 参赛者须为每幅/组参赛照片命名。</p>
	                            <p style="margin-bottom:10px;">* 每幅/组照片注明拍摄时间与地点，并附上照片的故事，文字在200-2000字左右。</p>
	                            <p style="margin-bottom:10px;">* 您也可以通过邮件投稿，将您的姓名、手机号码、摄影作品（含拍摄时间、拍摄地点、200字以上行走故事和摄影作品图片），邮件至huangj@creatoo.com,通过审核后即可成功参赛。</p>
	                        </div>
	                    </li>
	                    <li>分享转发<br>每个参赛者一经成功参赛，即会获取一个独立的参赛页面，可通过朋友圈等形式传播自己的参赛页面，请亲朋好友投票。</li>
	                    <li>用户投票<br>每个用户登录后可对作品进行投票，每人每日可对每组作品投一次票。</li>
	                    <li>展览与颁奖
	                        <div>（1）本次活动奖项分为：人气入围奖和优秀作品奖。</div>
	                        <div class="juh">
	                            <p style="margin-bottom:10px;">*人气入围奖：</p>
	                            <p style="margin-bottom:10px;">1.截止8月11日，按照文化云活动页面点赞排名，前100幅最具人气摄影故事作品，均可获得文化云积分及入围证书；</p>
	                            <p style="margin-bottom:10px;">2. 获得人气入围奖的摄影故事作品将有机会作为文化云APP开机画面，获得百万用户的共同欣赏。</p>
	                            <br>
	                            <p style="margin-bottom:10px;">*优秀作品奖：</p>
	                            <p style="margin-bottom:10px;">1. 截止8月7日，专家会在所有参赛摄影故事作品中评选出200幅精彩作品；</p>
	                            <p style="margin-bottom:10px;">2. 8月底进行最终评审，从专家评审的200幅作品+网络人气入围的100幅作品中，由摄影专家最终评选出100幅优秀摄影故事作品（排名不分先后），颁发证书。</p>
	                        </div>
	                        <div style="margin-top:30px;">（2）文化云对此次赛事的优秀作品进行为期三个月的线上展览，供群众浏览、欣赏。</div>
	                        <div style="margin-top:15px;">（3）优秀作品将于9月25日在上海市群众艺术馆展厅展出，并编辑成册。</div>
	                    </li>
	                </ol>
	            </div>
	        </div>
	        <div class="roomguize">
	            <div class="jz645">
	                <div class="jinhaotit">
	                    <div class="h1">#&nbsp;&nbsp;特别注意&nbsp;&nbsp;#</div>
	                </div>
	                <ol>
	                    <li>作品需以“我们的行走故事”为主题，突出真实性、艺术性、时间的持续连贯性、叙事的完整性，着力表现旅途中的心路历程。若不合要求，活动主办方有权对违规作品做删除处理。</li>
	                    <li>作品需要原创、不违反国家法律法规，活动主办方有权对违规作品做删除处理，并保留追究法律责任。</li>
	                    <li>作品一经提交，即视为同意活动主办方拥有该作品进行非营利活动的刊发版权。</li>
	                    <li>为保证参赛的公正性，活动主办方禁止任何形式的刷票行为，一经查实，有权取消违规作品的参赛权利。</li>
	                </ol>
	            </div>
	        </div>
	    </div>
	</div>
</body>
</html>