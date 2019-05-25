<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>实名认证</title>
<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
<script type="text/javascript" src="${path}/STATIC/js/common.js"></script>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style${empty sourceCode?'':sourceCode}.css"/>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/webuploader.css"/>
<script type="text/javascript" src="${path}/STATIC/wechat/js/webuploader/webuploader.min.js"></script>
<script type="text/javascript" src="${path}/STATIC/wechat/js/webuploader/upload-auth.js"></script>
		
<script>
	//分享是否隐藏
	if (is_weixin()) {
	    //通过config接口注入权限验证配置
	    wx.config({
	        debug: false,
	        appId: '${sign.appId}',
	        timestamp: '${sign.timestamp}',
	        nonceStr: '${sign.nonceStr}',
	        signature: '${sign.signature}',
	        jsApiList: ['hideAllNonBaseMenuItem']
	    });
	    wx.ready(function () {
	    	wx.hideAllNonBaseMenuItem();
	    });
	}

	//分享是否隐藏
	if(window.injs){
		injs.setAppShareButtonStatus(false);
	}

	function sendCode()
	{
		var userTelephone=$("#userTelephone").val();
		
		var telReg = (/^1[34578]\d{9}$/);
		
		if(userTelephone == ""){
	    	dialogAlert('系统提示', '请输入手机号码！');
	        return false;
	    }else if(!userTelephone.match(telReg)){
	    	dialogAlert('系统提示', '请正确填写手机号码！');
	        return false;
	    }
		
		$.ajax({
    		type: 'post',  
  			url : "${path}/wechatUser/sendAuthCode.do",  
  			dataType : 'json',  
  			data: {userId: userId, userTelephone: userTelephone},
  			success: function (data) {
  				if(data.status==0){
  	    			var s = 60;
  	    			$("#smsCodeBut").attr("onclick","");
  	    			$("#smsCodeBut").html(s+"s");
  	    			var ss = setInterval(function() {
  	    				s -= 1;
  	    				$("#smsCodeBut").html(s+"s");
  	    				if (s == 0) {
  	    					clearInterval(ss);
  	    					$("#smsCodeBut").attr("onclick","sendCode();");
  	    					$("#smsCodeBut").html("发送验证码");
  	    					return;
  	    				}
  	    			}, 1000)
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
			//判断登陆
        	publicLogin("${basePath}wechatUser/auth.do");
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
		                $.post("${path}/wechat/wcUpload.do",{mediaId:serverId,userId:userId,uploadType:2}, function(data) {
		                	if(data!=1){
		                		var imgUrl = getImgUrl(data);
		                		$("#idCardPhotoUrl").val(imgUrl);
		                		$("#idCardPhotoImg").attr("src",getIndexImgUrl(imgUrl,"_150_150"));
		                	}else{
		                		dialogAlert('系统提示', '上传失败！');
		                	}
		                },"json");
		            }
		        });
		    }
		});
	}
	
	function next()
	{
		if (userId ==null || userId == '') {
          	//判断登陆
        	publicLogin("${basePath}wechatUser/auth.do");
        }else{
        	
        	var nickName = $("#nickName").val();
    		if(!nickName){
    			dialogAlert('提示', '姓名不能为空！');
    			return;
    		}
    		var nameReg = (/^[a-zA-Z0-9\u4e00-\u9fa5]+$/);
        	if(!nickName.match(nameReg)){
		    	dialogAlert('提示', '姓名只能由中文，字母，数字组成！');
		        return false;
		    }
        	
        	var userTelephone=$("#userTelephone").val();
    		
    		var telReg = (/^1[34578]\d{9}$/);
    		
    		if(userTelephone == ""){
    	    	dialogAlert('系统提示', '请输入手机号码！');
    	        return false;
    	    }else if(!userTelephone.match(telReg)){
    	    	dialogAlert('系统提示', '请正确填写手机号码！');
    	        return false;
    	    }
    		
    		var code=$("#code").val();
    		
    		if(!code){
    			dialogAlert('提示', '验证码不能为空！');
    			return;
    		}
    		
    		var idCardNo=$("#userCardNo").val();
    		
    		var reg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;
			if(!reg.test(idCardNo)){
				dialogAlert('提示', "身份证不合法!");
				return  false;
			}
    		
			var userEmail=$("#userEmail").val();
    		
    		if(!userEmail){
    			dialogAlert('提示', '邮件不能为空！');
    			return;
    		}
    		
    		var regMail= /^[a-zA-Z0-9]+([\._\-]*[a-zA-Z0-9])*@([a-zA-Z0-9]+[-a-zA-Z0-9]*[a-zA-Z0-9]+\.){1,63}[a-zA-Z0-9]+$/;
    		
    		 if (!regMail.test(userEmail))
    		{
    			dialogAlert('提示', '电子邮箱格式不正确！');
    			return;
    		}
    		
    		var idCardPhotoUrl = $("#idCardPhotoUrl").val();
    		if(!idCardPhotoUrl&&'${user.idCardPhotoUrl}'==''){
    			dialogAlert('提示', '请上传身份证照片');
    			return;
    		}
    		
    		var data={userId:userId,nickName:nickName,userTelephone:userTelephone,code:code,userEmail:userEmail,idCardNo:idCardNo,idCardPhotoUrl:idCardPhotoUrl};
    		
    		$.post("${path}/wechatUser/userAuth.do",data, function(data) {
    			
    			if(data.status==0){

    				var tuserIsDisplay=$("#tuserIsDisplay").val();
    				
    				var roomOrderId=$("#roomOrderId").val();
    				
    				var tuserId=$("#tuserId").val();
    				
    				var ua = navigator.userAgent.toLowerCase();	
    				
    				subDialog(tuserIsDisplay,roomOrderId,tuserId,ua);
    			}else {
    				dialogAlert('提示', data.data);
    			}
    		},"json");
        }
	}
	
	//认证提示
    function subDialog(tuserIsDisplay,roomOrderId,tuserId,ua) {
        var winW = Math.min(parseInt($(window).width() * 0.82), 370);
        var d = dialog({
            width: winW,
            title: '提示',
            content: '提交成功',
            fixed: true,
            button: [{
                value: '确定',
                callback: function () {
                	
                	if(!tuserIsDisplay && !roomOrderId){
    		        	if (/wenhuayun/.test(ua)) {		//APP端
    		        		if (window.injs) {	//判断是否存在方法
    		    				injs.accessAppPage(6,'');
    		    			}else{
    		    				location.href = 'com.wenhuayun.app://usercenter';
    		    			}
    		        	}else{	//H5
    		        		if("${callback}"){
    		        			location.href = '${callback}wechatUser/preTerminalUser.do';
    		        		}else{
    		        			location.href = '${path}/wechatUser/preTerminalUser.do';
    		        		}
    		        	}
    				}else if(tuserIsDisplay=="0"){
    					location.href = '${path}/wechatRoom/authTeamUser.do?roomOrderId='+roomOrderId+'&userId='+userId+'&tuserId='+tuserId+'&type=${type}&callback=${callback}&sourceCode=${sourceCode}';
    				}else{
    					if (/wenhuayun/.test(ua)) {		//APP端
    						if (window.injs) {	//判断是否存在方法
    		    				injs.accessAppPage(7,0);
    		    			}else{
    		    				location.href = 'com.wenhuayun.app://orderlist';
    		    			}
    		        	}else{		//H5
    		        		location.href = "${path}/wechatActivity/wcOrderList.do?userId="+userId+"&callback=${callback}&sourceCode=${sourceCode}";
    		        	}
    				}
                }
            }]
        });
        d.showModal();
    }
	 
</script>
<style>
	.p3-font{float: none;}
</style>
</head>
<body>
	<form action="">
		<div class="main">
			<div class="header">
				<%-- <div class="index-top">
					<span class="index-top-5">
						<img src="${path}/STATIC/wechat/image/arrow1.png"  onclick="history.go(-1);"/>
					</span>
					<span class="index-top-2">实名认证</span>
				</div> --%>
				
				<input type="hidden" id="userId" name="userId" value="${user.userId }"/>
				<input type="hidden" id="tuserName" name="tuserName" value="${tuserName }"/>
				<input type="hidden" id="tuserIsDisplay" name="tuserIsDisplay" value="${tuserIsDisplay }"/>
				<input type="hidden" id="roomOrderId" name="roomOrderId" value="${roomOrderId }"/>
				<input type="hidden" id="userType" name="userType" value="${userType }"/>	
				<input type="hidden" id="tuserId" name="tuserId" value="${tuserId }"/>	
			</div>
			<div class="content padding-bottom0 margin-bottom100">
				<div class="certification bgfff fs30">
					<ul>
						<li>
							<div class="w100 p2-font f-left">
								<p class="w2">姓名</p>
							</div>
							<span class="f-left" style="margin: 0px 10px;">:</span>
							<c:choose>
								<c:when test="${userType!=2 }">
								<input class="f-left" placeholder="请输入真实姓名" type="text" name="nickName" id="nickName" value="${user.userNickName}" />
								</c:when>
								<c:otherwise>
								<span class="f-left">${user.userNickName}</span>
								</c:otherwise>
							</c:choose>
							<div style="clear: both;"></div>
						</li>
						<li>
							<div class="w100 p2-font f-left">
								<p class="w2">手机</p>
							</div>
							<span class="f-left" style="margin: 0px 10px;">:</span>
							<c:choose>
								<c:when test="${userType!=2 }">
								<input class="f-left" placeholder="请输入手机号" type="text" value="${user.userTelephone}" id="userTelephone" name="userTelephone" maxlength="11"/>
								</c:when>
								<c:otherwise>
								<span class="f-left">${user.userTelephone}</span>
								</c:otherwise>
							</c:choose>
							<div style="clear: both;"></div>
						</li>
						<c:if test="${userType!=2 }">
						<li>
							<div class="w100 p2-font f-left">
								<p class="w3">验证码</p>
							</div>
							<span class="f-left" style="margin: 0px 10px;">:</span>
							<input class="f-left" style="width: 240px;" placeholder="请输入6位验证码" type="text" name="code" id="code" value="" />
							<button id="smsCodeBut" class="certification-send f-right" type="button" onclick="sendCode();">发送验证码</button>
							<div style="clear: both;"></div>
						</li>
						</c:if>
						<li>
							<div class="w100 p2-font f-left">
								<p class="w2">邮箱</p>
							</div>
							<span class="f-left" style="margin: 0px 10px;">:</span>
							<c:choose>
								<c:when test="${userType!=2 }">
								<input class="f-left" placeholder="请输入邮箱地址" type="text" name="userEmail" id="userEmail" value="${user.userEmail}" class="w500"/>
								</c:when>
								<c:otherwise>
								<span class="f-left">${user.userEmail}</span>
								</c:otherwise>
							</c:choose>
							<div style="clear: both;"></div>
						</li>
					</ul>
				</div>
				<div class="certification bgfff fs30 margin-top20 padding-top20">
					<div class="border-bottom padding-bottom20">
						<p class="f-left">身份证号：</p>
						<c:choose>
							<c:when test="${userType!=2 }">
							<input placeholder="请输入身份证号" style="border: none;margin-top: 5px;" class="f-left c808080 w500" type="text" name="userCardNo" id="userCardNo" value="${user.userCardNo }" />
							</c:when>
							<c:otherwise>
							<span class="f-left c808080">${user.userCardNo}</span>
							</c:otherwise>
						</c:choose>																	
									
						<div style="clear: both;"></div>
					</div>
					<div class="padding-bottom20 padding-top20">
						<p>身份证照片：</p>
						<div class="margin-top20">
							<c:if test="${userType!=2 }">
							<p class="f-left fs24">示例：</p>
							<div class="f-left">
								<img src="${path}/STATIC/wechat/image/pic1.jpg" alt="" width="330px" height="160px" />
								<p class="c6771a7 fs24">1.身份证上的信息清晰可见</p>
								<p class="c6771a7 fs24">2.身份证号码必须清晰可识别</p>
								<p class="c6771a7 fs24">3.大小不超过2M像素</p>
							</div>
							</c:if>
							<div class="f-left margin-left50 add-pic-list" >
								<ul class="user-upl margin-top20"></ul>
								<c:if test="${not empty user.idCardPhotoUrl}">
									<img id="idCardPhotoImg" src="" alt="" width="220px" height="156"/>
									<script>
										var url = getImgUrl('${user.idCardPhotoUrl}');
								    	var imgUrl = getIndexImgUrl(url,"_150_150");
								    	$("#idCardPhotoImg").attr("src",imgUrl);
								    	$("#idCardPhotoUrl").val(url);
									</script>
								</c:if>
								<c:if test="${empty user.idCardPhotoUrl}">
									<img id="idCardPhotoImg" src="${path}/STATIC/wechat/image/pic2.jpg" alt="" width="220px" height="156"/>
								</c:if>
								<c:if test="${userType!=2 }">
								<p class='progress'><span></span></p>
								<input type="hidden" id="idCardPhotoUrl" value=""/>
								<div ontouchstart="uploadImg();" class="add-pic-button">
									<button  type="button" style="border: none;border-radius: 8px;margin: 30px auto 0px auto;" class="fs30 bg7279a0 w220 h80 cfff ">上传照片</button>
								</div>
								</c:if>
							</div>
							<div style="clear: both;"></div>
						</div>
					</div>
				</div>
			</div>
			<c:if test="${userType!=2 }">
			<div class="footer">
				<button style="border: none;" onclick="next();" type="button" class="w100-pc height100 fs30 bg7279a0 cfff">
				<c:choose>
					<c:when test="${tuserIsDisplay==0 }">
					下一步
					</c:when>
					<c:otherwise>
						提交
					</c:otherwise>
				</c:choose>
				</button>
			</div>
			</c:if>
		</div>
	</form>
</body>
<script>

	var userId = '${user.userId}';

	//判断是否是微信浏览器打开
	if (is_weixin() && browser.versions.ios) {
	    //通过config接口注入权限验证配置
	    wx.config({
	        debug: false,
	        appId: '${sign.appId}',
	        timestamp: '${sign.timestamp}',
	        nonceStr: '${sign.nonceStr}',
	        signature: '${sign.signature}',
	        jsApiList: ['chooseImage','uploadImage','previewImage']
	    });
	}else{
		$(".add-pic-button").addClass("uploadClass");
		$(".add-pic-button").attr("ontouchstart","");
	}
</script>
</html>