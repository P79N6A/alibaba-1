<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>${ccpInformationModule.informationModuleName}</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"></link>
	
	<style type="text/css">
		html,body {height: 100%;background: #f4f4f4;}
	</style>
	
	<script type="text/javascript">
	$.ajaxSettings.async = false; 	//同步执行ajax
	
	var informationModuleId = '${ccpInformationModule.informationModuleId}';
    var appShareTitle = '新鲜资讯，一手播报，快来围观最全线上信息资源！';
	//分享是否隐藏
    if(window.injs){
    	//分享文案
    	if(informationModuleId == 'bd59ef49bc46450392c8b03e37e15207') {
            appShareTitle = '我在文化湖南·锦绣潇湘服务云上发现了一个特别好玩的地方！' ;
        } else if(informationModuleId == '7f86231d89be49a89746b201b06b8288') {
            appShareTitle = '文化湖南·锦绣潇湘服务云推荐的相当韵味哦！';
        }
    	appShareDesc = '${ccpInformationModule.informationModuleName}';
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
				title: appShareTitle,
				desc: '${ccpInformationModule.informationModuleName}',
				imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
			});
			wx.onMenuShareTimeline({
				title: appShareTitle,
				imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
			});
			wx.onMenuShareQQ({
				title: appShareTitle,
				desc: '${ccpInformationModule.informationModuleName}',
				imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
			});
			wx.onMenuShareWeibo({
				title: appShareTitle,
				desc: '${ccpInformationModule.informationModuleName}',
				imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
			});
			wx.onMenuShareQZone({
				title: appShareTitle,
				desc: '${ccpInformationModule.informationModuleName}',
				imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
			});
		});
	}
	
	$(function () {
		loadInformationList(0,num)
		
		 $('.zixunList').on('click', '.swiper-slide', function () {
		    	$(this).parent().find('.swiper-slide').removeClass('cur');
		    	$(this).addClass('cur');
		    	
		    	$(".zSyList").find("li").remove();
		    	startIndex = 0;
		    	loadInformationList(startIndex, num)
		    });
		
		
		var zixunList = new Swiper('.zixunList', {
	        slidesPerView: 'auto',
	        spaceBetween: 0
	    });
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

		window.location.href=window.location.origin+'/wechatInformation/informationDetail.do?informationId='+informationId+'&informationModuleId=${ccpInformationModule.informationModuleId}';
	}
	
	function loadInformationList(index, pagesize){
		$("#loadingDiv").show();
		
		var tab=$(".swiper-slide.cur").attr("value");
		
		var data = {
				informationModuleId:informationModuleId,
               	pageIndex: index,
               	pageNum: pagesize
            };
		
		if(tab=="recommend"){
			data.informationIsRecommend=1
		}else if (tab=="all"){
			
		}else if(tab){
			data.informationType=tab;
		}
		
		$.post("${path}/wechatInformation/queryInformationList.do",data, function (data) {
			$("#loadingDiv").hide();
		    $.each(data, function (i, dom) {
				var date =formatTimeStr(dom.informationCreateTime);
				
				var informationTags=dom.informationTags;
				
				var tagDiv="";
				
				if(informationTags){
					
					tagDiv='<div class="label fl">'+informationTags.split(",")[0]+'</div>';
				}
					
				// var informationIconUrl=getIndexImgUrl(getImgUrl(dom.informationIconUrl), "_730_375");
				var li='<li class="jzCenter" >'+
				    		'<div class="tit">'+dom.informationTitle+'</div>'+
				    		'<div class="pic"><a href="'+dom.toUrl+'"><img src="'+dom.informationIconUrl+'"></a></div>'+
				    		'<div class="clearfix">'+
				    			tagDiv+
				    			'<div class="time fl">'+date+'</div>'+
				    			'<div class="dianz fr"><span></span>'+dom.wantCount+'</div>'+
				    			'<div class="pingl fr"><span></span>'+dom.commentCount+'</div>'+
				    		'</div>'+
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
		<div class="zixunList swiper-container">
	        <div class="swiper-wrapper">
	            <%--<div class="swiper-slide cur" value="recommend"><span>推荐</span><em></em></div>--%>
	            <div class="swiper-slide" value="all"><span>全部</span><em></em></div>
				<c:forEach items="${typeList }" var="informationType">
				  <div class="swiper-slide" value="${informationType.informationTypeId}"><span>${informationType.typeName }</span><em></em></div>
				
				</c:forEach>
	        </div>
		</div>
    	<ul class="zSyList colColor">
	    	<div id="loadingDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
	    </ul>
	</div>
</body>
</html>