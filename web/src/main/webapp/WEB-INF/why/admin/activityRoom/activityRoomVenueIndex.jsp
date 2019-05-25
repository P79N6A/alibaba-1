<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
 
    <title>活动室列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@ include file="/WEB-INF/why/common/limit.jsp"%>
	
    <!-- dialog start -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <script type="text/javascript">
        $(function() {
            $(".delete").on("click", function(){
                var roomId = $(this).attr("id");
                var name = $(this).parent().siblings(".title").find("a").text();
                var html = "您确定要删除" + name + "吗？";
                dialogConfirm("提示", html, function(){
                    $.post("${path}/activityRoom/deleteActivityRoom.do",{"roomId":roomId}, function(data) {
                        if (data!=null && data=='success') {
                            window.location.href="${path}/activityRoom/activityRoomIndex.do?venueId=${cmsVenue.venueId}";
                        }
                    });
                })
            });

            $("#select-all").on("click", function(){
                $(".main-content tbody td>input[type=checkbox]").prop("checked", this.checked);
            });
        });
        
        // 删除活动室
        function preDeleteActivityRoom(roomId){
        	var name = $("#"+roomId).parent().siblings(".title").find("a").text();
        	var html = "您确定要删除'" + name + "'吗？";
            dialogConfirm("提示", html, function(){
               $.post("${path}/activityRoom/preDeleteActivityRoom.do",{"roomId":roomId}, function(data) {
	                      	dialogAlert('提示',data.msg,function(){
	                      		if('2'==data.status){ //此状态代表删除至回收站
		                            window.location.href="${path}/activityRoom/activityRoomIndex.do?venueId=${cmsVenue.venueId}";
	                      		}
	                      	});
                    }); 
                });
        }
        
        function moveRoom(roomId,name) {
	    	 
            var html = "您确定要执行" + name + "操作吗？";
            dialogConfirm("提示", html, function () {
                $.post("${path}/activityRoom/moveActivityRoom.do", {"roomId": roomId}, function (data) {
                   
                    if (data != null && data == 'success') {
                    	 dialogAlert('提示', '操作成功！', function () {
                            window.location.href = "${path}/activityRoom/activityRoomIndex.do?venueId=${cmsVenue.venueId}";
                    	 });
                     }
                    else if (data=='failure'){
                    	
                    	 dialogAlert('提示', '操作失败，系统错误！');
                    }
                    else if (data=='login'){
                    	
                    	 dialogAlert('提示', '请先登录！', function () {
                    			window.location.href = "${path}/login.do";
	                    	 });
                    }
                });
            });
     }
    </script>
    <!-- dialog end -->
   
</head>
<body>

<div class="site">
    <em>您现在所在的位置：</em>场馆管理 &gt; 场馆信息管理 &gt;场馆列表 &gt; ${cmsVenue.venueName} &gt; 活动室列表
</div>
<form id="activityRoomIndexForm" action="${path}/activityRoom/activityRoomIndex.do" method="post">
<input type="hidden" id="venueId" name="venueId" value="${cmsVenue.venueId}"/>
<div class="search">
    <div class="search-box">
        <i></i><input id="searchKey" name="searchKey" class="input-text" data-val="请输入活动室名称\发布人\操作人" type="text"
                      value="<c:choose><c:when test="${not empty searchKey}">${searchKey}</c:when><c:otherwise>请输入活动室名称\发布人\操作人</c:otherwise></c:choose>" />
    </div>
    <div class="select-btn">
        <input type="button" value="搜索" onclick="$('#page').val(1);formSub('#activityRoomIndexForm')"/>
    </div>
</div>
<div class="search menage">
    <h2>${cmsVenue.venueName}  活动室一览</h2>
    <%
      if(activityRoomAddButton){
     %>
	    <div class="menage-box">
	        <a class="btn-add" href="${path}/activityRoom/preAddActivityRoom.do?venueId=${cmsVenue.venueId}">新建活动室</a>
	    </div>
     <%
        }
     %>
</div>

<div class="main-content">
    <table width="100%">
        <thead>
        <tr>
            <%--<th width="30"></th>--%>
            <th>ID</th>
            <th class="title">活动室名称</th>
            <%--<th>所属区县</th>--%>
            <th>具体位置</th>
            <th>发布者</th>
            <th>发布时间</th>
            <th>最新操作人</th>
            <th>最新操作时间</th>
             <th>状态</th>
            <th width="200">管理</th>

        </tr>
        </thead>

        <c:if test="${empty list}">
            <tr>
                <td colspan="8"> <h4 style="color:#DC590C">暂无数据!</h4></td>
            </tr>
        </c:if>

        <tbody>

        <c:forEach items="${list}" var="c" varStatus="s">
            <tr>
                <%--<td><input type="checkbox"/></td>--%>
                <td>${s.index+1}</td>
                <td class="title"><a href="${path}/frontRoom/roomDetail.do?roomId=${c.roomId}" target="_blank">${c.roomName}</a></td>
                <%--<td></td>--%>
                <td width="420px">${c.roomNo}</td>
                <td>${c.roomCreateUser}</td>
                <td width="120"><fmt:formatDate value="${c.roomCreateTime}" pattern="yyyy-MM-dd HH:mm" /></td>
                <td>${c.roomUpdateUser}</td>
                <td width="120"><fmt:formatDate value="${c.roomUpdateTime}" pattern="yyyy-MM-dd HH:mm" /></td>
                  <td>
                                <c:if test="${c.roomIsDel== 1}">
                                   已上架
                                </c:if>
                                <c:if test="${c.roomIsDel == 3}">
                                    已下架
                                </c:if>

                            </td>
                <td>
                	<c:if test="${c.sysNo=='0'||empty c.sysNo}">
	                	 <%
					      if(activityRoomEditButton){
					     %>
		                    <a href="${path}/activityRoom/preEditActivityRoom.do?roomId=${c.roomId}&venueId=${cmsVenue.venueId}">编辑</a>|
					     <%
					        }
					     %>
					</c:if>
					
					  <%
				      if(activityRoomMoveButton){
				     %>
	                     <c:choose>
                        	<c:when test="${c.roomIsDel== 1 }">
                        	<a href="javascript:moveRoom('${c.roomId }','下架')" >下架</a>|
                        	</c:when>
                       	 <c:when test="${c.roomIsDel== 3 }">
                        	<a href="javascript:moveRoom('${c.roomId }','上架')" >上架</a>|
                        	</c:when>
                        </c:choose>
				     <%
				        }
				     %>
					
                    <a href="${path}/cmsRoomBook/queryRoomBookList.do?roomId=${c.roomId}&venueId=${cmsVenue.venueId}">开放场次管理</a>|

				     <%
				      if(activityRoomDeleteButton){
				     %>
	                    <a href="javascript:preDeleteActivityRoom('${c.roomId }')" id="${c.roomId}" >删除</a>|
				     <%
				        }
				     %>
				     <%
				      if(activityRoomOrderIndexButton){
				     %>
	                    <a href="${path}/cmsRoomOrder/queryAllRoomOrderList.do?roomId=${c.roomId}&venueId=${cmsVenue.venueId}">预订详情</a>
				     <%
				        }
				     %>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <c:if test="${not empty list}">
        <input type="hidden" id="page" name="page" value="${page.page}" />
        <div id="kkpager"></div>
    </c:if>

    <script type="text/javascript">
        $(function(){
            kkpager.generPageHtml({
                pno : '${page.page}',
                total : '${page.countPage}',
                totalRecords :  '${page.total}',
                mode : 'click',//默认值是link，可选link或者click
                click : function(n){
                    this.selectPage(n);
                    $("#page").val(n);
                    formSub('#activityRoomIndexForm');
                    return false;
                }
            });
        });

        //提交表单
        function formSub(formName){
        	var searchKey = $("#searchKey").val();
            if(searchKey == "请输入活动室名称\\发布人\\操作人"){		//"\\"代表一个反斜线字符\
                $("#searchKey").val("");
            }
            $(formName).submit();
        }
    </script>
</div>
</form>
</body>
</html>