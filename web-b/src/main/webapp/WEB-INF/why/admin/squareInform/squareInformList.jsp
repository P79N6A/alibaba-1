<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>
      <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${pdath}/STATIC/js/dialog-min.js"></script>
    <!--文本编辑框 end-->
    <!-- dialog start -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>

    <script type="text/javascript">
		var userId = '${sessionScope.user.userId}';
		
		  seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
	            window.dialog = dialog;
	        });
		
		if (userId == null || userId == '') {
			location.href = '${path}/admin.do';
		}
    
        $(function () {
            kkpager.generPageHtml({
                pno: '${page.page}',
                total: '${page.countPage}',
                totalRecords: '${page.total}',
                mode: 'click',//默认值是link，可选link或者click
                click: function (n) {
                    this.selectPage(n);
                    $("#page").val(n);
                    formSub('#squareInformForm');
                    return false;
                }
            });
            
            selectModel();
        });

        //删除广场通知
        function deleteSquareInform(squareId) {
            var html = "您确定要删除吗";
            dialogConfirm("提示", html, function () {
                $.post("${path}/squareInform/deleteSquareInform.do", {"squareId": squareId}, function (data) {
                	   if (data == 'success') {
                      	 dialogAlert("系统提示", "删除成功", function () {
                               window.location.href = "${path}/squareInform/squareInformList.do"
                           });
                              dialog.close().remove();
                      }else{
                        alert("删除失败")
                       } 
                });
            });
        }
        //提交表单
        function formSub(formName) {
        	var userName=$('#userName').val();
            if(userName!=undefined&&userName=='用户名'){
            	$('#userName').val("");
            }
            
            var ext1=$('#ext1').val();
            if(ext1!=undefined&&ext1=='标题'){
            	$('#ext1').val("");
            }
            $(formName).submit();
        }
        
       
    </script>
    <style type="">
    	.entryButton{
    	color: #fff;background-color:rgba(125, 164, 203, 1);border:1px solid rgba(56, 78, 101, 1);font-weight: bolder;border-radius:3px;padding:3px 15px;
    	}
    	.entryReButton{
    	color: #596988;border:1px solid #596988;font-weight: bolder;border-radius:3px;padding:3px 15px;
    	}
    	
    	
    </style>
</head>
<body>
<form id="squareInformForm" action="${path}/squareInform/squareInformList.do" method="post">
     <input type="hidden" id="squareId" name="squareId"/>
     <input type="hidden" id="outId" name="outId"/>
    <div class="site">
		<em>您现在所在的位置：</em>运维管理 &gt;广场通知 &gt;广场通知列表  
	</div>
	<div class="site-title">
	</div>
    <div class="search">
        <div class="search-box">
	        <i></i><input type="text" id="userName" name="userName" value="${squareInform.userName}" data-val="用户名" class="input-text"/>
	    </div>
	     <div class="search-box">
	        <i></i><input type="text" id="ext1" name="ext1" value="${squareInform.ext1}" data-val="标题" class="input-text"/>
	    </div>
        <div class="select-btn">
            <input type="button" onclick="$('#page').val(1);formSub('#squareInformForm');" value="搜索"/>
        </div>
    </div>
    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th>用户名</th>
               <!--  <th>文案描述</th> -->
                <th>标题</th>
              	<!-- <th>照片</th> -->
                <!-- <th>内容</th> -->
              	<th>发布时间</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${list}" var="squareInform" varStatus="">
                <tr>
                    <td>${squareInform.userName }</td>
                  <%--   <td class="title">${squareInform.contextDec}</td> --%>
                    <td>${squareInform.ext1}</td>
                   <%--  <td>${squareInform.ext0 }</td> --%>
                    <%-- <td>${squareInform.ext2}</td> --%>
                    <td><fmt:formatDate value="${squareInform.publishTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                  <%--   <td>
 					<c:choose>
       			        <c:when test="${!empty entry.stageImg}">
							<a onclick="showStageImg('${entry.entryId}',);"><u>查看</u></a>       			        	
       			        </c:when>
       			        <c:otherwise>
       			        	未上传
       			        </c:otherwise>
       			    </c:choose>
					</td> --%>
                   
                    <td>
                      <a target="main" href="${path}/squareInform/editSquareInform.do?squareId=${squareInform.squareId}">编辑</a>
                      |  <a onclick="deleteSquareInform('${squareInform.squareId}');">删除</a>
                    </td>  
                </tr>
            </c:forEach>
            <c:if test="${empty list}">
                <tr>
                    <td colspan="14"><h4 style="color:#DC590C">暂无数据!</h4></td>
                </tr>
            </c:if>
            </tbody>
        </table>
        <c:if test="${not empty list}">
            <input type="hidden" id="page" name="page" value="${page.page}"/>
            <div id="kkpager"></div>
        </c:if>
    </div>
</form>
</body>
</html>
