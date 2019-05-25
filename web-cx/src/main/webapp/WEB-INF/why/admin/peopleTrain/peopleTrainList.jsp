<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

    <title>万人培训用户列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>

    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
</head>
<body>

<div class="site">
    <em>您现在所在的位置：</em>培训管理 &gt; 用户列表
</div>
<form id="courseListForm" method="post" action="${path}/peopleTrain/peopleTrainList.do">
    <div class="search">
        <div class="search-box">
			<i></i><input class="input-text" data-val="输入手机号码关键字" name="userMobileNo" value="<c:if test="${not empty trainTerminalUser.userMobileNo}">${trainTerminalUser.userMobileNo}</c:if><c:if test="${empty trainTerminalUser.userMobileNo}">输入手机号码关键字</c:if>" type="text" id="userMobileNo"/>
		</div>
        <!-- <div class="select-box w135">
        <input type="hidden" name="courseType" id="courseType" value=""/>
	         <div class="select-text" data-value="百分比">培训方式</div>
		      <ul class="select-option select_index" tip="dataone"  style="display: none;" id="courseList">
		      </ul>
        </div>
        <div class="select-box w135">
           <input type="hidden" name="courseField" id="courseField" value=""/>
	         <div class="select-text" data-value="从事领域">从事领域</div>
		      <ul class="select-option select_index" tip="dataone"  style="display: none;" id="courseFieldList">
		      </ul>
        </div> -->
        <div class="select-btn">
            <input type="button" value="搜索" onclick="$('#page').val(1);formSub('#courseListForm')"/>
        </div>
        <%-- <div class="menage-box">
        <a class="btn-add" href="${path}/peopleTrain/addCourse.do">添加课程</a>
        </div> --%>
    </div>
    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th>ID</th>
                <th>真实姓名</th>
                <th>手机号</th>
                <th>职务</th>
                <th>职称</th>
                <th>所在单位</th>
                <th>注册时间</th>
                <th>操作</th>
            </tr>
            </thead>
            <c:if test="${empty users}">
                <tr>
                    <td colspan="7"> <h4 style="color:#DC590C">暂无数据!</h4></td>
                </tr>
            </c:if>
            <tbody>

            <c:forEach items="${users}" var="u" varStatus="s">
                <tr>
                 <td>${s.index+1}</td>
                    <td>${u.realName}</td>
                    <td>${u.userMobileNo}</td>
                    <td>${u.jobName}</td>
                    <td>${u.titleName}</td>
                    <td>${u.unitName}</td>
					<td><fmt:formatDate value="${u.createTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                    <td>

                             <a href="${path}/peopleTrain/viewTrainUser.do?userId=${u.userId}">查看</a>

<%--                         | <a href="${path}/peopleTrain/editCourse.do?courseId=${c.userId}">编辑</a> --%>
                    </td>

                </tr>
            </c:forEach>
            </tbody>
        </table>
        <c:if test="${not empty users}">
            <input type="hidden" id="page" name="page" value="${page.page}" />
            <div id="kkpager"></div>
        </c:if>
        <script type="text/javascript">
            $(function(){
                kkpager.generPageHtml({
                    pno : '${page.page}',
                    total : '${page.countPage}',
                    totalRecords :  '${page.total}',
                    isShowTotalRecords : true,
                    mode : 'click',//默认值是link，可选link或者click
                    click : function(n){
                        this.selectPage(n);
                        $("#page").val(n);
                        formSub('#courseListForm');
                        return false;
                    }
                });
            });

            //提交表单
           function formSub(formName){
			if($("#userMobileNo").val() == "输入手机号码关键字"){
				$("#userMobileNo").val("");
			}
			$(formName).submit();
		}

        </script>
    </div>
</form>

</body>
</html>