<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·电影中的真善美</title>
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
			display: none;
		}
	</style>
	<script type="text/javascript">
	
	 	$.ajaxSettings.async = false;  	//同步执行ajax
		var indexTag = '${indexTag}';	//当前所在标签
		var themeTag = 1;				//默认还是就是选中第一个标签
		var userInfo= null;
		var num=20;
		var firstResult=0;

		
		
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
        	appShareTitle = '恰逢上海国际电影节20周年，看电影，写感受，体味别样人生，增加生命厚度！';
        	appShareDesc = '参与上海国际电影节，观看电影影像，讲述电影故事！';
        	appShareImgUrl = '${basePath}/STATIC/wsStatic/image/movieZSM/shareIcon.jpeg';
        	
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
					title: "恰逢上海国际电影节20周年，看电影，写感受，体味别样人生，增加生命厚度！",
					desc: '参与上海国际电影节，观看电影影像，讲述电影故事！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/movieZSM/shareIcon.jpeg'
				});
				wx.onMenuShareTimeline({
					title: "恰逢上海国际电影节20周年，看电影，写感受，体味别样人生，增加生命厚度！",
					imgUrl: '${basePath}/STATIC/wxStatic/image/movieZSM/shareIcon.jpeg'
				});
				wx.onMenuShareQQ({
					title: "恰逢上海国际电影节20周年，看电影，写感受，体味别样人生，增加生命厚度！",
					desc: '参与上海国际电影节，观看电影影像，讲述电影故事！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/movieZSM/shareIcon.jpeg'
				});
				wx.onMenuShareWeibo({
					title: "恰逢上海国际电影节20周年，看电影，写感受，体味别样人生，增加生命厚度！",
					desc: '参与上海国际电影节，观看电影影像，讲述电影故事！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/movieZSM/shareIcon.jpeg'
				});
				wx.onMenuShareQZone({
					title: "恰逢上海国际电影节20周年，看电影，写感受，体味别样人生，增加生命厚度！",
					desc: '参与上海国际电影节，观看电影影像，讲述电影故事！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/movieZSM/shareIcon.jpeg'
				});
			});
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
			//$('html,body').css('overflow','hidden');
			//登陆后返回首页
		
				//第一次进入shouy
				if(sessionStorage.getItem("showCover") == 1) {
		            $(".musicBg").hide();
		            $(".musicMain").show();
		            $('html,body').css('overflow','visible');
		        } else {
		            // 引导页上滑
		             $('html,body').css('overflow','hidden');
		        	 $(".musicBg").on("touchmove",function(){
		          	 $(".musicMain").show();
		          	 $(".musicBg").animate({
		             "top":"-1500px",
		             "opacity":"0"
		          }, function(){
		            $('html,body').css('overflow','visible');
		          })
		          window.sessionStorage.setItem("showCover", '1');
		        })
		     }
		
			
			
			if(!indexTag)
				indexTag=1;

			
			
			
			
			
			
			//判断进来的是微评还是征文
			if(indexTag==1){
				//微评选项卡被选中，去除其他的选项卡
				$(".musicMenu a:eq(0)").addClass("musicMenuOn").siblings().removeClass("musicMenuOnTwo");
				//设置主题的背景颜色，红色
				$(".movietable").css("background","#ff5458");
				//设置主题内部样式
				$(".moviemenu").find("a").css({"border-color":"#ff5458","color":"#ffbaba"});
			}else{
				$(".musicMenu a:eq(1)").addClass("musicMenuOnTwo").siblings().removeClass("musicMenuOn");
				$(".movietable").css("background","#ffb558");
				$(".moviemenu").find("a").css({"border-color":"#ffb558","color":"#faeadb"});
			}
			//每次微评/征文切换时，子标签中主题默认的选中第一个
			$(".moviemenu a:first").addClass("moviechoose").siblings().removeClass("moviechoose");
			//查询数据
			loadData();
			//监听微评和征文的切换动作
			$(".musicMenu").find("a").on("click",function(){
				//选中的是第一个标签：微评
				if($(this).index() == 0){
					$(this).addClass("musicMenuOn").siblings().removeClass("musicMenuOnTwo");
					$(".movietable").css("background","#ff5458");
					$(".moviemenu").find("a").css({"border-color":"#ff5458","color":"#ffbaba"});
					indexTag=$(this).attr("indexTag");
					//默认主题标签第一个被选中
					$(".moviemenu a:first").addClass("moviechoose").siblings().removeClass("moviechoose");
					//清空主体内容部分
					$(".musicFontList").html('<ul></ul>') 
					//添加加载图形
					$(".musicFontList").append('<div id="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>');
					firstResult=0;
					themeTag=1;
				}else{
					//选中的是第二个标签：征文
					$(this).addClass("musicMenuOnTwo").siblings().removeClass("musicMenuOn");
					$(".movietable").css("background","#ffb558");
					$(".moviemenu").find("a").css({"border-color":"#ffb558","color":"#faeadb"});
					
					$(".moviemenu a:first").addClass("moviechoose").siblings().removeClass("moviechoose");
					indexTag=$(this).attr("indexTag");
					$(".musicFontList").html('<ul></ul>') 
					$(".musicFontList").append('<div id="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>');
					firstResult=0;
					themeTag=1;
				}
				loadData();
			});
			
			

			
			
			
			//主题标签按钮点击切换时的监听事件
			$(".moviemenu").find("a").on("click", function() {
				//给选中的标签价样式
				$(this).addClass("moviechoose").siblings().removeClass("moviechoose");
				//清空主体内容部分
				$(".musicFontList").html('<ul></ul>') 
				$(".musicFontList").append('<div id="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>');
				firstResult=0;
				//给主题全局变量赋值
				themeTag=$(this).attr("themeTag");
				//加数据
				loadData();
			});
		
			
			
			
			
			
			//点击填写事件按钮
			$(".musicJoinBtn").on("click",function(){
				if (userId == null || userId == '') {
	        		//判断登陆
	            	publicLogin("${basePath}wechatStatic/movieIndex.do?indexTag="+indexTag);
	        	}
				else{
					//将写的弹出标签显示出来
					$(".musicWrite").show()
					$(".musicWrite").on("touchmove",function(){
						return false;
					})
				}
			});
			
			
			
			
			
			
			//点击【我的】按钮，跳转我的页面显示
			$(".myBtn")[0].addEventListener('click',jumpToMy,false);
			//跳转到我的页面
			function jumpToMy(){
				//判断用户是否登录，如没有则跳转到登录页面
				if (userId == null || userId == '') {
					publicLogin("${basePath}wechatStatic/myMovieIndex.do?indexTag="+indexTag);
				}
				else{
					 //跳转到那我的页面【myMovieIndex.jsp】，将当前的微评还是征文的选项带去
					 window.location.href='${basePath}wechatStatic/myMovieIndex.do?indexTag='+indexTag;
				}
			}
		
			
			
		
			
			
			//跳转查看排名，跳转到【rank.jsp】页面
			$(".rankingBtn").on("click",function(e){
				 window.location.href='${basePath}wechatStatic/movieRanking.do?userId='+userId
			});
			
			
			
			
			
			//跳转活动规则
			$(".ruleBtn").click(function(){
				 window.location.href='${basePath}wechatStatic/movieRule.do'
			});
			
			
			
			//点击关闭弹窗				
			$(".musicWrite").on("click",function(e){
				e.stopPropagation();
				$(this).hide()
			});
			
			
			
			//点击写微评监听事件	
			$("#writeWeiping").on("click",function(e){
				e.stopPropagation();
				window.location.href = '${path}/wechatStatic/createMoviessayArticle.do?articleType=1&userId='+userId;
			});
			
			
			//点击写征文监听事件
			$("#writeZhengwen").on("click",function(e){
				e.stopPropagation();
				window.location.href = '${path}/wechatStatic/createMoviessayArticle.do?articleType=2&userId='+userId;
			});
			

				
			
			/* $(".musicBg").on("click touchmove",function(){
				$(".musicMain").show()
				$(".musicBg").animate({
					"top":"-1500px",
					"opacity":"0"
				}, function(){
					$('html,body').css('overflow','visible');
				})
			}); */
			/* var urlSess = window.sessionStorage.getItem("touchName");//读取
			if(indexTag == 1 || indexTag == 2 || urlSess == '1') {
				$(".musicBg").hide();
				$(".musicMain").show()
			} else {
				$('html,body').css('overflow','hidden');
				$(".musicBg").on("touchmove",function(){
					$(".musicMain").show()
					$(".musicBg").animate({
						"top":"-1500px",
						"opacity":"0"
					}, function(){
						$('html,body').css('overflow','visible');
					})
					window.sessionStorage.setItem("touchName", '1'); //存入
				})
			} */

			
			
			
			
			
			
			
			//收藏
			$(".musicKeep").on("click",function(e){
				e.stopPropagation();
				$('.div-share').show()
				$("body,html").addClass("bg-notouch")
			});
			
			//分享
			$(".musicShare").click(function(e) {
				e.stopPropagation();
				if (!is_weixin()&&!(/wenhuayun/.test(ua))) {
					dialogAlert('系统提示', '请用微信浏览器打开分享！');
				}else{
					$("html,body").addClass("bg-notouch");
					$(".background-fx").css("display", "block")
				}
			});
			
			
			//片单
			$('.singlecard a:eq(0)').on('click',function(event){
				window.location.href='http://hs.hb.wenhuayun.cn/information/preInfo.do?informationId=2280d976a13343ebbd48578e58614f60&from=singlemessage&isappinstalled=0'
				event.stopPropagation();
			});
			
			
			//咨询
			$('.singlecard a:eq(1)').on('click',function(event){
				window.location.href='http://hs.hb.wenhuayun.cn/wechatFunction/contestQuiz.do?topicId=0933bfca389245ff8ba9d80e430ff510'
				event.stopPropagation();
			});
			
			
			
					
					
			//分享
			$('.musicToIndex').on('click',function(event){
				toWhyIndex();
				event.stopPropagation();
			});
			
			
					
			$(".background-fx").click(function() {
				$("html,body").removeClass("bg-notouch");
				$(".background-fx").css("display", "none")
			});
		});
		
		
		
		//加载数据
		function loadData(){		
			var data ={
					firstResult:firstResult,
					rows:num,
					loginUser:userId,
					articleType:indexTag,
					themeType:themeTag
				}
			var sum=$(".musicFontList li").length;
			$.post("${path}/wechatStatic/queryMoviessayArticleList.do",data, function (data) {
				if(data.length<num){
					$("#loadingDiv").remove();
				}
				if(data.length==0&&sum==0&&indexTag==2){
					/* if(themeTag==1){
						if($(".musicFontList").find("p").length==0){
								
						}
					} */
					$(".musicFontList").html("<p style='font-size: 24px;text-align: center;color: #666; margin-top: 100px;'>快来做话题#电影中的真善美#第一个征文投稿人吧~</p>");
				}else if (data.length==0&&sum==0&&indexTag==2){
					/* if(themeTag==2){
						if($(".musicFontList").find("p").length==0){
							
						}	
					} */
					$(".musicFontList").html("<p style='font-size: 24px;text-align: center;color: #666; margin-top: 100px;'>快来做话题#我与我的电影节#第一个征文投稿人吧~</p>");
				}
				$.each(data, function (i, dom) { 
					var likeClass='musicBestNum';
					var likeFun=''
					if(dom.isLike==1){
						likeClass='musicBestNum musicBestNumOn';
					}
					else 
						likeFun=' onclick="like(\''+dom.articleId+'\',this)"'
					<!--微评样式-->
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
						
						var musicHtml='<li articleId="'+dom.articleId+'" >'+
						'<div class="musicList">'+
						'<div class="movieName clearfix">'+
							'<img src="${path}/STATIC/wxStatic/image/movieZSM/ymovie.jpg" alt="">'+
							'<span class="zwname">'+dom.movieName+'</span>'+
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
				musicBestNum.addClass("musicBestNumOn")
				
				var num=parseInt(musicBestNum.html())+1;
				
				musicBestNum.html(num)
			}
		}
		
		
		
		var loadFlag = false;
		window.addEventListener('scroll', function() {
			var scrollTop = $(document).scrollTop();
    		var pageHeight = $(document).height();
            var winHeight = $(window).height();
            console.log(scrollTop);console.log(pageHeight);console.log(winHeight);
            if (!loadFlag && (scrollTop == (pageHeight - winHeight))) {
            	console.log('触发方法');
           		loadFlag=true;
 				firstResult += 20;
         		loadData();
         		loadFlag = false;
            }
		},false);
		
		
	 	//滑屏分页
  /*       $(window).on("scroll", function () {
        		debugger
        		//滚上去的高度
	            var scrollTop = $(document).scrollTop();
	            //当前文档页的高度
        		var pageHeight = $(document).height();
	            //屏幕的高度
	            var winHeight = $(window).height();
	            if (scrollTop >= (pageHeight - winHeight-20)) {
	            	if(!loadFlag){
	            		loadFlag=true;
      					firstResult += 20;
              			loadData();
              			loadFlag=false;
	            	}
	            }
        }); */
		
		
		
		
        function dialogSaveDraft(title, content, fn){
		    var d = dialog({
		        width:400,
		        title:title,
		        content:content,
		        fixed: true,
		        okValue: '确 定',
		        ok: function () {
		            if(fn)  fn();
		        }
		    });
		    d.showModal();
		}
		
	</script>
	</head>
	<body>
		<div style="display: none;"><img src="${basePath}/STATIC/wxStatic/image/movieZSM/shareIcon.jpeg"/></div>
		<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
			<img src="${path}/STATIC/wxStatic/image/fx-bg.png" style="width: 100%;height: 100%;" />
		</div>
		<div class="div-share">
			<div class="share-bg"></div>
			<div class="share">
				<img src="${path}/STATIC/wechat/image/wx-er2.png" />
				<p style="margin-top: 310px;">扫一扫&nbsp;关注文化云</p>
				<p>更多精彩活动、场馆等你发现</p>
				<button type="button" onclick="$('.div-share').hide();$('body,html').removeClass('bg-notouch')">关闭</button>
			</div>
		</div>
		<!--首页封面-->
		<div class="musicBg">
			<img src="${path}/STATIC/wxStatic/image/movieZSM/indexBg.jpg?20170609" alt="" class="musicimgBg">
			<div class="musicToIndex">首页</div>
			<div class="musicKeep">关注</div>
			<div class="musicShare">分享</div>
			<div class="singlecard clearfix">
				<a href="javascript:void(0)"><img src="${path}/STATIC/wxStatic/image/movieZSM/piandan.png" alt=""></a>
				<a href="javascript:void(0)"><img src="${path}/STATIC/wxStatic/image/movieZSM/zixun.png" alt=""></a>
			</div>
			<div class="download">
				<div>
					<img src="${path}/STATIC/wxStatic/image/movieZSM/next.png" alt="">
				</div>
			</div>
		</div>
		
		

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
			<div class="musicMenu clearfix">
				<a href="javascript:void(0)" class="musicMenuOn" indexTag="1">微&nbsp;评</a>
				<a href="javascript:void(0)" indexTag ="2">征&nbsp;文</a>
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