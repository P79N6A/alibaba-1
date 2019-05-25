<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>2016春华秋实市民投票通道</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-dc.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		var tab = '${tab}';
		var noVote = '${noVote}';	//1：不可投票
		var showRanking = '${showRanking}';		//1：显示排名
		var videoType = '${videoType}';
		var startIndex = 0;		//页数
	
		if (userId == null || userId == '') {
    		//判断登陆
        	publicLogin("${basePath}wechatDc/index.do");
    	}
		
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
        	appShareTitle = '“春华秋实”2016年上海市社区文艺指导员教学成果展演-展演名单已公布，点击进入……';
			appShareDesc = '展演名单已公布，点击进入……';
        	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/delivery/shareIcon.jpg';
        	
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
					title: "“春华秋实”2016年上海市社区文艺指导员教学成果展演-展演名单已公布，点击进入……",
					desc: '展演名单已公布，点击进入……',
					link: '${basePath}wechatDc/index.do?tab='+tab,
					imgUrl: '${basePath}/STATIC/wxStatic/image/delivery/shareIcon.jpg'
				});
				wx.onMenuShareTimeline({
					title: "“春华秋实”2016年上海市社区文艺指导员教学成果展演-展演名单已公布，点击进入……",
					imgUrl: '${basePath}/STATIC/wxStatic/image/delivery/shareIcon.jpg',
					link: '${basePath}wechatDc/index.do?tab='+tab
				});
				wx.onMenuShareQQ({
					title: "“春华秋实”2016年上海市社区文艺指导员教学成果展演-展演名单已公布，点击进入……",
					desc: '展演名单已公布，点击进入……',
					imgUrl: '${basePath}/STATIC/wxStatic/image/delivery/shareIcon.jpg'
				});
				wx.onMenuShareWeibo({
					title: "“春华秋实”2016年上海市社区文艺指导员教学成果展演-展演名单已公布，点击进入……",
					desc: '展演名单已公布，点击进入……',
					imgUrl: '${basePath}/STATIC/wxStatic/image/delivery/shareIcon.jpg'
				});
				wx.onMenuShareQZone({
					title: "“春华秋实”2016年上海市社区文艺指导员教学成果展演-展演名单已公布，点击进入……",
					desc: '展演名单已公布，点击进入……',
					imgUrl: '${basePath}/STATIC/wxStatic/image/delivery/shareIcon.jpg'
				});
			});
		}
		
		$(function () {
			if (tab == null || tab == '') {
				tab = 0;
			}
			
			loadDcList(0,20);
			
			menuChange(tab);
			
			$.post("${path}/wechatUser/queryTerminalUserById.do",{userId:userId}, function(data) {
				if(data.status==0){
					var user = data.data[0];
					$("#userMobile").val(user.userMobileNo);
				}
			},"json");
			
			// 回到顶部
			var topH = $(".hdtop").offset().top;
			$(window).scroll(function(){
				var scroH = $(this).scrollTop();
				if(scroH>topH){
					$(".hdtop").fadeIn(300);
				}else{
					$(".hdtop").fadeOut(300);
				}
			});
			$(".hdtop").click(function(){
				$("html,body").animate({scrollTop:0},400);
			});

			// 规则
			$('.delivery .deban .deann .btn_2').bind('click', function () {
				$('.delivery .derule').stop().fadeIn(300);
				$('html,body').css('overflow','hidden');
			});
			$('.delivery .derule .zhidaol').bind('click', function () {
				$('html,body').css('overflow','visible');
				$('.delivery .derule').stop().fadeOut(300);
			});

			// 切换标题栏固定
			$(document).scroll(function() {
				if($(document).scrollTop() > 572) {
					$(".delivery .delivetit").css("position", "fixed")
				} else {
					$(".delivery .delivetit").css("position", "static")
				}
			});
			$(document).on('touchmove', function() {
				if($(document).scrollTop() > 572) {
					$(".delivery .delivetit").css("position", "fixed")
				} else {
					$(".delivery .delivetit").css("position", "static")
				}
			});
			
			// 关闭弹窗
			$('.delivery .touptc .zhidl').bind('click', function () {
				$(this).parents('.touptc').hide();
				$(".menban").hide();
			});
			
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
		
		//加载剧评列表
		function loadDcList(index, pagesize){
			var data = {
					userId:userId,
					videoType:videoType,
					reviewType:6,
					firstResult: index,
	               	rows: pagesize
	            };
			$.post("${path}/wechatDc/queryDclist.do",data, function (data) {
				if(data.length<10){
        			$("#loadingDcVideoDiv").html("");
	        	}
				$.each(data, function (i, dom) {
					var ImgObj = new Image();
					ImgObj.src = dom.videoImgUrl+"@400w";
					ImgObj.onload = function(){
						if(ImgObj.width/ImgObj.height>345/255){
							var pLeft = (ImgObj.width*(255/ImgObj.height)-345)/2;
							$("img[videoId="+dom.videoId+"]").css({"height":"255px","position":"absolute","left":"-"+pLeft+"px"});
						}else{
							var pTop = (ImgObj.height*(345/ImgObj.width)-255)/2;
							$("img[videoId="+dom.videoId+"]").css({"width":"345px","position":"absolute","top":"-"+pTop+"px"});
						}
					}
					var videoActivityCenter = "";
					if(dom.videoActivityCenter.lastIndexOf("文化活动中心")>0){
						videoActivityCenter = dom.videoActivityCenter.substring(0,dom.videoActivityCenter.lastIndexOf("文化活动中心"));
					}else{
						videoActivityCenter = dom.videoActivityCenter;
					}
					var voteHtml = "";
					if(dom.isVote == 1){
						voteHtml = "class='old'";
					}
					var voteCountHtml = "";
					if(noVote == 1){
						voteCountHtml = "投票已结束";
					}else{
						voteCountHtml = "票 数<br><span>"+dom.voteCount+"</span>";
					}
					$("#dcVideoUl").append("<li "+voteHtml+">" +
								    			"<a href='http://www.wenhuayun.cn/wechatDc/toDetail.do?videoId="+dom.videoId+"' style='display:block;width:345px;height:255px;overflow:hidden;position: relative;'><img videoId='"+dom.videoId+"' src='"+dom.videoImgUrl+"@400w'></a>" +
								    			"<div class='char'>" +
													"<h5><a href='javascript:;'>"+dom.videoName+"</a></h5>" +
													"<h6>"+videoActivityCenter+"</h6>" +
													"<div class='piao clearfix'>" +
														"<div class='piao_1'><p>"+voteCountHtml+"</p><em>+1</em></div>" +
														"<div class='piao_2'><div onclick='dcVote(\""+dom.videoId+"\",this)'><em>积分+1</em></div></div>" +
													"</div>" +
								    			"</div>" +
								    		"</li>");
				});
			},"json");
		}
		
		//投票
		function dcVote(videoId,$this){
			if(noVote != 1){
				if (userId == null || userId == '') {
	        		//判断登陆
	            	publicLogin("${basePath}wechatDc/index.do");
	        	}else{
	        		$.post("${path}/wechatDc/addVote.do",{userId:userId,videoId:videoId}, function (data) {
	    				if(data == "100"){
	    					var _li = $($this).parents('li');
	   						_li.addClass('add');
	   						var ele = _li.find('.piao .piao_1 p span');
	   						ele.html(parseInt(ele.html()) + 1);
	   						_li.addClass('old');
	   						
	   						$("#dialog3").css("display","table");
	   						$(".menban").show();
	    				}else if(data == "200"){
	    					var _li = $($this).parents('li');
	   						_li.addClass('add');
	   						setTimeout(function () {
	   							_li.addClass('add_2');
	   						},90);
	   						var ele = _li.find('.piao .piao_1 p span');
	   						ele.html(parseInt(ele.html()) + 1);
	   						_li.addClass('old');
	    				}else if(data == "repeat"){
	    					$("#dialog2").css("display","table");
	    					$(".menban").show();
	    				}else if(data == "500"){
	    					dialogAlert('系统提示', '投票失败！');
	    				}
	    			},"json");
	        	}
			}else{
				$("#dialog4").css("display","table");
				$(".menban").show();
			}
		}
		
		//补填手机号
		function saveInfo(){
			var userMobile = $("#userMobile").val();
			var telReg = (/^1[34578]\d{9}$/);
			if(userMobile == ""){
		    	dialogAlert('系统提示', '请输入手机号码！');
		        return false;
		    }else if(!userMobile.match(telReg)){
		    	dialogAlert('系统提示', '请正确填写手机号码！');
		        return false;
		    }
			var data = {
				userId:userId,
				userTelephone:userMobile
			}
			$.post("${path}/terminalUser/editTerminalUser.do", data, function(data) {
				if (data == "success") {
					$("#dialog3").hide();
					$("#dialog1").css("display","table");
				}else {
					dialogAlert('系统提示', "提交失败")
				}
			},"json");
		}
		
		//跳过按钮
		function passBtn(){
			$("#dialog1").css("display","table");
		}
		
		//滑屏分页
        $(window).on("scroll", function () {
            var scrollTop = $(document).scrollTop();
            var pageHeight = $(document).height();
            var winHeight = $(window).height();
            if (scrollTop >= (pageHeight - winHeight - 80)) {
           		setTimeout(function () { 
      				startIndex += 20;
              		var index = startIndex;
              		loadDcList(index,20);
           		},800);
            }
        });
		
     	//进页面菜单显示
		function menuChange(num) {
			$('.delivetit li').eq(num).addClass('current');
      	}
	</script>
	
	<style type="text/css">
		html,body{font-family:arial,\5FAE\8F6F\96C5\9ED1,\9ED1\4F53,\5b8b\4f53,sans-serif; -webkit-text-size-adjust:none;/*Google Chrome*/-webkit-tap-highlight-color: transparent;}
		img {vertical-align: middle;}
		.delivery {background: url(${path}/STATIC/wxStatic/image/delivery/bg1.jpg) repeat;}
		html,body{height:100%;}
		.loadingDiv{font-size: 24px;color: #af81b8;text-align: center;}
		.delivery .menban {width: 100%;height: 100%;background-color: rgba(0,0,0,0.5);position: fixed;left: 0;top: 0;z-index: 9;display: none;}
	</style>
</head>

<body style="background: url(${path}/STATIC/wxStatic/image/delivery/bg1.jpg) repeat;">
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wxStatic/image/delivery/shareIcon.jpg"/></div>
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
	<div class="delivery">
		<div class="deban">
			<img src="${path}/STATIC/wxStatic/image/delivery/ban1.jpg">
			<ul class="lccshare clearfix" style="margin-top:10px;">
		        <li style="background-color: transparent">
		        	<a class="share-button" style="background-color: rgba(0,0,0,0.5);margin-bottom:10px;" href="javascript:;">分享</a>
		        	<a class="keep-button" style="background-color: rgba(0,0,0,0.5);" href="javascript:;">关注</a>
		        </li>
		    </ul>
		    <div class="bntime">11月08日～11月17日</div>
		    <div class="deann clearfix">
		    	<div class="btn_1">市民投票通道</div>
		    	<div class="btn_2"></div>
		    </div>
	    </div>
	    <div class="degg">
	    	<p style="padding-top: 9px;">市民投票时间为：&nbsp;&nbsp;&nbsp;<a href="${path}/wechatDc/suggestion.do"></a><br>2016年 11月8日00:00—11月17日17:00</p>
	    	<c:choose>
	    		<c:when test="${showRanking == 1}">
	    			<a class="zymd active" href="${path}/wechatDc/toRanking.do"></a>
	    		</c:when>
	    		<c:otherwise>
	    			<a class="zymd" href="javascript:$('#dialog5').css('display','table');$('.menban').show();"></a>
	    		</c:otherwise>
	    	</c:choose>
	    </div>
	    <div class="delivetit_wc">
		    <ul class="delivetit clearfix">
		    	<li onclick="location.href='${path}/wechatDc/index.do?tab=0'">舞 蹈</li>
		    	<li onclick="location.href='${path}/wechatDc/index.do?tab=1'">合 唱</li>
		    	<li onclick="location.href='${path}/wechatDc/index.do?tab=2'">时 装</li>
		    	<li onclick="location.href='${path}/wechatDc/index.do?tab=3'">戏曲/曲艺</li>
		    </ul>
	    </div>
	    <div class="delivecont_wc">
	    	<ul id="dcVideoUl" class="delivecont jz710 clearfix" style="display: block;"></ul>
	    	<div id="loadingDcVideoDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
	    </div>
	    <div class="defoot">
	    	<div class="jz710">此活动最终解释权归上海市群众艺术馆所有<br>主办方：上海市群众艺术馆    上海市东方公共文化配送中心（筹）</div>
	    </div>
	sh
	    <!-- 回到顶部 -->
	    <img class="hdtop" src="${path}/STATIC/wxStatic/image/delivery/top.png">
	    <!-- 规则 -->
	    <div class="derule">
	    	<div class="derule_nc">
		    	<div class="jz690">
		    		<div class="tit"><span style="font-size:25px;">#</span>&nbsp;&nbsp;&nbsp;&nbsp;评选规则&nbsp;&nbsp;&nbsp;&nbsp;<span style="font-size:25px;">#</span></div>
		    		<div class="cont">
		    			<div class="item">
			    			<p><img src="${path}/STATIC/wxStatic/image/delivery/pic9.png">活动简介</p>
			    			<p>上海市社区文艺指导员教学成果展演大众投票环节</p>
		    			</div>
		    			<div class="item">
		    				<p><img src="${path}/STATIC/wxStatic/image/delivery/pic9.png">大众投票日期</p>
		    				<p>2016年  11月8日00:00—11月17日17:00</p>
		    			</div>
		    			<div class="item">
		    				<p><img src="${path}/STATIC/wxStatic/image/delivery/pic9.png">展演名单公示日期</p>
		    				<p>2016年11月18日20:00</p>
		    			</div>
		    			<div class="item">
		    				<p><img src="${path}/STATIC/wxStatic/image/delivery/pic9.png">评比方式</p>
		    				<p>1）由<span class="liang">专家评审</span>和<span class="liang">大众投票</span>两部分组成。</p>
							<p>2）专家对节目打分占总得分的<span class="liang">80%</span>。</p>
							<p>3）市民通过“文化云—市民投票通道”进行投票，投票数占总得分的<span class="liang">20%</span>。</p>
							<p>4）舞蹈、时装、合唱、戏曲/曲艺四大门类前十六名入围展演活动。</p>	
		    			</div>
		    			<div class="item">
		    				<p><img src="${path}/STATIC/wxStatic/image/delivery/pic9.png">投票方式</p>
		    				<p>1）每个用户（同一ID）每天对每一个作品只能投一票。</p>
		    				<p>2）用户首次投票将有机会参与“文化云抽奖活动”，输入手机号码参与成功即进入抽奖数据库，活动将抽出10名幸运用户，每人获得“传统文化大礼包一份”。</p>
		    				<p>3）中奖名单于11月20日在文化云微信公众平台上公布，请提前关注文化云官方微信公众号。</p>
		    				<p>4）用户首次投票将被奖励文化云100积分，之后的每次投票成功将被奖励1积分，可累积不封顶。</p>
		    				<p>5）用户可以进入“文化云”--“个人中心”中查看并使用积分。</p>
		    			</div>
		    			<div class="item"><p>本活动禁止任何手段的恶意刷票或作弊行为，一经发现，取消活动资格及所获奖励。<br><br>此规则最终解释权归上海市群众艺术馆和文化云所有！</p></div>
		    		</div>
		    	</div>
		    	
		    </div>
		    <div class="zhidaol_wc"><div class="zhidaol">我知道了</div></div>
	    </div>
	    <!-- display:table;-->
	    <div id="dialog1" class="touptc">
	    	<div class="nc">
	    		<p>恭喜您，投票成功！<br>首次投票获得文化云100积分！</p>
	    		<div class="zhidl cha">X</div>
	    	</div>
	    </div>
	    <div id="dialog2" class="touptc">
	    	<div class="nc">
	    		<p>今天已经帮TA投过票咯<br/>去看看其他作品吧！</p>
	    		<div class="zhidl cha">X</div>
	    	</div>
	    </div>
	    <div id="dialog3" class="touptc" style="width:680px;padding:50px 0;">
	    	<div class="nc">
	    		<div class="tantit">请填写手机号</div>
	    		<div class="clearfix" style="margin-bottom:55px;">
	    			<input id="userMobile" type="text" value="" maxlength="11"  class="dettxt" autofocus="autofocus">
	    			<input class="detbtn" type="button" value="提交" onclick="saveInfo();">
	    		</div>
	    		<p style="font-size: 24px;color:#8163a6;text-align:left;margin-top:26px;line-height:38px;padding:0 40px;">1）用户首次投票将有机会参与“<span style="color:#d3bbf0">文化云抽奖活动</span>”，输入手机号码参与成功即进入抽奖数据库，活动将抽出10名幸运用户，每人获得“传统文化大礼包一份”。</p>
	    		<p style="font-size: 24px;color:#8163a6;text-align:left;margin-top:26px;line-height:38px;padding:0 40px;">2）中奖名单于11月20日在文化云微信公众平台上公布，请提前关注文化云官方微信公众号。</p>
	    		<p style="font-size: 24px;color:#8163a6;text-align:left;margin-top:26px;line-height:38px;padding:0 40px;">3）用户首次投票将被奖励文化云<span style="color:#d3bbf0">100</span>积分，之后的每次投票成功将被奖励<span style="color:#d3bbf0">1</span>积分，可累积不封顶。</p>
	    		<p style="font-size: 24px;color:#8163a6;text-align:left;margin-top:26px;line-height:38px;padding:0 40px;">4）用户可以进入“文化云”--“个人中心”中查看并使用积分。</p>
	    		<p style="font-size: 24px;color:#8163a6;text-align:left;margin-top:26px;line-height:38px;padding:0 40px;">5）每个用户（同一ID）每天对每一个作品只能投一票。</p>
		    	<p style="font-size: 24px;color:#8163a6;text-align:left;margin-top:26px;line-height:38px;padding:0 40px;">此活动最终解释权归上海市群众艺术馆和文化云所有！</p>
	    		<div class="touanniu zhidl" onclick="passBtn();" style="margin-top:55px;">
	    			<a style="color: #8C73AB;">跳过此步</a>
	    		</div>
	    	</div>
	    </div>
	    <div id="dialog4" class="touptc">
	    	<div class="nc">
	    		<p>投票时间已结束！</p>
	    		<div class="zhidl cha">X</div>
	    	</div>
	    </div>
	    <div id="dialog5" class="touptc">
	    	<div class="nc">
	    		<p style="font-size:36px;">名单将于11月18日20:00公布！</p>
	    		<div class="zhidl cha">X</div>
	    	</div>
	    </div>
	    <!-- 蒙版 -->
    	<div class="menban"></div>
	</div>
</body>
</html>