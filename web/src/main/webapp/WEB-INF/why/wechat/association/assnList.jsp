<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>文化社团</title>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/normalize.css"/>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/bpStyle.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/common.js"></script>

    <script>
	  	//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '文化云大咖圈，精彩连连看';
	    	appShareDesc = '众多活跃文艺团体、匠人济济一堂';
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
                    title: "文化云大咖圈，精彩连连看",
                    desc: '众多活跃文艺团体、匠人济济一堂',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareTimeline({
                    title: "众多活跃文艺团体、匠人济济一堂",
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareQQ({
                	title: "文化云大咖圈，精彩连连看",
                	desc: '众多活跃文艺团体、匠人济济一堂',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareWeibo({
                	title: "文化云大咖圈，精彩连连看",
                	desc: '众多活跃文艺团体、匠人济济一堂',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareQZone({
                	title: "文化云大咖圈，精彩连连看",
                	desc: '众多活跃文艺团体、匠人济济一堂',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
            });
        
        };
        
        $(function(){
        	if (!/wenhuayun/.test(ua)) {		//APP端
				$(".newMenuBTN").show();
			}
        	var assnName = $("#searchAssnName").val();
        	$.post("${path}/wechatAssn/getAssnList.do",{assnName:assnName}, function (data) {
    			if(data.status == 1){
    				$.each(data.data, function (i, dom) {
    					var tagHtml = ""
    					var tagList = dom.assnTag.split(",");
    					$.each(tagList, function (i, tag) {
    						tagHtml += "<li class='f-right'><p>"+tag+"</p></li>"
    					});
    					var assnImgUrl = dom.assnImgUrl.indexOf("http://")<0?getIndexImgUrl(getImgUrl(dom.assnImgUrl),"_750_500"):(dom.assnImgUrl+"@800w");
    					var assnIconUrl = dom.assnIconUrl.indexOf("http://")<0?getIndexImgUrl(getImgUrl(dom.assnIconUrl),"_150_150"):(dom.assnIconUrl+"@200w");
    					var activityCountHtml = "";
    					var hasAtivityHtml = "";
    					if(dom.activityCount>0){
    						hasAtivityHtml = "<li class='f-left'><div><p>可预订活动</p></div></li>";
    						activityCountHtml = "<span class='cd58185 fs26'>"+dom.activityCount+"</span>" +
												"<span>个在线活动</span>" +
												"<span class='margin-left10 margin-right10 cccc'>|</span>";
    					}
            			$("#assnUl").append("<li onclick='toAssnDetail(\""+dom.assnId+"\")'>" +
				            					"<div class='community-list'>" +
					        						"<div class='community-list-top'>" +
					        							"<img src='"+assnImgUrl+"' width='750' height='420'/>" +
					        							"<div class='user-head'>" +
					        								"<img src='"+assnIconUrl+"' width='135' height='135'/>" +
					        							"</div>" +
					        							"<div class='community-list-top-tab'>" +
															"<ul>" +
																"<li class='f-left'>" +
																	"<div>" +
																		"<img class='f-left' src='${path}/STATIC/wechat/image/assn/community-right.png'/>" +
																		"<p class='f-left'>实名认证</p>" +
																		"<div style='clear: both;'></div>" +
																	"</div>" +
																"</li>" +
																"<li class='f-left'>" +
																	"<div>" +
																		"<img class='f-left' src='${path}/STATIC/wechat/image/assn/community-right.png'/>" +
																		"<p class='f-left'>资质认证</p>" +
																		"<div style='clear: both;'></div>" +
																	"</div>" +
																"</li>" +
																hasAtivityHtml +
															"</ul>" +
														"</div>" +
					        							/*"<div class='community-list-top-state'>" +
					        								"<p>" +
					        									activityCountHtml +
					        									"<img class='margin-right10' style='display: inline-block;' src='${path}/STATIC/wechat/image/assn/flower.png' />" +
					        									"<span>"+(eval(dom.assnFlowerInit)+eval(dom.flowerCount))+"</span>" +
					        								"</p>" +
					        							"</div>" +*/
					        						"</div>" +
					        						"<div class='community-list-font'>" +
					        							"<div class='community-list-font-title'>" +
					        								"<p class='f-left'>"+dom.assnName+"</p>" +
					        								"<ul class='f-right'>"+tagHtml+"</ul>" +
					        								"<div style='clear: both;'></div>" +
					        							"</div>" +
					        							"<div class='community-list-font-explain'>" +
					        								"<p class='break2'>"+dom.assnIntroduce+"</p>" +
					        							"</div>" +
					        						"</div>" +
					        					"</div>" +
					        				"</li>");
            		});
        		}
        	}, "json");
        	
        	//底部菜单
        	if (!browser.versions.android) {		//非安卓(安卓不识别touchend)
        		$(document).on("touchmove", function() {
    				$(".footer").hide()
    			}).on("touchend", function() {
    				$(".footer").show()
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
			//回到顶部按钮显示
			$(window).scroll(function() {
				var screenheight = $(window).height() * 2
				if ($(document).scrollTop() > screenheight) {
					$(".totop").show()
				} else {
					$(".totop").hide()
				}
			})
        })
        
        //跳转到社团详情页
        function toAssnDetail(assnId){
        	if (window.injs) {		//APP端
        		injs.accessDetailPageByApp('${basePath}/wechatAssn/toAssnDetail.do?assnId='+assnId);
        	}else{
        		location.href='${path}/wechatAssn/toAssnDetail.do?assnId='+assnId;
        	}
        }

        //申请入驻
        function assnApply(){
        	getAppUserId();		//防止APP不刷新调用该方法
        	if (userId == null || userId == '') {
        		//判断登陆
            	publicLogin("${basePath}wechatAssn/toAssnApply.do");
        	}else{
        		if (window.injs) {		//APP端
            		injs.accessDetailPageByApp('${basePath}/wechatAssn/toAssnApply.do');
            	}else{
            		location.href='${path}/wechatAssn/toAssnApply.do';
            	}
        	}
        }
    </script>
    
</head>
<body>
	<div class="main">
		<%-- <div class="header">
			<div class="index-top">
				<span class="index-top-5" onclick="history.go(-1);">
					<img src="${path}/STATIC/wechat/image/arrow1.png" />
				</span>
				<span class="index-top-2">安徽文化云-大咖圈</span>
			</div>
		</div> --%>
		<input type="hidden" name="searchAssnName" id="searchAssnName" value="${searchAssnName}"/>
		<div class="content padding-bottom0">
			<ul id="assnUl"></ul>
		</div>
		<div class="footer" style="background-color: transparent;bottom: 40px;border:none;">
			<div class="totop" onclick="$('html,body').animate({scrollTop: 0}, 1000);"><img class="menuBtnShadow" src="${path}/STATIC/wechat/image/newmenu/top.png" /></div>
			<div style="clear: both;"></div>
			<div class="joinwhy" onclick="assnApply();">
				<img src="${path}/STATIC/wechat/image/assn/joinwhy.png" />
			</div>
			<div class="newMenuBTN" style="display: none;">
				<img class="menuBtnShadow" src="${path}/STATIC/wechat/image/newmenu/btn.png" />
			</div>
		</div>
		<div class="newMenuList">
				<div class="swiper-container4 swiper-container-horizontal">
					<div class="swiper-wrapper">
						<div class="swiper-slide">
							<ul>
								<li onclick="location.href='${path}/wechat/index.do'"><img src="${path}/STATIC/wechat/image/newmenu/shouye.png" /></li>
								<li onclick="location.href='${path}/wechatActivity/index.do'"><img src="${path}/STATIC/wechat/image/newmenu/huodong.png" /></li>
								<li onclick="location.href='${path}/wechatVenue/toSpace.do'"><img src="${path}/STATIC/wechat/image/newmenu/kongjian.png" /></li>
								<%--<li onclick="location.href='${path}/wechatAssn/toAssnList.do'"><img src="${path}/STATIC/wechat/image/newmenu/shetuan.png" /></li>--%>
								<%-- <li onclick="location.href='${path}/wechatBpProduct/preProductList.do'"><img src="${path}/STATIC/wechat/image/newmenu/shangcheng.png" /></li>
								<li onclick="location.href='${path}/wechatChuanzhou/chuanzhouIndex.do'"><img src="${path}/STATIC/wechat/image/newmenu/rwcz.png" /></li>
								<li onclick="location.href='${path}/wechatBpAntique/preAntiqueList.do'"><img src="${path}/STATIC/wechat/image/newmenu/wenwu.png" /></li> --%>
								<%-- <li onclick="location.href=''"><img src="${path}/STATIC/wechat/image/newmenu/canyu.png" /></li> --%>
								<li onclick="location.href='${path}/wechatActivity/activitySearchIndex.do'"><img src="${path}/STATIC/wechat/image/newmenu/sousuo.png" /></li>
								<li onclick="location.href='${path}/wechatUser/preTerminalUser.do'"><img src="${path}/STATIC/wechat/image/newmenu/zhongxin.png" /></li>
								<div style="clear: both;"></div>
							</ul>
						</div>
					</div>
					<div id="swiperPage" class="swiper-pagination"></div>

				</div>
				<div class="newMenuCloseBTN">
					<img src="${path}/STATIC/wechat/image/newmenu/closeBTN.png" />
				</div>
			</div>
	</div>
</body>
</html>