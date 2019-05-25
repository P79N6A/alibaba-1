<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>

    <title>文化云</title>
    <!-- 导入头部文件 start -->
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
</head>
<body>

<div class="site">
    <em>您现在所在的位置：</em>资讯管理 &gt; 资讯详情管理
</div>
<form action="${path }/ccpInformationDetail/ccpInformationDetailIndex.do" id="informationDetailForm" method="post">
	 <input type="hidden" id="informationId" name="informationId" value="${informationId }"/>
    <div class="search">
      
            <div class="search menage">
                <div class="menage-box">
                    <a class="btn-add">新增详情</a>
                </div>
            </div>
      
    </div>
    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th>ID</th>
                <th class="title">内容</th>
                <th>图片链接</th>
                <th>创建时间</th>
                <th>管理</th>
            </tr>
            </thead>
            <tbody>
            <c:if test="${fn:length(detailList) gt 0}">
                <tbody>
                <%int i=0;%>
                <c:forEach items="${detailList}" var="informationDetail">
                    <%i++;%>
                    <tr>
                        <td><%=i%></td>
                        <td class="title">
                            <a href="javascript:;">
                                <c:if test="${not empty informationDetail.detailTitle}">
                                    ${fn:substring(informationDetail.detailTitle,0,10)}:
                                </c:if>
                                <c:if test="${not empty informationDetail.detailContent}">
                                    ${fn:substring(informationDetail.detailContent,0,30)}
                                </c:if>
                            </a>
                        </td>
                        <td>
                         ${informationDetail.detailImageLink}
                        </td>
                          <td>
                            <fmt:formatDate value="${informationDetail.detailCreateTime}"  pattern="yyyy-MM-dd HH:mm" />
                        </td>
                        <td>
                           <a class="delete" informationDetailId="${informationDetail.informationDetailId}">删除</a> |
                           
                           <a informationDetailId="${informationDetail.informationDetailId}" class="informationDetail-edit">编辑</a> 
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </c:if>
            <c:if test="${empty detailList}">
                <tr>
                    <td colspan="7"> <h4 style="color:#DC590C">暂无数据!</h4></td>
                </tr>
            </c:if>
            </tbody>
        </table>
        <c:if test="${not empty detailList}">
            <input type="hidden" id="page" name="page" value="${page.page}" />
            <div id="kkpager"></div>
        </c:if>
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

    window.console = window.console || {log:function () {}}

    seajs.use(['jquery'], function ($) {
        // 新增详情
        $('.btn-add').on('click', function () {
        	
        	var informationId=$("#informationId").val()
           
        	  window.location.href = '${path}/ccpInformationDetail/preAddInformationDetail.do?informationId='+informationId
            
        });

        //编辑详情
        $('.informationDetail-edit').on('click', function () {
            var informationDetailId = $(this).attr("informationDetailId");
            window.location.href = '${path}/ccpInformationDetail/preEditInformationDetail.do?informationDetailId='+informationDetailId
             
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
                formSub('#informationDetailForm');
                return false;
            }
        });

        // 删除详情
        deleteinformationDetail();
    });

    function formSub(formName){
       
        $(formName).submit();
    }

    function deleteinformationDetail(){
        $(".delete").on("click", function(){
            var informationDetailId = $(this).attr("informationDetailId");
        	var informationId=$("#informationId").val()
            var html = "您确定要删除吗？";
            dialogConfirm("提示", html, function(){
                $.post("${path}/ccpInformationDetail/deleteInformationDetail.do",{informationDetailId:informationDetailId},function(data) {
                    if (data == 'success') {
                    	  window.location.href = '${path}/ccpInformationDetail/preAddInformationDetail.do?informationId='+informationId
                    }
                });
            })
        });
    }
</script>
</body>
</html>