<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>

<head>
    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/aliImageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/dc/css/whyupload.css"/>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/dc/css/lcc.css"/>
    
    <script type="text/javascript">
	    var userId = '${sessionScope.user.userId}';
	    var videoId = '${dcVideo.videoId}';
	    var reviewType = '${reviewType}';
	    var videoType = '${videoType}';
	    
		if (userId == null || userId == '') {
			location.href = '${path}/admin.do';
		}
    
		window.onload = function() { 
			//阿里上传初始化
	    	aliUploadImg(uploadImgCallBack, 1);
		}
		
	    $(function () {
	    	
	    	// 封面放大
	    	$('.reviewps .wztup .b').bind('click', function () {
	    		$('.resfenm').show();
	    	});
	    	$('.resfenm').bind('click', function () {
	    		$('.resfenm').hide();
	    	});
	    	$('.resfenm img').bind('click', function (evt) {
	    		setStopPropagation(evt);
	    	});
	    	
	    	//评分汇总tab
	    	$('.reviewps .rsfen_tit span').bind('click', function () {
	    		$('.reviewps .rsfen_div .rsfen_2').hide();
	    		$('.reviewps .rsfen_div .rsfen_2').eq($(this).index()).show();
	    		$('.reviewps .rsfen_tit span').removeClass('active');
	    		$(this).addClass('active');
	    	});
	    });
	    
	    function setStopPropagation(evt) {
    		var e = evt || window.event;
    		if(typeof e.stopPropagation == 'function') {
    			e.stopPropagation();
    		} else {
    			e.cancelBubble = true;
    		}	
    	}
	    
	    //技术审核
	    function videoTreview(videoStatus){
	    	var videoImgUrl = $("#videoImgUrl").val();
	    	var data = {
	    		reviewType:reviewType,
	    		videoId:videoId,
	    		videoStatus:videoStatus,
	    		videoImgUrl:videoImgUrl,
	    		videoTreviewUser:userId
	    	}
	    	$.post("${path}/dcVideo/editDcVideo.do",data, function (data) {
    			if (data == "200") {
    				dialogAlert('系统提示', "审核完成",function(){
    					location.href = '${path}/dcVideo/dcVideoIndex.do?reviewType='+reviewType;
    				});
    			}else{
    				dialogAlert('系统提示', "审核失败");
    			}
    		},"json");
	    }
	    
	  	//海选审核
	    function videoReview(videoReviewResult){
	    	var reviewReason = $("#reviewReason").val();
	  		if(videoReviewResult==0&&reviewReason.trim() == ""){
	  			dialogAlert('系统提示', "请填写理由！");
	  		}else{
	  			var data = {
	  				reviewType:reviewType,
  		    		videoId:videoId,
  		    		videoReviewResult:videoReviewResult,
  		    		videoReviewUser:userId,
  		    		videoReviewReason:reviewReason
  		    	}
  		    	$.post("${path}/dcVideo/editDcVideo.do",data, function (data) {
  	    			if (data == "200") {
  	    				dialogAlert('系统提示', "审核完成",function(){
  	    					location.href = '${path}/dcVideo/dcVideoIndex.do?reviewType='+reviewType+'&videoType='+videoType;
  	    				});
  	    			}else{
  	    				dialogAlert('系统提示', "审核失败");
  	    			}
  	    		},"json");
	  		}
	    }
	  	
	  	//海选复审
	    function videoSreview(videoStatus){
	    	var reviewSreason = $("#reviewSreason").val();
	  		if(videoStatus==4&&reviewSreason.trim() == ""){
	  			dialogAlert('系统提示', "请填写理由！");
	  		}else{
	  			var data = {
	  				reviewType:reviewType,
  		    		videoId:videoId,
  		    		videoStatus:videoStatus,
  		    		videoSreviewUser:userId,
  		    		videoSreviewReason:reviewSreason
  		    	}
  		    	$.post("${path}/dcVideo/editDcVideo.do",data, function (data) {
  	    			if (data == "200") {
  	    				dialogAlert('系统提示', "审核完成",function(){
  	    					location.href = '${path}/dcVideo/dcVideoIndex.do?reviewType='+reviewType;
  	    				});
  	    			}else{
  	    				dialogAlert('系统提示', "审核失败");
  	    			}
  	    		},"json");
	  		}
	    }
	  	
	  	//专家评分
	    function videoScore(){
	    	var scoreResult = $("#scoreResult").val();
	    	var scoreReason = $("#scoreReason").val();
	  		if(scoreResult.trim() == ""){
	  			dialogAlert('系统提示', "请填写评分！");
	  		}else if(!/^[0-9]*$/.test(scoreResult)||scoreResult>100||scoreResult<0){
	  			dialogAlert('系统提示', "请正确填写评分！");
	  		}else if(scoreReason.trim() == ""){
	  			dialogAlert('系统提示', "请填写理由！");
	  		}else{
	  			var data = {
	  				reviewType:reviewType,
  		    		videoId:videoId,
  		    		videoReviewResult:scoreResult,
  		    		videoReviewUser:userId,
  		    		videoReviewReason:scoreReason
  		    	}
  		    	$.post("${path}/dcVideo/editDcVideo.do",data, function (data) {
  	    			if (data == "200") {
  	    				dialogAlert('系统提示', "评分完成",function(){
  	    					location.href = '${path}/dcVideo/dcVideoIndex.do?reviewType='+reviewType+'&videoType='+videoType;
  	    				});
  	    			}else{
  	    				dialogAlert('系统提示', "评分失败");
  	    			}
  	    		},"json");
	  		}
	    }
	  	
	  	//上传回调函数
	    function uploadImgCallBack(up, file, info){
	    	var aliImgUrl = "${aliImgUrl}" + info 
	    	$("#videoImgUrl").val(aliImgUrl)
		}
    </script>
</head>

<body>
    <div class="lccmain">
		<div class="site">
			<em>您现在所在的位置：</em>配送中心 &gt; 
			<c:if test="${reviewType==1}">技术审核</c:if>
			<c:if test="${reviewType==2}">海选评审</c:if>
			<c:if test="${reviewType==3}">海选复审</c:if>
			<c:if test="${reviewType==4}">专家评审</c:if>
			<c:if test="${reviewType==5}">评分汇总</c:if>
		</div>
		<div class="site-title">
			<c:if test="${reviewType==1}">技术审核</c:if>
			<c:if test="${reviewType==2}">海选评审</c:if>
			<c:if test="${reviewType==3}">海选复审</c:if>
			<c:if test="${reviewType==4}">专家评审</c:if>
			<c:if test="${reviewType==5}">评分汇总</c:if>
		</div>
		<div class="reviewps">
			<div class="padd">
				<div class="revideo" style="background-color: #000;">
					<video src="${dcVideo.videoUrl}" style="max-width:820px;max-height:615px;margin:auto;" controls="controls">
						您的浏览器不支持 video 标签。
					</video>
				</div>
			</div>
			<div class="padd">
				<div class="repstit clearfix">${dcVideo.videoName}<span>约${dcVideo.videoLength}分钟</span></div>
			</div>
			<div class="padd">
				<div class="repswz">
					<p>${dcVideo.videoIntro}</p>
					<c:if test="${not empty dcVideo.videoImgUrl}">
						<div class="wztup clearfix">
							<div class="pic"><img src="${dcVideo.videoImgUrl}@100w"></div>
							<div class="b">查看封面原图</div>
						</div>
					</c:if>
					<c:if test="${empty dcVideo.videoImgUrl && reviewType==1}">
						<div class="whyUploadVedio">
							<div style="margin-top: 25px;width: 500px;">
								<div class="whyUploadImgDiv">
									<img src="${path}/STATIC/image/defaultImg.png" id="containerImg2" style="max-height: 750px;max-width: 750px;" />
									<div style="font-size: 14px;color: #999;line-height: 25px;">尺寸为：320*200，节目预览图片上传，格式为：jpg,png,bmp</div>
									<input type="hidden" id="videoImgUrl" name="videoImgUrl" value=""/>
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
					</c:if>
				</div>
			</div>
			<div class="respbaix">
				<div class="padd">
					<table class="rstab">
						<tr>
							<td class="td1"><span>报&nbsp;&nbsp;送&nbsp;&nbsp;人</span></td>
							<td class="td2"><input class="tabtxt" type="text" disabled="disabled" value="${dcVideo.createUser}"></td>
							<td class="td1"><span>所属区域</span></td>
							<td class="td2"><input class="tabtxt" type="text" disabled="disabled" value="${fn:substringAfter(dcVideo.userArea, ',')}"></td>
						</tr>
						<tr>
							<td class="td1"><span>活动中心</span></td>
							<td class="td2"><input class="tabtxt" type="text" disabled="disabled" value="${dcVideo.videoActivityCenter}"></td>
							<td class="td1">&nbsp;</td>
							<td class="td2">&nbsp;</td>
						</tr>
					</table>
					<div class="tabxian"></div>
					<table class="rstab">
						<tr>
							<td class="td1"><span>指&nbsp;&nbsp;导&nbsp;&nbsp;员</span></td>
							<td class="td2"><input class="tabtxt" type="text" disabled="disabled" value="${dcVideo.videoGuide}"></td>
							<td class="td1"><span>参演团队</span></td>
							<td class="td2"><input class="tabtxt" type="text" disabled="disabled" value="${dcVideo.videoTeamName}"></td>
						</tr>
						<tr>
							<td class="td1"><span>参演类别</span></td>
							<td class="td2">
								<c:choose>
									<c:when test="${dcVideo.videoType=='沪剧'||dcVideo.videoType=='越剧'||dcVideo.videoType=='京剧'||dcVideo.videoType=='其他'}">
										<input class="tabtxt" type="text" disabled="disabled" value="戏曲/曲艺">
									</c:when>
									<c:otherwise>
										<input class="tabtxt" type="text" disabled="disabled" value="${dcVideo.videoType}">
									</c:otherwise>
								</c:choose>
							</td>
							<td class="td1"><span>参演人数</span></td>
							<td class="td2"><input class="tabtxt" type="text" disabled="disabled" value="${dcVideo.videoTeamCount}"></td>
						</tr>
						<c:if test="${dcVideo.videoType=='沪剧'||dcVideo.videoType=='越剧'||dcVideo.videoType=='京剧'||dcVideo.videoType=='其他'}">
							<tr>
								<td class="td1"><span>戏曲/曲艺类别</span></td>
								<td class="td2"><input class="tabtxt" type="text" disabled="disabled" value="${dcVideo.videoType}"></td>
							</tr>
						</c:if>
						<c:if test="${not empty dcVideo.videoTeamRemark}">
							<tr>
								<td class="td1 tdarea"><span>备　　注</span></td>
								<td class="td2" colspan="3"><textarea class="tabarea" disabled="disabled">${dcVideo.videoTeamRemark}</textarea></td>
							</tr>
						</c:if>
					</table>
				</div>
			</div>
			<c:if test="${reviewType==1}">
				<div class="respbaix">
					<div class="padd resbtn">
						<a class="blue" href="javascript:videoTreview(3);">通过</a>
						<a class="red" href="javascript:videoTreview(2);">不通过</a>
					</div>
				</div>
			</c:if>
			<c:if test="${reviewType==2}">
				<div class="respbaix">
					<div class="padd">
						<table class="rstab_2">
							<tr>
								<td class="td1 tdarea"><span>理　　由</span></td>
								<td class="td2"><textarea id="reviewReason" class="tabarea tabtxtKT" maxlength="250">${dcVideo.videoReviewReason}</textarea></td>
							</tr>
							<tr>
								<td class="td1 tdarea">&nbsp;</td>
								<td class="td2"><div class="wz"><span>评审“不通过”，请写明理由；</span>评审“通过”，无需填写此项！</div></td>
							</tr>
						</table>
					</div>
					<div class="padd resbtn">
						<a class="red" href="javascript:videoReview(0);">不通过</a>
						<a class="blue" href="javascript:videoReview(1);">通过</a>
					</div>
				</div>
			</c:if>
			<c:if test="${reviewType==3}">
				<div class="respbaix">
					<div class="padd">
						<c:set var="items" value="${fn:split(dcVideo.videoReviewUser, ',')}"></c:set>
						<c:forEach items="${items}" var="dom" varStatus="i">
							<table class="rstab_4">
								<tr>
									<td class="td1"><span>评委${i.index+1}</span></td>
									<td class="td2"><input class="tabtxt" type="text" disabled="disabled" value="${dom}"></td>
									<td class="td3">
										<c:if test="${fn:split(dcVideo.videoReviewResult, ',')[i.index]==1}">
											<input class="tabbtn" type="button" disabled="disabled" value="通过">
										</c:if>
										<c:if test="${fn:split(dcVideo.videoReviewResult, ',')[i.index]==0}">
											<input class="tabbtn" type="button" disabled="disabled" value="不通过">
										</c:if>
									</td>
								</tr>
								<c:if test="${fn:split(dcVideo.videoReviewResult, ',')[i.index]==0}">
									<tr>
										<td class="td1 tdarea"><span>理　　由</span></td>
										<td class="td2" colspan="2"><textarea class="tabarea" disabled="disabled" maxlength="250">${fn:split(dcVideo.videoReviewReason, ',')[i.index]}</textarea></td>
									</tr>
								</c:if>
							</table>
							<c:if test="${fn:length(items)}>i}">
								<div class="tabxian"></div>
							</c:if>
						</c:forEach>
					</div>
				</div>
				<div class="respbaix">
					<div class="padd">
						<table class="rstab_2">
							<tr>
								<td class="td1 tdarea"><span>理　　由</span></td>
								<td class="td2"><textarea id="reviewSreason" class="tabarea tabtxtKT" maxlength="250">${dcVideo.videoSreviewReason}</textarea></td>
							</tr>
							<tr>
								<td class="td1 tdarea">&nbsp;</td>
								<td class="td2"><div class="wz"><span>评审“不通过”，请写明理由；</span>评审“通过”，无需填写此项！</div></td>
							</tr>
						</table>
					</div>
					<div class="padd resbtn">
						<a class="red" href="javascript:videoSreview(4);">不通过</a>
						<a class="blue" href="javascript:videoSreview(5);">通过</a>
					</div>
				</div>
			</c:if>
			<c:if test="${reviewType==4}">
				<div class="respbaix">
					<div class="padd">
						<table class="rstab rstab_3">
							<tr>
								<td class="td1"><span><em style="font-style:normal;color:#e12c57;">* </em>评　　分</span></td>
								<td class="td2"><input id="scoreResult" class="tabtxt tabtxtKT" type="text" value="${dcVideo.videoReviewResult}"></td>
								<td class="td3" colspan="2"><span style="color:red;">请输入评分，分数为0~100的整数</span></td>
							</tr>
							<tr>
								<td class="td1"><span><em style="font-style:normal;color:#e12c57;">* </em>评　　语</span></td>
								<td class="td2" colspan="3"><textarea id="scoreReason" class="tabarea tabtxtKT" maxlength="250">${dcVideo.videoReviewReason}</textarea></td>
							</tr>
						</table>
					</div>
					<div class="padd resbtn resbtn_input">
						<a class="blue" href="javascript:videoScore();">确定</a>
					</div>
				</div>
			</c:if>
			<c:if test="${reviewType==5}">
				<c:set var="itemsuser" value="${fn:split(dcVideo.videoReviewUser, ',')}"></c:set>
				<c:set var="itemstime" value="${fn:split(dcVideo.videoReviewTime, ',')}"></c:set>
				<c:set var="itemsresult" value="${fn:split(dcVideo.videoReviewResult, ',')}"></c:set>
				<c:set var="itemsreason" value="${fn:split(dcVideo.videoReviewReason, ',')}"></c:set>
				<div class="respbaix respbaix_rsfen">
					<div class="rsfen_tit">
						<span class="active"><c:if test="${not empty itemsuser[0]}">专家：${itemsuser[0]}</c:if><c:if test="${empty itemsuser[0]}">专家暂未评分</c:if></span>
						<span><c:if test="${not empty itemsuser[1]}">专家：${itemsuser[1]}</c:if><c:if test="${empty itemsuser[1]}">专家暂未评分</c:if></span>
						<span><c:if test="${not empty itemsuser[2]}">专家：${itemsuser[2]}</c:if><c:if test="${empty itemsuser[2]}">专家暂未评分</c:if></span>
					</div>
					<div class="padd rsfen_div">
						<table class="rsfen_2" style="display: table;">
							<tr>
								<td class="td1"><span>评　　分</span></td>
								<td class="td2"><input class="tabtxt" type="text" disabled="disabled" value="${itemsresult[0]}"></td>
								<td class="td3"><span>分</span></td>
								<td class="td4">（评分时间：${itemstime[0]}）</td>
							</tr>
							<tr>
								<td class="td1 tdarea"><span>评　　语</span></td>
								<td class="td2" colspan="3"><textarea class="tabarea" disabled="disabled">${itemsreason[0]}</textarea></td>
							</tr>
						</table>
						<table class="rsfen_2">
							<tr>
								<td class="td1"><span>评　　分</span></td>
								<td class="td2"><input class="tabtxt" type="text" disabled="disabled" value="${itemsresult[1]}"></td>
								<td class="td3"><span>分</span></td>
								<td class="td4">（评分时间：${itemstime[1]}）</td>
							</tr>
							<tr>
								<td class="td1 tdarea"><span>评　　语</span></td>
								<td class="td2" colspan="3"><textarea class="tabarea" disabled="disabled">${itemsreason[1]}</textarea></td>
							</tr>
						</table>
						<table class="rsfen_2">
							<tr>
								<td class="td1"><span>评　　分</span></td>
								<td class="td2"><input class="tabtxt" type="text" disabled="disabled" value="${itemsresult[2]}"></td>
								<td class="td3"><span>分</span></td>
								<td class="td4">（评分时间：${itemstime[2]}）</td>
							</tr>
							<tr>
								<td class="td1 tdarea"><span>评　　语</span></td>
								<td class="td2" colspan="3"><textarea class="tabarea" disabled="disabled">${itemsreason[2]}</textarea></td>
							</tr>
						</table>
					</div>
				</div>
				<div class="respbaix">
					<div class="padd">
						<table class="rsfen">
							<tr>
								<td class="td1"><span>专家评分</span></td>
								<td class="td2"><input class="tabtxt" type="text" disabled="disabled" value="${dcVideo.videoExpertScore}"></td>
								<td class="td3"><span>分</span></td>
								<td class="td2">&nbsp;</td>
								<td class="td3">&nbsp;</td>
							</tr>
							<tr>
								<td class="td1"><span>大众评分</span></td>
								<td class="td2"><input class="tabtxt" type="text" disabled="disabled" value="${dcVideo.videoPublicScore}"></td>
								<td class="td3"><span>分</span></td>
								<td class="td2"><input class="tabtxt" type="text" disabled="disabled" value="${dcVideo.voteCount}"></td>
								<td class="td3"><span>票</span></td>
							</tr>
							<tr>
								<td class="td1 hong"><span>总分</span></td>
								<td class="td2"><input class="tabtxt hong" type="text" disabled="disabled" value="${dcVideo.videoTotalScore}"></td>
								<td class="td3"><span>分</span></td>
								<td class="td2">&nbsp;</td>
								<td class="td3">&nbsp;</td>
							</tr>
						</table>
					</div>
				</div>
			</c:if>
		</div>	
	</div>
	<div class="resfenm">
		<img src="${dcVideo.videoImgUrl}@700w">
	</div>
</body>
</html>