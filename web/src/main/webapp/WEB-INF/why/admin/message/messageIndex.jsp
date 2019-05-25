<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<head>
    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    <script type="text/javascript" src="${path}/STATIC/js/admin/sysMessage/addMessage.js"></script>
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
    <em>您现在所在的位置：</em>系统消息 &gt; 系统消息列表
</div>

<div class="search">
    <div class="search-total">
        <div class="select-btn">
        <%
	        if(messageAddButton) {
	    %>
            <input class="btn-add-tag" type="button" value="添加"/>
	    <%
	        }
	    %>
        </div>
    </div>
</div>

<form id="pageForm" method="post" action="${path}/message/messageIndex.do">
    <!-- 正中间panel -->
    <div class="main-content">
        <table width="100%">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>发送内容模板</th>
                                    <th>消息类别</th>
                                   <%-- <th>目标用户</th>--%>
                                    <th>创建时间</th>
                                    <th>管理</th>
                                </tr>
                            </thead>
                            <tbody>
                            <c:if test="${null != messageList}">
                                <c:forEach items="${messageList}" var="dataList" varStatus="status">
                                    <tr>
                                        <td>${status.index+1}</td>

                                        <td title="${dataList.messageContent}">
                                            <c:choose>
                                                <c:when test="${fn:length(dataList.messageContent) > 20}">
                                                    ${fn:substring(dataList.messageContent, 0 , 20)}.....
                                                </c:when>
                                                <c:otherwise>
                                                    ${dataList.messageContent}
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>${dataList.messageType}</td>

                                        <%--<td>${dataList.messageTargetUser}</td>--%>

                                        <td width="80">
                                                    <fmt:formatDate value="${dataList.messageCreateTime}" type="both"/>
                                        </td>

                                        <td>
                                        <%
									        if(messageEditButton) {
									    %>
                                            <a class="_edit" href="javascript:;" data-id="${dataList.messageId}">编辑</a>
									    <%
									        }
									    %>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:if>

                            <c:if test="${empty messageList}">
                                <tr>
                                    <td colspan="9"> <h4 style="color:#DC590C">暂无数据!</h4></td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                    <input type="hidden" id="page" name="page" value="${page.page}" />
                    <c:if test="${fn:length(messageList) gt 0}">
                        <div id="kkpager"></div>
                    </c:if>
</form>

<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<script type="text/javascript">
    seajs.config({
        alias: {
            "jquery": "jquery-1.10.2.js"
        }
    });
    seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
        window.dialog = dialog;
    });

    window.console = window.console || {
        log:function () {

        }
    }
    seajs.use(['jquery'], function ($) {
        $('.btn-add-tag').on('click', function () {
            dialog({
                url: '${path}/message/preAddMessage.do',
                title: '添加消息模板',
                width: 560,
                height:400,
                fixed: true
            }).showModal();
            return false;
        });

        $('._edit').on('click', function () {
            var id = $(this).attr("data-id");
            dialog({
                url: '${path}/message/preEditMessage.do?id='+id,
                title: '编辑消息模板',
                width: 560,
                height:400,
                fixed: true
            }).showModal();
            return false;
        });

    });
</script>

</body>
</html>
