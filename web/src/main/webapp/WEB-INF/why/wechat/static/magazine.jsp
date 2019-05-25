<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>免费公益活动周刊</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<script type="text/javascript" src="${path}/STATIC/wxStatic/js/swiper.animate1.0.2.min.js"></script>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style.css"/>
	
	<script>
		var activityType = '${activityType}';
		var magazine_url = '${url}';	//本页相对路径
		
		//分享图片
		var imgUrl = '';
    	if(activityType==''){	//精选
			imgUrl='${basePath}/STATIC/wxStatic/image/banner-5.jpg';
		}else if(activityType=='47486962f28e41ceb37d6bcf35d8e5c3'){		//亲子
			imgUrl='${basePath}/STATIC/wxStatic/image/banner-4.jpg';
		}else if(activityType=='526091b990c3494d91275f75726c064f'){		//展览
			imgUrl='${basePath}/STATIC/wxStatic/image/banner-3.jpg';
		}else if(activityType=='bfb37ab6d52f492080469d0919081b2b'){		//演出
			imgUrl='${basePath}/STATIC/wxStatic/image/banner-2.jpg';
		}else if(activityType=='cf719729422c497aa92abdd47acdaa56'){		//讲座
			imgUrl='${basePath}/STATIC/wxStatic/image/banner-1.jpg';
		}
		
		//分享是否隐藏
		if(window.injs){
			//分享文案
			appShareTitle = '这是一本每日更新的上海免费公益文化活动期刊';
			appShareDesc = '汇聚22W场活动及场馆资源，提供最全的免费公益内容，轻松享受品质文化生活';
			appShareImgUrl = imgUrl;
			appShareLink = '${basePath}/' + magazine_url;
			
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
            		title: "这是一本每日更新的上海免费公益文化活动期刊",
                    desc: '汇聚22W场活动及场馆资源，提供最全的免费公益内容，轻松享受品质文化生活',
                    link: magazine_url,
                    imgUrl: imgUrl
                });
            	wx.onMenuShareTimeline({
            		title: "这是一本每日更新的上海免费公益文化活动期刊",
                    imgUrl: imgUrl,
                    link: magazine_url
                });
            	wx.onMenuShareQQ({
            		title: "这是一本每日更新的上海免费公益文化活动期刊",
            		desc: '汇聚22W场活动及场馆资源，提供最全的免费公益内容，轻松享受品质文化生活',
                    imgUrl: imgUrl
                });
                wx.onMenuShareWeibo({
                	title: "这是一本每日更新的上海免费公益文化活动期刊",
                	desc: '汇聚22W场活动及场馆资源，提供最全的免费公益内容，轻松享受品质文化生活',
                    imgUrl: imgUrl
                });
                wx.onMenuShareQZone({
                	title: "这是一本每日更新的上海免费公益文化活动期刊",
                	desc: '汇聚22W场活动及场馆资源，提供最全的免费公益内容，轻松享受品质文化生活',
                    imgUrl: imgUrl
                });
            });
        }
		
		$(function () {
			
			var date = new Date();
			$("#todayTime").html((date.getMonth() + 1)+"月"+date.getDate()+"日上新");
			
            loadType();		//根据activityType加载页面
        	loadMagazine();		//加载页面
            
		});
		
		//根据activityType加载页面
		function loadType(){
			if(activityType==''){	//精选
				$(".active-1-title").append("<img src='${path}/STATIC/wxStatic/image/title-5.png' height='103' width='244'/>");
				$(".active-1-banner").append("<img src='${path}/STATIC/wxStatic/image/banner-5.jpg' height='550' width='720'/>");
				$(".end-botton-list ul li:eq(4)").remove();
			}else if(activityType=='47486962f28e41ceb37d6bcf35d8e5c3'){		//亲子
				$(".active-1-title").append("<img src='${path}/STATIC/wxStatic/image/title-4.png' height='103' width='244'/>");
				$(".active-1-banner").append("<img src='${path}/STATIC/wxStatic/image/banner-4.jpg' height='550' width='720'/>");
				$(".end-botton-list ul li:eq(0)").remove();
			}else if(activityType=='526091b990c3494d91275f75726c064f'){		//展览
				$(".active-1-title").append("<img src='${path}/STATIC/wxStatic/image/title-3.png' height='103' width='244'/>");
				$(".active-1-banner").append("<img src='${path}/STATIC/wxStatic/image/banner-3.jpg' height='550' width='720'/>");
				$(".end-botton-list ul li:eq(1)").remove();
			}else if(activityType=='bfb37ab6d52f492080469d0919081b2b'){		//演出
				$(".active-1-title").append("<img src='${path}/STATIC/wxStatic/image/title-2.png' height='103' width='244'/>");
				$(".active-1-banner").append("<img src='${path}/STATIC/wxStatic/image/banner-2.jpg' height='550' width='720'/>");
				$(".end-botton-list ul li:eq(2)").remove();
			}else if(activityType=='cf719729422c497aa92abdd47acdaa56'){		//讲座
				$(".active-1-title").append("<img src='${path}/STATIC/wxStatic/image/title-1.png' height='103' width='244'/>");
				$(".active-1-banner").append("<img src='${path}/STATIC/wxStatic/image/banner-1.jpg' height='550' width='720'/>");
				$(".end-botton-list ul li:eq(3)").remove();
			}
		}
		
		//加载页面列表
		function loadMagazine(){
			var afterId = '0';
			$.post("${path}/wechatStatic/wcMagazineList.do",{activityType:activityType,userId:userId}, function (data) {
				if(data.status == 100){
					$.each(data.data, function (i, dom) {
						if(i==30){
							return false;
						}
						var buttonHtml = "";
						if(dom.type==2){
							if(dom.activityIsReservation == 2){
								buttonHtml = "<button type='button' onclick='showActivity(\"" + dom.activityId + "\")'>立即预订</button>";
							}else{
								buttonHtml = "<button type='button' onclick='showActivity(\"" + dom.activityId + "\")'>查看详情</button>";
							}
						}else{
							if(dom.activityUrl.length>0){
								buttonHtml = "<button type='button' onclick='showEditor(\"" + dom.activityId + "\",\"" + dom.activityUrl + "\")'>查看详情</button>";
							}else{
								if(dom.activityTel.length>0){
									buttonHtml = "<button type='button' onclick='window.location=\"tel:"+dom.activityTel+"\"'>立即咨询</button>";
								}else{
									return true;
								}
							}
						}
						var activityIconUrl = getIndexImgUrl(dom.activityIconUrl, "_750_500");
						var tagNamesHtml = "";
						var tagNames = dom.tagName.split(",");
	                    for (var i = 0; i < tagNames.length; i++) {
	                    	tagNamesHtml += "<li>["+tagNames[i]+"]</li>";
	                    }
	                    //tagNamesHtml += "<li>["+dom.activitySubject+"]</li>";
	                    tagNamesHtml += "<div style='clear: both;'></div>";
						var timeHtml = dom.activityStartTime.replace("-",".").replace("-",".");
						if(dom.activityEndTime.length>0&&dom.activityStartTime!=dom.activityEndTime){
							timeHtml += "-"+dom.activityEndTime.replace("-",".").replace("-",".");
	    				}
						timeHtml += "&nbsp;" + dom.eventTime;
						if(dom.activityTimeDes.length>0){
							timeHtml += "<br/>" + dom.activityTimeDes;
						}
						var wantGoHtml = "";
						var wantGoCount = dom.count;	//点赞数
						if(dom.count>10000){
							wantGoCount = "10000+";
						}
						if(dom.type==2){
							if (dom.isLike == 1) {		//点赞（我想去）
								wantGoHtml = "<div class='active-menu-1' id='active-menu-1-"+eval(afterId+1)+"' ontouchstart='addActWantGo(\"" + dom.activityId + "\","+eval(afterId+1)+")' style='background:url(${path}/STATIC/wxStatic/image/favorite_on.png) no-repeat 45px 25px;'><p>"+wantGoCount+"</p></div>";
		                    }else{
		                    	wantGoHtml = "<div class='active-menu-1' id='active-menu-1-"+eval(afterId+1)+"' ontouchstart='addActWantGo(\"" + dom.activityId + "\","+eval(afterId+1)+")'><p>"+wantGoCount+"</p></div>";
		                    }
						}else{
							if (dom.isLike == 1) {		//点赞（我想去）
								wantGoHtml = "<div class='active-menu-1' id='active-menu-1-"+eval(afterId+1)+"' ontouchstart='addEdiWantGo(\"" + dom.activityId + "\","+eval(afterId+1)+")' style='background:url(${path}/STATIC/wxStatic/image/favorite_on.png) no-repeat 45px 25px;'><p>"+wantGoCount+"</p></div>";
							}else{
								wantGoHtml = "<div class='active-menu-1' id='active-menu-1-"+eval(afterId+1)+"' ontouchstart='addEdiWantGo(\"" + dom.activityId + "\","+eval(afterId+1)+")'><p>"+wantGoCount+"</p></div>";
							}
						}
						$(".slide"+afterId).after("<div class='swiper-slide slide"+eval(afterId+1)+"' id='"+dom.activityId+"'>" +
													"<img data-url='${path}/STATIC/wxStatic/image/bg-img2.jpg' width='100%' height='100%' style='position: absolute;left: 0px;top: 0px;z-index: -1;' />" +
												  	"<div class='active-p1-banner'>" +
														"<img data-url='" + activityIconUrl + "' width='720' height='455'/>" +
														"<div class='banner-ps'>"+(dom.activityIsFree==1?"免费":"公益")+"</div>" +
														"<div class='banner-botton' id='banner-botton"+eval(afterId+1)+"'>" +
															"<img data-url='${path}/STATIC/wxStatic/image/other-botton.png'/>" +
														"</div>" +
														"<div class='banner-menu'>" +
															"<div class='banner-menu-botton' onclick='preMagazine(\"47486962f28e41ceb37d6bcf35d8e5c3\");'><p>亲子</p></div>" +
															"<div class='banner-menu-botton' onclick='preMagazine(\"526091b990c3494d91275f75726c064f\");'><p>展览</p></div>" +
															"<div class='banner-menu-botton' onclick='preMagazine(\"bfb37ab6d52f492080469d0919081b2b\");'><p>演出</p></div>" +
															"<div class='banner-menu-botton' onclick='preMagazine(\"cf719729422c497aa92abdd47acdaa56\");'><p>讲座</p></div>" +
															"<div class='banner-menu-botton' onclick='preMagazine();'><p>精选</p></div>" +
														"</div>" +
													"</div>" +
													"<div class='active-detail'>" +
														"<div class='active-detail-title'><p>"+dom.activityName+"</p></div>" +
														"<div class='active-detail-tag'>" +
															"<ul>"+tagNamesHtml+"</ul>" +
														"</div>" +
														"<div class='active-detail-place'>" +
															"<img class='a-i' data-url='${path}/STATIC/wxStatic/image/pce.png'/>" +
															"<div class='a-p'>"+dom.activityAddress+"</div>" +
															"<div style='clear: both;'></div>" +
														"</div>" +
														"<div class='active-detail-time'>" +
															"<img class='a-i' data-url='${path}/STATIC/wxStatic/image/clock-icon.png'/>" +
															"<div class='a-p'>"+timeHtml+"</div>" +
															"<div style='clear: both;'></div>" +
														"</div>" +
														"<div class='active-detail-tips'><p>"+dom.activityMemo+"</p></div>" +
													"</div>" +
													"<div class='active-detail-next'><div class='first-next-arrow'><img src='${path}/STATIC/wxStatic/image/arrow.png'/></div></div>" +
													"<div class='active-menu'>" +
														wantGoHtml +
														"<div class='active-menu-2'></div>" +
														"<div class='active-menu-3'></div>" +
														"<div class='active-menu-4'>"+buttonHtml+"</div>" +
														"<div style='clear: both;'></div>" +
													"</div>" +
												  "</div>");
						
						formatStyle();	//简介格式修改
						
						//展开类型
			            $("#banner-botton"+eval(afterId+1)).on('touchstart', function() {
							$(this).parent().find(".banner-menu").toggle()
						});
						
						afterId++;
					});
					
					//选中当前类型
					if(activityType==''){	//精选
						$(".banner-menu").each(function(){
							$(this).find("div:eq(4)").addClass("banner-menu-botton-bg");
						});
					}else if(activityType=='47486962f28e41ceb37d6bcf35d8e5c3'){		//亲子
						$(".banner-menu").each(function(){
							$(this).find("div:eq(0)").addClass("banner-menu-botton-bg");
						});
					}else if(activityType=='526091b990c3494d91275f75726c064f'){		//展览
						$(".banner-menu").each(function(){
							$(this).find("div:eq(1)").addClass("banner-menu-botton-bg");
						});
					}else if(activityType=='bfb37ab6d52f492080469d0919081b2b'){		//演出
						$(".banner-menu").each(function(){
							$(this).find("div:eq(2)").addClass("banner-menu-botton-bg");
						});
					}else if(activityType=='cf719729422c497aa92abdd47acdaa56'){		//讲座
						$(".banner-menu").each(function(){
							$(this).find("div:eq(3)").addClass("banner-menu-botton-bg");
						});
					}
					
					var ss_id = 0;		//页面回跳位置
					if(window.localStorage.getItem("magazineId")!=null){
						var magazineId = window.localStorage.getItem("magazineId");
						$(".swiper-slide").each(function() {
							if ($(this).attr("id")==magazineId) {
								ss_id = $("#"+magazineId).index();
							}
						})

					}
					
					//页面滚动
					var mySwiper = new Swiper('.swiper-container', {
						direction: 'vertical',
						touchRatio: 0.8,
						initialSlide: ss_id,
						onInit: function(swiper) { //Swiper2.x的初始化是onFirstInit
							swiperAnimateCache(swiper); //隐藏动画元素 
							swiperAnimate(swiper); //初始化完成开始动画
						},
						onSlideChangeEnd: function(swiper) {
							swiperAnimate(swiper); //每个slide切换结束时也运行当前slide动画
						},
						onSlideChangeEnd: function(swiper) {
							var snapIndex = swiper.snapIndex;
							var $slide = $(".swiper-wrapper .swiper-slide:eq("+snapIndex+")");
							//加载图片
							$slide.find("img").each(function () {
								$(this).attr("src",$(this).attr("data-url"));
							});
							//缓存ID
							if(snapIndex>0&&snapIndex<=data.data.length){
								var magazineId = $slide.attr("id");
								window.localStorage.setItem("magazineId", magazineId);
							}else{
								localStorage.removeItem("magazineId"); 
							}
						}
					});
					
					//收藏、分享蒙版
		            $(".active-menu-2").on("touchstart", function() {
		            	if (is_weixin()) {
		            		$(".wx-keep").show();
		            	}else{
		            		dialogAlert('系统提示', '请用微信浏览器打开收藏！');
		            	}
					});
					$(".active-menu-3").on("touchstart", function() {
						if (is_weixin()) {
							$(".wx-share").show();
						}else{
							var ua = navigator.userAgent.toLowerCase();	
		                	if (/wenhuayun/.test(ua)) {		//APP端
		                		$(".wx-share").show();
		                	}else{		//H5
		                		dialogAlert('系统提示', '请用微信浏览器打开分享！');
		                	}
						}
					});
					$(".wx-share,.wx-keep").on("touchstart",function(){
						$(".wx-share").hide();
						$(".wx-keep").hide();
					});
				}
			}, "json");
		}
		
		//跳转到活动详情
        function showActivity(activityId) {
        	window.localStorage.setItem("magazineId", activityId);
        	var ua = navigator.userAgent.toLowerCase();	
        	if (/wenhuayun/.test(ua)) {		//APP端
        		if (window.injs) {	//判断是否存在方法
    				injs.accessAppPage(1,activityId);
    			}else{
    				location.href = "com.wenhuayun.app://activitydetail?activityId=" + activityId;
    			}
        	}else{		//H5
        		location.href = "${path}/wechatActivity/preActivityDetail.do?activityId=" + activityId;
        	}
        }
		
		//跳转到采编外链
		function showEditor(activityId,activityUrl){
			window.localStorage.setItem("magazineId", activityId);
			window.location.href = activityUrl;
		}
		
		//跳转到其他活动周刊
		function preMagazine(type){
			localStorage.removeItem("magazineId"); 
			if(type){
				window.location.href = "${path}/wechatStatic/magazine.do?activityType=" + type;
			}else{
				window.location.href = "${path}/wechatStatic/magazine.do";
			}
		}
		
		//点赞（我想去）（活动）
        function addActWantGo(activityId,no) {
        	if (userId == null || userId == '') {
        		//判断登陆
            	publicLogin(magazine_url);
        	}else{
        		$.post("${path}/wechatActivity/wcAddActivityUserWantgo.do", {
                    activityId: activityId,
                    userId: userId
                }, function (data) {
                    if (data.status == 0) {
                    	var n = $("#active-menu-1-"+no+" p").text();
                    	$("#active-menu-1-"+no+" p").text(eval(n)+1);
                    	$("#active-menu-1-"+no).css("background", "url(${path}/STATIC/wxStatic/image/favorite_on.png) no-repeat 45px 25px");
                    } else if (data.status == 14111) {
                        $.post("${path}/wechatActivity/deleteActivityUserWantgo.do", {
                            activityId: activityId,
                            userId: userId
                        }, function (data) {
                            if (data.status == 0) {
                            	$("#active-menu-1-"+no+" p").text(eval($("#active-menu-1-"+no+" p").text()-1));
                            	$("#active-menu-1-"+no).css("background", "url(${path}/STATIC/wxStatic/image/favorite.png) no-repeat 45px 25px");
                            }
                        }, "json");
                    }
                }, "json");
        	}
        }
		
      	//点赞（我想去）（采编）
        function addEdiWantGo(activityId,no) {
        	if (userId == null || userId == '') {
        		//判断登陆
            	publicLogin(magazine_url);
        	}else{
        		$.post("${path}/wechatStatic/wcAddEditorialUserWantgo.do", {
                    activityId: activityId,
                    userId: userId
                }, function (data) {
                    if (data.status == 0) {
                    	var n = $("#active-menu-1-"+no+" p").text();
                    	$("#active-menu-1-"+no+" p").text(eval(n)+1);
                    	$("#active-menu-1-"+no).css("background", "url(${path}/STATIC/wxStatic/image/favorite_on.png) no-repeat 45px 25px");
                    } else if (data.status == 14111) {
                        $.post("${path}/wechatStatic/deleteEditorialUserWantgo.do", {
                            activityId: activityId,
                            userId: userId
                        }, function (data) {
                            if (data.status == 0) {
                            	$("#active-menu-1-"+no+" p").text(eval($("#active-menu-1-"+no+" p").text()-1));
                            	$("#active-menu-1-"+no).css("background", "url(${path}/STATIC/wxStatic/image/favorite.png) no-repeat 45px 25px");
                            }
                        }, "json");
                    }
                }, "json");
        	}
        }
      	
      	//文本格式修改
        function formatStyle() {
        	$(".active-detail-tips").each(function(){
        		$(this).find("p").find("img").each(function () {
                    var $this = $(this);
                    $this.css("display", "none");
                });
        		$(this).find("p").find("p,span,font").each(function () {
                    var $this = $(this);
                    $this.css({
                        "font-size": "32px",
                        "color": "#666666"
                    });
                });
        		$(this).find("a").each(function () {
                    var $this = $(this);
                    $this.css({
                    	"text-decoration": "underline",
                    	"color": "#7C7C7C"
                    });
                });
                var str = $(this).find("p").html();
                str.replace(/<span>/g, "").replace(/<\/span>/g, "");
                $(this).find("p").html(str);
        	});
        }
	</script>
</head>

<body>
	<div class="main">
		<div class="swiper-container">
			<div class="swiper-wrapper">

				<!--head-->
				<div class="swiper-slide slide0">
					<img src="${path}/STATIC/wxStatic/image/bg-img.jpg" width="100%" height="100%" style="position: absolute;left: 0px;top: 0px;z-index: -1;" />
					<div class="active-1-title"></div>
					<div class="active-1-banner"></div>
					<div class="active-1-logo">
						<div class="free-icon">
							<img src="${path}/STATIC/wxStatic/image/free.png" />
						</div>
						<div class="active-bottom">
							<div class="active-bottom1">
								<p>上海免费文化活动周刊</p>
							</div>
							<div class="active-bottom2">
								<img src="${path}/STATIC/wxStatic/image/logo-icon.png" style="float: left;" />
								<p style="float: left;" id="todayTime"></p>
								<div style="clear: both;"></div>
							</div>
						</div>
						<div class="first-next">
							<div class="first-next-arrow">
								<img src="${path}/STATIC/wxStatic/image/arrow.png" />
							</div>
						</div>
					</div>
				</div>

				<!--END-->
				<div class="swiper-slide">
					<img src="${path}/STATIC/wxStatic/image/bg-img3.jpg" width="100%" height="100%" style="position: absolute;left: 0px;top: 0px;z-index: -1;" />
					<div class="end-title">
						<p>浏览其他免费活动周刊</p>
					</div>
					<div class="end-botton-list">
						<ul>
							<li class="end-botton-list-bottom" onclick="preMagazine('47486962f28e41ceb37d6bcf35d8e5c3');">
								<img src="${path}/STATIC/wxStatic/image/qinzi-botton.png" />
							</li>
							<li class="end-botton-list-bottom" onclick="preMagazine('526091b990c3494d91275f75726c064f');">
								<img src="${path}/STATIC/wxStatic/image/zhanlan-botton.png" />
							</li>
							<li class="end-botton-list-bottom" onclick="preMagazine('bfb37ab6d52f492080469d0919081b2b');">
								<img src="${path}/STATIC/wxStatic/image/yanchu-botton.png" />
							</li>
							<li class="end-botton-list-bottom" onclick="preMagazine('cf719729422c497aa92abdd47acdaa56');">
								<img src="${path}/STATIC/wxStatic/image/jiangzuo-botton.png" />
							</li>
							<li class="end-botton-list-bottom" onclick="preMagazine();">
								<img src="${path}/STATIC/wxStatic/image/jingxuan-button.png" />
							</li>
						</ul>
					</div>
					<div class="end-er">
						<img src="${path}/STATIC/wxStatic/image/er.jpg" />
					</div>
					<div class="end-tip">
						<p>扫描二维码&nbsp;&nbsp;关注文化云</p>
						<p>发现更多品质生活</p>
					</div>
				</div>
			</div>
		</div>
		<div class="wx-bg">
			<div class="wx-share">
				<img src="${path}/STATIC/wxStatic/image/fx-bg.png" width="100%" height="100%" />
			</div>
			<div class="wx-keep">
				<img src="${path}/STATIC/wxStatic/image/sc-bg.png" width="100%" height="100%" />
			</div>
		</div>
	</div>
	<script>
		//箭头的动态
		function arrow() {
			$(".first-next-arrow").animate({
				bottom: "10px"
			}, 500).animate({
				bottom: "0px"
			}, 500)
		}
		arrow();
		setInterval("arrow()", 200)
	</script>

</body>
</html>