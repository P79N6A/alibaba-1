<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>资质认证</title>
<%@include file="/WEB-INF/why/wechat/commonFrame.jsp"%>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/style${empty sourceCode?'':sourceCode}.css"/>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/wechat/css/webuploader.css"/>
<script type="text/javascript" src="${path}/STATIC/wechat/js/webuploader/webuploader.min.js"></script>
<script type="text/javascript" src="${path}/STATIC/wechat/js/webuploader/upload-authTeamUser.js"></script>
		
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
	
	//上传资质及作品（9张图）
	function uploadImg(formId){
		
		//判断是否是微信浏览器打开
        if (!is_weixin()) {
            dialogAlert('系统提示', '请用微信浏览器打开！');
            return;
        }
		
		chooseCount = 10 - $("#"+formId+" .add-pic-list li").length;
		
		wx.chooseImage({
			count: chooseCount,	// 默认9
	    	sizeType: ['compressed'],	// 指定是原图还是压缩图，默认二者都有
		    success: function (res) {
		        var localIds = res.localIds; // 返回选定照片的本地ID列表，localId可以作为img标签的src属性显示图片
		        syncUpload(localIds,formId);
		    }
		});
	}
	
	//上传营业执照（1张图）
	function uploadTuserPic(){
		
		//判断是否是微信浏览器打开
        if (!is_weixin()) {
            dialogAlert('系统提示', '请用微信浏览器打开！');
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
		                		$(".add-tuser-pic-button").hide();
		                		var imgUrl = getIndexImgUrl(getImgUrl(data),"_150_150");
		                		$(".tuser-upl").append("<li imgUrl='"+getImgUrl(data)+"' class='uploadLi'>" +
								                			    "<img src='"+imgUrl+"' ontouchstart='previewImage(\""+getImgUrl(data)+"\");' height='150' width='150'>" +
								                			    "<img class='tuser-uplrem' src='${path}/STATIC/wechat/image/mobile_close.png'></img>" +
								                			"</li>");
		                		
		                		//删除按钮
		                		$(".tuser-uplrem").on("touchstart", function() {
		                			$(this).parent('li').remove();
		                			$(".add-tuser-pic-button").show();
		                		})
		                	}else{
		                		dialogAlert('系统提示', '上传失败！');
		                	}
		                },"json");
		            }
		        });
		    }
		});
	}
	
	//上传多张图片，需要将之前并行上传改成串行。
	function syncUpload(localIds,formId){
		var localId = localIds.pop();
		wx.uploadImage({
		    localId: localId,
		    isShowProgressTips: 1, // 默认为1，显示进度提示
		    success: function (res) {
                var serverId = res.serverId; // 返回图片的服务器端ID
                $.post("${path}/wechat/wcUpload.do",{mediaId:serverId,userId:userId,uploadType:2}, function(data) {
                	if(data!=1){
                		var imgUrl = getIndexImgUrl(getImgUrl(data),"_150_150");
                		$("#"+formId+" .user-upl").prepend("<li imgUrl='"+getImgUrl(data)+"' class='uploadLi'>" +
						                			    "<img src='"+imgUrl+"' ontouchstart='previewImage(\""+getImgUrl(data)+"\");' height='150' width='150'>" +
						                			    "<img class='user-uplrem' src='${path}/STATIC/wechat/image/mobile_close.png'></img>" +
						                			"</li>");
                		
                		imgButton(formId);	//判断图片按钮是否显示
                		
                		//删除按钮
                		$("#"+formId+" .user-uplrem").on("touchstart", function() {
                			$(this).parent('li').remove();
                			imgButton(formId);
                		})
                		
                		//其他对serverId做处理的代码
                        if(localIds.length > 0){
        					syncUpload(localIds,formId);
                        }
                	}else{
                		dialogAlert('系统提示', '上传失败！');
                	}
                },"json");
            }
		});
	}
	
	//判断图片按钮是否显示
	function imgButton(formId){
		var clnum = $("#"+formId+" .add-pic-list li");
		if (clnum.length >= 10) {
			$("#"+formId+" .add-pic-button").hide();
		} else {
			$("#"+formId+" .add-pic-button").show();
		}
	}
	
	//图片预览
	function previewImage(url){
		wx.previewImage({
		    current: url, // 当前显示图片的http链接
		    urls: [url]
		});
	}
	
	// 团体类别
    function getTeamUserType(){
        $.post("${path}/sysdict/queryCode.do",{'dictCode' : 'TEAM_TYPE'},function(data) {
            if (data != '' && data != null) {
               var list = eval(data);
               TypeChose(list, "teamForm #tuserTeamType","teamForm #tuserTeamTypeName") 
            }
        });
    }
	 
	//公司类别
	function getCompanyType(){
		$.post("${path}/sysdict/queryCode.do",{'dictCode' : 'COMPANY_TYPE'},function(data) {
            if (data != '' && data != null) {
               var list = eval(data);
               TypeChose(list, "companyForm #tuserTeamType","companyForm #tuserTeamTypeName") 
            }
        });
	}
	
	function buttonOpen(button){
		button.removeClass("bgccc")
		button.addClass("bg7279a0")
	}
</script>

<script>
			$(function() {
				//切换标签(页面重置)
				$(".add-tab>ul>li").click(function() {
					$(".add-tab>ul>li>div").removeClass("border-bottom2")
					$(this).find("div").addClass("border-bottom2")
					$(".add-tab>ul>li>div").removeClass("c5e6d98")
					$(this).find("div").addClass("c5e6d98")
					
					var num = $(this).index()
					$(".add-tab-content").hide();
					var tuserName=$("#inputName").val();
					$("form").each(function(index,dom){ 
						dom.reset();
					});
					$(".uploadLi").each(function(index,dom){
						$(this).remove();
					});
					imgButton('personForm');
					imgButton('teamForm');
					imgButton('companyForm');
					$(".add-tuser-pic-button").show();
					upload1();
					upload2();
					upload3();
					upload4();
					$(".add-tab-content").eq(num).show();
				});
				
				//提交
				$(".add-tuser").click(function() {
					
					var button=$(this).find("button");
					
					if (button.hasClass("bg7279a0")) {
						button.removeClass("bg7279a0")
						button.addClass("bgccc")
					}else 
						return false;
					
					var form=$(this).parents("form");
					var formId=form.attr("id") 
					var agree=$("#"+formId+" #agree").is(':checked');
					
		        	if(!agree){
		        		dialogAlert('提示', '请先同意佛山文化云使用协议及规则！');
		        		buttonOpen(button)
		    			return;
		        	}
		        	
		        	var formData= form.serializeArray();
		        	var tuserUserType=$("#"+formId+" #tuserUserType").val();
		        	var userId=$("#userId").val();
		        	var roomOrderId=$("#roomOrderId").val();
		        	
		        	formData.push({'name':'userId','value':userId});
		        	formData.push({'name':'roomOrderId','value':roomOrderId});
		        	
		    		$("#"+formId+" .add-pic-list li.uploadLi").each(function(index, element) {
		    			formData.push({'name':'teamUserDetailPics','value':$(element).attr("imgUrl")});
		    		});
		    	
		    		var textReg = (/^[a-zA-Z0-9\u4e00-\u9fa5]+$/);		//中文，字母，数字组成正则
		    		
		    		// 个人
		    		if(tuserUserType=="1"){
		    			var tuserName=form.find("#tuserName").val();
		    			if(!tuserName){
		        			dialogAlert('提示', '个人姓名不能为空！');
		        			buttonOpen(button)
		        			return;
		        		}
		            	if(!tuserName.match(textReg)){
		    		    	dialogAlert('提示', '姓名只能由中文，字母，数字组成！');
		    		    	buttonOpen(button)
		    		        return false;
		    		    }
		    			
		    			var tuserTag=form.find("#tuserTag").val();
		    			if(!tuserTag){
		        			dialogAlert('提示', '头衔/职位不能为空！');
		        			buttonOpen(button)
		        			return;
		        		}
		            	if(!tuserTag.match(textReg)){
		    		    	dialogAlert('提示', '头衔/职位只能由中文，字母，数字组成！');
		    		    	buttonOpen(button)
		    		        return false;
		    		    }
		    			
						var tuserYear=form.find("#tuserYear").val();
						if(!tuserYear){
		        			dialogAlert('提示', '从业年限不能为空！');
		        			buttonOpen(button)
		        			return;
		        		}
						
						var reg=/^[1-9]([0-9]*)$/;
						if(!reg.test(tuserYear)){
							dialogAlert('提示', "从业年限必须为数字!");
							buttonOpen(button)
							return  false;
						}
						
						var tuserTeamRemark=form.find("#tuserTeamRemark").val();
						if(!tuserTeamRemark){
		        			dialogAlert('提示', '自我介绍不能为空！');
		        			buttonOpen(button)
		        			return;
		        		}
		    		}else if(tuserUserType=="0"){	// 社团
						var tuserName=form.find("#tuserName").val();
		    			if(!tuserName){
		        			dialogAlert('提示', '社团名称不能为空！');
		        			buttonOpen(button)
		        			return;
		        		}
		    			if(!tuserName.match(textReg)){
		    		    	dialogAlert('提示', '社团名称只能由中文，字母，数字组成！');
		    		    	buttonOpen(button)
		    		        return false;
		    		    }
		    			
		    			var reg=/^[1-9]([0-9]*)$/;
						var tuserYear=form.find("#tuserYear").val();
						if(!tuserYear){
		        			dialogAlert('提示', '成立年限不能为空！');
		        			buttonOpen(button)
		        			return;
		        		}
						if(!reg.test(tuserYear)){
							dialogAlert('提示', "成立年限必须为数字!");
							buttonOpen(button)
							return  false;
						}
						
						var tuserLimit=form.find("#tuserLimit").val();
						if(!tuserLimit){
		        			dialogAlert('提示', '社团人数不能为空！');
		        			buttonOpen(button)
		        			return;
		        		}
						if(!reg.test(tuserLimit)){
							dialogAlert('提示', "社团人数必须为数字!");
							buttonOpen(button)
							return  false;
						}
						
						var tuserTeamType=form.find("#tuserTeamType").val();
						if(!tuserTeamType){
		        			dialogAlert('提示', '社团类型不能为空！');
		        			buttonOpen(button)
		        			return;
		        		}
						if(!tuserTeamType.match(textReg)){
		    		    	dialogAlert('提示', '社团类型只能由中文，字母，数字组成！');
		    		    	buttonOpen(button)
		    		        return false;
		    		    }
						
						var tuserTeamRemark=form.find("#tuserTeamRemark").val();
						if(!tuserTeamRemark){
		        			dialogAlert('提示', '社团介绍不能为空！');
		        			buttonOpen(button)
		        			return;
		        		}
		    		}else if(tuserUserType=="2"){	// 公司
						var tuserName=form.find("#tuserName").val();
		    			if(!tuserName){
		        			dialogAlert('提示', '公司名称不能为空！');
		        			buttonOpen(button)
		        			return;
		        		}
		    			if(!tuserName.match(textReg)){
		    		    	dialogAlert('提示', '公司名称只能由中文，字母，数字组成！');
		    		    	buttonOpen(button)
		    		        return false;
		    		    }
		    			
						var tuserTag=form.find("#tuserTag").val();
		    			if(!tuserTag){
		        			dialogAlert('提示', '主营业务不能为空！');
		        			buttonOpen(button)
		        			return;
		        		}
						
						var tuserTeamType=form.find("#tuserTeamType").val();
						if(!tuserTeamType){
		        			dialogAlert('提示', '请选择公司类型！');
		        			buttonOpen(button)
		        			return;
		        		}
						if(!tuserTeamType.match(textReg)){
		    		    	dialogAlert('提示', '公司类型只能由中文，字母，数字组成！');
		    		    	buttonOpen(button)
		    		        return false;
		    		    }
						
						var tuserTeamRemark=form.find("#tuserTeamRemark").val();
						if(!tuserTeamRemark){
		        			dialogAlert('提示', '公司介绍不能为空！');
		        			buttonOpen(button)
		        			return;
		        		}
						
						if($("#"+formId+" .add-tuser-pic-list li.uploadLi").length==0){
			    			dialogAlert('提示', '请上传公司营业执照！');
		        			buttonOpen(button)
		        			return;
			    		}
						
			    		$("#"+formId+" .add-tuser-pic-list li.uploadLi").each(function(index, element) {
			    			formData.push({'name':'tuserPicture','value':$(element).attr("imgUrl")});
			    		});
						
		    		}
		    		
		    		if($("#"+formId+" .add-pic-list li.uploadLi").length==0){
		    			dialogAlert('提示', '请上传资质及作品！');
	        			buttonOpen(button)
	        			return;
		    		}

		    		$.post("${path}/wechatRoom/addRoomTeamUser.do",formData, function(data) {
		    			var msg=data.data;
		    			if(data.status==0){
		    				var ua = navigator.userAgent.toLowerCase();	
		    				var inputName=$("#inputName").val();
		    				subDialog(inputName,ua);
		    			}else{
		    				dialogAlert('提示', msg);
		    				buttonOpen(button)
		    			}
		    		},'json');
				});
				
				//页面跳转指定认证 0-个人；1-社团；2-公司
				var roomType = '${roomType}';
				if(roomType){
					$(".add-tab>ul>li").eq(roomType).click();
				}
				
			})
			
			//认证提示
		    function subDialog(inputName,ua) {
		        var winW = Math.min(parseInt($(window).width() * 0.82), 370);
		        var d = dialog({
		            width: winW,
		            title: '提示',
		            content: '提交成功',
		            fixed: true,
		            button: [{
		                value: '确定',
		                callback: function () {
		                	if(inputName){
		    		        	location.href = '${path}/wechatActivity/wcOrderList.do?userId='+userId+'&callback=${callback}&sourceCode=${sourceCode}';
		    				}else{
		    					if (/wenhuayun/.test(ua)) {		//APP端
		    						toUserCenter();
		    		        	}else{		//H5
		    		        		if("${callback}"){
		    		        			location.href = '${callback}wechatUser/preTerminalUser.do';
		    		        		}else{
		    		        			location.href = '${path}/wechatUser/preTerminalUser.do';
		    		        		}
		    		        	}
		    				}s
		                }
		            }]
		        });
		        d.showModal();
		    }
		</script>
</head>
<body>
	<div class="main">
		<input type="hidden" id="userId" name="userId" value="${userId }"/>
		<input type="hidden" id="roomOrderId" name="roomOrderId" value="${roomOrderId }"/>
		<input type="hidden" id="inputName" name="inputName" value="${tuserName }"/>
		<input type="hidden" id="tuserId" name="tuserId" value="${teamUser.tuserId }"/>
		<div class="header">
			<%-- <div class="index-top">
				<span class="index-top-5">
					<img src="${path}/STATIC/wechat/image/arrow1.png"  onclick="history.go(-1);"/>
				</span>
				<span class="index-top-2">添加使用者</span>
			</div> --%>
		</div>
		<div class="content padding-bottom0 margin-bottom100">
			<div class="add-tab fs30">
				<ul>
					<li class="h80 border-right">
						<div class="border-bottom2 c5e6d98">个人</div>
					</li>
					<li class="h80 border-right">
						<div>社团</div>
					</li>
					<li class="h80">
						<div>公司</div>
					</li>
					<div style="clear: both;"></div>
				</ul>
			</div>

			<!--个人-->
			<form id="personForm">
				<input type="hidden" id="tuserUserType" name="tuserUserType" value="1"/>
				<div class="add-tab-content">
					<div class="add-tab-list">
						<div class="one">
							<div class="border-bottom padding-bottom20">
								<p class="f-left fs30">个人姓名：</p><input placeholder="请输入个人姓名" class="f-left fs30 border-none margin-top5 c808080 w500" type="text" name="tuserName" id="tuserName" value="${tuserName }" />
								<div style="clear: both;"></div>
							</div>
							<div class="border-bottom padding-bottom20 margin-top20">
								<p class="f-left fs30">头衔/职位：</p><input placeholder="请输入头衔/职位" class="f-left fs30 border-none margin-top5 c808080 w500" type="text" name="tuserTag" id="tuserTag" value="" />
								<div style="clear: both;"></div>
							</div>
							<div class="border-bottom padding-bottom20 margin-top20">
								<p class="f-left fs30">从业年限：</p><input placeholder="请输入从业年限" class="f-left fs30 border-none margin-top5 c808080 w500" type="text" name="tuserYear" id="tuserYear" value="" />
								<div style="clear: both;"></div>
							</div>
							<div class="padding-bottom20 margin-top20">
								<p class="f-left fs30">自我介绍：</p><textarea id="tuserTeamRemark" name="tuserTeamRemark" placeholder="请输入自我介绍" class="h150 fs30 margin-top5 c808080" style="width: 500px;border: none;"></textarea>
								<div style="clear: both;"></div>
							</div>
						</div>
						<div class="add-tab-list margin-top20">
							<div class="one add-pic-list">
								<p class="fs30">资质及作品上传：</p>
								<ul class="user-upl margin-top20">
									<li class="user-upload border-none">
										<div class="add-pic-button" ontouchstart="uploadImg('personForm');">
											<img src="${path}/STATIC/wechat/image/add-comment.png" width="150px" height="150px" />
										</div>
									</li>
								</ul>
								<div style="clear: both;"></div>
								<div class="add-user-success">
									<input id="agree" class="f-left margin-top10 margin-right10" type="checkbox" style="width: 30px;height: 30px;" />
									<p class="f-left fs24">同意佛山文化云使用协议及规则</p>
								</div>
								<div style="clear: both;"></div>
							</div>
							<div class="add-tuser w100-pc h100" style="position:fixed;bottom:0px">
								<button type="button" class="bg7279a0 w100-pc height100-pc cfff fs40 border-none">提交认证</button>
							</div>
						</div>
					</div>
				</div>
			</form>
			
			<!--社团-->
			<form id="teamForm">
				<input type="hidden" id="tuserUserType" name="tuserUserType" value="0"/>
				<div class="add-tab-content" style="display: none;">
					<div class="add-tab-list">
						<div class="one">
							<div class="border-bottom padding-bottom20">
								<p class="f-left fs30">社团名称：</p><input placeholder="请输入社团名称" class="f-left fs30 border-none margin-top5 c808080 w500" type="text" name="tuserName" id="tuserName" value="${tuserName }" />
								<div style="clear: both;"></div>
							</div>
	
							<div class="border-bottom padding-bottom20 margin-top20">
								<p class="f-left fs30">成立年限：</p><input placeholder="请输入从业年限" class="f-left fs30 border-none margin-top5 c808080 w500" type="text" name="tuserYear" id="tuserYear" value="" />
								<div style="clear: both;"></div>
							</div>
	
							<div class="border-bottom padding-bottom20 margin-top20">
								<p class="f-left fs30">社团人数：</p><input placeholder="请输入社团人数" class="f-left fs30 border-none margin-top5 c808080 w500" type="text" name="tuserLimit" id="tuserLimit" value="" />
								<div style="clear: both;"></div>
							</div>
	
							<div class="border-bottom padding-bottom20 margin-top20 add-user-arrowr" onclick="getTeamUserType()">
								<p class="f-left fs30">社团类型：<span id="tuserTeamTypeName"></span><input type="hidden" id="tuserTeamType"  name="tuserTeamType" style="position: absolute; left: -9999px;" /></p>
								<div style="clear: both;"></div>
							</div>
	
							<div class="padding-bottom20 margin-top20">
								<p class="f-left fs30">社团介绍：</p><textarea id="tuserTeamRemark" name="tuserTeamRemark" placeholder="请输入社团介绍" class="h150 fs30 margin-top5 c808080" style="width: 500px;border: none;"></textarea>
								<div style="clear: both;"></div>
							</div>
						</div>
						<div class="add-tab-list margin-top20">
							<div class="one add-pic-list">
								<p class="fs30">资质及作品上传：</p>
								<ul class="user-upl margin-top20">
									<li class="user-upload border-none">
										<div class="add-pic-button" ontouchstart="uploadImg('teamForm');">
											<img src="${path}/STATIC/wechat/image/add-comment.png" width="150px" height="150px" />
										</div>
									</li>
								</ul>
								<div style="clear: both;"></div>
								<div class="add-user-success">
									<input id="agree" class="f-left margin-top10 margin-right10" type="checkbox" style="width: 30px;height: 30px;" />
									<p class="f-left fs24">同意佛山文化云使用协议及规则</p>
								</div>
								<div style="clear: both;"></div>
							</div>
							<div class="add-tuser w100-pc h100" style="position:fixed;bottom:0px">
								<button type="button" class="bg7279a0 w100-pc height100-pc cfff fs40 border-none">提交认证</button>
							</div>
						</div>
					</div>
				</div>
			</form>
			
			<!--公司-->
			<form id="companyForm">
				<input type="hidden" id="tuserUserType" name="tuserUserType" value="2"/>
				<div class="add-tab-content" style="display: none;">
					<div class="add-tab-list">
						<div class="one">
							<div class="border-bottom padding-bottom20">
								<p class="f-left fs30">公司名称：</p><input placeholder="请输公司名称" class="f-left fs30 border-none margin-top5 c808080 w500" type="text"name="tuserName" id="tuserName" value="${tuserName }" />
								<div style="clear: both;"></div>
							</div>
	
							<div class="border-bottom padding-bottom20 margin-top20">
								<p class="f-left fs30">主营业务：</p><input placeholder="请输入主营业务" class="f-left fs30 border-none margin-top5 c808080 w500" type="text" name="tuserTag" id="tuserTag" value="" />
								<div style="clear: both;"></div>
							</div>
	
							 <div class="border-bottom padding-bottom20 margin-top20 add-user-arrowr" onclick="getCompanyType()">
								<p class="f-left fs30">公司类型：<span id="tuserTeamTypeName"></span><input type="hidden" id="tuserTeamType"  name="tuserTeamType" style="position: absolute; left: -9999px;" /></p>
								<div placeholder="请输入从业年限" class="f-left fs30 border-none margin-top5 c808080"></div>
								<div style="clear: both;"></div>
							</div>
	
							<div class="padding-bottom20 margin-top20">
								<p class="f-left fs30">公司介绍：</p><textarea id="tuserTeamRemark" name="tuserTeamRemark" placeholder="请输公司介绍" class="h150 fs30 margin-top5 c808080" style="width: 500px;border: none;"></textarea>
								<div style="clear: both;"></div>
							</div>
						</div>
						<div class="add-tab-list margin-top20">
							<div class="one add-tuser-pic-list">
								<p class="fs30">公司营业执照上传：</p>
								<ul class="tuser-upl margin-top20">
									<li class="user-upload border-none">
										<div class="add-tuser-pic-button" ontouchstart="uploadTuserPic();">
											<img src="${path}/STATIC/wechat/image/add-comment.png" width="150px" height="150px" />
										</div>
									</li>
								</ul>
								<div style="clear: both;"></div>
							</div>
							<div class="one add-pic-list">
								<p class="fs30">资质及作品上传：</p>
								<ul class="user-upl margin-top20">
									<li class="user-upload border-none">
										<div class="add-pic-button" ontouchstart="uploadImg('companyForm');">
											<img src="${path}/STATIC/wechat/image/add-comment.png" width="150px" height="150px" />
										</div>
									</li>
								</ul>
								<div style="clear: both;"></div>
								<div class="add-user-success">
									<input id="agree" class="f-left margin-top10 margin-right10" type="checkbox" style="width: 30px;height: 30px;" />
									<p class="f-left fs24">同意佛山文化云使用协议及规则</p>
								</div>
								<div style="clear: both;"></div>
							</div>
							<div class="add-tuser w100-pc h100" style="position:fixed;bottom:0px">
								<button type="button" class="bg7279a0 w100-pc height100-pc cfff fs40 border-none">提交认证</button>
							</div>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
</body>
<script>
	var userId = '${userId}';

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
		$("#personForm .add-pic-button").addClass("uploadClass1");
		$("#personForm .add-pic-button").attr("ontouchstart","");
		$("#teamForm .add-pic-button").addClass("uploadClass2");
		$("#teamForm .add-pic-button").attr("ontouchstart","");
		$("#companyForm .add-pic-button").addClass("uploadClass3");
		$("#companyForm .add-pic-button").attr("ontouchstart","");
		$(".add-tuser-pic-button").addClass("uploadClass4");
		$(".add-tuser-pic-button").attr("ontouchstart","");
		
		// Web Uploader实例
		var uploader1;	//个人资质
		var uploader2;	//社团资质
		var uploader3;	//公司资质
		var uploader4;	//公司执照
		
		upload1();
	}
</script>
</html>