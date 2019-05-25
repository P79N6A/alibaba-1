<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·音乐中的真善美</title>
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
		.musicBestNum {background: url(${path}/STATIC/wechat/image/musicZSM/best.png) no-repeat top center;margin-top: 30px;}
		.musicBestNum.musicBestNumOn {background-image: url(${path}/STATIC/wechat/image/musicZSM/bestOn.png)}
		.musicBestNum p {margin-top: 41px;}
	</style>
	<script>
		$(function() {
			
			var indexTag=$("#indexTag").val();

			//菜单标签按钮点击事件
			$(".musicMenuBtn").on("click", function() {
				
				var indexTag=$(this).attr("indexTag");
				
				if(indexTag==1){
					
					window.location.href = '${path}/wechatStatic/musicIndex.do?indexTag=1';
				}
				
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

		<body>
		<div class="musicMain">
			<input type="hidden" name="indexTag" id="indexTag" value="1"/>
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
					<div class="musicWeiping musicRightLine" onclick="window.location.href='${basePath}wechatStatic/musicIndex.do?indexTag=1'">
						<div class="musicMenuBtn" >主&emsp;页</div>
					</div>
					<div class="musicZhengwen">
						<div class="musicMenuBtn musicMenuOn">微评排名</div>
					</div>
				</div>
				
				<div class="content musicRankingDiv">
				
				<c:if test="${!empty myBestArticle }">
				
				
				<div class="musicMyRanking clearfix">
					<div class="musicRankNum">
						<div>${ myBestArticle.rowno}</div>
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
							<p class="musicUserName">${myBestArticle.articleTitle }</p>
						</div>
						<p class="musicUserWrite">${myBestArticle.articleText }</p>
					</div>
					<c:choose>
							<c:when test="${myBestArticle.articleType==2 }">
							
							</c:when>
							<c:when test="${myBestArticle.isLike==1 }">
							<div class="musicBestNum musicBestNumOn" >
							
								<p>${myBestArticle.articleLike }</p>
							
							</div>
							</c:when>
							<c:otherwise>
							<div class="musicBestNum" onclick="like('${myBestArticle.articleId}',this)">
							
							<p>${myBestArticle.articleLike }</p></div>
							
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
											})
												
											</script>
										</div>
										<p class="musicUserName">${ article.articleTitle}</p>
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