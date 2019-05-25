<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

    <title>万人培训课程列表--文化云</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
    <%@include file="/WEB-INF/why/common/limit.jsp"%>

    <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
    <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
    <script type="text/javascript">
        $(function() {
        var courseType="${courseType}";
        var courseField="${courseField}";
		 	$.post("${path}/sysdict/queryChildSysDictByDictCode.do",{'dictCode':"PXFS"}, function(data) {
          	var list = eval(data);
           if(data != null && data.length > 0){
           		$("#courseList").html("");
           		var dictHtml="";
            	dictHtml+="<li  data_value=''>全部</li>";
          		for (var i = 0; i < list.length; i++) {
            	var obj = list[i];
            	var dictId = obj.dictId;
            	var dictName = obj.dictName;
            	if(courseType==dictId){ 
                	dictHtml+="<li class='seleced' data-option='"+dictId+"'>"+dictName+"</li>";
              	}else{
                	dictHtml+="<li  data-option='"+dictId+"'>"+dictName+"</li>";
              	}
          	}
          $("#courseList").html(dictHtml);
          var txt=$("#courseList").find("li[data-option="+courseType+"]").text();
          if(txt==''){
        	  txt="培训方式";
          }
          $("#courseList").siblings(".select-text").text(txt);
        }
      });
		 $.post("${path}/sysdict/queryChildSysDictByDictCode.do",{'dictCode':"COURSE_FIELD"}, function(data) {
          var list = eval(data);
           if(data != null && data.length > 0){
           $("#courseFieldList").html("");
           var dictHtml="";
           dictHtml+="<li data_value=''>全部</li>";
          for (var i = 0; i < list.length; i++) {
            var obj = list[i];
            var dictId = obj.dictId;
            var dictName = obj.dictName;
            if(courseField==dictId){ 
            	dictHtml+="<li class='seleced' data-option='"+dictId+"'>"+dictName+"</li>";
              }else{
            	  dictHtml+="<li data-option='"+dictId+"'>"+dictName+"</li>";
              }
          }
          $("#courseFieldList").html(dictHtml);
          var txt=$("#courseFieldList").find("li[data-option="+courseField+"]").text();
          if(txt==''){
        	  txt="从事领域";
          }
          $("#courseFieldList").siblings(".select-text").text(txt);
        }
      });
		
        });
        
        $(function(){
			selectModel();
		});
    </script>
</head>
<body>

<div class="site">
    <em>您现在所在的位置：</em>培训管理 &gt; 课程列表
</div>
<form id="courseListForm" method="post" action="${path}/peopleTrain/courseList.do">
    <div class="search">
        <div class="search-box">
            <i></i><input id="searchKey" name="searchKey" class="input-text" placeholder="请输入课程名称 " type="text"
                          value="<c:choose><c:when test="${not empty searchKey}">${searchKey}</c:when><c:otherwise></c:otherwise></c:choose>"/>
        </div>
        <div class="select-box w135">
        <input type="hidden" name="courseType" id="courseType" value="${courseType}"/>
	         <div class="select-text" data-option="培训方式">培训方式</div>
		      <ul class="select-option select_index" tip="dataone"  style="display: none;" id="courseList">
		      </ul>
        </div>
        <div class="select-box w135">
           <input type="hidden" name="courseField" id="courseField" value="${courseField}"/>
	         <div class="select-text" data-option="从事领域">从事领域</div>
		      <ul class="select-option select_index" tip="dataone"  style="display: none;" id="courseFieldList">
		      </ul>
        </div>
        <div class="select-btn">
            <input type="button" value="搜索" onclick="$('#page').val(1);formSub('#courseListForm')"/>
        </div>
        <div class="menage-box">
        <a class="btn-add" href="${path}/peopleTrain/addCourse.do">添加课程</a>
        </div>
    </div>
    <div class="main-content">
        <table width="100%">
            <thead>
            <tr>
                <th>ID</th>
                <th class="title">课程名称</th>
                <th>创建时间</th>
                <th>创建人</th>
                <th>培训方式</th>
                <th>从事领域</th>
                <th>状态</th>
                <th>操作</th>

            </tr>
            </thead>
            <c:if test="${empty list}">
                <tr>
                    <td colspan="7"> <h4 style="color:#DC590C">暂无数据!</h4></td>
                </tr>
            </c:if>
            <tbody>

            <c:forEach items="${list}" var="c" varStatus="s">
                <tr>
                 <td>${s.index+1}</td>
                    <td class="title">${c.courseTitle}</td>
                   <td><fmt:formatDate value="${c.createTime}" pattern="yyyy-MM-dd HH:mm"/></td>
                    <td>${c.createUser}</td>
                    <td>${c.courseType}</td>
                    <td>${c.courseField}</td>
                    <td> <c:if test="${c.courseState==2}">未审核</c:if> <c:if test="${c.courseState==1}">审核通过 </c:if><c:if test="${c.courseState==3}">审核未通过 </c:if></td>
                    <td>
                       <a href="${path}/peopleTrain/courseView.do?courseId=${c.courseId}">查看报名</a>
                       |<a href="${path}/peopleTrain/courseDetails.do?courseId=${c.courseId}">课程详情</a>
                       <c:if test="${c.courseState==2}">  | <a href="${path}/peopleTrain/editCourse.do?courseId=${c.courseId}&pages=${page.page}">编辑</a></c:if>
                       <%if(trianUserListButton) {%>
                       <c:if test="${c.courseState==2}"><%-- |<a href="javascript:soldOut('${c.courseId}',2);">下架</a> --%>|<a href="javascript:soldOut('${c.courseId}',1,'${page.page}');">上架</a></c:if> 
                       <c:if test="${c.courseState==1}">| <a href="javascript:soldOut('${c.courseId}',2,'${page.page}');">下架</a></c:if> 
                       | <a href="javascript:soldOut('${c.courseId}',3,'${page.page};')">删除</a>
                       <%-- <c:if test="${c.courseState==3}">| <a href="javascript:soldOut('${c.courseId}',2);">上架</a></c:if> --%>
                       <%}%>
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
                        formSub('#courseListForm');
                        return false;
                    }
                });
            });

            //提交表单
            function formSub(formName){
                $(formName).submit();
            }

            //课程商家和下架
            function soldOut(courseId,state,page){
                if(state==1){
                 name="上架";
                }else if(state==2){
                 name="下架";
                }else{
                 name="删除";
                }
                var html = "您确定"+name+"此课程吗？";
				dialogConfirm("提示", html, function(){

	                $.ajax({
	                    url:'${path}/peopleTrain/editState.do',
	                    type:"POST",
	                    data:{courseId:courseId,state:state,page:page},
	                    dataType:"json",
	                    success:function(re){
	                    	//window.location.href = "${path}/peopleTrain/courseList.do";
	                    	 formSub('#courseListForm');
	                    }
	                });
				})
            }
            <%--      function check(courseId,checkState){
                $.ajax({
                    url:'${path}/peopleTrain/check.do',
                    type:"POST",
                    data:{courseId:courseId,checkState:checkState},
                    dataType:"json",
                    success:function(re){
                        formSub('#courseListForm');
                    }
                });
            }


        --%></script>
    </div>
</form>

</body>
</html>