<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

    <title>活动室场次列表--文化上海云</title>
    <%@include file="../../common/pageFrame.jsp"%>

    <!-- dialog start -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <style type="text/css">
        .td-time{ float: left; width: 218px; height: 20px; line-height: 20px; padding: 10px 6px; margin-right: 10px; border: solid 1px #ACB4C3; position: relative; border-radius: 4px; -webkit-border-radius: 4px; -moz-border-radius: 4px; background: url("../image/input-icon1.gif") repeat-x;}
        .td-time .text{ float: left; display: inline-block; color: #596887; padding: 0 10px 0 5px;}
        .td-time input{ float: left; display: inline-block; line-height: 20px; color: #142340; width: 72px; border: none; text-align: left;}
        .td-time i{ display: block; position: absolute; right: 7px; top: 8px; width: 22px; height: 22px; background: url("${path}/STATIC/image/data-icon1.png") no-repeat; cursor: pointer;}
    </style>
    <!-- dialog end -->
</head>
<body>
<div class="site">
<c:choose>
	<c:when test="${empty venueId }">
	 <em>您现在所在的位置：</em>活动室管理 &gt; ${activityRoom.roomName} &gt; 场次列表
	</c:when>
	<c:otherwise>
	 <em>您现在所在的位置：</em>场馆管理 &gt;场馆信息管理 &gt; 场馆列表 &gt; 活动室管理 &gt; ${activityRoom.roomName} &gt; 场次列表
	</c:otherwise>
</c:choose>
   
</div>
<form id="activityRoomBookForm" action="${path}/cmsRoomBook/queryRoomBookList.do?venueId=${venueId}" method="post">
<input type="hidden" id="roomId" name="roomId" value="${activityRoom.roomId}"/>
<script type="text/javascript">
    $(function(){
        $(".start-btn").on("click", function(){
            WdatePicker({el:'startDate',dateFmt:'yyyy-MM-dd',doubleCalendar:true,minDate:'%y-%M-%d',maxDate:'%y-%M-{%d+6}',position:{left:-70,top:8},isShowClear:false,isShowOK:true,isShowToday:false,onpicked:pickedStartFunc})
        })
    });
    function pickedStartFunc(){
        $dp.$('activityStartTime').value=$dp.cal.getDateStr('yyyy-MM-dd');
    }
</script>
<div class="search">
    <div class="td-time">
        <span class="text">开放日期</span>
        <input type="text" id="startDate" name="startDate" value="${startDate}"/>
        <i class="data-btn start-btn"></i>
    </div>

    <div class="select-btn">
        <input type="button" value="搜索" onclick="$('#page').val(1);formSub('#activityRoomBookForm')"/>
    </div>
</div>

<div class="main-content">
    <table width="100%">
        <thead>
        <tr>
            <th>ID</th>
            <th>开放日期</th>
            <th>开放时间</th>
            <th>星期</th>
            <th>状态</th>
            <th>操作时间</th>
            <th width="100px;">管理</th>
        </tr>
        </thead>

        <c:if test="${empty roomBookList}">
            <tr>
                <td colspan="7"> <h4 style="color:#DC590C">暂无数据!</h4></td>
            </tr>
        </c:if>
        <tbody>

        <c:forEach items="${roomBookList}" var="c" varStatus="s">
            <tr>
                <td>${s.index+1}</td>
                <td><fmt:formatDate value="${c.curDate}" pattern="yyyy-MM-dd" /></td>
                <td>
                    <c:choose>
                        <c:when test="${c.openPeriod == null ||  c.openPeriod == 'OFF'}">不开放</c:when>
                        <c:otherwise>
                            ${c.openPeriod}
                        </c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <c:choose>
                        <c:when test="${c.dayOfWeek == 1}">星期一</c:when>
                        <c:when test="${c.dayOfWeek == 2}">星期二</c:when>
                        <c:when test="${c.dayOfWeek == 3}">星期三</c:when>
                        <c:when test="${c.dayOfWeek == 4}">星期四</c:when>
                        <c:when test="${c.dayOfWeek == 5}">星期五</c:when>
                        <c:when test="${c.dayOfWeek == 6}">星期六</c:when>
                        <c:when test="${c.dayOfWeek == 7}">星期日</c:when>
                        <c:otherwise>
                            无效星期
                        </c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <c:choose>
                        <c:when test="${c.bookStatus == 1}"><span style="color: blue;">开放</span></c:when>
                        <c:when test="${c.bookStatus == 2}"><span style="color: grey;">已预订</span></c:when>
                        <c:when test="${c.bookStatus == 3}"><span style="color: red;">不开放</span></c:when>
                        <c:otherwise>
                            无效状态
                        </c:otherwise>
                    </c:choose>
                </td>
                <td><fmt:formatDate value="${c.updateTime}" pattern="yyyy-MM-dd HH:mm" /></td>
                <td width="100px;" style="color:red;">
                    <a href="${path}/cmsRoomBook/preEditRoomBook.do?bookId=${c.bookId}&venueId=${venueId}">修改状态</a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <c:if test="${not empty roomBookList}">
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
                    formSub('#activityRoomBookForm');
                    return false;
                }
            });
        });

        //提交表单
        function formSub(formName){
            $(formName).submit();
        }
    </script>
</div>
</form>
</body>
</html>