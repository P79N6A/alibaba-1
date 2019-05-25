<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

    <title>万人培训报名列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>

    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <script type="text/javascript">
        $(function() {
         //导出excel表格

        });
          function exportExcel() {
            location.href = "${path}/peopleTrain/exportTrainTerminalExcel.do?" + $("#applyListForm").serialize();
          }
    </script>
    <style>
      .export{
          float: right;
	    display: inline-block;
	    width: 100px;
	    height: 42px;
	    line-height: 42px;
	    overflow: hidden;
	    color: #ffffff;
	    font-size: 18px;
	    border-radius: 5px;
	    -moz-border-radius: 5px;
	    -webkit-border-radius: 5px;
	    background: #1882FC;
	    text-align: center;

      }
    </style>
</head>
<body>

<div class="site">
    <em>您现在所在的位置：</em>培训管理 &gt; 报名列表
</div>
<form id="applyListForm" method="post" action="${path}/peopleTrain/applyList.do">
    <div class="search">
        <div class="search-box">
            <i></i><input id="searchKey" name="searchKey" class="input-text" placeholder="请输入报名人\单位名称\手机号码" type="text"
                          value="<c:choose><c:when test="${not empty searchKey}">${searchKey}</c:when><c:otherwise></c:otherwise></c:choose>"/>
        </div>
        <div class="select-btn">
            <input type="button" value="搜索" onclick="$('#page').val(1);formSub('#applyListForm')"/>
        </div>
       <a class="export" onclick="exportExcel();">导出</a>
    </div>
    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th>ID</th>
                <th class="title">真实姓名</th>
                <th>性别</th>
                <th>手机号码</th>
                <!-- <th>身份证号</th> -->
                <th>单位名称</th>
                <th>课程</th>
                <th>报名状态</th>
                <th>报名时间</th>
                <th>操作</th> 
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
                    <td>${s.index+1}</td>
                    <td class="title">${c.realName}</td>
                    <td> <c:if test="${c.userSex ==1}">男</c:if> 
                    <c:if test="${c.userSex ==2}">女</c:if></td>
                    <td>${c.userMobileNo}</td>
                    <%-- <td>${c.idNumber }</td> --%>
                    <td>${c.unitName }</td>
                    <td>${c.courseTitle }</td>
                    <td><c:if test="${c.orderStatus ==1}">待确认</c:if> 
                    <c:if test="${c.orderStatus ==2}">已确认</c:if></td>
                    <td>${fn:substring(c.createTime, 0, 19)}</td>                
                     <td>
                            <%--<a href="#">查看</a>

                       | <a href="#">编辑</a>

                            |--%>  <a href="${path}/peopleTrain/viewTrainUser.do?userId=${c.userId}">查看</a>|<a href="javascript:deleteOrder('${c.orderId}',4);">删除</a>
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
                    isShowTotalRecords : true,
                    mode : 'click',//默认值是link，可选link或者click
                    click : function(n){
                        this.selectPage(n);
                        $("#page").val(n);
                        formSub('#applyListForm');
                        return false;
                    }
                });
            });

            //提交表单
            function formSub(formName){
                $(formName).submit();
            }
            //删除报名人
            function deleteOrder(orderId,state){
            	var html = "您确定要 删除吗？";
				dialogConfirm("提示", html, function(){
					 $.ajax({
		                    url:'${path}/peopleTrain/deleteOrder.do',
		                    type:"POST",
		                    data:{orderId:orderId,state:state},
		                    dataType:"json",
		                    success:function(re){
		                        formSub('#applyListForm');
		                    }
		                });
				})
               
            }

        </script>
    </div>
</form>

</body>
</html>