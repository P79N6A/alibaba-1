<%@ page language="java" pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%
    String path = request.getContextPath();
    request.setAttribute("path", path);
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
    request.setAttribute("basePath", basePath);
%>
<!DOCTYPE html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title>等待确认</title>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/train/css/reset-index.css"/>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/train/css/culture.css"/>
<link rel="stylesheet" type="text/css" href="${path}/STATIC/train/css/trains.css"/>
<script type="text/javascript" src="${path}/STATIC/train/js/jquery.min.js"></script>
<script type="text/javascript" src="${path}/STATIC/train/js/train_index.js"></script>
</head>
<body>
<%@include file="../index/index_top.jsp"%>
    <!--con start-->
    <div id="register-content">
    <div class="register-content">
        <div class="steps steps-room">
            <ul class="clearfix">
                <li class="step_1 visited_pre">1.填写个人信息<i class="tab_status"></i></li>
                <li class="step_2 finish">2.选择课程<i class="tab_status"></i></li>
               <!--  <li class="step_3 active">3.等待确认<i class="tab_status"></i></li> -->
                <li class="step_4 end">3.等待确认</li>
            </ul>
        </div>
        <form action="Room_book_order.html">
        <div class="room-part1 room-part2">
            <div class="trians_block trians_block_order clearfix">
              <div class="trains_title_left fl">
                 报名项目
              </div>
              <div class="train_sel_con fl">
                  <table class="trains_select" width="100%" style="margin-top: 0;">
                    <tbody>
                    <c:forEach items="${courses}" var="course" varStatus="i">
                     <tr>
                        <td <c:if test="${i.index==0}">width="26"</c:if> >
                           <div class="train_check on"><input type="radio" id="check1"  readonly="readonly" checked="checked" name="radio"/></div>
                        </td>
                        <td>
                          <span class="topic">${course.courseTitle}</span>
                        </td>
                    </tr>
                    </c:forEach>
                   </tbody>
                  </table>
                </div>
            </div>
            <div class="train_text">您的报名已成功，请等待最终确认！</div>
        </div>
        </form>
    </div>
</div>
<%@include file="../index/index_foot.jsp"%>
<script>
//执行下拉列表
selectModel();
</script>
</body>
</html>
