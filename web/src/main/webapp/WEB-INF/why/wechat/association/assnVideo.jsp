<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>社团视频</title>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/common.js"></script>

    <script>
        var assnId = '${assnId}';
        
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
        	$.post("${path}/wechatAssn/getAssnRes.do",{associationId:assnId,resType:2}, function (data) {
    			if(data.status == 1){
    				$.each(data.data, function (i, dom) {
    					var assnResNameHtml = "";
    					if(dom.assnResName){
    						assnResNameHtml = "<p>"+dom.assnResName+"</p>";
    					}
    					var assnResCover = dom.assnResCover.indexOf("http://")<0?getIndexImgUrl(getImgUrl(dom.assnResCover),"_750_500"):(dom.assnResCover+"@800w");
    					$("#assnVideoUl").append("<li>" +
						 							"<video src='"+dom.assnResUrl+"' poster='"+assnResCover+"' controls style='width:360px;height:230px;'/>" +
						 							assnResNameHtml +
						 						 "</li>");
            		});
        		}
        	}, "json");
        })
        
    </script>
    
</head>
<body>
	<div class="main">
		<%-- <div class="header">
			<div class="index-top">
				<span class="index-top-5" onclick="history.go(-1);">
					<img src="${path}/STATIC/wechat/image/arrow1.png" />
				</span>
				<span class="index-top-2">社团视频</span>
			</div>
		</div> --%>
		<div class="content padding-bottom0">
			<div class="community-active2">
				<ul id="assnVideoUl"></ul>
			</div>
		</div>
	</div>
</body>
</html>