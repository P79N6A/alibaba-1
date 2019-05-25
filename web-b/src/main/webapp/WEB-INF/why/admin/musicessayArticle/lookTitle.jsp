<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>查看</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>

</head>
<%   request.setAttribute("vEnter", "\r\n");   %>
<body style="background: none;">
<form id="roleForm">
    <div class="main-publish tag-add">
            <table width="100%" class="form-table">
                <tr>
                    <td class="td-title" style="text-align:center;" width="20%">${fn:replace(EntityArticle.articleText, vEnter, "<br/>")}</td>
                </tr>
            </table>
    </div>
</form>

<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<script type="text/javascript">
    $(function(){
        selectModel();
    });
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
        $(function () {
            var dialog = parent.dialog.get(window);
        });
    });

    function dialogTypeSaveDraft(title, content, fn){
        var d = parent.dialog({
            width:400,
            title:title,
            content:content,
            fixed: true,
            okValue: '确 定',
            ok: function () {
                if(fn)  fn();
            }
        });
        d.showModal();
    }
</script>
</body>
</html>