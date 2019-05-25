<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>安康文化云·电影中的真善美</title>
	<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
	<link rel="stylesheet" type="text/css" href="${path}/STATIC/wxStatic/css/style-series-movie.css" />
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
		
		.musicInfoList{
			 margin-top: 0px;
		}
		
		.musicMain .content {
		    padding: 14px 24px;
		}
		
		
	</style>
	<script type="text/javascript">
		$(function() {
			
			$.ajaxSettings.async = false; 
			var articleType = '${articleType}';	//当前所在标签
			var userInfo= '${userInfo}';
			var articleCount=parseInt('${articleCount}');
			var themeType = 1;
			
			
			
			if (userId == null || userId == '') {
        		//判断登陆
            	publicLogin("${basePath}wechatStatic/createMoviessayArticle.do?articleType="+articleType);
        	}
			
			
			if(userInfo == null || userInfo == ''){
				//户是还没有报名
				$("#musicList").show();
				$('#musicMenu').hide();
				
			}
			else if(articleType== 1){
				
				times = checkTimes();
				if(times=='no'){
					$(".musicMenu").hide();
				}
				//写的是微评
				$(".musicMenu a:eq(0)").addClass("musicMenuOn").siblings().removeClass("musicMenuOnTwo");
				$("#musicWipingDiv").show();
				$("#Wipingmenu a:eq(0)").addClass("publishinfo").siblings().removeClass("publishinfo");
			}
			else if(articleType== 2){
					
					times = checkTimes();
					if(times=='all'){
						$("#musicZhengwenDiv").show();
						$(".musicMenu a:eq(1)").addClass("musicMenuOnTwo").siblings().removeClass("musicMenuOn");
						$("#Zhengwenmenu a:eq(0)").addClass("publishinfotwo").siblings().removeClass("publishinfotwo");
					}
					if(times=='1'){
						$("#musicZhengwenDiv").show();
						$(".musicMenu a:eq(1)").addClass("musicMenuOnTwo").siblings().removeClass("musicMenuOn");
						$("#Zhengwenmenu a:eq(0)").addClass("publishinfotwo").siblings().removeClass("publishinfotwo");
						$("#Zhengwenmenu a:eq(1)").hide();
						themeType = '1' ;
					}
					if(times=='2'){
						$("#musicZhengwenDiv").show();
						$(".musicMenu a:eq(1)").addClass("musicMenuOnTwo").siblings().removeClass("musicMenuOn");
						$("#Zhengwenmenu a:eq(1)").addClass("publishinfotwo").siblings().removeClass("publishinfotwo");
						$("#Zhengwenmenu a:eq(0)").hide();
						themeType = '2';
						
						
						var form =$("#articleType2");
						form.find("#movieName").hide();
					}
					if(times=='no'){
						dialogSaveDraft('提示', '您的征文发布次数已用完',function(){
							window.location.href = '${path}/wechatStatic/myMovieIndex.do?indexTag=2&userId='+userId;
	    				});
					}
				
				
				
				
				
			}
			
			
			
			//微评征文点击切换
			$(".musicMenu").find("a").on("click",function(){
				if($(this).index() == 0){
					$(this).addClass("musicMenuOn").siblings().removeClass("musicMenuOnTwo");
					$("#musicWipingDiv").show()
					$("#musicZhengwenDiv").hide()
				}else{
					$(this).addClass("musicMenuOnTwo").siblings().removeClass("musicMenuOn");
					$("#musicWipingDiv").hide();
					$("#musicZhengwenDiv").show();
					if(times=='1'){
						$("#Zhengwenmenu a:eq(0)").addClass("publishinfotwo").siblings().removeClass("publishinfotwo");
						$("#Zhengwenmenu a:eq(1)").hide();
						themeType = '1' ;
					}
					if(times=='2'){
						$("#Zhengwenmenu a:eq(1)").addClass("publishinfotwo").siblings().removeClass("publishinfotwo");
						$("#Zhengwenmenu a:eq(0)").hide();
						themeType = '2';
						
						var form =$("#articleType2");
						form.find("#movieName").hide();
					}
				}
			});
			
			
			
			function checkTimes(){
				var reDate;
				var formData ={
						userId:userId
					}
				$.post("${path}/wechatStatic/queryMoviessayArticleByArticleType.do",formData, function(data) {
					reDate =  data;	
				},'json');
				return reDate;
			}
			
			
			
			//微评中   电影中的真善美 == 我与我的电影节   之间点击切换
			$("#Wipingmenu").find("a").on("click",function(){
				$(this).addClass("publishinfo").siblings().removeClass("publishinfo");
				themeType = $(this).attr('themeType');
				var form =$("#articleType1");
				var movieName= form.find("#movieName")
				if(themeType==2){
					movieName.hide();
				}else{
					movieName.show();
				}
			});
			
			

			//征文中#电影中的真善美 我与我的电影节#点击切换
			$("#Zhengwenmenu").find("a").on("click",function(){
				$(this).addClass("publishinfotwo").siblings().removeClass("publishinfotwo");
				themeType = $(this).attr('themeType');
				var form =$("#articleType2");
				var movieName= form.find("#movieName")
				if(themeType==2){
					movieName.hide();
				}else{
					movieName.show();
				}
			});

			
			
			
			
			//用户表单的提交事事件
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
				if(submitFlag){
					submitFlag = false;
					$.post("${path}/wechatStatic/saveMoviessayUserInfo.do",formData, function(data) {
		    			if(data>=0){
		    				$("#musicList").hide();
		    				$('#musicMenu').show();
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
					submitFlag = true;
				}else{
					return false;
				}
			});
			
			
			
			
			
			var submitFlag = true;
			//微评的提交事件
			$("#articleTypeSubmit1").click(function(){
				var form =$("#articleType1");
				var movieName= form.find("#movieName").val();
				var articleTitle= form.find("#articleTitle").val();
				var articleText= form.find("#articleText").val();
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
					 times = checkTimes();
					 if(times!='no'){
				    	var dd = dialog({
				            width:400,
				            title:'系统提示', 
				            content:'您编辑的微评内容已超过140个字符限制，您可以选择重新编辑或者改投征文（600字以上）。',
				            fixed: true,
				            okValue: '改投征文',
				            cancelValue:'重新编辑',
				            ok: function () {
				            	//改写征文
				            	$("#musicWipingDiv").hide()
								$("#musicZhengwenDiv").show()
								var articleTitle=$("#musicWipingDiv").find("#articleTitle").val();
				            	var articleText=$("#musicWipingDiv").find("#articleText").val();
				            	var movieName=$("#musicWipingDiv").find("#movieName").val();
				            	$("#musicZhengwenDiv").find("#articleTitle").val(articleTitle);
				            	$("#musicZhengwenDiv").find("#articleText").val(articleText);
				            	$("#musicZhengwenDiv").find("#movieName").val(movieName);
								if(times=='1'){
									$("#Zhengwenmenu a:eq(1)").hide();
									themeType = '1' ;
									$("#Zhengwenmenu a:eq(0)").addClass("publishinfotwo").siblings().removeClass("publishinfotwo");
								}else if(times=='2'){
									$("#Zhengwenmenu a:eq(0)").hide();
									themeType = '2';
									var form =$("#articleType2");
									var movieName = form.find("#movieName");
									movieName.hide();
									movieName.val('');
									$("#Zhengwenmenu a:eq(1)").addClass("publishinfotwo").siblings().removeClass("publishinfotwo");
								}else if(times=='all'){
									if(themeType==2){
										$("#Zhengwenmenu a:eq(1)").addClass("publishinfotwo").siblings().removeClass("publishinfotwo");
										$("#musicZhengwenDiv").find("#movieName").hide();
										$("#musicZhengwenDiv").find("#movieName").val('');
									}else{
										$("#Zhengwenmenu a:eq(0)").addClass("publishinfotwo").siblings().removeClass("publishinfotwo");
									}
								}
				            	//当改为征文后，社设置征文的类型:articleType = 2
				            	articleType = 2;
				            	$(".musicMenu a:eq(1)").addClass("musicMenuOnTwo").siblings().removeClass("musicMenuOn");
				            	$("#musicWipingDiv").find("#articleTitle").val('');
				            	$("#musicWipingDiv").find("#articleText").val('');
				            	$("#musicWipingDiv").find("#movieName").val('');	    			
				            },
				            cancel:function(){
				            }
				        });}else{
				        	var dd = dialog({
					            width:400,
					            title:'系统提示', 
					            content:'您编辑的微评内容已超过140个字符限制，您可以重新编辑(征文次数已用完！)。',
					            fixed: true,
					            cancelValue:'重新编辑',
					            cancel:function(){	
					            }
					 		});
				        }
					 
					 
					 
					 
				        dd.showModal();
				        return false;
				 }	
				 
				 
				//获取到表单数据
				var formData= form.serializeArray();
				formData.push({'name':'userId','value':userId});
				formData.push({'name':'themeType','value':themeType});
				if(submitFlag){
					submitFlag = false;
					 $.post("${path}/wechatStatic/saveMoviessayArticle.do",formData, function(data) {
					 	if(data=="success"){
					 		dialogSaveDraft('提示', '保存成功',function(){
		    					window.location.href = '${path}/wechatStatic/myMovieIndex.do?indexTag=1&userId='+userId;
		    				});
		    			}else{
		    				
		    				dialogAlert('提示', '保存失败，系统繁忙');
		    			}
		    		},'json');
					submitFlag = true;
				}else{
					return false;
				}
			});
			
			
			
			
			
			
		//征文的提交事件
		$("#articleTypeSubmit2").click(function(){
				var form =$("#articleType2");
				var movieName= form.find("#movieName").val();
				var articleTitle= form.find("#articleTitle").val();
				var articleText= form.find("#articleText").val();
				if(!articleTitle){
					dialogAlert('系统提示', '征文名称不能为空！');
			        return false;
				}else{
					var reData;
					var formData = {
							userId:userId,
							articleType:articleType,
							movieName:movieName
					}
					$.post("${path}/wechatStatic/queryMoviessayZWCountByMovieName.do",formData, function(data) {
							reData = data;
					});
					if(reData>0){
						dialogAlert('系统提示', '所评电影不可重复！');
						return false;
					}
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
					formData.push({'name':'themeType','value':themeType});
					if(submitFlag){
					 $.post("${path}/wechatStatic/saveMoviessayArticle.do",formData, function(data) {
						 submitFlag = false;
						 if(data=="success"){
							 dialogSaveDraft('提示', '保存成功',function(){
			    					window.location.href = '${path}/wechatStatic/myMovieIndex.do?indexTag=2&userId='+userId;
			    				});
			    			}else{
			    				dialogAlert('提示', '保存失败，系统繁忙');
			    			}
			    		},'json');
					 submitFlag = true;
					}else{
						return false;
					}
				});
		
		
		
		
		
		
				$(".myBtn").on("click",function(e){
					if (userId == null || userId == '') {
						publicLogin("${basePath}wechatStatic/myMovieIndex.do?indexTag="+articleType);
					}
					else{
						 window.location.href='${basePath}wechatStatic/myMovieIndex.do?indexTag='+articleType
					}
				});
				
				
				
				
				$(".rankingBtn").on("click",function(e){
					 window.location.href='${basePath}wechatStatic/movieRanking.do?userId='+userId
				});
				
				
				
				
				$(".ruleBtn").on("click",function(e){
					 window.location.href='${basePath}wechatStatic/movieRule.do';
				});
		
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

	<body>
		<div class="musicMain">
			<!--头图-->
			<div class="musicBanner">
				<!-- 回到文化云 -->
				<a href="" class="gobackculture">
					回到文化云
				</a>
				<!-- 片单，资讯 -->
				<div class="message">
					<div class="message_child">
						<a href="http://hs.hb.wenhuayun.cn/information/preInfo.do?informationId=2280d976a13343ebbd48578e58614f60&from=singlemessage&isappinstalled=0"></a>
						<a href="http://hs.hb.wenhuayun.cn/wechatFunction/contestQuiz.do?topicId=0933bfca389245ff8ba9d80e430ff510"></a>
					</div>
				</div>
				<img src="${path}/STATIC/wxStatic/image/movieZSM/banner.jpg?20170609" />
				<div class="myBtn">
					<img src="${path}/STATIC/wxStatic/image/movieZSM/myBtn.png" />
				</div>
				<div class="rankingBtn">
					<img src="${path}/STATIC/wxStatic/image/movieZSM/rankingBtn.png" />
				</div>
				<div class="ruleBtn">
					<img src="${path}/STATIC/wxStatic/image/movieZSM/ruleBtn.png" />
				</div>
			</div>

			<!--菜单-->
			<div class="musicMenu clearfix" id="musicMenu">
				<a href="javascript:void(0)" class="musicMenuOn" articleType = "1">微&nbsp;评</a>
				<a href="javascript:void(0)" articleType = "2">征&nbsp;文</a>
			</div>
			<div class="content musicFontList">
				<!--报名-->
				<form id="userForm">
				<div id="musicList" style="display: none;">
					<div class="musicDetailTitle" style="padding-bottom:0;padding-top:12px;">
						<span class="rate_span">#&emsp;我要参赛&emsp;# </span>
						<span class="rate_span">请先填写参赛资料</span>
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
								<input type="text" id="userMail" name="userMail" placeholder="（选填）"/>
							</li>
							<li class="clearfix">
								<p>QQ</p>
								<input type="text" id="userQq" name="userQq" placeholder="（选填）"/>
							</li>
							<li class="clearfix">
								<p style="line-height: 25px;">本职工作</p>
								<input type="text" id="userWork" name="userWork" placeholder="（选填）"/>
							</li>
						</ul>
						<p class="musicInfoTips">请正确填写个人信息，如您获得奖项，您提交的信息将作为领奖依据，一经提交不可修改。</p>
						<div id="userInfoSubmit" class="musicDetailBtn clearfix" style="border: none;padding-left:0;padding-right:0;">
							<div class="musicDetailBtnCenter">下一步</div>
						</div>
					</div>
				</div>
				</form>
				<form id="articleType1">
					<!--微评-->
					<div id="musicWipingDiv" class="userWrite" style="display: none;">
						<div class="userInputDiv">
							<div class="infomenu clearfix" id="Wipingmenu">
								<a href="javascript:void(0)" class="publishinfo" themeType="1">#电影中的真善美#</a>
								<a href="javascript:void(0)" themeType="2">#我与我的电影节#</a>
							</div>
							<input type="text" id="movieName" name ="movieName" placeholder="请输入电影名称" />
							<input type="text" id="articleTitle" name="articleTitle"  placeholder="请输入微评主题（15字以内）" />
							<textarea id="articleText" name="articleText" style="resize: none;" placeholder="请输入文字（140字以内）"></textarea>
						</div>
						<div id="articleTypeSubmit1" class="musicDetailBtn clearfix" style="border: none;">
							<div class="musicDetailBtnCenter">发布</div>
						</div>
					</div>
					<input type="hidden" name="articleType" value="1"/>
				</form>
				<!--征文-->
				<form id="articleType2">
					<div id="musicZhengwenDiv" class="userWrite" style="display: none;">
						<div class="userInputDiv">
							<div class="infomenu clearfix" id="Zhengwenmenu">
								<a href="javascript:void(0)" class="publishinfotwo" themeType="1">#电影中的真善美#</a>
								<a href="javascript:void(0)" themeType="2">#我与我的电影节#</a>
							</div>
							<input type="text" id="movieName" name ="movieName" placeholder="请输入电影名称" />
							<input type="text" id="articleTitle" name="articleTitle" placeholder="请输入征文名称（15字以内）" />
							<textarea style="resize: none;" id="articleText" name="articleText" placeholder="请输入文字（600~2000字）"></textarea>
						</div>
						<div id="articleTypeSubmit2" class="musicDetailBtn clearfix" style="border: none;">
							<div class="musicDetailBtnCenter">发布</div>
						</div>
						<input type="hidden" name="articleType" value="2"/>
					</div>
				</form>
			</div>
		</div>
	</body>

</html>