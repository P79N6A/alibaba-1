<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>活动纪实管理--文化云</title>
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

        //新增
        function handleAdd(){
            location.href = '${path}/VolunteerActivityDemeanorDocumentary/preEditDoc.do?activityId=' + $('#activityId').val();
        }

        //删除
        function handleRemove(uuid){
            dialogConfirm("提示", "您确定要删除吗？", function(){
                $.post("${path}VolunteerActivityDemeanorDocumentary/deleteVolunteerActivityDemeanorDocumentary.do",{"uuid": uuid}, function(res) {
                    if (res && res.status == 200) {
                        dialogConfirm("提示", "删除成功！", function(){
                            location.reload();
                        })
                    }else{
                        dialogAlert('提示', '删除失败！');
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
<input type="hidden" name="activityId" id="activityId" value="${activityId}"/>
	<form id="form" action="" method="post">
	    <div class="site">
		    <em>您现在所在的位置：</em>文化志愿者 &gt;志愿者活动 &gt;活动纪实管理
		</div>
		<div class="search">
		    <div class="search-box">
		        <i></i><input type="text" id="resourceName" name="resourceName" value="${model.resourceName}" data-val="请输入资源名称" class="input-text"/>
		    </div>

		    <div class="select-btn">
		        <input type="button" onclick="$('#page').val(1);formSub('#form');" value="搜索"/>
		    </div>
			<div class="search-total">
				<div class="select-btn">
					<input type="button" onclick="handleAdd();" value="新增资源" />
				</div>
			</div>
		</div>
		<div class="main-content">
		    <table width="100%">
		        <thead>
			        <tr>
			            <th width="200">资源名称</th>
						<th width="120">资源类型</th>
			            <th width="120">资源大小</th>
			            <th width="200">操作</th>
			        </tr>
		        </thead>
		        <tbody>
		        <c:forEach items="${list}" var="item">
		            <tr>
		                <td>${item.resourceName}</td>
						<td>
							<c:choose>
								<c:when test="${item.resourceType==1}">
									图片
								</c:when>
								<c:when test="${item.resourceType==2}">
									视频
								</c:when>
								<c:when test="${item.resourceType==3}">
									音频
								</c:when>
							</c:choose>
						</td>
						<td>${item.resourceSize}</td>
						<td>
							<a target="main" href="${path}/VolunteerActivityDemeanorDocumentary/preEditDoc.do?activityId=${activityId}&uuid=${item.uuid}">编辑</a> |
							<a target="main" href="javascript:;" onclick="handleRemove('${item.uuid}')">删除</a>
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