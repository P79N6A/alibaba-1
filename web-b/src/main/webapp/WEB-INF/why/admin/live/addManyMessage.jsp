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

                $.post("${path}/live/saveManyMessage.do", $("#form").serialize(), function(result) {
                	
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
	                <td class="td-title" width="20%">增加评论数：</td>
	                <td class="td-input"><input type="number" name="commontNum" class="input-text w100" min="0"></input></td>
	            </tr>
	              <tr>
	                <td class="td-title" width="20%">增加点赞数：</td>
	                <td class="td-input"><input type="number" name="likeNum" class="input-text w100" min="0"></input></td>
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