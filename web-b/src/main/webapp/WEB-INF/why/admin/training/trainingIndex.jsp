<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>

    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
</head>
<body>

<div class="site">
    <em>您现在所在的位置：</em>培训管理 &gt; 培训视频列表
</div>
<form action="${path}/training/trainingIndex.do" id="inheritorForm" method="post">
    <div class="search">
        <div class="search menage">
            <div class="menage-box">
                <a class="btn-add">新增培训视频</a>
            </div>
        </div>
    </div>

    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th>ID</th>
                <th class="title">视频标题</th>
                <th>主讲人</th>
                <th>创建时间</th>
                <th>管理</th>
            </tr>
            </thead>
            <tbody>
            <c:if test="${fn:length(trainingList) gt 0}">
                <tbody>
                <%int i=0;%>
                <c:forEach items="${trainingList}" var="trainingList">
                    <%i++;%>
                    <tr>
                        <td><%=i%></td>
                        <td class="title">
                            <a href="javascript:;">${trainingList.trainingTitle}</a>
                        </td>
                        <td>
                                ${trainingList.speakerName}
                        </td>
                        <td>
                            <c:if test="${not empty trainingList.createTime}">
                                <fmt:formatDate value="${trainingList.createTime}"  pattern="yyyy-MM-dd HH:mm" />
                            </c:if>
                        </td>
                        <td>

                                <a trainingId="${trainingList.trainingId}" class="inheritor-edit">编辑</a> |

                                <a trainingId="${trainingList.trainingId}" class="inheritor-delete">删除</a>

                        </td>
                    </tr>
                </c:forEach>

                </tbody>
            </c:if>
            <c:if test="${empty trainingList}">
                <tr>
                    <td colspan="8"> <h4 style="color:#DC590C">暂无数据!</h4></td>
                </tr>
            </c:if>
            </tbody>
        </table>
        <%--<c:if test="${not empty trainingList}">--%>
            <%--<input type="hidden" id="page" name="page" value="${page.page}" />--%>
            <%--<div id="kkpager"></div>--%>
        <%--</c:if>--%>
    </div>
</form>
<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
<script type="text/javascript">
    seajs.config({
        alias: {
            "jquery": "jquery-1.10.2.js"
        }
    });

    seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
        window.dialog = dialog;
    });

    window.console = window.console || {log:function () {}};

    seajs.use(['jquery'], function ($) {
        // 新增培训视频
        $('.btn-add').on('click', function () {
            dialog({
                url: '${path}/training/preTraining.do',
                title: '新增培训视频',
                width: 900,
                height: 800,
                fixed: true
            }).showModal();
            return false;
        });

        //培训视频
        $('.inheritor-edit').on('click', function () {
            var trainingId = $(this).attr("trainingId");
            dialog({
                url: '${path}/training/preTraining.do?trainingId='+trainingId,
                title: '编辑培训视频',
                width: 900,
                height: 800,
                fixed: true
            }).showModal();
            return false;
        });

        $(".inheritor-delete").on("click", function(){
            var trainingId = $(this).attr("trainingId");
            var name = $(this).parent().siblings(".title").find("a").text();
            var html = "您确定要删除" + name + "吗？";
            dialogConfirm("提示", html, function(){
                $.post("${path}/training/editInheritor.do",{trainingId:trainingId},function(data) {
                    if (data == 'success') {
                        window.location.href="${path}/training/trainingIndex.do?";
                    }
                });
            })
        });

    });

    $(function(){
        kkpager.generPageHtml({
            pno : '${page.page}',
            total : '${page.countPage}',
            totalRecords :  '${page.total}',
            mode : 'click',//默认值是link，可选link或者click
            click : function(n){
                this.selectPage(n);
                $("#page").val(n);
                formSub('#inheritorForm');
                return false;
            }
        });
    });

    function formSub(formName){
        $(formName).submit();
    }
</script>
</body>
</html>