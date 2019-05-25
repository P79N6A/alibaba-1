<%@ page language="java"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>

<head>
  <title>文化云</title>
  <!-- 导入头部文件 start -->
  <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
  <script type="text/javascript" src="${path}/STATIC/js/jquery.epiclock.js"></script>
  <script type="text/javascript" src="${path}/STATIC/js/highcharts/highcharts.js"></script>
  <script type="text/javascript" src="${path}/STATIC/js/highcharts/exporting.js"></script>
  <script type="text/javascript" src="${path}/STATIC/js/Statistics/Statistics.js"></script>
  <script type="text/javascript">
    $(function(){

    });


    function exportExcel() {
      location.href = "${path}/activityStatistics/exportActivityByMessageExcel.do?" + $("#comment").serialize();
    }
    // 分页
    $(function(){
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
    });

    //提交表单
    function formSub(formName){
      $(formName).submit();
    }

  </script>
</head>
<body>
<form id="comment" action="" method="post">
<div class="site">
  <em>您现在所在的位置：</em>数据管理 &gt; 活动数据统计 &gt; 活动评论报表
</div>
<div class="site-title">活动信息数据</div>
<div class="data-content">
  <div class="table-tit">
    <h1>活动评论报表</h1>
    <div class="form-table">
      <a class="export" onclick="exportExcel();">导出</a>
      <input class="export" type="button" value="确定" onclick="$('#page').val(1);formSub('#comment');"/>
      <div class="td-time" style="margin-top: 0px;">
        <div class="start w240" style="margin-left: 8px;">
          <span class="text">开始日期</span>
          <input type="hidden" id="startDateHidden"/>
          <input type="text" id="activityStartTime" name="activityStartTime" value="${activityStatistics.activityStartTime}" readonly/>
          <i class="data-btn start-btn"></i>
        </div>
        <span class="txt" style="line-height: 42px;">至</span>
        <div class="end w240">
          <span class="text">结束日期</span>
          <input type="hidden" id="endDateHidden"/>
          <input type="text" id="activityEndTime" name="activityEndTime" value="${activityStatistics.activityEndTime}" readonly/>
          <i class="data-btn end-btn"></i>
        </div>
      </div>
    </div>
  </div>

  <div>&nbsp;&nbsp;&nbsp;&nbsp;
    <c:if test="${not empty activityStatistics.activityStartTime}">
  ${activityStatistics.activityStartTime}——${activityStatistics.activityEndTime}内，
    </c:if>
    <c:if test="${empty list[0].commentCount}">
    新增评论数量为<a style="color: #CC0000">0</a> 条
    </c:if>
    <c:if test="${not empty list[0].commentCount}">
    新增评论数量为<a style="color: #CC0000">${list[0].commentCount}</a> 条
    </c:if>
  </div>
  <div class="in-container">
    <div id="totalStatistic"></div>
  </div>
  <div class="table-cont"  >
    <table width="100%" class="tab-data" id="Area_Info">
      <thead id="thead1" class="tab-data">
      <tr>
        <td width="80%">活动名称</td>
        <td width="20%">评论数量</td>
      </tr>
      <c:if test="${empty list}">
        <tr>
          <td colspan="8"> <h4 style="color:#DC590C">暂无数据!</h4></td>
        </tr>
      </c:if>
      <tbody>
      <c:forEach items="${list}" var="c" varStatus="s">
      <tr>
        <td width="80%"><a target="_blank" href="${path}/frontActivity/frontActivityDetail.do?activityId=${c.activityId}" style="float: left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${c.activityName}</a></td>
        <td width="20%" ><a style="color: #0066cc" href="${path}/activityStatistics/activityMessage.do?activityId=${c.activityId}" target="Frame2">${c.numMessage}</a></td>
      </tr>
      </c:forEach>
      </tbody>
    </table>
    <c:if test="${not empty list}">
      <input type="hidden" id="page" name="page" value="${page.page}" />
      <div id="kkpager"></div>
    </c:if>
  </div>
</div>
</thead>
</form>
<IFRAME ID="Frame2" name="Frame2"SRC="${path}/activityStatistics/activityMessage.do;" allowTransparency="true" STYLE="background-color: whitesmoke" width="100%" height="125%" scrolling="no" frameborder="0"> </IFRAME>
</body>
</html>