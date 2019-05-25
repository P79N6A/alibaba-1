<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>活动列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <script type="text/javascript" src="${path}/STATIC/js/admin/inheritor/UploadCultureInheritorImg.js"></script>
</head>

<body style="background: none;">
<form id="inheritorForm">
    <div class="main-publish tag-add">
        <input type="hidden" id="sessionId" value="${pageContext.session.id}"/>
            <table width="100%" class="form-table">
                <tr>
                    <td class="td-title" width="20%">传承非遗：</td>
                    <td class="td-input">${inheritor.cultureName}</td>
                </tr>
                <tr>
                    <td class="td-title"><span class="red">*</span>姓名：</td>
                    <td class="td-input">${inheritor.inheritorName}</td>
                </tr>
                <tr>
                    <td class="td-title">性别：</td>
                    <td class="td-radio">
                        <c:if test="${inheritor.inheritorSex eq 1}">男</c:if>
                        <c:if test="${inheritor.inheritorSex eq 2}">女</c:if>
                    </td>
                </tr>
                <tr>
                    <td class="td-title">年龄：</td>
                    <td class="td-input">${inheritor.inheritorAge}</td>
                </tr>
                <tr>
                    <td class="td-title">民族：</td>
                    <td class="td-select">
                        <span id="nationSpan"></span>
                    </td>
                </tr>
                <tr>
                    <td class="td-title">传承人头像：</td>
                    <td class="td-upload">
                        <table>
                            <tr>
                                <td id="tuserPictureLabel">
                                    <input type="hidden" id="inheritorHeadImgUrl" value="${inheritor.inheritorHeadImgUrl}">
                                    <div class="img-box">
                                        <div  id="imgHeadPrev" class="img"> </div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr class="td-line">
                    <td class="td-title">传承人简介：</td>
                    <td class="td-input">
                        <textarea rows="6" style="width: 500px;resize: none" readonly>${inheritor.inheritorRemark}</textarea>
                    </td>
                </tr>
                <tr>
                    <td class="td-title"></td>
                    <td class="td-btn">
                        <input class="btn-cancel" type="button" value="关闭"/>
                    </td>
                </tr>
            </table>
    </div>
</form>

<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<script type="text/javascript">
    $(function(){
        $.post("${path}/inheritor/queryDictNameByDictId.do",{dictId:'${inheritor.inheritorNation}'},function(data){
            $("#nationSpan").html(data.dictName);
        });
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
            /*点击取消按钮，关闭登录框*/
            $(".btn-cancel").on("click", function(){
                dialog.close().remove();
            });
        });
    });
</script>
</body>
</html>