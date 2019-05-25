<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>志愿者活动业务管理--文化云</title>
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

        //停止招募
        function handleStopRecruit(uuid){
            dialogConfirm("提示", "您确定要停止招募吗？", function(){
                var data = {uuid: uuid, recruitmentStatus: 2};
                $.post("${path}/newVolunteerActivity/updateNewVolunteerActivityJson.do", data, function(res) {
                    if (res && res.status == 200) {
                        dialogConfirm("提示", "操作成功！", function(){
                            location.reload();
                        })
                    }else{
                        dialogAlert('提示', '操作失败！');
                    }
                });
            })
        }

        //启用招募
        function handleRecruit(uuid){
            dialogConfirm("提示", "您确定要启用招募吗？", function(){
                var data = {uuid: uuid, recruitmentStatus: 1};
                $.post("${path}/newVolunteerActivity/updateNewVolunteerActivityJson.do", data, function(res) {
                    if (res && res.status == 200) {
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
		    <em>您现在所在的位置：</em>文化志愿者 &gt;志愿者活动 &gt;志愿者活动业务管理
		</div>
		<div class="search">
		    <div class="search-box">
		        <i></i><input type="text" id="name" name="name" value="${model.name}" data-val="请输入活动名称" class="input-text"/>
		    </div>

		    <div class="select-btn">
		        <input type="button" onclick="$('#page').val(1);formSub('#form');" value="搜索"/>
		    </div>
		</div>
		<div class="main-content">
		    <table width="100%">
		        <thead>
			        <tr>
			            <th width="200">活动名称</th>
			            <th width="220">活动时间</th>
						<th width="120">招募对象类型</th>
			            <th width="80">服务时长</th>
			            <th width="120">联系电话</th>
			            <th width="80">允许报名人数</th>
			            <th width="80">招募状态</th>
			            <th width="80">状态</th>
			            <th width="200">操作</th>
			        </tr>
		        </thead>
		        <tbody>
		        <c:forEach items="${list}" var="item">
		            <tr>
		                <td>${item.name}</td>
						<td><fmt:formatDate value="${item.startTime}" pattern="yyyy-MM-dd HH:mm"/> 至 <fmt:formatDate value="${item.endTime}" pattern="yyyy-MM-dd HH:mm"/></td>
						<td>
							<c:choose>
								<c:when test="${item.recruitObjectType=='1'}">
									个人
								</c:when>
								<c:when test="${item.recruitObjectType=='2'}">
									团队
								</c:when>
								<c:otherwise>
									个人、团队
								</c:otherwise>
							</c:choose>
						</td>
						<td>${item.serviceTime} 小时</td>
						<td>${item.phone}</td>
						<td>${item.limitNum}</td>
						<td>
							<c:choose>
								<c:when test="${item.recruitmentStatus==1}">
									招募中
								</c:when>
								<c:when test="${item.recruitmentStatus==2}">
									停止招募
								</c:when>
							</c:choose>
						</td>
						<td>
							<c:choose>
								<c:when test="${item.publish==1}">
									已上架
								</c:when>
								<c:when test="${item.publish==2}">
									未上架
								</c:when>
							</c:choose>
						</td>
						<td>
							<a target="main" href="${path}/newVolunteerActivity/queryNewVolunteerActivityById.do?uuid=${item.uuid}">查看</a> |
							<c:choose>
								<c:when test="${item.publish==2}"><!--未上架-->
									<a target="main" href="${path}/newVolunteerActivity/preEditActivity.do?uuid=${item.uuid}">编辑</a> |
								</c:when>
							</c:choose>
							<a target="main" href="${path}/VolunteerActivityDemeanorDocumentary/documentaryList.do?activityId=${item.uuid}">活动纪实</a> |
							<a target="main" href="${path}/newVolunteerActivity/preMemberList.do?volunteerActivityId=${item.uuid}">招募成员管理</a>
							<c:choose>
								<c:when test="${item.recruitmentStatus==1}"><!--正在招募-->
									<a target="main" href="javascript:;" onclick="handleStopRecruit('${item.uuid}')"> | 停止招募</a>
								</c:when>
								<c:when test="${item.recruitmentStatus==2}"><!--停止招募-->
									<a target="main" href="javascript:;" onclick="handleRecruit('${item.uuid}')"> | 启用招募</a>
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