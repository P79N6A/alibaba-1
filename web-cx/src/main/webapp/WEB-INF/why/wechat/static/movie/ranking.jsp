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
		.musicBestNum {background: url(${path}/STATIC/wechat/image/musicZSM/best.png) no-repeat top center;margin-top: 30px;}
		.musicBestNum.musicBestNumOn {background-image: url(${path}/STATIC/wechat/image/musicZSM/bestOn.png)}
		.musicBestNum p {margin-top: 41px;}
	</style>
	<script type="text/javascript">
	    $.ajaxSettings.async = false; 
		$(function() { 

			
			var indexTag=$("#indexTag").val();
			
			
			//跳转主页显示
			$(".musicMenu").find("a").on("click",function(){
				if($(this).index() == 0){
					window.location.href='${path}/wechatStatic/movieIndex.do?indexTag=1';
					return false;
				}
			});
			
			
			
			
			
			//点击我的跳转我的页面
			$(".myBtn")[0].addEventListener('click',jumpToMy,false);
			function jumpToMy(){
				if (userId == null || userId == '') {
					publicLogin('${basePath}wechatStatic/myMovieIndex.do?indexTag=1');
				}
				else{
					 window.location.href='${basePath}wechatStatic/myMovieIndex.do?indexTag=1';
				}
			}
			
			
			
			
			//跳转活动规则
			$(".ruleBtn").click(function(){
				window.location.href='${basePath}wechatStatic/movieRule.do';
			});
			
			
			
			

			//首页排行点击切换
			$("#musicWeiping").on("click", function() {
				$("#musicWipingDiv").show()
				$("#musicZhengwenDiv").hide()
			})

			$("#musicZhengwen").on("click", function() {
				$("#musicWipingDiv").hide()
				$("#musicZhengwenDiv").show()
			})

		});
		
		
		
		
		//用户的点赞操作
		function like(articleId,div){
			var musicBestNum=$(div);
			var p = musicBestNum.find('p');
			if(musicBestNum.hasClass("musicBestNumOn")){
				return false;
			}
			if (userId == null || userId == '') {
        		//判断登陆
            	publicLogin("${basePath}wechatStatic/musicIndex.do?indexTag=1");
        	}
			if("${sessionScope.endDz}"=="true"){
				dialogAlert('系统提示', '点赞事件已过！');
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
		
		
		
		
		
		
		//获取到用户的头像
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

	<body>
		<div class="musicMain">
		<input type="hidden" name="indexTag" id="indexTag" value="1"/>
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
				<a href="javascript:void(0)">主&nbsp;页</a>
				<a href="javascript:void(0)" class="musicMenuOn">微评排名</a>
			</div>

			<div class="content musicRankingDiv">
				<c:if test="${!empty myBestArticle.articleId }">
					<div class="musicMyRanking clearfix">
						<div class="musicRankNum">
							<div>${myBestArticle.rowno }</div>
						</div>
						<div class="musicInfo">
							<div class="clearfix musicUserImageDiv">
								<div class="musicUserImage">
									<img id="userHeadMy" data="${myBestArticle.userHeadImgUrl }" />
									<script >
											$(function(){
												var userHeadImgUrl=$("#userHeadMy").attr("data");
												$("#userHeadMy").attr("src",getHeadImgUrl(userHeadImgUrl))
											})	
									</script>
								</div>
								<p class="musicUserName">${myBestArticle.userName }</p>
							</div>
							<div class="rankmovie clearfix">
								<img src="${path}/STATIC/wxStatic/image/movieZSM/redmovie.jpg" alt="">
								<span>${myBestArticle.articleTitle }</span>
							</div>
							<p class="musicUserWrite">${myBestArticle.articleText }</p>
						</div>
						<c:choose>
							<c:when test="${myBestArticle.articleType==2 }">
							
							</c:when>
							
							<c:when test="${myBestArticle.isLike==1 }">
								<div class="musicBestNum musicBestNumOn" style="margin-top:26px;">
									<p>${myBestArticle.articleLike }</p>
									
								</div>
							</c:when>
							<c:otherwise>
								<div class="musicBestNum" rankpost onclick="like('${myBestArticle.articleId}',this)">
									<p>${myBestArticle.articleLike }</p>
								</div>
							</c:otherwise>
						</c:choose>
					</div>
				</c:if>
				<div class="musicRankingList">
					<ul>
						<c:forEach items="${rankList }" var="article">
							<li>
								<div class="musicMyRanking clearfix">
									<div class="musicRankNum">
										<div>${article.rowno }</div>
									</div>
									<div class="musicInfo">
										<div class="clearfix musicUserImageDiv">
											<div class="musicUserImage">
												<img id="userHead${article.articleId }" data="${article.userHeadImgUrl }" />
												<script >
													$(function(){	
														var articleId='${article.articleId }'
														var userHeadImgUrl=$("#userHead"+articleId).attr("data");
														$("#userHead"+articleId).attr("src",getHeadImgUrl(userHeadImgUrl))
													});
												</script>
											</div>
											<p class="musicUserName">${ article.userName}</p>
										</div>
										<div class="rankmovie clearfix">
											<img src="${path}/STATIC/wxStatic/image/movieZSM/redmovie.jpg" alt="">
											<span>${ article.articleTitle}</span>
										</div>
										<p class="musicUserWrite">${ article.articleText}</p>
									</div>	
									<c:choose>
							<c:when test="${article.articleType==2 }">		
							</c:when>
							<c:when test="${article.isLike==1 }">
							<div class="musicBestNum musicBestNumOn" >		
								<p>${article.articleLike }</p>
							</div>
							</c:when>
							<c:otherwise>
							<div class="musicBestNum" onclick="like('${article.articleId}',this)">
							<p>${article.articleLike }</p></div>
							</c:otherwise>
						</c:choose>
						</div>
						</li>
						</c:forEach>
					</ul>
				</div>

			</div>
		</div>
	</body>

</html>