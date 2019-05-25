<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

    <title>活动列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
</head>
<body>

<div class="site">
    <em>您现在所在的位置：</em>敏感词管理 &gt;敏感词列表
</div>
<form  action="${path}/sensitiveWords/sensitiveWordsIndex.do" id="indexForm"  method="post">

    <div class="search">

        <div class="search-box">
           <i></i><input type="text" id="sensitiveWords" value="${cmsSensitiveWords.sensitiveWords}" name ="sensitiveWords" class="input-text"  data-val="输入敏感词" />
        </div>

        <div class="select-btn">
            <input type="button" value="搜索" onclick="pageSubmit()" style="border: none; "/>
        </div>

        <%if(sensitiveWordsPreAddButton){%>
            <div class="search-total">
                <div class="select-btn">
                    <input class="btn-add-tag" type="button" value="添加"/>
                </div>
            </div>
        <%}%>

    </div>



    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th >ID</th>
                <th class="title">敏感词</th>
                <th class="venue">状态</th>
                <th >操作人</th>
                <th >操作时间</th>
                <th >管理</th>
            </tr>
            </thead>
            <tbody>
            <%int i=0;%>
            <c:forEach items="${list}" var="cmsSensitiveWords">
                <% i++;%>
                <tr>
                    <td > <%= i%></td>
                    <td class="title">${cmsSensitiveWords.sensitiveWords}</td>
                    <td class="venue">
                        <c:choose>
                            <c:when test="${cmsSensitiveWords.wordsStatus==1}">
                                启用
                            </c:when>
                            <c:otherwise>
                                冻结
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>${cmsSensitiveWords.userAccount}</td>
                    <td>
                        <fmt:formatDate value="${cmsSensitiveWords.updateTime}"  pattern="yyyy-MM-dd" />
                    </td>

                    <td width="200" class="td-editing">

                        <c:if test="${cmsSensitiveWords.wordsStatus == 1}">
                            <%if(sensitiveWordsFreezeButton){%>
                                <a href="javascript:delWorld('${cmsSensitiveWords.sid}');">冻结</a> <%if(sensitiveWordsPreEditButton){%>|<%}%>
                            <%}%>
                        </c:if>
                        <c:if test="${cmsSensitiveWords.wordsStatus != 1}">
                            <%if(sensitiveWordsFreezeButton){%>
                                <a href="javascript:actWorld('${cmsSensitiveWords.sid}');" >激活</a> <%if(sensitiveWordsPreEditButton){%>|<%}%>
                            <%}%>
                        </c:if>
                        <%if(sensitiveWordsPreEditButton){%>
                            <a  href="javascript:;" data-id="${cmsSensitiveWords.sid}" class="tag-edit">编辑</a>
                        <%}%>

                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty list}">
                <tr>
                    <td colspan="7"> <h4 style="color:#DC590C">暂无数据!</h4></td>
                </tr>
            </c:if>
            </tbody>
        </table>
        <c:if test="${not empty list}">
            <input type="hidden" id="page" name="page" value="${page.page}" />
            <div id="kkpager" ></div>
        </c:if>
    </div>

</form>
<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
<script type="text/javascript">
    //删除
    function delWorld(id){
        dialogConfirm("冻结敏感词", "您确定要冻结敏感词吗？", removeParent);
        function removeParent() {
            location.href='${path}/sensitiveWords/deleteSensitiveWords.do?sid=' + id + '&wordsStatus=2&'+ $('#indexForm').serialize();
        }
    }

    function actWorld(id){
        dialogConfirm("激活敏感词", "您确定要激活敏感词吗？", removeParent);
        function removeParent() {
            location.href='${path}/sensitiveWords/deleteSensitiveWords.do?sid=' + id + '&wordsStatus=1&'+ $('#indexForm').serialize();
        }
    }
    ('确认提示框','确定要激活该敏感词吗？','${path}/sensitiveWords/deleteSensitiveWords.do?sid=${cmsSensitiveWords.sid}'+'&wordsStatus=1&'+ $('#indexForm').serialize())
    $(function(){
        kkpager.generPageHtml({
            pno : '${page.page}',
            total : '${page.countPage}',
            totalRecords :  '${page.total}',
            mode : 'click',//默认值是link，可选link或者click
            click : function(n){
                this.selectPage(n);
                $("#page").val(n);
                pageSubmit();
                //$("#indexForm").submit();
                return false;
            }
        });
    });

    //var pageSize = ${page.countPage};
    function pageSubmit(){
        if($("#sensitiveWords").val()=="输入敏感词"){
            $("#sensitiveWords").val("");
        }
        $("#indexForm").submit();
        /* if(page <= pageSize){
         $("#page").val(page);
         $("#indexForm").submit();
         }else{
         //alert("跳转页数不能超过总页数");
         }*/
    }

    //
    seajs.config({
        alias: {
            "jquery": "jquery-1.10.2.js"
        }
    });
    seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
        window.dialog = dialog;
    });

    window.console = window.console || {
        log:function () {

        }
    }
    seajs.use(['jquery'], function ($) {
        $(".btn-add-tag").on('click', function () {
            dialog({
                url: '${path}/sensitiveWords/preAddSensitiveWords.do',
                title: '添加敏感词',
                width: 560,
                //height:400,
                fixed: true
            }).showModal();
            return false;
        });


        $(".tag-edit").on('click', function () {
            var id = $(this).attr("data-id");
            dialog({
                url: '${path}/sensitiveWords/preEditSensitiveWords.do?sid='+id,
                title: '编辑敏感词',
                width: 560,
                //height:400,
                fixed: true
            }).showModal();
            return false;
        });

    });



</script>
</body>
</html>