<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
<%@include file="/WEB-INF/why/common/limit.jsp"%>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
 <style>
	td{
	 position:relative;
	}
	.refuse_reason{
	position: absolute;
    color: red;
    right: -156px;
    top: 0;
    background: #fff;
    border: 1px solid #ccc;
    padding: 5px;
    width: 148px;
    z-index: 100;
    text-align:left;
    display:none;}
</style> 
<script type="text/javascript">
		seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
		    window.dialog = dialog;
		});
  $(function(){
	  selectModel();
	  //分页
      kkpager.generPageHtml({
          pno : '${page.page}',
          total : '${page.countPage}',
          totalRecords :  '${page.total}',
          mode : 'click',//默认值是link，可选link或者click
          click : function(n){
              this.selectPage(n);
              $("#page").val(n);
              formSub('#form');
              return false;
          }
      });
  })
  function checkCnwdEntryform(a,entryId,status){
  	if(status==2){
  		var name = $(a).parent().siblings(".title").html();
  		  var html = "您确定要审核通过\"" + name + "\"吗？";
            dialogConfirm("提示", html, function(){
                $.post("${path}/cnwdEntryform/check.do",{"entryId":entryId,"status":status}, function(data) {
                    if (data!=null && data=='success') {
                  	dialogAlert("提示","操作成功",function () {
                  		window.location.href = "${path}/cnwdEntryform/cnwdEntryformList.do";
                    });
                    }else if(data!=null && data=='login'){
                  	  dialogAlert('提示', '请先登录！', function () {
                 			window.location.href = "${path}/login.do";
 	                    	 }); 
                    }else{
                     	dialogTypeSaveDraft("提示", "保存失败");
                     }
                });
            })
  	}
  	else if(status==3){
  		 dialog({
               url: '${path}/cnwdEntryform/preRefuse.do?entryId='+entryId+'&status='+status,
               title: '审核不通过',
               width: 400,
               height:300,
               fixed: false,
               data: {"entryId":entryId,"status":status}, // 给 iframe 的数据
               onclose: function () {
              	 formSub('#form');
               }
           }).showModal();
           return false;
  	}
  }
  function sendMessage(a,entryId){
	  $.post("${path}/cnwdEntryform/sendMessage.do",{"entryId":entryId}, function(data) {
		     if (data!=null && data=='success') {
               	dialogAlert("提示","发送成功",function () {
               		window.location.href = "${path}/cnwdEntryform/cnwdEntryformList.do";
                 });
                 }else if(data!=null && data=='login'){
               	  dialogAlert('提示', '请先登录！', function () {
              			window.location.href = "${path}/login.do";
	                    	 }); 
                 }else{
                  	dialogTypeSaveDraft("提示", "发送失败");
                  }
		  
	  });
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
  //提交表单
  function formSub(formName) {
	  var programName = $('#programName').val();
      if (programName != undefined && programName == '输入节目名称') {
          $('#programName').val("");
      }
	  var teamName = $('#teamName').val();
      if (teamName != undefined && teamName == '输入团队名称') {
          $('#teamName').val("");
      }
      var entryIndex=$("#entryIndex").val();
      if (entryIndex != undefined && entryIndex == '输入编号') {
          $('#entryIndex').val("");
      }
      $(formName).submit();
  }
</script>

</head>
<body>
	<form id="form" action="" method="post">
	    <div class="site">
		    <em>您现在所在的位置：</em>长宁舞蹈大赛列表
		</div>
		<div class="search">
		<div class="search-box w135">
            <i></i><input type="text" id="programName" name="programName" value="${cnwdEntryform.programName}"
                          data-val="输入节目名称" class="input-text"/>
        </div>
		<div class="search-box w135">
            <i></i><input type="text" id="teamName" name="teamName" value="${cnwdEntryform.teamName}"
                          data-val="输入团队名称" class="input-text"/>
        </div>
		<div class="search-box w135">
            <i></i><input type="text" id="entryIndex" name="entryIndex" value="${cnwdEntryform.entryIndex}" onkeyup="this.value=this.value.replace(/[^\d]/g,'')"
                          data-val="输入编号" class="input-text"/>
        </div>
	    <div class="select-box">
       		<input type="hidden" id="matchType" name="matchType" value="${cnwdEntryform.matchType}"/>
            <div id="matchTypeDiv" class="select-text" data-value="">全部参赛类别</div>
            <ul class="select-option">
            	<li data-option="">全部参赛类别</li>
            	<li data-option="街舞">街舞</li>
            	<li data-option="爵士舞">爵士舞</li>
            	<li data-option="踢踏舞">踢踏舞</li>
            	<li data-option="其他舞种">其他舞种</li>
            </ul>
        </div> 
	    <div class="select-box w135" >
       		<input type="hidden" id="checkStatus" name="checkStatus" value="${cnwdEntryform.checkStatus}"/>
            <div id="tagLevelDiv" class="select-text" data-value="">状态</div>
            <ul class="select-option">
            	<li data-option="">状态</li>
            	<li data-option="1">提交成功待审核</li>
            	<li data-option="2">审核通过</li>
            	<li data-option="3">审核不通过</li>
            </ul>
        </div> 
         <div class="select-btn">
            <input type="button" value="搜索" onclick="$('#page').val(1);formSub('#form');"/>
        </div>
		</div>
		<div class="main-content">
		    <table width="100%">
		        <thead>
			        <tr>
			            <th>编号</th>
			            <th class="title">节目名称</th>
			            <th>参赛类别</th>
			            <th>节目时长</th>
			            <th>参演人数</th>
			            <th>团队名称</th>
			            <th>平均年龄</th>
			            <th>状态</th>
			            <th>申请时间</th>
			            <th>管理</th>
			        </tr>
		        </thead>
		        <tbody>
		        <%-- <%int i=0;%> --%>
		        <c:forEach items="${cnwdEntryformList}" var="cnwdEntry">
		            <%-- <%i++;%> --%>
		            <tr>
		                <td >${cnwdEntry.entryIndex }</td>
		                <td  class="title">${cnwdEntry.programName }</td>
		                <td>${cnwdEntry.matchType }</td>
		                <td>${cnwdEntry.programDuration } </td>
		                <td>${cnwdEntry.participatingNumber }</td>
		                <td>${cnwdEntry.teamName }</td>
		                <td>${cnwdEntry.avgAge }</td>
		                <td>    
                                <c:if test="${cnwdEntry.checkStatus == 1}">
                                                                                                                                 提交成功，待审核
                                        </c:if>
                                        <c:if test="${cnwdEntry.checkStatus == 2}">
                                                                                                                                审核通过
                                        </c:if>
                                        <c:if test="${cnwdEntry.checkStatus == 3}">
                                                                                                                               审核不通过
                                          <img height="15" src="${path}/STATIC/image/u112.png" class="reason"></img>                                                                                    
                                        </c:if> 
                                         <div class="refuse_reason">${cnwdEntry.refusalReason}</div> 
                        </td>
                        <td><fmt:formatDate value="${cnwdEntry.createTime}"  pattern="yyyy-MM-dd HH:mm:ss" type="both"/></td>
		                <td>
		                <%if (viewCnwdEntryformButton) {%>
		                   <a target="main" href="${path }/cnwdEntryform/viewCnwdEntryform.do?entryId=${cnwdEntry.entryId}">查看</a>
		                 <%}%> 
                       <%if (checkCnwdEntryformButton) {%>
                          <c:if test="${cnwdEntry.checkStatus== 1}">
                             | <a href="javascript:;" onclick="checkCnwdEntryform(this,'${cnwdEntry.entryId}',2)">审核通过</a>
                          </c:if>
                          <c:if test="${cnwdEntry.checkStatus == 1}">
                              |<a href="javascript:;" onclick="checkCnwdEntryform(this,'${cnwdEntry.entryId}',3)">审核不通过</a>
                          </c:if>
                           <%}%>
		                   |<a target="main"  onclick="sendMessage(this,'${cnwdEntry.entryId}',2)">发送短息</a>
		                </td>
		            </tr>
		        </c:forEach>
		        <c:if test="${empty cnwdEntryformList}">
		            <tr>
		                <td colspan="8"><h4 style="color:#DC590C">暂无数据!</h4></td>
		            </tr>
		        </c:if>
		        </tbody>
		    </table>
		
			<c:if test="${not empty cnwdEntryformList}">
	            <input type="hidden" id="page" name="page" value="${page.page}" />
		    	<div id="kkpager"></div>
	        </c:if>
		</div>
	</form>
</body>
</html>
 <script>

	$("td").on("mouseover",".reason",function(){
		
		$(this).siblings(".refuse_reason").show();
	});
	$("td").on("mouseout",".reason",function(){
		
		$(this).siblings(".refuse_reason").hide();
	});
</script>