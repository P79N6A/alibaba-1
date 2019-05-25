<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
    <title>模板功能管理--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
</head>

<body>
	<form id="functionForm" action="" method="post">
		<div class="site">
		    <em>您现在所在的位置：</em>活动管理 &gt; 模板功能管理
		</div>
		
		<div class="search">
			<div class="menage-box">
		        <a class="btn-add">添加功能</a>
		    </div>
		</div>
		
		<div class="main-content">
		    <table width="100%">
		        <thead>
			        <tr>
			            <th width="65">ID</th>
			            <th class="title">功能名称</th>
			            <th>简介</th>
			            <th>示例图</th>
			            <th>操作</th>
			        </tr>
		        </thead>
		
		        <tbody id="function">
			        <%int i=0;%>
			        <c:if test="${not empty list}">
				        <c:forEach items="${list}" var="dataList">
				            <%i++;%>
				            <tr>
				                <td><%=i%></td>
				                
				                <c:choose>
				                    <c:when test="${not empty dataList.funName}">
				                        <td class="title">${dataList.funName}</td>
				                    </c:when>
				                    <c:otherwise>
				                        <td class="title"></td>
				                    </c:otherwise>
				                </c:choose>
				                
				                <c:choose>
				                    <c:when test="${not empty dataList.funDescr}">
				                        <td class="title">${dataList.funDescr}</td>
				                    </c:when>
				                    <c:otherwise>
				                        <td class="title"></td>
				                    </c:otherwise>
				                </c:choose>
				
				                <td data-id="${dataList.funIconUrl}">
				                    <img src="" data-url="${dataList.funIconUrl}"  width="60" height="40"/>
				                </td>
				                
				                <td width="170">
	                                <a funType="update" funId="${dataList.funId}">编辑</a> |
	                                <a href="javascript:functionDelete('${dataList.funId}');" style="color: red;">删除</a>
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
		    <c:if test="${not empty list}">
			    <input type="hidden" id="page" name="page" value="${page.page}" />
			    <div id="kkpager" ></div>
		    </c:if>
		</div>
	</form>

	<script type="text/javascript">
		$(function(){
			//图片显示
			$("#function Img").each(function(index,item){
				$(this).attr("src",getImgUrl($(this).attr("data-url")));
			});

			//分页
			kkpager.generPageHtml({
				pno : '${page.page}',
				total : '${page.countPage}',
				totalRecords :  '${page.total}',
				mode : 'click',//默认值是link，可选link或者click
				click : function(n){
					this.selectPage(n);
					$("#page").val(n);
					searchFunction();
					return false;
				}
			});
		});

		function searchFunction(){
			$("#functionForm").submit();
		}

		//删除
		function functionDelete(id){
			dialogConfirm("提示", "您确定要删除该功能吗？", function(){
				$.post("${path}/function/deleteFunction.do",{"functionId":id}, function(data) {
					if (data!=null && data=='success') {
						window.location.href="${path}/function/functionIndex.do";
					}else{
						dialogAlert('系统提示', '删除失败！');
					}
				});
			})
		}

		seajs.config({
			alias: {
				"jquery": "jquery-1.10.2.js"
			}
		});

		seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
			window.dialog = dialog;
		});

		seajs.use(['jquery'], function ($) {
			$('.btn-add').on('click', function () {
				dialog({
					url: '${path}/function/preFuntionAdd.do',
					title: '添加功能',
					width: 660,
					height:665,
					fixed: true
				}).showModal();
				return false;
			});

			$('a[funType="update"]').on('click', function () {
				dialog({
					url: '${path}/function/preFuntionEdit.do?functionId='+$(this).attr("funId"),
					title: '编辑功能',
					width: 660,
					height:665,
					fixed: true
				}).showModal();
				return false;
			});
		});

	</script>
</body>
</html>