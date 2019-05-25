<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setLocale value="zh_CN"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/html">
<head>
    <title>查看用户</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <link rel="stylesheet" type="text/css" href="${path }/STATIC/css/cnwd/reset.css">
	<link rel="stylesheet" type="text/css" href="${path }/STATIC/css/cnwd/dance.css">
	<link rel="Stylesheet" type="text/css" href="${path }/STATIC/css/cnwd/DialogBySHF.css" />
	<script type="text/javascript" src="${path }/STATIC/js/cnwd/DialogBySHF.js"></script>
</head>
<body>
<div class="site">
    <em>您现在所在的位置：</em>舞蹈大赛 &gt;长宁舞蹈大赛列表 &gt; 查看
</div>
<div class="site-title">查看</div>
<!-- 正中间panel -->
<form action=" " id="registerForm" method="post">
	<div class="content_wrap">
		<div class="section clear">
			<div class="information clear">
				<span class="name">机构/单位名称</span>
				<input type="text" id="agencyName" data-type="notnull" value="${cnwdEntryform.agencyName }" data-msg="机构/单位名称必填" name="agencyName" class="text_one" readonly="readonly">
			</div>
			<input type="hidden" id="entryId" name="entryId" value="${cnwdEntryform.entryId }">
			<div class="information clear">
				<span class="name">机构类型</span>
				<label for="one">
					<span class="button">企业</span>
					<input type="radio"   id="one"  name="agencyType" value="企业" class="box" disabled="disabled" >
				</label>
				<label for="two">
					<span class="button">事业单位</span>
					<input type="radio" name="agencyType" id="two" value="事业单位" class=" box big_w" disabled="disabled">
				</label>
				<label for="three">
					<span class="button">民非组织</span>
					<input type="radio" name="agencyType" id="three" value="民非组织" class=" box big_w" disabled="disabled">
				</label>
				<label for="four">
					<span class="button">院校</span>
					<input type="radio"  name="agencyType" id="four"  value="院校" class="box" disabled="disabled">
				</label>
				<label for="five">
					<span class="button">社团</span>
					<input type="radio" name="agencyType"  id="five"  value="社团" class="box" disabled="disabled">
				</label>
				<br>
			   <label for="six" class="mar_left">
					<span class="button">其他</span>
					<input type="radio" name="agencyType" id="six"  class="box" disabled="disabled">
				</label>
				<input type="text" id="qita" placeholder="请填写具体类型" class="detail_type mar_top" readonly="readonly">
			</div>
			<div class="information clear">
				<span class="name">团队名称</span>
				<input type="text" id="teamName" data-type="notnull" value="${cnwdEntryform.teamName }" data-msg="团队名称必填" name="teamName" class="text_one" readonly="readonly"></input>
			</div>
			<div class="information clear">
				<span class="name">成立时间</span>
				<input type="text" id="dateOfEstablishment" value="${cnwdEntryform.dateOfEstablishment }"  data-type="notnull" data-msg="成立时间必填" name="dateOfEstablishment" class="text_one" readonly="readonly"></input>
			</div>
			<div class="information clear">
				<span class="name">成员人数</span>
				<input type="text" id="memberNumber" value="${cnwdEntryform.memberNumber }" data-type="notnull" data-msg="成员人数必填" name="memberNumber" class="text_two"  onkeyup="this.value=this.value.replace(/[^\d]/g,'')" readonly="readonly"></input>
				<span class="name" style="margin-left: 115px;">平均年龄</span>
				<input type="text" id="avgAge" value="${cnwdEntryform.avgAge }" name="avgAge" data-type="notnull" data-msg="平均年龄必填" class="text_two"  onkeyup="this.value=this.value.replace(/[^\d]/g,'')" readonly="readonly"></input>
			</div>
			<div class="information clear">
				<span class="name">领队姓名</span>
				<input type="text" id="leaderName" value="${cnwdEntryform.leaderName }"  data-type="notnull" data-msg="领队姓名必填" name="leaderName" class="text_two" readonly="readonly"></input>
				<span class="name" style="width:128px;margin-left: 95px;">联系方式（手机）</span>
				<input type="text" id="telephone" value="${cnwdEntryform.telephone }" data-type="notnull" maxlength="11" data-msg="联系方式必填" name="telephone" class="text_two" readonly="readonly"></input>
			</div>
			<div class="information clear">
				<span class="name">电子邮箱</span>
				<input type="text" id="email" value="${cnwdEntryform.email }" data-type="notnull" data-msg="电子邮箱必填" name="email" class="text_two" readonly="readonly"></input>
				<span class="name" style="margin-left: 115px;">传真电话</span>
				<input type="text" id="faxaphone" value="${cnwdEntryform.faxaphone }" data-type="notnull" data-msg="传真电话必填" name="faxaphone" class="text_two" readonly="readonly"></input>
			</div>
			<div class="information clear">
				<span class="name">联系地址</span>
				<input type="text" id="address"  value="${cnwdEntryform.address }" data-type="notnull" data-msg="联系地址必填" name="address" class="text_one" readonly="readonly"></input>
			</div>
			<div class="information clear">
				<span class="name">团队简介</span>
				<textarea id="teamProfile" name="teamProfile" class="team_info" placeholder="特色、经历、获得荣誉、感人故事等" disabled="disabled">${cnwdEntryform.teamProfile }</textarea>
			</div>
			<div class="information clear">
				<span class="name">参赛类别</span>
				<label for="ten">
					<span class="button">流行舞</span>
					<input type="radio"  name="matchType" id="ten" class="box big_w" disabled="disabled">
				</label>
				<div class="dance clear">
					<span class="dance_type"  data-type="街舞" name="danceType"><img src="${path }/STATIC/image/cnwd/images/dance.png">街舞</span>
					<span class="dance_type"  data-type="爵士舞" name="danceType">爵士舞</span>
					<span class="dance_type"  data-type="踢踏舞" name="danceType">踢踏舞</span>
				</div>
				<br>
				<label for="six" class="mar_left">
					<span class="button">其他舞种（除广场舞、流行舞以外的其他舞种）</span>
					<input type="radio" name="matchType" value="其他舞种" id="seven" class="box biger" disabled="disabled">
				</label>
			</div>
			<div class="information clear" id="videoUrl1Webupload">
				<span class="name">上传节目视频</span>
				<div class="info fl">
					<p>流行舞及其他舞种，参赛节目要求不超过7分钟，团队人数不低于3人；</p>
					<p>支持mp4,rm,mpg,avi格式；画面要求稳定不抖动，音质清晰、尽量避免使用重复率高的曲目；</p>
					<p>每位市民只能参加一个团队的表演，否则将取消团队比赛与获奖资格。</p>
					<div class="vedio" id="ossfile2" style="width:260px;">
					   <div name="aliFile" style="position: relative;margin: 0px;width:260px;">
					   <c:if test="${cnwdEntryform.videoUrl!=null}">
							<video src="${cnwdEntryform.videoUrl}" style='width:260px;' controls/>
						   <input type="hidden" name="videoUrl" value="${cnwdEntryform.videoUrl}" >  
							<img class="aliRemoveBtn" src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201733161236Bn6gTqiCZBHhgObFvsCkLFNzmIBoh2.png" style="position:absolute;right:0;top:0;width:20px" onclick="removeImg($(this));"/>
					 </c:if>
					  </div> 
					</div>
					<!-- <a id="selectfiles2" class="sel_vedio btn_bgone fl">选择视频</a> -->
					<!-- <p class="col fl">*不得上传未经授权的他人作品，以及色情、反动等违规视频。</p> -->
				</div>
			</div>
			<div class="information clear">
				<span class="name">视频封面</span>
				<div class="info fl" id="assnImgUrlWebupload">
					<p>尺寸为：750*450，节目预览图片上传，格式为：jpg、png、bmp。</p>
					
					<div class="upload_img fl" id="ossfile2">
					   <div name="aliFile" style="position: relative;width:120px;height:130px;">
					        <c:if test="${cnwdEntryform.videoCoverImg!=null}">
								<img class="aliFileImg bigCheck" src="${cnwdEntryform.videoCoverImg}" style="max-height: 130px;max-width: 120px;position: absolute;left: 0;right: 0;top: 0;bottom: 0;margin: auto;">
								  <input type="hidden" name="videoCoverImg" value="${cnwdEntryform.videoCoverImg}" >  
								<!-- <img class="aliRemoveBtn" src="http://culturecloud.img-cn-hangzhou.aliyuncs.com/H5/201733161236Bn6gTqiCZBHhgObFvsCkLFNzmIBoh2.png" style="position:absolute;right:0;top:0;width:20px;height:20px;" onclick="removeImg($(this));"/> -->
						</c:if>
					   </div> 
					</div>
					
					<!-- <div id="selectfiles2" class="upload fl" style="float: left;overflow: hidden;margin: 33px 10px 10px 0;">
						 <a style="width:100%;height:100%;margin:0;background-color:rgba(0,0,0,0);text-align:center;padding:50px 0 0 0;" id="selectfiles2" class="selectFiles btn">封面上传</a>
					</div> -->
					
					<!-- <p class="col mar fl">*不得上传未经授权的他人作品，以及色情、反动等违规图片。</p> -->
				</div>
			</div>
			<div class="information clear">
				<span class="name">节目名称</span>
				<input type="text" id="programName" value="${cnwdEntryform.programName}" data-type="notnull" data-msg="节目名称必填" name="programName" class="text_one" readonly="readonly">
			</div>
			<div class="information clear">
				<span class="name">节目时长</span>
				<input type="text" id="programDuration" value="${cnwdEntryform.programDuration}" data-type="notnull" data-msg="节目时长必填" name="programDuration" class="text_one" readonly="readonly">
			</div>
			<div class="information clear">
				<span class="name">编导及身份</span>
				<input type="text" id="producerAndId" value="${cnwdEntryform.producerAndId}" data-type="notnull" data-msg="编导及身份必填" name="producerAndId" class="text_one" readonly="readonly">
			</div>
			<div class="information clear">
				<span class="name">参演人数</span>
				<input type="text" id="participatingNumber" value="${cnwdEntryform.participatingNumber}" data-type="notnull" data-msg="参演人数必填" name="participatingNumber" class="text_one"  onkeyup="this.value=this.value.replace(/[^\d]/g,'')" readonly="readonly">
			</div>
			<!-- <div class="room-order-info info2" style="position: relative;">
                            <input class="btn-publish" type="button" onclick="javascript:history.back(-1)" value="返回"/>
            </div> -->
            <a href="#" id="btn" class="btn btn_bgone btn_next" onclick="javascript:history.back(-1)">返回</a>
		</div>
	</div>
</form>
</body>
</html>
<script type="text/javascript">
    var entryId = $("#entryId").val();
     var agencyType ='${cnwdEntryform.agencyType}';
    $(function(){
    	if(agencyType){
    		$("input:radio[name='agencyType']").each(function() {
        		var checkedAgencyType = $(this).val();
        		if(agencyType==checkedAgencyType){
        			$(this).attr("checked","checked");
        			$(this).siblings("span.button").addClass("cur");
        		}
    		});
    		if($(":radio[name=agencyType]:checked").size() == 0){
    			$("#six").attr("checked","checked");
    			$("#six").siblings("span.button").addClass("cur");
    			$("#qita").val(agencyType);
    			$(".detail_type").show();
    		}
    	}
    }) 
        var matchType = '${cnwdEntryform.matchType}';
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
					$("#seven").attr("checked","checked");
					$("#seven").siblings("span.button").addClass("cur").parent().siblings().children("span.button").removeClass("cur");
					$(".dance").attr("style","display:none");
				}
			})
		}
	})
    /*按钮样式的改变*/
/* 	$(".box").change(function(){
		$(this).is(':checked');
		if($(this).is(':checked') == true){
			 $(this).siblings("span.button").addClass("cur").parent().siblings().children("span.button").removeClass("cur");
			 $(this).attr("checked","checked").parent().siblings().find(".box").removeAttr('checked');
			 
		}else{
			$(this).siblings("span.button").removeClass("cur");
			$(this).removeAttr('checked')
		}
		if ($(this).attr('id') == 'six') {
			 $(".detail_type").show().focus();

			}else if ($(this).is(':checked') == true ) {
				$(".detail_type").hide();
				$("#qita").val('');
			}else{
				$(".detail_type").hide();
				$("#qita").val("");
			}
		console.log($(this).is(':checked'));
		console.log($(this).attr('id'));
	}); */
	/*参赛类别*/
	/* $(".dance .dance_type").click(function(){
		$("#ten").val($(this).attr("data-type"));
		$(this).append("<img src='${path }/STATIC/image/cnwd/images/dance.png'>").siblings().find("img").remove();
	});
     var entryId=$("#entryId").val();
	 $(function () {
		 aliUploadFiles('videoUrl1Webupload', getAssnResVideoUrls, 1, true, 'H5');
		 aliUploadImg('assnImgUrlWebupload', getAssnImgUrl, 1, true, 'H5');
	}); */

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
    $(function(){
    	$(".bigCheck").on("click",function(){
    		var img_src = $(this).attr('src');
    		
    		var i=img_src.indexOf("@");
    		
    		if(i>-1){
    			img_src=img_src.substring(0,i);
    		}
    		
    		imgCheck(img_src);
    	})
    })
    function imgCheck(src){
	
	var img=new Image();  
	img.src=src;
	
	var width ;
	var height ;
	
	img.onload = function(){ 
	    //原始宽度
	    width = this.width;
	    //原始高度
	    height = this.height
	    
	  
	    if(window.parent.dialog)
	    	window.parent.dialog({
	    		 padding: 0,
	            title: '图片预览',
	            content: '<img style="max-height:1000px;max-width:1000px;" src="'+src+'" width="'+width+'" height="'+height+'" />',
	            center:true,  
	            fixed: false,
	            onclose: function () {
	            }
	        }).showModal();
	    	else
	    		dialog({
	    			 padding: 0,
	    			  content: '<img style="max-height:1000px;max-width:1000px;" src="'+src+'" width="'+width+'" height="'+height+'" />',
	    	        title: '图片预览',
	    	        center:true,  
	    	        fixed: false,
	    	        onclose: function () {
	    	        }
	    	    }).showModal();
	}
	
	
}
    /*按钮样式的改变*/
/* 	$(".box").change(function(){
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
	}); */
</script>
