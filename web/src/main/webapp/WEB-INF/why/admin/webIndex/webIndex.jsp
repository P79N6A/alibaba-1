<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>

<head>
    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>
    <link rel="Stylesheet" type="text/css" href="${path}/STATIC/css/DialogBySHF.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/DialogBySHF.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <script type="text/javascript">

    </script>
</head>

<body>
<div class="site">
    <em>您现在所在的位置：</em> 推荐管理 &gt; web端推荐 &gt; 首页栏目推荐
</div>
<div class="site-title">首页栏目推荐</div>
<div class="main-publish">
    <table width="100%" class="form-table">
        <tr>
            <td width="100" class="td-title"><span class="red">*</span>最新活动：</td>
            <td class="td-input" id="newActivitysLabel">
                <input type="text" id="newestActivity" name="newestActivity"  class="input-text w510" value=""
                       maxlength="255"/>
                <a style="color: red">请输入四个活动ID，请以英文逗号分隔。</a>
            </td>
        </tr>
        <tr>
            <td width="100" class="td-title"></td>
            <td class="td-btn">
                <div class="room-order-info info2" style="position: relative;">
                    <input style="width: 150px" class="btn-save" type="button" onclick="save('newestActivity')"
                           value="保存"/>

                </div>
            </td>
        </tr>
        <tr>
            <td width="100" class="td-title"><span class="red">*</span>周末去哪儿：</td>
            <td class="td-input" id="weekEndActivityLabel">
                <input type="text" id="weekEndActivity" name="weekEndActivity" class="input-text w510" value=""
                       maxlength="255"/>
                <a style="color: red">请输入四个活动ID，请以英文逗号分隔。</a>
            </td>
        </tr>
        <tr>
            <td width="100" class="td-title"></td>
            <td class="td-btn">
                <div class="room-order-info info2" style="position: relative;">
                    <input style="width: 150px" class="btn-save" type="button" onclick="save('weekEndActivity')"
                           value="保存"/>
                </div>
            </td>
        </tr>
    </table>
</div>
<script type="text/javascript">
    function save(Key) {
        var saveIds = $("#" + Key).val();
        //保存首页信息
        $.post("${path}/webIndex/saveToRedis.do", {
            "Ids": saveIds,
            "Key": Key
        }, function (data) {
            if (data == 'success') {
                dialogAlert('系统提示', '保存成功', function () {
                    window.location = "${path}/webIndex/webIndex.do";
                });
            } else if (data == 'repeat') {

            } else {
                dialogAlert('系统提示', '保存失败');
            }
        });
    }
</script>
</body>
</html>