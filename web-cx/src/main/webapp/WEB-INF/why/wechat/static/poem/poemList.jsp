<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>佛山文化云·每日诗品</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series-2.css?t=New Date()"/>
	
	<script>
		var poemDate = '${poemDate}'<'2017-05'?'2017-05':'${poemDate}';
	
		if (userId == null || userId == '') {
			//判断登陆
		   	publicLogin("${basePath}wechatStatic/poemLectorList.do");
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
				jsApiList: ['onMenuShareAppMessage','onMenuShareTimeline','onMenuShareQQ','onMenuShareWeibo','onMenuShareQZone']
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
			$('.reviewNav').css({'width':$('.reviewNav li').length * 115});
			
			$('.reviewNav li').each(function () {
		        if($(this).attr('_time') == poemDate) {
		            $(this).addClass('cur');
		            var _index = $(this).index();
		            if(_index >= 3) {
		                $('.reviewNavWc').scrollLeft((_index - 2) * 115 - 57);
		            } else {
		                $('.reviewNavWc').scrollLeft(0);
		            }
		        }
		    });
			
			loadData(poemDate);
			
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
		
		function huiguFun(ele) {
		    $(ele).parent().find('li').removeClass('cur');
		    $(ele).addClass('cur');
		    var _index = $(ele).index();
		    if(_index >= 3) {
		        $('.reviewNavWc').animate({'scrollLeft' : (_index - 2) * 115 - 57},200);
		    } else {
		        $('.reviewNavWc').animate({'scrollLeft' : 0},200);
		    }
		    
		    $(".reviewTab").html("");
		    $("#noDataDiv").hide();
		    loadData($(ele).attr("_time"));
		}
		
		function loadData(poemDate){
			$.post("${path}/wechatStatic/queryPoemList.do",{poemDate:poemDate,userId:userId}, function (data) {
				if(data.length>0){
					$.each(data, function (i, dom) {
						var poemIsCompleteHtml = "";
						var poemClickHtml = "";
						if(dom.poemIsComplete == 1){
							poemIsCompleteHtml = "<td class='td3' ><div class='zhuang wc'></div><div class='jf'>+100积分</div></div>"
							poemClickHtml = "onclick='location.href=\"${path}/wechatStatic/poemComplete.do?poemDate="+dom.poemDate+"\"'";
						}else{
							poemIsCompleteHtml = "<td class='td3' ><div class='zhuang'></div></div>";
							poemClickHtml = "onclick='location.href=\"${path}/wechatStatic/poemIndex.do?poemDate="+dom.poemDate+"\"'";
						}
						$(".reviewTab").append("<tr "+poemClickHtml+">" +
								                    "<td class='td1'>"+eval(dom.poemDate.substring(8))+"日</td>" +
								                    "<td class='td2'>" +
								                        "<div class='tit'>"+dom.poemTitle+"</div>" +
								                        "<div class='clearfix'>" +
								                            "<div class='chao'>"+dom.poemAuthor+"</div>" +
								                            "<div class='renw'>品诗人："+dom.lectorName+"</div>" +
								                        "</div>" +
								                    "</td>" +
								                    poemIsCompleteHtml +
								                "</tr>");
					});
				}else{
					$("#noDataDiv").show();
				}
			},"json");
		}
	</script>
	
	<style>
		html,body {min-height: 100%;background: url(${path}/STATIC/wxStatic/image/dailyPoetry/bg6.jpg) no-repeat top center;background-color: #eee}
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
		<div class="reviewNavWc">
			<ul class="reviewNav clearfix">
				<li onclick="huiguFun(this)" _time="2017-05"><div class="year">2017</div><div class="month">5月</div></li>
				<li onclick="huiguFun(this)" _time="2017-06"><div class="year">2017</div><div class="month">6月</div></li>
	            <li onclick="huiguFun(this)" _time="2017-07"><div class="year">2017</div><div class="month">7月</div></li>
	            <li onclick="huiguFun(this)" _time="2017-08"><div class="year">2017</div><div class="month">8月</div></li>
	            <li onclick="huiguFun(this)" _time="2017-09"><div class="year">2017</div><div class="month">9月</div></li>
	            <li onclick="huiguFun(this)" _time="2017-10"><div class="year">2017</div><div class="month">10月</div></li>
	            <li onclick="huiguFun(this)" _time="2017-11"><div class="year">2017</div><div class="month">11月</div></li>
	            <li onclick="huiguFun(this)" _time="2017-12"><div class="year">2017</div><div class="month">12月</div></li>
	            <!-- <li onclick="huiguFun(this)" _time="2018-01"><div class="year">2018</div><div class="month">1月</div></li> -->
			</ul>
		</div>
	    <div class="reviewTabWc">
	        <div class="nc">
	            <table class="reviewTab"></table>
	            <div id="noDataDiv" style='display:none;padding-top:320px;font-size: 30px;color: #6B6969;font-weight: bolder;text-align: center;line-height: 30px;'>
	            	<span style="color: red;font-size: 26px;">每日都有一首新诗，敬请期待~</span>
	            </div>
	        </div>
	    </div>
		
		<!-- 导航 -->
		<div class="shiNav">
			<a href="${path}/wechatStatic/poemComplete.do"><span style="background-position: 0 0;"></span></a>
			<a class="cur" href="${path}/wechatStatic/poemList.do"><span style="background-position: 0 -55px;"></span></a>
			<a href="${path}/wechatStatic/poemLectorList.do"><span style="background-position: 0 -110px;"></span></a>
			<a href="${path}/wechatStatic/poemRule.do"><span style="background-position: 0 -165px;"></span></a>
		</div>
	</div>
</body>
</html>