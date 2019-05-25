<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>分配管理员--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <script type="text/javascript">
        $(function(){
       /*      $("input[type=checkbox]").change(function(){
                $("#userDeptPath").val($(this).val());
                $("#userId").val($(this).attr("id"));
                var obj = this;
                 $("input[type=checkbox]").each(function(){
                    if(obj != this){
                        $(this).attr("checked",false);
                    }
                }); 
            }); */
        })

        function assignSubmit(){
        /** add by yh 2015-10-28 begin 选择多个管理员  */
        	var userIds = new Array;
        	$("input[type=checkbox]").each(function(){
                var attrs = $(this).attr("checked");
            	var userId = $(this).attr("id"); 
            	 if(attrs){
            		userIds.push(userId);
            	} 
            });
			var uids = userIds.join();
        	/** add by yh 2015-10-28 end */
        	
            var userDeptPath = $("#userDeptPath").val();
            var venueId = $("#venueId").val();
            var userId = $("#userId").val();

            $.post("${path}/venue/assignManager.do", {userDeptPath:userDeptPath,venueId:venueId,userId:uids}, function(result) {
                if(result == "success"){
                    dialogAlert('提示', '场馆管理员分配成功!',function (){
                        window.location.href="${path}/venue/venueIndex.do";
                    });
                }else{
                    dialogAlert('提示', '场馆管理员分配失败!');
                }
            }); 
        }
    </script>
</head>
<body>
<div class="site">
    <em>您现在所在的位置：</em>场馆管理 &gt; 分配管理员
</div>
<div class="site-title">分配管理员</div>
<div class="main-content">
    <form id="assignForm">
        <table width="100%">
            <tr>
                <td>
                    <c:choose>
                        <c:when test="${viewAssign  == 1}">
                            <div style="text-align: left;width: 300px;float: left">
                                <span>${sysUser.userNickName}</span>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:if test="${fn:length(userList) > 0}">
                                <c:forEach items="${userList}" var="user">
                                    <div style="text-align: left;width: 300px;float: left">
                                        <input type="checkbox" value="${user.userDeptPath}" id="${user.userId}"/>姓名:${user.userNickName} (帐号:${user.userAccount})
                                    </div>
                                </c:forEach>
                            </c:if>
                            <c:if test="${userList == null || fn:length(userList) == 0}">
                                当前已没有可分配的管理员，请在当前区下进行创建场馆管理员
                            </c:if>
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>
            <tr>
                <input id="venueId" value="${venue.venueId}" type="hidden"/>
                <input id="userDeptPath" type="hidden"/>
                <input id="userId" type="hidden"/>
                <td class="td-btn">
                    <c:if test="${viewAssign  == null || viewAssign != 1}">
                        <input type="button" value="保存" onclick="assignSubmit()"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    </c:if>
                    <input type="button" value="返回" onclick="javascript:history.back(-1)"/>
                </td>
            </tr>
        </table>
    </form>
</div>

</body>
</html>