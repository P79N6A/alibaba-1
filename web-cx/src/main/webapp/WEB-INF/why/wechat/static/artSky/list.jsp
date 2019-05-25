<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>佛山文化云·艺术天空</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		var enterParam = '${enterParam}';
		var ycode = '${ycode}';
		var smsCode;
		var activityId;
		
		if (userId == null || userId == '') {
    		//判断登陆
        	publicLogin('${basePath}wechatStatic/artSkyIndex.do?enterParam='+enterParam);
    	}
	
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '佛山文化云-这里是上海国际艺术节之“艺术天空”VIP票务兑换通道';
	    	appShareDesc = '近百场国际水准演出票务Y码热兑中，现在索码还有机会！';
	    	appShareImgUrl = '${basePath}/STATIC/wxStatic/image/sky/shareIcon.jpg';
	    	appShareLink = '${basePath}/wechatStatic/artSkyIndex.do?enterParam='+enterParam;
	    	
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
					title: "佛山文化云-这里是上海国际艺术节之“艺术天空”VIP票务兑换通道",
					desc: '近百场国际水准演出票务Y码热兑中，现在索码还有机会！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/sky/shareIcon.jpg',
					link: '${basePath}/wechatStatic/artSkyIndex.do?enterParam='+enterParam
				});
				wx.onMenuShareTimeline({
					title: "佛山文化云-这里是上海国际艺术节之“艺术天空”VIP票务兑换通道",
					imgUrl: '${basePath}/STATIC/wxStatic/image/sky/shareIcon.jpg',
					link: '${basePath}/wechatStatic/artSkyIndex.do?enterParam='+enterParam
				});
				wx.onMenuShareQQ({
					title: "佛山文化云-这里是上海国际艺术节之“艺术天空”VIP票务兑换通道",
					desc: '近百场国际水准演出票务Y码热兑中，现在索码还有机会！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/sky/shareIcon.jpg',
					link: '${basePath}/wechatStatic/artSkyIndex.do?enterParam='+enterParam
				});
				wx.onMenuShareWeibo({
					title: "佛山文化云-这里是上海国际艺术节之“艺术天空”VIP票务兑换通道",
					desc: '近百场国际水准演出票务Y码热兑中，现在索码还有机会！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/sky/shareIcon.jpg',
					link: '${basePath}/wechatStatic/artSkyIndex.do?enterParam='+enterParam
				});
				wx.onMenuShareQZone({
					title: "佛山文化云-这里是上海国际艺术节之“艺术天空”VIP票务兑换通道",
					desc: '近百场国际水准演出票务Y码热兑中，现在索码还有机会！',
					imgUrl: '${basePath}/STATIC/wxStatic/image/sky/shareIcon.jpg',
					link: '${basePath}/wechatStatic/artSkyIndex.do?enterParam='+enterParam
				});
			});
		}
		
		$(function () {
			$.post("${path}/wechatStatic/getActivityListByCode.do",{specialCode:ycode}, function (data) {
    			if (data.status == 1) {
    				$.each(data.data, function (i, dom) {
    					
    					var availableCount=parseInt(dom.availableCount);
    					
    					var btnClick="";
    					if(dom.isOver==1){
    						btnClick="<a class='liji hui' href='javascript:;'>停止兑换</a>";
    					}else{
    						if(availableCount<=0){
    							btnClick="<a class='liji hui' href='javascript:;'>已兑完</a>";
        					}else{
            					btnClick="<a class='liji hong' href=\"javascript:exchange('"+dom.endTimePoint+"','"+dom.activityName+"','"+dom.activityId+"');\">立即兑换</a>";
        					}
    					}
    					
    					var activityIconUrl = getIndexImgUrl(getImgUrl(dom.activityIconUrl), "_300_300");
        				$("#activityUl").append("<li>" +
    						    					"<div class='neir clearfix'>" +
    						    						"<div class='pic'><img src='"+activityIconUrl+"' width='290' height='175'><div class='skyTicketNum'>余票：<span>"+availableCount+"</span></div></div>" +
    						    						"<div class='char'>" +
    						    							"<h4>"+dom.activityName+"</h4>" +
    						    							"<p class='dz'>"+dom.activityAddress+"</p>" +
    						    							"<p class='sj'>"+dom.endTimePoint+"</p>" +
    						    						"</div>" +
    						    					"</div>" +
    						    					"<div class='skyAnniu clearfix'>" +
    						    						"<a class='xx' href='javascript:;' activityMemo='"+dom.activityMemo+"'>活动详情</a>" +
    						    						btnClick+
    						    					"</div>" +
    						    				"</li>");
    				});
    				
    				// 活动详情弹出层
    				$('.skyAnniu .xx').bind('click', function () {
    					$(".skyhdxx").html($(this).attr("activityMemo"));
    					$(".skyWhite").css({
    						"height":"800px"
    					})
    					$('.skyhei').show();
    					$('.skyhdxx_wc').show();
    				});

    				$('.skyhdxx_wc .close').bind('click', function () {
    					$(".skyWhite").css({
    						"height":"auto"
    					})
    					$('.skyhei').hide();
    					$('.skyhdxx_wc').hide();
    				});
    			}else{
    				dialogAlert('系统提示', data.msg.errmsg);
    			}
    		},"json");
			
			//分享
			$(".shareBtn").click(function() {
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
			$(".keepBtn").on("touchstart", function() {
				$('.div-share').show()
				$("body,html").addClass("bg-notouch")
			})
		});
		
		//返回首页
		function preArtSkyIndex(){
			if (userId == null || userId == '') {
	    		//判断登陆
	        	publicLogin('${basePath}wechatStatic/artSkyIndex.do?enterParam='+enterParam);
	    	}else{
	    		location.href = '${path}/wechatStatic/artSkyIndex.do?enterParam='+enterParam;
	    	}
		}
		
		//我的订单
		function preOrderList(){
			if (window.injs) {	//判断是否存在方法
                injs.accessAppPage(7, 1);
            } else {
                window.location.href = "${path}/wechatActivity/wcOrderList.do";
            }
		}
		
		//立即兑换
		function exchange(time,name,id){
			activityId = id;
			$("#exchangeText").html("您将要使用Y码兑换<span class='spanhong'>"+time+"</span>"+name+"（票务1张）");
			$('.skyhei').show();
			$('.skytan_3').hide();
			$('.skytan_4').hide();
			$('.skytan_1').show();
		}
		
		//提交
		function submitBtn(){
			var userSmsCode = $("#smsCode").val();
			if(userSmsCode!=smsCode){
				dialogAlert("提示", "请输入正确的短信验证码！");
			}else{
				$('.skyhei').show();
				$('.skytan_1').hide();
				$('.skytan_4').hide();
				$('.skytan_3').show();
			}
		}
		
		//取消兑换
		function cancelBtn(){
			$('.skyhei').hide();
			$('.skytan_3').hide();
			$('.skytan_4').hide();
			$('.skytan_1').hide();
		}
		
		//确认兑换
		function confirmExchange(){
			$(".content-bg").show();
			var data = {
				userId:userId,
				specialCode:ycode,
				activityId:activityId,
				telphone:$("#userMobile").val(),
				name:"艺术天空"
			}
			$.post("${path}/wechatStatic/changeActivity.do", data, function (data) {
				$(".content-bg").hide();
	            if(data.status == 1) {
	            	$('.skyhei').show();
	    			$('.skytan_1').hide();
	    			$('.skytan_3').hide();
	    			$('.skytan_4').show();
	            }else{
	            	pointspop('系统提示', data.msg.errmsg);
    			}
	        }, "json");
		}
		
		//发送验证码
	    function sendSms() {
	        var userMobile = $("#userMobile").val();
	        var telReg = (/^1[34578]\d{9}$/);
	        if (userMobile == "") {
	            dialogAlert('系统提示', '请输入手机号码！');
	            return false;
	        } else if (!userMobile.match(telReg)) {
	            dialogAlert('系统提示', '请正确填写手机号码！');
	            return false;
	        }
	        $.ajax({
	    		type: 'post',  
	  			url : "${path}/wechatUser/sendAuthCode.do",  
	  			dataType : 'json',  
	  			data: {userId: userId, userTelephone: userMobile},
	  			success: function (data) {
	  				if (data.status == 0) {
		                smsCode = data.data1;
		                var s = 60;
		                $("#smsCodeBut").attr("onclick", "");
		                $("#smsCodeBut").html(s + "s");
		                var ss = setInterval(function () {
		                    s -= 1;
		                    $("#smsCodeBut").html(s + "s");
		                    if (s == 0) {
		                        clearInterval(ss);
		                        $("#smsCodeBut").attr("onclick", "sendSms();");
		                        smsCode = '';
		                        $("#smsCodeBut").html("发送验证码");
		                    }
		                }, 1000)
		            }
	  			}
	        });
		}
		
		//临时弹窗（原弹窗不起作用，未解决）
	    function pointspop(title, desc) {
			$("body").append([
				"<div class='alertPop' style='position: fixed;width: 500px;height: 300px;background-color: #fff;z-index: 999;left: 0;right: 0;top: 0;bottom: 0;margin: auto;border-radius: 10px;overflow: hidden;'>" +
				"<p style='font-size: 40px;text-align: center;margin-top: 50px;'>" + title + "</p>" +
				"<p style='text-align: center;font-size: 30px;margin-top: 50px;padding: 0 20px;'>" + desc + "</p>" +
				"</div>"
			])
			setTimeout(function(){
				$(".alertPop").fadeOut();
			},2000)
			setTimeout(function(){
				$(".alertPop").remove()
			},3000)
		}

	</script>
	
	<style>
		a{color: #666666;}
		.skyzhuanqu {text-align: center;margin-bottom: 40px;}
		.skyTicketNum {
			position: absolute;
			right: 0;
			bottom: 0;
			padding: 0 20px;
			background: rgba(255, 255, 255, 0.8);
			line-height: 40px;
			font-size: 24px;
			border-top-left-radius: 10px;
		}
	</style>
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wxStatic/image/sky/shareIcon.jpg"/></div>
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
	<div class="skymain">
		<div class="skyban">
			<img src="${enterLogoImageUrl}@750w" style="height: 540px;width: 750px;">
			<ul class="skydfg clearfix">
				<li><a href="javascript:;" class="shareBtn">分享</a></li>
				<li><a href="javascript:;" class="keepBtn">关注</a></li>
			</ul>
		</div>
		<div class="skyzhuanqu"><img src="${path}/STATIC/wxStatic/image/sky/sky10.png"></div>
		<div class="skyhdlist jz702">
			<ul id="activityUl"></ul>
		</div>
	</div>
	
	<!-- 弹出框 遮罩-->
	<div class="skyhei"></div>
	
	<!-- 活动详情弹出层 -->
	<div class="skyWhite skyhdxx_wc">
	<div style="width: 565px;height: 800px;overflow-y: scroll;margin: auto;">
		<div class="skyWhite_nc">
			<div class="skyhdxx"></div>
		</div>
		</div>
		<div class="close" style="position:absolute;top:20px;right:20px;"><img src="${path}/STATIC/wxStatic/image/sky/iconImg4.png"></div>
	</div>
	
	<!-- 绑定手机号弹窗 -->
	<div class="skyWhite skytan_1">
		<div class="skyWhite_nc2">
			<div class="tantit">手机号绑定</div>
			<p>请先验证你的手机号以便于我们向您发送订票确认短信</p>
			<table class="skybdsj">
				<tr>
					<td class="td1" colspan="2">
						<input id="userMobile" class="txt txt1" type="text" placeholder="请输入手机号">
					</td>
				</tr>
				<tr>
					<td class="td1">
						<input id="smsCode" class="txt txt2" type="text" placeholder="请输入验证码">
					</td>
					<td class="td2">
						<a id="smsCodeBut" class="fsyzm lan" href="javascript:;" onclick="sendSms();">发送验证码</a>
					</td>
				</tr>
				<tr>
					<td class="td1" colspan="2">
						<input class="btn hong sjhbd" type="button" value="提  交" onclick="submitBtn()">
					</td>
				</tr>
			</table>
		</div>
		<div class="close" style="width:36px;height:36px;position:absolute;right:20px;top:20px;" onclick="cancelBtn();"><img src="${path}/STATIC/wxStatic/image/sky/iconImg4.png"></div>
	</div>
	
	<!-- 确认兑换 -->
	<div class="skyWhite skytan_3">
		<div class="skyWhite_nc2">
			<div class="tantit">确认兑换</div>
			<p id="exchangeText"></p>
			<table class="skybdsj">
				<tr>
					<td class="td1" colspan="2">
						<input class="btn lan qrdh" type="button" value="确认兑换" onclick="confirmExchange();">
					</td>
				</tr>
				<tr>
					<td class="td1" colspan="2">
						<input class="btn hong qxfh" type="button" value="取消返回" onclick="cancelBtn();">
					</td>
				</tr>
			</table>
			<p style="color:#d95353;font-size:24px;">Y码一经兑换即失效，后续您取消或者修改订单，Y码不再生效，请您谨慎确认预订信息。</p>
		</div>
	</div>
	
	<!-- 兑换成功 -->
	<div class="skyWhite skytan_4">
		<div class="skyWhite_nc2">
			<div class="tantit">兑换成功</div>
			<p>恭喜你，兑换成功！</p>
			<table class="skybdsj">
				<tr>
					<td class="td1" colspan="2">
						<input class="btn lan jxdh" type="button" value="继续兑换" onclick="preArtSkyIndex();">
					</td>
				</tr>
				<tr>
					<td class="td1" colspan="2">
						<a class="btn hong" href="javascript:preOrderList();">查看订单</a>
					</td>
				</tr>
			</table>
		</div>
	</div>
	
	<!-- 返回顶部 -->
	<div class="skyTop" style="display: block;" onclick="preArtSkyIndex();"><img src="${path}/STATIC/wxStatic/image/sky/iconImg3.png"></div>
	
	<div class="content-bg" style="display: none;width: 100%;height: 100%;position: fixed;top: 0px;z-index: 999">
	    <div style="width: 100%;height:100%;filter:alpha(Opacity=80);-moz-opacity:0.5;opacity: 0.5;background-color: #000;"></div>
	    <div style="width: 100%;height: 100%;display: table;position: absolute;top: 0px;">
	        <p style="display: table-cell;vertical-align: middle;text-align: center;color: #fff;font-size: 40px;font-weight: bold;">
	            正在为您兑换...</p>
	    </div>
	</div>
</body>
</html>