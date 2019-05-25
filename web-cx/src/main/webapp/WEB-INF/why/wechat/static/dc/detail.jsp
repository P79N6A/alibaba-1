<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>2016春华秋实市民投票通道</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-dc.css?v=231231"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		var videoId = '${videoId}';
		var noVote = '${noVote}';	//1：不可投票
		var isWifi = true;
	
		if (userId == null || userId == '') {
    		//判断登陆
        	publicLogin("${basePath}wechatDc/toDetail.do?videoId="+videoId);
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
                jsApiList: ['onMenuShareAppMessage','onMenuShareTimeline','onMenuShareQQ','onMenuShareWeibo','onMenuShareQZone','getNetworkType']
            });
        };
		
		$(function () {
			$.post("${path}/wechatDc/queryDclist.do",{userId:userId,videoId:videoId}, function (data) {
				if(data.length>0){
					var dom = data[0];
					$("#videoUrl").attr("src",dom.videoUrl);
					$("#videoImgUrl").attr("src",dom.videoImgUrl+"@800w");
					var ImgObj = new Image();
					ImgObj.src = dom.videoImgUrl+"@800w";
					ImgObj.onload = function(){
						if(ImgObj.width/ImgObj.height>750/435){
							var pLeft = (ImgObj.width*(435/ImgObj.height)-750)/2;
							$("#videoImgUrl").css({"height":"435px","position":"absolute","left":"-"+pLeft+"px"});
						}else{
							var pTop = (ImgObj.height*(750/ImgObj.width)-435)/2;
							$("#videoImgUrl").css({"width":"750px","position":"absolute","top":"-"+pTop+"px"});
						}
					}
					$('#videoUrl').on('play', function() {
						if(!isWifi){
							dialogAlert("提示", "您的流量正在燃烧哟~~");
						}
					});
					$("#videoName").html(dom.videoName);
					$("#videoGuide").html(dom.videoGuide);
					var videoActivityCenter = "";
					if(dom.videoActivityCenter.lastIndexOf("文化活动中心")>0){
						videoActivityCenter = dom.videoActivityCenter.substring(0,dom.videoActivityCenter.lastIndexOf("文化活动中心"));
					}else{
						videoActivityCenter = dom.videoActivityCenter;
					}
					$("#videoActivityCenter").html(videoActivityCenter);
					$("#videoIntro").html(dom.videoIntro);
					$("#videoTeamName").html(dom.videoTeamName);
					$("#videoTeamRemark").html(dom.videoTeamRemark);
					if(noVote!=1){
						$("#voteCount").html(dom.voteCount);
					}
					if(dom.isVote == 1){
						$('.delivery .lptp .tp div').css('background-image','url(${path}/STATIC/wxStatic/image/delivery/pic14.png)');
					}
					
					shareTitle = "【拉票】快来帮“"+videoActivityCenter+"”"+dom.videoName+"投上一票，助力他们登顶百姓展演舞台！！！";
					shareDesc = "2016上海市社区文艺指导员教学成果展演，我本次助力第"+(eval(dom.voteCount)+1)+"票，快来加入投票大军吧！！！";
					assnIconUrl = "${basePath}/STATIC/wxStatic/image/delivery/shareIcon.jpg";
					
					//分享是否隐藏
    		        if(window.injs){
    		        	//分享文案
    		        	appShareTitle = shareTitle;
    		        	appShareDesc = shareDesc;
    		        	appShareImgUrl = assnIconUrl;
    		        	
    		    		injs.setAppShareButtonStatus(true);
    		    	}
    				
    				if (is_weixin()) {
	    				wx.ready(function () {
	    	            	wx.onMenuShareAppMessage({
	    	                    title: shareTitle,
	    	                    desc: shareDesc,
	    	                    link: '${basePath}wechatDc/toDetail.do?videoId='+videoId,
	    	                    imgUrl: assnIconUrl
	    	                });
	    	                wx.onMenuShareTimeline({
	    	                    title: shareDesc,
	    	                    imgUrl: assnIconUrl,
	    	                    link: '${basePath}wechatDc/toDetail.do?videoId='+videoId
	    	                });
	    	                wx.onMenuShareQQ({
	    	                	title: shareTitle,
	    	                    desc: shareDesc,
	    	                    imgUrl: assnIconUrl
	    	                });
	    	                wx.onMenuShareWeibo({
	    	                	title: shareTitle,
	    	                    desc: shareDesc,
	    	                    imgUrl: assnIconUrl
	    	                });
	    	                wx.onMenuShareQZone({
	    	                	title: shareTitle,
	    	                    desc: shareDesc,
	    	                    imgUrl: assnIconUrl
	    	                });
	    	                wx.getNetworkType({
	    		        	    success: function (res) {
	    		        	        var networkType = res.networkType; // 返回网络类型2g，3g，4g，wifi
	    		        	        if(networkType!='wifi'){
	    		        	        	isWifi = false;
	    		        	        	dialogAlert("提示", "您正在使用非wifi网络，观看视频将产生流量费用！");
	    		        	        }
	    		        	    }
	    		        	});
	    	            });
    				}else{
    					//APP判断网络
    					if(window.injs){
    						if(injs.currentNetworkState()!=1){
    							isWifi = false;
		        	        	dialogAlert("提示", "您正在使用非wifi网络，观看视频将产生流量费用！");
    						}
    					}
    				}
				}
			},"json");
			
			$.post("${path}/wechatUser/queryTerminalUserById.do",{userId:userId}, function(data) {
				if(data.status==0){
					var user = data.data[0];
					$("#userMobile").val(user.userMobileNo);
				}
			},"json");
			
			// 规则
			$('.delivery .detailcont .wxtis .gzcx').bind('click', function () {
				$('.delivery .derule').stop().fadeIn(300);
				$('html,body').css('overflow','hidden');
				$('.delivery .devideo video').hide();
			});
			$('.delivery .derule .zhidaol').bind('click', function () {
				$('html,body').css('overflow','visible');
				$('.delivery .derule').stop().fadeOut(300, function () {
					$('.delivery .devideo video').show();
				});
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
            
		});
		
		//投票
		function dcVote(){
			if(noVote != 1){
				if (userId == null || userId == '') {
	        		//判断登陆
	            	publicLogin("${basePath}wechatDc/index.do");
	        	}else{
	        		$.post("${path}/wechatDc/addVote.do",{userId:userId,videoId:videoId}, function (data) {
	        			if(data == "100"){
	        				$('.delivery .lptp .tp').addClass('add');
	   						var ele = $('.delivery .lptp .tp').find('span');
	   						ele.html(parseInt(ele.html()) + 1);
	   						
	   						$("#dialog4").css("display","table");
	   						$(".menban").show();
	    				}else if(data == "200"){
	    					$('.delivery .lptp .tp').addClass('add');
	    					
	   						var ele = $('.delivery .lptp .tp').find('span');
	   						ele.html(parseInt(ele.html()) + 1);
	   						
	   						$("#dialog2").css("display","table");
	   						$(".menban").show();
	    				}else if(data == "repeat"){
	    					$("#dialog3").css("display","table");
	    					$(".menban").show();
	    				}else if(data == "500"){
	    					dialogAlert('系统提示', '投票失败！');
	    				}
	    			},"json");
	        	}
			}else{
				$("#dialog5").css("display","table");
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
	</script>
	
	<style type="text/css">
		html,body{font-family:arial,\5FAE\8F6F\96C5\9ED1,\9ED1\4F53,\5b8b\4f53,sans-serif; -webkit-text-size-adjust:none;/*Google Chrome*/-webkit-tap-highlight-color: transparent;}
		img {vertical-align: middle;}
		.delivery .menban {width: 100%;height: 100%;background-color: rgba(0,0,0,0.5);position: fixed;left: 0;top: 0;z-index: 9;display: none;}
	</style>
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wxStatic/image/delivery/shareIcon.jpg"/></div>
	<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
		<img src="${path}/STATIC/wechat/image/commonShare.png" style="width: 100%;height: 100%;" />
	</div>
	<div class="delivery">
		<div class="devideo">
			<div style="height: 435px;width: 750px;overflow: hidden;position: absolute;left: 0;top: 0;"><img id="videoImgUrl" src=""></div>
			<div class="play" onclick="document.getElementById('videoUrl').play()"></div>
			<video id="videoUrl" src="" controls></video>
		</div>
		<div class="detailcont">
			<div id="videoName" class="tit">春华秋实团体汇演赛</div>
			<div class="xx">指导员：<span id="videoGuide"></span>&nbsp;&nbsp;|&nbsp;&nbsp;社区：<span id="videoActivityCenter"></span></div>
			<div style="text-align:center;margin-bottom:60px;"><img src="${path}/STATIC/wxStatic/image/delivery/pic8.png"></div>
			<div class="cont">
				<div class="ct"><span>作品简介</span></div>
				<p id="videoIntro"></p>
			</div>
			<div class="cont">
				<div class="ct"><span>团队简介</span></div>
				<div class="xiao">#<span id="videoTeamName"></span>#</div>
				<p id="videoTeamRemark"></p>
			</div>
			<div class="cont wxtis">
				<div class="wxtinc">
					<div class="bt">温馨提示：</div>
					<p>
						1.本场活动评比方式由专家评审和大众投票两部分组成；<br>
						2.专家对节目打分占总得分的80%;<br>
						3.大众投票数占总得分的20%；
					</p>
					<p style="margin-top:20px;">具体详情请点击 <span class="gzcx"></span></p>
				</div>
			</div>
			<!-- <a class="gdzp" href="${path}/wechatDc/index.do">看看其他作品</a> -->
			<div class="dgzp_div">
				<a class="gdzp" href="${path}/wechatDc/index.do">更多作品</a>
			</div>
		</div>
		<div class="lptp_wc">
			<div class="lptp clearfix">
				<div class="lp share-button"><div>支持公共文化</div></div>
				<div class="tp" onclick="dcVote();">
					<c:if test="${noVote!=1}">
						<div>投票<span id="voteCount"></span></div>
					</c:if>
					<c:if test="${noVote==1}">
						<div>投票已结束</div>
					</c:if>
					<em>+1</em>
				</div>
			</div>
		</div>
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
	    <!-- 第二次点击投票时的弹窗 -->
	    <!-- display:table;-->
	    <div id="dialog1" class="touptc">
	    	<div class="nc">
	    		<p>恭喜您，投票成功！<br>首次投票获得文化云100积分！</p>
	    		<div class="zhidl cha">X</div>
	    		<div class="touanniu">
	    			<a href="${path}/wechatDc/index.do">看看其他作品</a>
	    			<a class="hs" href="${path}/wechatDc/suggestion.do">我有话说</a>
	    		</div>
	    	</div>
	    </div>
	    <div id="dialog2" class="touptc">
	    	<div class="nc">
	    		<p>恭喜您，投票成功！<br>获得文化云1积分！</p>
	    		<div class="zhidl cha">X</div>
	    		<div class="touanniu">
	    			<a href="${path}/wechatDc/index.do">看看其他作品</a>
	    			<a class="hs" href="${path}/wechatDc/suggestion.do">我有话说</a>
	    		</div>
	    	</div>
	    </div>
	    <div id="dialog3" class="touptc">
	    	<div class="nc">
	    		<p>今天已经帮TA投过票咯<br/>太喜欢，帮他拉个票吧！</p>
	    		<div class="zhidl cha">X</div>
	    		<div class="touanniu">
	    			<a href="${path}/wechatDc/index.do">看看其他作品</a>
	    			<a class="hs" href="${path}/wechatDc/suggestion.do">我有话说</a>
	    		</div>
	    	</div>
	    </div>
	    <div id="dialog4" class="touptc" style="width:680px;padding:50px 0;">
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
	    <div id="dialog5" class="touptc">
	    	<div class="nc">
	    		<p>投票时间已结束！</p>
	    		<div class="zhidl cha">X</div>
	    	</div>
	    </div>
	    <!-- 蒙版 -->
    	<div class="menban"></div>
	</div>
</body>
</html>