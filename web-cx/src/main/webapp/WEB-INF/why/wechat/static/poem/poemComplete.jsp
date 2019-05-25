<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>佛山文化云·每日诗品</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series-2.css?t=New Date()"/>
	
	<script>
		var poem;
	
		if (userId == null || userId == '') {
			//判断登陆
		   	publicLogin("${basePath}wechatStatic/poemComplete.do");
		}
		
		//分享是否隐藏
		if(window.injs){
		   	//分享文案
		   	appShareTitle = '每日诗品-名师古诗赏析+填字游戏，快来挑战你的古诗功底！';
		   	appShareDesc = '每天一位中文名师，带你赏析古诗的独特魅力，争当古诗词达人！';
		   	appShareImgUrl = 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017426143720EKjF9mvXioZA8rrp3DRQXnisSNDRoD.jpg';
		   	
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
				jsApiList: ['previewImage','onMenuShareAppMessage','onMenuShareTimeline','onMenuShareQQ','onMenuShareWeibo','onMenuShareQZone']
			});
			wx.ready(function () {
				wx.onMenuShareAppMessage({
					title: "每日诗品-名师古诗赏析+填字游戏，快来挑战你的古诗功底！",
					desc: '每天一位中文名师，带你赏析古诗的独特魅力，争当古诗词达人！',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017426143720EKjF9mvXioZA8rrp3DRQXnisSNDRoD.jpg'
				});
				wx.onMenuShareTimeline({
					title: "每日诗品-名师古诗赏析+填字游戏，快来挑战你的古诗功底！",
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017426143720EKjF9mvXioZA8rrp3DRQXnisSNDRoD.jpg'
				});
				wx.onMenuShareQQ({
					title: "每日诗品-名师古诗赏析+填字游戏，快来挑战你的古诗功底！",
					desc: '每天一位中文名师，带你赏析古诗的独特魅力，争当古诗词达人！',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017426143720EKjF9mvXioZA8rrp3DRQXnisSNDRoD.jpg'
				});
				wx.onMenuShareWeibo({
					title: "每日诗品-名师古诗赏析+填字游戏，快来挑战你的古诗功底！",
					desc: '每天一位中文名师，带你赏析古诗的独特魅力，争当古诗词达人！',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017426143720EKjF9mvXioZA8rrp3DRQXnisSNDRoD.jpg'
				});
				wx.onMenuShareQZone({
					title: "每日诗品-名师古诗赏析+填字游戏，快来挑战你的古诗功底！",
					desc: '每天一位中文名师，带你赏析古诗的独特魅力，争当古诗词达人！',
					imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017426143720EKjF9mvXioZA8rrp3DRQXnisSNDRoD.jpg'
				});
			});
		}
	
		$(function () {
		    
			$.post("${path}/wechatStatic/queryPoemList.do",{poemDate:'${poemDate}',userId:userId,selectCompleteCount:1}, function (data) {
				if(data.length>0){
					poem = data[0];
					readPoetry(data[0]);
					//点赞
       				if(poem.userIsWant > 0){
       					$('.zan').addClass('cur');
       				}
					$("#wantCount").text(poem.wantCount);
				}
			},"json");
			
			//swiper初始化div
		    initSwiper();
			
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
		});
		
		// 读取诗词数据
		function readPoetry(data) {
			var neir = data.poemContent;
			if(neir){
				var txt1 = '<div class="tit">' + data.poemTitle + '</div>' + '<div class="author">' + data.poemAuthor + '</div>' + '<div class="neir" style="font-size: 32px;letter-spacing: 4px;padding-left: 20px;">' + neir.replace(/\r\n/g,'<br>') + '</div>';
				$('.fillPoetry').html(txt1);
				
				$("#lectorHeadImg img").attr("src",data.lectorHeadImg+"@150w");
				$("#lectorHeadImg img").attr("onclick","previewImg('"+data.lectorHeadImg+"','"+data.lectorHeadImg+"')");
				$("#lectorName").html(data.lectorName);
				$("#lectorJob").html(data.lectorJob);
				$("#poemLectorExplain").html(data.poemLectorExplain.replace(/\r\n/g,'<br>'));
			}else{
				$("#poemShowDiv").css({"padding":"400px 0 0 279px","font-size":"30px","color":"#6B6969","font-weight":"bolder"});
				$("#poemShowDiv").html("本日暂无数据~");
			}
			
			$("#poemShowDiv").show();
			$("#poemCompleteCount").html(data.poemCompleteCount);
		}

		//点赞（我想去）
        function addWantGo() {
        	$.post("${path}/wechatUser/addUserWantgo.do", {
        		relateId: poem.poemId,
                userId: userId,
                type: 11
            }, function (data) {
                if (data.status == 0) {
                	$('.zan').addClass('cur');
                	var _span = $('.zan').find('span');
        			_span.html(parseInt(_span.html()) + 1);
                } else if (data.status == 14111) {
                    $.post("${path}/wechatUser/deleteUserWantgo.do", {
                    	relateId: poem.poemId,
                        userId: userId
                    }, function (data) {
                        if (data.status == 0) {
                        	$('.zan').removeClass('cur');
                        	var _span = $('.zan').find('span');
                			_span.html(parseInt(_span.html()) - 1);
                        }
                    }, "json");
                }
            }, "json");
        }
	</script>
	
	<style>
		html,body {min-height: 100%;background: url(${path}/STATIC/wxStatic/image/dailyPoetry/bg2.jpg) no-repeat top center;background-color: #eee}
	</style>
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/2017426143720EKjF9mvXioZA8rrp3DRQXnisSNDRoD.jpg"/></div>
	<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
		<img src="${path}/STATIC/wechat/image/commonShare.png" style="width: 100%;height: 100%;" />
	</div>
	
	<div class="dailyPty">
		<ul class="lccshare clearfix">
			<li><a href="${path}/wechatStatic/poemRule.do">活动规则</a></li>
			<li class="share-button"><a href="javascript:;">分享</a></li>
			<li onclick="toWhyIndex();"><a href="javascript:;">首页</a></li>
		</ul>
		<table class="jinrps">
			<tr>
				<td class="td1">${fn:substring(poemDate, 0, 4)}年<fmt:parseNumber integerOnly="true" value="${fn:substring(poemDate, 5, 7)}" />月</td>
				<td class="td2" rowspan="2">今日诗品</td>
			</tr>
			<tr><td class="td3"><fmt:parseNumber integerOnly="true" value="${fn:substring(poemDate, 8, 10)}" /></td></tr>
		</table>
		
		<div id="poemShowDiv" style="display: none;">
			<div class="fillPoetry"></div>
			<div class="mingshixinjie"></div>
			<ul class="jiangshit jiangshitAn clearfix">
				<li>
					<div class="teach clearfix">
						<div class="toux" id="lectorHeadImg"><div><img src=""></div></div>
						<div class="char">
							<h5 id="lectorName"></h5>
							<h6 id="lectorJob"></h6>
						</div>
					</div>
					<div class="neirong" id="poemLectorExplain"></div>
					<a class="allLink" href="${path}/wechatStatic/poemLectorList.do"></a>
					<div class="zan" onclick="addWantGo();"><em></em><span id="wantCount"></span></div>
				</li>
			</ul>
		</div>
		
		<div class="answerFootWc">
			<div class="answerFoot">
				<span>你已完成了<pcc id="poemCompleteCount"></pcc>首古诗挑战</span>
				<a class="wq" href="${path}/wechatStatic/poemList.do"></a>
			</div>
		</div>
	</div>
</body>
</html>