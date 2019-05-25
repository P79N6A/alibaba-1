<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>佛山文化云·上海当代戏剧节</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		var noControl = '${noControl}'; //1：不可操作
		var tab = '${tab}';
	
		if (userId == null || userId == '') {
    		//判断登陆
        	publicLogin("${basePath}wechatStatic/dramaFestival.do");
    	}
		
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
        	appShareTitle = '上海当代戏剧节·看完好戏不来说一说？';
        	appShareDesc = '上海艺术节之艺术天空特别策划，全天12小时演出不间断，快来和我一起共享艺术盛宴';
        	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/dramaImg/shareIcon.jpg';
        	appShareLink = '${basePath}/wechatStatic/dramaFestival.do';
        	
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
					title: "佛山文化云·上海当代戏剧节·看完好戏不来说一说？",
					desc: '观戏剧，写剧评，分享属于你的“戏如人生”，赢取戏剧节限量礼品。',
					link: '${basePath}wechatStatic/dramaFestival.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/dramaImg/shareIcon.jpg'
				});
				wx.onMenuShareTimeline({
					title: "佛山文化云·上海当代戏剧节·看完好戏不来说一说？",
					imgUrl: '${basePath}/STATIC/wxStatic/image/dramaImg/shareIcon.jpg',
					link: '${basePath}wechatStatic/dramaFestival.do'
				});
				wx.onMenuShareQQ({
					title: "佛山文化云·上海当代戏剧节·看完好戏不来说一说？",
					desc: '观戏剧，写剧评，分享属于你的“戏如人生”，赢取戏剧节限量礼品。',
					link: '${basePath}/wechatStatic/dramaFestival.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/dramaImg/shareIcon.jpg'
				});
				wx.onMenuShareWeibo({
					title: "佛山文化云·上海当代戏剧节·看完好戏不来说一说？",
					desc: '观戏剧，写剧评，分享属于你的“戏如人生”，赢取戏剧节限量礼品。',
					link: '${basePath}/wechatStatic/dramaFestival.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/dramaImg/shareIcon.jpg'
				});
				wx.onMenuShareQZone({
					title: "佛山文化云·上海当代戏剧节·看完好戏不来说一说？",
					desc: '观戏剧，写剧评，分享属于你的“戏如人生”，赢取戏剧节限量礼品。',
					link: '${basePath}/wechatStatic/dramaFestival.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/dramaImg/shareIcon.jpg'
				});
			});
		}
		
		$(function () {
			if (tab == null || tab == '') {
				tab = 0;
			}
			
			if(tab == 0){
				loadDramaList(1);
			}else if(tab == 1){
				loadDramaCommentList();
			}else if(tab == 3){
				loadDramaList(2);
				loadDramaList(3);
			}
			
			menuChange(tab);

			//菜单顶部固定
			$(document).on('touchmove', function() {
				if($(document).scrollTop() > 240) {
					$(".dramaMenuList").css('position', 'fixed')
				} else {
					$(".dramaMenuList").css('position', 'relative')
				}
			})
			$(document).on('scroll', function() {
				if($(document).scrollTop() > 240) {
					$(".dramaMenuList").css('position', 'fixed')
				} else{
					$(".dramaMenuList").css('position', 'relative')
				}
			})

			//菜单点击样式
			$(".dramaMenuList>ul>li>div").on('click', function() {
				$(".dramaMenuList>ul>li>div").removeClass('dramaMenuOn')
				$(this).addClass('dramaMenuOn')
				$(".dramaContent>ul>li").hide()
				$(".dramaContent>ul>li").eq($(this).parent().index()).show()

			})

			//投一票点击切换红心
			$(".dramaActLove").click(function(e) {
				e.stopPropagation();
				$(this).find('img').attr("src", "${path}/STATIC/wxStatic/image/dramaImg/loveOn.png")
			})

			//排行榜 查看全部
			$(".dramaDownShow").click(function() {
				if($(this).hasClass('dramaDOn')) {
					$(this).parent().find('.dramaRankList').css('height', '955px')
					$(this).find('img').removeClass('rotate180')
					$(this).removeClass('dramaDOn')
				} else {
					$(this).parent().find('.dramaRankList').css('height', 'auto')
					$(this).find('img').addClass('rotate180')
					$(this).addClass('dramaDOn')

				}
			})
			
          	//分享
			$(".share-button").click(function() {
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
			//关注
			$(".keep-button").on("touchstart", function() {
				$('.div-share').show()
				$("body,html").addClass("bg-notouch")
			})
            
		});
		
		//加载戏剧列表
		function loadDramaList(sort){
			$.post("${path}/wechatStatic/queryCcpDramalist.do",{userId:userId,sort:sort}, function (data) {
   				$.each(data, function (i, dom) {
   					if(sort==1){
   						var voteHtml = "";
   	   					if(dom.isVote == 1){
   	   						voteHtml = "<div class='dramaActLove' onclick='dialogAlert(\"系统提示\", \"今日已投票！\");'>" +
											"<p><img src='${path}/STATIC/wxStatic/image/dramaImg/loveOn.png' alt='' />投一票</p>" +
									   "</div>";
   	   					}else{
	   	   					voteHtml = "<div class='dramaActLove' onclick='dramaVote(\""+dom.dramaId+"\",this)'>" +
											"<p><img src='${path}/STATIC/wxStatic/image/dramaImg/love.png' alt='' />投一票</p>" +
									   "</div>";
   	   					}
   						$("#dramaUl1").append("<li>" +
												"<div class='dramaActTag'>" +
													"<img src='"+dom.dramaImg+"@300w' style='width: 320px;height: 430px;' onclick='toDramaDetail(\""+dom.dramaId+"\")'/>" +
													"<div class='dramaActTagName'>"+dom.dramaName+"</div>" +
													voteHtml +
												"</div>" +
												"<div class='dramaActWrite' onclick='toComment(\""+dom.dramaId+"\")'>写评论</div>" +
											 "</li>");
   					}else if(sort==2){
   						$("#dramaUl2").append("<li onclick='toDramaDetail(\""+dom.dramaId+"\")'>" +
													"<div style='height: 150px;'>" +
														"<div class='dramaRankNum'>"+(i+1)+"</div>" +
														"<div class='dramaRankImg'>" +
															"<img src='"+dom.dramaImg+"@200w' />" +
														"</div>" +
														"<div class='dramaRankTitle'>" +
															"<p>"+dom.dramaName+"</p>" +
															"<p>"+dom.dramaTag+"</p>" +
														"</div>" +
														"<div class='dramaRankLove'>" +
															"<img src='${path}/STATIC/wxStatic/image/dramaImg/loveOn.png' />" +
															"<p>"+dom.voteCount+"</p>" +
														"</div>" +
														"<div style='clear: both;'></div>" +
													"</div>" +
											  "</li>");
					}else if(sort==3){
   						$("#dramaUl3").append("<li onclick='toDramaDetail(\""+dom.dramaId+"\")'>" +
													"<div style='height: 150px;'>" +
														"<div class='dramaRankNum'>"+(i+1)+"</div>" +
														"<div class='dramaRankImg'>" +
															"<img src='"+dom.dramaImg+"@200w' />" +
														"</div>" +
														"<div class='dramaRankTitle'>" +
															"<p>"+dom.dramaName+"</p>" +
															"<p>"+dom.dramaTag+"</p>" +
														"</div>" +
														"<div class='dramaRankLove'>" +
															"<img src='${path}/STATIC/wxStatic/image/dramaImg/write.png' />" +
															"<p>"+dom.commentCount+"</p>" +
														"</div>" +
														"<div style='clear: both;'></div>" +
													"</div>" +
											  "</li>");
					}
   				});
			},"json");
		}
		
		//详情
		function toDramaDetail(dramaId){
			if (userId == null || userId == '') {
				publicLogin("${basePath}wechatStatic/toDramaDetail.do?dramaId="+dramaId);
			}else{
				location.href = '${path}/wechatStatic/toDramaDetail.do?dramaId='+dramaId+'&tab='+tab;
			}
		}
		
		//投票
		function dramaVote(dramaId,$this){
			if(noControl != 1){
				if (userId == null || userId == '') {
	        		//判断登陆
	            	publicLogin("${basePath}wechatStatic/dramaFestival.do");
	        	}else{
	        		$.post("${path}/wechatStatic/addDramaVote.do",{userId:userId,dramaId:dramaId}, function (data) {
	    				if(data == "200"){
	    					$($this).find("img").attr("src", "${path}/STATIC/wxStatic/image/dramaImg/loveOn.png");
	    				}else if(data == "repeat"){
	    					dialogAlert('系统提示', '今日已投票！');
	    				}else if(data == "500"){
	    					dialogAlert('系统提示', '投票失败！');
	    				}
	    			},"json");
	        	}
			}else{
				dialogAlert('系统提示', '活动已结束！');
			}
		}
		
		//评论
		function toComment(dramaId){
			if(noControl != 1){
				if (userId == null || userId == '') {
	        		//判断登陆
	            	publicLogin("${basePath}wechatStatic/dramaFestival.do");
	        	}else{
	        		$.post("${path}/wechatStatic/queryCcpDramaUserName.do",{userId:userId}, function (data) {
	        			if(data.length>0){
	        				location.href = '${path}/wechatStatic/toDramaComment.do?dramaId='+dramaId;
	        			}else{
	        				location.href = '${path}/wechatStatic/toDramaUser.do?dramaId='+dramaId;
	        			}
	        		},"json");
	        	}
			}else{
				dialogAlert('系统提示', '活动已结束！');
			}
		}
		
		//加载剧评列表
		function loadDramaCommentList(){
			$.post("${path}/wechatStatic/queryCcpDramaCommentlist.do",{dramaStatus:2}, function (data) {
				$.each(data, function (i, dom) {
					var userHeadImgHtml = '';
					if(dom.userHeadImgUrl){
		                if(dom.userHeadImgUrl.indexOf("http") == -1){
		                	dom.userHeadImgUrl = getImgUrl(dom.userHeadImgUrl);
		                }
		            }else{
		            	dom.userHeadImgUrl = '';
		            }
					if (dom.userHeadImgUrl.indexOf("http") == -1) {
		            	userHeadImgHtml = "<img src='../STATIC/wx/image/sh_user_header_icon.png'/>";
		            } else if (dom.userHeadImgUrl.indexOf("/front/") != -1) {
		                var imgUrl = getIndexImgUrl(dom.userHeadImgUrl, "_300_300");
		                userHeadImgHtml = "<img src='" + imgUrl + "' onerror='imgNoFind();'/>";
		            } else {
		            	userHeadImgHtml = "<img src='" + dom.userHeadImgUrl + "' onerror='imgNoFind();'/>";
		            }
					$("#dramaCommentUl").append("<li>" +
													"<div class='dramaUser'>" +
														"<div class='dramaUserImg'>"+userHeadImgHtml+"</div>" +
														"<div class='dramaUserDetail'>" +
															"<div class='dramaUserInfo'>" +
																"<div class='dramaUserName'>" +
																	"<p>"+dom.userName+"</p>" +
																	"<p>"+formatTimeStr(dom.createTime)+"</p>" +
																"</div>" +
																"<div class='dramaActName'>"+dom.dramaName+"</div>" +
																"<div style='clear: both;'></div>" +
															"</div>" +
															"<div class='dramaUserComent'>" +
																"<p>"+dom.dramaCommentRemark+"</p>" +
															"</div>" +
														"</div>" +
														"<div style='clear: both;'></div>" +
													"</div>" +
												"</li>");
				});
			},"json");
		}
		
		//进页面菜单显示
		function menuChange(num) {
			$(".dramaMenuList>ul>li>div").removeClass('dramaMenuOn')
			$(".dramaMenuList>ul>li>div").eq(num).addClass('dramaMenuOn')
			$(".dramaContent>ul>li").hide()
			$(".dramaContent>ul>li").eq(num).show()
		}
		
		//日期泛型
		function formatTime(date) {
			//获取到的年月日事件
			var date_get_year = parseInt(date.split('-')[0])
			var date_get_mon = parseInt(date.split('-')[1])
			var date_get_day = parseInt(date.split(' ')[0].split('-')[2])
			var data_get_time = date.split(' ')[1].split(':')
				//当前的年月日时间
			var myDate = new Date()
			var date_now = myDate.toLocaleDateString().split('/')
			var data_now_year = myDate.getFullYear();
			var data_now_mon = myDate.getMonth() + 1;
			var data_now_day = myDate.getDate();

			if(date_get_year == data_now_year && date_get_mon == data_now_mon && date_get_day == data_now_day) {
				if(parseInt(data_get_time[0]) < myDate.getHours()) {
					return myDate.getHours() - parseInt(data_get_time[0]) + '小时前';
				} else {
					return date.split(' ')[1]
				}
			} else {
				return date.split(' ')[0]
			}
		}

	</script>
	
	<style>
		/*清除浮动*/
		ul:after {
			display: block;
			clear: both;
			content: "";
			visibility: hidden;
			height: 0
		}
		ul {
			zoom: 1
		}
	</style>
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wxStatic/image/dramaImg/shareIcon.jpg"/></div>
	<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
		<img src="${path}/STATIC/wechat/image/commonShare.png" style="width: 100%;height: 100%;" />
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
	<div class="dramaMain">
		<img class="keep-button" src="${path}/STATIC/wxStatic/image/hongkouAct/hkshare.png" style="position: absolute;right: 30px;top: 30px;" />
		<img class="share-button" src="${path}/STATIC/wxStatic/image/hongkouAct/hkkeep.png" style="position: absolute;right: 120px;top: 30px;" />
		<div>
			<img src="${path}/STATIC/wxStatic/image/dramaImg/banner.jpg" />
		</div>
		<div class="dramaMenu">
			<div class="dramaMenuList">
				<ul>
					<li onclick="location.href='${path}/wechatStatic/dramaFestival.do'">
						<div>参演节目</div>
					</li>
					<li onclick="location.href='${path}/wechatStatic/dramaFestival.do?tab=1'">
						<div>精彩剧评</div>
					</li>
					<li onclick="location.href='${path}/wechatStatic/dramaFestival.do?tab=2'">
						<div>活动规则</div>
					</li>
					<li onclick="location.href='${path}/wechatStatic/dramaFestival.do?tab=3'">
						<div>排行榜</div>
					</li>
					<div style="clear: both;"></div>
				</ul>
			</div>
		</div>
		<div class="dramaContent">
			<ul>
				<!--参演节目-->
				<li style="display: block;">
					<div style="padding: 20px 40px;">
						<div class="dramaActTitle">
							<img src="${path}/STATIC/wxStatic/image/dramaImg/acttitle.png" />
							<p>2016第十二届上海当代戏剧节于2016年11月5日在上海话剧艺术中心拉开大幕。先后将有16部国内外最前沿的当代戏剧作品在上海话剧艺术中心和1933微剧场的舞台上轮番上演。一个月足不出“沪”，尽享8个国家的48场戏剧饕餮。即日—12月11日期间，每观看一场上海当代戏剧节的戏剧，随手提交原创观剧剧评，分享你的观看感受，为你最喜欢的演出投票，便有机会获得上海当代戏剧节限量帆布环保袋，快来分享属于你的“戏如人生”。</p>
						</div>
						<div class="dramaActList">
							<ul id="dramaUl1"></ul>
						</div>
					</div>
				</li>

				<!--精彩剧评-->
				<li>
					<div style="padding: 0 0 0 20px;">
						<ul id="dramaCommentUl"></ul>
					</div>
				</li>

				<!--活动规则-->
				<li style="padding: 25px;background-color: #eeeeee;">
					<div style="background-color: #fff;padding: 20px;">
						<div class="dramaRule" style="padding-bottom: 30px;border-bottom: 1px solid #262626;">
							<p style="text-align: center;font-size: 34px;color: #262626;font-weight: bold;">上海当代戏剧节</p>
							<p style="text-align: center;font-size: 30px;line-height: 10px;">#&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;#</p>
							<p style="text-align: center;font-size: 30px;">活动规则</p>
						</div>
						<div class="dramaRuleFont">
							<ol>
								<li>参与活动，提交剧评，即可当即获得200文化云积分；</li>
								<li>每个用户可以提交多个剧评，但积分仅获得一次（以同一ID为准判定）；</li>
								<li>参与成功即进入抽奖数据库，我们会在12月12日从所有参与活动的用户中，抽出10名获得<span style="color: #bd492a;">上海当代戏剧节限量帆布环保袋1个</span>;</li>
							</ol>
							<div style="width: 475px;margin: 50px 0 0 40px;">
								<img style="float: left;display: block;" src="${path}/STATIC/wxStatic/image/dramaImg/rule.jpg" />
								<img style="float: right;display: block;" src="${path}/STATIC/wxStatic/image/dramaImg/rule2.png" />
								<div style="clear: both;"></div>
							</div>
						</div>
					</div>
				</li>

				<!--排行榜-->
				<li style="padding: 25px;background-color: #eeeeee;">
					<div style="background-color: #fff;">
						<div style="margin: 0 30px;">
							<p style="font-size: 34px;text-align: center;line-height: 120px;border-bottom: 1px solid #262626;">#&emsp;&emsp;最受观众喜爱排行榜&emsp;&emsp;#</p>
							<div class="dramaRankList">
								<ul id="dramaUl2"></ul>
							</div>
							<div class="dramaDownShow">
								<p>查看全部<img src="${path}/STATIC/wxStatic/image/dramaImg/arrow.png" alt="" /></p>
							</div>
						</div>

					</div>
					
					<div style="background-color: #fff;margin-top: 20px;">
						<div style="margin: 0 30px;">
							<p style="font-size: 34px;text-align: center;line-height: 120px;border-bottom: 1px solid #262626;">#&emsp;&emsp;群众热议排行榜&emsp;&emsp;#</p>
							<div class="dramaRankList">
								<ul id="dramaUl3"></ul>
							</div>
							<div class="dramaDownShow">
								<p>查看全部<img src="${path}/STATIC/wxStatic/image/dramaImg/arrow.png" alt="" /></p>
							</div>
						</div>
					</div>
				</li>
			</ul>
		</div>
	</div>
</body>
</html>