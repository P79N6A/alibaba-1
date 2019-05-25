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

        function submitForm(){
            var replyContent = $("#replyContent").val().trim();
            if('' == replyContent || undefined == replyContent) {
                dialogAlert("提示","请填写回复内容",function(){
                });
                return;
            }
            $.post("${path}/feedInformation/feedBackReply.do", $("#feedBackReply").serialize(),
                    function(data) {
                        if(data != null && data == 'success'){
                            dialogAlert("提示","回复成功！",function(){
                                parent.location.href="${path}/feedInformation/feedIndex.do";
                            });

                        } else if(data != null && data == 'ADVERT_NOT_INSERT'){
                            dialogAlert("提示","回复失败！",function(){
                                parent.location.href="${path}/feedInformation/feedIndex.do";
                            });
                    }
            });




        }
    </script>

</head>
<body style="background: none;">
<%--360下无法取得session--%>
<form id="feedBackReply">

    <input type="hidden"  name="feedBackId" value="${feedBackId}" />
        <table>
            <tr align="left" colspan="2" style=" font-size: 14px; display: block; margin:10px 0px;">
                <td>回复:</td></tr>
            <tr colspan="2">
               <td><textarea name="replyContent" id="replyContent" style="width:485px;height: 250px; line-height: 20px; font-family: Microsoft YaHei, PingFangSC-Regular, SimHei; resize: none; border: solid 1px #9c9c9c; border-radius: 5px; padding: 5px;" maxlength="200"></textarea></td>
            </tr>
            <tr>
                <td class="td-btn" align="center" colspan="2" style="margin-top: 30px;display: block;">
                <input class="btn-save" type="button" value="确定" onclick="submitForm();" style="width: 100px;  background:#ED3838;height: 40px; line-height: 40px; overflow: hidden; text-align: center; border: none; border-radius: 5px;-webkit-border-radius: 5px; color: #ffffff; outline: none; margin: 0 10px;"/>
                <input class="btn-cancel" type="button" value="取消"  style="width: 100px; height: 40px; line-height: 40px; overflow: hidden; background: #5DA7FD; text-align: center; border: none; border-radius: 5px;-webkit-border-radius: 5px; color: #ffffff; outline: none; margin: 0 10px;"/>
            </td>
            </tr>
        </table>
    </div>
</form>

</body>
</html>




