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
		.musicMain .content .musicListMenu .musicBestNum {padding-left:10px;}
	</style>
	</head>
	<script>
	
	    $.ajaxSettings.async = false; 	//同步执行ajax
		
	    var indexTag = '${indexTag}';	//当前所在标签
	    var themeTag = 1;				//默认是选中第一个标签
		var userInfo= null;
		if(!indexTag)
			indexTag=1;
		
		var num=20;
		var firstResult=0;

		
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
        	appShareTitle = '听音乐，写感受；品味音乐之韵，网罗周边之美！';
        	appShareDesc = '参与上海之春国际音乐节，让美妙在心里不断流淌。';
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
					title: "听音乐，写感受；品味音乐之韵，网罗周边之美！",
					desc: '参与上海之春国际音乐节，让美妙在心里不断流淌。',
					imgUrl: '${basePath}/STATIC/wxStatic/image/movieZSM/shareIcon.jpeg'
				});
				wx.onMenuShareTimeline({
					title: "听音乐，写感受；品味音乐之韵，网罗周边之美！",
					imgUrl: '${basePath}/STATIC/wxStatic/image/movieZSM/shareIcon.jpeg'
				});
				wx.onMenuShareQQ({
					title: "听音乐，写感受；品味音乐之韵，网罗周边之美！",
					desc: '参与上海之春国际音乐节，让美妙在心里不断流淌。',
					imgUrl: '${basePath}/STATIC/wxStatic/image/movieZSM/shareIcon.jpeg'
				});
				wx.onMenuShareWeibo({
					title: "听音乐，写感受；品味音乐之韵，网罗周边之美！",
					desc: '参与上海之春国际音乐节，让美妙在心里不断流淌。',
					imgUrl: '${basePath}/STATIC/wsStatic/image/movieZSM/shareIcon.jpeg'
				});
				wx.onMenuShareQZone({
					title: "听音乐，写感受；品味音乐之韵，网罗周边之美！",
					desc: '参与上海之春国际音乐节，让美妙在心里不断流淌。',
					imgUrl: '${basePath}/STATIC/wechat/image/movieZSM/shareIcon.jpeg'
				});
			});
		}
		
		
		
		//对文本的换行处理
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
		
		
		//得到用户的头像
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
		
		
		
		
		$(function() {
			
			if(indexTag==1){
				//选中的是微评选项，给微评加样式
				$(".musicMenu a:eq(1)").addClass("musicMenuOn").siblings().removeClass("musicMenuOnTwo");
				//给下面的主题标签加背景样式
				$(".movietable").css("background","#ff5458");
				//加边框
				$(".moviemenu").find("a").css({"border-color":"#ff5458","color":"#ffbaba"});
			}else{
				$(".musicMenu a:eq(2)").addClass("musicMenuOnTwo").siblings().removeClass("musicMenuOn");
				$(".movietable").css("background","#ffb558");
				$(".moviemenu").find("a").css({"border-color":"#ffb558","color":"#faeadb"});
			}
			
			//默认选中第一个主题标签
			$(".moviemenu a:first").addClass("moviechoose").siblings().removeClass("moviechoose");
			//加载数据
			loadData();
			
			
			

			
			
			//微评，征文，主页 三个标签间的切换监听操作
			$(".musicMenu").find("a").on("click",function(){
				if($(this).index() == 0){
					//主页
					window.location.href='${path}/wechatStatic/movieIndex.do?indexTag=1';
					return false;
				}else if($(this).index() == 1){
					//微评
					$(this).addClass("musicMenuOn").siblings().removeClass("musicMenuOnTwo");
					$(".movietable").css("background","#ff5458");
					$(".moviemenu").find("a").css({"border-color":"#ff5458","color":"#ffbaba"});
					$(".moviemenu a:first").addClass("moviechoose").siblings().removeClass("moviechoose");
					$(".musicFontList").html('<ul></ul>') 
					$(".musicFontList").append('<div id="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>');
					firstResult=0;
					indexTag = $(this).attr('indexTag');
					themeTag=1;
					
				}else{
					//征文
					$(this).addClass("musicMenuOnTwo").siblings().removeClass("musicMenuOn");
					$(".movietable").css("background","#ffb558");
					$(".moviemenu").find("a").css({"border-color":"#ffb558","color":"#faeadb"});
					$(".moviemenu a:first").addClass("moviechoose").siblings().removeClass("moviechoose");
					$(".musicFontList").html('<ul></ul>') 
					$(".musicFontList").append('<div id="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>');
					firstResult=0;
					indexTag = $(this).attr('indexTag');
					themeTag=1;
				}
				loadData();
			});
			
			
			
			
			//菜单内部标签按钮点击事件
			$(".moviemenu").find("a").on("click", function() {
				$(this).addClass("moviechoose").siblings().removeClass("moviechoose");
				$(".musicFontList").html('<ul></ul>'); 
				$(".musicFontList ul").html('<div id="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>');
				//获取到主题的编码
				themeTag=$(this).attr("themeTag");
				firstResult=0;
				loadData();
			});
			
			
			

			
			//点击填写事件按钮
			$(".musicJoinBtn").on("click",function(){
				if (userId == null || userId == '') {
	            	publicLogin("${basePath}wechatStatic/movieIndex.do?indexTag="+indexTag);
	        	}
				else{
					$(".musicWrite").show();
					$(".musicWrite").on("touchmove",function(){
						return false;
					})
				}
			});
			
			
			
			
			
			//跳转查看排名
			$(".rankingBtn").on("click",function(e){
				 window.location.href='${basePath}wechatStatic/movieRanking.do?userId='+userId
			});
			
			//跳转活动规则
			$(".ruleBtn").click(function(){
				 window.location.href='${basePath}wechatStatic/movieRule.do';
			});
			
			//点击关闭弹窗				
			$(".musicWrite").on("click",function(e){
				e.stopPropagation();
				$(this).hide()
			});
			
			
			
			//点击写微评
			$("#writeWeiping").on("click",function(e){
				e.stopPropagation();
				console.log(1);
				window.location.href = '${path}/wechatStatic/createMoviessayArticle.do?articleType=1&userId='+userId;
			});
			
			
			//点击写征文
			$("#writeZhengwen").on("click",function(e){
				e.stopPropagation();
				console.log(2);
				window.location.href = '${path}/wechatStatic/createMoviessayArticle.do?articleType=2&userId='+userId;
			});
		});
		
		
		
		//点击详情按钮
		function articleDetail(articleId){
			if (userId == null || userId == '') {
        		//判断登陆
            	publicLogin("${basePath}wechatStatic/movieIndex.do?indexTag="+indexTag);
        	}
			else{
			 	window.location.href='${basePath}wechatStatic/moviessayArticleDetail.do?articleId='+articleId+"&loginUser="+userId;
			}
		}
		
		
		function loadData(){
			var data ={
					firstResult:firstResult,
					rows:num,
					userId:userId,
					loginUser:userId,
					articleType:indexTag,
					themeType:themeTag
				}
			
			var sum=$(".musicFontList li").length;
			$.post("${path}/wechatStatic/queryMoviessayArticleList.do",data, function (data) {		
				if(data.length<num){
					$("#loadingDiv").remove();
				} 
				if(data.length==0&&sum==0){
					if(indexTag==1 && themeTag==1)
						$(".musicFontList").append("<p style='font-size: 24px;text-align: center;color: #666; margin-top: 100px;'>您还没有发布话题#电影中的真善美#微评作品，快去写微评吧！</p>");
					else if(indexTag==1 && themeTag==2)
						$(".musicFontList").append("<p style='font-size: 24px;text-align: center;color: #666; margin-top: 100px;'>您还没有发布话题#我与我的电影节#微评作品，快去写微评吧！</p>");
					else if(indexTag==2 && themeTag ==1)
						$(".musicFontList").append("<p style='font-size: 24px;text-align: center;color: #666; margin-top: 100px;'>您还没有投稿话题#电影中的真善美#征文作品，快去投稿吧！</p>");
					else if(indexTag==2 && themeTag ==2)
						$(".musicFontList").append("<p style='font-size: 24px;text-align: center;color: #666; margin-top: 100px;'>您还没有投稿话题#我与我的电影节#征文作品，快去投稿吧！</p>");
				}
				$.each(data, function (i, dom) { 
					var likeClass='musicBestNum';
					var likeFun=''

						if(dom.isLike==1){
							likeClass='musicBestNum musicBestNumOn';
						}
						else 
							likeFun=' onclick="like(\''+dom.articleId+'\',this)"'	
					
					if(indexTag==1){
						
						var musicHtml='<li articleId="'+dom.articleId+'" >'+
							'<div class="musicList">'+
							'<div class="movieName clearfix">'+
								'<img src="${path}/STATIC/wxStatic/image/movieZSM/redmovie.jpg" alt="">'+
								'<span>'+dom.movieName+'</span>'+
							'</div>'+
							'<p class="musicListFont" onclick="articleDetail(\''+dom.articleId+'\')"><span>'+dom.articleTitle+'</span>'+TransferString(dom.articleText)+'</p>'+
						'<div class="musicListMenu clearfix">'+
							'<div class="musicUserInfo clearfix">'+
								'<div class="musicUserImg">'+
									'<img src="'+getHeadImgUrl(dom.userHeadImgUrl)+'" />'+
								'</div>'+
								'<p>'+dom.userName+'</p>'+
							'</div>'+
							'<div class="musicGetBtn" onclick="articleDetail(\''+dom.articleId+'\')">去拉票</div>'+
							'<div class="'+likeClass+'"'+likeFun+'>'+dom.articleLike+'</div>'+
						'</div>'+
					'</div>'+
				'</li>'
				
					$(".musicFontList ul").append(musicHtml);
				
						<!--征文样式-->
					}else if (indexTag==2){
						
						
						var musicHtml='<li articleId="'+dom.articleId+'">'+
						'<div class="musicList">'+
							'<div class="movieName clearfix">'+
							'<img src="${path}/STATIC/wxStatic/image/movieZSM/ymovie.jpg" alt="">'+
							'<span>'+dom.movieName+'</span>'+
						'</div>'+
						'<p class="musicListFont"  onclick="articleDetail(\''+dom.articleId+'\')"><span>'+dom.articleTitle+'</span>'+TransferString((dom.articleText.length>80?(dom.articleText.substring(0,80)+'...'):dom.articleText))+'</p>'+
							'<div class="musicListMenu clearfix">'+
								'<div class="musicUserInfo clearfix">'+
									'<div class="musicUserImg">'+
									'<img src="'+getHeadImgUrl(dom.userHeadImgUrl)+'" />'+
									'</div>'+
									'<p>'+dom.userName+'</p>'+
								'</div>'+
								'<div class="musicGetBtn musicGetBtnOn" onclick="articleDetail(\''+dom.articleId+'\')">全文</div>'+
							'</div>'+
						'</div>'+
					'</li>'
						
						$(".musicFontList ul").append(musicHtml);
					}
				});
				
			},"json");
		}
		
		
		
		
		/* 点赞事件 */
		function like(articleId,div){
			var musicBestNum=$(div)
			if(musicBestNum.hasClass("musicBestNumOn")){
				return false;
			}
			else if (userId == null || userId == '') {
        		//判断登陆
            	publicLogin("${basePath}wechatStatic/movieIndex.do?indexTag="+indexTag);
        	}
			else if("${sessionScope.endDz}"=="true"){
				dialogAlert('系统提示', '活动已结束！');
				return false;
			}
			else{
				$.post("${path}/wechatStatic/likeMoviessayArticle.do",{articleId:articleId,userId:userId}, function (data) {
						
				},'json');
				musicBestNum.addClass("musicBestNumOn");
				var num=parseInt(musicBestNum.html())+1;
				musicBestNum.html(num);
			}
		}
		
	</script>

	<body>	
		<div style="display: none;"><img src="${basePath}/STATIC/wxStatic/image/movieZSM/shareIcon.jpeg"/></div>
		<div class="musicMain">
			<!--头图-->
			<div class="musicBanner">
				<!-- 回到文化云 -->
				<a href="javascript:void(0)" class="gobackculture" onclick="toWhyIndex();">
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
			<div class="musicMenu mymusicMenu clearfix">
				<a href="javascript:void(0)" indexTag="0"><i>主&nbsp;页</i></a>
				<a href="javascript:void(0)" class="musicMenuOn" indexTag="1"><i>我&nbsp;的&nbsp;微&nbsp;评</i></a>
				<a href="javascript:void(0)" indexTag="2"><i>我&nbsp;的&nbsp;征&nbsp;文</i></a>
			</div>
			<div class="movietable">
				<div class="moviemenu clearfix">
					<a href="javascript:void(0)" class="moviechoose" themeTag="1">#电影中的真善美#</a>
					<a href="javascript:void(0)" themeTag="2">#我与我的电影节#</a>
				</div>
			</div>
			<div class="content musicFontList">
				<ul>
				
				</ul>
				
				<div id="loadingDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
				
			</div>
		</div>
		
		<c:choose>
            	<c:when test="${sessionScope.endTg==true }">
            		
            	</c:when>
           		<c:otherwise>
            		<div class="musicJoinBtn">
						<img src="${path}/STATIC/wxStatic/image/movieZSM/joinBtn.png" />
					</div>
            	</c:otherwise>
		</c:choose>
		
		<div class="musicWrite">
			<div class="clearfix" style="width: 300px;position: absolute;left: 0;right: 0;bottom: 300px;margin: auto;">
				<div style="float: left;" id="writeWeiping">
					<div style="height: 110px;">
						<img src="${path}/STATIC/wxStatic/image/movieZSM/writeWeiping.png" />
					</div>
					<p style="text-align: center;color: #262626;font-size: 26px;margin-top: 10px;">写微评</p>
				</div>
				<div style="float: right;" id="writeZhengwen">
					<div style="height: 110px;">
						<img src="${path}/STATIC/wxStatic/image/movieZSM/writeZhengwen.png" />
					</div>
					<p style="text-align: center;color: #262626;font-size: 26px;margin-top: 10px;">写征文</p>
				</div>
			</div>
		</div>
	</body>

</html>