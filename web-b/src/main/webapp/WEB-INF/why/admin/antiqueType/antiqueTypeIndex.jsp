<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<head>
    <title>文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    <script type="text/javascript">
        $(function(){
            getPage();
        });
        function getPage(){
            kkpager.generPageHtml({
                pno : '${page.page}',
                total : '${page.countPage}',
                totalRecords :  '${page.total}',
                mode : 'click',//默认值是link，可选link或者click
                click : function(n){
                    this.selectPage(n);
                    $("#page").val(n);
                    $("#pageForm").submit();
                    return false;
                }
            });
        }
    </script>
</head>
<body>
<div class="site">
    <em>您现在所在的位置：</em>藏品类型管理 &gt;藏品类型列表
</div>
<form id="pageForm" method="post" action="${path}/antiqueType/index.do">
    <!-- 正中间panel -->
    <div class="main-content pt10">
        <table width="100%">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>藏品类型名称</th>
                                    <th>所属场馆</th>
                                    <th>创建时间</th>
                                    <th>管理</th>
                                </tr>
                            </thead>
                            <tbody>
                            <c:if test="${null != dataList}">
                                <c:forEach items="${dataList}" var="data" varStatus="status">
                                    <tr>
                                        <td>${status.index+1}</td>

                                        <td title="${data.antiqueTypeName}">${data.antiqueTypeName}</td>

                                        <%--<td>${dataList.messageType}</td>--%>

                                        <%--<td>${dataList.messageTargetUser}</td>--%>
                                        <td>
                                            ${data.venueName}
                                        </td>
                                        <td>
                                                    <fmt:formatDate value="${data.updateTime}" type="both"/>
                                        </td>

                                        <td>
                                        	<%
											    if(antiqueTypePreAddButton) {
										    %>
                                            <a class="_edit"  data-id="${data.antiqueTypeId}" href="javascript:;">编辑</a>
                                            <%
									            }
									        %>
                                        </td>
                                        <%--href="${path}/antiqueType/preEditAntiqueType.do?antiqueTypeId=${data.antiqueTypeId}"--%>

                                    </tr>
                                </c:forEach>
                            </c:if>

                            <c:if test="${empty dataList}">
                                <tr>
                                    <td colspan="9"> <h4 style="color:#DC590C">暂无数据!</h4></td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>


                    <c:if test="${fn:length(dataList) gt 0}">
                        <input type="hidden" id="page" name="page" value="${page.page}" />
                        <div id="kkpager"></div>
                    </c:if>
</form>


<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<script>
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

        $('._edit').on('click', function () {
            var id = $(this).attr("data-id");
            dialog({
                url: '${path}/antiqueType/preEditAntiqueType.do?antiqueTypeId='+id,
                title: '编辑藏品类型',
                width: 460,
                height:200,
                fixed: true
            }).showModal();
            return false;
        });
    });
</script>


</body>
</html>
