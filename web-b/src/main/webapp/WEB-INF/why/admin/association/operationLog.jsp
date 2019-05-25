<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>社团申请列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>

    <script type="text/javascript">
        //搜索
        function formSub(formName){
            var  assnName=$('#assnName').val();
            if(assnName!=undefined&&assnName=='输入社团名称'){
                $('#assnName').val("");
            }
            $(formName).submit();
        }

        $(document).ready(function(){
            //分页
            kkpager.generPageHtml({
                pno : '${page.page}',
                total : '${page.countPage}',
                totalRecords :  '${page.total}',
                mode : 'click',//默认值是link，可选link或者click
                click : function(n){
                    this.selectPage(n);
                    $("#page").val(n);
                    formSub('#associationForm');
                    return false;
                }
            });
        });


    </script>
</head>
<body>
<form id="associationForm" action="${path}/association/operationLog.do" method="post">
    <div class="main-content">
        <table width="100%">
            <input type="hidden" id="assnId" name="assnId" value="${association.assnId}"/>
            <thead>
            <tr>
                <th width="30">ID</th>
                <th width="40">操作人</th>
                <th width="40">状态</th>
                <th width="80">操作时间</th>
                <th width="100">驳回理由</th>
            </tr>
            </thead>
            <tbody>
            <%--1:已通过 2:被驳回 3:编辑--%>
            <c:forEach var="ass" items="${ ccpAssociationExamines}" varStatus="status">
                <tr>
                    <td>${ status.index + 1}</td>
                    <td>${ ass.examineUserName}</td>

                    <c:choose>
                        <c:when test="${ass.examineState==1}">
                            <td>已通过</td>
                        </c:when>
                        <c:when test="${ass.examineState==2}">
                            <td>被驳回</td>
                        </c:when>
                        <c:otherwise>
                            <td>编辑</td>
                        </c:otherwise>
                    </c:choose>
                    <td><fmt:formatDate value="${ass.examineTime}" pattern="yyyy-MM-dd"/></td>
                    <td>${ ass.reason}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
    <c:if test="${not empty ccpAssociationExamines}">
        <input type="hidden" id="page" name="page" value="${page.page}"/>
        <div id="kkpager"></div>
    </c:if>

    <div class="search" style="text-align: center">
        <div class="select-btn" style="float: none;width: auto">
            <input type="button" onclick="javascript:history.back()" value="关闭"/>
        </div>
    </div>
</form>
</body>
</html>