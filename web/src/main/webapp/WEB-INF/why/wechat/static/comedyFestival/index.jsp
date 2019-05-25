<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·上海国际喜剧节系列活动</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css?v=1102"/>
	<script type="text/javascript" src="${path}/STATIC/wechat/js/webuploader/webuploader.min.js"></script>
	<script type="text/javascript" src="${path}/STATIC/wechat/js/webuploader/upload-comedy.js"></script>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		var startIndex = 0;		//页数
		var noControl = '${noControl}'; //1：不可操作
		var tab = '${tab}';
		if (tab == null || tab == '') {
			tab = 0;
		}
	
		//分享是否隐藏
        if(window.injs){
        	//分享文案
        	appShareTitle = '上海国际喜剧节正确打开方式：分享灿烂笑脸，赢取精美奖品~';
        	appShareDesc = '听说，一个可以分享的灿烂笑脸才是一个合格的好笑脸。别说话，看我的 ，哈哈哈';
        	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/comedy/shareIcon.jpg';
        	
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
					title: "上海国际喜剧节正确打开方式：分享灿烂笑脸，赢取精美奖品~",
					desc: '听说，一个可以分享的灿烂笑脸才是一个合格的好笑脸。别说话，看我的 ，哈哈哈',
					link: '${basePath}wechatStatic/comedyFestival.do',
					imgUrl: '${basePath}/STATIC/wxStatic/image/comedy/shareIcon.jpg'
				});
				wx.onMenuShareTimeline({
					title: "上海国际喜剧节正确打开方式：分享灿烂笑脸，赢取精美奖品~",
					imgUrl: '${basePath}/STATIC/wxStatic/image/comedy/shareIcon.jpg',
					link: '${basePath}wechatStatic/comedyFestival.do'
				});
				wx.onMenuShareQQ({
					title: "上海国际喜剧节正确打开方式：分享灿烂笑脸，赢取精美奖品~",
					desc: '听说，一个可以分享的灿烂笑脸才是一个合格的好笑脸。别说话，看我的 ，哈哈哈',
					imgUrl: '${basePath}/STATIC/wxStatic/image/comedy/shareIcon.jpg'
				});
				wx.onMenuShareWeibo({
					title: "上海国际喜剧节正确打开方式：分享灿烂笑脸，赢取精美奖品~",
					desc: '听说，一个可以分享的灿烂笑脸才是一个合格的好笑脸。别说话，看我的 ，哈哈哈',
					imgUrl: '${basePath}/STATIC/wxStatic/image/comedy/shareIcon.jpg'
				});
				wx.onMenuShareQZone({
					title: "上海国际喜剧节正确打开方式：分享灿烂笑脸，赢取精美奖品~",
					desc: '听说，一个可以分享的灿烂笑脸才是一个合格的好笑脸。别说话，看我的 ，哈哈哈',
					imgUrl: '${basePath}/STATIC/wxStatic/image/comedy/shareIcon.jpg'
				});
			});
		}
		
		$(function () {
			loadComedyList(0,20);
			
			menuChange(tab);
			
			//顶部菜单fixed
			$(document).on('scroll', function() {
				if($(document).scrollTop() > 242) {
					$(".comedy .coNav").css("position", "fixed")
				} else {
					$(".comedy .coNav").css("position", "static")
				}
			});
			$(document).on('touchmove', function() {
				if($(document).scrollTop() > 242) {
					$(".comedy .coNav").css("position", "fixed")
				} else {
					$(".comedy .coNav").css("position", "static")
				}
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
		
		//加载喜剧列表
		function loadComedyList(index, pagesize){
			var data = {
					userId:userId,
					firstResult: index,
	               	rows: pagesize
	            };
			$.post("${path}/wechatStatic/queryComedyList.do",data, function (data) {
				if(data.length<10){
        			$("#loadingComedyDiv").html("");
	        	}
				if (userId == null || userId == '') {
					$("#uploadComedy").show();
				}
				$.each(data, function (i, dom) {
					var isMeHtml = "";
					if(i==0){
						if(userId == dom.userId){
							isMeHtml = "<span class='wdxl'>我的笑脸</span>";
						}else{
							$("#uploadComedy").show();
						}
					}
					var userHeadImgHtml = '';
					if(dom.userHeadImgUrl){
		                if(dom.userHeadImgUrl.indexOf("http") == -1){
		                	dom.userHeadImgUrl = getImgUrl(dom.userHeadImgUrl);
		                }
		            }else{
		            	dom.userHeadImgUrl = '';
		            }
					if (dom.userHeadImgUrl.indexOf("http") == -1) {
		            	userHeadImgHtml = "<img src='../STATIC/wx/image/sh_user_header_icon.png' width='90' height='90'/>";
		            } else if (dom.userHeadImgUrl.indexOf("/front/") != -1) {
		                var imgUrl = getIndexImgUrl(dom.userHeadImgUrl, "_300_300");
		                userHeadImgHtml = "<img src='" + imgUrl + "' onerror='imgNoFind();' width='90' height='90'/>";
		            } else {
		            	userHeadImgHtml = "<img src='" + dom.userHeadImgUrl + "' onerror='imgNoFind();' width='90' height='90'/>";
		            }
					var ImgObj = new Image();
					ImgObj.src = dom.comedyUrl+"@300w";
					ImgObj.onload = function(){
						if(ImgObj.width/ImgObj.height>310/280){
							var pLeft = (ImgObj.width*(280/ImgObj.height)-310)/2;
							$("img[userId="+dom.userId+"]").css({"height":"280px","position":"absolute","left":"-"+pLeft+"px"});
						}else{
							var pTop = (ImgObj.height*(310/ImgObj.width)-280)/2;
							$("img[userId="+dom.userId+"]").css({"width":"310px","position":"absolute","top":"-"+pTop+"px"});
						}
					}
					$("#comedyUl").append("<li onclick=\"location.href='${path}/wechatStatic/comedyDetail.do?userId="+dom.userId+"'\">" +
											"<div class='char'>" +
												"<div class='charnc clearfix'>" +
													"<div class='tu'>"+userHeadImgHtml+"</div>" +
													"<div class='wz'><span>"+dom.tuserName+"</span></div>" +
												"</div>" +
											"</div>" +
											"<div class='pic' style='height:280px;width:310px;overflow:hidden;'>" +
												"<img userId='"+dom.userId+"' src='"+dom.comedyUrl+"@300w'>" +
												"<a class='fx' href='javascript:;'>分享</a>" +
												isMeHtml +
											"</div>" +
										 "</li>");
				});
			},"json");
		}
		
		//前往留资页
		function toUserInfo(){
			if(noControl != 1){
				if (userId == null || userId == '') {
					//判断登陆
			    	publicLogin('${basePath}wechatStatic/comedyFestival.do');
				}else{
					// 首页
					$('.comedy .cosy').hide();
					// 留资页
					$('.comedy .joinAct').show();
				}
			}else{
				dialogAlert('系统提示', '活动已结束！');
			}
		}
		
		//保存用户
		function userInfo(){
			if(noControl != 1){
				if (userId == null || userId == '') {
					//判断登陆
			    	publicLogin('${basePath}wechatStatic/comedyFestival.do?tab=3');
				}else{
					var userName = $("#userName").val();
					if(userName == ""){
				    	dialogAlert('系统提示', '请输入姓名！');
				        return false;
				    }
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
						userName:userName,
						userMobile:userMobile,
						userId:userId
					}
					$.post("${path}/wechatStatic/saveOrUpdateCcpComedy.do",data, function (data) {
		    			if (data == "200") {
		    				// 留资页
		    				$('.comedy .joinAct').hide();
		    				// 传照片
		    				$('.comedy .bcTakePhoto').show();
		    			}else{
		    				dialogAlert('系统提示', "提交失败！");
		    			}
		    		},"json");
				}
			}else{
				dialogAlert('系统提示', '活动已结束！');
			}
		}
		
		//保存用户上传图片
		function userUploadImg(){
			if(noControl != 1){
				if (userId == null || userId == '') {
					//判断登陆
			    	publicLogin('${basePath}wechatStatic/comedyFestival.do?tab=4');
				}else{
					var userUploadImg = $("#userUploadImg").val();
					if(userUploadImg == ""){
				    	dialogAlert('系统提示', '请上传图片！');
				        return false;
				    }
					var data = {
						comedyUrl:userUploadImg,
						userId:userId
					}
					$.post("${path}/wechatStatic/saveOrUpdateCcpComedy.do",data, function (data) {
						if (data == "200") {
		    				dialogConfirm('系统提示', "提交成功！",function(){
		    					location.href = '${path}/wechatStatic/comedyFestival.do';
		    				});
		    			}else{
		    				dialogAlert('系统提示', "提交失败！");
		    			}
		    		},"json");
				}
			}else{
				dialogAlert('系统提示', '活动已结束！');
			}
		}
		
		//进页面菜单显示
		function menuChange(num) {
			if(num>2){
				$('.comedy .coNav li').removeClass('current');
				$('.comedy .coNav li').eq(0).addClass('current');
				$('.comedy .cocont_wc .cocont').hide();
				$('.comedy .cocont_wc .cocont').eq(0).show();
			}else{
				$('.comedy .coNav li').removeClass('current');
				$('.comedy .coNav li').eq(num).addClass('current');
				$('.comedy .cocont_wc .cocont').hide();
				$('.comedy .cocont_wc .cocont').eq(num).show();
			}

			if(num==0){
				// 首页
				$('.comedy .cosy').show();
				// 留资页
				$('.comedy .joinAct').hide();
				// 传照片
				$('.comedy .bcTakePhoto').hide();
			}else if(num==3){
				// 首页
				$('.comedy .cosy').hide();
				// 留资页
				$('.comedy .joinAct').show();
				// 传照片
				$('.comedy .bcTakePhoto').hide();
			}else if(num==4){
				// 首页
				$('.comedy .cosy').hide();
				// 留资页
				$('.comedy .joinAct').hide();
				// 传照片
				$('.comedy .bcTakePhoto').show();
			}
		}
		
		//滑屏分页
        $(window).on("scroll", function () {
            var scrollTop = $(document).scrollTop();
            var pageHeight = $(document).height();
            var winHeight = $(window).height();
            if (scrollTop >= (pageHeight - winHeight - 40)) {
           		setTimeout(function () { 
      				startIndex += 20;
              		var index = startIndex;
              		loadComedyList(index,20);
           		},800);
            }
        });
	</script>
	
	<style type="text/css">
		* {-webkit-tap-highlight-color: transparent;}
		html,body {
			font-family: arial, \5FAE\8F6F\96C5\9ED1, \9ED1\4F53, \5b8b\4f53, sans-serif;
			-webkit-text-size-adjust: none;
		}
		html,body,.comedy {min-height: 100%;}
		img {
			vertical-align: middle;
		}
		.webuploader-element-invisible {
			display: none;
		}
		
		.bcUpPhoto>div:nth-last-child(2) {
			width: 700px;
			height: 700px;
		}
		.comedy .bcSharePageDiv {display: none;}
	</style>
	
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wxStatic/image/comedy/shareIcon.jpg"/></div>
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
	<div class="comedy">
		<div class="coban">
			<img src="${path}/STATIC/wxStatic/image/comedy/ban1.jpg" width="750" height="250">
			<ul class="lccshare clearfix">
				<li class="share-button"><a href="javascript:;">分享</a></li>
				<li class="keep-button"><a href="javascript:;">关注</a></li>
			</ul>
		</div>
		<div class="coNav_wc">
			<ul class="coNav clearfix">
				<li><a href="${path}/wechatStatic/comedyFestival.do">最美笑脸</a></li>
				<li><a href="${path}/wechatStatic/comedyFestival.do?tab=1">活动规则</a></li>
				<li><a href="http://ct.wenhuayun.cn/template/activityTopicDetail.do?topicid=24">喜剧节</a></li>
			</ul>
		</div>
		<div class="cocont_wc">
			<div class="cocont cozmxl">
				<!-- 首页 -->
				<div class="cosy jz670" style="display: none;">
					<div class="tit"><img src="${path}/STATIC/wxStatic/image/comedy/pic1.jpg"></div>
					<p>　　第二届“上海国际喜剧节将以“喜剧，就是生活”为主题，再次掀起“全民狂欢”的快乐热浪，涵盖喜剧精品展演，即兴喜剧周、喜剧街头展演秀、喜剧国际专业论坛等精彩活动。现在就上传笑脸，分享欢乐，即可赢取喜剧节定制T恤喔！</p>
					<div style="border-top: 1px solid #262626;border-bottom: 2px solid #262626;height: 4px;margin-top:36px;"></div>
					<ul id="comedyUl" class="colistul clearfix"></ul>
					<div id="loadingComedyDiv" class="loadingDiv"><img class="loadingImg" src="${path}/STATIC/wechat/image/loading.gif" /><span class="loadingSpan">加载中。。。</span><div style="clear:both"></div></div>
					<a id="uploadComedy" class="shcxl" href="javascript:toUserInfo();" style="display: none;"></a>
				</div>
				<!-- 留资页 -->
				<div class="joinAct" style="display: none;">
					<p style="text-align: center;font-size: 32px;">#&nbsp;上传我的笑脸&nbsp;#</p>
					<p style="text-align: center;font-size: 24px;margin-top: 20px;color:#808080;">请先留下你的个人资料</p>
					<div class="userInfoInput">
						<div class="bcUserName">
							<span class="inputTitle">姓名</span><input id="userName" type="text" class="inputText" maxlength="20">
						</div>
						<div class="bcUserPhone">
							<span class="inputTitle">手机</span><input id="userMobile" type="text" class="inputText" maxlength="20">
						</div>
						<p style="width: 580px;margin: auto;font-size: 18px;margin-top: 30px;">
							1.参与活动，上传我的笑脸，即可当即获得500文化云积分<br />
							2.每个用户只可上传一次照片，请精心选择你最美的笑脸参加喔<br />
							3.请正确填写你的姓名与联系方式，以便我们与你取得联系
						</p>
						<div class="nextBtn" onclick="userInfo();">下一步</div>
					</div>
				</div>
				<!-- 传照片 -->
				<div class="bcTakePhoto" style="display: none;">
					<div class="bcUpPhotoDiv">
						<input type="hidden" id="userUploadImg"/>
						<div class="bcUpPhoto uploadClass" style="width: 700px;height: 700px;background-color: #7c7c7c;">
							<img id="upPhoto" src="${path}/STATIC/wxStatic/image/comedy/pic5.jpg" style="max-height: 700px;max-width: 700px;display: block;margin: auto;position: absolute;left:0;top:0;right:0;bottom:0; "/>
						</div>
					</div>
					<div class="bcSubmit" onclick="userUploadImg();">发&nbsp;布</div>
				</div>
			</div>
			<!-- 规则 -->
			<div class="cocont cohdgz jz700">
				<div class="hdgznc">
					<div class="jinhtit">
						<em style="left: 110px;">#</em><em style="right: 110px;">#</em>
						上海国际喜剧节<span>活动规则</span>
					</div>
					<div style="border-top:1px solid #262626;margin:40px 0;"></div>
					<div class="neir clearfix">
						<div class="nr_1">1.</div>
						<div class="nr_2">参与活动，上传我的笑脸，即可当即获得500文化云积分；</div>
					</div>
					<div class="neir clearfix">
						<div class="nr_1">2.</div>
						<div class="nr_2">每个用户只可上传一次照片，请精心选择你最美的笑脸参加喔;</div>
					</div>
					<div class="neir clearfix">
						<div class="nr_1">3.</div>
						<div class="nr_2">上传笑脸之后，转发至微信朋友圈，即可获得一个抽奖码;</div>
					</div>
					<div class="neir clearfix">
						<div class="nr_1">4.</div>
						<div class="nr_2">我们会在12月12日从所有抽奖码中，抽出20名用户获得喜剧节定制T恤每人1件；</div>
					</div>
					<div class="neir clearfix">
						<div class="nr_1">5.</div>
						<div class="nr_2">活动名单会在文化云微信公众平台上公布，请提前关注文化云官方微信公众号；</div>
					</div>
					<div class="neir clearfix">
						<div class="nr_1">6.</div>
						<div class="nr_2">参与用户应对上传照片负法律责任，未经本人允许,随意上传他人私人照片所产生的一切责任由提交者自负。主办方有权对侵权或违规照片做删除处理，并取消参赛者资格，保留追究法律责任的权利；</div>
					</div>
					<div class="neir clearfix">
						<div class="nr_1">7.</div>
						<div class="nr_2">本次活动最终解释权归文化云所有。</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>