<%-- 实现国际化需要导入的lib --%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<fmt:setLocale value="zh_CN"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/html">
<head>
    <title>查看用户</title>
    <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
     <script type="text/javascript">
     $(function(){
    	  var courseType="${course.courseType}";
    	 $.post("${path}/sysdict/queryChildSysDictByDictCode.do",{'dictCode':"PXFS"}, function(data) {
           	var list = eval(data);
            if(data != null && data.length > 0){
            		$("#courseType").html("");
            		var dictHtml="";
           		for (var i = 0; i < list.length; i++) {
             	var obj = list[i];
             	var dictId = obj.dictId;
             	var dictName = obj.dictName;
             	if(courseType==dictId){ 
                 	dictHtml=dictName;
               	}
           	}
           $("#courseType").html(dictHtml);
         }
       });
    	 var courseRank="${course.courseRank}";
    	 $.post("${path}/sysdict/queryChildSysDictByDictCode.do",{'dictCode':"KCPC"}, function(data) {
           	var list = eval(data);
            if(data != null && data.length > 0){
            		$("#courseRank").html("");
            		var dictHtml="";
           		for (var i = 0; i < list.length; i++) {
             	var obj = list[i];
             	var dictId = obj.dictId;
             	var dictName = obj.dictName;
             	if(courseRank==dictId){ 
                 	dictHtml=dictName;
               	}
           	}
           $("#courseRank").html(dictHtml);
         }
       });
         var location="${course.courseField}";
         location=location.split(",");
         $.post("${path}/sysdict/queryChildSysDictByDictCode.do",{'dictCode':"COURSE_FIELD"}, function(data) {
             var list = eval(data);
              if(data != null && data.length > 0){
              $("#courseField").html("");
              var dictHtml='';
             for (var i = 0; i < list.length; i++) {
                        var obj = list[i];
               var dictId = obj.dictId;
               var dictName = obj.dictName;
                	   if(ischecked(dictId)){
          	                dictHtml+=dictName+",";
          	                
          	             }               	    
             }
             dictHtml = dictHtml.substr(0,dictHtml.length - 1);
             $("#courseField").html(dictHtml);
           }
         });
         //从事领域

         function ischecked(obj){
              for(var i=0;i<location.length;i++){
                 if(obj==location[i]){
                    return true;
                 }
              }
           }
     });
     </script>
</head>
<body>
<div class="site">
    <em>您现在所在的位置：</em>培训管理 &gt;课程列表 &gt; 查看课程
</div>
<div class="site-title">查看课程</div>
<!-- 正中间panel -->
<div class="main-publish">
    <table class="form-table" width="100%">
        <tbody>
        <tr>
            <td class="td-title" width="130">课程名称：</td>
            <td class="td-input" >
                <span>${course.courseTitle}</span>
            </td>
        </tr>
        <tr>
            <td class="td-title">培训方式：</td>
            <td class="td-input" >
                <span id="courseType"></span>
            </td>
        </tr>
        <tr>
            <td class="td-title">课程批次：</td>
            <td class="td-input" >
                <span id="courseRank"></span>
            </td>
        </tr>
        <tr>
            <td class="td-title">最大人数：</td>
            <td class="td-input" >
                <span>
					${course.peopleNumber}
                </span>
            </td>
        </tr>
        <tr>
            <td class="td-title">联系方式：</td>
            <td class="td-input" >
                <span>
					${course.coursePhoneNum}
                </span>
            </td>
        </tr>
        <tr>
            <td class="td-title">课程领域：</td>
            <td class="td-input" >
                <span id="courseField">
                </span>
            </td>
        </tr>
        <tr>
            <td class="td-title">目标学员：</td>
            <td class="td-input" >
                <span>
                ${course.targetAudienc}
                </span>
            </td>
        </tr>
        <tr>
            <td class="td-title">培训地点：</td>
            <td class="td-input" >
                <span>${course.trainAddress}</span>
            </td>
        </tr>
        <tr>
            <td class="td-title">培训时间：</td>
            <td class="td-input" >
                <span>${course.courseStartTime}至</span>
                <span>${course.courseEndTime}</span>
                <span>${course.trainTime}</span>
            </td>
        </tr>

        <tr>
            <td class="td-title">课程状态：</td>
            <td class="td-input">
                                    <span>
                                        <c:choose>
                                            <c:when test="${course.courseState==1}">
                                               审核通过
                                            </c:when>
                                            <c:when test="${trainUser.courseState==2}">
                                                未审核
                                            </c:when>
                                            <c:otherwise>
			 审核未通过
			        	                   </c:otherwise>
                                        </c:choose>
                                    </span>
            </td>
        </tr>
        <tr>
            <td class="td-title">创建人：</td>
            <td class="td-input" >
                <span>${course.createUser}</span>
            </td>
        </tr>
                <tr>
            <td class="td-title">师资简介：</td>
            <td class="td-input" >
                <span>${course.teacherIntro}</span>
            </td>
        </tr>
        <tr>
            <td class="td-title">课程描述：</td>
            <td class="td-input" >
                <span>${course.courseDescription}
                </span>
            </td>
        </tr>
        <tr class="submit-btn">
            <td></td>
            <td class="td-btn">
                <input type="button" class="btn-publish" value="返回" onclick="javascript :history.back(-1);"/>
            </td>
        </tr>
        </tbody>
    </table>
</div>
</body>
</html>
