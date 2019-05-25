<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>专属页列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
	<script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
	<link rel="Stylesheet" type="text/css" href="${path}/STATIC/css/DialogBySHF.css" />
    <script type="text/javascript" src="${path}/STATIC/js/DialogBySHF.js"></script>
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
                    searchSpecialPage();
                    return false;
                }
            });
            
        });
        
        seajs.config({
            alias: {
                "jquery": "jquery-1.10.2.js"
            }
        });

        seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
            window.dialog = dialog;
        });

        window.console = window.console || {log:function () {}}
        
        //添加
        function preAddSpecialPage(){
            dialog({
                url: '${path}/specialPage/preAddSpecialPage.do',
                title: '新增活动专属页',
                width: 500,
                height: 220,
                fixed: true
            }).showModal();
        }
        
      	//编辑
        function preEditSpecialPage(pageId){
        	dialog({
                url: '${path}/specialPage/preAddSpecialPage.do?pageId=' + pageId,
                title: '编辑活动专属页',
                width: 500,
                fixed: true
            }).showModal();
        }

     	//删除
		function specialPageDelete(id){
			dialogConfirm("提示", "您确定要删除该条专属页吗？", function(){
                $.post("${path}/specialPage/saveOrUpdatePage.do",{"pageId":id,"pageIsDel":2}, function(data) {
                    if (data!=null && data=='success') {
                        window.location.href="${path}/specialPage/index.do";
                    }else{
		                dialogAlert('系统提示', '删除失败！');
		            }
                });
            })
		}
        
     	//搜索
        function formSub(formName){
            var pageName = $("#pageName").val();
            if(pageName == "请输入专属页名称") {
                $("#pageName").val("");
            }
            $(formName).submit();
        }
     	
     	//关联活动
        function selectActivityList(pageId,selectType) {
            var winW = parseInt($(window).width()*0.8);
            var winH = parseInt($(window).height()*0.95);
            $.DialogBySHF.Dialog({
                Width: winW,
                Height: winH,
                URL: '${path}/specialPage/preSelectActivityList.do?pageId='+pageId+'&selectType='+selectType
            });
        }
        
    </script>
</head>
<body>
	<form id="specialPageForm" method="post" action="">
	<div class="site">
	    <em>您现在所在的位置：</em>渠道管理 &gt; 活动专属页列表
	</div>
	<div class="search">
	    <div class="search-box">
	        <i></i><input value="<c:choose><c:when test="${not empty entity.pageName}">${entity.pageName}</c:when><c:otherwise>请输入专属页名称</c:otherwise></c:choose>" name="pageName" id="pageName" class="input-text" data-val="请输入专属页名称" type="text"/>
	    </div>
	    <div class="select-btn">
	        <input type="button" value="搜索" onclick="$('#page').val(1);formSub('#specialPageForm');"/>
	    </div>
	    <div class="menage-box">
	        <a class="btn-add" href="javascript:preAddSpecialPage();">添加</a>
	    </div>
	</div>
	<div class="main-content">
	    <table width="100%">
	        <thead>
		        <tr>
		            <th width="50">ID</th>
		            <th class="title">活动专属页名称</th>
		            <th width="270">活动主题</th>
		            <th width="270">关联活动</th>
		            <th width="200">创建人</th>
		            <th width="200">创建时间</th>
		            <th width="140">管理</th>
		        </tr>
	        </thead>
	        <tbody id="specialPage">
		        <%int i=0;%>
		        <c:if test="${null != list}">
		            <c:forEach items="${list}" var="dataList" varStatus="status">
		                <%i++;%>
		                <tr>
		                    <td><%=i%></td>
		                    <td class="title">${dataList.pageName}</td>
		                    <td>${dataList.projectName}</td>
		                    <td>
		                    	<a onclick="selectActivityList('${dataList.pageId}',1);">点击关联</a>
		                    	<c:if  test="${dataList.activityCount>0}">
		                    		&nbsp;|&nbsp;<a onclick="selectActivityList('${dataList.pageId}',2);">查看已关联活动</a>
		                    	</c:if>
		                    </td>
							<td>${dataList.pageCreateUser}</td>
		                    <td width="170"><fmt:formatDate value="${dataList.pageCreateTime}" pattern="yyyy-MM-dd HH:mm" /></td>
		                    <td>
		                    	<a target="main" href="javascript:preEditSpecialPage('${dataList.pageId}');">编辑</a>
		                    	|<a style="color:red;"  href="javascript:specialPageDelete('${dataList.pageId}');">删除</a>
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
</body>
</html>