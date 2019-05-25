<%@ page import="java.util.Date" %>
<%@ page language="java"  pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <title>用户订单列表--文化云</title>
  <%@include file="/WEB-INF/why/common/pageFrame.jsp"%>
  <%@include file="/WEB-INF/why/common/limit.jsp"%>
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
  <script type="text/javascript" src="${path}/STATIC/js/dialog-min.js"></script>
  <!--文本编辑框 end-->
  <!-- dialog start -->
  <link rel="stylesheet" type="text/css" href="${path}/STATIC/css/dialog-back.css"/>
  <script type="text/javascript" src="${path}/STATIC/js/dialogBack/lib/sea.js"></script>
  <script type="text/javascript" src="${path}/STATIC/js/ckeditor/sample.js"></script>
  <script type="text/javascript">
    //** 日期控件
    $(function(){
      $(".start-btn").on("click", function(){
        WdatePicker({el:'startDateHidden',dateFmt:'yyyy-MM-dd',doubleCalendar:true,minDate:'',maxDate:'#F{$dp.$D(\'endDateHidden\')}',
          oncleared:function() {
            $("#activityStartTime").val("");
          },position:{left:-224,top:8},isShowOK:true,isShowToday:false,onpicked:pickedStartFunc})
      })
      $(".end-btn").on("click", function(){
        WdatePicker({el:'endDateHidden',dateFmt:'yyyy-MM-dd',doubleCalendar:true,minDate:'#F{$dp.$D(\'startDateHidden\')}',oncleared:function() {
          $("#activityEndTime").val("");
        },position:{left:-224,top:8},isShowOK:true,isShowToday:false,onpicked:pickedendFunc})
      })
    });
    function pickedStartFunc(){
      $dp.$('activityStartTime').value=$dp.cal.getDateStr('yyyy-MM-dd');
    }
    function pickedendFunc(){
      $dp.$('activityEndTime').value=$dp.cal.getDateStr('yyyy-MM-dd');
    }

    //导出excel
    function exportOrderExcel() {
      var orderNumber=$('#orderNumber').val();
      if(orderNumber!=undefined && orderNumber=='输入订单号'){
        $('#orderNumber').val("");
      }
      location.href = "${path}/order/exportOrderExcel.do?" + $("#activityForm").serialize();
    }

    $(function(){
      seajs.use(['${path}/STATIC/js/dialogBack/src/dialog-plus'], function (dialog) {
        window.dialog = dialog;
      });
      $("input").focus();
      selectModel();
      page();//分页
    });

    window.console = window.console || {log:function () {}}
    function cancelUserOrder(activityOrderId) {
      /*var dialogWidth = ($(window).width() * 0.8);*/
      var dialogWidth = ($(window).width() < 800) ? ($(window).width() * 0.6) : 800;
      /* var dialogHeight = ($(window).height() < 600) ? ($(window).height() * 0.6) : 600;*/
      dialog({
        url: '${path}/order/preCancelUserOrder.do?activityOrderId=' + activityOrderId,
        title: '取消用户订单',
        width: 500,
        fixed: false,
        data: {
        }, // 给 iframe 的数据
        onclose: function () {
          if(this.returnValue){
            windows.reload();
          }
        }
      }).showModal();
      return false;
    }

    function page(){
      kkpager.generPageHtml({
        pno : '${page.page}',
        total : '${page.countPage}',
        totalRecords :  '${page.total}',
        mode : 'click',
        click : function(n){
          this.selectPage(n);
          $("#page").val(n);
          formSub('#activityForm');
          return false;
        }
      });
    }
    function formSub(formName){
      var searchKey = $("#searchKey").val();
      <%--var userId=${activity.userId};--%>
      if(searchKey == "请输入订单号\\手机号\\活动名称") {		//"\\"代表一个反斜线字符\
        $("#searchKey").val("");
      }
      $(formName).submit();
    }
    /**
     *  取消订单
     */
    function cancelOrder(id){

      dialogConfirm("取消订单", "您确定要取消该订单吗？", removeParent);
      function removeParent() {
        $.post("${path}/order/updateOrderByActivityOrderId.do", {activityOrderId:id},function (data) {
          if (data == 'success') {
            dialogAlert("提示","订单取消成功",function () {
              location.reload();
            });
          } else {
            dialogAlert("提示","订单取消失败:" + data);
          }
        });
      }
    }
    /**
     *  发送消息
     */
    function sendMessger(id){
      dialogConfirm("发送短消息", "您确定发送短消息吗？", removeParent);
      function removeParent() {
        $.post("${path}/order/sendSmsMessage.do",{'activityOrderId':id},function(data){
          if(data == "success"){
            dialogAlert("提示","短信发送成功!");
            //$("#activityForm").submit();
          } else {
            dialogAlert("提示","短信发送失败!");
          }
        });
      }
    }
  </script>
</head>
<body>
<form id="activityForm" action="${path}/order/queryAllTerminalUserOrderIndex.do?userId=${activity.userId}" method="post">

  <div class="site">
    <em>您现在所在的位置：</em>会员管理&gt;用户管理&gt;用户列表 &gt;用户订单
  </div>
  <div class="search">
    <div class="search-box">
      <i></i><input id="searchKey" name="searchKey" class="input-text" data-val="请输入订单号\手机号\活动名称" type="text"
                    value="<c:choose><c:when test="${not empty searchKey}">${searchKey}</c:when><c:otherwise>请输入订单号\手机号\活动名称</c:otherwise></c:choose>"/>
    </div>
    <%----%>
    <%--<div class="select-box w135">--%>
      <%--<input type="hidden" value="${activity.orderPayStatus}" name="orderPayStatus" id="orderPayStatus"/>--%>
      <%--<div class="select-text" data-value="">--%>
        <%--<c:choose>--%>
          <%--<c:when test="${activity.orderPayStatus==1}">--%>
            <%--未出票--%>
          <%--</c:when>--%>
          <%--<c:when test="${activity.orderPayStatus==2}">--%>
            <%--已取消--%>
          <%--</c:when>--%>
          <%--<c:when test="${activity.orderPayStatus==3}">--%>
            <%--已出票--%>
          <%--</c:when>--%>
          <%--<c:when test="${activity.orderPayStatus==4}">--%>
            <%--已验票--%>
          <%--</c:when>--%>
          <%--<c:when test="${activity.orderPayStatus ==5}">--%>
            <%--已失效--%>
          <%--</c:when>--%>
          <%--<c:otherwise>--%>
            <%--订单状态--%>
          <%--</c:otherwise>--%>
        <%--</c:choose>--%>
      <%--</div>--%>
      <%--<ul class="select-option">--%>
        <%--<li data-option=""  >订单状态</li>--%>
        <%--<li data-option="1"  >未出票</li>--%>
        <%--<li data-option="2"  >已取消</li>--%>
        <%--<li data-option="3"  >已出票</li>--%>
        <%--<li data-option="4"  >已验票</li>--%>
        <%--<li data-option="5"  >已失效</li>--%>
      <%--</ul>--%>
    <%--</div>--%>

    <%--<div class="select-box w135">--%>
      <%--<input type="hidden" value="${activity.activitySalesOnline}" name="activitySalesOnline" id="activitySalesOnline"/>--%>
      <%--<div class="select-text" data-value="">--%>
        <%--<c:choose>--%>
          <%--<c:when test="${activity.activitySalesOnline == 'Y'}">--%>
            <%--在线选座--%>
          <%--</c:when>--%>
          <%--<c:when test="${activity.activitySalesOnline == 'N'}">--%>
            <%--自由入座--%>
          <%--</c:when>--%>
          <%--<c:otherwise>--%>
            <%--选座方式--%>
          <%--</c:otherwise>--%>
        <%--</c:choose>--%>
      <%--</div>--%>
      <%--<ul class="select-option">--%>
        <%--<li data-option="">选座方式</li>--%>
        <%--<li data-option="Y">在线选座</li>--%>
        <%--<li data-option="N">自由入座</li>--%>
      <%--</ul>--%>
    <%--</div>--%>
    <div class="form-table" style="float: left;">
      <div class="td-time" style="margin-top: 0px;">
        <div class="start w240" style="margin-left: 8px;">
          <span class="text">开始日期</span>
          <input type="hidden" id="startDateHidden"/>
          <input type="text" id="activityStartTime" name="activityStartTime" value="${activity.activityStartTime}" readonly/>
          <i class="data-btn start-btn"></i>
        </div>
        <span class="txt" style="line-height: 42px;">至</span>
        <div class="end w240">
          <span class="text">结束日期</span>
          <input type="hidden" id="endDateHidden"/>
          <input type="text" id="activityEndTime" name="activityEndTime" value="${activity.activityEndTime}" readonly/>
          <i class="data-btn end-btn"></i>
        </div>
      </div>
    </div>
    <div class="select-btn">
      <input type="button" onclick="$('#page').val(1);formSub('#activityForm');" value="搜索"/>
    </div>
    <%--<div class="search-total">--%>
      <%--<div class="select-btn">--%>
        <%--<input type="button" onclick="exportOrderExcel();" value="导出"/>--%>
      <%--</div>--%>
    <%--</div>--%>
  </div>
  <div class="main-content">
    <table width="100%">
      <thead>
      <tr>
        <th >订单号</th>
        <th class="title">活动名称</th>
        <th >预订手机号</th>
        <%--<th>所属区县</th>--%>
        <%--<th class="venue">所属场馆</th>--%>
        <%--<th>票数</th>--%>
        <%--<th>类型</th>--%>
        <%--<th>日期</th>--%>
        <%--<th>场次</th>--%>
        <%--<th >预订人</th>--%>
        <th>订单时间</th>
        <th>订单状态</th>
        <th>管理</th>
      </tr>
      </thead>

      <tbody>
      <%int i=0;%>
      <c:forEach items="${activityList}" var="avct">
        <%i++;%>
        <tr>
          <td >${avct.orderNumber}</td>
          <td class="title">
            <c:if test="${not empty avct.activityName}">
              <c:set var="activityName" value="${avct.activityName}"/>
              <c:out value="${fn:substring(activityName,0,19)}"/>
              <c:if test="${fn:length(activityName) > 19}">...</c:if>
            </c:if>
          </td>
          <td>
              ${avct.orderPhoneNo}
          </td>
          <%--<td>--%>
            <%--<c:if test="${not empty avct.activityArea}">--%>
              <%--${fn:split(avct.activityArea,",")[1]}--%>
            <%--</c:if>--%>
            <%--<c:if test="${empty avct.activityArea}">--%>
              <%--未知--%>
            <%--</c:if>--%>
          <%--</td>--%>

          <%--<td class="venue">--%>
            <%--<c:choose>--%>
              <%--<c:when test="${avct.createActivityCode == 1}">市级自建</c:when>--%>
              <%--<c:when test="${avct.createActivityCode == 2}">区级自建</c:when>--%>
              <%--<c:otherwise>--%>
                <%--<c:if test="${not empty avct.venueName}">--%>
                  <%--<c:out escapeXml="true" value="${avct.venueName}"/>--%>
                <%--</c:if>--%>
                <%--<c:if test="${ empty avct.venueName}">--%>
                  <%--未知场馆--%>
                <%--</c:if>--%>
              <%--</c:otherwise>--%>
            <%--</c:choose>--%>
          <%--</td>--%>
          <%--<td>--%>
            <%--<c:if test="${not empty avct.orderVotes}">--%>
              <%--${avct.orderVotes}--%>
            <%--</c:if>--%>
            <%--<c:if test="${empty avct.orderVotes}">--%>
              <%--未知--%>
            <%--</c:if>--%>
          <%--</td>--%>
          <%--<td>--%>
            <%--<c:if test="${not empty avct.activitySalesOnline}">--%>
              <%--<c:if test="${avct.activitySalesOnline=='Y'}">--%>
                <%--在线选座--%>
              <%--</c:if>--%>
              <%--<c:if test="${avct.activitySalesOnline=='N'}">--%>
                <%--自由选座--%>
              <%--</c:if>--%>
            <%--</c:if>--%>
            <%--<c:if test="${empty avct.activitySalesOnline}">--%>
              <%--未知--%>
            <%--</c:if>--%>
          <%--</td>--%>
          <!-- 新增日期和场次  start  -->
          <%--<td>${avct.eventDate}</td>--%>
          <%--<td>${avct.eventTime}</td>--%>
          <!-- 新增日期和场次  end  -->
          <%--<td >--%>
            <%--<c:if test="${not empty avct.orderName}">--%>
              <%--${avct.orderName}--%>
            <%--</c:if>--%>
            <%--<c:if test="${ empty avct.orderName}">--%>
              <%--未知预订人--%>
            <%--</c:if>--%>
          <%--</td>--%>
          <td >
            <c:if test="${not empty avct.orderCreateTime}">
              <fmt:formatDate value="${avct.orderCreateTime}" pattern="yyyy-MM-dd HH:mm" />
            </c:if>
          </td>
          <td >
            <c:if test="${not empty avct.orderPayStatus}">
              <c:if test="${avct.orderPayStatus ==1}">
                未出票
              </c:if>
              <c:if test="${avct.orderPayStatus ==2}">
                已取消
              </c:if>
              <c:if test="${avct.orderPayStatus ==3}">
                已出票
              </c:if>
              <c:if test="${avct.orderPayStatus ==4}">
                已验票
              </c:if>
              <c:if test="${avct.orderPayStatus ==5}">
                已失效
              </c:if>
            </c:if>
          </td>
          <td>
            <%if(activityOrderDetailButton){%>
            <a  href="${path}/order/viewOrderDetail.do?activityOrderId=${avct.activityOrderId}">查看</a>
            <%}%>
            <c:if test="${avct.orderPayStatus ==1}">
              <%if(activityOrderCancelButton){%>
              <%if(activityOrderDetailButton){%> | <%}%>
              <c:if test="${avct.activitySalesOnline == 'Y'}" >
                <a  href="javascript:cancelUserOrder('${avct.activityOrderId}')">取消</a>
              </c:if>
              <c:if test="${avct.activitySalesOnline == 'N'}" >
                <a  href="javascript:cancelOrder('${avct.activityOrderId}')">取消</a>
              </c:if>
              <%}%>
              <%if(activityOrderSendSmsButton){%>
              <%if(activityOrderSendSmsButton){%> | <%}%><a target="_blank" onclick="sendMessger('${avct.activityOrderId}')">发消息</a>
              <%}%>
            </c:if>
          </td>
        </tr>
      </c:forEach>
      <c:if test="${empty activityList}">
        <tr>
          <td colspan="12"><h4 style="color:#DC590C">暂无数据!</h4></td>
        </tr>
      </c:if>
      </tbody>
    </table>
    <c:if test="${not empty activityList}">
      <input type="hidden" id="page" name="page" value="${page.page}" />
      <div id="kkpager" ></div>
    </c:if>
  </div>
</form>
</body>
</html>