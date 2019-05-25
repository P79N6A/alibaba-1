<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>
    <%@include file="/WEB-INF/why/index/cnwd/aliImageFrame.jsp"%>
	<meta charset="UTF-8">
	<title>第二步</title>
	<link rel="stylesheet" type="text/css" href="${path }/STATIC/css/cnwd/reset.css">
	<link rel="stylesheet" type="text/css" href="${path }/STATIC/css/cnwd/dance.css">
	<link rel="Stylesheet" type="text/css" href="${path }/STATIC/css/cnwd/DialogBySHF.css" />
	<script type="text/javascript" src="${path }/STATIC/js/cnwd/DialogBySHF.js"></script>
</head>
<style>
	#assnImgUrlWebupload div[name = aliFile] br,#assnImgUrlWebupload div[name = aliFile] span,#assnImgUrlWebupload div[name = aliFile] b,div[name = aliFile] .progress{
		display:none!important;	
	}
	#assnImgUrlWebupload div[name = aliFile] img:nth-child(1){
		position:relative!important;
	}
	
	#assnImgUrlWebupload div[name = aliFile] .aliRemoveBtn{
		position:absolute;
		right:0;
		top:0;
		width:20px!important;
		height:20px!important;
	}
	#ossfile2 div[name=aliFile] span{
		display:block!important;
	}
</style>
<body>
    <%@include file="/WEB-INF/why/index/cnwd/header.jsp"%>
	<p class="crumbs">我的位置：2017年舞蹈大赛</p>


	<ul class="steps">
		<li class="cur">填写团队基本信息</li>
		<hr class="hrone cur">
		<li class="cur">上传参赛视频</li>
		<hr class="hrtwo">
		<li class="">提交成功</li>
	</ul>
<form action="" id="registerTowForm" method="post">
	<div class="content_wrap">
		<div class="section clear">
			<div class="information clear">
				<span class="name">参赛类别</span>
				<label for="ten">
					<span class="button">流行舞</span>
					<input type="radio"  name="matchType" id="ten" class="box big_w">
				</label>
				<div class="dance clear">
					<span class="dance_type"  data-type="街舞" name="danceType"><img src="${path }/STATIC/image/cnwd/images/dance.png">街舞</span>
					<span class="dance_type"  data-type="爵士舞" name="danceType">爵士舞</span>
					<span class="dance_type"  data-type="踢踏舞" name="danceType">踢踏舞</span>
				</div>
				<br>
				<label for="six" class="mar_left">
					<span class="button">其他舞种（除广场舞、流行舞以外的其他舞种）</span>
					<input type="radio" name="matchType" value="其他舞种" id="six" class="box biger">
				</label>
			</div>
			<input type="hidden" id="entryId" name="entryId" value="${cnwdEntryForm.entryId}">
			<%-- <input type="hidden" id="checkStatus" name="checkStatus" value="${cnwdEntryForm.checkStatus}"> --%>
		 	<%--  <div class="information clear" id="videoUrl1Webupload">
				<span class="name">上传节目视频</span>
				<div class="info fl">
					<p>流行舞及其他舞种，参赛节目要求不超过7分钟，团队人数不低于3人；</p>
					<p>支持mp4,rm,mpg,avi格式；画面要求稳定不抖动，音质清晰、尽量避免使用重复率高的曲目；</p>
					<p>每位市民只能参加一个团队的表演，否则将取消团队比赛与获奖资格。</p>
					<div class="vedio" id="ossfile2" style="width:260px;">
					   <div name="aliFile" style="position: relative;margin: 0px;width:260px;">
					   <c:if test="${cnwdEntryForm.videoUrl!=null}">
							<video src="${cnwdEntryForm.videoUrl}" style='width:260px;' controls/>
						   <input type="hidden" name="videoUrl" value="${cnwdEntryForm.videoUrl}" >  
							<img class="aliRemoveBtn" src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201733161236Bn6gTqiCZBHhgObFvsCkLFNzmIBoh2.png" style="position:absolute;right:0;top:0;width:20px" onclick="removeImg($(this));"/>
					 </c:if>
					  </div> 
					</div>
					<a id="selectfiles2" class="sel_vedio btn_bgone fl">选择视频</a>
					<p class="col fl">*不得上传未经授权的他人作品，以及色情、反动等违规视频。</p>
				</div>
			</div>  --%>  
			<div class="information clear" id="videoUrl1Webupload">
				<div style="width: 145px;text-align: right;font-size: 16px;color: #333;float:left;line-height: 40px;">上传节目视频</div>
				<div style="margin-left: 15px;width: 680px;float:left;" class="info fl">
				    <p>流行舞及其他舞种，参赛节目要求不超过7分钟，团队人数不低于3人；</p>
					<p>支持mp4,rm,mpg,avi格式；画面要求稳定不抖动，音质清晰、尽量避免使用重复率高的曲目；</p>
					<p>每位市民只能参加一个团队的表演，否则将取消团队比赛与获奖资格。</p>
					<div id="ossfile2" style="width:300px;">
						<div class="vedio"  name="aliFile">
						 <c:if test="${cnwdEntryForm.videoUrl!=null}">
								 <video src="${cnwdEntryForm.videoUrl}" style='width:300px;' controls/> 
							   <input type="hidden" name="videoUrl" value="${cnwdEntryForm.videoUrl}" >  
								<img class="aliRemoveBtn" src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201733161236Bn6gTqiCZBHhgObFvsCkLFNzmIBoh2.png" style="position:absolute;right:0;top:0;width:20px" onclick="removeImg($(this));"/>
						 </c:if>
						</div>
						<!--<pre id="console"></pre>-->
						<br/>
					</div>
					<div id="container2" style="overflow: hidden;">
						<a id="selectfiles2" href="javascript:void(0);" class='sel_vedio btn_bgone fl' style="width:140px;height:35px;background-size:140px 35px;font-size:16px;text-align:center;line-height:35px;color:#fff;">选择视频</a>
					</div>
				</div>
			</div>
			<div class="information clear">
				<span class="name">视频封面</span>
				<div class="info fl" id="assnImgUrlWebupload">
					<p>尺寸为：750*450，节目预览图片上传，格式为：jpg、png、bmp。</p>
					
					<div class="upload_img fl" id="ossfile2">
					   <div name="aliFile" style="position: relative;width:120px;height:130px;">
					        <c:if test="${cnwdEntryForm.videoCoverImg!=null}">
								<img class="aliFileImg" src="${cnwdEntryForm.videoCoverImg}" style="max-height: 130px;max-width: 120px;position: absolute;left: 0;right: 0;top: 0;bottom: 0;margin: auto;">
								  <input type="hidden" name="videoCoverImg" value="${cnwdEntryForm.videoCoverImg}" >  
								<img class="aliRemoveBtn" src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201733161236Bn6gTqiCZBHhgObFvsCkLFNzmIBoh2.png" style="position:absolute;right:0;top:0;width:20px;height:20px;" onclick="removeImg($(this));"/>
						</c:if>
					   </div> 
					</div>
					
					<div id="selectfiles2" class="upload fl" style="float: left;overflow: hidden;margin: 33px 10px 10px 0;">
						<a style="width:100%;height:100%;margin:0;background-color:rgba(0,0,0,0);text-align:center;padding:50px 0 0 0;" id="selectfiles2" class="selectFiles btn">封面上传</a>
					</div>
					
					<p class="col mar fl">*不得上传未经授权的他人作品，以及色情、反动等违规图片。</p>
				</div>
			</div>
			
			<div class="information clear">
				<span class="name">节目名称</span>
				<input type="text" id="programName" value="${cnwdEntryForm.programName}" data-type="notnull" data-msg="节目名称必填" name="programName" class="text_one">
			</div>
			<div class="information clear">
				<span class="name">节目时长</span>
				<input type="text" id="programDuration" value="${cnwdEntryForm.programDuration}" data-type="notnull" data-msg="节目时长必填" name="programDuration" class="text_one">
			</div>
			<div class="information clear">
				<span class="name">编导及身份</span>
				<input type="text" id="producerAndId" value="${cnwdEntryForm.producerAndId}" data-type="notnull" data-msg="编导及身份必填" name="producerAndId" class="text_one">
			</div>
			<div class="information clear">
				<span class="name">参演人数</span>
				<input type="text" id="participatingNumber" value="${cnwdEntryForm.participatingNumber}" data-type="notnull" data-msg="参演人数必填" name="participatingNumber" class="text_one"  onkeyup="this.value=this.value.replace(/[^\d]/g,'')">
			</div>
			<div class="btn_wrap clear">
				<a href="${path }/cnwdEntry/registerOne.do?entryId=${entryId}&editStatus=1" class="btn btn_bgtwo fl">上一步</a>
				<a href="#" onclick="registerThree();" class="btn btn_bgone fl">下一步</a>
			</div>
			
		</div>
	</div>
</form>
<%@include file="/WEB-INF/why/index/cnwd/footer.jsp"%>
</body>
</html>
<script type="text/javascript">
	/*参赛类别*/
	$(".dance .dance_type").click(function(){
		$("#ten").val($(this).attr("data-type"));
		$(this).append("<img src='${path }/STATIC/image/cnwd/images/dance.png'>").siblings().find("img").remove();
	});
     var entryId=$("#entryId").val();
	 $(function () {
		 aliUploadFiles('videoUrl1Webupload', getAssnResVideoUrls, 1, true, 'cnwd');
		 aliUploadImg('assnImgUrlWebupload', getAssnImgUrl, 1, true, 'H5');
	});

	//视频地址回调
    function getAssnResVideoUrls(up, file, info) {
    	var filePath = "http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info;
    	$("#"+file.id).append("<input type='hidden' name='videoUrl' value='"+filePath+"'/>");
    	$("#"+file.id).prepend("<video src='"+filePath+"' style='width:260px;' controls/>");
	} 
	
    //封面图回调
    function getAssnImgUrl(up, file, info) {
    	var filePath = "http://culturecloud.img-cn-hangzhou.aliyuncs.com/" + info;
    	$("#"+file.id).append("<input type='hidden' name='videoCoverImg' value='"+filePath+"'/>");
	}
	
    var matchType = '${cnwdEntryForm.matchType}';
	 $(function(){
		if(matchType){
			$("input:radio[name='matchType']").each(function() {
				if(matchType!='其他舞种'){
					$("#ten").siblings("span.button").addClass("cur").parent().siblings().children("span.button").removeClass("cur");
					$("#ten").attr("checked","checked");
					$(".dance").attr("style","display:inline-block");
					$(".dance span").each(function(i,dom){
						if(matchType==$(this).html()){
							
							$(this).append("<img src='${path }/STATIC/image/cnwd/images/dance.png'>").siblings().find("img").remove();
						}
					})
				}else{
					$("#six").attr("checked","checked");
					$("#six").siblings("span.button").addClass("cur").parent().siblings().children("span.button").removeClass("cur");
					$(".dance").attr("style","display:none");
				}
			})
		}
	}) 
    /*按钮样式的改变*/
	$(".box").change(function(){
		$(this).is(':checked');
		if($(this).is(':checked') == true){
			 $(this).siblings("span.button").addClass("cur").parent().siblings().children("span.button").removeClass("cur");
			 $(this).attr("checked","checked").parent().siblings().find(".box").removeAttr('checked');
			 
		}else{
			$(this).siblings("span.button").removeClass("cur");
			$(this).removeAttr('checked')
		}
		if ($(this).attr('id')=="ten" && $(this).is(':checked') == true) {
			$(".dance").attr("style","display:inline-block");
		}else{
			$(".dance").hide();
		}
		console.log($(this).is(':checked'));
		console.log($(this).attr('id'));
	});
	
	
	 //校验
    function validate(){
	    var isOk=true;
	
		$(".content_wrap").find('input').each(function (index,item) {
			if($(item).attr("data-type")=='notnull'){
				var value=$(item).val();
				if(value== undefined ||value=='' || value.length==0){
					$.DialogBySHF.Alert({ Width: 590, Height: 332, Content: $(item).attr("data-msg") });
	 				var obj=$(item).next();
					isOk=false;
					return false;
				}
			}
		});
	
	return isOk;
}
	 
	 function registerThree(){
		 $(".dance").find('span').each(function(index,item){
			 if($(item).children('img').length>0){ 
				 $("#ten").val($(item).attr("data-type"));
			 } 
		});
		 //$("input[name='newsletter']")
          var videoUrl=$("input[name='videoUrl']").val()
		  var videoCoverImg=$("input[name='videoCoverImg']").val();
		 if(videoUrl== undefined ||videoUrl=='' || videoUrl.length==0){
			 $.DialogBySHF.Alert({ Width: 590, Height: 332, Content: "请上传视频" });
			 return;
		 }
		 if(videoCoverImg== undefined ||videoCoverImg=='' || videoCoverImg.length==0){
			 $.DialogBySHF.Alert({ Width: 590, Height: 332, Content: "请上传视频封面" });
			 return;
		 }   
		 if(!validate()){
			 return;
		 }
		 $.post("${path}/cnwdEntry/registerTwoSave.do",$("#registerTowForm").serialize(),function(data){
			 if(data.msg=="ok"){
				 //alert("保存成功！");
				 window.location.href="${path}/cnwdEntry/registerThree.do?entryId="+entryId;
			 }
		 })
	 }
	//删除图片
 	function removeImg($this){
 		$this.parent("div[name=aliFile]").remove();
 	}
	
 	
	
</script>