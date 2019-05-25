<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setLocale value="zh_CN"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/html">
<head>
    <title>查看评论</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>

    <script type="text/javascript">
        $(function(){
            $("#commentImg").find(".pld_img img").each(function(index,item){
                var commentImgUrl = $(this).attr("data-url");
                commentImgUrl = getImgUrl(commentImgUrl);
                commentImgUrl = getIndexImgUrl(commentImgUrl, "_300_300");
                $(item).attr("src", commentImgUrl);
            });
        });

        function deleteComment(){
            var commentId = $("#commentId").val();
            dialogConfirm("提示", "确定删除吗？", function(){
                $.post("${path}/comment/deleteComment.do",{commentId:commentId},function(data) {
                    if (data == 'success') {
                        window.location.href="${path}/comment/commentIndex.do";
                    }
                });
            })
        }
    </script>
</head>
<body>
<div class="site">
    <em>您现在所在的位置：</em>评论管理 &gt; 查看评论
</div>
<div class="site-title">评论内容</div>
<!-- 正中间panel -->
<div class="main-publish">
    <input type="hidden" value="${comment.commentId}" id="commentId"/>
    <table class="form-table" width="100%">
        <tbody>
        <tr>
            <td class="td-title" width = "130">评论时间：</td>
            <td class="td-input" >
                <span><fmt:formatDate value="${comment.commentTime}" pattern="yyyy-MM-dd HH:mm" /></span>
            </td>
        </tr>
        <tr>
            <td class="td-title">用户名：</td>
            <td class="td-input" >
                <span>${comment.commentUserName}</span>
            </td>
        </tr>
        <tr>
            <td class="td-title">评论对象：</td>
            <td class="td-input" >
                <span>${comment.commentRkName}</span>
            </td>
        </tr>
        <tr>
            <td class="td-title">评论内容：</td>
            <td class="td-input" >
                <span><c:out escapeXml="true" value="${comment.commentRemark}"/></span>
            </td>
        </tr>
        <tr>
            <td class="td-title"></td>
            <td id="commentImg">
                <c:if test="${not empty comment.commentImgUrl}">
                    <div class="wk">
                        <c:set var="commentImgUrls" value="${fn:split(comment.commentImgUrl, ';')}" />
                        <c:forEach items="${commentImgUrls}" var="commentImgUrl">
                            <c:if test="${not empty commentImgUrl}">
                                <div class="pld_img fl">
                                    <img onload="fixImage(this, 75, 50)" data-url="${commentImgUrl}"/>
                                </div>
                            </c:if>
                        </c:forEach>
                        <div class="clear"></div>
                        <div class="after_img">
                            <!--do start-->
                            <div class="do"><a href="javascript:void(0)" class="shouqi"><span><img src="${path}/STATIC/image/shouqi.png" width="8" height="11" /></span>收起</a>
                                <a href="#" target="_blank" class="yuantu"><span><img src="${path}/STATIC/image/fangda.png" width="11" height="11"/></span>原图</a></div>
                            <!--do end-->
                            <img src="" class="fd_img" />
                        </div>
                    </div>
                </c:if>
            </td>
        </tr>
        <tr class="submit-btn">
            <td></td>
            <td class="td-btn">
                <input type="button" class="btn-save" value="返回" onclick="javascript :history.back(-1);"/>
                <input type="button" class="btn-publish" value="删除" onclick="deleteComment()"/>
            </td>
        </tr>
        </tbody>
    </table>
</div>
</body>
</html>
