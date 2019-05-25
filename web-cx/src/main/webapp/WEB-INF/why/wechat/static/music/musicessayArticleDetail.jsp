<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>佛山文化云·音乐中的真善美</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series-2.css?v=20161021"/>
	<script src="${path}/STATIC/js/common.js"></script>
<style>
html,
		body {
			height: 100%;
		}
		
		.musicMain {
			width: 750px;
			margin: auto;
			min-height: 100%;
			background-color: #eeeeee;
		}
		.musicMain .content .musicListMenu .musicBestNum {padding-left:10px;}
</style>
<script type="text/javascript">

var articleId='${ article.articleId}'
var articleType='${ article.articleType}'

var desc='听音乐，写感受；品味音乐之韵，网罗周边之美！'
var title='听TA讲述音乐故事，如果打动你就请为TA点赞吧！'

if(articleType==2){
	
	desc='听音乐，写感受；品味音乐之韵，网罗周边之美！'
	title='听TA讲述音乐故事，为TA祈祷获得1000元奖金！'
}

//分享是否隐藏
if(window.injs){
	//分享文案
	appShareTitle = title;
	appShareDesc = desc;
	appShareImgUrl = '${basePath}/STATIC/wechat/image/musicZSM/shareIcon.jpg';
	
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
			imgUrl: '${basePath}/STATIC/wechat/image/musicZSM/shareIcon.jpg'
		});
		wx.onMenuShareTimeline({
			title: title,
			imgUrl: '${basePath}/STATIC/wechat/image/musicZSM/shareIcon.jpg'
		});
		wx.onMenuShareQQ({
			title: title,
			desc: desc,
			imgUrl: '${basePath}/STATIC/wechat/image/musicZSM/shareIcon.jpg'
		});
		wx.onMenuShareWeibo({
			title: title,
			desc: desc,
			imgUrl: '${basePath}/STATIC/wechat/image/musicZSM/shareIcon.jpg'
		});
		wx.onMenuShareQZone({
			title: title,
			desc: desc,
			imgUrl: '${basePath}/STATIC/wechat/image/musicZSM/shareIcon.jpg'
		});
	});
}
	
$(function() {
	
	var indexTag = '${article.articleType}';	//当前所在标签
	
	$(".musicDetailBtnCenter").click(function(){
		
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
			
			$(".myBtn").on("click",function(e){
				
				if (userId == null || userId == '') {
					publicLogin("${basePath}wechatStatic/myMusicIndex.do?indexTag="+indexTag);
				}
				else{
					 window.location.href='${basePath}wechatStatic/myMusicIndex.do?indexTag='+indexTag
				}
			})
			
			$(".rankingBtn").on("click",function(e){
				
				 window.location.href='${basePath}wechatStatic/musicRanking.do?userId='+userId
			})
			
			$(".ruleBtn").on("click",function(e){
				
				 window.location.href='${basePath}wechatStatic/musicRule.do'
			})
			
			var userHeadImgUrl=$("#userHead").attr("data");
	
			$("#userHead").attr("src",getHeadImgUrl(userHeadImgUrl))
	
			
})

	function like(articleId,div){
	
			var musicBestNum=$(div)
			
			if(musicBestNum.hasClass("musicBestNumOn")){
				
				return false;
			}
			
			dialogAlert('系统提示', '活动已结束！');
	        return false;
		}
		
function getHeadImgUrl(userHeadImgUrl){
	
	//头像
	var userHeadImgHtml = '';
	if(userHeadImgUrl){
        if(userHeadImgUrl.indexOf("http") == -1){
        	userHeadImgUrl = getImgUrl(userHeadImgUrl);
        }
        if (userHeadImgUrl.indexOf("http")==-1) {
        	userHeadImgHtml = '../STATIC/wx/image/sh_user_header_icon.png'
        } else if (userHeadImgUrl.indexOf("/front/") != -1) {
            var imgUrl = getIndexImgUrl(userHeadImgUrl, "_300_300");
            userHeadImgHtml =  imgUrl ;
        } else {
        	userHeadImgHtml =  userHeadImgUrl ;
        }
    }else{
    	userHeadImgHtml = "../STATIC/wx/image/sh_user_header_icon.png";
    }
	
	return userHeadImgHtml;
}
</script>
</head>
 <%   request.setAttribute("vEnter", "\r\n");   %>
<body>
<div style="display: none;"><img src="${basePath}/STATIC/wechat/image/musicZSM/shareIcon.jpg"/></div>
		<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
			<img src="${path}/STATIC/wxStatic/image/fx-bg.png" style="width: 100%;height: 100%;" />
		</div>
<div class="musicMain">

			<!--头图-->
			<div class="musicBanner">
				<img src="${path}/STATIC/wechat/image/musicZSM/banner.jpg" />
				<div class="myBtn">
					<img src="${path}/STATIC/wechat/image/musicZSM/myBtn.png" />
				</div>
				 <div class="rankingBtn">
					<img src="${path}/STATIC/wechat/image/musicZSM/rankingBtn.png" />
				</div>
				<div class="ruleBtn">
					<img src="${path}/STATIC/wechat/image/musicZSM/ruleBtn.png" />
				</div> 
			</div>

			<!--菜单-->
			<div class="musicMenu clearfix">
				<div class="musicWeiping musicRightLine">
					<div class="musicMenuBtn <c:if test="${ article.articleType==1}">musicMenuOn</c:if>" <c:if test="${ article.articleType==2}">onclick="window.location.href='${basePath}wechatStatic/musicIndex.do?indexTag=1'"</c:if>>微&emsp;评</div>
				</div>
				<div class="musicZhengwen">
					<div class="musicMenuBtn <c:if test="${ article.articleType==2}">musicMenuOn</c:if>" <c:if test="${ article.articleType==1}">onclick="window.location.href='${basePath}wechatStatic/musicIndex.do?indexTag=2'"</c:if>>征&emsp;文</div>
				</div>
			</div>

			<div class="content musicFontList">
				<div class="musicList">
					<!--  <div class="musicDetailTitle">
						#&emsp;&emsp;请为“<span>天空之城</span>”发布的微评投票&emsp;&emsp;#
					</div>-->
					<p class="musicDetailName">${ article.articleTitle}</p>
					<p class="musicListFont">${fn:replace(article.articleText, vEnter, "<br/>")}  </p>
					<div class="musicListMenu clearfix">
						<div class="musicUserInfo clearfix">
							<div class="musicUserImg">
								<img id="userHead" data="${article.userHeadImgUrl }" src="" />
							</div>
							<p>${article.userName }</p>
						</div>
						<c:choose>
							<c:when test="${article.articleType==2 }">
							
							</c:when>
							<c:when test="${article.isLike==1 }">
							<div class="musicBestNum musicBestNumOn" >${article.articleLike }</div>
							</c:when>
							<c:otherwise>
							<div class="musicBestNum" onclick="like('${article.articleId}',this)">${article.articleLike }</div>
							
							</c:otherwise>
						</c:choose>
						
						
					</div>
					<div class="musicDetailBtn clearfix">
						<div class="musicDetailBtnCenter">分享</div>
					</div>
				</div>

				<!--征文样式-->
				<!--<div class="musicList">
					<div class="musicDetailTitle">
						#&emsp;&emsp;分享“<span>天空之城</span>”发布的征文发&emsp;&emsp;#
					</div>
					<p>音乐沁透灵魂</p>
					<p class="musicListFont">高校音乐教师是音乐院系的主体，其文化素养表现出来的学识水平、教学艺术、创新能力是高校音乐教育发展的普遍需求。要建设一支具有现代音乐教育理念的教师队伍。高校音乐教师是音乐院系的主体，其文化素养表现出来的学识水平、教学艺术、创新能力是高校音乐教育发展的普遍需求。要建设一支具有现代音乐教育理念的教师队伍，加强教师教。</p>
					<div class="musicListMenu clearfix">
						<div class="musicUserInfo clearfix">
							<div class="musicUserImg">
								<img src="../image/musicZSM/userImg.png" />
							</div>
							<p>云叔云叔</p>
						</div>
						<div class="musicGetBtn musicGetBtnOn">分享</div>
					</div>
					<div class="musicDetailBtn clearfix">
						<div class="musicDetailBtnCenter">分享</div>
					</div>
				</div>-->
			</div>
		</div>

</body>