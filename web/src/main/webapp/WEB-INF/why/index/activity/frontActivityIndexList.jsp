<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java"  pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>活动首页--文化云</title>
  <!-- 导入头部文件 start -->
  <%@include file="/WEB-INF/why/common/frontPageFrame.jsp"%>

</head>
<body>
<form action="${path}/frontActivity/frontActivityIndex.do" method="get" id="activityForm">
        <div class="week" id="activityList">
          <div class="in-tit red">活动列表</div>
          <ul class="week-activities">
            <c:forEach items="${activityList}" var="activity">

              <li activity-icon-url="${activity.activityIconUrl}">
                <a href="${path}/frontActivity/frontActivityDetail.do?activityId=${activity.activityId}">
                  <img onload="fixImage(this, 220, 220)"/>
                </a>
                <div class="info">
                  <h4>
                    <a href="${path}/frontActivity/frontActivityDetail.do?activityId=${activity.activityId}" >
                      <c:out escapeXml="true" value="${activity.activityName}"/>
                    </a>
                  </h4>
                  <p>地址：
                  		<c:set var="activityAddress" value="${activity.activityAddress}"/>
		                <c:out value="${fn:substring(activityAddress,0,10)}" escapeXml="true"/>
		                <c:if test="${fn:length(activityAddress) > 10}">...</c:if>
                  </p>
                  <p>时间：${activity.activityStartTime}</p>
                  <p>热度：<span class="red">${activity.yearBrowseCount}</span></p>
                </div>
              </li>
           </c:forEach>
          </ul>
          <div class="page">
            <input type="hidden" id="page" name="page" value="" />
            <c:if test="${fn:length(activityList) gt 0}">
              <a  href="javascript:void(0);" onclick="pageSubmit(-1)" class="prev-page" ></a>
              <a href="javascript:void(0);" onclick="pageSubmit(1)" class="next-page"></a>
              <script type="text/javascript">
                var pageSize = ${page.countPage};
                function pageSubmit(page){
                  if(page <= pageSize){
                    $("#page").val(page);
                    formSub("#activityForm");
                  }else{
                    //alert("跳转页数不能超过总页数");
                  }
                }
              </script>
              <script type="text/javascript">
                //提交表单
                function formSub(formName){
                  $(formName).submit();
                }
              </script>
            </c:if>
          </div>
        </div>


</form>
</body>
</html>