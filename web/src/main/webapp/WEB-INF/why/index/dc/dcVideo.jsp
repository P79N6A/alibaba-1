<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" pageEncoding="UTF-8" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <%@include file="/WEB-INF/why/common/frontIndexPageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/aliImageFrame.jsp"%>
    
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture-index.css" />
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/culture-index-new.css" />
    
     <link rel="stylesheet" type="text/css" href="${path}/STATIC/dc/css/whyupload.css"/>
    <style type="text/css">
	.aliRemoveBtn{display: none;}
    .error-msg{ padding-left: 10px; color: #ff0000; display: inline-block; *margin-top:-25px; line-height: 40px;}
    </style>
     <title>视频上传系统</title>
	</head>

	<body style="background-color: #ffffff;" ms-important="Login">

		<!--top start-->
		<!--top end-->
		<!--nav start-->
		<form id="form">
			<input type="hidden" id="videoId"  name="videoId" value="${video.videoId }"/>
		<div class="hp_navbg">
			<div class="hp_nav clearfix">
				<div class="logo fl">
					<img alt="文化云" src="${path}/STATIC/image/baiduLogo.png" width="80" height="48" />
				</div>
				<ul class="fl">
				</ul>
	       		 <div class="fr">
					<ul class="fl">
			            <li data-url="frontIndex"><a href="#" onclick="logout();">退出</a></li>
			            </ul>
			    </div>
				<!--search start-->
				
				<script type="text/javascript">
					/*导航当前样式*/
					var webUrlStr = window.location.href.split("/");
					var webUrl = webUrlStr[3];

					if(webUrl.indexOf("?") > 0) {
						webUrl = webUrl.split("?")[0];
					}
					//前台页面导航样式
					$(function() {
						
						$("#postfiles").click(function() {
							if($("#ossfile>div").length > 0) {
								$("#container").hide()
							}
						})

						$("#postfiles2").click(function() {
							if($(".whyUploadImgDiv>img").attr('src') != ''){
								$(".whyUploadImgDiv>img").remove()
							}
							if($("#ossfile2>div").length > 0) {
								$("#container2").hide()
							}
						})
						
						var userId = '${sessionScope.dcUser.userId}';
						if (userId == null || userId == '') {
						    window.location.href = '../dcFront/login.do';
						    return;
						}
						
						$("#queryType").val();
						$('.hp_nav ul li').each(function() {
							if($(this).attr("data-url") == webUrl) {
								$(this).addClass('h_nav').siblings().removeClass('h_nav');
								if($(this).attr("data-url") == "frontVenue") {
									$("#queryType").val("场馆");
								} else {
									$("#queryType").val();
								}
							} else if($(this).attr("data-url") == "/frontIndex/index.do") {
								$(this).addClass('h_nav').siblings().removeClass('h_nav');
								$("#queryType").val();
							}
						});
					});

					function outLogin() {
						$.post("/frontTerminalUser/outLogin.do", function(result) {
							location.href = "../frontIndex/index.do";
						});
					}

					$('#searchVal').keydown(function(event) {
						if(event.keyCode == 13) {
							$("#globalSearchBtn").trigger("click");
							event.preventDefault();
						}
					})

					$("#globalSearchBtn").on("click", function() {

						var queryType = $("#queryType").val();
						var searchVal = $("#searchVal").val();
						if(queryType == "场馆") {
							searchTopVenueList(searchVal);
						} else {
							searchTopActivityList(searchVal);
						}

					});

					function searchTopVenueList(venueName) {
						window.location.href = "/frontVenue/venueList.do?keyword=" + encodeURI(venueName);
					}

					function searchTopActivityList(activityName) {
						window.location.href = "/frontActivity/activityList.do?activityName=" + encodeURI(activityName);
					}
					
					function logout(){
						 $.post("${path}/dcFront/logout.do",function(){
							 
							 window.location.href = '../dcFront/login.do';
						 });
					}
				</script>
			</div>
		</div>

		<!--上传登录-->

		<div class="whyuploadMain">
			<div class="whyUploadDiv">
				<p class="nowPlace">您所在的位置：视频上传</p>
				<div class="whyUserLogin" style="height: auto;padding-bottom: 50px;">
					<div class="whyUpTitle">视频上传</div>
					<div>
						<div class="whyUpInfoL">
							<div class="whyUpInfoTitle">指导员信息</div>
							<ul style="width: 420px;margin: 30px auto 0;">
								<li>
									<div class="whyUpInputTitle"><span style="color: #e12c57;">*&nbsp;</span>指导员姓名</div>
									<div class="whyUpInputDiv">
										<input id="videoGuide" name="videoGuide" value="${video.videoGuide }" readOnly="true" type="text" style="width: 200px;height: 40px;padding-left: 15px;float: left;" />
										<div style="display: block;float: left;cursor: pointer;">
											<img src="${path}/STATIC/image/uparrow.png" width="40" height="40" id="teachName" />
										</div>
										<div style="clear: both;"></div>
										<div style="position: absolute;left: 0;top: 40px;width: 255px;max-height: 400px;z-index: 10;overflow-y: scroll;">
											<div class="whyUpTbList" id="teachNameList">
												<ul>
												<c:forEach items="${fn:split(sessionScope.dcUser.areaOfficer,'，')}" var="areaOfficer">
														<li>${areaOfficer }</li>
												</c:forEach>
												</ul>
											</div>
										</div>
										<span class="error-msg" id="videoGuideSpan"></span>
									</div>
									<div style="clear: both;"></div>
								</li>
								<li>
									<div class="whyUpInputTitle"><span style="color: #e12c57;">*&nbsp;</span>手机号</div>
									<div class="whyUpInputDiv">
										<input id="videoTelephone" name="videoTelephone" value="${video.videoTelephone }" type="text" maxlength="20" style="width: 225px;height: 40px;padding: 0 15px;" />
										<span class="error-msg" id="videoTelephoneSpan"></span>
									</div>
									<div style="clear: both;"></div>
								</li>
								<li>
									<div class="whyUpInputTitle"><span style="color: #e12c57;">*&nbsp;</span>所属活动中心</div>
									<div class="whyUpInputDiv">
										<input id="videoActivityCenter" name="videoActivityCenter" value="${video.videoActivityCenter }" readOnly="true" type="text" style="width: 200px;height: 40px;padding-left: 15px;float: left;" />
										<div style="display: block;float: left;cursor: pointer;">
											<img src="${path}/STATIC/image/uparrow.png" width="40" height="40" id="actCenter" />
										</div>
										<div style="clear: both;"></div>
										<div style="position: absolute;left: 0;top: 40px;width: 255px;max-height: 400px;z-index: 10;overflow-y: scroll;">
											<div class="whyUpTbList" id="actCenterList">
												<ul>
													<c:forEach items="${fn:split(sessionScope.dcUser.areaActivityCenter,'，')}" var="activityCenter">
														<li>${activityCenter }</li>
												</c:forEach>
												</ul>
											</div>
										</div>
										<span class="error-msg" id="videoActivityCenterSpan"></span>
									</div>
									<div style="clear: both;"></div>
								</li>
								<li>
									<div class="whyUpInputTitle"><span style="color: #e12c57;">*&nbsp;</span>参演类别</div>
									<div class="whyUpInputDiv">
										<c:choose>
											<c:when test="${video.videoType=='沪剧'||video.videoType=='越剧'||video.videoType=='京剧'||video.videoType=='其他'}">
												<input id="videoType" value="戏曲/曲艺" readOnly="true" type="text" style="width: 200px;height: 40px;padding-left: 15px;float: left;" />
											</c:when>
											<c:otherwise>
												<input id="videoType" value="${video.videoType }" readOnly="true" type="text" style="width: 200px;height: 40px;padding-left: 15px;float: left;" />
											</c:otherwise>
										</c:choose>
										
										<!-- 用于存储参演类别或曲艺类别的隐藏域 -->
										<input id="videoTypeHide" name="videoType" value="${video.videoType }" type="hidden"/>
										<div style="display: block;float: left;cursor: pointer;" id="showType">
											<img src="${path}/STATIC/image/uparrow.png" width="40" height="40" />
										</div>
										<div style="clear: both;"></div>
										<div style="position: absolute;left: 0;top: 40px;width: 255px;max-height: 400px;z-index: 10;overflow-y: scroll;">
											<div class="whyUpTbList" id="showTypeList">
												<ul>
													<li>舞蹈</li>
													<li>合唱</li>
													<li>时装</li>
													<li>戏曲/曲艺</li>
												</ul>
											</div>
										</div>
										<span class="error-msg" id="videoTypeSpan"></span>
									</div>
									<div style="clear: both;"></div>
								</li>
								<li id="dramaTypeLi" style="display: none;">
									<div class="whyUpInputTitle"><span style="color: #e12c57;">*&nbsp;</span>戏曲/曲艺类别</div>
									<div class="whyUpInputDiv">
										<input id="dramaType" value="${video.videoType }" readOnly="true" type="text" style="width: 200px;height: 40px;padding-left: 15px;float: left;" />
										<div style="display: block;float: left;cursor: pointer;" id="showType2">
											<img src="${path}/STATIC/image/uparrow.png" width="40" height="40" />
										</div>
										<div style="clear: both;"></div>
										<div style="position: absolute;left: 0;top: 40px;width: 255px;max-height: 400px;z-index: 10;overflow-y: scroll;">
											<div class="whyUpTbList" id="showTypeList2">
												<ul>
													<li>沪剧</li>
													<li>越剧</li>
													<li>京剧</li>
													<li>其他</li>
												</ul>
											</div>
										</div>
										<span class="error-msg" id="dramaTypeSpan"></span>
									</div>
									<div style="clear: both;"></div>
								</li>
								<script>
									if('${video.videoType}'=='沪剧'||'${video.videoType}'=='越剧'||'${video.videoType}'=='京剧'||'${video.videoType}'=='其他'){
										$("#dramaTypeLi").show();
									}
								</script>
							</ul>
						</div>
						<div class="whyUpInfoR">
							<div class="whyUpInfoTitle">参演团队信息</div>
							<ul style="width: 420px;margin: 30px auto 0;">
								<li>
									<div class="whyUpInputTitle"><span style="color: #e12c57;">*&nbsp;</span>参演团队名称</div>
									<div class="whyUpInputDiv">
										<input type="text" id="videoTeamName" name="videoTeamName" value="${video.videoTeamName }" style="width: 225px;height: 40px;padding: 0 15px;" />
										<span class="error-msg" id="videoTeamNameSpan"></span>
									</div>
									<div style="clear: both;"></div>
								</li>
								<li>
									<div class="whyUpInputTitle"><span style="color: #e12c57;">*&nbsp;</span>参演人数</div>
									<div class="whyUpInputDiv">
										<input type="number" id="videoTeamCount" name="videoTeamCount" value="${video.videoTeamCount }" min="1" max="100"  style="width: 225px;height: 40px;padding: 0 15px;" />
										<span class="error-msg" id="videoTeamCountSpan"></span>
									</div>
									<div style="float: left;width: 40px;height: 40px;line-height: 40px;text-align: center;">人</div>
									<div style="clear: both;"></div>
									<div style="position: absolute;right: 45px;bottom: -20px;font-size: 12px;color: #333;">（1-100人）</div>
								</li>
								<li>
									<div class="whyUpInputTitle">备注</div>
									<div style="float: left;border: 1px solid #cad5d9;margin-left: 20px;width: 255px;height: 165px;">
										<textarea id="videoTeamRemark" name="videoTeamRemark"  style="resize: none;" onkeyup="inputLimit(this,200,whyNoteNum)" maxlength="200">${video.videoTeamRemark }</textarea>
									</div>
									<div style="clear: both;"></div>
									<div style="position: absolute;right: 45px;bottom: -20px;font-size: 12px;color: #333;"><span id="whyNoteNum">0</span>/200字</div>
								</li>
							</ul>
						</div>
						<div style="clear: both;"></div>
					</div>
					<div class="whyVedioInfo">
						<div class="whyVedioInfoTitle">视频信息</div>
						<div class="whyVedioInfoContent">
							<div class="whyUploadVedio">
								<div style="float: left;width: 145px;text-align: right;font-size: 16px;color: #333;"><span style="color: #e12c57;">*&nbsp;</span>上传视频</div>
								<div style="float: right;width: 700px;font-size: 14px;color: #999;line-height: 25px;">舞蹈、合唱、时装类视频时长不得超过6分钟；戏曲／曲艺类视频不得超过8分钟；支持mp4,rm,mpg,avi,mov格式；画面要求稳定不抖动，突出主体和任务，分辨率越高越好！(只有mp4视频才可预览，其它格式视频需等待技术评审转码后预览)</div>
								<div style="clear: both;"></div>
								<div style="margin-left: 195px;margin-top: 25px;width: 500px;position: relative;">
									<div class="whyUploadImgDiv">
										<img src="${path}/STATIC/image/pic7.png" id="whyVideoImg" style="max-height: 100px;max-width: 100px;position: absolute;left: 0;top: 0;z-index: 1;" />
										<video src="${video.videoUrl }" id="containerImg1" style="max-height: 100px;max-width: 100px;">
											your browser does not support the video tag
										</video>
										<input type="hidden" id="videoUrl" name="videoUrl" value="${video.videoUrl }"/>
									</div>
									<div id="ossfile">你的浏览器不支持flash,Silverlight或者HTML5！</div>
									<!--<pre id="console"></pre>-->
									<br/>
									<div id="container">
										<a id="selectfiles" href="javascript:void(0);" class='btn'>1.选择文件</a>
										<a id="postfiles" href="javascript:void(0);" class='btn'>2.点击开始上传</a>
									</div>
									<span class="error-msg" id="videoUrlSpan"></span>
								</div>
							</div>
							<div class="whyUploadVedio">
								<div style="float: left;width: 145px;text-align: right;font-size: 16px;color: #333;">作品封面 </div>
								<div style="float: right;width: 700px;font-size: 14px;color: #999;line-height: 25px;">建议尺寸为：750*500，节目预览图片上传，格式为：jpg,png,bmp</div>
								<div style="clear: both;"></div>
								<div style="margin-left: 195px;margin-top: 25px;width: 500px;">
									<div class="whyUploadImgDiv" style="height:auto">
										<c:choose>
											<c:when test="${empty video.videoImgUrl }">
												
											</c:when>
											<c:otherwise>
												<img src="${video.videoImgUrl}" id="containerImg2" style="max-height: 100px;max-width: 100px;" />
											</c:otherwise>
										</c:choose>
										<input type="hidden" id="videoImgUrl" name="videoImgUrl" value="${video.videoImgUrl }"/>
									</div>
									<div id="ossfile2">你的浏览器不支持flash,Silverlight或者HTML5！</div>
									<!--<pre id="console"></pre>-->
									<br/>
									<div id="container2">
										<a id="selectfiles2" href="javascript:void(0);" class='btn'>1.选择文件</a>
										<a id="postfiles2" href="javascript:void(0);" class='btn'>2.点击开始上传</a>
									</div>
								</div>
								<span class="error-msg" id="videoImgUrlSpan"></span>
							</div>
							<div style="margin-top: 30px;">
								<div class="whyUpLVedioInfo">
									<p style="float: left;width: 100px;text-align: right;line-height: 40px;margin-left: 45px;"><span style="color: #e12c57;">*&nbsp;</span>作品名称</p>
									<div style="float: left;width: 200px;height: 40px;border: 1px solid #cad5d9;position: relative;margin-left: 50px;position: relative;">
										<input id="videoName" name="videoName" value="${video.videoName }" type="text" maxlength="18" onkeyup="inputLimit(this,18,detailTitle)" />
										<div style="position: absolute;right: 0;bottom: -25px;font-size: 12px;color: #333;"><span id="detailTitle">0</span>/18字</div>
										<span class="error-msg" id="videoNameSpan"></span>
									</div>
									<div style="clear: both;"></div>
								</div>
								<div class="whyUpLVedioInfo" style="margin-left: 100px;">
									<p style="float: left;width: 100px;text-align: right;line-height: 40px;"><span style="color: #e12c57;">*&nbsp;</span>作品时长约</p>
									<div style="float: left;width: 200px;height: 40px;border: 1px solid #cad5d9;position: relative;margin-left: 50px;">
										<input id="videoLength" name="videoLength" value="${video.videoLength }" type="text" min="0" />
										<span class="error-msg" id="videoLengthSpan"></span>
									</div>
									<span style="line-height: 40px;margin-left: 10px;">分钟</span>
									<div style="clear: both;"></div>
								</div> 
								<div style="clear: both;"></div>
								<div class="whyUpLVedioInfo" style="float: none;margin-top: 30px;">
									<p style="float: left;width: 100px;text-align: right;line-height: 40px;margin-left: 45px;"><span style="color: #e12c57;">*&nbsp;</span>作品简介</p>
									<div style="float: left;width: 400px;height: 200px;border: 1px solid #cad5d9;position: relative;margin-left: 50px;">
										<textarea id="videoIntro" name="videoIntro" style="resize: none;" onkeyup="inputLimit(this,200,detailInput)" maxlength="200">${video.videoIntro }</textarea>
										<div style="position: absolute;right: 0;bottom: -25px;font-size: 12px;color: #333;"><span id="detailInput">0</span>/200字</div>
										<div style="position: absolute;left: 0;bottom: -25px;font-size: 12px;color: #e12c57;">不得上传未经授权的他人作品，以及色情、反动等违法视频。</div>
									</div>
									<span class="error-msg" id="videoIntroSpan"></span>
									<div style="clear: both;"></div>
								</div>
								<div style="width: 500px;margin: 100px auto 0;">
									<div class="whyBackBtn" onclick="javascript:history.go(-1);">返回</div>
									<div class="whySubmitBtn">提交</div>
									<div style="clear: both;"></div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		</form>
	</body>
	<script>
	//备注输入限制
	function inputLimit(obj, num, ID) {
		var oldInput = $(obj).val()
		console.log($(obj).val().length)
		$(ID).text($(obj).val().length)
		if($(obj).val().length > num) {
			$(obj).val(oldInput.substr(0, num))
		}
	}
	
	function uploadImgCallBack(up, file, info){
    	var aliImgUrl = "${aliImgUrl}" + info 
    	//$(".aliImg").find("img").attr("src",aliImgUrl).css({"width":"100px","height":"100px"})
    	$("#videoImgUrl").val(aliImgUrl)
	}
	
	function uploadVideoCallBack(up, file, info){
    	var aliVideoUrl = "${aliImgUrl}" + info 
    //	$(".aliImg").find("img").attr("src",aliImgUrl+"@300w").css({"width":"100px","height":"100px"})
    	$("#videoUrl").val(aliVideoUrl)
	}
	
	 function dialogTypeSaveDraft(title, content, fn){
	        var d = parent.dialog({
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

	
	window.onload = function() { 
		aliUploadImg(uploadImgCallBack, 1)
		aliUploadVideo(uploadVideoCallBack, 1)
	}
	
		//上传初始化
		$(function() {
			
			// 保存
			$(".whySubmitBtn").click(function() {
			
				var videoGuide = $("#videoGuide").val();
                if(videoGuide==undefined||$.trim(videoGuide)==""){
                    $("#videoGuideSpan").html("请选择指导员姓名");
                    $('#videoGuide').focus();
                    return;
                }else{
                    $("#videoGuideSpan").html("");
                }
                
                var videoTelephone = $("#videoTelephone").val();
                if(videoTelephone==undefined||$.trim(videoTelephone)==""){
                    $("#videoTelephoneSpan").html("请输入联系电话");
                    $('#videoTelephone').focus();
                    return;
                }else{
                    $("#videoTelephoneSpan").html("");
                }

                var videoActivityCenter = $("#videoActivityCenter").val();
                if(videoActivityCenter==undefined||$.trim(videoActivityCenter)==""){
                    $("#videoActivityCenterSpan").html("请选择活动中心");
                    $('#videoActivityCenter').focus();
                    return;
                }else{
                    $("#videoActivityCenterSpan").html("");
                }
                
                var videoType = $("#videoType").val();
                if(videoType==undefined||$.trim(videoType)==""){
                    $("#videoTypeSpan").html("请选择参演类别");
                    $('#videoType').focus();
                    return;
                }else{
                    $("#videoTypeSpan").html("");
                    var dramaType = $("#dramaType").val();
                    if(videoType=="戏曲/曲艺"){
                    	if(dramaType==undefined||$.trim(dramaType)==""){
                       	 $("#dramaTypeSpan").html("请选择戏曲类别");
                            $('#dramaType').focus();
                            return;
                       }else{
                       		$("#dramaTypeSpan").html("");
                       }
                    }else{
                    	$("#dramaTypeSpan").html("");
                    }
                }
                
                var videoTeamName = $("#videoTeamName").val();
                if(videoTeamName==undefined||$.trim(videoTeamName)==""){
                    $("#videoTeamNameSpan").html("请输入参演团队名称");
                    $('#videoTeamName').focus();
                    return;
                }else{
                    $("#videoTeamNameSpan").html("");
                }
                
                var videoTeamCount = $("#videoTeamCount").val();
                if(videoTeamCount==undefined||$.trim(videoTeamCount)==""){
                    $("#videoTeamCountSpan").html("请输入参演人数");
                    $('#videoTeamCount').focus();
                    return;
                }else{
                    $("#videoTeamCountSpan").html("");
                }
                
                if(parseInt(videoTeamCount)>100){
                	  $("#videoTeamCountSpan").html("参演人数不能大于100");
                      $('#videoTeamCount').focus();
                      return;
                }else{
                    $("#videoTeamCountSpan").html("");
                }
                
                if(parseInt(videoTeamCount)<1){
              	  	$("#videoTeamCountSpan").html("参演人数不能小于1");
                    $('#videoTeamCount').focus();
                    return;
              	}else{
                  $("#videoTeamCountSpan").html("");
              	}
                
                var videoTeamCount = $("#videoTeamCount").val();
                if(videoTeamCount==undefined||$.trim(videoTeamCount)==""){
                    $("#videoTeamCountSpan").html("请输入参演人数");
                    $('#videoTeamCount').focus();
                    return;
                }else{
                    $("#videoTeamCountSpan").html("");
                }
                
                var videoUrl = $("#videoUrl").val();
                if(videoUrl==undefined||$.trim(videoUrl)==""){
                    $("#videoUrlSpan").html("请上传视频");
                    $('#videoUrl').focus();
                    return;
                }else{
                    $("#videoUrlSpan").html("");
                }
                
                var videoName = $("#videoName").val();
                if(videoName==undefined||$.trim(videoName)==""){
                    $("#videoNameSpan").html("请输入作品名称");
                    $('#videoName').focus();
                    return;
                }else{
                    $("#videoNameSpan").html("");
                }
                
                var videoLength = $("#videoLength").val();
                if(videoLength==undefined||$.trim(videoLength)==""){
                    $("#videoLengthSpan").html("请输入作品时长");
                    $('#videoLength').focus();
                    return;
                }else if (!/^[0-9]*$/.test(videoLength)){
                	  $("#videoLengthSpan").html("作品时长只能输入整数");
                      $('#videoLength').focus();
                      return;
                }else{
                    $("#videoLengthSpan").html("");
                }
                
                var videoIntro = $("#videoIntro").val();
                if(videoIntro==undefined||$.trim(videoIntro)==""){
                    $("#videoIntroSpan").html("请输入作品简介");
                    $('#videoIntro').focus();
                    return;
                }else{
                    $("#videoIntroSpan").html("");
                }
                
                $.post("${path}/dcFront/saveDcVideo.do", $("#form").serialize(), function(result) {
                    if(result == "repeat"){
                        dialogTypeSaveDraft("提示", "指导员信息重复（同一指导员，同一所属活动中心，不能重复报名同一参演类别）");
                    }else if (result == "success") {
                    	 window.location.href = '../dcFront/saveSuccess.do';
                    }else if(result=="cantUpdate") {
                    	 dialogTypeSaveDraft("提示", "该作品技术评审已通过进入海选");
                    }else if (result == "login") {
                        dialogTypeSaveDraft("提示", "请先登录", function(){
                       	 window.location.href = '../dcFront/login.do';
                        });
                    }else{
                        dialogTypeSaveDraft("提示", "保存失败");
                    }
                });
			})
			
			//上传视频预览
			$("#whyVideoImg").click(function() {
				if($("#containerImg1").attr("src") != '') {
					document.getElementById('containerImg1').play()
					$(this).hide()
				}
			})
			$("#containerImg1").click(function() {
				$("#whyVideoImg").show()
				document.getElementById('containerImg1').pause()
			})
			
			//指导员姓名下拉框
			$("#teachName").click(function(){
				$("#teachNameList").show()
			})
			$("#teachNameList li").click(function(){
				$("#videoGuide").val($(this).text())
				$("#teachNameList").hide()
			})
			
			//参演类别下拉框
			$("#showType").click(function(){
				$("#showTypeList").show()
			})
			$("#showTypeList li").click(function(){
				$("#videoType").val($(this).text())
				$("#videoTypeHide").val($(this).text())
				$("#showTypeList").hide()
				if($(this).text() == "戏曲/曲艺"){
					$("#dramaType").val("");
					$("#dramaTypeLi").show();
				}else{
					$("#dramaTypeLi").hide();
				}
			})
			
			//戏曲类别下拉框
			$("#showType2").click(function(){
				$("#showTypeList2").show()
			})
			$("#showTypeList2 li").click(function(){
				$("#dramaType").val($(this).text())
				$("#videoTypeHide").val($(this).text())
				$("#showTypeList2").hide()
			})
			
			
			//所属活动中心下拉框
			$("#actCenter").click(function(){
				$("#actCenterList").show()
			})
			$("#actCenterList li").click(function(){
				$("#videoActivityCenter").val($(this).text())
				$("#actCenterList").hide()
			})
		})
		
	</script>

</html>