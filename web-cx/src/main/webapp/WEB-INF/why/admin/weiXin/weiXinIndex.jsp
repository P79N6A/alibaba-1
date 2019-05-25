<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

    <title>场馆列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>

    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    
</head>
<body>

<div class="site">
    <em>您现在所在的位置：</em>场馆管理 &gt; 场馆信息管理&gt; 场馆列表
</div>
<form id="venueIndexForm" method="post" action="${path}/venue/venueIndex.do">

    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th class="title" style="width: 1000px">自动回复内容</th>
                <th>创建时间</th>
                <th>最新操作时间</th>
                <th>管理</th>
            </tr>
            </thead>
            <c:if test="${empty list}">
                <tr>
                    <td colspan="8"> <h4 style="color:#DC590C">暂无数据!</h4></td>
                </tr>
            </c:if>
            <tbody>

            <c:forEach items="${list}" var="c" varStatus="s">
                <tr>
                    <td class="title">${c.autoContent}</td>
                    <td><fmt:formatDate value="${c.createTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                    <td><fmt:formatDate value="${c.updateTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                    <td>
	                 <a href="${path}/weiXin/preEditWeiXin.do?weiXinId=${c.weiXinId}">编辑</a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        <c:if test="${not empty list}">
            <input type="hidden" id="page" name="page" value="${page.page}" />
            <div id="kkpager"></div>
        </c:if>
        <script type="text/javascript">
            $(function(){
                kkpager.generPageHtml({
                    pno : '${page.page}',
                    total : '${page.countPage}',
                    totalRecords :  '${page.total}',
                    mode : 'click',//默认值是link，可选link或者click
                    click : function(n){
                        this.selectPage(n);
                        $("#page").val(n);
                        formSub('#venueIndexForm');
                        return false;
                    }
                });
            });

            //提交表单
            function formSub(formName){
                var searchKey = $("#searchKey").val();
                if(searchKey == "请输入场馆名称\\发布人\\操作人"){		//"\\"代表一个反斜线字符\
                    $("#searchKey").val("");
                }
                $(formName).submit();
            }

            //场馆推荐与取消推荐 add by YangHui
            function recommendVenue(venueId,type){
                $.ajax({
                    url:'${path}/venue/recommendVenue.do',
                    type:"POST",
                    data:{venueId:venueId,type:type},
                    dataType:"json",
                    success:function(re){
                        formSub('#venueIndexForm');
                    }
                });
            }

        </script>
    </div>
</form>

</body>
</html>