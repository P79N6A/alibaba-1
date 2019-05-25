<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>佛山文化云·艺术天空</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		var selectLocation = 0;	
		var selectArea = 0;	
		var isOrder = '${isOrder}';		//判断是否可开始预订
		
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '佛山文化云-上海国际艺术节之“艺术天空”票务抢鲜兑换中！手慢无！';
	    	appShareDesc = '一年一次国际品质演出，88台艺术剧目倾力奉上，不可错过的艺术盛宴';
	    	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/sky/shareIcon.jpg';
	    	
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
					title: "佛山文化云-上海国际艺术节之“艺术天空”票务抢鲜兑换中！手慢无！",
					desc: '一年一次国际品质演出，88台艺术剧目倾力奉上，不可错过的艺术盛宴',
					imgUrl: '${basePath}/STATIC/wxStatic/image/sky/shareIcon.jpg'
				});
				wx.onMenuShareTimeline({
					title: "佛山文化云-上海国际艺术节之“艺术天空”票务抢鲜兑换中！手慢无！",
					imgUrl: '${basePath}/STATIC/wxStatic/image/sky/shareIcon.jpg'
				});
				wx.onMenuShareQQ({
					title: "佛山文化云-上海国际艺术节之“艺术天空”票务抢鲜兑换中！手慢无！",
					desc: '一年一次国际品质演出，88台艺术剧目倾力奉上，不可错过的艺术盛宴',
					imgUrl: '${basePath}/STATIC/wxStatic/image/sky/shareIcon.jpg'
				});
				wx.onMenuShareWeibo({
					title: "佛山文化云-上海国际艺术节之“艺术天空”票务抢鲜兑换中！手慢无！",
					desc: '一年一次国际品质演出，88台艺术剧目倾力奉上，不可错过的艺术盛宴',
					imgUrl: '${basePath}/STATIC/wxStatic/image/sky/shareIcon.jpg'
				});
				wx.onMenuShareQZone({
					title: "佛山文化云-上海国际艺术节之“艺术天空”票务抢鲜兑换中！手慢无！",
					desc: '一年一次国际品质演出，88台艺术剧目倾力奉上，不可错过的艺术盛宴',
					imgUrl: '${basePath}/STATIC/wxStatic/image/sky/shareIcon.jpg'
				});
			});
		}
		
		$(function() {
			//loadData('c7b503c9b63946d896d4213633c62882','actListByLocation');
			//loadData('d6ac546a6bc3496cac6cdc46012ddffc','actListByLocation');
			//loadData('fac89e6627f9428d9320f526342d33d6','actListByArea');
			//loadData('88004b0a032a4b07ab3a420a64d66c77','actListByArea');
			
			//默认展开
			//moreActivtiy('actListByLocation');
			//moreActivtiy('actListByArea');
			
			//中心场次UL的宽度
			var num_1width = $("#sky2center li").length * 375
			$("#sky2center").css("width", num_1width)

			//家门口的场次UL的宽度
			var num_2width = $("#sky2home li").length * 160
			$("#sky2home").css("width", num_2width)
			
			//精彩剧目UL宽度
			var num_3width = $("#sky2BList1 ul li").length * 300
			$("#sky2BList1 ul").css("width", num_3width)

			//精彩直击UL宽度
			var num_4width = $("#sky2BList2 ul li").length * 300
			$("#sky2BList2 ul").css("width", num_4width)

			//分享
			$(".shareBtn").click(function() {
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
			$(".keepBtn").on("touchstart", function() {
				$('.div-share').show()
				$("body,html").addClass("bg-notouch")
			})
		})
		
		//加载数据
		function loadData(activityId,htmlId){
			$.post("${path}/wechatActivity/activityWcDetail.do", {activityId: activityId,activityIsDel:3}, function (data) {
                if (data.status == 1) {
                	var activity = data.data;
                	var time = activity.activityStartTime.replace("-","/").replace("-","/");
                    if (activity.activityEndTime.length != 0&&activity.activityStartTime!=activity.activityEndTime) {
                    	time += "&nbsp;-&nbsp;"+activity.activityEndTime.replace("-","/").replace("-","/");
                    }
                    var orderBtnHtml = '';
                    var toDeatail = "";
                   	if(isOrder==1){
                       	toDeatail = "onclick=\"toActDetail('"+activity.activityId+"')\"";
                       	if (activity.activityIsPast==1) {
                           	orderBtnHtml = "<div class='sky2DBtn sky2DBtnOff'>已结束</div>";
                           	return;
                        }else{
                           	if(activity.activityIsReservation == 2){
                           		if(activity.activityAbleCount > 0){
                           			if(activity.status.indexOf(1)>=0){
                           				orderBtnHtml = "<div class='sky2DBtn'>立即订票</div>";
                           			}else{
                           				orderBtnHtml = "<div class='sky2DBtn sky2DBtnOff'>无法预订</div>";
                           			}
                           		}else{
                           			orderBtnHtml = "<div class='sky2DBtn sky2DBtnOff'>已订完</div>";
                           		}
                           	}else{
                           		orderBtnHtml = "<div class='sky2DBtn sky2DBtnOff'>直接前往</div>";
                           	}
                        }
                    }else{
                       	orderBtnHtml = "<div class='sky2DBtn sky2DBtnOff'>未开始</div>";
                    }
                	$("#"+htmlId).append("<li "+toDeatail+">" +
				        					"<div class='sky2MLDImg'>" +
					    						"<img src='"+getIndexImgUrl(activity.activityIconUrl, "_300_300")+"' width='290' height='175'/>" +
					    					"</div>" +
					    					"<div class='sky2MLInfo'>" +
					    						"<div class='sky2DTitle'>"+activity.activityName+"</div>" +
					    						"<div class='sky2DPlace'>"+activity.activityAddress+"</div>" +
					    						"<div class='sky2DTime'>"+time+"</div>" +
					    					"</div>" +
					    					"<div style='clear: both;'></div>" +orderBtnHtml+
					    				"</li>");
                }else if(data.status == 500) {
                    window.location.href = "${path}/timeOut.html";
                }
			}, "json");
		}
		
		//我的订单
		function preOrderList(){
			if (userId == null || userId == '') {
	    		//判断登陆
	        	publicLogin('${basePath}wechatStatic/artSky.do');
	    	}else{
	    		if (window.injs) {	//判断是否存在方法
	                injs.accessAppPage(7, 1);
	            } else {
	                window.location.href = "${path}/wechatActivity/wcOrderList.do";
	            }
	    	}
		}
		
		//更多活动
		function moreActivtiy(htmlId){
			if(htmlId=="actListByLocation"){
				$("#moreBtn1").attr("onclick","packupActivtiy('actListByLocation');");
				$("#moreBtn1 span").text("收起");
				$("#moreBtn1 img").addClass("sky2rot");
				
				if(selectLocation==0){
					loadData('ccc5bf58de0e4fe2bba85df8f6497c23',htmlId);
					loadData('36753b57b2d54159b479a8259d1adca0',htmlId);
					loadData('deb27092739d4267a2d37454758fc466',htmlId);
					loadData('dc91403ab49b44868d19070098d0c41d',htmlId);
					loadData('8f3d028f980a47d087dcab88260c3776',htmlId);
					loadData('c2a0df33606c48abb67ad8412da437ed',htmlId);
					loadData('78a78062e5f340f69a4cad19c90054a8',htmlId);
					loadData('f4cde2bdf9b44709ad65e8c037f44524',htmlId);
					loadData('921ff26c7afe40a891fbfe9139026d39',htmlId);
					loadData('a65a917c81824e19822178b07364d3ee',htmlId);
					loadData('17fcbc93bc9a446a9a649742973081d1',htmlId);
					loadData('70907d2b20f04faabc50b405c383c5f4',htmlId);
					loadData('7b18d2b176f5473583a47cbf6ee11047',htmlId);
					loadData('b861d12c414e490aa04f2809bcb38800',htmlId);
					loadData('2ff554d7b22f4fa1a53368a1d9469335',htmlId);
					loadData('4d05802d05a343f9ade4b430a76a9f29',htmlId);
				}else if(selectLocation==1){
					loadData('9709dcfbf26143458d66be005e51c66b',htmlId);
					loadData('6affba69982042968b46908fc88126f6',htmlId);
					loadData('854f9bd36c174b2bb64dcd9137cd7234',htmlId);
					loadData('3a2c6871a0784c5c8c542b132d101d8c',htmlId);
					loadData('bb196aa3868e4c66892fe019c041cd21',htmlId);
					loadData('d46812c7f3e94fa0803bf62daeeddf75',htmlId);
				}else if(selectLocation==2){
					loadData('0f0d88af83cb4da28238c10d8343256a',htmlId);
					loadData('38677751dcb842d59ef83f26dcb1edd7',htmlId);
					loadData('65518d8486f84305b94fc7134199433e',htmlId);
					loadData('7d4521ac8dd541f0a382fac2735fc740',htmlId);
					loadData('58065af200bb45f58fd1f3c0d9348e96',htmlId);
				}else if(selectLocation==3){
					loadData('c31ebf0487ce4d8fb6a264f1ebc44489',htmlId);
				}
			}else if(htmlId=="actListByArea"){
				$("#moreBtn2").attr("onclick","packupActivtiy('actListByArea');");
				$("#moreBtn2 span").text("收起");
				$("#moreBtn2 img").addClass("sky2rot");
				
				if(selectArea==0){
					loadData('fac89e6627f9428d9320f526342d33d6',htmlId);
					loadData('88004b0a032a4b07ab3a420a64d66c77',htmlId);
				}else if(selectArea==1){
					loadData('c7b503c9b63946d896d4213633c62882',htmlId);
					loadData('d6ac546a6bc3496cac6cdc46012ddffc',htmlId);
				}else if(selectArea==2){
					loadData('f52e89fe060c4fd2b26214f6d6373d72',htmlId);
					loadData('edf1b49b389b40f9a1ef849182cd0d2a',htmlId);
				}
			}
		}
		
		//收起活动
		function packupActivtiy(htmlId){
			if(htmlId=="actListByLocation"){
				$("#actListByLocation").html("");
				$("#moreBtn1").attr("onclick","moreActivtiy('actListByLocation');");
				$("#moreBtn1 span").text("更多活动");
				$("#moreBtn1 img").removeClass("sky2rot");
				
				if(selectLocation==0){
					loadData('c7b503c9b63946d896d4213633c62882',htmlId);
					loadData('d6ac546a6bc3496cac6cdc46012ddffc',htmlId);
				}else if(selectLocation==1){
					loadData('fac89e6627f9428d9320f526342d33d6',htmlId);
					loadData('88004b0a032a4b07ab3a420a64d66c77',htmlId);
				}else if(selectLocation==2){
					loadData('f52e89fe060c4fd2b26214f6d6373d72',htmlId);
					loadData('edf1b49b389b40f9a1ef849182cd0d2a',htmlId);
				}else if(selectLocation==3){
					loadData('0d4a043e966942d9af04d1e4cf5759b4',htmlId);
					loadData('e1f76f57011d4741a3767bb9edbf9663',htmlId);
				}
			}else if(htmlId=="actListByArea"){
				$("#actListByArea").html("");
				$("#moreBtn2").attr("onclick","moreActivtiy('actListByArea');");
				$("#moreBtn2 span").text("更多活动");
				$("#moreBtn2 img").removeClass("sky2rot");
				
				if(selectArea==0){
					loadData('fac89e6627f9428d9320f526342d33d6',htmlId);
					loadData('88004b0a032a4b07ab3a420a64d66c77',htmlId);
				}else if(selectArea==1){
					loadData('c7b503c9b63946d896d4213633c62882',htmlId);
					loadData('d6ac546a6bc3496cac6cdc46012ddffc',htmlId);
				}else if(selectArea==2){
					loadData('f52e89fe060c4fd2b26214f6d6373d72',htmlId);
					loadData('edf1b49b389b40f9a1ef849182cd0d2a',htmlId);
				}
			}
		}
		
		//商圈点击事件
		function locationSelectBtn(index){
			$("#locationBtn0").attr("onclick","locationSelectBtn(0)");
			$("#locationBtn1").attr("onclick","locationSelectBtn(1)");
			$("#locationBtn2").attr("onclick","locationSelectBtn(2)");
			$("#locationBtn3").attr("onclick","locationSelectBtn(3)");
			$("#locationBtn"+index).attr("onclick","");
			
			$("#sky2center li div").removeClass("sky2Chose");
			$("#sky2center li div:eq("+index+")").addClass("sky2Chose");
			
			selectLocation = index;
			packupActivtiy("actListByLocation");
			
			//默认展开
			moreActivtiy('actListByLocation');
		}
		
		//区域点击事件
		function areaSelectBtn(index){
			$("#areaBtn0").attr("onclick","areaSelectBtn(0)");
			$("#areaBtn1").attr("onclick","areaSelectBtn(1)");
			$("#areaBtn2").attr("onclick","areaSelectBtn(2)");
			$("#areaBtn3").attr("onclick","areaSelectBtn(3)");
			$("#areaBtn"+index).attr("onclick","");
			
			$("#sky2home li div").removeClass("sky2Chose");
			$("#sky2home li div:eq("+index+")").addClass("sky2Chose");
			
			selectArea = index;
			packupActivtiy("actListByArea");
			
			//默认展开
			moreActivtiy('actListByArea');
		}
		
	</script>
	
	<style>
		.sky2rot {
			transform: rotate(180deg);
			-o-transform: rotate(180deg);
			-webkit-transform: rotate(180deg);
			-moz-transform: rotate(180deg);
		}
		.sky2MLPlace1>ul>li>div {
		    width: 325px;
		    line-height:90px;
		}
	</style>
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wxStatic/image/sky/shareIcon.jpg"/></div>
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
	<div class="sky2">
		<div class="youthArtHead">
			<img src="${path}/STATIC/wxStatic/image/sky2info/sky2banner.jpg" />
			<ul class="lcchk_ban_ul clearfix" style="width: auto;right: 20px;">
				<li><a href="javascript:void(0)" class="shareBtn">分享</a></li>
				<li><a href="javascript:void(0)" class="keepBtn">关注</a></li>
			</ul>
		</div>
		<div class="sky2MenuList" style="margin-bottom: 8px;">
			<div class="sky2L" onclick="location.href='${path}/information/preInfo.do?informationId=14161febbc024242a894ae56c30b390b'">
				<img src="${path}/STATIC/wxStatic/image/sky2info/pic1.jpg" />
			</div>
			<div class="sky2R" onclick="location.href='${path}/information/preInfo.do?informationId=d17b74abaf444262b5d999a2598f251f'">
				<img src="${path}/STATIC/wxStatic/image/sky2info/pic2.jpg" />
			</div>
			<div class="sky2L" onclick="location.href='${path}/wechatStatic/artAnswer.do'">
				<img src="${path}/STATIC/wxStatic/image/sky2info/pic3.jpg" />
			</div>
			<div class="sky2R" onclick="preOrderList();">
				<img src="${path}/STATIC/wxStatic/image/sky2info/pic4.jpg" />
			</div>
			<div style="clear: both;"></div>
		</div>

		<!--中心场次-->
		<%-- <div class="sky2InfoTitle">中心场次</div>
		<div style="height: 90px;width: 750px;overflow: hidden;margin: auto;">
			<div class="sky2MLPlace1" style="height: 150px;">
				<ul id="sky2center" style="height: 90px;">
					<li><div class="sky2Chose" id="locationBtn0" onclick="locationSelectBtn(0);">上海城市草坪音乐广场</div></li>
					<li style="display: none;"><div id="locationBtn1" onclick="locationSelectBtn(1);">大宁<br />郁金香公园</div></li>
					<li style="display: none;"><div id="locationBtn2" onclick="locationSelectBtn(2);">中山公园</div></li>
					<li><div id="locationBtn3" onclick="locationSelectBtn(3);">虹桥艺术中心</div></li>
					<div style="clear: both;"></div>
				</ul>
			</div>
		</div>
		<div class="sky2MLDetail">
			<ul id="actListByLocation" style="overflow: hidden;min-height: 632px;"></ul>
		</div>
		<div id="moreBtn1" class="sky2MoreBtn" onclick="moreActivtiy('actListByLocation');" style="border-bottom: 10px solid #eee;"><span style="color: #999;">更多活动</span><img style="margin-left: 10px;display: inline-block;" src="${path}/STATIC/wxStatic/image/sky2info/more.png" /></div> --%>

		<!--家门口的活动-->
		<%-- <div class="sky2InfoTitle">家门口的活动</div>
		<div class="sky2MLPlace2">
			<ul id="sky2home">
				<li><div class="sky2Chose" id="areaBtn0" onclick="areaSelectBtn(0);">静安</div></li>
				<li><div id="areaBtn1" onclick="areaSelectBtn(1);">黄埔</div></li>
				<li><div id="areaBtn2" onclick="areaSelectBtn(2);">长宁</div></li>
				<div style="clear: both;"></div>
			</ul>
		</div>
		<div class="sky2MLDetail">
			<ul id="actListByArea" style="overflow: hidden;min-height: 632px;"></ul>
		</div>
		<div id="moreBtn2" class="sky2MoreBtn" onclick="moreActivtiy('actListByArea');" style="border-bottom: 10px solid #eee;"><span style="color: #999;">更多活动</span><img style="margin-left: 10px;display: inline-block;" src="${path}/STATIC/wxStatic/image/sky2info/more.png" /></div> --%>

		<%-- <div style="border-bottom: 10px solid #eee;" onclick="location.href='${path}/wechatStatic/liveText.do'">
			<img style="display: block;" src="${path}/STATIC/wxStatic/image/sky2info/img8.jpg" />
		</div> --%>

		<!--艺术大师-->
		<div class="youthArtTips">
			<p class="youthArtTipsTt">嘉宾介绍</p>
			<div class="hkPeoList">
				<ul>
					<li>
						<div style="float: left;">
							<img src="${path}/STATIC/wxStatic/image/sky2info/pic5.jpg" width="150" />
						</div>
						<div style="float: left;width: 500px;margin-left: 30px;">
							<p class="hkPeoListName">英国圣三一男童合唱团</p>
							<p class="hkPeoListDetl">英国圣三一男童合唱团是世界上最著名的童声合唱团之一，无论是在英国国内还是国外，在近50年中，该合唱团都享有很高的关注度。合唱团在英国戈林德伯恩歌剧院、皇家歌剧院、伦敦考文特花园、英国国家歌剧院等各种歌剧院演出过。除此之外，还在英国作曲家本杰明·布里顿的歌剧《仲夏夜之梦》中担任合唱，并因此声名大噪。</p>
						</div>
						<div style="clear: both;"></div>
					</li>
					<li>
						<div style="float: left;">
							<img src="${path}/STATIC/wxStatic/image/sky2info/pic6.jpg" width="150" />
						</div>
						<div style="float: left;width: 500px;margin-left: 30px;">
							<p class="hkPeoListName">卡塔尔爱乐乐团</p>
							<p class="hkPeoListDetl">卡塔尔爱乐乐团是阿拉伯世界最优秀也是最为人熟知的交响乐团。乐团于2007年由卡塔尔莫扎王妃亲手建立并赞助,全团101名职业音乐家均通过严格筛选自欧洲与中东国家的一线名团。</p>
						</div>
						<div style="clear: both;"></div>
					</li>
					<li>
						<div style="float: left;">
							<img src="${path}/STATIC/wxStatic/image/sky2info/pic7.jpg" width="150" />
						</div>
						<div style="float: left;width: 500px;margin-left: 30px;">
							<p class="hkPeoListName">央吉玛与她的乐队</p>
							<p class="hkPeoListDetl">央吉玛是门巴族第七代，生于西藏林芝墨脱，信仰藏传佛教。多年来，她一直致力于把自己族人的音乐传承下来。对于央吉玛现在的音乐，有人称为世界音乐，也有人称为民谣，但央吉玛并无意将自己的音乐定性，“比较融合”，她这样形容自己的音乐。</p>
						</div>
						<div style="clear: both;"></div>
					</li>
					<li>
						<div style="float: left;">
							<img src="${path}/STATIC/wxStatic/image/sky2info/pic8.jpg" width="150" />
						</div>
						<div style="float: left;width: 500px;margin-left: 30px;">
							<p class="hkPeoListName">迪图瓦与英国皇家爱乐乐团</p>
							<p class="hkPeoListDetl">英国皇家爱乐乐团于1946年创立，并于1966年被英国女皇为乐团冠上“皇家”头衔，奠定了其在英国乐坛无可取代的地位。乐团现任音乐总监是全球五位杰出的指挥之——夏尔·迪图瓦。他1936年出生于瑞士洛桑，先后就读于洛桑音乐学院，日内瓦音乐学院。</p>
						</div>
						<div style="clear: both;"></div>
					</li>
				</ul>
			</div>
		</div>

		<!--精彩剧目-->
		<div class="sky2Brilliant" style="padding-top: 20px;border-bottom: 10px solid #eee;">
			<p class="youthArtTipsTt">精彩剧目</p>
			<div class="sky2BList1" id="sky2BList1">
				<ul>
					<li onclick="location.href='https://mp.weixin.qq.com/s?__biz=MzA5NTQ1MDM2Mg==&mid=2651694220&idx=1&sn=0d41fa4f2a925ec8e6a2ab09828c80dd&chksm=8b462119bc31a80f3141e5505daa22a730e94753c43d35be22c57ee1dd3d043afd1d4cb1f500&mpshare=1&scene=1&srcid=1009G8OrCA6P1cFWi9EjwPOd&key=c50f8b988e61749a9dcdf4f3429fbb6196cd3819304ed0fdc4acf5440ce3e9fe85a6b59bdc950cbbe7a4b410e1f48df4&ascene=0&uin=NjIyNDU5ODAw&devicetype=iMac15%2C1+OSX+OSX+10.11.3+build(15D21)&version=11020201&pass_ticket=DQQ3DJTsKCakX3cSSHjX7ped%2FbvjhBD6zO4aS0WkUJxzPKgAKHko7IsEkI1pWhhz'">
						<img src="${path}/STATIC/wxStatic/image/sky2info/br1.jpg" width="280" />
						<p>红河州歌舞团<br />《诺玛阿美》</p>
					</li>
					<li onclick="location.href='https://mp.weixin.qq.com/s?__biz=MzA5NTQ1MDM2Mg==&mid=2651694245&idx=2&sn=903976e9da5428d2bb37c762daacdced&chksm=8b462130bc31a8260900be26fdcdbefe26fe7ecab1f0e0cdda60ed5967f7237bf4d8d109b686&mpshare=1&scene=1&srcid=1009sixfhcbjrnPkR3wyx3R5&key=c50f8b988e61749afe0ef8c68b40f1ed41c7adc7097bb9fde471c44312245fa3830b38a299bd606b0a3d14f613842571&ascene=0&uin=NjIyNDU5ODAw&devicetype=iMac15%2C1+OSX+OSX+10.11.3+build(15D21)&version=11020201&pass_ticket=DQQ3DJTsKCakX3cSSHjX7ped%2FbvjhBD6zO4aS0WkUJxzPKgAKHko7IsEkI1pWhhz'">
						<img src="${path}/STATIC/wxStatic/image/sky2info/br2.jpg" width="280" />
						<p>加拿大魁北克<br/>音乐会ILAM</p>
					</li>
					<li onclick="location.href='https://mp.weixin.qq.com/s?__biz=MzA5NTQ1MDM2Mg==&mid=2651694251&idx=2&sn=a00147c00b451795978b970a4dd31bd8&chksm=8b46213ebc31a828b9aabd20a89ed37dd68976ddf4813a04c728ecba201c1c57142bddd9b536&mpshare=1&scene=1&srcid=10095xhjdyD8sj3X0wrGn1gZ&key=c50f8b988e61749a116a73bf1eb9e95763b56c2088a0cb87cfc33e253205c010107d1dbe6ac7a07c7891c416e669d870&ascene=0&uin=NjIyNDU5ODAw&devicetype=iMac15%2C1+OSX+OSX+10.11.3+build(15D21)&version=11020201&pass_ticket=DQQ3DJTsKCakX3cSSHjX7ped%2FbvjhBD6zO4aS0WkUJxzPKgAKHko7IsEkI1pWhhz'">
						<img src="${path}/STATIC/wxStatic/image/sky2info/br3.jpg" width="280" />
						<p>凯尔特女人合唱团</p>
					</li>
					<li onclick="location.href='https://mp.weixin.qq.com/s?__biz=MzA5NTQ1MDM2Mg==&mid=2651694192&idx=2&sn=8381d0c61955eedf83736c713cb9b563&chksm=8b4621e5bc31a8f3c1f10ff6325a98df67f998b58a912be775ac5a74e2709fa5afcf170caaf4&mpshare=1&scene=1&srcid=10098fmyu329IFkP02VKTnuY&key=c50f8b988e61749ae72350994582949fc7132d2a4a0bc56a31c4722ec13905778da1e89b1dd414f1fcc4903d8469b3dd&ascene=0&uin=NjIyNDU5ODAw&devicetype=iMac15%2C1+OSX+OSX+10.11.3+build(15D21)&version=11020201&pass_ticket=DQQ3DJTsKCakX3cSSHjX7ped%2FbvjhBD6zO4aS0WkUJxzPKgAKHko7IsEkI1pWhhz'">
						<img src="${path}/STATIC/wxStatic/image/sky2info/br4.jpg" width="280" />
						<p>闲舞人剧场<br/>《莲花》</p>
					</li>
					<li onclick="location.href='https://mp.weixin.qq.com/s?__biz=MzA5NTQ1MDM2Mg==&mid=2651694252&idx=2&sn=f4600b97c3535d442232f29af29d5228&chksm=8b462139bc31a82f8f60629bd8a76d48e7c6fadcb261a8f6bd186d679f9e0993d219f5f296ae&mpshare=1&scene=1&srcid=1009OuuPCn1XJnrbk97WAjQu&key=c50f8b988e61749abb7dca9d72dc16e54b0a42b45d049a54c07fb32d31cc297fe6345b2d0d928fbc8e2ce0f8e5474381&ascene=0&uin=NjIyNDU5ODAw&devicetype=iMac15%2C1+OSX+OSX+10.11.3+build(15D21)&version=11020201&pass_ticket=DQQ3DJTsKCakX3cSSHjX7ped%2FbvjhBD6zO4aS0WkUJxzPKgAKHko7IsEkI1pWhhz'">
						<img src="${path}/STATIC/wxStatic/image/sky2info/br5.jpg" width="280" />
						<p>张军新昆曲音乐会</p>
					</li>
					<div style="clear: both;"></div>
				</ul>
			</div>
		</div>

		<!--精彩剧目-->
		<%-- <div class="sky2Brilliant" style="padding-top: 20px;border-bottom: 10px solid #eee;">
			<p class="youthArtTipsTt">精彩直击</p>
			<div class="sky2BList1" id="sky2BList2">
				<ul>
					<li>
						<div class="sky2video">
							<img src="${path}/STATIC/wxStatic/image/sky2info/img3.jpg" width="280" onclick="document.getElementById('video1').play()" />
							<video id="video1" src="http://culturecloud.oss-cn-hangzhou.aliyuncs.com/mp4MultibitrateIn55/%E5%9B%9E%E5%AE%B6%E8%BF%87%E5%B9%B4.mp4" style="width:10px;height: 10px;position: absolute;left: 0;right: 0;bottom: 0;top: 0;margin: auto;z-index: 1;"></video>
						</div>
						<p>美国泡泡大师<br />《魔幻泡泡秀》</p>
					</li>
					<li>
						<div class="sky2video">
							<img src="${path}/STATIC/wxStatic/image/sky2info/img3.jpg" width="280" onclick="document.getElementById('video2').play()" />
							<video id="video2" src="http://culturecloud.oss-cn-hangzhou.aliyuncs.com/mp4MultibitrateIn55/%E5%9B%9E%E5%AE%B6%E8%BF%87%E5%B9%B4.mp4" style="width:10px;height: 10px;position: absolute;left: 0;right: 0;bottom: 0;top: 0;margin: auto;z-index: 1;"></video>
						</div>
						<p>美国泡泡大师<br />《魔幻泡泡秀》</p>
					</li>
					<li>
						<div class="sky2video">
							<img src="${path}/STATIC/wxStatic/image/sky2info/img3.jpg" width="280" onclick="document.getElementById('video3').play()" />
							<video id="video3" src="http://culturecloud.oss-cn-hangzhou.aliyuncs.com/mp4MultibitrateIn55/%E5%9B%9E%E5%AE%B6%E8%BF%87%E5%B9%B4.mp4" style="width:10px;height: 10px;position: absolute;left: 0;right: 0;bottom: 0;top: 0;margin: auto;z-index: 1;"></video>
						</div>
						<p>美国泡泡大师<br />《魔幻泡泡秀》</p>
					</li>
					<li>
						<div class="sky2video">
							<img src="${path}/STATIC/wxStatic/image/sky2info/img3.jpg" width="280" onclick="document.getElementById('video4').play()" />
							<video id="video4" src="http://culturecloud.oss-cn-hangzhou.aliyuncs.com/mp4MultibitrateIn55/%E5%9B%9E%E5%AE%B6%E8%BF%87%E5%B9%B4.mp4" style="width:10px;height: 10px;position: absolute;left: 0;right: 0;bottom: 0;top: 0;margin: auto;z-index: 1;"></video>
						</div>
						<p>美国泡泡大师<br />《魔幻泡泡秀》</p>
					</li>
					<div style="clear: both;"></div>
				</ul>
			</div>
		</div> --%>

		<!--热门回顾-->
		<div class="sky2HotReview" style="padding-top: 20px;">
			<p class="youthArtTipsTt">热门回顾</p>
			<div class="sky2HRList">
				<ul>
					<li onclick="toActDetail('c7b503c9b63946d896d4213633c62882')">
						<img src="${path}/STATIC/wxStatic/image/sky2info/img5.jpg" />
						<p>长征路上民歌行——上海民族乐团纪念红军长征胜利八十周年音乐会</p>
					</li>
					<li onclick="toActDetail('d6ac546a6bc3496cac6cdc46012ddffc')">
						<img src="${path}/STATIC/wxStatic/image/sky2info/img6.jpg" />
						<p>“天草之间”上海首届游牧音乐会</p>
					</li>
					<li onclick="toActDetail('88004b0a032a4b07ab3a420a64d66c77')">
						<img src="${path}/STATIC/wxStatic/image/sky2info/img7.jpg" />
						<p>央吉玛《莲花秘境》音乐会-静安场</p>
					</li>
				</ul>
			</div>
		</div>
	</div>
</body>
</html>