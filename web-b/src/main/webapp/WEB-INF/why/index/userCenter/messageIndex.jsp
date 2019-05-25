<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<head>
    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>

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
                    $("#myForm").submit();
                    return false;
                }
            });
        });
    </script>
</head>
<body>
<div class="site">
    <em>您现在所在的位置：</em>系统消息 &gt; 系统消息列表
</div>
<form id="myForm" method="post" action="${path}/message/messageIndex.do">
    <!-- 正中间panel -->
    <div class="main-content">
        <table width="100%">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>发送内容模板</th>
                                    <th>消息类别</th>
                                    <th>目标用户</th>
                                    <th>创建时间</th>
                                    <th>管理</th>
                                </tr>
                            </thead>
                            <tbody>
                            <c:if test="${null != messageList}">
                                <c:forEach items="${messageList}" var="dataList" varStatus="status">
                                    <tr>
                                        <td>${status.index+1}</td>
                                        <c:choose>
                                            <c:when test="${not empty dataList.messageContent}">
                                                <td class="th-name">${dataList.messageContent}</td>
                                            </c:when>
                                            <c:otherwise>
                                                <td class="th-name"></td>
                                            </c:otherwise>
                                        </c:choose>

                                        <c:choose>
                                            <c:when test="${not empty dataList.messageType}">
                                                <td>${dataList.messageType}</td>
                                            </c:when>
                                            <c:otherwise>
                                                <td></td>
                                            </c:otherwise>
                                        </c:choose>

                                        <c:choose>
                                            <c:when test="${not empty dataList.messageTargetUser}">
                                                <td>${dataList.messageTargetUser}</td>
                                            </c:when>
                                            <c:otherwise>
                                                <td></td>
                                            </c:otherwise>
                                        </c:choose>

                                        <c:choose>
                                            <c:when test="${not empty dataList.messageCreateTime}">
                                                <td width="80">
                                                    <fmt:formatDate value="${dataList.messageCreateTime}" type="both"/>
                                                </td>
                                            </c:when>
                                            <c:otherwise>
                                                <td></td>
                                            </c:otherwise>
                                        </c:choose>
                                        <td>
                                            <a href="${path}/message/preEditMessage.do?id=${dataList.messageId}">编辑</a>
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
                <c:if test="${not empty messageList}">
                    <div id="kkpager"></div>
                </c:if>


                    <!-- 分页功能div start -->
                    <%--<c:if test="${not empty userList}">
                        <input type="hidden" id="page" name="page" value="${page.page}" />
                        <div class="turn-page-box">
                            <ul>
                                <li><a class="first-page" href="javascript:void(0);" onclick="pageSubmit(0)">首页</a></li>
                                <li><a class="pre-page" href="javascript:void(0);" onclick="pageSubmit(${page.page-1})">上一页</a></li>
                                <!-- 判断当前页是否小于总页数 start -->
                                <c:choose>
                                    <c:when test="${(page.page+1) <= page.countPage}">
                                        <li><a class="next-page" href="javascript:void(0);" onclick="pageSubmit(${page.page+1})">下一页</a></li>
                                    </c:when>
                                    <c:otherwise>
                                        <li><a class="next-page" href="javascript:void(0);" onclick="pageSubmit(${page.countPage})">下一页</a></li>
                                    </c:otherwise>
                                </c:choose>
                                <!-- 判断当前页是否小于总页数 end -->
                                <li><a class="last-page" href="javascript:void(0);" onclick="pageSubmit(${page.countPage})">尾页</a></li>
                            </ul>
                            <div class="total-page">
                                <span>第${page.page}页</span>
                                <span>/</span>
                                <span>共${page.countPage}页</span>

                            </div>
                            <div class="go-page">
                                <span>跳转到：</span>
                                <input class="go-page-text" id="goPage" type="text" value="${page.page}">
                                <input class="go-page-btn" type="button" value="GO" onclick="pageSubmit($('#goPage').val())"/>
                            </div>
                        </div>
                        <script type="text/javascript">
                            var pageSize = ${page.countPage};
                            function pageSubmit(page){
                                //alert(page);
                                if(page <= pageSize){
                                    $("#page").val(page);
                                    formSub("#PageForm");
                                }else{
                                    alert("跳转页数不能超过总页数");
                                }
                            }

                        </script>
                    </c:if>--%>
                    <!-- 分页功能div end -->
</form>

</body>
</html>
