<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

    <title>场馆评论列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file ="/WEB-INF/why/common/limit.jsp"%>

    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
</head>
<body>

<div class="site">
    <em>您现在所在的位置：</em>场馆管理 &gt; 场馆信息管理&gt; 场馆评论列表
</div>
<form id="commentVenueIndexForm" method="post" action="${path}/comment/commentVenueIndex.do">
<div class="search">
    <div class="search-box">
        <i></i><input id="commentRemark" name="commentRemark" class="input-text" data-val="输入评论内容关键词" type="text"
             value="<c:choose><c:when test="${not empty comment.commentRemark}">${comment.commentRemark}</c:when><c:otherwise>输入评论内容关键词</c:otherwise></c:choose>"/>
    </div>
    <div class="select-box w135">
        <input type="hidden" value="${comment.commentIsTop}" name="commentIsTop" id="commentIsTop"/>
        <div class="select-text" data-value="">
            <c:choose>
                <c:when test="${comment.commentIsTop == 1}">
                    已置顶
                </c:when>
                <c:when test="${comment.commentIsTop == 0}">
                    未置顶
                </c:when>
                <c:otherwise>
                    全部状态
                </c:otherwise>
            </c:choose>
        </div>
        <ul class="select-option">
            <li data-option="">全部状态</li>
            <li data-option="1">已置顶</li>
            <li data-option="0">未置顶</li>
        </ul>
    </div>
    <div class="form-table" style="float: left;"><div class="td-time" style="margin-top: 0px;">
	    <div class="start w240" style="margin-left: 8px;">
	        <span class="text">开始日期</span>
	        <input type="hidden" id="startDateHidden"/>
	        <input type="text" id="commentStartTime" name="commentStartTime" value="${comment.commentStartTime}" readonly/>
	        <i class="data-btn start-btn"></i>
	    </div>
    	<span class="txt" style="line-height: 42px;">至</span>
	    <div class="end w240">
	        <span class="text">结束日期</span>
	        <input type="hidden" id="endDateHidden"/>
	        <input type="text" id="commentEndTime" name="commentEndTime" value="${comment.commentEndTime}" readonly/>
	        <i class="data-btn end-btn"></i>
	    </div>
	</div></div>
    <input type="hidden" name="commentRkId" value="${comment.commentRkId}"/>
    <div class="select-btn">
        <input type="button" value="搜索" onclick="$('#page').val(1);formSub('#commentVenueIndexForm')"/>
    </div>
</div>
<div class="main-content">
    <table width="100%">
        <thead>
        <tr>
            <th>ID</th>
            <th class="title" width="75%">评论内容</th>
            <th>评论人</th>
            <th>评论时间</th>
            <th width="200">管理</th>
        </tr>
        </thead>
        <c:if test="${empty commentList}">
            <tr>
                <td colspan="5"> <h4 style="color:#DC590C">暂无数据!</h4></td>
            </tr>
        </c:if>
        <tbody>

        <c:forEach items="${commentList}" var="c" varStatus="s">
            <tr>
                <td>${s.index+1}</td>
                <td style="text-align: left" class="title"><c:if test="${c.commentIsTop == 1}"><i class="top-icon"></i></c:if>${c.commentRemark}</td>
                <td>${c.commentUserName}</td>
                <td><fmt:formatDate value="${c.commentTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                <td>
                    <%
                        if(commentDelButton){
                    %>
                        <a class="delete" commentId="${c.commentId}">删除</a> |
                    <%
                        }
                    %>

                    <c:if test="${c.commentIsTop == 0}">
                        <%
                            if(commentTopTrueButton){
                        %>
                             <a class="commentTop" commentId="${c.commentId}">置顶</a>
                        <%
                            }
                        %>
                    </c:if>
                    <c:if test="${c.commentIsTop == 1}">
                        <%
                            if(commentTopFalseButton){
                        %>
                            <a class="commentNotTop" commentId="${c.commentId}">取消置顶</a>
                        <%
                            }
                        %>
                    </c:if>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <c:if test="${not empty commentList}">
    <input type="hidden" id="page" name="page" value="${page.page}" />
    <div id="kkpager"></div>
    </c:if>
    <script type="text/javascript">
        $(function(){
        	selectModel();
        	
            // 删除
            $(".delete").on("click", function(){
                var commentId = $(this).attr("commentId");
                var html = "您确定要删除该评论吗？";
                dialogConfirm("提示", html, function(){
                    $.post("${path}/comment/deleteComment.do",{commentId:commentId},function(data) {
                        if (data == 'success') {
                            formSub("#commentVenueIndexForm");
                        }
                    });
                })
            });

            // 置顶
            $(".commentTop").on("click", function(){
                var commentId = $(this).attr("commentId");
                var html = "您确定将该评论置顶吗？";
                dialogConfirm("提示", html, function(){
                    $.post("${path}/comment/commentTopTrue.do",{commentId:commentId},function(data) {
                        if (data == 'success') {
                            formSub("#commentVenueIndexForm");
                        }
                    });
                })
            });

            // 取消置顶
            $(".commentNotTop").on("click", function(){
                var commentId = $(this).attr("commentId");
                var html = "您确定将该评论取消置顶吗？";
                dialogConfirm("提示", html, function(){
                    $.post("${path}/comment/commentTopFalse.do",{commentId:commentId},function(data) {
                        if (data == 'success') {
                            formSub("#commentVenueIndexForm");
                        }
                    });
                })
            });


            kkpager.generPageHtml({
                pno : '${page.page}',
                total : '${page.countPage}',
                totalRecords :  '${page.total}',
                mode : 'click',//默认值是link，可选link或者click
                click : function(n){
                    this.selectPage(n);
                    $("#page").val(n);
                    formSub('#commentVenueIndexForm');
                    return false;
                }
            });
        });

        //提交表单
        function formSub(formName){
            var commentRemark = $("#commentRemark").val();
            if(commentRemark == "输入评论内容关键词"){
                $("#commentRemark").val("");
            }
            $(formName).submit();
        }
        
      //** 日期控件
        $(function(){
            $(".start-btn").on("click", function(){
                WdatePicker({el:'startDateHidden',dateFmt:'yyyy-MM-dd',doubleCalendar:true,minDate:'',maxDate:'#F{$dp.$D(\'endDateHidden\')}',position:{left:-224,top:8},isShowClear:false,isShowOK:true,isShowToday:false,onpicked:pickedStartFunc})
            })
            $(".end-btn").on("click", function(){
                WdatePicker({el:'endDateHidden',dateFmt:'yyyy-MM-dd',doubleCalendar:true,minDate:'#F{$dp.$D(\'startDateHidden\')}',position:{left:-224,top:8},isShowClear:false,isShowOK:true,isShowToday:false,onpicked:pickedendFunc})
            })
        });
        function pickedStartFunc(){
            $dp.$('commentStartTime').value=$dp.cal.getDateStr('yyyy-MM-dd');
        }
        function pickedendFunc(){
            $dp.$('commentEndTime').value=$dp.cal.getDateStr('yyyy-MM-dd');
        }
    </script>
</div>
</form>

</body>
</html>