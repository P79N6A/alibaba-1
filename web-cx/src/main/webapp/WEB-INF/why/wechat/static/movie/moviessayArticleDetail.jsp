<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>佛山文化云·电影中的真善美</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series-movie.css" />
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
	</style>
	<script type="text/javascript">
		
			$.ajaxSettings.async = false; 
			var articleId='${ article.articleId}'
			var articleType='${ article.articleType}'
	
			var desc='看电影，写感受，体味别样人生，增加生命厚度！'
			var title='上海国际电影节20周年，听${ article.userName}讲述电影故事，如果打动你就请为TA点赞吧！'
	
			if(articleType==2){
				
				desc='看电影，写感受，体味别样人生，增加生命厚度！'
				title='上海国际电影节20周年，听${ article.userName}讲述电影故事，为TA祈祷获得1000元奖金！'
			}
	
			//分享是否隐藏
			if(window.injs){
				//分享文案
				appShareTitle = title;
				appShareDesc = desc;
				appShareImgUrl = '${basePath}/STATIC/wxStatic/image/movieZSM/shareIcon.jpeg';
				
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
						imgUrl: '${basePath}/STATIC/wxStatic/image/movieZSM/shareIcon.jpeg'
					});
					wx.onMenuShareTimeline({
						title: title,
						imgUrl: '${basePath}/STATIC/wxStatic/image/movieZSM/shareIcon.jpeg'
					});
					wx.onMenuShareQQ({
						title: title,
						desc: desc,
						imgUrl: '${basePath}/STATIC/wxStatic/image/movieZSM/shareIcon.jpeg'
					});
					wx.onMenuShareWeibo({
						title: title,
						desc: desc,
						imgUrl: '${basePath}/STATIC/wxStatic/image/movieZSM/shareIcon.jpeg'
					});
					wx.onMenuShareQZone({
						title: title,
						desc: desc,
						imgUrl: '${basePath}/STATIC/wxStatic/image/movieZSM/shareIcon.jpeg'
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
			});
			
			
			$(".background-fx").click(function() {
				$("html,body").removeClass("bg-notouch");
				$(".background-fx").css("display", "none")
			});	
			
			
			if(indexTag==1){
				$(".musicMenu a:eq(1)").addClass("musicMenuOn").siblings().removeClass("musicMenuOnTwo");
				$(".musicDetailTitle_p span").css("background-color","#fb393c")
			}else{
				//征文
				$(".musicMenu a:eq(1)").addClass("musicMenuOnTwo").siblings().removeClass("musicMenuOn");
				$(".musicDetailTitle_p span").css("background-color","#f3a851")
			}
			
			
	/* 		$(".musicMenu").find("a").on("click",function(){
				//微评
				if($(this).index() == 0){
					$(this).addClass("musicMenuOn").siblings().removeClass("musicMenuOnTwo");
//					$(".musicDetailTitle_p span").css("background-color","#fb393c")
				}else{
					//征文
					$(this).addClass("musicMenuOnTwo").siblings().removeClass("musicMenuOn");
//					$(".musicDetailTitle_p span").css("background-color","#f3a851")
				}
			}) */
			//点击我的跳转我的页面
			$(".myBtn").click(function(){
				if (userId == null || userId == '') {
					publicLogin('${basePath}wechatStatic/myMovieIndex.do?indexTag=1');
				}
				else{
					 window.location.href='${basePath}wechatStatic/myMovieIndex.do?indexTag=1';
				}
			});
			
			
			
			//跳转查看排名
			$(".rankingBtn").on("click",function(e){
				 window.location.href='${basePath}wechatStatic/movieRanking.do?userId='+userId
			});
			
			
			//跳转活动规则
			$(".ruleBtn").click(function(){
				 window.location.href='${basePath}wechatStatic/movieRule.do'
			});
		});
		
		
		//用户的点赞操作
		function like(articleId,div){
			var musicBestNum=$(div);
			var p = musicBestNum.find('p');
			if(musicBestNum.hasClass("musicBestNumOn")){
				return false;
			}
			else if (userId == null || userId == '') {
        		//判断登陆
            	publicLogin("${basePath}wechatStatic/musicIndex.do?indexTag=1");
        	}
			else if("${sessionScope.endDz}"=="true"){
				dialogAlert('系统提示', '活动已结束！');
				return false;
			}
			else{
				$.post("${path}/wechatStatic/likeMoviessayArticle.do",{articleId:articleId,userId:userId}, function (data) {
				},'json');
				musicBestNum.addClass("musicBestNumOn");
				var num=parseInt(p.html())+1;
				p.html(num);
			}	
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
		
		
		
		
		function TransferString(content)  
		{  
		    var string = content;  
		    try{  
		        string=string.replace(/\r\n/g,"<BR>")  
		        string=string.replace(/\n/g,"<BR>");  
		    }catch(e) {  
		        alert(e.message);  
		    }  
		    return string;  
		}
		
	</script>
</head>
<%   request.setAttribute("vEnter", "\r\n");   %>
	<body>
	<div style="display: none;"><img src="${basePath}/STATIC/wxStatic/image/movieZSM/shareIcon.jpeg"/></div>
		<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
			<img src="${path}/STATIC/wxStatic/image/fx-bg.png" style="width: 100%;height: 100%;" />
		</div>
		<div class="musicMain">
			<!--头图-->
			<div class="musicBanner">
				<!-- 回到文化云 -->
				<a href="" class="gobackculture">
					回到文化云
				</a>
				<!-- 片单，资讯 -->
				<div class="message">
					<div class="message_child">
						<a href="http://hs.hb.wenhuayun.cn/information/preInfo.do?informationId=2280d976a13343ebbd48578e58614f60&from=singlemessage&isappinstalled=0"></a>
						<a href="http://hs.hb.wenhuayun.cn/wechatFunction/contestQuiz.do?topicId=0933bfca389245ff8ba9d80e430ff510"></a>
					</div>
				</div>
				<img src="${path}/STATIC/wxStatic/image/movieZSM/banner.jpg?20170609" />
				<div class="myBtn">
					<img src="${path}/STATIC/wxStatic/image/movieZSM/myBtn.png" />
				</div>
				<div class="rankingBtn">
					<img src="${path}/STATIC/wxStatic/image/movieZSM/rankingBtn.png" />
				</div>
				<div class="ruleBtn">
					<img src="${path}/STATIC/wxStatic/image/movieZSM/ruleBtn.png" />
				</div>
			</div>

			<!--菜单-->
			<div class="musicMenu clearfix">
				<a href="javascript:void(0)" onclick="window.location.href='${basePath}wechatStatic/movieIndex.do?indexTag=1'">主&emsp;页</a>
				<c:if test="${ article.articleType==1}">
					<a href="javascript:void(0)" class='musicMenuOn'>微&emsp;评&emsp;详&emsp;情</a>
				</c:if>
				<c:if test="${ article.articleType==2}">
					<a href="javascript:void(0)" class='musicMenuOnTwo'>征&emsp;文&emsp;详&emsp;情</a>
				</c:if>
			</div>

			<div class="content musicFontList">
				<c:if test="${ article.articleType==1}">
					<!-- 微评样式 -->
					<div class="musicList movieList">
						<div class="musicDetailTitle" style="border-bottom:1px solid #eeeeee">
							<p>#&emsp;请为“<span>${article.userName }</span>”发布的微评投票&emsp;#</p>
							<p class="musicDetailTitle_p">
								<c:if test="${article.themeType==1}">
									<span>电影中的真善美</span>
								</c:if>
								<c:if test="${article.themeType==2}">
									<span>我与我的电影节</span>
								</c:if>
							</p>
						</div>
						<div class="movieName clearfix">
							<img src="${path}/STATIC/wxStatic/image/movieZSM/redmovie.jpg" alt="">
							<span>${article.movieName }</span>
						</div>
						<p class="musicListFont"><span>${article.articleTitle}</span>${fn:replace(article.articleText, vEnter, "<br/>")}</p>
						<div class="musicListMenu clearfix" style="padding-left: 38px;">
							<div class="musicUserInfo clearfix">
								<div class="musicUserImg">
									<img id="userHead${article.articleId }" data="${article.userHeadImgUrl }" />
									<script >
										$(function(){	
											var articleId='${article.articleId }'
											var userHeadImgUrl=$("#userHead"+articleId).attr("data");
											$("#userHead"+articleId).attr("src",getHeadImgUrl(userHeadImgUrl))
										});
									</script>
								</div>
								<p>${article.userName }</p>
							</div>
							
							<c:choose>
								<c:when test="${article.isLike==1 }">
									<div class="musicBestNum musicBestNumOn" style="margin-top:26px;">
										<p>${article.articleLike }</p>
									</div>
								</c:when>
								<c:otherwise>
									<div class="musicBestNum" rankpost onclick="like('${article.articleId}',this)">
										<p>${article.articleLike }</p>
									</div>
								</c:otherwise>
							</c:choose>
						</div>
						<div class="musicDetailBtn clearfix">
							<div class="musicDetailBtnCenter">分享去拉票</div>
						</div>
					</div>
				</c:if>
				
				
				<c:if test="${ article.articleType==2}">
					<!--征文样式-->
					<div class="musicList movieList" >
						<div class="musicDetailTitle" style="border-bottom:1px solid #eeeeee">
							<p>#&emsp;分享“<span>${article.userName }</span>”发布的征文发&emsp;#</p>
							<p class="musicDetailTitle_p">
								<c:if test="${article.themeType==1}">
									<span>电影中的真善美</span>
								</c:if>
								<c:if test="${article.themeType==2}">
									<span>我与我的电影节</span>
								</c:if>
							</p>
						</div>
						<div class="movieName clearfix">
							<img src="${path}/STATIC/wxStatic/image/movieZSM/ymovie.jpg" alt="">
							<span class="zwname">${article.movieName }</span>
						</div>
						<p class="musicListFont zwmusicListFont"><span>${article.articleTitle}</span>${fn:replace(article.articleText, vEnter, "<br/>")}</p>
						<div class="musicListMenu clearfix" style="padding-left: 38px;">
							<div class="musicUserInfo clearfix">
								<div class="musicUserImg">
									<img id="userHead${article.articleId }" data="${article.userHeadImgUrl }" />
									<script >
										$(function(){	
											var articleId='${article.articleId }'
											var userHeadImgUrl=$("#userHead"+articleId).attr("data");
											$("#userHead"+articleId).attr("src",getHeadImgUrl(userHeadImgUrl))
										});
									</script>
								</div>
								<p>${article.userName }</p>
							</div>
						</div>
						<div class="musicDetailBtn clearfix">
							<div class="musicDetailBtnCenter">分享</div>
						</div>
					</div> 
				</c:if>
			</div>
		</div>
	</body>

</html>