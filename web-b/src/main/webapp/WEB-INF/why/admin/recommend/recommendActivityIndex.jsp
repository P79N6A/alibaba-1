<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>活动列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>

    <script type="text/javascript">
        $(function () {
            $("input").focus();
            kkpager.generPageHtml({
                pno: '${page.page}',
                total: '${page.countPage}',
                totalRecords: '${page.total}',
                mode: 'click',//默认值是link，可选link或者click
                click: function (n) {
                    this.selectPage(n);
                    $("#page").val(n);
                    formSub('#activityForm');
                    return false;
                }
            });
        });
        //提交表单
        function formSub(formName) {
            var activityName = $('#activityName').val();
            if (activityName != undefined && activityName == '输入活动名称') {
                $('#activityName').val("");
            }
            $(formName).submit();
        }
        /**
         * 取消推荐活动
         */
        function cancelRecommendActivity(recommendId) {
            var html = "您确定要取消推荐该活动吗？";
            dialogConfirm("提示", html, function () {
                $.post("${path}/recommendRelate/cancelRecommendActivity.do", {"recommendId": recommendId}, function (data) {
                    if (data != null && data == 'success') {
                        window.location.href = "${path}/recommendRelate/recommendIndex.do";
                    } else {
                        dialogConfirm("提示", "活动信息异常", function () {
                            window.location.href = "${path}/recommendRelate/recommendIndex.do";
                        })
                    }
                });
            })
        }
        /**
         * 推荐活动
         */
        function topActivity(activityId) {
            var html = "您确定要置顶该活动吗？";
            dialogConfirm("提示", html, function () {
                $.post("${path}/recommendRelate/topActivity.do", {
                    "activityId": activityId,
                    "activityType": activityId
                }, function (data) {
                    if (data != null && data == 'success') {
                        window.location.href = "${path}/recommendRelate/recommendIndex.do";
                    } else {
                        dialogConfirm("提示", "活动已被置顶", function () {
                            window.location.href = "${path}/recommendRelate/recommendIndex.do";
                        })
                    }
                });
            })
        }
        /**
         * 取消推荐活动
         */
        function cancelTopActivity(recommendId) {
            var html = "您确定要取消置顶该活动吗？";
            dialogConfirm("提示", html, function () {
                $.post("${path}/recommendRelate/cancelRecommendActivity.do", {"recommendId": recommendId}, function (data) {
                    if (data != null && data == 'success') {
                        window.location.href = "${path}/recommendRelate/recommendIndex.do";
                    } else {
                        dialogConfirm("提示", "活动信息异常", function () {
                            window.location.href = "${path}/recommendRelate/recommendIndex.do";
                        })
                    }
                });
            })
        }

    </script>
</head>
<body>
<form id="activityForm" action="${path}/recommendRelate/recommendIndex.do" method="post">

    <div class="site">
        <em>您现在所在的位置：</em>推荐管理 &gt; app端推荐&gt;首页栏目推荐

    </div>
    <div class="search">
        <div class="search-box">
            <i></i><input type="text" id="activityName" name="activityName" value="${activity.activityName}"
                          data-val="输入活动名称" class="input-text"/>
        </div>
        <div class="select-btn">
            <input type="button" onclick="$('#page').val(1);formSub('#activityForm');" value="搜索"/>
        </div>
    </div>
    </div>
    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th>ID</th>
                <th class="title">活动名称</th>
                <th>开始时间</th>
                <th>结束时间</th>
                <th>管理</th>
            </tr>
            </thead>
            <tbody>
            <%int i = 0;%>
            <c:forEach items="${recommendList}" var="avct" varStatus="status">
                <%i++;%>
                <tr>
                    <td><%=i%>
                    </td>
                    <td class="title">
                        <a target="_blank" title="${avct.attachList[0].activityName}"
                           href="${path}/frontActivity/frontActivityDetail.do?activityId=${avct.attachList[0].activityId}">${avct.attachList[0].activityName}</a>
                    </td>
                    <td>
                            ${avct.activityStartTime}
                    </td>
                    <td>
                            ${avct.activityEndTime}
                    </td>
                    <td>
                        <%if (apprecommendRelateButton) {%>

                        <a onclick="cancelRecommendActivity('${avct.recommendId}')">取消推荐</a> |

                        <c:if test="${not empty avct.relatedId}">
                            <a onclick="cancelTopActivity('${avct.relatedId}')">取消置顶</a>
                        </c:if>
                        <c:if test="${ empty avct.relatedId}">
                            <a onclick="topActivity('${avct.attachList[0].activityId}')">置顶</a>
                        </c:if>
                        <%}%>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty recommendList}">
                <tr>
                    <td colspan="8"><h4 style="color:#DC590C">暂无数据!</h4></td>
                </tr>
            </c:if>
            </tbody>
        </table>
        <c:if test="${not empty recommendList[0].attachList}">
            <input type="hidden" id="page" name="page" value="${page.page}"/>
            <div id="kkpager"></div>
        </c:if>
    </div>
</form>
</body>
</html>