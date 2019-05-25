<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<head>

  <title>文化云</title>
  <!-- 导入头部文件 start -->
  <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
  <%@include file="/WEB-INF/why/common/limit.jsp"%>
  <script type="text/javascript" src="${path}/STATIC/js/Statistics/Statistics.js"></script>
  <style type="text/css"></style>
  <script type="text/javascript">
    $(function(){
      getPage();
      selectModel();
    });
    // 分页
    function getPage(){
      kkpager.generPageHtml({
        pno : '${page.page}',
        total : '${page.countPage}',
        totalRecords :  '${page.total}',
        mode : 'click',//默认值是link，可选link或者click
        click : function(n){
          this.selectPage(n);
          $("#page").val(n);
          formSub('#comment');
          return false;
        }
      });
    }
    function formSub(formName){
      $(formName).submit();
    }
  </script>
  <style type="text/css">
    .main-content table{ border: dashed 1px #CCCCCC;}
    .main-content table th{ height: 60px; line-height: 60px; background-color: #ECF0F2; color: #596988;}
  </style>
</head>
<body>
<form action="" id="comment" method="post">
  <div class="main-content">
    <table width="100%">
      <thead>
      <tr>
        <th width="50">ID</th>
        <th style="text-align: left;">评论内容</th>
        <th width="100">评论人</th>
        <th width="110">评论时间</th>
      </tr>
      </thead>
      <c:if test="${fn:length(list) gt 0}">
        <tbody>
        <%int i=0;%>
        <c:forEach items="${list}" var="comment">
          <%i++;%>
          <tr>
            <td><%=i%></td>
            <td title="<c:out escapeXml="true" value="${comment.commentRemark}"/>" style="text-align: left; word-break: break-all; word-wrap: break-word; padding: 8px 0;">
              <c:out escapeXml="true" value="${comment.commentRemark}"/>
            </td>
            <td>
              <c:if test="${not empty comment.commentUserNickName}">
                ${comment.commentUserNickName}
              </c:if>
            </td>
            <td>
              <c:if test="${not empty comment.commentTime}">
                <fmt:formatDate value="${comment.commentTime}"  pattern="yyyy-MM-dd HH:mm" />
              </c:if>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </c:if>
      <c:if test="${empty list}">
        <tr>
          <td colspan="7"> <h4 style="color:#DC590C">暂无数据!</h4></td>
        </tr>
      </c:if>
    </table>
    <c:if test="${not empty list}">
      <input type="hidden" id="page" name="page" value="${page.page}" />
      <div id="kkpager"></div>
    </c:if>
  </div>
</form>
</body>
</html>