<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>佛山文化云·古韵嘉州</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series-2.css"/>
	<script src="${path}/STATIC/js/common.js"></script>		
	
	<script>
	//分享是否隐藏
    if(window.injs){
    	//分享文案
    	appShareTitle = '【佛山文化云·古韵嘉州】文化资讯';
    	appShareDesc = '带你领略乐山的古往今来、历史发展';
    	appShareImgUrl = 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20177319822wH3anU9izUr007hjxmKfOPdcEzHE01.png';
    	
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
			jsApiList: ['previewImage','onMenuShareAppMessage','onMenuShareTimeline','onMenuShareQQ','onMenuShareWeibo','onMenuShareQZone']
		});
		wx.ready(function () {
			wx.onMenuShareAppMessage({
				title: '【佛山文化云·古韵嘉州】文化资讯',
				desc: '带你领略乐山的古往今来、历史发展',
				imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20177319822wH3anU9izUr007hjxmKfOPdcEzHE01.png'
			});
			wx.onMenuShareTimeline({
				title: '【佛山文化云·古韵嘉州】文化资讯',
				desc: '带你领略乐山的古往今来、历史发展',
				imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20177319822wH3anU9izUr007hjxmKfOPdcEzHE01.png'
			});
			wx.onMenuShareQQ({
				title: '【佛山文化云·古韵嘉州】文化资讯',
				desc: '带你领略乐山的古往今来、历史发展',
				imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20177319822wH3anU9izUr007hjxmKfOPdcEzHE01.png'
			});
			wx.onMenuShareWeibo({
				title: '【佛山文化云·古韵嘉州】文化资讯',
				desc: '带你领略乐山的古往今来、历史发展',
				imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20177319822wH3anU9izUr007hjxmKfOPdcEzHE01.png'
			});
			wx.onMenuShareQZone({
				title: '【佛山文化云·古韵嘉州】文化资讯',
				desc: '带你领略乐山的古往今来、历史发展',
				imgUrl: 'http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20177319822wH3anU9izUr007hjxmKfOPdcEzHE01.png'
			});
		});
	}
	
	$(function () {
		$.post("${path}/wechatStatic/getCcpJiazhouInfoList.do", function (data) {
			 if (data.status == 200) {
			      $.each(data.data, function (i, dom) {
                	var jiazhouInfoCreate = jsDateDiff(dom.jiazhouInfoCreateTime);
                		$("#infoList").append('<li onclick="jiazhouInfoDetail(\''+dom.jiazhouInfoId+'\');">'+
                		        '<div class="jzListDiv">'+
                				'<div class="jzListTitle">'+dom.jiazhouInfoTitle+'</div>'+
                				'<div class="jzListImg">'+
    							'<img src='+dom.jiazhouInfoIconUrl+'>'+
    						    '</div>'+
    						    '<div class="jzListTag clearfix">'+
     							'<div>'+dom.tagName+'</div>'+
     							'<div>'+jiazhouInfoCreate+'</div>'+
     						    '</div></div></li>');
                	});
			 }
		},"json");
	});
	
	function jsDateDiff(publishTime){  
		if(publishTime.indexOf(".")>=0){
			time = new Date(Date.parse(publishTime.replace(/\./g, "/")));
		}else{
			time = new Date(Date.parse(publishTime.replace(/-/g, "/")));
		}
		publishTime = time.getTime() / 1000;
	    var d_minutes,d_hours,d_days;       
	    var timeNow = parseInt(new Date().getTime()/1000);  
	    var d;       
	    d = timeNow - publishTime;       
	    d_days = parseInt(d/86400);       
	    d_hours = parseInt(d/3600);       
	    d_minutes = parseInt(d/60);       
	    if(d_days>0 && d_days<4){       
	        return d_days+"天前";       
	    }else if(d_days<=0 && d_hours>0){       
	        return d_hours+"小时前";       
	    }else if(d_hours<=0 && d_minutes>0){       
	        return d_minutes+"分钟前";       
	    }else{       
	        var s = new Date(publishTime*1000);       
	        return (s.getMonth()+1)+"月"+s.getDate()+"日";       
	    }       
	} 		
	
	//跳转到嘉州详情页
    function jiazhouInfoDetail(jiazhouInfoId){
    	if (window.injs) {		//APP端
    		injs.accessDetailPageByApp('${basePath}/wechatStatic/jiazhouInfoDetail.do?jiazhouInfoId='+jiazhouInfoId);
    	}else{
    		window.parent.location.href='${path}/wechatStatic/jiazhouInfoDetail.do?jiazhouInfoId='+jiazhouInfoId;
    	}
    }
	</script>	
</head>
<body>
<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/20177319822wH3anU9izUr007hjxmKfOPdcEzHE01.png"/></div>
	<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
		<img src="${path}/STATIC/wechat/image/commonShare.png" style="width: 100%;height: 100%;" />
	</div>
		<div class="jiazhouImfoMain">
			<ul id="infoList"></ul>
		</div>
	</body>

</html>