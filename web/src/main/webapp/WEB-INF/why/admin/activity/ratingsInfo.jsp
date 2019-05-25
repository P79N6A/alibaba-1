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

    <script type="text/javascript">



        function editRatingsInfo() {
            var activityId=$("#activityId").val();
            var type=$("#type").val();
            var ratingsInfo=$("input[name='ratingsInfo']:checked").val();
            if(ratingsInfo==undefined){
                dialogAlert("提示", "请至少选择一个评级项", function () {
                });
                return;
            }
            $.post('${path}/activity/editRatingsInfo.do', {type:type,activityId: activityId,ratingsInfo:ratingsInfo}, function (result) {
                if ("success" == result) {
                    dialogAlert("提示", "评级成功", function () {
                        if(type!=undefined&&type=='activity'){
                            parent.location.href = '${path}/activity/activityIndex.do?activityState=6';
                        }else if(type!=undefined&&type=='editorial')
                            parent.location.href = '${path}/activityEditorial/activityEditorialIndex.do?activityState=6';
                       // dialog.close().remove();
                    });
                    return;
                } else {
                    dialogAlert("提示", "评级失败", function () {
                    });
                    return;
                }
            });
        }
        $(function () {
            /*点击取消按钮，关闭登录框*/
            $(".btn-publish").on("click", function () {
                parent.location.href = '${path}/activity/activityIndex.do?activityState=6';


            });


        });


    </script>
</head>
<body class="rbody">
<input type="hidden" id="activityId" name="activityId" value="${activityId}"/>
<input type="hidden" id="type" name="type" value="${type}"/>
<!-- 正中间panel -->
<div id="content">
    <div class="content">
        <div class="con-box-blp">
            <form id="tag_form" action="" method="post">
                <div class="con-box-tlp">
                    <div class="form-box">
                        <table class="form-table">
                            <tbody>
                            <tr style="padding-left:130px;display:block; margin-top:20px;">
                                <c:forEach items="${dictList}" var="dict">

                                    <td class="td-input" style="display:inline-block;width:80px; font-size: 13px;">
                                        <input type="radio" name="ratingsInfo" style="display:inline; width:15px; height: 15px; margin-right:3px; cursor: pointer; vertical-align: middle;"

                                               <c:if test="${ratingsInfo eq dict.dictId}">
                                                 checked
                                                </c:if>
                                               value="${dict.dictId}" >${dict.dictName}</td>
                                </c:forEach>

                            </tr>
                            <tr class="td-btn" style="margin-top:15px;">
                                <td colspan="2"><input type="button" value="保存" onclick="editRatingsInfo()" class="btn-save"
                                                       style="margin-left: 155px;margin-top: 20px;"/>
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