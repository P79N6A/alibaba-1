<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>佛山文化云·文化志愿者</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
	
	 var title='佛山文化云·志愿者招募';
	 var desc= '为热爱文化和艺术、热心公益的人们提供众多实践机会';
	 var imgUrl='${basePath}/STATIC/wx/image/share_120.png';
	 
		//分享是否隐藏
	   	 if(window.injs){
	    	//分享文案
	    	appShareTitle = title;
	    	appShareDesc =desc;
	    	appShareImgUrl = imgUrl;
	    	
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
						title: title,
						desc: desc,
						imgUrl: imgUrl,
						link: '${basePath}wechatStatic/volunteerRecruitIndex.do'
					});
					wx.onMenuShareTimeline({
						title: title,
						imgUrl: imgUrl,
						link: '${basePath}wechatStatic/volunteerRecruitIndex.do'
					});
					wx.onMenuShareQQ({
						title: title,
						desc: desc,
						imgUrl: imgUrl,
						link: '${basePath}/wechatStatic/volunteerRecruitIndex.do'
					});
					wx.onMenuShareWeibo({
						title: title,
						desc: desc,
						imgUrl: imgUrl,
						link: '${basePath}/wechatStatic/volunteerRecruitIndex.do'
					});
					wx.onMenuShareQZone({
						title: title,
						desc: desc,
						imgUrl: imgUrl,
						link: '${basePath}/wechatStatic/volunteerRecruitIndex.do'
					});
				});
			}
		
		$(function () {
			
			$.post("${path}/wechatStatic/getVolunteerRecruitList.do", function (data) {
				if (data.status == 1) {
					$.each(data.data, function (i, dom) {
						var recruit="";
					//	var imgUrl = getImgUrl(dom.topicIcon);
						//$("#topicUl").append("<li id='"+dom.topicId+"' onclick='showQuestion(\""+dom.topicId+"\")'>" +
						//		"<img src='"+imgUrl+"' width='220' height='167'/>" +
						//	 "</li>");	
						var recruitIconUrl=getImgUrl(dom.recruitIconUrl);
						var recruitId=dom.recruitId;
						
						recruit+='<li>'+
									'<div>'+
									'<a href="${path}/wechatStatic/toVolunteerDetail.do?recruitId='+recruitId+'">'+
										'<img src="'+recruitIconUrl+'" width="750" height="400" />'+
										'<div class="volunteers-bg"></div>'+
										'<div class="volunteers-pop">'+
											'<p>'+dom.recruitName+'</p>'+
											'<div class="volunteers-tag">'+
												'<ul>';
						if(dom.ageRequirement)
						{
							recruit+='<li>'+
							'<p>'+dom.ageRequirement+'</p>'+
							'</li>';
						}
						
						if(dom.educationRequirement)
						{
							recruit+='<li>'+
							'<p>'+dom.educationRequirement+'</p>'+
							'</li>';
						}
													
						recruit+='<div style="clear: both;"></div>'+
												'<ul>'+
											'</div>'+
										'</div>'+
										'</a>'+
									'</div>'+
								'</li>';
								
						$("#volunteer-recruit-list").append(recruit);
						
					});
				}
			}, "json");
			
			// 我要报名
			$(".volunteers").click(function () {
				
				if (userId ==null || userId == '') {
		            
		            publicLogin("${basePath}wechatStatic/createVolunteerApply.do");
		        }
				else
				{
					 window.location.href = '${path}/wechatStatic/createVolunteerApply.do';
		             return;
				}
		    })
		});
		
		
	</script>
</head>

	<body>
		<div class="volunteers-main">
			<div class="volunteers-content">
				<div class="volunteers">
					<img src="${path}/STATIC/wxStatic/image/zyz/whzyzbanner.png" />
				</div>
				<div class="volunteers-title">
					<p>-热门志愿者招募-</p>
				</div>
				<ul id="volunteer-recruit-list">
					
				</ul>
				<div class="volunteers-title">
					<!-- <p>-热门志愿者招募-</p>-->
				</div>
				<!-- <ul class="volunteersHot">
					<li>
						<img src="image/whzyz/test-4.png">
						<p>幸福的像花儿一样</p>
					</li>
					<li>
						<img src="image/whzyz/test-4.png">
						<p>幸福的像花儿一样</p>
					</li>
					<li>
						<img src="image/whzyz/test-4.png">
						<p>幸福的像花儿一样</p>
					</li>
					<li>
						<img src="image/whzyz/test-4.png">
						<p>幸福的像花儿一样</p>
					</li>
					<div style="clear: both;"></div>
				</ul> -->
			</div>
		</div>
	</body>

</html>