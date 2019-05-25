<%@ page language="java" pageEncoding="UTF-8" %>
<html >
<head>
    <title>${managementInformation.shareTitle}</title>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/info.css?20160516"/>
    <script type="text/javascript" src="${path}/STATIC/js/common.js"></script>
    <script type="text/javascript">
        
    	$(function(){
    		formatStyle("informationContent");
    	});
    
      	//分享是否隐藏
        if(window.injs){
        	//分享文案
	    	appShareTitle = '${managementInformation.shareTitle}';
	    	appShareDesc = '${managementInformation.shareSummary}';
	    	var shareImg = '${managementInformation.shareIconUrl}';		//app必须分步执行，不然调不到值
            appShareImgUrl = getIndexImgUrl(getImgUrl(shareImg),"_500_500");

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
                jsApiList: ['onMenuShareAppMessage', 'onMenuShareTimeline', 'onMenuShareQQ', 'onMenuShareWeibo', 'onMenuShareQZone']
            });
            wx.ready(function () {
                wx.onMenuShareAppMessage({
                    title:'${managementInformation.shareTitle}',
                    desc: '${managementInformation.shareSummary}',
                    imgUrl:getIndexImgUrl(getImgUrl($('#shareIconUrl').val()),"_500_500")
                });
                wx.onMenuShareTimeline({
                    title: '${managementInformation.shareTitle}',
                    imgUrl: getIndexImgUrl(getImgUrl($('#shareIconUrl').val()), "_500_500")
                });
                wx.onMenuShareQQ({
                    title: '${managementInformation.shareTitle}',
                    desc: '${managementInformation.shareSummary}',
                    imgUrl:getIndexImgUrl(getImgUrl($('#shareIconUrl').val()), "_500_500"),
                });
                wx.onMenuShareWeibo({
                    title:' ${managementInformation.shareTitle}',
                    desc: '${managementInformation.shareSummary}',
                    imgUrl:getIndexImgUrl(getImgUrl($('#shareIconUrl').val()), "_500_500"),
                });
                wx.onMenuShareQZone({
                    title:' ${managementInformation.shareTitle}',
                    desc:' ${managementInformation.shareSummary}',
                    imgUrl: getIndexImgUrl(getImgUrl($('#shareIconUrl').val()), "_500_500"),
                });
            });
        }

      	//富文本格式修改
        function formatStyle(id) {
            var $cont = $("#" + id);
            $cont.find("img").each(function () {
            	var $this = $(this);
            	$this.css({"max-width": "710px"});
            });
            $cont.find("p,span,font").each(function () {
                var $this = $(this);
                $this.css({
                    "font-size": "24px",
                    "color": "#7C7C7C",
                    "line-height": "44px",
                    "font-family": "Microsoft YaHei"
                });
            });
            $cont.find("a").each(function () {
                var $this = $(this);
                $this.css({
                	"text-decoration": "underline",
                	"color": "#7C7C7C"
                });
            });
            var str = $cont.html();
            str.replace(/<span>/g, "").replace(/<\/span>/g, "");
            $cont.html(str);
        }
    </script>
    
</head>
<body>
<div class="advice_con">
    <div class="titl">${managementInformation.informationTitle}</div>
    <div class="author">by:${managementInformation.authorName}</div>
    <div class="label">
        <c:forEach items="${managementInformation.informationTags}" var="avct">
            <a><c:out escapeXml="true" value="${avct}"/></a>
        </c:forEach>
    </div>
    <div id="informationContent" class="c_list">
        ${managementInformation.informationContent}
    </div>
    <!-- 重新修改图片链接地址（防止APP打开图片，用div来遮罩） -->
    <script type="text/javascript">
    	$(".huodong").parent().css("position","relative");
    	var ua = navigator.userAgent.toLowerCase();	
    	$(".huodong").each(function () {
    		var h_height = $(this).find("img").height();
			var h_width = $(this).find("img").width();
			var hrefUrl = '';
    		if (/wenhuayun/.test(ua)) {		//APP端
    			hrefUrl = "com.wenhuayun.app://activitydetail?activityId=" + $(this).attr("id");
        	}else{		//H5
        		hrefUrl = "${path}/wechatActivity/preActivityDetail.do?activityId=" + $(this).attr("id");
        	}
    		
    		$(this).after(
   				"<div onclick='location.href=\""+hrefUrl+"\"' style='height: " + h_height + "px;width: " + h_width + "px;filter:alpha(Opacity=0);-moz-opacity:0;opacity: 0;z-index:100; background-color:#ffffff;position: absolute;left: 5px;top: 0px;'>" +
   				"</div>"
   			)
    	});
    	$(".changguan").parent().css("position","relative");
    	$(".changguan").each(function () {
    		var h_height = $(this).find("img").height();
			var h_width = $(this).find("img").width();
			var hrefUrl = '';
    		if (/wenhuayun/.test(ua)) {		//APP端
    			hrefUrl = "com.wenhuayun.app://venuedetail?venueId=" + $(this).attr("id");
        	}else{		//H5
        		hrefUrl = "${path}/wechatVenue/venueDetailIndex.do?venueId=" + $(this).attr("id");
        	}
    		
    		$(this).after(
   				"<div onclick='location.href=\""+hrefUrl+"\"' style='height: " + h_height + "px;width: " + h_width + "px;filter:alpha(Opacity=0);-moz-opacity:0;opacity: 0;z-index:100; background-color:#ffffff;position: absolute;left: 5px;top: 0px;'>" +
   				"</div>"
   			)
    	});
    </script>
    <c:if test="${managementInformation.informationFooter == 1}">
        <div class="change_img" ng-show="info.informationFooter">
            <img src="${path}/STATIC/image/advice_img.png" width="680" height="375">
        </div>
    </c:if>
    <div class="sum_author clearfix">
        <div class="sa_l fl">浏览量：${managementInformation.browseCount}</div>
        <div class="sa_r fr">发布者：${managementInformation.publisherName}</div>
    </div>
</div>
<input type="hidden" id="shareIconUrl" name="shareIconUrl" value="${managementInformation.shareIconUrl}">
</body>

</html>
