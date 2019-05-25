<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>${informationType.typeName}</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"></link>
	
	<style type="text/css">
		html,body {height: 100%;background: #f4f4f4;}
	</style>
	
	<script type="text/javascript">
	$.ajaxSettings.async = false; 	//同步执行ajax
	
	//分享是否隐藏
    if(window.injs){
    	//分享文案
    	appShareTitle = '新鲜资讯，一手播报，快来围观最全线上信息资源！';
    	appShareDesc = '${informationType.typeName}';
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
				title: "新鲜资讯，一手播报，快来围观最全线上信息资源！",
				desc: '${informationType.typeName}',
				imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
			});
			wx.onMenuShareTimeline({
				title: "新鲜资讯，一手播报，快来围观最全线上信息资源！",
				imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
			});
			wx.onMenuShareQQ({
				title: "新鲜资讯，一手播报，快来围观最全线上信息资源！",
				desc: '${informationType.typeName}',
				imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
			});
			wx.onMenuShareWeibo({
				title: "新鲜资讯，一手播报，快来围观最全线上信息资源！",
				desc: '${informationType.typeName}',
				imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
			});
			wx.onMenuShareQZone({
				title: "新鲜资讯，一手播报，快来围观最全线上信息资源！",
				desc: '${informationType.typeName}',
				imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
			});
		});
	}
	
	$(function () {
		loadInformationList(0,num)
	})
	
	var startIndex = 0;		//页数
	var num=20
	var toDay='${toDay}'
	
	//滑屏分页
	var loadDataLock = true;
	$(window).on("scroll", function () {
	    var scrollTop = $(document).scrollTop();
	    var pageHeight = $(document).height();
	    var winHeight = $(window).height();
	    if (scrollTop >= (pageHeight - winHeight - 80)) {
	    	if(loadDataLock){
				loadDataLock = false;
   				startIndex += num;
          		var index = startIndex;
		   		setTimeout(function () { 
		          		loadInformationList(index,num);
		   		},800);
	    	}
	    }
	});
	
	function loadInformation(informationId){
		
		window.location.href='${basePath}wechatInformation/informationDetail.do?informationId='+informationId;
	}
	
	function loadInformationList(index, pagesize){
		$("#loadingDiv").show();
		var data = {
				informationType:'${informationType.informationTypeId}',
               	pageIndex: index,
               	pageNum: pagesize
            };
		
		$.post("${path}/wechatInformation/queryInformationList.do",data, function (data) {
			$("#loadingDiv").hide();
		    $.each(data, function (i, dom) {
				var date =formatTimeStr(dom.informationCreateTime);
				var informationTags=dom.informationTags;
				var tagDiv="";
				if(informationTags){
					tagDiv='<div class="label fl">'+informationTags.split(",")[0]+'</div>';
				}
				var informationIconUrl=getIndexImgUrl(getImgUrl(dom.informationIconUrl), "_730_375");
				var li='<li class="jzCenter" onclick="loadInformation(\''+dom.informationId+'\');">'+
				    		// '<div class="tit">'+dom.informationTitle+'</div>'+
				    		'<div class="pic"><img src="'+informationIconUrl+'"></div>'+
				    		// '<div class="clearfix">'+
				    		// 	tagDiv+
				    		// 	'<div class="time fl">'+date+'</div>'+
				    		// 	'<div class="dianz fr"><span></span>'+dom.wantCount+'</div>'+
				    		// 	'<div class="pingl fr"><span></span>'+dom.commentCount+'</div>'+
				    		// '</div>'+
				    	'</li>';
					
		    	$(".zSyList").append(li);
		    	
			});
			loadDataLock = true;
		},"json");
	}
	
	</script>
</head>
	
<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wx/image/share_120.png"/></div>
	<div class="zMain">	
    	<ul class="zSyList colColor">
	    	<div id="loadingDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
	    </ul>
	</div>
</body>
</html>