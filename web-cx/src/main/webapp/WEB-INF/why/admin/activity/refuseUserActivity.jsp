<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setLocale value="zh_CN"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/html">
<head>
    <title>拒绝理由</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <!--文本编辑框 end-->
    <!-- dialog start -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>

    <script type="text/javascript">

        seajs.config({
            alias: {
                "jquery": "${path}/STATIC/js/dialog/lib/jquery-1.10.2.js"
            }
        });
        seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });
        var mdialog;
        window.console = window.console || {log:function () {}}
        seajs.use(['jquery'], function ($) {
            $(function () {
                var dialog = parent.dialog.get(window);
                mdialog = dialog;
                $(".btn-publish").on("click", function(){
                    var dataStr = ''
                    var validCount =  '';
                    var valData = {"dataStr": "11", "validCount": "11"};
                    $.post("${path}/activity/refuseUserActivity.do", $("#activityForm").serialize(),function (data) {
                        if (data == 'success') {
                            dialogAlert("提示","未通过审核成功",function () {
                                dialog.close(valData).remove();
                            });
                        } else {
                            dialogAlert("提示","未通过审核成功失败:" + data);
                        }
                    });


                });
                /*点击取消按钮，关闭登录框*/
                $(".btn-save").on("click", function(){
                    dialog.close().remove();
                });
            });
        });


    </script>

</head>
<body>
<form action="" id="activityForm" name="activityForm" method="post">
<input type="hidden" name="activityId" id="activityId" value="${activityId}" />
<!-- 正中间panel -->
<div class="main-publish">
            <table class="form-table" width="100%">
                <tbody>
                                    <tr><td >未通过该活动审核的原因是：</td></tr>
                                    <tr>

                                        <td class="yd_numlist yd_numlist_bg" >
                                            <input type="checkbox" name="reason" value="主题色情暴力">主题色情暴力<br>
                                            <input type="checkbox" name="reason" value="内容含有敏感词汇">内容含有敏感词汇<br>
                                            <input type="checkbox" name="reason" value="图片像素过低">图片像素过低<br>
                                            <input type="checkbox" name="reason" value="政策问题">政策问题<br>
                                            备注:<br>
                                            <textarea rows="5" cols="50" name="reason"></textarea>
                                        </td>
                                    </tr>
                            <tr class="submit-btn">
                                <td class="td-btn">
                                    <input type="button" class="btn-publish" value="确定"/>
                                    <input type="button" class="btn-save" value="返回"/>

                                </td>
                            </tr>
                </tbody>
                        </table>
    </div>
</form>
<script type="text/javascript">
    //提交表单
    function formSub(formName){
        $(formName).submit();
    }
</script>
</body>
</html>
