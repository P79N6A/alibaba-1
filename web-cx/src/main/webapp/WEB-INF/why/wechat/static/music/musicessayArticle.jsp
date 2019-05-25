<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>佛山文化云·音乐中的真善美</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series-2.css?v=20161021"/>
	<script src="${path}/STATIC/js/common.js"></script>
	<style>
		html,
		body {
			height: 100%;
		}
		
		.musicMain {
			width: 750px;
			margin: auto;
			min-height: 100%;
			background-color: #eeeeee;
		}
	</style>
	<script type="text/javascript">
		
		var articleType = '${articleType}';	//当前所在标签
		var userInfo= '${userInfo}';
		var articleCount=parseInt('${articleCount}');
		
		$(function() {
			//进页面时判断哪个标签被选中
			//等于2时，征文被选中
			if(articleType == 2) {
				$('.musicMenuBtn').removeClass("musicMenuOn");
				$(".musicZhengwen").find(".musicMenuBtn").addClass("musicMenuOn");
			}
			
			if (userId == null || userId == '') {
        		//判断登陆
            	publicLogin("${basePath}wechatStatic/createMusicessayArticle.do?articleType="+articleType);
        	}
			
			if(userInfo.length==0){
				$("#userInfoDiv").show();
			}
			else if(articleType== 1){
				$("#musicWipingDiv").show();
			}
			else if(articleType== 2){
				$("#musicZhengwenDiv").show();
			}
			
			//菜单标签按钮点击事件
			$(".musicMenuBtn").on("click", function() {
				$('.musicMenuBtn').removeClass("musicMenuOn");
				$(this).addClass("musicMenuOn")
			})
			
			//微评征文点击切换
			$("#musicWeiping").on("click",function(){
				$("#musicWipingDiv").show()
				$("#musicZhengwenDiv").hide()
			})
			
			$("#musicZhengwen").on("click",function(){
				$("#musicWipingDiv").hide()
				$("#musicZhengwenDiv").show()
			})


			
			$("#userInfoSubmit").click(function(){
				
				var userRealName=$("#userRealName").val();
				var userMoblieNo=$("#userMoblieNo").val();
				
				if(!userRealName){
        			dialogAlert('系统提示', '姓名不能为空！');
        			return;
        		}
				
				var telReg = (/^1[34578]\d{9}$/);
				
				if(userMoblieNo == ""){
			    	dialogAlert('系统提示', '手机号码不能为空！');
			        return false;
			    }else if(!userMoblieNo.match(telReg)){
			    	dialogAlert('系统提示', '请正确填写手机号码！');
			        return false;
			    }
				
				var formData= $("#userForm").serializeArray();
				
				formData.push({'name':'userId','value':userId});
				
				$.post("${path}/wechatStatic/saveMusicessayUserInfo.do",formData, function(data) {
	    			if(data>=0){
	    				$("#userInfoDiv").hide();
	    			
		    			 if(articleType== 1){
		    				$("#musicWipingDiv").show();
		    			}
		    			else if(articleType== 2){
		    				$("#musicZhengwenDiv").show();
		    			}
	    			}else{
	    				dialogAlert('提示', '保存失败，系统繁忙');
	    			}
	    		},'json');
			});
			
			$("#articleTypeSubmit1").click(function(){
				
				var form =$("#articleType1");
				
				var articleTitle= form.find("#articleTitle").val();
				var articleText=form.find("#articleText").val();
				
				if(!articleTitle){
					dialogAlert('系统提示', '微评名称不能为空！');
			        return false;
				}
				 if(articleTitle.length>15){
				    	dialogAlert('系统提示', '微评名称在15字以内！');
				        return false;
				 }
				 
				 if(!articleText){
						dialogAlert('系统提示', '请输入微评内容！');
				        return false;
				}
				 if(articleText.length>140){
				    	//dialogAlert('系统提示', '微评内容在140字以内！');
				    	
				    	var dd = dialog({
				            width:400,
				            title:'系统提示', 
				            content:'您编辑的微评内容已超过140个字符限制，您可以选择重新编辑或者改投征文（600字以上）。',
				            fixed: true,
				            okValue: '改投征文',
				            cancelValue:'重新编辑',
				            ok: function () {
				            	//window.location.href = '${path}/wechatStatic/createMusicessayArticle.do?articleType=2&userId='+userId;
				            	$("#musicWipingDiv").hide()
								$("#musicZhengwenDiv").show()
								
								var articleTitle=$("#musicWipingDiv").find("#articleTitle").val();
				            	var articleText=$("#musicWipingDiv").find("#articleText").val();
				            	
				            	$("#musicZhengwenDiv").find("#articleTitle").val(articleTitle);
				            	$("#musicZhengwenDiv").find("#articleText").val(articleText);
				            	
				            	articleType = 2;
				    			$('.musicMenuBtn').removeClass("musicMenuOn");
				    			$(".musicZhengwen").find(".musicMenuBtn").addClass("musicMenuOn");

				            	$("#musicWipingDiv").find("#articleTitle").val('');
				            	$("#musicWipingDiv").find("#articleText").val('');
				    			
				            },
				            cancel:function(){
				            	
				            }
				        });
				        dd.showModal();
				        
				        return false;
				 }	
				 
				var formData= form.serializeArray();
					
				formData.push({'name':'userId','value':userId});
			
				 $.post("${path}/wechatStatic/saveMusicessayArticle.do",formData, function(data) {
					 	if(data=="success"){
					 		dialogSaveDraft('提示', '保存成功',function(){
		    					
		    					window.location.href = '${path}/wechatStatic/myMusicIndex.do?indexTag=1&userId='+userId;
		    				});
		    			}else{
		    				dialogAlert('提示', '保存失败，系统繁忙');
		    			}
		    		},'json');
				
			});
			
			$("#articleTypeSubmit2").click(function(){
				
				if(articleCount>=3){
					
					dialogAlert('系统提示', '征文每人最多发三篇！');
			        return false;
				}
				
				var form =$("#articleType2");
				
				var articleTitle= form.find("#articleTitle").val();
				var articleText=form.find("#articleText").val();
				
				if(!articleTitle){
					dialogAlert('系统提示', '征文名称不能为空！');
			        return false;
				}
				 if(articleTitle.length>15){
				    	dialogAlert('系统提示', '征文名称在15字以内！');
				        return false;
				 }
				 
				 if(!articleText){
						dialogAlert('系统提示', '请输入征文内容！');
				        return false;
				}
				 if(articleText.length<600||articleText.length>1500){
				    	dialogAlert('系统提示', '征文内容在600-1500字以内！');
				        return false;
				 }	
			
				 var formData= form.serializeArray();
					
				formData.push({'name':'userId','value':userId});
				 
				 $.post("${path}/wechatStatic/saveMusicessayArticle.do",formData, function(data) {
					 if(data=="success"){
						 dialogSaveDraft('提示', '保存成功',function(){
		    					
		    					window.location.href = '${path}/wechatStatic/myMusicIndex.do?indexTag=2&userId='+userId;
		    				});
		    			}else{
		    				dialogAlert('提示', '保存失败，系统繁忙');
		    			}
		    		},'json');
			});
			
			$(".myBtn").on("click",function(e){
				
				if (userId == null || userId == '') {
					publicLogin("${basePath}wechatStatic/myMusicIndex.do?indexTag="+articleType);
				}
				else{
					 window.location.href='${basePath}wechatStatic/myMusicIndex.do?indexTag='+articleType
				}
			})
			
			$(".rankingBtn").on("click",function(e){
				
				 window.location.href='${basePath}wechatStatic/musicRanking.do?userId='+userId
			})
			
			$(".ruleBtn").on("click",function(e){
				
				 window.location.href='${basePath}wechatStatic/musicRule.do'
			})
		});
		
		function dialogSaveDraft(title, content, fn){
		    var d = dialog({
		        width:400,
		        title:title,
		        content:content,
		        fixed: true,
		        okValue: '确 定',
		        ok: function () {
		            if(fn)  fn();
		        }
		    });
		    d.showModal();
		}
	</script>
</head>
		<body>
		<div style="display: none;"><img src="${basePath}/STATIC/wechat/image/musicZSM/shareIcon.jpg"/></div>
		<div class="background-fx" style="position: fixed;top: 0px;left: 0px;width: 100%;height: 100%;display: none;z-index: 100;">
			<img src="${path}/STATIC/wxStatic/image/fx-bg.png" style="width: 100%;height: 100%;" />
		</div>
		<div class="musicMain">
			<!--头图-->
			<div class="musicBanner">
				<img src="${path}/STATIC/wechat/image/musicZSM/banner.jpg" />
				<div class="myBtn">
					<img src="${path}/STATIC/wechat/image/musicZSM/myBtn.png" />
				</div>
				 <div class="rankingBtn">
					<img src="${path}/STATIC/wechat/image/musicZSM/rankingBtn.png" />
				</div>
				<div class="ruleBtn">
					<img src="${path}/STATIC/wechat/image/musicZSM/ruleBtn.png" />
				</div> 
			</div>

			<!--菜单-->
			<div class="musicMenu clearfix">
				<div class="musicWeiping musicRightLine" id="musicWeiping">
					<div class="musicMenuBtn musicMenuOn">微&emsp;评</div>
				</div>
				<div class="musicZhengwen" id="musicZhengwen">
					<div class="musicMenuBtn">征&emsp;文</div>
				</div>
			</div>

			<div class="content musicFontList">
				<form id="userForm">
				<!--留资-->
				<div id="userInfoDiv" class="musicList" style="display: none;">
					<div class="musicDetailTitle" style="border-bottom: 1px solid #666666;">
						#&emsp;我要参赛&emsp;#
					</div>
					<div class="musicInfoList">
						<ul>
							<li class="clearfix">
								<p>姓名</p>
								<input type="text" id="userRealName" name="userRealName"/>
							</li>
							<li class="clearfix">
								<p>手机</p>
								<input type="text" id="userMoblieNo" name="userMoblieNo" maxlength="11"/>
							</li>
							<li class="clearfix">
								<p>邮箱</p>
								<input type="text" id="userMail" name="userMail"/>
							</li>
							<li class="clearfix">
								<p>QQ</p>
								<input type="text" id="userQq" name="userQq"/>
							</li>
						</ul>
						<p class="musicInfoTips">请正确填写个人信息，如您获得奖项，您提交的信息将作为领奖依据，一经提交不可修改。</p>
						<div id="userInfoSubmit" class="musicDetailBtn clearfix" style="border: none;">
							<div class="musicDetailBtnCenter">下一步</div>
						</div>
					</div>
				</div>
				</form>
				<form id="articleType1">
				<!--微评-->
				<div id="musicWipingDiv" class="userWrite" style="display: none;">
					<div class="userInputDiv">
						<input type="text" id="articleTitle" name="articleTitle" placeholder="请输入微评名称（15字以内）" />
						<textarea id="articleText" name="articleText" style="resize: none;" placeholder="请输入文字（140字以内）"></textarea>
					</div>
					<div id="articleTypeSubmit1" class="musicDetailBtn clearfix" style="border: none;">
						<div class="musicDetailBtnCenter">发布</div>
					</div>
				</div>
				<input type="hidden" name="articleType" value="1"/>
				</form>
				<form id="articleType2">
				<!--征文-->
				<div id="musicZhengwenDiv" class="userWrite" style="display: none;">
					<div class="userInputDiv">
						<input type="text" id="articleTitle" name="articleTitle" placeholder="请输入征文名称（15字以内）" />
						<textarea id="articleText" name="articleText" style="resize: none;" placeholder="请输入文字（600~1500字）"></textarea>
					</div>
					<div id="articleTypeSubmit2" class="musicDetailBtn clearfix" style="border: none;">
						<div class="musicDetailBtnCenter">发布</div>
					</div>
				</div>
						<input type="hidden" name="articleType" value="2"/>
				</form>
			</div>
		</div>
	</body>

</html>