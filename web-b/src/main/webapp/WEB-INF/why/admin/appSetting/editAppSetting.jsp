<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>标签管理</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <input type="hidden" id="saveId" name="saveId" value="${saveId}"/>
    <script type="text/javascript">

        $(function () {
            var dialog = parent.dialog.get(window);
        });

        function saveForm() {
            var saveId=$("#saveId").val();
            if(saveId == 'hotDays'){
                var hotWords = $("#hotDays").val();
            }else{
                var hotWords = $("#hotKeywords").val();
            }
            $.post('${path}/appSetting/saveSetting.do', {hotWords: hotWords,saveId:saveId}, function (result) {
                if ("success" == result) {
                    dialogAlert("提示", "修改成功", function () {
                        parent.location.href = '${path}/appSetting/appSettingIndex.do';
                        dialog.close().remove();
                    });
                    return;
                } else {
                    dialogAlert("提示", "修改失败", function () {
                    });
                    return;
                }
            });
        }
        $(function () {
            /*点击取消按钮，关闭登录框*/
            $(".btn-publish").on("click", function () {
                parent.location.href = '${path}/appSetting/appSettingIndex.do';
                dialog.close().remove();

            });


        });


    </script>
</head>
<body class="rbody">
<!-- 正中间panel -->
<div id="content">
    <div class="content">
        <div class="con-box-blp">
            <form id="tag_form" action="" method="post">
                <div class="con-box-tlp">
                    <div class="form-box">
                        <table class="form-table">
                            <tbody>
                            <tr>

                                <c:if test="${saveId == 'hotDays'}">
                                    <td class="td-title"><span class="td-prompt">*</span>热活动时间天数：</td>
                                    <td class="td-input">
                                        <input type="text" id="hotDays" class="input-text w220"
                                               value="<c:forEach items='${hotWords}' var='c'>${c}</c:forEach>"
                                               onkeyup="if(isNaN(value))execCommand('undo')"/>
                                    </td>
                                </c:if>
                                <c:if test="${saveId!='hotDays'}">
                                    <td class="td-input">
                                        <textarea style="width: 360px;height: 200px;overflow: hidden;resize: none;"
                                                  id="hotKeywords" class="input-text w220"><c:forEach
                                                items="${hotWords}" var="c">${c},</c:forEach></textarea>
                                        <span class="upload-tip" style="color:#ff0000">关键词请以英文逗号分隔</span>
                                    </td>
                                </c:if>
                            </tr>
                            <tr class="td-btn">
                                <td colspan="2"><input type="button" value="保存" onclick="saveForm()" class="btn-save"
                                                       style="margin-left: 135px;margin-top: 20px;"/>
                                    <input type="button" value="返回" class="btn-publish btn-cancel"/></td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

</body>
</html>