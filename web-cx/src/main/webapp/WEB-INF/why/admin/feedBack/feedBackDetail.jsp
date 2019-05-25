<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
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

        seajs.use(['jquery'], function ($) {
            $(function () {
                var dialog = parent.dialog.get(window);
                /*点击取消按钮，关闭登录框*/
                $(".btn-cancel").on("click", function(){
                    dialog.close().remove();
                });
            });
        });



    </script>

</head>
<body style="background: none;">
<%--360下无法取得session--%>
<form id="feedBackReply">

    <input type="hidden"  name="feedBackId" value="${feedBackId}" />
        <table>
            <tr align="left" colspan="2" style=" font-size: 14px; display: block; margin:10px 0px;">
                <td><h1>查看回复内容:</h1></td></tr>
            <tr colspan="2">
               <td><div class="reply-content">${replyContent}</div></td>
            </tr>

        </table>
    </div>
</form>

</body>
</html>




