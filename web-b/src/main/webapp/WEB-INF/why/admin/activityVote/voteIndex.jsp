<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <link rel="shortcut icon" href="${path}/STATIC/image/favicon.ico" type="image/x-icon" mce_href="${path}/STATIC/image/favicon.ico">
    <link href="${path}/STATIC/image/favicon.ico" rel="icon" type="image/x-icon" mce_href="${path}/STATIC/image/favicon.ico">
    <title>投票管理列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript">
        $(function(){
        	
        	//分页
            kkpager.generPageHtml({
                pno : '${page.page}',
                total : '${page.countPage}',
                totalRecords :  '${page.total}',
                mode : 'click',//默认值是link，可选link或者click
                click : function(n){
                    this.selectPage(n);
                    $("#page").val(n);
                    var activityName = $("#activityName").val();
                    if(activityName == "请输入活动名称\\投票标题") {
                        $("#activityName").val("");
                    }

                    $("#voteFrom").submit();
                    return false;
                }
            });
            
        });

        function voteDelete(voteId){

            dialogConfirm("提示", "您确定要删除该投票吗？", function(){
                $.post('${path}/vote/deleteActivityVote.do?voteId='+voteId,null ,
                        function(data) {
                            if(data == "success"){
                                dialogSaveDraft("提示", "删除成功", function(){
                                    window.location.href = "${path}/vote/activityVoteIndex.do";
                                })
                            }else if(data == "votingRecords"){
                                dialogSaveDraft("提示", "该记录已经有用户投票了不能删除", function(){
                                    window.location.href = "${path}/vote/activityVoteIndex.do";
                                })
                            } else{
                                dialogSaveDraft("提示", "删除失败", function(){
                                    window.location.href = "${path}/vote/activityVoteIndex.do";
                                })
                            }


                        });
            });
        }

        function searchVote(){

            var activityName = $("#activityName").val();
            if(activityName == "请输入活动名称\\投票标题") {
                $("#activityName").val("");
            }
            $("#voteFrom").submit();
        }


    </script>
</head>
<body>
<form id="voteFrom" method="post" action="${path}/vote/activityVoteIndex.do">
<div class="site">
    <em>您现在所在的位置：</em>主题管理 &gt; 投票管理
</div>
<div class="search">
	    <div class="menage-box">
	        <a class="btn-add" href="${path}/vote/perAddActivityVote.do">新增投票</a>
	    </div>

    <div class="search-box">
        <i></i><input value="<c:choose><c:when test="${not empty cmsActivityVote}">${cmsActivityVote.activityId}</c:when><c:otherwise>请输入活动名称\投票标题</c:otherwise></c:choose>" name="activityId" id="activityName" class="input-text" data-val="请输入活动名称\投票标题" type="text"/>
    </div>
    <div class="select-btn">
        <input type="button" value="搜索" onclick="searchVote()"/>
    </div>

</div>
<div class="main-content">
   <table width="100%">
        <thead>
        <tr>
            <th>ID</th>
            <th class="title">活动名称</th>
            <th >投票标题</th>
            <th >发布时间</th>
            <th >管理</th>
        </tr>
        </thead>
        <tbody>
        <%int i=0;%>
        <c:if test="${not empty list}">
            <c:forEach items="${list}" var="dataList" varStatus="status">
                <%i++;%>
                <tr>
                    <td width="65"><%=i%></td>

                    <c:choose>
                        <c:when test="${not empty dataList.activityName}">
                            <td class="title">${dataList.activityName}</td>
                        </c:when>
                        <c:otherwise>
                            <td class="title"></td>
                        </c:otherwise>
                    </c:choose>

                    <c:choose>
                        <c:when test="${not empty dataList.voteTitel}">
                            <td width="440">${dataList.voteTitel}</td>
                        </c:when>
                        <c:otherwise>
                            <td width="440"></td>
                        </c:otherwise>
                    </c:choose>
                    
                    <c:choose>
                        <c:when test="${not empty dataList.voteDate}">
                            <td width="170"><fmt:formatDate value="${dataList.voteDate}" pattern="yyyy-MM-dd" /></td>
                        </c:when>
                        <c:otherwise>
                            <td width="170"></td>
                        </c:otherwise>
                    </c:choose>

                    <td width="170">
                   		<a target="main" href="${path}/vote/perEditActivityVote.do?voteId=${dataList.voteId}">编辑</a>&nbsp;|
                        <a target="main" href="javascript:toTongji('${dataList.voteId}','${dataList.activityName}');">投票统计</a>&nbsp;|
                   		<a style="color:red;" onclick="voteDelete('${dataList.voteId}');" href="#">删除</a>
                	</td>
                </tr>
            </c:forEach>
        </c:if>
        <c:if test="${empty list}">
            <tr>
                <td colspan="8"><h4 style="color:#DC590C">暂无数据!</h4></td>
            </tr>
        </c:if>
        </tbody>
    </table>
    </div>
    <c:if test="${not empty list}">
        <input type="hidden" id="page" name="page" value="${page.page}" />
        <div id="kkpager"></div>
    </c:if>
</form>
<script type="text/javascript">
    function toTongji(voteId,activityName) {
        var activityName = encodeURI(encodeURI(activityName));
        location.href = "${path}/vote/voteStatistics.do?voteId=" + voteId +"&activityName=" +activityName;
    }
</script>
</body>
</html>