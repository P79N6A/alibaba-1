<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·微笔记大赛</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series.css"/>
	<script src="${path}/STATIC/js/common.js"></script>
	
	<script>
		var isEnd = '${isEnd}';		//是否能参与（1：已结束）
	
		//分享是否隐藏
	    if(window.injs){
	    	//分享文案
	    	appShareTitle = '市民文化节--云叔喊你来写读书笔记 赢丰富好礼';
	    	appShareDesc = '阅读中的真善美•我的阅读笔记线上“微笔记”征集大赛火热进行中';
	    	appShareImgUrl = '${basePath}/STATIC/wx/image/share_120.png';
	    	appShareLink = '${basePath}/wechatStatic/micronote.do';
	    	
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
					title: "市民文化节--云叔喊你来写读书笔记 赢丰富好礼",
					desc: '阅读中的真善美•我的阅读笔记线上“微笔记”征集大赛火热进行中',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
					link: '${basePath}wechatStatic/micronote.do'
				});
				wx.onMenuShareTimeline({
					title: "阅读中的真善美•我的阅读笔记线上“微笔记”征集大赛火热进行中",
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
					link: '${basePath}wechatStatic/micronote.do'
				});
				wx.onMenuShareQQ({
					title: "市民文化节--云叔喊你来写读书笔记 赢丰富好礼",
					desc: '阅读中的真善美•我的阅读笔记线上“微笔记”征集大赛火热进行中',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
					link: '${basePath}/wechatStatic/micronote.do'
				});
				wx.onMenuShareWeibo({
					title: "市民文化节--云叔喊你来写读书笔记 赢丰富好礼",
					desc: '阅读中的真善美•我的阅读笔记线上“微笔记”征集大赛火热进行中',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
					link: '${basePath}/wechatStatic/micronote.do'
				});
				wx.onMenuShareQZone({
					title: "市民文化节--云叔喊你来写读书笔记 赢丰富好礼",
					desc: '阅读中的真善美•我的阅读笔记线上“微笔记”征集大赛火热进行中',
					imgUrl: '${basePath}/STATIC/wx/image/share_120.png',
					link: '${basePath}/wechatStatic/micronote.do'
				});
			});
		}
		
		$(function () {
			
		});
		
		//保存信息
	    function addNote(){
	    	if(isEnd == 1){
				dialogAlert('系统提示', '活动已结束！');
			}else{
				if (userId == null || userId == '') {
	        		//判断登陆
	            	publicLogin("${basePath}wechatStatic/toMicronoteApply.do");
	        	}else{
	        		$("#addNote").attr("onclick","");
	    	        var notePublisherName=$('#notePublisherName').val();
	    	        var notePublisherAge=$('#notePublisherAge').val();
	    	        var notePublisherMobile=$('#notePublisherMobile').val();
	    	        var noteTitle=$('#noteTitle').val();
	    	        var noteContent=$('#noteContent').val();
	    	        
	    	        if(notePublisherName.trim()==""){
	    	        	$("#addNote").attr("onclick","addNote();");
	    	        	dialogAlert('系统提示', '姓名为必填项！');
	    	            return;
	    	        }
	    	        if(notePublisherAge.trim()==""){
	    	        	$("#addNote").attr("onclick","addNote();");
	    	        	dialogAlert('系统提示', '年龄为必填项！');
	    	            return;
	    	        }
	    	        var telReg = (/^1[34578]\d{9}$/);
	    	        if(notePublisherMobile.trim()==""){
	    	        	$("#addNote").attr("onclick","addNote();");
	    	        	dialogAlert('系统提示', '手机号为必填项！');
	    	            return;
	    	        }else if(!notePublisherMobile.match(telReg)) {
	    	        	$("#addNote").attr("onclick","addNote();");
	    	            dialogAlert('系统提示', '请正确填写手机号码！');
	    	            return;
	    	        }
	    	        if(noteTitle.trim()==""){
	    	        	$("#addNote").attr("onclick","addNote();");
	    	        	dialogAlert('系统提示', '作品标题为必填项！');
	    	            return;
	    	        }
	    	        if(noteContent.trim()==""){
	    	        	$("#addNote").attr("onclick","addNote();");
	    	        	dialogAlert('系统提示', '作品内容为必填项！');
	    	            return;
	    	        }
	    	        
	    	        $("#createUser").val(userId);
	    	      	$("#updateUser").val(userId);
	    	      	
	    	      	//保存参赛信息
	    	        $.post("${path}/wechatStatic/saveMicronote.do", $("#applyForm").serialize(),function(data) {
	    	        	if (data.status == 1) {
	    	        		if(data.data == 1){
	    	        			dialogConfirm('系统提示', "提交完成</br>已获得500积分！",function (r){
	                            	location.href = '${path}/wechatStatic/toMicronoteList.do';
	                            });
	    	        		}else{
	    	        			$("#addNote").attr("onclick","addNote();");
	    	        			dialogConfirm('系统提示', "您已参与过该活动！",function (r){
	                            	location.href = '${path}/wechatStatic/toMicronoteList.do';
	                            });
	    	        		}
	                    }else{
	                    	$("#addNote").attr("onclick","addNote();");
	                    	dialogAlert('系统提示', '提交失败！');
	                    }
	    	        },"json");
	        	}
			}
		}
		
	</script>
	
	<style>
		html,
		body {
			height: 100%;
			width: 100%;
		}
		
		.zsm-main {
			height: 100%;
			background-position: 100% 100%;
		}
	</style>
</head>

<body>
	<!-- 方便分享自动抓取 -->
	<div style="display: none;"><img src="${basePath}/STATIC/wx/image/share_120.png"/></div>
	<div class="zsm-main">
		<div class="zsm-enter">
			<p class="enterP1">报名参赛</p>
			<p class="enterP2">参与活动即立享500积分</p>
		</div>
		<form id="applyForm" action="">
			<input id="createUser" name="createUser" type="hidden" value=""/>
			<input id="updateUser" name="updateUser" type="hidden" value=""/>
			<div class="enterForm">
				<ul>
					<li>
						<label>姓名：</label>
						<input id="notePublisherName" type="text" name="notePublisherName" maxlength="7"/>
					</li>
					<li>
						<label>年龄：</label>
						<input id="notePublisherAge" type="text" name="notePublisherAge" maxlength="10"/>
					</li>
					<li>
						<label>手机号：</label>
						<input id="notePublisherMobile" type="text" name="notePublisherMobile" maxlength="11"/>
					</li>
					<li>
						<label>作品标题：</label>
						<input id="noteTitle" type="text" name="noteTitle" maxlength="50"/>
					</li>
					<li>
						<label>作品内容：</label>
						<textarea id="noteContent" style="resize: none;height: 400px;" name="noteContent" maxlength="200"></textarea>
					</li>
				</ul>
			</div>
		</form>
		<div id="addNote" class="vote-btn1" onclick="addNote();">
			<img src="${path}/STATIC/wxStatic/image/zsm/submit.png" />
		</div>
	</div>
</body>
</html>