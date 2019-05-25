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

    <input type="hidden" id="saveName" name="saveName" value="${saveName}"/>
    <script type="text/javascript">
        var saveId = $("#saveName").val();
        var saveSelected = "";
        $(function () {
            var dialog = parent.dialog.get(window);
            loadForm();
            loadArea();

        });
        function loadForm() {
            $.post('${path}/appSetting/getSetting.do', {saveId: saveId}, function (result) {
                saveSelected=result;
            });

        }
        function loadArea() {
            $.post("${path}/appTag/appActivityTagByType.do", function (data) {
                if (data.status == 0) {
                    $.each(data.data3, function (i, dom) {
                        if (saveSelected.indexOf(dom.areaCode) != -1) {
                            $("#userAreaCheck").append(" <label > <input checked name ='area'  value='" + dom.areaCode + "' type=\"checkbox\"/><em>" + dom.areaCode.split(":")[1] + "</em></label>");
                        }else{
                            $("#userAreaCheck").append(" <label > <input name ='area'  value='" + dom.areaCode + "' type=\"checkbox\"/><em>" + dom.areaCode.split(":")[1]  + "</em></label>");
                        }
                    });
                    $("#userAreaCheck").append("<label class=\"red\">（此处可多选）</label>");

                }
            }, "json");

        }
        function saveForm() {
            var saveName = $("#saveName").val();
            var areaIds = new Array();
            $('input[name="area"]:checked').each(function () {
                areaIds.push($(this).val());
            });
            var hotWords = areaIds.join(',');
            $.post('${path}/appSetting/saveSetting.do', {hotWords: hotWords, saveId: saveName}, function (result) {
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
    <script type="text/javascript">

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
                                <div><span class="red">*</span>热门区域：</div>
                                <div>
                                    <td class="td-fees" id="userAreaCheck">
                                    </td>
                                </div>
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