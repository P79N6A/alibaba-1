<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>${ccpExhibition.exhibitionHead}</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		var fullUrl = '${fullUrl}';
	
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '${ccpExhibition.exhibitionShareTitle}';
	    	appShareDesc = '${ccpExhibition.exhibitionShareDesc}';
	    	appShareImgUrl = '${ccpExhibition.exhibitionShareImg}@400w';
	    	
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
					title: '${ccpExhibition.exhibitionShareTitle}',
					desc: '${ccpExhibition.exhibitionShareDesc}',
					link: fullUrl,
					imgUrl: '${ccpExhibition.exhibitionShareImg}@400w'
				});
				wx.onMenuShareTimeline({
					title: '${ccpExhibition.exhibitionShareTitle}',
					imgUrl: '${ccpExhibition.exhibitionShareImg}@400w',
					link: fullUrl
				});
				wx.onMenuShareQQ({
					title: '${ccpExhibition.exhibitionShareTitle}',
					desc: '${ccpExhibition.exhibitionShareDesc}',
					imgUrl: '${ccpExhibition.exhibitionShareImg}@400w'
				});
				wx.onMenuShareWeibo({
					title: '${ccpExhibition.exhibitionShareTitle}',
					desc: '${ccpExhibition.exhibitionShareDesc}',
					imgUrl: '${ccpExhibition.exhibitionShareImg}@400w'
				});
				wx.onMenuShareQZone({
					title: '${ccpExhibition.exhibitionShareTitle}',
					desc: '${ccpExhibition.exhibitionShareDesc}',
					imgUrl: '${ccpExhibition.exhibitionShareImg}@400w'
				});
			});
		}
		
		$(function () {
			$(".spdInBtn").click(function() {
				$(".spdFirstPage").hide()
				$(".swiper-container").show()
				var swiper = new Swiper('.swiper-container', {
					slidesPerView: 1,
					mousewheelControl: true,
					lazyLoading: true,
					lazyLoadingInPrevNext: true,
					lazyLoadingInPrevNextAmount: 1,
				});
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
		
	</script>
	
	<style>
		html,body {
			height: 100%;
		}
	</style>
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${ccpExhibition.exhibitionShareImg}@400w"/></div>
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
	<div class="spdMain">
		<div class="spdMainLogo">
			<c:choose>
				<c:when test="${!empty ccpExhibition.indexLogo }">
					<img src="${ ccpExhibition.indexLogo}@90w" />
				</c:when>
				<c:when test="${!empty logo }">
					<img src="${logo}@90w" />
				</c:when>
				<c:otherwise>
					<img src='${path}/STATIC/wxStatic/image/exhibition/logo.png' />
				</c:otherwise>
			</c:choose>																		
		</div>
		<div class="spdToIndex">
			<img src="${path}/STATIC/wxStatic/image/exhibition/toIndex.png" onclick="toWhyIndex();"/>
		</div>
		<div class="spdShare share-button">
			<img src="${path}/STATIC/wxStatic/image/exhibition/share.png" />
		</div>
		<div class="spdKeep keep-button">
			<img src="${path}/STATIC/wxStatic/image/exhibition/keep.png" />
		</div>
		<!--封面-->
		<div class="spdFirstPage">
			<div class="spdFistPage">
				<div class="spdIndexTitle">
					<p>${ccpExhibition.exhibitionTitle}</p>
					<p>${ccpExhibition.exhibitionSubtitle}</p>
				</div>
				<div class="spdIndexImg">
					<img src="${ccpExhibition.exhibitionHeadImg}@700w" width="610" height="400" />
				</div>
				<div class="spdInBtn">
					<img src="${path}/STATIC/wxStatic/image/exhibition/inBtn.png" />
				</div>
			</div>
		</div>
		<!--内页-->
		<div class="swiper-container" style="display: none;">
			<div class="swiper-wrapper">
				<c:forEach items="${ccpExhibition.exhibitionPageList}" var="exhibitionPage" varStatus="i">
					<c:if test="${exhibitionPage.pageType == 1}">
						<!--1张图-->
						<div class="swiper-slide">
							<div class="spdArrow"><img src="${path}/STATIC/wxStatic/image/exhibition/rightArrow.png" ></div>
							<div class="spdPageBg">
								<div class="spdPageTitle">${exhibitionPage.pageTitle}</div>
								<div class="spdNum1">
									<div>
										<div class="spdPageImg">
											<img data-src='${exhibitionPage.pageImg}@700w'  class="swiper-lazy" />
										</div>
										<div class="spdPageImgName">${exhibitionPage.pageContent}</div>
									</div>
								</div>
							</div>
						</div>
					</c:if>
					<c:if test="${exhibitionPage.pageType == 2}">
						<!--2张图-->
						<div class="swiper-slide">
							<div class="spdArrow"><img src="${path}/STATIC/wxStatic/image/exhibition/rightArrow.png" ></div>
							<div class="spdPageBg">
								<div class="spdPageTitle">${exhibitionPage.pageTitle}</div>
								<div class="spdNum2">
									<c:set var="items" value="${fn:split(exhibitionPage.pageImg, ',')}"></c:set>
									<c:forEach items="${items}" var="dom" varStatus="i">
										<div>
											<div class="spdPageImg">
												<img data-src='${dom}@700w'  class="swiper-lazy" />
											</div>
											<div class="spdPageImgName">${fn:split(exhibitionPage.pageContent, ',')[i.index]}</div>
										</div>
									</c:forEach>
								</div>
							</div>
						</div>
					</c:if>
					<c:if test="${exhibitionPage.pageType == 4}">
						<!--4张图-->
						<div class="swiper-slide">
							<div class="spdArrow"><img src="${path}/STATIC/wxStatic/image/exhibition/rightArrow.png" ></div>
							<div class="spdPageBg">
								<div class="spdPageTitle">${exhibitionPage.pageTitle}</div>
								<div class="spdNum4 clearfix">
									<c:set var="items" value="${fn:split(exhibitionPage.pageImg, ',')}"></c:set>
									<c:forEach items="${items}" var="dom" varStatus="i">
										<div>
											<div class="spdPageImg">
												<img data-src='${dom}@700w'  class="swiper-lazy" />
											</div>
											<div class="spdPageImgName">${fn:split(exhibitionPage.pageContent, ',')[i.index]}</div>
										</div>
									</c:forEach>
								</div>
							</div>
						</div>
					</c:if>
				</c:forEach>
				
				<!--底页-->
				<div class="swiper-slide">
					<div class="spdEndPage">
						<div class="spdEndPageTitle">${ccpExhibition.exhibitionFootContent}</div>
						<div class="spdEndPageImg">
							<img data-src='${ccpExhibition.exhibitionFootImg}@700w'  class="swiper-lazy" />
						</div>
						<div class="spdEndBtn share-button">
							<img src="${path}/STATIC/wxStatic/image/exhibition/endBtn.png" />
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>