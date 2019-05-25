<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>活动列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>

<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<script type="text/javascript">
    $(function(){
    	
    	$.post("../specialProject/searchProjectList.do",function(data) {
    		
    		var projectId = $("#projectId").val();

            if (data != '' && data != null) {
                var list = eval(data);
                var ulHtml = '<li data-option="">请选择</li>';
                for (var i = 0; i <list.length; i++) {
                    var project = list[i];
                    ulHtml += '<li data-option="'+project.projectId+'">'+ project.projectName+ '</li>';
                    
                    if(projectId != '' && projectId == project.projectId){
                        $('#projectIdDiv').html(project.projectName);
                    }
                }
                $('#projectIdUl').html(ulHtml);
                
                if(projectId)
                {
                	searchProjectList();
                }
                	
            }
        }).success(function() {
            selectModel(searchProjectList);
        });
    	
    });
    seajs.config({
        alias: {
            "jquery": "jquery-1.10.2.js"
        }
    });

    seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
        window.dialog = dialog;
    });

    window.console = window.console || {log:function () {}}
    seajs.use(['jquery'], function ($) {
        $(function () {
            var dialog = parent.dialog.get(window);
            /*点击确定按钮*/
            $(".btn-save").click(function(){
                var customerName = $("#customerName").val();
                if(customerName==undefined||$.trim(customerName)==""){
                    $("#customerNameSpan").html("渠道客户名称不能为空");
                    $('#customerName').focus();
                    return;
                }else{
                    $("#customerNameSpan").html("");
                }

                var projectId=$("#projectId").val();
                
                if(projectId==undefined||$.trim(projectId)==""){
                    $("#projectIdSpan").html("活动主题必选");
                    $('#projectId').focus();
                    return;
                }else{
                    $("#projectIdSpan").html("");
                }
                
 				var pageId=$("#pageId").val();
                
                if(pageId==undefined||$.trim(pageId)==""){
                    $("#pageIdSpan").html("专属页必选");
                    $('#pageId').focus();
                    return;
                }else{
                    $("#pageIdSpan").html("");
                }
                
 				var enterId=$("#enterId").val();
                
                if(enterId==undefined||$.trim(enterId)==""){
                    $("#enterIdSpan").html("渠道入口必选");
                    $('#enterId').focus();
                    return;
                }else{
                    $("#enterIdSpan").html("");
                }
                
                var ycodeStartTimeHidden=$("#ycodeStartTimeHidden").val();
                
                if(!ycodeStartTimeHidden){
                	
                	$("#timeIdSpan").html("开始日期必选");
                	$('#ycodeStartTime').focus();
                	 return;
	            }else{
	                $("#timeIdSpan").html("");
	            }
                
				var ycodeEndTimeHidden=$("#ycodeEndTimeHidden").val();
                
                if(!ycodeEndTimeHidden){
                	
                	$("#timeIdSpan").html("结束日期必选");
                	$('#ycodeEndTime').focus();
                	 return;
	            }else{
	                $("#timeIdSpan").html("");
	            }
                
                $.post("${path}/specialCustomer/saveCustomer.do", $("#form").serialize(), function(result) {
                	
                    if (result == "success") {
                        dialogTypeSaveDraft("提示", "保存成功", function(){
                            parent.location.href="${path}/specialCustomer/index.do";
                            dialog.close().remove();
                        });
                    }else if (result == "login") {
                    	
                    	 dialogAlert('提示', '请先登录！', function () {
                 			window.location.href = "${path}/login.do";
	                    	 });
                    }else{
                        dialogTypeSaveDraft("提示", "保存失败");
                    }
                });
            });
            /*点击取消按钮，关闭登录框*/
            $(".btn-cancel").click(function(){
                dialog.close().remove();
            });
            
            $(function(){
            	
            	var customerId=$("#customerId").val();
            	
            	if(!customerId)
                $(".start-btn").click(function(){
                    WdatePicker({el:'ycodeStartTimeHidden',dateFmt:'yyyy-MM-dd HH:mm',doubleCalendar:true,minDate:'%y-%M-{%d}',maxDate:'#F{$dp.$D(\'ycodeEndTimeHidden\')}',position:{left:-224,top:8},isShowClear:false,isShowOK:true,isShowToday:false,onpicked:pickedStartFunc})
                })
                $(".end-btn").click(function(){
                    WdatePicker({el:'ycodeEndTimeHidden',dateFmt:'yyyy-MM-dd HH:mm',doubleCalendar:true,minDate:'#F{$dp.$D(\'ycodeStartTimeHidden\')}',position:{left:-224,top:8},isShowClear:false,isShowOK:true,isShowToday:false,onpicked:pickedendFunc})
                })
            });
           
        });
    });
    
    function pickedStartFunc(){
        $dp.$('ycodeStartTime').value=$dp.cal.getDateStr('yyyy-MM-dd HH:mm');
        $dp.$('startWeek').innerHTML=$dp.cal.getDateStr('DD');
    }
    function pickedendFunc(){
        $dp.$('ycodeEndTime').value=$dp.cal.getDateStr('yyyy-MM-dd HH:mm');
        $dp.$('endWeek').innerHTML=$dp.cal.getDateStr('DD');
    }
    
    function searchProjectList(){
    	
    	var projectId=$("#projectId").val();
    	
    	if(projectId){
    		$.post("../specialPage/searchPageList.do",{projectId:projectId},function(data) {
    			
    			 var pageId=$("#pageId").val();
        		
                if (data != '' && data != null) {
                    var list = eval(data);
                    var ulHtml = '<li data-option="">请选择</li>';
                    for (var i = 0; i <list.length; i++) {
                        var page = list[i];
                        ulHtml += '<li data-option="'+page.pageId+'">'+ page.pageName+ '</li>';
                        
                        if(pageId != '' && pageId == page.pageId){
                            $('#pageIdDiv').html(page.pageName);
                        }
                    }
                    $('#pageIdUl').html(ulHtml);
                }
            }).success(function() {
               
            });
    		
    		$.post("../specialEnter/searchEnterList.do",{projectId:projectId},function(data) {
    			
    			 var enterId=$("#enterId").val();
        		
                if (data != '' && data != null) {
                    var list = eval(data);
                    var ulHtml = '<li data-option="">请选择</li>';
                    for (var i = 0; i <list.length; i++) {
                        var enter = list[i];
                        ulHtml += '<li data-option="'+enter.enterId+'">'+ enter.enterName+ '</li>';
                        
                        if(enterId != '' && enterId == enter.enterId){
                            $('#enterIdDiv').html(enter.enterName);
                        }
                    }
                    $('#enterIdUl').html(ulHtml);
                }
            }).success(function() {
                
            });
    		
    	}
    	else
    	{
    		 $('#pageIdUl').html("");
    		 $("#pageIdDiv").html("请选择");
    		 $('#enterIdUl').html("");
    		 $("#enterIdDiv").html("请选择");
    		 
    	}
    	
	
		
		
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
</script>
</head>

<body style="background: none;">
<form id="form">
    <div class="main-publish tag-add" style="overflow:visible;">
   <input type="hidden" name="customerId" id="customerId" value="${entity.customerId }"/>
            <table width="100%" class="form-table">
                <tr>
                    <td class="td-title" width="20%"><span class="red">*</span>渠道客户名称：</td>
                    <td class="td-input"><input type="text" class="input-text w210" id="customerName" name="customerName" value="${entity.customerName }"/>
                    <span class="error-msg" id="customerNameSpan"></span>
                    </td>
                </tr>
                <tr>
                    <td class="td-title" width="20%"><span class="red">*</span>选择活动主题：</td>
                    <td class="td-input search" id="projectIdLabel">

                    <div class="select-box w230" style="margin-left: 0px;">
                        <input type="hidden" value="${entity.projectId }" name="projectId" id="projectId"/>
                        <div class="select-text" data-value="" id="projectIdDiv">请选择</div>
                        <ul class="select-option" style="display: none;max-height:100px"  id="projectIdUl">
                        </ul>
                    </div>
                      <span class="error-msg" id="projectIdSpan"></span>
              	  </td>
                </tr>
                 <tr>
                    <td class="td-title" width="20%"><span class="red">*</span>选择专属页：</td>
                    <td class="td-input search" id="pageIdLabel">

                    <div class="select-box w230" style="margin-left: 0px;">
                        <input type="hidden" value="${entity.pageId }" name="pageId" id="pageId"/>
                        <div class="select-text" data-value="" id="pageIdDiv">请选择</div>
                        <ul class="select-option" style="display: none;max-height:100px"  id="pageIdUl">
                        </ul>
                    </div>
                      <span class="error-msg" id="pageIdSpan"></span>
              	  </td>
                </tr>
               <tr>
                    <td class="td-title" width="20%"><span class="red">*</span>选择渠道入口：</td>
                    <td class="td-input search" id="enterIdLabel">

                    <div class="select-box w230" style="margin-left: 0px;">
                        <input type="hidden" value="${entity.enterId }" name="enterId" id="enterId"/>
                        <div class="select-text" data-value="" id="enterIdDiv">请选择</div>
                        <ul class="select-option" style="display: none;max-height:100px"  id="enterIdUl">
                        </ul>
                    </div>
                      <span class="error-msg" id="enterIdSpan"></span>
              	  </td>
                </tr>
              <tr>
                    <td class="td-title" width="20%">客户类型：</td>
                    <td class="td-input" >
                       <input class="input-text" type="text" value="${entity.customerType }" name="customerType" id=""customerType""/>
                  
              	  </td>
                </tr>
                  <tr>
	                <td width="100" class="td-title"><span class="red">*</span>Y码兑换日期：</td>
	                <td class="td-time" id="ycodeStartTimeLabel">
	                    <div class="start w400" style="width:260px;">
	                        <span class="text">开始日期</span>
	                        <input type="hidden" id="ycodeStartTimeHidden"  value="<fmt:formatDate value="${entity.ycodeStartTime }"  pattern="yyyy-MM-dd HH:mm" type="both"/>" />
	                        
	                        <c:choose>
	                        	<c:when test="${empty entity.customerId }">
	                        	   <input style="width:120px;background-color:#fff" type="text" id="ycodeStartTime"
	                         name="ycodeStartTime"  value="<fmt:formatDate value="${entity.ycodeStartTime }"  pattern="yyyy-MM-dd HH:mm" type="both"/>" readonly/>
	                        	</c:when>
	                        	<c:otherwise>
	                        	  <input type="text" id="ycodeStartTime"
	                         name="ycodeStartTime" disabled="disabled" value="<fmt:formatDate value="${entity.ycodeStartTime }"  pattern="yyyy-MM-dd HH:mm" type="both"/>" readonly/>
	                        	</c:otherwise>
	                        </c:choose>
	                        
	                     
	                        <span class="week" id="startWeek"></span>
	                        <i class="data-btn start-btn"></i>
	                    </div>
	                    <span class="txt">至</span>
	                    <div class="end w400"  style="width:260px;">
	                        <span class="text">结束日期</span>
	                        <input type="hidden" id="ycodeEndTimeHidden" value="<fmt:formatDate value="${entity.ycodeEndTime }"  pattern="yyyy-MM-dd HH:mm" type="both"/>"/>
	                        <input  style="width:120px;background-color:#fff" type="text" id="ycodeEndTime" name="ycodeEndTime" value="<fmt:formatDate value="${entity.ycodeEndTime }"  pattern="yyyy-MM-dd HH:mm" type="both"/>" readonly/>
	                        <span class="week" id="endWeek"></span>
	                        <i class="data-btn end-btn"></i>
	                    </div>
	                      <span class="error-msg" id="timeIdSpan"></span>
	                   </td>
	            </tr>
	            <tr >
                    <td class="td-title"></td>
                    <td class="td-btn">
                        <input class="btn-save" type="button"  value="保存"/>
                        <input class="btn-cancel" type="button" value="关闭"/>
                    </td>
                </tr>
            </table>
    </div>
</form>


</body>
</html>