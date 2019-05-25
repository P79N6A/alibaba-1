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
			display: none;
		}
		.musicMain .content .musicListMenu .musicBestNum {padding-left:10px;}
	</style>
<script type="text/javascript">
$.ajaxSettings.async = false; 	//同步执行ajax
		var indexTag = '${indexTag}';	//当前所在标签
		
		var userInfo= null;
	
		var num=20;
		var firstResult=0;
		
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
        	appShareTitle = '听音乐，写感受；品味音乐之韵，网罗周边之美！';
        	appShareDesc = '参与上海之春国际音乐节，让美妙在心里不断流淌。';
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
					title: "听音乐，写感受；品味音乐之韵，网罗周边之美！",
					desc: '参与上海之春国际音乐节，让美妙在心里不断流淌。',
					imgUrl: '${basePath}/STATIC/wechat/image/musicZSM/shareIcon.jpg'
				});
				wx.onMenuShareTimeline({
					title: "听音乐，写感受；品味音乐之韵，网罗周边之美！",
					imgUrl: '${basePath}/STATIC/wechat/image/musicZSM/shareIcon.jpg'
				});
				wx.onMenuShareQQ({
					title: "听音乐，写感受；品味音乐之韵，网罗周边之美！",
					desc: '参与上海之春国际音乐节，让美妙在心里不断流淌。',
					imgUrl: '${basePath}/STATIC/wechat/image/musicZSM/shareIcon.jpg'
				});
				wx.onMenuShareWeibo({
					title: "听音乐，写感受；品味音乐之韵，网罗周边之美！",
					desc: '参与上海之春国际音乐节，让美妙在心里不断流淌。',
					imgUrl: '${basePath}/STATIC/wechat/image/musicZSM/shareIcon.jpg'
				});
				wx.onMenuShareQZone({
					title: "听音乐，写感受；品味音乐之韵，网罗周边之美！",
					desc: '参与上海之春国际音乐节，让美妙在心里不断流淌。',
					imgUrl: '${basePath}/STATIC/wechat/image/musicZSM/shareIcon.jpg'
				});
			});
		}

		$(function() {
			$('html,body').css('overflow','hidden');
			if(indexTag){
				$(".musicBg").hide();
				$(".musicMain").show();
				$('html,body').css('overflow','visible');
			}
			if(!indexTag)
				indexTag=1;
				
			//进页面时判断哪个标签被选中
			//等于2时，征文被选中
			if(indexTag == 2) {
				$('.musicMenuBtn').removeClass("musicMenuOn");
				$(".musicZhengwen").find(".musicMenuBtn").addClass("musicMenuOn");
			}
			
			loadData();

			//菜单标签按钮点击事件
			$(".musicMenuBtn").on("click", function() {
				$('.musicMenuBtn').removeClass("musicMenuOn");
				$(this).addClass("musicMenuOn")
				
				indexTag=$(this).attr("indexTag");
				
				$(".musicFontList").html('<ul></ul>') 
				
				$(".musicFontList").append('<div id="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>');
				
				
				firstResult=0;
				loadData();
			})

			//即可参与点击事件
			$(".musicJoinBtn").on("click",function(){
				
				if (userId == null || userId == '') {
	        		//判断登陆
	            	publicLogin("${basePath}wechatStatic/musicIndex.do?indexTag="+indexTag);
	        	}
				else{
					
					$(".musicWrite").show()
					$(".musicWrite").on("touchmove",function(){
						return false;
					})
				}
				
			})
			
			//点击关闭弹窗				
			$(".musicWrite").on("click",function(e){
				e.stopPropagation();
				$(this).hide()
			})
			
			$("#writeWeiping").on("click",function(e){
				e.stopPropagation();
				console.log(1)
				
				window.location.href = '${path}/wechatStatic/createMusicessayArticle.do?articleType=1&userId='+userId;
			})
			
			$("#writeZhengwen").on("click",function(e){
				e.stopPropagation();
				console.log(2)
				
				window.location.href = '${path}/wechatStatic/createMusicessayArticle.do?articleType=2&userId='+userId;
			})
			
			//封面分享收藏
			$(".musicKeep").on("click",function(e){
				e.stopPropagation();
				$('.div-share').show()
				$("body,html").addClass("bg-notouch")
			})
			
			$(".musicShare").click(function(e) {
				e.stopPropagation();
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
			 	
			//封面
			
			$(".musicBg").on("click touchmove",function(){
				$(".musicMain").show()
				$(".musicBg").animate({
					"top":"-1500px",
					"opacity":"0"
				},function() {$('html,body').css('overflow','visible');})
			})
			
			
			//封面分享收藏
			$(".musicKeep").on("click",function(e){
				e.stopPropagation();
			})
			
			$(".musicShare").on("click",function(e){
				e.stopPropagation();
			})

			$(".musicToIndex").on("click",function(e){
				e.stopPropagation();
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
			
		});
		
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
		
		function articleDetail(articleId){
			
			 window.location.href='${basePath}wechatStatic/musicessayArticleDetail.do?articleId='+articleId+"&loginUser="+userId
			
		}
		
		function like(articleId,div){
			
			var musicBestNum=$(div)
			
			if(musicBestNum.hasClass("musicBestNumOn")){
				
				return false;
			}
			
			dialogAlert('系统提示', '活动已结束！');
	        return false;
				
		}
		
		function loadData(){
			
			var data ={
					firstResult:firstResult,
					rows:num,
					loginUser:userId,
					articleType:indexTag
				}
			
			var sum=$(".musicFontList li").length;
			
			$.post("${path}/wechatStatic/queryMusicessayArticleList.do",data, function (data) {
				
				if(data.length<num){
					
					$("#loadingDiv").remove();
				}
				
				if(data.length==0&&sum==0&&indexTag==2){
					$(".musicFontList").append("<p style='font-size: 24px;text-align: center;color: #666; margin-top: 100px;'>快来做第一个征文投稿人吧~</p>");
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
		
		//滑屏分页
        $(window).on("scroll", function () {
            var scrollTop = $(document).scrollTop();
            var pageHeight = $(document).height();
            var winHeight = $(window).height();
            if (scrollTop >= (pageHeight - winHeight - 20)) {
           		setTimeout(function () { 
           			
           				firstResult += 20;
                   	
                   		loadData();
           			
           		},800);
            }
        });
	</script>
</head>
	<body>
		<div style="display: none;"><img src="${basePath}/STATIC/wechat/image/musicZSM/shareIcon.jpg"/></div>
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
			<div class="musicToIndex" onclick="toWhyIndex();">首页</div>
			<div class="musicKeep">关注</div>
			<div class="musicShare">分享</div>
		</div>

		<div class="musicMain">
			<!--头图-->
			<div class="musicBanner">
				<img src="${path}/STATIC/wechat/image/musicZSM/banner.jpg" />
				<div class="myBtn">
					<img src="${path}/STATIC/wechat/image/musicZSM/myBtn.png" />
				</div>
				 <div class="rankingBtn" >
					<img src="${path}/STATIC/wechat/image/musicZSM/rankingBtn.png" />
				</div>
				<div class="ruleBtn">
					<img src="${path}/STATIC/wechat/image/musicZSM/ruleBtn.png" />
				</div> 
			</div>

			<!--菜单-->
			<div class="musicMenu clearfix">
				<div class="musicWeiping musicRightLine">
					<div class="musicMenuBtn musicMenuOn" indexTag="1">微&emsp;评</div>
				</div>
				<div class="musicZhengwen">
					<div class="musicMenuBtn" indexTag="2">征&emsp;文</div>
				</div>
			</div>

			<div class="content musicFontList">
				<ul>
					
				</ul>
				<div id="loadingDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
			</div>
		</div>
		
		<div class="musicWrite">
			<div class="clearfix" style="width: 300px;position: absolute;left: 0;right: 0;bottom: 300px;margin: auto;">
				<div style="float: left;" id="writeWeiping">
					<div style="height: 110px;">
						<img src="${path}/STATIC/wechat/image/musicZSM/writeWeiping.png" />
					</div>
					<p style="text-align: center;color: #262626;font-size: 26px;margin-top: 10px;">写微评</p>
				</div>
				<div style="float: right;" id="writeZhengwen">
					<div style="height: 110px;">
						<img src="${path}/STATIC/wechat/image/musicZSM/writeZhengwen.png" />
					</div>
					<p style="text-align: center;color: #262626;font-size: 26px;margin-top: 10px;">写征文</p>
				</div>
			</div>
		</div>
	</body>
</html>