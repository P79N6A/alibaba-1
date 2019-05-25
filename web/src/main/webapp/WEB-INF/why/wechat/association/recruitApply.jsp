<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>我想入驻文化云大咖圈</title>
    <%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
    <%-- <%@include file="/WEB-INF/why/common/aliImageFrame.jsp"%> --%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/common.js"></script>
    <!--阿里上传插件-->
		<script type="text/javascript" src="${path}/STATIC/ossjs/crypto.js"></script>
		<script type="text/javascript" src="${path}/STATIC/ossjs/hmac.js"></script>
		<script type="text/javascript" src="${path}/STATIC/ossjs/sha1.js"></script>
		<script type="text/javascript" src="${path}/STATIC/ossjs/base64.js"></script>
		<script type="text/javascript" src="${path}/STATIC/ossjs/plupload.full.min.js"></script>
		<script type="text/javascript" src="${path}/STATIC/ossjs/upload.js"></script>
		<script type="text/javascript" src="${path}/STATIC/ossjs/uuid.js"></script>
		<link rel="stylesheet" href="${path}/STATIC/ossjs/aliUploadStyle.css" />

    <script>
        
      	//分享是否隐藏
        if(window.injs){
        	//分享文案
        	appShareTitle = '文化云大咖圈，精彩连连看';
        	appShareDesc = '众多活跃文艺团体、匠人济济一堂';
        	appShareImgUrl = '${basePath}/STATIC/wx/image/share_120.png';
        	
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
                    title: "文化云大咖圈，精彩连连看",
                    desc: '众多活跃文艺团体、匠人济济一堂',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareTimeline({
                    title: "众多活跃文艺团体、匠人济济一堂",
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareQQ({
                	title: "文化云大咖圈，精彩连连看",
                	desc: '众多活跃文艺团体、匠人济济一堂',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareWeibo({
                	title: "文化云大咖圈，精彩连连看",
                	desc: '众多活跃文艺团体、匠人济济一堂',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
                wx.onMenuShareQZone({
                	title: "文化云大咖圈，精彩连连看",
                	desc: '众多活跃文艺团体、匠人济济一堂',
                    imgUrl: '${basePath}/STATIC/wx/image/share_120.png'
                });
            });
        
        };
        
        //保存信息
	    function applyAssn(){
        	if (userId == null || userId == '') {
        		//判断登陆
            	publicLogin("${basePath}wechatAssn/toRecruitApply.do");
        	}else{
        		$("#applyAssnBut").attr("onclick","");
    	        var applyName=$('#applyName').val();
    	        var applyCard = $("#applyCard").val();
    	        var moblie = $("#moblie").val();
    	        var personProfile = $("#personProfile").val();
    	        
    	        //名称
    	        if(applyName==undefined||applyName.trim()==""){
    	        	$("#applyAssnBut").attr("onclick","applyAssn();");
    	        	dialogAlert('系统提示', '姓名为必填项！');
    	            $('#applyName').focus();
    	            return;
    	        }else{
    	            if(applyName.length>20){
    	            	$("#applyAssnBut").attr("onclick","applyAssn();");
    	            	dialogAlert('系统提示',"姓名只能输入20字以内！");
    	                $('#applyName').focus();
    	                return false;
    	            }
    	        }
    	        
    	        //身份证
    	         var reg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;
    	        if(applyCard==undefined||applyCard.trim()==""){
    	        	$("#applyAssnBut").attr("onclick","applyAssn();");
    	            dialogAlert('系统提示',"身份证为必填！");
    	            $('#applyCard').focus();
    	            return;
    	        }else if(!reg.test(applyCard)){	 	
    	        	$("#applyAssnBut").attr("onclick","applyAssn();");
 	                dialogAlert('提示', "身份证不合法!");
 	                $('#applyCard').focus();
 	                return;
	 	            
	 	        }
    	        
    	        /* else{
    	            if(applyCard.length>18){
    	            	$("#applyAssnBut").attr("onclick","applyAssn();");
    	            	dialogAlert('系统提示',"身份证只能输入18字以内！");
    	                $('#applyCard').focus();
    	                return false;
    	            }
    	        } */
    	
    	        //联系电话
    	        var telReg = (/^(0|86|17951)?(13[0-9]|15[012356789]|17[0135678]|18[0-9]|14[57])[0-9]{8}$/);
    	        if(moblie==undefined||moblie==""){
    	        	$("#applyAssnBut").attr("onclick","applyAssn();");
    	        	dialogAlert('系统提示',"联系电话为必填项！");
    	            $('#moblie').focus();
    	            return;
    	        }else if (!moblie.match(telReg)) {
    	        	$("#applyAssnBut").attr("onclick","applyAssn();");
	                dialogAlert('系统提示', '请正确填写手机号码！');
	                $('#moblie').focus()
	                return;
	            }
    	        
    	        
    	      	//社团简介
    	        if(personProfile==undefined||personProfile.trim()==""){
    	        	$("#applyAssnBut").attr("onclick","applyAssn();");
    	        	dialogAlert('系统提示',"个人简介为必填！");
    	            $('#personProfile').focus();
    	            return;
    	        }else{
    	            if(personProfile.length>500){
    	            	$("#applyAssnBut").attr("onclick","applyAssn();");
    	            	dialogAlert('系统提示',"个人简介只能输入1000字以内！");
    	                $('#personProfile').focus();
    	                return false;
    	            }
    	        }
    	      	
    	      	$("#applyId").val(userId);
    	      	var imgpic = $(".upload-img-identify");
    	      	if(imgpic.length==0){
    	      		$("#applyAssnBut").attr("onclick","applyAssn();");
    	        	dialogAlert('系统提示',"图片必须上传！");
    	            return;
    	      	}else{
    	      		$("#pic").val("");
    	      		for(var i = 0;i < imgpic.length; i++){
    	      			if($("#pic").val().trim()==""){
    						$("#pic").val(imgpic[i].getAttribute('src'));
    					}else{
    						$("#pic").val($("#pic").val()+","+imgpic[i].getAttribute('src'));
    					} 
    	      		}
    	      	}
    	      	
    	        //保存申请信息
    	        /* $.post("${path}/wechatAssn/recruitApply.do", $("#associationApplyForm").serialize(),function(data) {
                    if (data!=null&&data=='success') {
                    	dialogConfirm('系统提示', "申请完成！",function (r){
                        	if(window.injs){	//判断是否存在方法
                        		injs.accessAppPage(11); 
                        	}else{
                        		location.href = '${path}/wechatAssn/toAssnDetail.do?assnId='+${assnId};
                        	}
                        });
                    }else if(data=='full'){
                    	$("#applyAssnBut").attr("onclick","applyAssn();");
                    	dialogAlert('系统提示', '此社团已经满员！');
                    }else{
                    	$("#applyAssnBut").attr("onclick","applyAssn();");
                    	dialogAlert('系统提示', '申请失败！');
                    }
    	        },"json"); */
    	      	$.post("${path}/frontAssn/applyRecruit.do", $("#associationApplyForm").serialize(),function(data) {
	                 if (data!=null&&data=='success') {
	                	 dialogConfirm('系统提示', "申请完成！",function (r){
	                        	location.href = '${path}/wechatAssn/toAssnDetail.do?assnId='+$("#assnId").val();
	                        });
	                	 /* dialogAlert("提示", "申请完成！", function () {
	                 		window.location.href = '${path}/wechatAssn/toAssnDetail.do?assnId=' + $("#assnId").val();
	 	     	        	}); */
	                 }else if(data!=null&&data=='applyed'){
	                	 dialogConfirm('系统提示', "您已经报名了,请不要重复报名！",function (r){
	                        	location.href = '${path}/wechatAssn/toAssnDetail.do?assnId='+$("#assnId").val();
	                        });
	                	 /* dialogAlert("提示", "您已经报名了,请不要重复报名！", function () {
		                 		window.location.href = '${path}/wechatAssn/toAssnDetail.do?assnId=' + $("#assnId").val();
		 	     	        	}); */
	                 }else{
	                	 $("#applyAssnBut").attr("onclick","applyAssn();");
	                     dialogAlert('系统提示', '申请失败！');
	                 }
	 	        },"json");
        	}
	    }
    </script>
    
</head>
<style>
		#container{float: left;width: 154px;height: 154px;margin-right: 13px;margin-bottom: 10px;}
		.joinusMain{padding: 40px;width: 670px;margin: auto;}
		div[name = aliFile]{float: left;width: 150px;height: 150px;border: 2px dashed #b0b0b0;margin-right: 13px;margin-bottom: 10px;}
		.imgPack{width: 100%;height: 100%;position: relative;}
		.imgPack .upload-img-identify{position: absolute;left: 0;right: 0;bottom: 0;top: 0;max-width: 154px;max-height: 154px;margin: auto;}
		.imgPack .aliRemoveBtn{position: absolute;right: -10px;top: -10px;z-index: 10;}
		div[name = aliFile] span,div[name = aliFile] b{display: none;}
	</style>
<body>
<form id="associationApplyForm">
<input id="assnId" name="assnId" type="hidden" value="${assnId}"/>
<input id="recruitId" name="recruitId" type="hidden" value="${recruitId}"/>
<input id="pic" name="pic" type="hidden"/>
<input id="applyId" name="applyId" type="hidden" />
		<div class="joinusMain">
			
			<input id="applyName" name="applyName" placeholder="请输入您的姓名" type="text" style="width: 633px;height: 38px;border: 1px solid #b0b0b0;border-radius: 10px;line-height: 40px;color: #262626;font-size: 24px;padding: 20px;background-color: #f8f8f8;margin-bottom: 20px;" />
			<input id="applyCard" name="applyCard" placeholder="请输入您的身份证号" type="number" style="width: 633px;height: 38px;border: 1px solid #b0b0b0;border-radius: 10px;line-height: 40px;color: #262626;font-size: 24px;padding: 20px;background-color: #f8f8f8;margin-bottom: 20px;" />
			<input id="moblie" name="moblie" placeholder="请输入您的联系方式" type="tel" style="width: 633px;height: 38px;border: 1px solid #b0b0b0;border-radius: 10px;line-height: 40px;color: #262626;font-size: 24px;padding: 20px;background-color: #f8f8f8;margin-bottom: 20px;" />
			<textarea id="personProfile" name="personProfile" placeholder="请输入个人简介，最多1000字" style="width: 633px;height: 250px;border: 1px solid #b0b0b0;border-radius: 10px;line-height: 40px;color: #262626;font-size: 24px;padding: 20px;background-color: #f8f8f8;margin-bottom: 20px;resize: none;"></textarea>
			
			<div id="webUpload" class="clearfix">
				<div id="container">
					<img id="selectfiles" src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201813181606eRHL6i84mkpxwprkN4sIwy71iD7h7.jpg" />
				</div>
				<div id="ossfile"></div>

			</div>
			
			<p style="font-size: 24px;margin-top: 25px;color: #999999;">可上传9张图片，格式为jpg，jpeg，png，gif，大小不超过2M</p>
			<div id="applyAssnBut" style="width: 550px;height: 85px;background-color: #a09ee0;margin: 50px auto;border-radius: 10px;font-size: 30px;color: #fff;text-align: center;line-height: 85px;" onclick="applyAssn()">提&emsp;交</div>
			
			<p style="font-size: 24px;margin-top: 25px;color: #262626;"><span style="color: red;">*</span>如果你对加入本社团感兴趣，请提交相关信息，我们的工作人员会尽快与您联系</p>
		</div>
</form>
</body>
<script>
		function test(up, file, fileName) {
			
			//上传格式判断，如果不对，触发删除事件
			var _type = fileName.split(".")[1].toLowerCase()
			if(_type != "png" && _type != "jpg" && _type != "jpeg" && _type != "gif"){
				$("#" + file.id).find(".aliRemoveBtn").click();
			}else{
				/* if($("#pic").val().trim()==""){
					$("#pic").val(fileName);
				}else{
					$("#pic").val($("#pic").val()+","+fileName);
				} */
			}
			
			//console.log('http://culturecloud.img-cn-hangzhou.aliyuncs.com/' + fileName)
		}
		$(function() {

			console.log($("#select").val())

			aliUpload({
				uploadDomId: 'webUpload',
				//fileFormat:'jpg,jpeg',
				fileNum: 9,
				progressBar: false,
				callBackFunc: test,
				imgPreview: true,
			})
		})
	</script>
</html>