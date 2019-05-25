<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>2016春华秋实建议栏</title>
<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-dc.css?v=231231" />
<script src="${path}/STATIC/js/common.js"></script>

<script>

	//分享是否隐藏
	if(window.injs){
		//分享文案
		appShareTitle = '【建议】2016春华秋实建议栏';
    	appShareDesc = '2016上海市社区文艺指导员教学成果展演-百姓投票活动建议栏，为了我们未来越办越好……';
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
				title: "【建议】2016春华秋实建议栏",
				desc: '2016上海市社区文艺指导员教学成果展演-百姓投票活动建议栏，为了我们未来越办越好……',
				imgUrl: '${basePath}/STATIC/wxStatic/image/delivery/shareIcon.jpg'
			});
			wx.onMenuShareTimeline({
				title: "2016上海市社区文艺指导员教学成果展演-百姓投票活动建议栏，为了我们未来越办越好……",
				imgUrl: '${basePath}/STATIC/wxStatic/image/delivery/shareIcon.jpg'
			});
			wx.onMenuShareQQ({
				title: "【建议】2016春华秋实建议栏",
				desc: '2016上海市社区文艺指导员教学成果展演-百姓投票活动建议栏，为了我们未来越办越好……',
				imgUrl: '${basePath}/STATIC/wxStatic/image/delivery/shareIcon.jpg'
			});
			wx.onMenuShareWeibo({
				title: "【建议】2016春华秋实建议栏",
				desc: '2016上海市社区文艺指导员教学成果展演-百姓投票活动建议栏，为了我们未来越办越好……',
				imgUrl: '${basePath}/STATIC/wxStatic/image/delivery/shareIcon.jpg'
			});
			wx.onMenuShareQZone({
				title: "【建议】2016春华秋实建议栏",
				desc: '2016上海市社区文艺指导员教学成果展演-百姓投票活动建议栏，为了我们未来越办越好……',
				imgUrl: '${basePath}/STATIC/wxStatic/image/delivery/shareIcon.jpg'
			});
		});
	}

	$(function() {
		
		// 关闭弹窗
		$('.delivery .touptc .zhidl').bind('click', function () {
			$(this).parents('.touptc').hide();
			$(".menban").hide(0,function(){
				setTimeout(function() {
					window.location.href='${path}/wechatDc/index.do';
				},300);
				
			});
		});

	});

	function submitForm() {

		$("#suggestionSubmit").attr("onclick", "");

		var telephone = $("#telephone").val();
		var content = $("#content").val();

		if (!content||!$.trim(content)) {
			dialogAlert('系统提示', "请输入意见内容!")
			$("#suggestionSubmit").attr("onclick", "submitForm();");
			return false;
		}
		else if (content.length > 200) {
			dialogAlert('系统提示', "只能输入200字以内!")
			$("#suggestionSubmit").attr("onclick", "submitForm();");
			return false;
		}

		var isMobile = /^(?:13\d|15\d|18\d|17\d)\d{5}(\d{3}|\*{3})$/; //手机号码验证规则

		if (telephone != '' && !isMobile.test(telephone)) {

			dialogAlert('系统提示', "手机格式不正确!")

			$("#suggestionSubmit").attr("onclick", "submitForm();");
			return false; //返回一个错误，不向下执行
		}
		
		 $.post("${path}/wechatDc/createSuggestion.do",$("form").serialize(),function(data){
			  if(data=="success"){
				 
					$("#dialog1").css("display","table");
					$(".menban").show();
					
			  }else {
				
				  $("#suggestionSubmit").attr("onclick", "submitForm();");
			  }
		  });
	}
</script>
<style >
html,body{font-family:arial,\5FAE\8F6F\96C5\9ED1,\9ED1\4F53,\5b8b\4f53,sans-serif; -webkit-text-size-adjust:none;/*Google Chrome*/-webkit-tap-highlight-color: transparent;background-color: #efefef;}
img {vertical-align: middle;}
.touptc {display:none;}
	.delivery .menban {width: 100%;height: 100%;background-color: rgba(0,0,0,0.5);position: fixed;left: 0;top: 0;right:0;bottom:0;margin:auto;z-index: 9;display: none;}
</style>
</head>
<body>
<form id="form">
	<div class="delivery">

		<div class="woyouhs">
			<textarea id="content" name="content" class="shu" maxlength="500" style="height: 240px;"
				placeholder="对“2016春华秋实百姓投票活动”有任何意见或建议，请告诉我们！"></textarea>
			<input class="shu" type="text" id="telephone" name="telephone"
				placeholder="非必填项，输入手机号，方便我们回复给您！" maxlength="11"> <input
				id="suggestionSubmit" class="btn" type="button" onclick="submitForm();"
				value="提交">
		</div>
		
		<div id="dialog1" class="touptc">
	    	<div class="nc">
	    		<p style="font-size:36px;">提交成功！</p>
	    		<div class="zhidl cha">X</div>
	    	</div>
	    </div>
	    <!-- 蒙版 -->
    	<div class="menban"></div>

	</div>
</body>
</form>
</html>