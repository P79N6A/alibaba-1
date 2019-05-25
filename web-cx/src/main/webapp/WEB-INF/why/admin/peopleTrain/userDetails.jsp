<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

    <title>场馆列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>

    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <script type="text/javascript">
        $(function() {
         //导出excel表格

        });
          function exportExcel() {
            location.href = "${path}/peopleTrain/exportTrainTerminalExcel.do?" + $("#courseListForm").serialize();
          }
    </script>
    <style>
      .export{
          float: right;
	    display: inline-block;
	    width: 100px;
	    height: 42px;
	    line-height: 42px;
	    overflow: hidden;
	    color: #ffffff;
	    font-size: 18px;
	    border-radius: 5px;
	    -moz-border-radius: 5px;
	    -webkit-border-radius: 5px;
	    background: #1882FC;
	    text-align: center;

      }
    </style>
</head>
<body>

<div class="site">
    <em>您现在所在的位置：</em>培训管理 &gt; 报名列表
</div>
<form id="courseListForm" method="post" action="${path}/peopleTrain/courseList.do">
    <div class="search">
        <div class="search-box">
            <i></i><input id="searchKey" name="searchKey" class="input-text" placeholder="请输入课程名\课程类型" type="text"
                          value=""/>
        </div>
        <div class="select-btn">
            <input type="button" value="搜索" onclick="$('#page').val(1);formSub('#courseListForm')"/>
        </div>
       <a class="export" onclick="exportExcel();">导出</a>
    </div>
    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th>ID</th>
                <th class="title">课程名称</th>
                <th>课程时间</th>
                <th>报名时间</th>
                <th>课程类型</th>
            </tr>
            </thead>
            <c:if test="${empty list}">
                <tr>
                    <td colspan="5"> <h4 style="color:#DC590C">暂无数据!</h4></td>
                </tr>
            </c:if>
            <tbody>

            <c:forEach items="${list}" var="c" varStatus="s">
                <tr>
                    <td>${s.index+1}</td>
                    <td class="title">${c.courseTitle}</td>
                    <td><fmt:formatDate value="${c.courseTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                       <td><fmt:formatDate value="${c.createTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                    <td>${c.courseType}</td>
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
                        formSub('#courseListForm');
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