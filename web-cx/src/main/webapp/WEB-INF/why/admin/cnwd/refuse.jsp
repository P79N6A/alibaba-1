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
                	var  refusalReason=$("#refusalReason").val();
                	if(refusalReason==undefined||refusalReason==''){
                		alert("请输入拒绝理由");
                	}else{
                    $.post("${path}/cnwdEntryform/check.do", $("#form").serialize(),function (data) {
                        if (data == 'success') {
                        	   alert("提交成功")
                                dialog.close().remove();
                        }else if(data!=null && data=='login'){
                      		 alert("请先登录")
                     			window.location.href = "${path}/login.do";
                        }else{
                          alert("保存失败")
                         }
                    });
                	}

                });
                /*点击取消按钮，关闭登录框*/
                $(".btn-save").on("click", function(){
                    dialog.close().remove();
                });
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

</head>
<body>
<form action="" id="form" name="form" method="post">
<input type="hidden" name="entryId" id="entryId" value="${entryId}" />
<input type="hidden" name="status" id="status" value="${status}" />
            <table class="form-table" >
                <tbody>
                     <tr><td >未通过原因：</td></tr>
                                    <tr>
                                        <td class="yd_numlist yd_numlist_bg" >
                                            <textarea rows="5" cols="50" name="refusalReason" id="refusalReason"></textarea>
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
</form>
<script type="text/javascript">
    //提交表单
    function formSub(formName){
        $(formName).submit();
    }
</script>
</body>
</html>
