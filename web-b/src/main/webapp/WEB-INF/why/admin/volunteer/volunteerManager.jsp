<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>志愿者管理--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>
    
    <script type="text/javascript">

        //搜索
       function formSub(formName){
         
            $(formName).submit();
        }
        
        
        
        $(document).ready(function(){
            //分页
            kkpager.generPageHtml({
                pno : '${page.page}',
                total : '${page.countPage}',
                totalRecords :  '${page.total}',
                mode : 'click',//默认值是link，可选link或者click
                click : function(n){
                    this.selectPage(n);
                    $("#page").val(n);
                    formSub('#form');
                    return false;
                }
            });
            
        });

        //通过
        function handleAccept(uuid){
            dialogConfirm("提示", "您确定要通过审核吗？", function(){
                var data = {uuid: uuid, status: 2};
                $.post("${path}/newVolunteer/auditNewVolunteer.do", data, function(res) {
                    if (res && res === 'success') {
                        dialogConfirm("提示", "操作成功！", function(){
                            location.reload();
                        })
                    }else{
                        dialogAlert('提示', '操作失败！');
                    }
                });
            })
        }

        //拒绝
        function handleRefuse(uuid){
            dialogConfirm("提示", "您确定要拒绝申请吗？", function(){
                var data = {uuid: uuid, status: 3};
                $.post("${path}/newVolunteer/auditNewVolunteer.do", data, function(res) {
                    if (res && res === 'success') {
                        dialogConfirm("提示", "操作成功！", function(){
                            location.reload();
                        })
                    }else{
                        dialogAlert('提示', '操作失败！');
                    }
                });
            })
        }

	</script>
    <style type="text/css">
        .ui-dialog-title,.ui-dialog-content textarea{ font-family: Microsoft YaHei;}
        .ui-dialog-header{ border-color: #9b9b9b;}
        .ui-dialog-close{ display: none;}
        .ui-dialog-title{ color: #F23330; font-size: 20px; text-align: center;}
        .ui-dialog-content{}
        .ui-dialog-body{}
    </style>
</head>
<body>
	<form id="form" action="" method="post">
	    <div class="site">
		    <em>您现在所在的位置：</em>文化志愿者 &gt;志愿者管理
		</div>
		<%--<div class="search">--%>
		    <%--<div class="search-box">--%>
		        <%--<input type="text" id="name" name="name" value="${model.name}" data-val="请输入志愿者名称" class="input-text"/>--%>
		    <%--</div>--%>

		    <%--<div class="select-btn">--%>
		        <%--<input type="button" onclick="$('#page').val(1);formSub('#form');" value="搜索"/>--%>
		    <%--</div>--%>
		<%--</div>--%>
		<div class="main-content">
		    <table width="100%">
		        <thead>
			        <tr>
			            <th width="120">姓名</th>
						<th width="120">学历</th>
						<th width="120">联系电话</th>
						<th width="120">类型</th>
						<th width="120">状态</th>
			            <th width="220">申请时间</th>
			            <th width="200">操作</th>
			        </tr>
		        </thead>
		        <tbody>
		        <c:forEach items="${list}" var="item">
		            <tr>
		                <td>${item.name}</td>
						<td>
							<c:choose>
								<c:when test="${item.education==1}">
									高中
								</c:when>
								<c:when test="${item.education==2}">
									大专
								</c:when>
								<c:when test="${item.education==3}">
									本科
								</c:when>
								<c:when test="${item.education==4}">
									硕士及以上
								</c:when>
							</c:choose>
						</td>
						<td>${item.phone}</td>
						<td>
							<c:choose>
								<c:when test="${item.type==1}">
									个人
								</c:when>
								<c:when test="${item.type==2}">
									团队
								</c:when>
							</c:choose>
						</td>
						<td>
							<c:choose>
								<c:when test="${item.status==1}">
									待审核
								</c:when>
								<c:when test="${item.status==2}">
									已通过
								</c:when>
								<c:when test="${item.status==3}">
									已拒绝
								</c:when>
								<c:when test="${item.status==9}">
									已删除
								</c:when>
							</c:choose>
						</td>
						<td><fmt:formatDate value="${item.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
						<td>
							<c:choose>
								<c:when test="${item.status == 1}">
									<a target="main" href="${path}/newVolunteer/viewVolunteer.do?uuid=${item.uuid}">查看</a> |
									<a target="main" href="javascript:;" onclick="handleAccept('${item.uuid}')">通过</a> |
									<a target="main" href="javascript:;" onclick="handleRefuse('${item.uuid}')">拒绝</a>
								</c:when>
								<c:when test="${item.status != 1}">
									<a target="main" href="${path}/newVolunteer/viewVolunteer.do?uuid=${item.uuid}">查看</a>
								</c:when>
							</c:choose>

						</td>
		            </tr>
		        </c:forEach>

		        <c:if test="${empty list}">
		            <tr>
		                <td colspan="8"><h4 style="color:#DC590C">暂无数据!</h4></td>
		            </tr>
		        </c:if>
		        </tbody>
		    </table>
		
			<c:if test="${not empty list}">
	            <input type="hidden" id="page" name="page" value="${page.page}" />
		    	<div id="kkpager"></div>
	        </c:if>
		</div>
	</form>
</body>
</html>