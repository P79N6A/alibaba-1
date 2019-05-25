<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>个人设置</title>
<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wx/css/mc-mobile.css" />
<script type="text/javascript" src="${path}/STATIC/wx/js/mc-mobile.js"></script>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/webuploader.css"/>
<script type="text/javascript" src="${path}/STATIC/wechat/js/webuploader/webuploader.min.js"></script>
<script type="text/javascript" src="${path}/STATIC/wechat/js/webuploader/upload-userSetting.js"></script>

<script type="text/javascript">

	if (userId ==null || userId == '') {
	    window.location.href = "${path}/muser/login.do";
	}

	$(function(){
		
		//性别修改
        $("body").on("click",".sex_sel label",function(){
			$(this).addClass("cur").siblings().removeClass("cur");
			var vals=$(this).find("span").text();
			var data = {};
			if(vals=='男'){
				data = {userId:userId,userSex:1};
			}
			if(vals=='女'){
				data = {userId:userId,userSex:2};
			}
			$.ajax({
	    		type: 'post',  
	  			url : "${path}/wechatUser/editTerminalUser.do",  
	  			dataType : 'json',  
	  			data: data,
	  			success: function (data) {
					if(data.status==0){
						$("#set_sex").text(vals);
				  		$(this).parents(".sex_blocks").hide();
				  		$(".fixSbg").hide();
					}
				}
			});
     	});
        
        loadUser();
	});

	//加载用户数据
	function loadUser(){
		$.ajax({
    		type: 'post',  
  			url : "${path}/wechatUser/queryTerminalUserById.do",  
  			dataType : 'json',  
  			data: {userId: userId},
  			success: function (data) {
				if(data.status==0){
					var user = data.data[0];
					$("#set_name").html(user.userName);
					if(user.userHeadImgUrl.indexOf("http") == -1){
						$("#userHeadImgUrl").attr("src",'../STATIC/wx/image/sh_user_header_icon.png');
					}else if(user.userHeadImgUrl.indexOf("/front/") != -1){
						var imgUrl = getIndexImgUrl(user.userHeadImgUrl, "_300_300");
						$("#userHeadImgUrl").attr("src",imgUrl);
					} else {
						$("#userHeadImgUrl").attr("src",user.userHeadImgUrl);
					}
					if(user.userSex==1){
						$("#set_sex").html("男");
					}else if(user.userSex==2){
						$("#set_sex").html("女");
					}else{
						$("#set_sex").html("男");
					}
					if(user.userTelephone==''){
						if(user.userMobileNo==''){
							$("#set_phone").html("未填写");
						}else{
							$("#set_phone").html(user.userMobileNo);
						}
					}else{
						$("#set_phone").html(user.userTelephone);
					}
					if(user.registerOrigin==2 || user.registerOrigin==3 || user.registerOrigin==4){
						$("#setPhone").attr("onclick","createDialog($(this),alerta);");
					}else{
						$("#setPhone").css("background","none");
						$("#editPassLi").show();
					}
				}
  			}
		});
	}
	
	//上传头像
	function uploadImg(){
		//判断是否是微信浏览器打开
        if (!is_weixin()) {
            dialogAlert('系统提示', '请用微信浏览器打开！');
            return;
        }
		
		if (userId ==null || userId == '') {
            window.location.href = "${path}/muser/login.do?type=${basePath}wechatUser/preUserSetting.do";
            return;
        }
		
		wx.chooseImage({
			count: 1,	// 默认9
	    	sizeType: ['compressed'],	// 指定是原图还是压缩图，默认二者都有
		    success: function (res) {
		        var localIds = res.localIds; // 返回选定照片的本地ID列表，localId可以作为img标签的src属性显示图片
		        wx.uploadImage({
		            localId: localIds[0], // 需要上传的图片的本地ID，由chooseImage接口获得
		            isShowProgressTips: 1, // 默认为1，显示进度提示
		            success: function (res) {
		                var serverId = res.serverId; // 返回图片的服务器端ID
		                $.post("${path}/wechat/wcUpload.do",{mediaId:serverId,userId:userId,uploadType:3}, function(data) {
		                	if(data!=1){
		                		$.ajax({
		            	    		type: 'post',  
		            	  			url : "${path}/wechatUser/editTerminalUser.do",  
		            	  			dataType : 'json',  
		            	  			data: {userId:userId,userSex:0,userHeadImgUrl:data},
		            	  			success: function (data) {
			            				if(data.status==0){
			            					$("#userHeadImgUrl").attr("src",localIds[0]);
			            				}
		            	  			}
		                		});
		                	}else{
		                		dialogAlert('系统提示', '上传失败！');
		                	}
		                },"json");
		            }
		        });
		    }
		});
	}
	
	function outLogin(){
		dialogConfirm('系统提示', '确定要退出系统？',function(r){
			window.location.href='${path}/muser/outLogin.do';
		});
	}
	
	//保存按钮（昵称、电话）
	function alerta(){
		var vals=$(".dialog_set").find("input").val();
		var Id=$(".dialog_set").find("input").attr("name");
		var data = {};
		if(Id=='set_name'){
			var nameReg = (/^[a-zA-Z0-9\u4e00-\u9fa5]+$/);
			if(vals ==""){
		    	dialogAlert('系统提示', '请输入昵称！');
		        return false;
		    }
			if(vals.length>20){
				dialogAlert('系统提示', '昵称不得超过20字！');
				return false;
			}
			if(!vals.match(nameReg)){
		    	dialogAlert('系统提示', '昵称只能由中文，字母，数字组成！');
		        return false;
		    }
			data = {userId:userId,userSex:0,userName:vals};
		}
		if(Id=='set_phone'){
		    var telReg = (/^1[34578]\d{9}$/);
		    if(vals ==""){
		    	dialogAlert('系统提示', '请输入手机号码！');
		        return false;
		    }else if(!vals.match(telReg)){
		    	dialogAlert('系统提示', '请正确填写手机号码！');
		        return false;
		    }
			data = {userId:userId,userSex:0,userTelephone:vals};
		}
		$.ajax({
    		type: 'post',  
  			url : "${path}/wechatUser/editTerminalUser.do",  
  			dataType : 'json',  
  			data: data,
  			success: function (data) {
				if(data.status==0){
					$("#"+Id).text(vals);
					$(".dialog_set").remove();
					$(".fixbg").remove();
				}
  			}
		});
	}
	
	function toSetPass(){
		location.href = '${path}/muser/preSetPass.do?type=${basePath}wechat/index.do';
	}
</script>

<style>
	.content{padding-bottom: 0px;}
</style>

</head>
<body>
	<input id="userId" type="hidden" value="${sessionScope.terminalUser.userId}"/>
	<div class="main">
		<div class="content">
			<div class="personal-set">
				<p>头像</p>
				<div class="personal-set-rbt" ontouchstart="uploadImg();">
					<img src="${path}/STATIC/wechat/image/arrow_right.png" />
					<p class='progress'><span></span></p>
				</div>
				<div class="personal-set-head">
					<div class="personal-set-head-bg"></div>
					<img id="userHeadImgUrl" width="200" height="200" onerror="imgNoFind();"/>
				</div>
				<div style="clear: both;"></div>
			</div>
			<div class="personal-p1">
				<ul>
					<li class="border-bottom">
						<div class="personal-p1-bg" onClick="createDialog($(this),alerta);">
							<label>昵称</label>
							<span class="rig" id="set_name" tip="昵称"></span>
							<div style="clear: both;"></div>
						</div>
					</li>
					<li class="border-bottom">
						<div class="personal-p1-bg set_sex">
							<label>性别</label>
							<span class="rig" id="set_sex"></span>
							<div style="clear: both;"></div>
						</div>
					</li>
					<li class="border-bottom">
						<div class="personal-p1-bg" id="setPhone">
							<label>手机</label>
							<span class="rig" id="set_phone" tip="手机号"></span>
							<div style="clear: both;"></div>
						</div>
					</li>
				</ul>
			</div>
			<div class="personal-p3">
				<ul>
					<li class="border-bottom" id="editPassLi" style="display: none;">
						<div class="personal-p3-bg" onclick="toSetPass();">
							<label>修改密码</label>
							<span>修改</span>
							<div style="clear: both;"></div>
						</div>
					</li>
					<li>
						<div class="personal-p3-bg" onclick="outLogin();">
							<p>退出登录</p>
						</div>
					</li>
				</ul>
			</div>
		</div>
	</div>
	<div class="sex_blocks">
	  <div class="til">性别</div>
	  <div class="sex_sel">
	      <label for="nan"><span>男</span><input id="nan" name="sex" type="radio"/></label>
	      <label for="nv"><span>女</span><input id="nv" name="sex" type="radio"/></label>
	  </div>
	</div>
	<div class="fixSbg"></div>
	
	<script>
	
		//判断是否是微信浏览器打开
	    if (is_weixin() && browser.versions.ios) {
	
	    	//通过config接口注入权限验证配置
	        wx.config({
	            debug: false,
	            appId: '${sign.appId}',
	            timestamp: '${sign.timestamp}',
	            nonceStr: '${sign.nonceStr}',
	            signature: '${sign.signature}',
	            jsApiList: ['chooseImage','uploadImage']
	        });
	    }else{
			$(".personal-set-rbt").addClass("uploadClass");
			$(".personal-set-rbt").attr("ontouchstart","");
		}
		
	</script>
</body>
</html>