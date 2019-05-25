<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>讲师列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp" %>
    <%@include file="/WEB-INF/why/common/limit.jsp" %>

    <script type="text/javascript">

        $(function () {
        	
        	 //关闭图片预览
  		    $(".imgPreview,.imgPreview>img").click(function() {
  			 	$(".imgPreview").fadeOut("fast");
  			}) 	   
        	
            kkpager.generPageHtml({
                pno: '${page.page}',
                total: '${page.countPage}',
                totalRecords: '${page.total}',
                mode: 'click',//默认值是link，可选link或者click
                click: function (n) {
                    this.selectPage(n);
                    $("#page").val(n);
                    formSub('#poemLectorForm');
                    return false;
                }
            });
        	 
        });
        
      	//提交表单
        function formSub(formName) {
        	var lectorName = $('#lectorName').val();
            if (lectorName != undefined && lectorName == '输入讲师姓名') {
                $('#lectorName').val("");
            }
            $(formName).submit();
        }

        //点击看大图
        function showPreview(url){
        	$(".imgPreview img").attr("src",url);
        	$(".imgPreview").fadeIn("fast");
        }
        
      	//删除
		function deletePoemLector(lectorId,isPoem){
      		var text = isPoem==1?"该讲师已赏析过每日一诗，确定要删除吗？":"您确定要删除此讲师吗？";
			dialogConfirm("提示", text, function(){
                $.post("${path}/poem/deletePoemLector.do",{"lectorId":lectorId}, function(data) {
                    if (data == '200') {
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
    
</head>

<body>
	<form id="poemLectorForm" action="" method="post">
	    <div class="site">
	        <em>您现在所在的位置：</em>运维管理 &gt; 每日一诗管理 &gt; 讲师列表
	    </div>
	    <div class="search">
		    <div class="search-box">
		        <input type="text" id="lectorName" name="lectorName" value="${entity.lectorName}" data-val="输入讲师姓名" class="input-text"/>
		    </div>
		    <div class="select-btn" style="margin:0px 15px;">
		        <input type="button"  onclick="$('#page').val(1);formSub('#poemLectorForm');" value="搜索"/>
		    </div>
		</div>
		<div class="search menage">
		    <h2>讲师一览</h2>
		    <div class="menage-box">
		        <a class="btn-add" href="${path}/poem/preAddPoemLector.do">新增讲师</a>
		    </div>
		</div>
	    <div class="main-content">
	        <table width="100%">
	            <thead>
	            <tr>
	                <th width="50">ID</th>
	                <th width="100">讲师姓名</th>
	                <th width="100">头像</th>
	                <th width="200">职位</th>
	                <th class="title">简介</th>
	                <th width="100">创建人</th>
	                <th width="100">创建时间</th>
	                <th width="100">管理</th>
	            </tr>
	            </thead>
	            <tbody>
	            <%int i = 0;%>
	            <c:forEach items="${list}" var="dom">
	                <%i++;%>
	                <tr>
	                    <td><%=i%></td>
	                    <td>${dom.lectorName}</td>
	                    <td><img onclick="showPreview('${dom.lectorHeadImg}');" src="${dom.lectorHeadImg}@100w" width="100"></img></td>
	                    <td>${dom.lectorJob}</td>
	                    <td class="title">${dom.lectorIntro}</td>
	                    <td>${dom.createUser}</td>
	                    <td><fmt:formatDate value="${dom.createTime}" pattern="yyyy-MM-dd"/></td>
	                    <td>
	                    	<a target="main" href="${path}/poem/preEditPoemLector.do?lectorId=${dom.lectorId}">编辑</a>
	                    	| <a target="main" href="javascript:deletePoemLector('${dom.lectorId}',${dom.isPoem})" style="color: red;font-weight: bold;">删除</a>
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
	            <input type="hidden" id="page" name="page" value="${page.page}"/>
	            <div id="kkpager"></div>
	        </c:if>
	    </div>
	</form>
	<!--点击放大图片imgPreview-->
	<div class="imgPreview" style="width:800px;height:600px;position:fixed;top:0;right:0;bottom:0;left:0;margin:auto;z-index:100;display: none;">
		<img src="" style="max-width:100%;max-height:100%;width:auto;height:auto;position:absolute;top:0;right:0;bottom:0;left:0;margin:auto;"/>
	</div>
</body>
</html>
