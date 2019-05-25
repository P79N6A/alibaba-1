<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>推荐列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    <script type="text/javascript">
        $(function() {
            var defaultAreaId = $("#area").val();
            $.post("${path}/recommend/getLocArea.do",function(areaData) {
                var ulHtml = "<li data-option=''>全部区县</li>";
                var divText = "全部区县";
                if (areaData != '' && areaData != null) {
                    for(var i=0; i<areaData.length; i++){
                        var area = areaData[i];
                        var areaId = area.id;
                        var areaText = area.text;
                        ulHtml += '<li data-option="'+areaId+'">'
                        + areaText
                        + '</li>';
                        if(defaultAreaId == areaId){
                            divText = areaText;
                        }
                    }
                    $("#areaDiv").html(divText);
                    $("#areaUl").html(ulHtml);
                }
            }).success(function() {
                selectModel();
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
                    formSub('#recommendForm');
                    return false;
                }
            });
        });

        //提交表单
        function formSub(formName){
//            var venueName = $("#venueName").val();
//            if(venueName == "输入关键词"){
//                $("#venueName").val("");
//            }
            if($("#contentName").val()=="请输入内容名称"){
                $("#contentName").val("");
            }
            $(formName).submit();
        }

        //取消推荐
        function cancelRecommend(recommendId) {
            var data = {"recommendId":recommendId};

            var html = "您确定要取消推荐吗？";
            dialogConfirm("提示", html, function(){
                $.post("${path}/recommend/cancelRecommend.do",data,function(result){
                    if (result !=null && result == 'success') {
                        window.location.href="${path}/recommend/recommendIndex.do";
                    }
                });
            });
        }
    </script>
</head>
<body>
<form id="recommendForm" action="${path}/recommend/recommendIndex.do" method="post">
<div class="site">
    <em>您现在所在的位置：</em>运维管理 &gt; </em>推荐列表
</div>
<div class="search">
    <div class="search-box">
        <i></i><input type="text" id="contentName" name="contentName" value="${cmsRecommend.contentName}"
               data-val="请输入内容名称"    class="input-text"/>
    </div>
    <div class="select-box w135">
        <input type="hidden" id="area" name="area" value="${cmsRecommend.area}"/>
        <div id="areaDiv" class="select-text" data-value="">全部区县</div>
        <ul class="select-option" id="areaUl">
        </ul>
    </div>
    <div class="select-btn">
        <input type="button" onclick="$('#page').val(1);formSub('#recommendForm');" value="搜索"/>
    </div>
</div>
<div class="main-content">
    <table width="100%">
        <thead>
        <tr>
            <th >ID</th>
            <th class="title">推荐位置</th>
            <th class="venue">内容名称</th>
            <th>所属区县</th>
            <th >操作人</th>
            <th>操作时间</th>
            <th>管理</th>
        </tr>
        </thead>

        <tbody>
        <c:forEach items="${recommendList}" var="c" varStatus="s">
            <tr>
                <td >${s.index + 1}</td>
                <td class="title">热点推荐</td>
                <td class="venue">${c.contentName}</td>
                <td>
                    ${fn:substringAfter(c.area, ',')}
                </td>
                <td >
                   ${c.recommendUserName}
                </td>
                <td >
                   <fmt:formatDate value="${c.recommendTime}" pattern="yyyy-MM-dd HH:mm"></fmt:formatDate>
                </td>
                <td>
                	<%
                      if(recommendCancleButton) {
                    %>
	                    <a onclick="cancelRecommend('${c.recommendId}')">
	                     	取消推荐
                    <%
                        }
                    %>
                       
                    </a>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty recommendList}">
            <tr>
                <td colspan="7"> 暂无数据!</td>
            </tr>
        </c:if>
        </tbody>
    </table>
    <c:if test="${not empty recommendList}">
    <input type="hidden" id="page" name="page" value="${page.page}" />
    <div id="kkpager" ></div>
    </c:if>
</div>
</form>
</body>
</html>