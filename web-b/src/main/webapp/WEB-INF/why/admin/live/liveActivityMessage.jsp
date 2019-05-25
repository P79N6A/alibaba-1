<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>添加修改专属也--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/aliImageFrame.jsp"%>

<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>

<script type="text/javascript">
	$.ajaxSettings.async = false; 	//同步执行ajax

    seajs.config({
        alias: {
            "jquery": "jquery-1.10.2.js"
        }
    });

    seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
        window.dialog = dialog;
    });

    window.console = window.console || {log:function () {}}
    
    $(function(){
    	 $(".start-btn").on("click", function () {
             WdatePicker({
                 el: 'startDateHidden',
                 dateFmt: 'yyyy-MM-dd',
                 doubleCalendar: true,
                 minDate: '',
                 maxDate: '',
                 position: {left: -224, top: 8},
                 isShowClear: false,
                 isShowOK: true,
                 isShowToday: false,
                 onpicked: pickedStartFunc
             })
         });
    	 
    	 $(".recommend-btn").on("click", function () {
             WdatePicker({
                 el: 'messageRecommendTimeHidden',
                 dateFmt: 'yyyy-MM-dd',
                 doubleCalendar: true,
                 minDate: '',
                 maxDate: '',
                 position: {left: -224, top: 8},
                 isShowClear: false,
                 isShowOK: true,
                 isShowToday: false,
                 onpicked: pickedRecommendFunc
             })
         });
    	 
    	 $("input[name=messageIsRecommend]").change(function() {
    			var v=$(this).val();
    			
    			if(v=="1"){
    				$("#IsRecommend").show();
    			}
    			else
    				$("#IsRecommend").hide();
     	});
    });
    
    function pickedStartFunc() {
        $dp.$('messageCreateTime').value = $dp.cal.getDateStr('yyyy-MM-dd');
    }
    function pickedRecommendFunc() {
        $dp.$('messageRecommendTime').value = $dp.cal.getDateStr('yyyy-MM-dd');
    }
    
    window.onload = function() { 
		aliUploadImg("whyUploadImgDiv",uploadImgCallBack, 3)
	}
    
    function uploadImgCallBack(up, file, info){
    	var aliImgUrl = "${aliImgUrl}" + info 
    	
    	//$("#"+file.id).find("input[name='"+messageImg+"']").val(aliImgUrl)
    	
    	$("#"+file.id).append('<input type="hidden" name="messageImg" value="'+aliImgUrl+'"/>')
    	
    	
	}
    
    function addZero(value){
    	  var time = "";
    	  if(!value){
    		  return "00";
    	  }
    	  else if (value.toString().length < 2) {
    	        time = "0" + value.toString()
    	    } else {
    	        time = value.toString()
    	    }
    	    return time;
    }
  
	
    
        $(function () {
        	
        	/*点击确定按钮*/
            $(".btn-save").on("click", function(){
                var messageContent = $("#messageContent").val();
                
                if(messageContent==undefined||$.trim(messageContent)==""){
                    $("#messageContentSpan").html("文字内容为必填");
                    $('#messageContent').focus();
                    return;
                }else{
                	$("#messageContentSpan").html("");
                }
              
                
                var startDateHidden=$("#startDateHidden").val();
                
                if(!startDateHidden){
	                $("#messageCreateTimeSpan").html("创建时间为必填");
	                return;
	            }else{
	            	$("#messageCreateTimeSpan").html("");
	            }             
                
                $("#messageCreateTime").val(startDateHidden+" "+addZero($("#messageCreateTime1").val())+":"+addZero($("#messageCreateTime2").val())+":"+addZero($("#messageCreateTime3").val()))
                
                var messageIsRecommendYes =$("#messageIsRecommendYes").prop("checked");
                
                if(messageIsRecommendYes){
                	
                	 var messageRecommendTimeHidden=$("#messageRecommendTimeHidden").val();
                	
                	 if(!messageRecommendTimeHidden){
     	                $("#messageRecommendTimeSpan").html("推荐时间为必填");
     	                return;
     	            }else{
     	            	$("#messageRecommendTimeSpan").html("");
     	            }         
                	 
                	$("#messageRecommendTime").val(messageRecommendTimeHidden+" "+addZero($("#messageRecommendTime1").val())+":"+addZero($("#messageRecommendTime2").val())+":"+addZero($("#messageRecommendTime3").val()))
                       
                }
                

                $.post("${path}/live/saveLiveActivityMessage.do", $("#form").serialize(), function(result) {
                	
                    if (result == "success") {
                    	dialogTypeSaveDraft("提示", "保存成功", function(){
                            parent.location.href="${path}/live/liveActivityListIndex.do";
                        });
                    }else if (result == "login") {
                    	
                   	 dialogAlert('提示', '请先登录！', function () {
                   		parent.location.href = "${path}/login.do";
	                    	 });
                   }else{
                    	dialogTypeSaveDraft("提示", "保存失败");
                    }
                });
            }); 
        	
        });
    

    function dialogTypeSaveDraft(title, content, fn){
        var d = window.dialog({
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

<style>
 div[name = aliFile] img:nth-child(1){
 	position:static!important;
 }
</style>

<body style="background: none;">
 <div class="site">
		    <em>您现在所在的位置：</em>直播管理 &gt;直播活动管理 &gt;添加评论
		</div>
	<form id="form">
		<input id="messageActivity" name="messageActivity" type="hidden" value="${liveActivity.liveActivityId }"/>
	   	<input id="messageIsInteraction" name="messageIsInteraction" type="hidden" value="1"/>
	    <div class="main-publish tag-add">
	        <table width="100%" class="form-table">
	      	  <tr>
	                <td class="td-title" width="20%">直播活动：</td>
	                <td class="td-input">${liveActivity.liveTitle }</td>
	            </tr>
	          <tr>
	                <td class="td-title" width="20%"><span class="red">*</span>文字内容：</td>
	                <td class="td-input"><textarea id="messageContent" name="messageContent" rows="4" class="textareaBox" style="width: 380px;resize: none" >${entity.messageContent }</textarea></div>  <span class="error-msg" id="messageContentSpan"></span></td>
	            </tr>
	            <tr>
                    <td class="td-title" width="20%">选择图片：</td>
                    <td class="td-input search" id="projectIdLabel" height="500">
	                 	<div class="whyUploadVedio">
								<!-- <div style="float: left;width: 145px;text-align: right;font-size: 16px;color: #333;">作品封面 </div>
								<div style="float: right;width: 700px;font-size: 14px;color: #999;line-height: 25px;">尺寸为：320*200，节目预览图片上传，格式为：jpg,png,bmp</div> -->
								<div style="clear: both;"></div>
								<div id="whyUploadImgDiv" style="margin-left: 20px;margin-top: 25px;width: 500px;">
									<div  class="whyUploadImgDiv">
									
									<c:choose>
										<c:when test="${!empty entity.messageImg }">
											<c:forEach items="${fn:split(entity.messageImg, ',')}" var="img">
									
										<div name="aliFile" style="position:relative" ><span></span><b></b>
											<img onclick="aliRemoveImg(this)" class="aliRemoveBtn" src="../STATIC/image/removeBtn.png" style="position:absolute;left:80px;top:0;width:20px" />
											<img src="${img}" style="max-height: 100px;max-width: 100px;" />
											<input type="hidden" name="messageImg" value="${img }"/>
											<br />
										</div>
									</c:forEach>
										</c:when>
										<c:otherwise>
										
										</c:otherwise>
									</c:choose>
									<div id="ossfile2">你的浏览器不支持flash,Silverlight或者HTML5！</div>
									</div>
									
									<!--<pre id="console"></pre>-->
									<br/>
									<div id="container2">
										<a id="selectfiles2" href="javascript:void(0);" class='btn'>1.选择文件</a>
										<a id="postfiles2" href="javascript:void(0);" class='btn'>2.点击开始上传</a>
									</div>
								</div>
								<span class="error-msg" id="videoImgUrlSpan"></span>
							</div>
              	    </td>
                </tr>
                <tr>
                	 <td class="td-title" width="20%"><span class="red">*</span>创建时间:</td>
                	     <td class="td-input">
                	  <div class="td-time" style="margin-top: 0px;">
                <div class="start w240" style="margin-left: 8px;">
                    <span class="text"></span>
                    <input type="hidden" id="startDateHidden"/>
                    <input type="text" id="messageCreateTime" name="messageCreateTime"
                           value="" readonly/>
                    <i class="data-btn start-btn"></i>
                </div>
                <input id="messageCreateTime1" min="0" max="23" type="number" class="input-text w64" maxlength="2"  />：
                <input id="messageCreateTime2" min="0" max="59" type="number" class="input-text w64" maxlength="2"  />：
           	     <input id="messageCreateTime3" min="0" max="59" type="number" class="input-text w64" maxlength="2"  />
           	<span class="error-msg" id="messageCreateTimeSpan"></span>
            </div>
                	</td>
                </tr>
                <tr>
                	<td class="td-title" width="30%">
                	是否推荐:
                	</td>
                	 <td class="td-input td-fees">
                	 	<label><input checked="checked" type="radio" id="messageIsRecommendNo"  name="messageIsRecommend" value="0"/><em>否</em></label>
                	 	<label><input type="radio" id="messageIsRecommendYes" name="messageIsRecommend" value="1"/><em>是</em></label>
                	 </td>
                </tr>
                 <tr id="IsRecommend" style="display: none;">
	                	 <td class="td-title" width="20%">推荐时间:</td>
	                	     <td class="td-input">
	                	  <div class="td-time" style="margin-top: 0px;">
	                <div class="start w240" style="margin-left: 8px;">
	                    <span class="text"></span>
	                    <input type="hidden" id="messageRecommendTimeHidden"/>
	                    <input type="text" id="messageRecommendTime" name="messageRecommendTime"
	                           value="" readonly/>
	                    <i class="data-btn recommend-btn"></i>
	                </div>
	                <input id="messageRecommendTime1" min="0" max="23" type="number" class="input-text w64" maxlength="2"  />：
	                <input id="messageRecommendTime2" min="0" max="59" type="number" class="input-text w64" maxlength="2"  />：
	                <input id="messageRecommendTime3" min="0" max="59" type="number" class="input-text w64" maxlength="2"  />
	            	<span class="error-msg" id="messageRecommendTimeSpan"></span>
	            </div>
                	</td>
                </tr>
	            <tr>
	                <td class="td-title"></td>
	                <td class="td-btn" style="padding: 36px 0;">
	                    <input class="btn-save" type="button"  value="保存"/>
	                </td>
	            </tr>
	        </table>
	    </div>
	</form>
</body>
</html>