<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>

    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>

    <script type="text/javascript">
        $(function(){
            getPage();
            selectModel();

            //删除
            deleteComment();
        });

        // 分页
        function getPage(){
            kkpager.generPageHtml({
                pno : '${page.page}',
                total : '${page.countPage}',
                totalRecords :  '${page.total}',
                mode : 'click',//默认值是link，可选link或者click
                click : function(n){
                    this.selectPage(n);
                    $("#page").val(n);
                    formSub('#commentForm');
                    return false;
                }
            });
        }

        function formSub(formName){
            $(formName).submit();
        }

        function deleteComment(){
            $(".delete").on("click", function(){
                var commentId = $(this).attr("commentId");
                var name = $(this).parent().siblings(".title").find("a").text();
                var html = "您确定要删除" + name + "吗？";
                dialogConfirm("提示", html, function(){
                    $.post("${path}/comment/deleteComment.do",{commentId:commentId},function(data) {
                        if (data == 'success') {
                            window.location.href="${path}/comment/commentIndex.do";
                        }
                    });
                })
            });
        }

        function checkComment(commentId,commentState){
            var showText = '' ;
            if(commentState == 1){
                showText = '审核通过' ;
            } else {
                showText = '审核拒绝' ;
            }
            var html = "您确定要" + showText + "吗？";
            dialogConfirm("提示", html, function(){
                $.post("${path}/comment/checkComment.do",{commentId:commentId,commentState:commentState},function(data) {
                    if (data == 'success') {
                        window.location.href="${path}/comment/commentIndex.do";
                    }
                });
            })
        }
    </script>
</head>
<body>
<form action="${path}/comment/commentIndex.do" id="commentForm" method="post">
<div class="site">
    <em>您现在所在的位置：</em>评论管理 &gt; 评论列表
</div>

    <div class="search">
        <div class="select-box w135">
            <input type="hidden" id="commentType" name="commentType" value="${comment.commentType}" />
            <div class="select-text" data-value="" id="commentTypeDiv">所有类型</div>
            <ul class="select-option">
                <li data-option="">所有类型</li>
                <li data-option="1">场馆</li>
                <li data-option="2">活动</li>
                <li data-option="20">动态资讯 </li>
                <li data-option="21">文化联盟</li>
                <li data-option="30">文化点单</li>
               <%-- <li data-option="7">活动室</li>
                <li data-option="9">通知</li>
                <li data-option="10">直播</li>--%>
            </ul>
        </div>
        <div class="select-btn">
                <input type="button" value="搜索" onclick="$('#page').val(1);formSub('#commentForm');"/>
        </div>
    </div>
    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th width="50">ID</th>
                <th class="title" width="150">评论对象名称/内容</th>
                <th width="100">评论类型</th>
                <th style="text-align: left;">评论内容</th>
                <th width="100">评论人</th>
                <th width="150">评论ID</th>
                <th width="110">评论状态</th>
                <th width="110">评论时间</th>
                <th width="80">管理</th>
            </tr>
            </thead>
            <c:if test="${fn:length(commentList) gt 0}">
                <tbody>
                <%int i=0;%>
                <c:forEach items="${commentList}" var="comment">
                    <%i++;%>
                    <tr>
                        <td><%=i%></td>
                        <td class="title">
                            <c:if test="${not empty comment.commentRkName}">
                            	<c:choose>
                            		<c:when test="${comment.commentType == 4}">
                            			<img src="${fn:split(comment.commentRkName, ';')[0]}@140w" alt="" />
                            		</c:when>
                            		<c:otherwise>
                            			${comment.commentRkName}
                            		</c:otherwise>
                            	</c:choose>
                            </c:if>
                        </td>
                        <td>
                            <c:if test="${comment.commentType == 1}">场馆</c:if>
                            <c:if test="${comment.commentType == 2}">活动</c:if>
                            <%--<c:if test="${comment.commentType == 3}">藏品</c:if>--%>
                            <%--<c:if test="${comment.commentType == 4}">专题活动</c:if>--%>
                            <%--<c:if test="${comment.commentType == 6}">团体</c:if>--%>
                            <c:if test="${comment.commentType == 7}">活动室</c:if>
                            <%--<c:if test="${comment.commentType == 8}">非遗</c:if>--%>
                            <%--<c:if test="${comment.commentType == 9}">通知</c:if>--%>
                            <%--<c:if test="${comment.commentType == 10}">直播</c:if>--%>
                            <c:if test="${comment.commentType == 20}">动态资讯 </c:if>
                            <c:if test="${comment.commentType == 21}">文化联盟 </c:if>
                            <c:if test="${comment.commentType == 30}">文化点单 </c:if>
                            <%--<c:if test="${comment.commentType == 21}">文化文物</c:if>--%>
                            <%--<c:if test="${comment.commentType == 22}">文化商城</c:if>--%>
                        </td>
                        <td title="<c:out escapeXml="true" value="${comment.commentRemark}"/>" style="text-align: left; word-break: break-all; word-wrap: break-word; padding: 8px 0;">
                            <c:out escapeXml="true" value="${comment.commentRemark}"/>
                        </td>
                        <td>
                            <c:if test="${not empty comment.commentUserName}">
                                ${comment.commentUserName}
                            </c:if>
                        </td>
                        <td>
                        	${comment.commentUserId}
                        </td>
                        <td>
                            <c:if test="${not empty comment.commentTime}">
                                <fmt:formatDate value="${comment.commentTime}"  pattern="yyyy-MM-dd HH:mm" />
                            </c:if>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${empty comment.commentState or comment.commentState == 0}">
                                    待审核
                                </c:when>
                                <c:when test="${comment.commentState == 1}">
                                    审核通过
                                </c:when>
                                <c:when test="${comment.commentState == 2}">
                                    审核未通过
                                </c:when>
                            </c:choose>
                        </td>
                        <td>
                            <c:if test="${empty comment.commentState or comment.commentState == 0}">
                                <a  target='main'  href=javascript:checkComment('${comment.commentId}',1);>通过</a>
                                | <a  target='main'  href=javascript:checkComment('${comment.commentId}',2);>拒绝</a> |
                            </c:if>
                            <%
                                if(commentDeleteButton) {
                            %>
                                <a class="delete" commentId="${comment.commentId}">删除</a><%if(commentViewButton){%> | <%}%>
                            <%
                                }
                            %>

                            <%
                                if(commentViewButton) {
                            %>
                                <a href="${path}/comment/viewComment.do?commentId=${comment.commentId}">查看</a>
                            <%
                                }
                            %>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </c:if>
            <c:if test="${empty commentList}">
                <tr>
                    <td colspan="7"> <h4 style="color:#DC590C">暂无数据!</h4></td>
                </tr>
            </c:if>
        </table>
        <c:if test="${not empty commentList}">
            <input type="hidden" id="page" name="page" value="${page.page}" />
            <div id="kkpager"></div>
        </c:if>
    </div>
</form>
</body>
</html>