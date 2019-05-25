<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>

<head>
    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>

    <script type="text/javascript" src="${path}/STATIC/js/admin/activity/UploadActivityFile.js"></script>
    <%--<script type="text/javascript" src="${path}/STATIC/js/admin/activity/getActivityFile.js"></script>--%>
    <script type="text/javascript" src="${path}/STATIC/js/area.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/area-venues-admin.js?version=20151125"></script>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <!--文本编辑框 end-->
    <!-- dialog start -->
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/ckeditor/sample.js"></script>
    <script type="text/javascript" src="${path}/STATIC/js/admin/activity/addActivity.js?version=20151126"></script>
    <script type="text/javascript">


        //主题标签
        $(function(){
            $.post("../tag/getChildTagByType.do?code=ACTIVITY_TYPE", function(data) {
                var list = eval(data);
                var tagHtml = '';
                var tagIds = $("#activityType").val();
                var ids = '';
                if (tagIds.length > 0) {
                    ids = tagIds.substring(0, tagIds.length - 1).split(",");
                }
                for (var i = 0; i < list.length; i++) {
                    var obj = list[i];
                    var tagId = obj.tagId;
                    var tagName = obj.tagName;
                    var result = false;
                    if (ids != '') {
                        for (var j = 0; j <ids.length; j++) {
                            if (list[i].tagId == ids[j]) {
                                result = true;
                                break;
                            }
                        }
                    }
                    var cl = '';
                    if (result) {
                        cl = 'class="cur"';
                    }
                    tagHtml += '<a ' + cl + 'onclick="setActivityTag(\''
                    + tagId + '\',\'activityType\')">' + tagName
                    + '</a>';
                }
                $("#activityTypeLabel").html(tagHtml);
                tagSelect("activityTypeLabel");
            });
        });


        //选择关键字标签时，赋值
        function setActivityTag(value,id) {

            var tagIds = $("#"+id).val();
            if (tagIds != '') {
                var ids = tagIds.substring(0, tagIds.length - 1).split(",");
                var data = '', r = true;
                for (var i = 0; i < ids.length; i++) {
                    if (ids[i] == value) {
                        r = false;
                    } else {
                        data = data + ids[i] + ',';
                    }
                }
                if (r) {
                    data += value + ',';
                }
                $("#"+id).val(data);
            } else {
                $("#"+id).val(value + ",");
            }
        }


    </script>
</head>

<body >

<form action="${path}/recommend/cmsListRecommendTag.do" id="recommendForm" method="post">
    <div class="site">
        <em>您现在所在的位置：</em>app端推荐 &gt; 活动列表推荐
    </div>
    <div class="site-title">活动列表推荐</div>
    <input type="hidden" value="${sessionScope.user.userIsManger}" id="userIsManager"/>
    <div class="main-publish">
        <table width="100%" class="form-table">



            <tr>
                <td width="100" class="td-title"><h3>标签选择区：</h3></td>
                <td class="td-tag">


                </td>
            </tr>

            <tr>
                <td width="100" class="td-title"></td>
                <td class="td-tag">
                    <dl>

                        <input id="activityType" name="activityType"  style="position: absolute; left: -9999px;" type="hidden" value="${tagIds}"/>
                        <dd id="activityTypeLabel">
                        </dd>
                    </dl>


                </td>
            </tr>

            <tr>
                <td width="100" class="td-title"></td>
                <td class="td-btn">
                    <div class="room-order-info info2" style="position: relative;">
                        <input type="button" value="确定" class="btn-publish" onclick="document.forms[0].submit();"/>
                        <input type="button" value="返回" class="btn-save" onclick="javascript:history.back(-1)"/>
                    </div>
                </td>
            </tr>
        </table>
    </div>
</form>


</body>
</html>