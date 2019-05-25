<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·文化非遗</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/hsStyle.css"/>
	<style>
		.swiper-container4{
			height: auto;
		}
	</style>
	<script type="text/javascript" src="${path}/STATIC/js/common.js"></script>
	<script>
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '安康文化云·非物质文化遗产风貌';
	    	appShareDesc = '感受乐山非遗项目历史传承、发展，体味传统文化和工艺之美和智慧';
	    	appShareImgUrl = '${basePath}STATIC/wx/image/share_120.png';
	    	
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
					title: "安康文化云·非物质文化遗产风貌",
					desc: '感受乐山非遗项目历史传承、发展，体味传统文化和工艺之美和智慧',
					imgUrl: '${basePath}STATIC/wx/image/share_120.png'
				});
				wx.onMenuShareTimeline({
					title: "感受乐山非遗项目历史传承、发展，体味传统文化和工艺之美和智慧",
					imgUrl: '${basePath}STATIC/wx/image/share_120.png'
				});
				wx.onMenuShareQQ({
					title: "安康文化云·非物质文化遗产风貌",
					desc: '感受乐山非遗项目历史传承、发展，体味传统文化和工艺之美和智慧',
					imgUrl: '${basePath}STATIC/wx/image/share_120.png'
				});
				wx.onMenuShareWeibo({
					title: "安康文化云·非物质文化遗产风貌",
					desc: '感受乐山非遗项目历史传承、发展，体味传统文化和工艺之美和智慧',
					imgUrl: '${basePath}STATIC/wx/image/share_120.png'
				});
				wx.onMenuShareQZone({
					title: "安康文化云·非物质文化遗产风貌",
					desc: '感受乐山非遗项目历史传承、发展，体味传统文化和工艺之美和智慧',
					imgUrl: '${basePath}STATIC/wx/image/share_120.png'
				});
			});
		}
		
		$(function () {
			$.post("${path}/wechatStatic/getCcpHeritageList.do", function (data) {
                if (data.status == 1) {
                	$.each(data.data, function (i, dom) {
                		var imgUrl = getIndexImgUrl(getImgUrl(dom.heritageCoverImg),"_750_500");
                		var heritageDynastyHtml = "";
                		if('${basePath}'.indexOf('http://xc.bj.wenhuayun.cn')<0){	//北京西城不显示朝代
                			heritageDynastyHtml = "<li><p>"+dom.heritageDynasty+"</p></li>";
                		}
                		
                		if(i==0){
                			$("#heritageUl").append("<li>" +
		            				"<div>" +
		        						"<img src='${path}/STATIC/wxStatic/image/feiyi/cover1.jpg' width='750' height='400' />" +
		        					"</div>" +
		        				"</li>");
                		}
                		
                		else if(i==21){
                			$("#heritageUl").append("<li>" +
		            				"<div>" +
		        						"<img src='${path}/STATIC/wxStatic/image/feiyi/cover2.jpg' width='750' height='400' />" +
		        						"</div>" +
		        					"</div>" +
		        				"</li>");
                		}
                		else if(i==24){
                			$("#heritageUl").append("<li>" +
		            				"<div>" +
		        						"<img src='${path}/STATIC/wxStatic/image/feiyi/cover3.jpg' width='750' height='400' />" +
		        						"</div>" +
		        					"</div>" +
		        				"</li>");
                		}
                		
                		$("#heritageUl").append("<li onclick='toHeritageDetail(\""+dom.heritageId+"\");'>" +
						            				"<div>" +
						        						"<img src='"+imgUrl+"' width='750' height='400' />" +
						        						"<div class='feiyi-bg'></div>" +
						        						"<div class='feiyi-pop'>" +
						        							"<p>"+dom.heritageName+"</p>" +
						        							"<div class='feiyi-tag'>" +
						        								"<ul>" +
						        									"<li><p>"+dom.heritageLevel+"</p></li>" +
						        									"<li><p>"+dom.heritageArea.split(",")[1]+"</p></li>" +
						        									heritageDynastyHtml +
						        									"<div style='clear: both;'></div>" +
						        								"</ul>" +
						        							"</div>" +
						        						"</div>" +
						        					"</div>" +
						        				"</li>");
                	})
                }
			},"json");
			
			if (!/wenhuayun/.test(ua)&&self == top) {		//APP端
				$(".newMenuBTN").show();
			}
			
			//底部菜单
			if (!browser.versions.android) {		//非安卓(安卓不识别touchend)
				$(document).on("touchmove", function() {
					$(".newMenu").hide()
				}).on("touchend", function() {
					$(".newMenu").show()
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
			
			if(!browser.versions.ios){	//IOS端(在iframe里不识别scroll)
				//回到顶部按钮显示
				$(window).scroll(function() {
					var screenheight = $(window).height() * 2
					if ($(document).scrollTop() > screenheight) {
						$(".totop").show()
					} else {
						$(".totop").hide()
					}
				})
			}
		});
		
		//跳转到非遗详情页
        function toHeritageDetail(heritageId){
        	if (window.injs) {		//APP端
        		injs.accessDetailPageByApp('${basePath}/wechatStatic/heritageDetail.do?heritageId='+heritageId);
        	}else{
        		window.parent.location.href='${path}/wechatStatic/heritageDetail.do?heritageId='+heritageId;
        	}
        }
	</script>
	
</head>

<body>
	<div class="feiyi-main">
		
				<div onclick="window.parent.location.href='http://www.gpimg.cn/360/zuw7il3hr6c2f69p/'" class="feiyi-top">
					<img src="${path}/STATIC/wxStatic/image/feiyi/feiyi4.png"/>
				
				</div>
			
				<div class="feiyi-top">
					<div onclick="window.parent.location.href='${path}/wechatVenue/preVenueListTagSub.do?tagSubId=82cf7c55502d4955af35d2680bf72a70'">
						<img src="${path}/STATIC/wxStatic/image/feiyi/feiyi1.png"/>
					</div>
					<div onclick="window.parent.location.href='${path}/wechatVenue/preVenueListTagSub.do?tagSubId=d55168cafd7649c8af0c94857f36c071'">
						<img src="${path}/STATIC/wxStatic/image/feiyi/feiyi3.png"/>
					</div>
				</div>
		<!-- <div class="feiyi-menu">
			<ul class="parent">
				<li class="child feiyi-borderbottom">全部</li>
				<li class="child">民间文学</li>
				<li class="child">传统音乐</li>
				<li class="child">传统舞蹈</li>
				<li class="child">传统戏剧</li>
			</ul>
		</div> -->
		<div class="feiyi-content">
			<ul id="heritageUl"></ul>
		</div>
		<%@include file="/WEB-INF/why/wechat/footerMenuList.jsp" %>
	</div>
</body>
</html>