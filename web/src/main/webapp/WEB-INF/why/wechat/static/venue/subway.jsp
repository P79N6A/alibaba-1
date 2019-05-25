<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·文化地铁</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '申通地铁进驻文化云';
	    	appShareDesc = '打造公共文化新空间';
	    	appShareImgUrl = '${basePath}/STATIC/wx/image/share_120.png';
	    	
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
					title: "申通地铁进驻文化云",
					desc: '打造公共文化新空间',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
				wx.onMenuShareTimeline({
					title: "打造公共文化新空间",
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
				wx.onMenuShareQQ({
					title: "申通地铁进驻文化云",
					desc: '打造公共文化新空间',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
				wx.onMenuShareWeibo({
					title: "申通地铁进驻文化云",
					desc: '打造公共文化新空间',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
				wx.onMenuShareQZone({
					title: "申通地铁进驻文化云",
					desc: '打造公共文化新空间',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
				});
			});
		}
		
		$(function() {
			//正在进行活动
			$.post("${path}/wechatVenue/venueWcActivity.do", {venueId:'c8af10f8b9d64339a3a980a922502230'}, function (data) {
                if (data.status == 0) {
                	$.each(data.data, function (i, dom) {
                		var time = dom.activityStartTime.substring(5, 10).replace("-", ".");
                        if (dom.activityEndTime.length > 0&&dom.activityStartTime!=dom.activityEndTime) {
                            time += "-" + dom.activityEndTime.substring(5, 10).replace("-", ".");
                        }
                        var activityIconUrl = getIndexImgUrl(dom.activityIconUrl, "_750_500");
                        var price = "";
                        if(dom.activityAbleCount > 0 || dom.activityIsReservation == 1){
                        	if (dom.activityPrice.length != 0 && dom.activityPrice > 0) {
                        		if (dom.activityPrice.length != 0 && dom.activityPrice > 0) {
                        			if(dom.priceType==0){
            							price += "<span style='font-size: 57px;'>" + dom.activityPrice + "</span>元起";
            						}else{
            							price += "<span style='font-size: 57px;'>" + dom.activityPrice + "</span>元/人";
            						}
                        		}else{
                        			price += "<span style='font-size: 57px;'>收费</span>";
                        		}
                            } else {
                                price += "<span style='font-size: 57px;'>免费</span>";
                            }
                        }else{
                        	price += "<span style='font-size: 57px;'>已订完</span>";
                        }
                		var tagHtml = "<ul class='metro-img-tag'>";
            			tagHtml += "<li><p>"+dom.activitySubject.substring(dom.activitySubject.length-4)+"</p></li>";
            			tagHtml += "<li><p>"+dom.tagName+"</p></li>";
            			if(dom.activitySubject.length>4){
            				tagHtml += "<li><p>"+dom.activitySubject.substring(0,dom.activitySubject.length-5)+"</p></li>";
            			}
            			tagHtml += "</ul>"
                		$("#activityList").append("<div class='metro-img-detail' onclick='toActDetail(\""+dom.activityId+"\")'>" +
						            					"<img src='"+activityIconUrl+"' style='width: 750px;height: 475px;' />" +
								    					"<img src='${path}/STATIC/wxStatic/image/subway/400.png' style='position: absolute;left: 0px;top: 0px;width: 750px;height: 475px;' />" +
								    					"<p style='font-size: 40px;color: #fff;position: absolute;left: 20px;bottom: 110px;'>"+dom.activityName+"</p>" +
								    					"<p style='padding-left: 30px;background: url(${path}/STATIC/wxStatic/image/subway/map.png)no-repeat left center;position: absolute;left: 20px;bottom: 60px;color: #fff;font-size: 24px;line-height: 40px;'>"+dom.activityLocationName+"</p>" +
								    					tagHtml +
								    					"<p style='position: absolute;right: 20px;bottom: 60px;color: #fff;font-size: 40px;line-height: 40px;'>"+price+"</p>" +
								    					"<p style='position: absolute;right: 20px;bottom: 20px;color: #fff;font-size: 24px;line-height: 40px;'>"+time+"</p>" +
								    			  "</div>");
                	});
                }
			}, "json");
			
			//过往活动
			$.post("${path}/wechatVenue/venueWcHisActivity.do", {venueId:'c8af10f8b9d64339a3a980a922502230'}, function (data) {
                if (data.status == 0) {
                	$.each(data.data, function (i, dom) {
                		var activityIconUrl = getIndexImgUrl(dom.activityIconUrl, "_750_500");
                		$("#activityHisUl").prepend("<li onclick='toActDetail(\""+dom.activityId+"\")'>" +
														"<img src='"+activityIconUrl+"' width='270' height='170' />" +
														"<div class='metro-tab-list-p'>" +
															"<p>"+dom.activityName+"</p>" +
														"</div>" +
													"</li>");
                	});
                	var width_li = $(".metro-tab-list>ul>li").width() + 22;
        			var num_li = $(".metro-tab-list>ul>li").length * width_li;
        			$(".metro-tab-list>ul").css("width", num_li);
                }
			}, "json");
			
			//顶部banner图隐藏
			$(document).scroll(function() {
				if($(document).scrollTop() > 280) {
					$(".metro-menu").css({
						"padding": "0px",
						"position": "fixed",
						"top": "0px",
						"left": "0px",
						"z-index":"10"
					})
				} else {
					$(".metro-menu").css({
						"padding": "20px 0px 30px",
						"position": "static"
					})
				}
			})

			//锚
			$(".metro-menu-list").click(function() {
				$(".metro-menu-list").removeClass("metro-menu-on")
				$(this).addClass("metro-menu-on")
				switch($(this).index()) {
					case 0:
						$("html,body").animate({
							scrollTop: $(".part1").offset().top - 352
						}, 500);
						break;
					case 1:
						$("html,body").animate({
							scrollTop: $(".part2").offset().top - 352
						}, 500);
						break;
					case 2:
						$("html,body").animate({
							scrollTop: $(".part3").offset().top - 352
						}, 500);
						break;
				}
			})

			//地铁线路点击事件
			$(".metro-tag").on("touchstart", function() {
				var this_num = $(this).index()
				$(".triangle").css("border-bottom", "25px solid #fff");
				$(".triangle-down").css({
					"color": "#262626",
					"background-color": "#fff"
				})
				$(".metro-point").attr("src", "${path}/STATIC/wxStatic/image/subway/8.png")
				$(".metro-point").css("z-index", "0")
				for(var i = 0; i <= this_num; i++) {
					$(".metro-tag").eq(i).find(".triangle").css("border-bottom", "25px solid #ff5077");
					$(".metro-tag").eq(i).find(".triangle-down").css({
						"background-color": "#ff5077",
						"color": "#fff",
					})
					$(".metro-point").eq(i).attr("src", "${path}/STATIC/wxStatic/image/subway/circle-red.png")
					$(".metro-point").eq(i).css("z-index", "9")
				}
				switch(this_num) {
					case 0:
						$(".red-line").css("width", "150px")
						break;
					case 1:
						$(".red-line").css("width", "240px")
						break;
					case 2:
						$(".red-line").css("width", "330px")
						break;
					case 3:
						$(".red-line").css("width", "430px")
						break;
					case 4:
						$(".red-line").css("width", "530px")
						break;
					case 5:
						$(".red-line").css("width", "620px")
						break;
					case 6:
						$(".red-line").css("width", "750px")
						break;
					default:
						break;
				}
			})
		})

		//地铁弹窗 正在制作中
		function metroMaking(div) {
			$(div).append(
				"<div class='metro-pop' style='position: absolute;left: -30px;top: 0px;width: 100px;'><p style='color: red;font-size: 20px;'>正在制作中</p></div>"
			)
			$(".metro-pop").animate({
				"top": "-100px"
			}).fadeOut(function() {
				$(this).remove()
			})
		}
		
      	//跳转到咨询页
        function toInfoDetail(infoId){
        	if (window.injs) {		//APP端
        		injs.accessDetailPageByApp('${basePath}/information/preInfo.do?informationId='+infoId);
        	}else{
        		window.parent.location.href='${path}/information/preInfo.do?informationId='+infoId;
        	}
        }
		
	</script>
</head>

<body>
	<div class="metro-main">
		<div class="metro-content">
			<div class="metro-head-img">
				<img src="${path}/STATIC/wxStatic/image/subway/banner.png" />
			</div>
			<div style="width: 750px;height: 102px;">
				<div class="metro-menu">
					<div class="metro-menu-list metro-border-right metro-menu-on">
						<p>音乐角</p>
					</div>
					<div class="metro-menu-list metro-border-right">
						<p>文化长廊</p>
					</div>
					<div class="metro-menu-list">
						<p>文化列车</p>
					</div>
					<div style="clear: both;"></div>
				</div>
			</div>
			<div class="metro-part part1">
				<p class="metro-part-title">－音乐角－</p>
				<p class="metro-part-ps">在人民广场等地铁站点，定期进行公益音乐演出，为广大乘客观众提供各类世界名曲以及通俗音乐的欣赏，普及音乐知识。</p>
				<div id="activityList"></div>
				<div>
					<p style="line-height: 50px;padding-left: 30px;font-size: 24px;">往期回顾&nbsp;》》</p>
					<div class="metro-tab-list">
						<ul id="activityHisUl">
							<li onclick="toActDetail('9856a1f2c3374e2d9fb0e0f4c7c9616b');">
								<img src="${path}/STATIC/wxStatic/image/subway/1.jpg" width="270" height="170" />
								<div class="metro-tab-list-p">
									<p>地铁音乐角|手风琴二重奏专场</p>
								</div>
							</li>
							<li onclick="toActDetail('6828b5291482435b8a1e8fe5229379fe');">
								<img src="${path}/STATIC/wxStatic/image/subway/2.jpg" width="270" height="170" />
								<div class="metro-tab-list-p">
									<p>”经典轻音乐专场“ 地铁音乐角</p>
								</div>
							</li>
							<li onclick="toActDetail('5a9dc2fd11714085b351a9a2827fa5be');">
								<img src="${path}/STATIC/wxStatic/image/subway/3.jpg" width="270" height="170" />
								<div class="metro-tab-list-p">
									<p>地铁音乐角，迎六一专场</p>
								</div>
							</li>
							<li onclick="toActDetail('4ff6ef9ae27b476f81e86573c1389540');">
								<img src="${path}/STATIC/wxStatic/image/subway/4.jpg" width="270" height="170" />
								<div class="metro-tab-list-p">
									<p>地铁音乐角 | Harmony长笛专场</p>
								</div>
							</li>
							<li onclick="toActDetail('be93ad4fec7b4c35a391e4dd773a6e92');">
								<img src="${path}/STATIC/wxStatic/image/subway/5.jpg" width="270" height="170" />
								<div class="metro-tab-list-p">
									<p>春之声 | 徐汇区专场地铁音乐角</p>
								</div>
							</li>
							<li onclick="toActDetail('fe1419e7207948b6a222939956d103d2');">
								<img src="${path}/STATIC/wxStatic/image/subway/6.jpg" width="270" height="170" />
								<div class="metro-tab-list-p">
									<p>“同一首歌”徐汇区专场地铁音乐角</p>
								</div>
							</li>
							<li onclick="toActDetail('777ffb03c9464c77a85e0ad608062eff');">
								<img src="${path}/STATIC/wxStatic/image/subway/7.jpg" width="270" height="170" />
								<div class="metro-tab-list-p">
									<p>“江南丝竹”徐汇区专场地铁音乐角</p>
								</div>
							</li>
							<li onclick="toActDetail('225134915e7344a1930b56697b4056d4');">
								<img src="${path}/STATIC/wxStatic/image/subway/8.jpg" width="270" height="170" />
								<div class="metro-tab-list-p">
									<p>“心古典音悦会”徐汇专场地铁音乐角</p>
								</div>
							</li>
							<li onclick="toActDetail('40cd7a51476749938a03491dd2c07cfe');">
								<img src="${path}/STATIC/wxStatic/image/subway/9.jpg" width="270" height="170" />
								<div class="metro-tab-list-p">
									<p>"上海风情"徐汇专场地铁音乐角</p>
								</div>
							</li>
							<div style="clear: both;"></div>
						</ul>
					</div>
				</div>
			</div>
			<div class="metro-part part2">
				<p class="metro-part-title">－文化长廊－</p>
				<p class="metro-part-ps">在上海100余座地铁站的站台、出入口通道、换乘线路上，精心展示了雕塑、绘画、摄影等多种艺术。</p>
				<div class="metro-place">
					<img src="${path}/STATIC/wxStatic/image/subway/pictureo2.png" />
					<img src="${path}/STATIC/wxStatic/image/subway/line.png" style="position: absolute;left: 0px;top: 50px;" />
					<img class="metro-point" src="${path}/STATIC/wxStatic/image/subway/circle-red.png" style="position: absolute;left: 90px;top: 43px;z-index: 9;" />
					<img class="metro-point" src="${path}/STATIC/wxStatic/image/subway/8.png" style="position: absolute;left: 181px;top: 43px;" />
					<img class="metro-point" src="${path}/STATIC/wxStatic/image/subway/8.png" style="position: absolute;left: 275px;top: 43px;" />
					<img class="metro-point" src="${path}/STATIC/wxStatic/image/subway/8.png" style="position: absolute;left: 370px;top: 43px;" />
					<img class="metro-point" src="${path}/STATIC/wxStatic/image/subway/8.png" style="position: absolute;left: 465px;top: 43px;" />
					<img class="metro-point" src="${path}/STATIC/wxStatic/image/subway/8.png" style="position: absolute;left: 560px;top: 43px;" />
					<img class="metro-point" src="${path}/STATIC/wxStatic/image/subway/8.png" style="position: absolute;left: 650px;top: 43px;" />
					<img class="red-line" src="${path}/STATIC/wxStatic/image/subway/line-red.png" style="position: absolute;left: 0px;top: 50px;width: 150px;height: 8px;z-index: 8;" />
					<div>
						<div style="position: absolute;left: 82px;top: 80px;" class="metro-tag" onclick="toInfoDetail('e170fd8d0dc1465d8a749af4088adcc4');">
							<div class="triangle" style="border-bottom: 25px solid #ff5077;"></div>
							<div class="triangle-down" style="background-color: #ff5077;color: #fff;">人民广场站</div>
						</div>
						<div onclick="metroMaking(this)" style="position: absolute;left: 172px;top: 80px;" class="metro-tag">
							<div class="triangle"></div>
							<div class="triangle-down">黄陂南路</div>
						</div>
						<div onclick="metroMaking(this)" style="position: absolute;left: 267px;top: 80px;" class="metro-tag">
							<div class="triangle"></div>
							<div class="triangle-down">陕西南路</div>
						</div>
						<div onclick="metroMaking(this)" style="position: absolute;left: 362px;top: 80px;" class="metro-tag">
							<div class="triangle"></div>
							<div class="triangle-down">常熟路</div>
						</div>
						<div onclick="metroMaking(this)" style="position: absolute;left: 457px;top: 80px;" class="metro-tag">
							<div class="triangle"></div>
							<div class="triangle-down">衡山路</div>
						</div>
						<div onclick="metroMaking(this)" style="position: absolute;left: 552px;top: 80px;" class="metro-tag">
							<div class="triangle"></div>
							<div class="triangle-down">徐家汇</div>
						</div>
						<div onclick="metroMaking(this)" style="position: absolute;left: 644px;top: 80px;" class="metro-tag">
							<div class="triangle"></div>
							<div class="triangle-down">上海体育馆</div>
						</div>
					</div>
				</div>
			</div>
			<div class="metro-part part3" style="border: none;">
				<p class="metro-part-title">－文化列车－</p>
				<p class="metro-part-ps">不定期设定文化主题，围绕主题装饰列车整体车身、把手环，如之前的“印象莫奈专列”今年的“航海号”等等。</p>
				<div class="metro-month" onclick="toInfoDetail('62daa93cb5074135b461f6a0c7c8a1c9');">
					<img src="${path}/STATIC/wxStatic/image/subway/picture03.png" />
					<p>地铁“航海号”首发开进“北外滩”</p>
				</div>
				<!--<div class="metro-month">
					<img src="${path}/STATIC/wxStatic/image/subway/picture04.png" />
					<p>帆船驶入地铁来纪念中国航海日12号线开行“航海号”列车</p>
				</div>-->
			</div>
		</div>
	</div>
</body>
</html>