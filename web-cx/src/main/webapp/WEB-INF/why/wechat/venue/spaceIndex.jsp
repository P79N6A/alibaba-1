<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>文化场馆</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp" %>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/hsStyle.css"/>
	<%--<link rel="stylesheet" href="${path}/STATIC/wechat/css/bpColorCtrl.css" />--%>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		var latitude = 22.964305;
	    var longitude = 113.116029;
	    
	
		$(function () {
			/*菜单轮播*/
			var mySwiper4 = new Swiper('.swiper-container4', {
				freeMode: false,
				autoplay: false,
				loop: false,
				pagination: '.swiper-pagination'
			});
			
			//自适应高度
			$(".content").css("height", $("body").height() - $(".header").height());
			
			if (is_weixin()) {
		        //通过config接口注入权限验证配置
		        wx.config({
		            debug: false,
		            appId: '${sign.appId}',
		            timestamp: '${sign.timestamp}',
		            nonceStr: '${sign.nonceStr}',
		            signature: '${sign.signature}',
		            jsApiList: ['getLocation','onMenuShareAppMessage', 'onMenuShareTimeline', 'onMenuShareQQ', 'onMenuShareWeibo', 'onMenuShareQZone']
		        });
		        wx.ready(function () {
		            wx.onMenuShareAppMessage({
		                title: "我在“佛山文化云”发现一大波文化空间，快来和我一起参观吧！",
		                desc: '提供公众文化生活和消费的互联网平台，为公众提供便捷和有品质的文化生活服务。',
		                imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
		            });
		            wx.onMenuShareTimeline({
		                title: "我在“佛山文化云”发现一大波文化空间，快来和我一起参观吧！",
		                imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
		            });
		            wx.onMenuShareQQ({
		                title: "我在“佛山文化云”发现一大波文化空间，快来和我一起参观吧！",
		                desc: '提供公众文化生活和消费的互联网平台，为公众提供便捷和有品质的文化生活服务。',
		                imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
		            });
		            wx.onMenuShareWeibo({
		                title: "我在“佛山文化云”发现一大波文化空间，快来和我一起参观吧！",
		                desc: '提供公众文化生活和消费的互联网平台，为公众提供便捷和有品质的文化生活服务。',
		                imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
		            });
		            wx.onMenuShareQZone({
		                title: "我在“佛山文化云”发现一大波文化空间，快来和我一起参观吧！",
		                desc: '提供公众文化生活和消费的互联网平台，为公众提供便捷和有品质的文化生活服务。',
		                imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
		            });
		            wx.getLocation({
	                    type: 'gcj02', // 默认为wgs84的gps坐标，如果要返回直接给openLocation用的火星坐标，可传入'gcj02'
	                    success: function (res) {
	                        latitude = (res.latitude == null || res.latitude == "") ? 0 : res.latitude; // 纬度，浮点数，范围为90 ~ -90
	                        longitude = (res.longitude == null || res.longitude == "") ? 0 : res.longitude; // 经度，浮点数，范围为180 ~ -180。
	                        loadDate();
	                    },
		    		    fail: function (res){
		    		    	dialogAlert("系统提示", "获取坐标失败，定位未启用");
		    		    	loadDate();
		    		    }
	                });
		        });
		    }else{
		    	if (window.navigator.geolocation) {
	                var options = {enableHighAccuracy: true};
	                window.navigator.geolocation.getCurrentPosition(handleSuccess, handleError, options);
	            } else {
	                dialogAlert("系统提示", "浏览器不支持html5来获取地理位置信息");
	            }

	            function handleSuccess(position) {
	                var lng = position.coords.longitude;
	                var lat = position.coords.latitude;
	                longitude = wgs84togcj02(lng, lat)[0];
	                latitude = wgs84togcj02(lng, lat)[1];
	                loadDate();
	            }
	            function handleError(error) {
	            	//dialogAlert("系统提示", "获取坐标失败，定位未启用");
	            	loadDate();
	            }
		    }
			
			//底部菜单
			$(document).on("touchmove", function() {
				$(".footer").hide()
			}).on("touchend", function() {
				$(".footer").show()
			})
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
			
		});
		
		function loadDate(){
			//空间标签
            $.post("${path}/wechat/getAdvertRecommend.do", {advertPostion: 3,advertType: "B"}, function (data) {
            	if(data.status==1){
            		$.each(data.data, function (i, dom) {
            			var iframeUrl = "";
            			if(dom.advertLink==0){
            				iframeUrl = "${basePath}/wechatVenue/preVenueListIframe.do?venueType="+dom.advertUrl;
            			}else{
            				iframeUrl = dom.advertUrl;
            			}
            			
            			if(i==0){
            				$("#tagList").append("<div class='swiper-slide border-bottom2'><a style='font-weight:bold' iframeUrl='"+iframeUrl+"'>"+dom.advertTitle+"</a></div>");
            				$("#spaceIframe").attr("src",iframeUrl);
            			}else{
            				$("#tagList").append("<div class='swiper-slide'><a iframeUrl='"+iframeUrl+"'>"+dom.advertTitle+"</a></div>");
            			}
            		});
            		
            		var mySwiper = new Swiper('.swiper-container', {
        				slidesPerView: 'auto',
        				paginationClickable: true,
        				spaceBetween: 20,
        				freeMode: true
        			})
            		
            		$(".swiper-slide a").click(function() {
    					$(".swiper-slide a").css("font-weight", "normal");
    					$(this).css("font-weight", "bold");
    					$(".swiper-slide").removeClass("border-bottom2")
						$(this).parent().addClass("border-bottom2");
    					$(".ui-popup").remove();	//强制清除弹窗，防止多弹窗不关闭
    					$("#spaceIframe").attr("src",$(this).attr("iframeUrl"));
    				})
            	}
            },"json");
		}
		
		
	</script>
	
	<style>
		html,body {
			height: 100%;
		}
		#tagList .swiper-slide {
			height: 95px;
			width:auto;
			padding:0 20px;
		}

	</style>
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wx/image/share_120.png"/></div>
	<div class="main">
		<div class="header" style="width:730px;padding: 0 10px;">
			<div class="swiper-container" style="width: 100%;">
				<div class="swiper-wrapper" id="tagList"></div>
			</div>
			<div style="clear: both;"></div>
		</div>
		<div class="content" style="padding: 100px 0 0;">
			<iframe id="spaceIframe" class="whySpaceIfram" src=""></iframe>
		</div>
		<div class="footer" style="background-color: transparent;bottom: 40px;border:none;">
			<div class="totop" onclick="$('html,body').animate({scrollTop: 0}, 1000);"><img class="menuBtnShadow" src="${path}/STATIC/wechat/image/newmenu/top.png" /></div>
			<div style="clear: both;"></div>
			<div class="newMenuBTN">
				<img class="menuBtnShadow" src="${path}/STATIC/wechat/image/newmenu/btn.png" />
			</div>
		</div>
		<div class="newMenuList">
			<div class="swiper-container4 swiper-container-horizontal">
				<div class="swiper-wrapper">
					<div class="swiper-slide">
						<ul>
							<li onclick="location.href='${path}/wechat/index.do'"><img src="${path}/STATIC/wechat/image/newmenu/index.png" /></li>
							<li onclick="location.href='${path}/wechatActivity/index.do'"><img src="${path}/STATIC/wechat/image/newmenu/act.png" /></li>
							<li onclick="location.href='${path}/wechatVenue/toSpace.do'"><img src="${path}/STATIC/wechat/image/newmenu/kongjian.png" /></li>
							<li onclick="location.href='${path}/wechatVenue/venueTagPage.do'"><img src="${path}/STATIC/wechat/image/newmenu/search.png" /></li>
							<!--<li onclick="location.href='${path}/wechatChuanzhou/chuanzhouIndex.do'"><img src="${path}/STATIC/wechat/image/newmenu/rwhs.png" /></li>
                    <li onclick="location.href='${path}/wechatChuanzhou/chuanzhouIndex.do'"><img src="${path}/STATIC/wechat/image/newmenu/qzty.png" /></li>
                    <li onclick="location.href='${path}/wechatChuanzhou/chuanzhouIndex.do'"><img src="${path}/STATIC/wechat/image/newmenu/szyd.png" /></li>-->
							<li onclick="location.href='${path}/wechatUser/preTerminalUser.do'"><img src="${path}/STATIC/wechat/image/newmenu/gerenzhongxin.png" /></li>

							<%--<li onclick="location.href='${path}/wechatBpProduct/preProductList.do'"><img src="${path}/STATIC/wechat/image/newmenu/shangcheng.png" /></li>--%>
							<%--<li onclick="location.href='${path}/wechatBpAntique/preAntiqueList.do'"><img src="${path}/STATIC/wechat/image/newmenu/wenwu.png" /></li>--%>
							<%-- <li onclick="location.href=''"><img src="${path}/STATIC/wechat/image/newmenu/canyu.png" /></li> --%>


							<div style="clear: both;"></div>
						</ul>
					</div>
				</div>
				<%--<div id="swiperPage" class="swiper-pagination"></div>--%>

			</div>
			<div class="newMenuCloseBTN">
				<img src="${path}/STATIC/wechat/image/newmenu/closeBTN.png" />
			</div>
		</div>
	</div>
</body>
</html>